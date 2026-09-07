import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../application/services/vault/vault_service.dart';
import '../../../application/services/vaults_manager/vaults_manager_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/passphrase_text_field.dart';

/// Lets the user export the current vault as an encrypted `.json` backup file.
class BackupVaultPage extends HookConsumerWidget {
  const BackupVaultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final passphraseController = useTextEditingController();
    final isProcessing = useState(false);
    final errorText = useState<String?>(null);

    Future<void> backUp() async {
      final passphrase = passphraseController.text;
      final vaultId = ref.read(vaultServiceProvider).currentVaultId;
      if (vaultId == null) {
        errorText.value = localizations.backupVaultNoOpenVault;
        return;
      }
      final entry =
          ref.read(vaultsManagerServiceProvider).vaultRegistry[vaultId];
      final storedPassword = entry?.password;
      if (storedPassword == null) {
        errorText.value = localizations.backupVaultDetailsUnavailable;
        return;
      }

      if (passphrase != storedPassword) {
        errorText.value = localizations.backupVaultIncorrectPassphrase;
        return;
      }

      errorText.value = null;
      isProcessing.value = true;
      final passphraseBytes = Uint8List.fromList(utf8.encode(passphrase));
      try {
        final backupBytes = await ref
            .read(vaultServiceProvider.notifier)
            .createBackup(passphrase: passphraseBytes);

        // Store the vault name alongside the encrypted payload so restore can
        // show which vault it recreates.
        final rawJson = jsonDecode(
          utf8.decode(
            backupBytes.buffer.asUint8List(
              backupBytes.offsetInBytes,
              backupBytes.lengthInBytes,
            ),
          ),
        ) as Map<String, dynamic>;
        final fileContent = {
          ...rawJson,
          'vaultName': entry?.vaultName,
        };
        final bytes = Uint8List.fromList(
          utf8.encode(jsonEncode(fileContent)),
        );
        // Prefix with the vault name so the file says which vault it restores.
        final safeName = (entry?.vaultName ?? 'vault')
            .replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
        final savedPath = await FilePicker.platform.saveFile(
          dialogTitle: localizations.saveVaultBackup,
          fileName:
              '$safeName-vault-backup-${DateTime.now().millisecondsSinceEpoch}.json',
          bytes: bytes,
        );

        if (!context.mounted) return;
        if (savedPath != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(localizations.backupSaved)),
          );
          Navigator.of(context).pop();
        }
      } catch (_) {
        errorText.value = localizations.backupVaultFailed;
      } finally {
        passphraseBytes.fillRange(0, passphraseBytes.length, 0);
        if (context.mounted) isProcessing.value = false;
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(localizations.backUpVault)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(localizations.backupVaultDescription),
              const SizedBox(height: 24),
              PassphraseTextField(
                controller: passphraseController,
                errorText: errorText.value,
                onChanged: (_) => errorText.value = null,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: isProcessing.value ? null : backUp,
                child: isProcessing.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(localizations.backUpVault),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
