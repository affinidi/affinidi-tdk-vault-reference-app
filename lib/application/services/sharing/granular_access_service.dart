import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import '../../../application/services/vault/vault_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
  ///
  /// This method:
  /// 1. Gets the current user's DID from their profile
  /// 2. Iterates through all profiles in the vault
  /// 3. For each profile, checks if any items are shared with the current user
  /// 4. Returns a list of GranularAccessItem objects
  Future<List<GranularAccessItem>> discoverSharedFiles({
    required String currentProfileId,
  }) async {
    try {
      final vaultService = ref.read(vaultServiceProvider);
      final vault = vaultService.currentVault;
      if (vault == null) {
        return [];
      }

      // Get current profile's DID
      final profiles = await vault.listProfiles();
      final currentProfile = profiles.firstWhere(
        (p) => p.id == currentProfileId,
        orElse: () => throw Exception('Current profile not found'),
      );
      final currentUserDid = currentProfile.did;

      final sharedItems = <GranularAccessItem>[];

      // Check all profiles to see if any have shared items with current user
      for (final profile in profiles) {
        try {
          final vaultServiceNotifier = ref.read(vaultServiceProvider.notifier);
          final permissions = await vaultServiceNotifier.getItemAccess(
            profileId: profile.id,
            granteeDid: currentUserDid,
          );

          for (final permission in permissions) {
            // Filter out expired permissions
            if (permission.expiresAt != null) {
              final now = DateTime.now().toUtc();
              final expiresAt = permission.expiresAt!.toUtc();
              if (expiresAt.isBefore(now)) {
                // Skip expired permissions - backend should have revoked these, but filter client-side as well
                continue;
              }
            }

            for (final nodeId in permission.itemIds) {
              try {
                // Try to get node info from owner's file storage
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
              } catch (e) {
                // Skip if we can't get node info
                continue;
              }
            }
          }
        } catch (e) {
          // Skip if we can't get access for this profile
          continue;
        }
      }

      return sharedItems;
    } catch (e) {
      // Return empty list if discovery fails - don't break the app
      return [];
    }
  }

  /// Gets node information (name, type) from the owner's file storage
  Future<Map<String, dynamic>?> _getNodeInfo({
    required Vault vault,
    required String profileId,
    required String nodeId,
  }) async {
    try {
      final profiles = await vault.listProfiles();
      final profile = profiles.firstWhere((p) => p.id == profileId);
      final fileStorage = profile.defaultFileStorage;
      if (fileStorage == null) return null;

      // Try to find the node by searching through folders
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
    } catch (e) {
      // If we can't find the node, return null
      return null;
    }
    return null;
  }

  /// Recursively searches for a node in the file storage
  Future<Item?> _searchForNode({
    required FileStorage fileStorage,
    required String profileId,
    required String nodeId,
  }) async {
    try {
      // Search in root folder
      final rootFolder = await fileStorage.getFolder(folderId: profileId);
      for (final item in rootFolder.items) {
        if (item.id == nodeId) {
          return item;
        }
        // If it's a folder, search recursively
        if (item is Folder) {
          final found = await _searchForNode(
            fileStorage: fileStorage,
            profileId: item.id,
            nodeId: nodeId,
          );
          if (found != null) return found;
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
