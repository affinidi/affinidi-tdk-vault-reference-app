import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/claimed_credential_small_widget.dart';
import '../../claimed_credential_details_page/claimed_credential_details_page.dart';
import '../claim_credentials_page_controller.dart';

class VerifiableCredential extends ConsumerWidget {
  const VerifiableCredential({
    super.key,
    required this.offerUri,
    required this.profileId,
  });

  final Uri offerUri;
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider =
        claimCredentialsPageControllerProvider(profileId: profileId);
    final verifiableCredential =
        ref.watch(provider.select((state) => state.verifiableCredential));

    if (verifiableCredential == null) {
      return SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () => ClaimedCredentialDetailsPage.show(
        context: context,
        verifiableCredential: verifiableCredential,
      ),
      child: ClaimedCredentialSmallWidget(
          verifiableCredential: verifiableCredential),
    );
  }
}
