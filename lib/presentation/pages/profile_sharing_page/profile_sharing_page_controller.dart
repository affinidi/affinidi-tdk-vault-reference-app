import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../application/services/vault/vault_service.dart';
import '../../../application/services/vaults_manager/vaults_manager_service.dart';
import '../../../application/services/messaging/message_service.dart';
import 'profile_sharing_page_state.dart';

part 'profile_sharing_page_controller.g.dart';

@riverpod
class ProfileSharingController extends _$ProfileSharingController {
  final didController = TextEditingController();
  final sharedProfileJsonController = TextEditingController();

  @override
  ProfileSharingPageState build() {
    final initialState = const ProfileSharingPageState(
      profiles: [],
      selectedProfileId: null,
      isLoading: true,
    );

    Future.microtask(() => _loadProfiles());

    return initialState;
  }

  Future<void> _loadProfiles() async {
    try {
      final vaultServiceState = ref.read(vaultServiceProvider);
      final vault = vaultServiceState.currentVault;
      final profiles = await vault?.listProfiles() ?? [];

      state = state.copyWith(
        profiles: profiles,
        selectedProfileId: profiles.isNotEmpty ? profiles.first.id : null,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void selectProfile(String profileId) {
    state = state.copyWith(selectedProfileId: profileId);
  }

  Future<void> shareAndAutoAccept({
    required String receiverDid,
    required Permissions permissions,
    required void Function(ProfileSharingMessage message) onMessage,
  }) async {
    state = state.copyWith(isLoading: true);
    onMessage(ProfileSharingMessage.sharingProfile);
    try {
      final vaultService = ref.read(vaultServiceProvider.notifier);

      final sharedProfile = await vaultService.shareProfile(
        profileId: state.selectedProfileId!,
        toDid: receiverDid,
        permissions: permissions,
      );
      if (sharedProfile != null) {
        await Future.delayed(const Duration(seconds: 1));
        onMessage(ProfileSharingMessage.sharedProfileJsonGenerated);
        await Future.delayed(const Duration(seconds: 1));
        onMessage(ProfileSharingMessage.autoAccepting);
        final vaultsManager = ref.read(vaultsManagerServiceProvider);
        final vaultRegistry = vaultsManager.vaultRegistry;
        final originalVaultService = ref.read(vaultServiceProvider);
        final originalVaultId = originalVaultService.currentVaultId;
        final originalVaultEntry = vaultsManager.vaultRegistry[originalVaultId];
        final originalPassword = originalVaultEntry?.password;
        bool accepted = false;
        for (final entry in vaultRegistry.entries) {
          final vaultId = entry.key;
          await vaultService.open(
              vaultId: vaultId, password: entry.value.password);
          final vault = ref.read(vaultServiceProvider).currentVault;
          if (vault != null) {
            final profiles = await vault.listProfiles();
            for (final profile in profiles) {
              if (profile.did == receiverDid) {
                await vaultService.addSharedProfile(
                  profileId: profile.id,
                  sharedProfile: sharedProfile,
                );
                accepted = true;
                break;
              }
            }
          }
          if (accepted) break;
        }
        if (originalVaultId != null && originalPassword != null) {
          await vaultService.open(
            vaultId: originalVaultId,
            password: originalPassword,
          );
        }
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void dispose() {
    didController.dispose();
    sharedProfileJsonController.dispose();
  }
}
