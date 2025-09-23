import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../application/services/credential/credential_service.dart';
import '../../widgets/loading_status/async_loading_controller.dart';

part 'delete_credential_form_controller.g.dart';

@riverpod
class DeleteCredentialFormController extends _$DeleteCredentialFormController {
  DeleteCredentialFormController() : super();

  final loadingController = AsyncLoadingController.provider('deleteCredentialFormLoadingController');

  @override
  void build(DigitalCredential digitalCredential, {required String profileId}) {}

  Future<void> delete({required void Function() onSuccess}) async {
    await ref.read(loadingController.notifier).start(() async {
      await ref
          .read(credentialServiceProvider(profileId: profileId).notifier)
          .deleteCredential(credential: digitalCredential);
      onSuccess.call();
    });
  }
}
