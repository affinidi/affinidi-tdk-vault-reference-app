import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../infrastructure/exceptions/app_exception.dart';
import '../../../l10n/app_localizations.dart';
import '../../../application/services/vault/vault_service.dart';
import '../../../navigation/flows/app_routes.dart';
import '../../widgets/passphrase_text_field.dart';
import '../vaults_page/vaults_page_controller.dart';

/// Restores a vault from a previously exported `.json` backup file.
class RestoreVaultPage extends HookConsumerWidget {
  const RestoreVaultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final passphraseController = useTextEditingController();
    final vaultNameController =
        useTextEditingController(text: 'Restored vault');
    final backupBytes = useState<Uint8List?>(null);
    final pickedFileName = useState<String?>(null);
    final restoredVaultId = useState<String?>(null);
    final isProcessing = useState(false);
    final errorText = useState<String?>(null);

    Future<void> pickFile() async {
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Select a backup file',
        type: FileType.custom,
        allowedExtensions: const ['json'],
        withData: true,
      );
      final bytes = result?.files.single.bytes;
      if (bytes == null) return;
      try {
        final json = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
        if (json['encryptedBackup'] is! String || json['salt'] is! String) {
          throw const FormatException('Not a recognised backup file.');
        }
        backupBytes.value = bytes;
        pickedFileName.value = result!.files.single.name;
        final name = json['vaultName'];
        if (name is String && name.isNotEmpty) {
          vaultNameController.text = name;
        }
        errorText.value = null;
      } catch (_) {
        errorText.value = localizations.restoreVaultInvalidFile;
      }
    }

    Future<void> restore() async {
      final data = backupBytes.value;
      if (data == null) return;
      errorText.value = null;
      isProcessing.value = true;
      final passphraseBytes = Uint8List.fromList(
        utf8.encode(passphraseController.text),
      );
      try {
        final vaultId =
            await ref.read(vaultServiceProvider.notifier).restoreFromBackupData(
                  backupData: ByteData.sublistView(data),
                  passphrase: passphraseBytes,
                  vaultName: vaultNameController.text.trim().isEmpty
                      ? 'Restored vault'
                      : vaultNameController.text.trim(),
                );
        // Add the restored vault to the list so it shows without a restart.
        final vault = ref.read(vaultServiceProvider).currentVault;
        if (vault != null) {
          ref
              .read(vaultsPageControllerProvider.notifier)
              .addVault(vaultId, vault);
        }
        restoredVaultId.value = vaultId;
      } catch (error) {
        errorText.value = error is AppException &&
                error.type == AppExceptionType.vaultAlreadyExists
            ? localizations.restoreVaultAlreadyExists
            : localizations.restoreVaultFailed;
      } finally {
        passphraseBytes.fillRange(0, passphraseBytes.length, 0);
        if (context.mounted) isProcessing.value = false;
      }
    }

    Widget body;
    if (restoredVaultId.value != null) {
      body = _SuccessView(
        onOpen: () => context.go(ProfilesRoutePath.base),
      );
    } else if (backupBytes.value == null) {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(localizations.restoreVaultFileInstruction),
          if (errorText.value != null) ...[
            const SizedBox(height: 12),
            Text(
              errorText.value!,
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
          Text(
            localizations.selectedBackupFile(pickedFileName.value ?? ''),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: vaultNameController,
            decoration:
                InputDecoration(labelText: localizations.vaultNameLabel),
          ),
          const SizedBox(height: 16),
          PassphraseTextField(
            controller: passphraseController,
            errorText: errorText.value,
            onChanged: (_) => errorText.value = null,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: isProcessing.value ? null : restore,
            child: isProcessing.value
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
