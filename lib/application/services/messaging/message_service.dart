import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod/riverpod.dart';
import '../../../l10n/app_localizations.dart';

part 'message_service.g.dart';

enum ProfileSharingMessage {
  sharingProfile,
  sharedProfileJsonGenerated,
  autoAccepting,
}

@riverpod
MessageService messageService(Ref ref) {
  return MessageService();
}

class MessageService {
  String getLocalizedMessage(ProfileSharingMessage message, AppLocalizations localizations) {
    switch (message) {
      case ProfileSharingMessage.sharingProfile:
        return localizations.sharingProfileMessage;
      case ProfileSharingMessage.sharedProfileJsonGenerated:
        return localizations.sharedProfileJsonGeneratedMessage;
      case ProfileSharingMessage.autoAccepting:
        return localizations.autoAcceptingMessage;
    }
  }
}
