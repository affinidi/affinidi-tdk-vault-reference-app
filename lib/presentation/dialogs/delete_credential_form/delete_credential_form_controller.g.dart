// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_credential_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$deleteCredentialFormControllerHash() =>
    r'a632cf4ea3c955d21d7c2b2773245b1851911ae1';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$DeleteCredentialFormController
    extends BuildlessAutoDisposeNotifier<void> {
  late final DigitalCredential digitalCredential;
  late final String profileId;

  void build(
    DigitalCredential digitalCredential, {
    required String profileId,
  });
}

/// See also [DeleteCredentialFormController].
@ProviderFor(DeleteCredentialFormController)
const deleteCredentialFormControllerProvider =
    DeleteCredentialFormControllerFamily();

/// See also [DeleteCredentialFormController].
class DeleteCredentialFormControllerFamily extends Family<void> {
  /// See also [DeleteCredentialFormController].
  const DeleteCredentialFormControllerFamily();

  /// See also [DeleteCredentialFormController].
  DeleteCredentialFormControllerProvider call(
    DigitalCredential digitalCredential, {
    required String profileId,
  }) {
    return DeleteCredentialFormControllerProvider(
      digitalCredential,
      profileId: profileId,
    );
  }

  @override
  DeleteCredentialFormControllerProvider getProviderOverride(
    covariant DeleteCredentialFormControllerProvider provider,
  ) {
    return call(
      provider.digitalCredential,
      profileId: provider.profileId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'deleteCredentialFormControllerProvider';
}

/// See also [DeleteCredentialFormController].
class DeleteCredentialFormControllerProvider
    extends AutoDisposeNotifierProviderImpl<DeleteCredentialFormController,
        void> {
  /// See also [DeleteCredentialFormController].
  DeleteCredentialFormControllerProvider(
    DigitalCredential digitalCredential, {
    required String profileId,
  }) : this._internal(
          () => DeleteCredentialFormController()
            ..digitalCredential = digitalCredential
            ..profileId = profileId,
          from: deleteCredentialFormControllerProvider,
          name: r'deleteCredentialFormControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$deleteCredentialFormControllerHash,
          dependencies: DeleteCredentialFormControllerFamily._dependencies,
          allTransitiveDependencies:
              DeleteCredentialFormControllerFamily._allTransitiveDependencies,
          digitalCredential: digitalCredential,
          profileId: profileId,
        );

  DeleteCredentialFormControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.digitalCredential,
    required this.profileId,
  }) : super.internal();

  final DigitalCredential digitalCredential;
  final String profileId;

  @override
  void runNotifierBuild(
    covariant DeleteCredentialFormController notifier,
  ) {
    return notifier.build(
      digitalCredential,
      profileId: profileId,
    );
  }

  @override
  Override overrideWith(DeleteCredentialFormController Function() create) {
    return ProviderOverride(
      origin: this,
      override: DeleteCredentialFormControllerProvider._internal(
        () => create()
          ..digitalCredential = digitalCredential
          ..profileId = profileId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        digitalCredential: digitalCredential,
        profileId: profileId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<DeleteCredentialFormController, void>
      createElement() {
    return _DeleteCredentialFormControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteCredentialFormControllerProvider &&
        other.digitalCredential == digitalCredential &&
        other.profileId == profileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, digitalCredential.hashCode);
    hash = _SystemHash.combine(hash, profileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DeleteCredentialFormControllerRef
    on AutoDisposeNotifierProviderRef<void> {
  /// The parameter `digitalCredential` of this provider.
  DigitalCredential get digitalCredential;

  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _DeleteCredentialFormControllerProviderElement
    extends AutoDisposeNotifierProviderElement<DeleteCredentialFormController,
        void> with DeleteCredentialFormControllerRef {
  _DeleteCredentialFormControllerProviderElement(super.provider);

  @override
  DigitalCredential get digitalCredential =>
      (origin as DeleteCredentialFormControllerProvider).digitalCredential;
  @override
  String get profileId =>
      (origin as DeleteCredentialFormControllerProvider).profileId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
