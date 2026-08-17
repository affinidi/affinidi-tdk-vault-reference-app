import 'dart:convert';

import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../application/services/vault/vault_service.dart';
import '../../../navigation/flows/vaults/vaults_route_constants.dart';
import '../../widgets/passphrase_text_field.dart';

/// Restores a vault from a previously exported `.json` backup file.
class RestoreVaultPage extends HookConsumerWidget {
  const RestoreVaultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passphraseController = useTextEditingController();
    final vaultNameController =
        useTextEditingController(text: 'Restored vault');
    final backupData = useState<BackupData?>(null);
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
        backupData.value = BackupData.fromJson(json);
        pickedFileName.value = result!.files.single.name;
        final name = json['vaultName'];
        if (name is String && name.isNotEmpty) {
          vaultNameController.text = name;
        }
        errorText.value = null;
      } catch (_) {
        errorText.value = 'The selected file is not a valid backup.';
      }
    }

    Future<void> restore() async {
      final data = backupData.value;
      if (data == null) return;
      errorText.value = null;
      isProcessing.value = true;
      try {
        final vaultId =
            await ref.read(vaultServiceProvider.notifier).restoreFromBackupData(
                  backupData: data,
                  passphrase: passphraseController.text,
                  vaultName: vaultNameController.text.trim().isEmpty
                      ? 'Restored vault'
                      : vaultNameController.text.trim(),
                );
        restoredVaultId.value = vaultId;
      } catch (_) {
        errorText.value =
            'Restore failed. The passphrase may be incorrect or the backup is '
            'invalid.';
      } finally {
        if (context.mounted) isProcessing.value = false;
      }
    }

    Widget body;
    if (restoredVaultId.value != null) {
      body = _SuccessView(
        onOpen: () => context.go(
          VaultsRoutePath.openVaultWithId(restoredVaultId.value!),
        ),
      );
    } else if (backupData.value == null) {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Pick a vault backup (.json) file to restore.'),
          if (errorText.value != null) ...[
            const SizedBox(height: 12),
            Text(
              errorText.value!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: pickFile,
            child: const Text('Choose backup file'),
          ),
        ],
      );
    } else {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Selected file: ${pickedFileName.value}'),
          const SizedBox(height: 24),
          TextField(
            controller: vaultNameController,
            decoration: const InputDecoration(labelText: 'Vault name'),
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
                : const Text('Restore vault'),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Restore vault from backup')),
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
        const Text(
          'Your vault was restored successfully.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: onOpen,
          child: const Text('Open restored vault'),
        ),
      ],
    );
  }
}
