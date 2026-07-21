// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'localizations_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$localizationsHash() => r'19b034bdeb113f09c890af9959c5e0e9a593397d';

/// Provides the current [AppLocalizations] instance to controllers that need
/// to produce user-facing strings without access to a [BuildContext].
///
/// Returns [AppLocalizationsEn] unconditionally because the app declares only
/// `'en'` in its supported locales list.  If additional locales are added in
/// future, replace this with a locale-aware implementation that reads a
/// `localeProvider` exposed from the root widget.
///
/// Copied from [localizations].
@ProviderFor(localizations)
final localizationsProvider = AutoDisposeProvider<AppLocalizations>.internal(
  localizations,
  name: r'localizationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$localizationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LocalizationsRef = AutoDisposeProviderRef<AppLocalizations>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
