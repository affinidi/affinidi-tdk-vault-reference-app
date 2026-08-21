import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../l10n/app_localizations.dart';
import '../../l10n/app_localizations_en.dart';

part 'localizations_provider.g.dart';

/// Provides the current [AppLocalizations] instance to controllers that need
/// to produce user-facing strings without access to a [BuildContext].
///
/// Returns [AppLocalizationsEn] unconditionally because the app declares only
/// `'en'` in its supported locales list.  If additional locales are added in
/// future, replace this with a locale-aware implementation that reads a
/// `localeProvider` exposed from the root widget.
@riverpod
AppLocalizations localizations(Ref ref) => AppLocalizationsEn();
