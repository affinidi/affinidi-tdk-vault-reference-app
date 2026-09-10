import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../widgets/passphrase_text_field.dart';
import 'backup_vault_page_controller.dart';
import 'backup_vault_page_state.dart';

/// Lets the user export the current vault as an encrypted `.json` backup file.
class BackupVaultPage extends HookConsumerWidget {
  const BackupVaultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final passphraseController = useTextEditingController();
    final state = ref.watch(backupVaultPageControllerProvider);
    final controller = ref.read(backupVaultPageControllerProvider.notifier);

    String? errorText() => switch (state.error) {
          BackupVaultError.noOpenVault => localizations.backupVaultNoOpenVault,
          BackupVaultError.detailsUnavailable =>
            localizations.backupVaultDetailsUnavailable,
          BackupVaultError.incorrectPassphrase =>
            localizations.backupVaultIncorrectPassphrase,
          BackupVaultError.failed => localizations.backupVaultFailed,
          null => null,
        };

    Future<void> backUp() async {
      final backup = await controller.createBackup(passphraseController.text);
      if (backup == null || !context.mounted) return;

      try {
        final savedPath = await FilePicker.platform.saveFile(
          dialogTitle: localizations.saveVaultBackup,
          fileName: backup.fileName,
          bytes: backup.bytes,
        );

        if (savedPath != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(localizations.backupSaved)),
          );
          Navigator.of(context).pop();
        }
      } catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.backupVaultFailed)),
        );
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
                errorText: errorText(),
                onChanged: (_) => controller.clearError(),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: state.isProcessing ? null : backUp,
                child: state.isProcessing
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
