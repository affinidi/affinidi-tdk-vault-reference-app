import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../application/services/vault/vault_service.dart';
import '../../../application/services/vaults_manager/vaults_manager_service.dart';
import '../../widgets/passphrase_text_field.dart';

/// Lets the user export the current vault as an encrypted `.json` backup file.
class BackupVaultPage extends HookConsumerWidget {
  const BackupVaultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passphraseController = useTextEditingController();
    final isProcessing = useState(false);
    final errorText = useState<String?>(null);

    Future<void> backUp() async {
      final passphrase = passphraseController.text;
      final vaultId = ref.read(vaultServiceProvider).currentVaultId;
      final storedPassword = vaultId == null
          ? null
          : ref
              .read(vaultsManagerServiceProvider)
              .vaultRegistry[vaultId]
              ?.password;

      if (passphrase != storedPassword) {
        errorText.value = 'Incorrect passphrase for this vault.';
        return;
      }

      errorText.value = null;
      isProcessing.value = true;
      try {
        final backupData = await ref
            .read(vaultServiceProvider.notifier)
            .createBackup(passphrase: passphrase);

        final bytes = Uint8List.fromList(
          utf8.encode(jsonEncode(backupData.toJson())),
        );
        final savedPath = await FilePicker.platform.saveFile(
          dialogTitle: 'Save vault backup',
          fileName:
              'vault-backup-${DateTime.now().millisecondsSinceEpoch}.json',
          bytes: bytes,
        );

        if (!context.mounted) return;
        if (savedPath != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Backup saved.')),
          );
          Navigator.of(context).pop();
        }
      } catch (error) {
        errorText.value = 'Backup failed: $error';
      } finally {
        if (context.mounted) isProcessing.value = false;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Back up vault')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Enter your vault passphrase to export an encrypted backup '
                'file of your profiles, credentials, files and consent history.',
              ),
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
                    : const Text('Back up vault'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
