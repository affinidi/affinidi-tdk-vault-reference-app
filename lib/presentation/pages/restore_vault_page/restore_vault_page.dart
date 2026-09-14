import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../navigation/flows/app_routes.dart';
import '../../widgets/passphrase_text_field.dart';
import '../vaults_page/vaults_page_controller.dart';
import 'restore_vault_page_controller.dart';
import 'restore_vault_page_state.dart';

/// Restores a vault from a previously exported `.json` backup file.
class RestoreVaultPage extends HookConsumerWidget {
  const RestoreVaultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final passphraseController = useTextEditingController();
    final state = ref.watch(restoreVaultPageControllerProvider);
    final controller = ref.read(restoreVaultPageControllerProvider.notifier);
    final vaultNameController = useTextEditingController(
      text: state.vaultName ?? localizations.restoredVaultDefaultName,
    );

    String? errorText() => switch (state.error) {
          RestoreVaultError.invalidFile =>
            localizations.restoreVaultInvalidFile,
          RestoreVaultError.alreadyExists =>
            localizations.restoreVaultAlreadyExists,
          RestoreVaultError.failed => localizations.restoreVaultFailed,
          null => null,
        };

    Future<void> pickFile() async {
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: localizations.selectBackupFile,
        type: FileType.custom,
        allowedExtensions: const ['json'],
        withData: true,
      );
      final bytes = result?.files.single.bytes;
      if (bytes == null) return;
      final vaultName = controller.selectBackup(
        bytes: bytes,
        fileName: result!.files.single.name,
        defaultVaultName: localizations.restoredVaultDefaultName,
      );
      if (vaultName != null) vaultNameController.text = vaultName;
    }

    Future<void> restore() async {
      await controller.restore(passphrase: passphraseController.text);
      if (ref.read(restoreVaultPageControllerProvider).restoredVaultId !=
          null) {
        ref.invalidate(vaultsPageControllerProvider);
      }
    }

    Widget body;
    if (state.restoredVaultId != null) {
      body = _SuccessView(
        onOpen: () => context.go(ProfilesRoutePath.base),
      );
    } else if (state.backupBytes == null) {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(localizations.restoreVaultFileInstruction),
          if (errorText() != null) ...[
            const SizedBox(height: 12),
            Text(
              errorText()!,
              softWrap: true,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: pickFile,
            child: Text(localizations.chooseBackupFile),
          ),
        ],
      );
    } else {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(localizations.selectedBackupFile(state.pickedFileName ?? '')),
          const SizedBox(height: 24),
          TextField(
            controller: vaultNameController,
            onChanged: controller.updateVaultName,
            decoration:
                InputDecoration(labelText: localizations.vaultNameLabel),
          ),
          const SizedBox(height: 16),
          PassphraseTextField(
            controller: passphraseController,
            errorText: errorText(),
            onChanged: (_) => controller.clearError(),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: state.isProcessing ? null : restore,
            child: state.isProcessing
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(localizations.restoreVaultAction),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(localizations.restoreVaultTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: body,
        ),
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.onOpen});

  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.check_circle_outline, size: 64),
        const SizedBox(height: 16),
        Text(
          AppLocalizations.of(context)!.restoreVaultSuccess,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: onOpen,
          child: Text(AppLocalizations.of(context)!.openRestoredVault),
        ),
      ],
    );
  }
}
