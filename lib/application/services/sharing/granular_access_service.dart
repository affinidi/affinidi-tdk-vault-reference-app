import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../application/services/vault/vault_service.dart';

part 'granular_access_service.g.dart';

/// Data class representing a file/folder shared via granular access
class GranularAccessItem {
  final String ownerProfileId;
  final String ownerProfileName;
  final String nodeId;
  final String nodeName;
  final bool isFolder;
  final List<String> rights;
  final DateTime? expiresAt;

  GranularAccessItem({
    required this.ownerProfileId,
    required this.ownerProfileName,
    required this.nodeId,
    required this.nodeName,
    required this.isFolder,
    required this.rights,
    this.expiresAt,
  });
}

@riverpod
GranularAccessService granularAccessService(Ref ref) {
  return GranularAccessService(ref);
}

class GranularAccessService {
  final Ref ref;

  GranularAccessService(this.ref);

  /// Discovers all files/folders shared with the current user via granular access
  Future<List<GranularAccessItem>> discoverSharedFiles({
    required String currentProfileId,
  }) async {
    try {
      final vaultService = ref.read(vaultServiceProvider);
      final vault = vaultService.currentVault;
      if (vault == null) {
        return [];
      }

      final profiles = await vault.listProfiles();
      final currentProfile = profiles.firstWhere(
        (p) => p.id == currentProfileId,
        orElse: () => throw Exception('Current profile not found'),
      );
      final currentUserDid = currentProfile.did;

      final sharedItems = <GranularAccessItem>[];

      for (final profile in profiles) {
        final vaultServiceNotifier = ref.read(vaultServiceProvider.notifier);
        final permissions = await vaultServiceNotifier.getItemAccess(
          profileId: profile.id,
          granteeDid: currentUserDid,
        );

        for (final permission in permissions) {
          if (permission.expiresAt != null) {
            final now = DateTime.now().toUtc();
            final expiresAt = permission.expiresAt!.toUtc();
            if (expiresAt.isBefore(now)) {
              continue;
            }
          }

          for (final nodeId in permission.itemIds) {
            try {
              final nodeInfo = await _getNodeInfo(
                vault: vault,
                profileId: profile.id,
                nodeId: nodeId,
              );

              if (nodeInfo != null) {
                sharedItems.add(GranularAccessItem(
                  ownerProfileId: profile.id,
                  ownerProfileName: profile.name,
                  nodeId: nodeId,
                  nodeName: nodeInfo['name'] as String,
                  isFolder: nodeInfo['isFolder'] as bool,
                  rights: permission.rights,
                  expiresAt: permission.expiresAt,
                ));
              }
            } catch (e, st) {
              debugPrint(
                  'granular_access: failed to resolve node $nodeId for profile ${profile.id}: $e');
              Error.throwWithStackTrace(e, st);
            }
          }
        }
      }

      return sharedItems;
    } catch (e, st) {
      Error.throwWithStackTrace(
        Exception('granular_access: discovery failed: $e'),
        st,
      );
    }
  }

  /// Gets node information (name, type) from the owner's file storage
  Future<Map<String, dynamic>?> _getNodeInfo({
    required Vault vault,
    required String profileId,
    required String nodeId,
  }) async {
    final profiles = await vault.listProfiles();
    final profile = profiles.firstWhere((p) => p.id == profileId);
    final fileStorage = profile.defaultFileStorage;
    if (fileStorage == null) return null;

    Item? foundItem = await _searchForNode(
      fileStorage: fileStorage,
      profileId: profileId,
      nodeId: nodeId,
    );

    if (foundItem != null) {
      return {
        'name': foundItem.name,
        'isFolder': foundItem is Folder,
      };
    }

    return null;
  }

  /// Recursively searches for a node in the file storage
  Future<Item?> _searchForNode({
    required FileStorage fileStorage,
    required String profileId,
    required String nodeId,
  }) async {
    final rootFolder = await fileStorage.getFolder(folderId: profileId);
    for (final item in rootFolder.items) {
      if (item.id == nodeId) {
        return item;
      }

      if (item is Folder) {
        final found = await _searchForNode(
          fileStorage: fileStorage,
          profileId: item.id,
          nodeId: nodeId,
        );
        if (found != null) return found;
      }
    }
    return null;
  }
}
