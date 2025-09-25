import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../navigation/navigation_provider.dart';
import '../../widgets/bottom_sheet_dialog.dart';
import '../../widgets/loading_status/modal_async_loading_status.dart';
import 'delete_credential_form_controller.dart';

class DeleteCredentialForm extends ConsumerWidget {
  const DeleteCredentialForm({
    required this.digitalCredential,
    required this.profileId,
    super.key,
  });

  final DigitalCredential digitalCredential;
  final String profileId;

  static void show({
    required BuildContext context,
    required DigitalCredential digitalCredential,
    required String profileId,
  }) =>
      showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: true,
        context: context,
        builder: (context) => DeleteCredentialForm(
          digitalCredential: digitalCredential,
          profileId: profileId,
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final provider = deleteCredentialFormControllerProvider(digitalCredential,
        profileId: profileId);
    final controller = ref.read(provider.notifier);
    final navigation = ref.read(navigationServiceProvider);

    void cancel() {
      if (!context.mounted) return;

      navigation.pop();
    }

    void delete() async {
      if (!context.mounted) return;

      await controller.delete(
        onSuccess: () {
          if (!context.mounted) return;
          navigation.pop();
        },
      );
    }

    return BottomSheetDialog(
      title: localizations.deleteCredentialTitle,
      actions: [
        TextButton(
          onPressed: cancel,
          child: Text(localizations.cancelActionText),
        ),
        FilledButton(
          onPressed: () => delete(),
          child: Text(localizations.deleteCredentialActionText),
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ModalAsyncLoadingStatus(
            loadingMessage: localizations.deleteCredentialLoadingMessage,
            controller.loadingController,
          ),
          Text(localizations.deleteCredentialDescription),
        ],
      ),
      onCancel: () => cancel(),
    );
  }
}
