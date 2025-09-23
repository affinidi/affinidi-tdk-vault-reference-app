// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_folder_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$createFolderFormControllerHash() =>
    r'd3f1fbe07f07e3456242e17233a53205c6efc77b';

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

abstract class _$CreateFolderFormController
    extends BuildlessAutoDisposeNotifier<CreateFolderFormState> {
  late final String? parentNodeId;
  late final String profileId;

  CreateFolderFormState build({
    String? parentNodeId,
    required String profileId,
  });
}

/// See also [CreateFolderFormController].
@ProviderFor(CreateFolderFormController)
const createFolderFormControllerProvider = CreateFolderFormControllerFamily();

/// See also [CreateFolderFormController].
class CreateFolderFormControllerFamily extends Family<CreateFolderFormState> {
  /// See also [CreateFolderFormController].
  const CreateFolderFormControllerFamily();

  /// See also [CreateFolderFormController].
  CreateFolderFormControllerProvider call({
    String? parentNodeId,
    required String profileId,
  }) {
    return CreateFolderFormControllerProvider(
      parentNodeId: parentNodeId,
      profileId: profileId,
    );
  }

  @override
  CreateFolderFormControllerProvider getProviderOverride(
    covariant CreateFolderFormControllerProvider provider,
  ) {
    return call(
      parentNodeId: provider.parentNodeId,
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
  String? get name => r'createFolderFormControllerProvider';
}

/// See also [CreateFolderFormController].
class CreateFolderFormControllerProvider
    extends AutoDisposeNotifierProviderImpl<CreateFolderFormController,
        CreateFolderFormState> {
  /// See also [CreateFolderFormController].
  CreateFolderFormControllerProvider({
    String? parentNodeId,
    required String profileId,
  }) : this._internal(
          () => CreateFolderFormController()
            ..parentNodeId = parentNodeId
            ..profileId = profileId,
          from: createFolderFormControllerProvider,
          name: r'createFolderFormControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$createFolderFormControllerHash,
          dependencies: CreateFolderFormControllerFamily._dependencies,
          allTransitiveDependencies:
              CreateFolderFormControllerFamily._allTransitiveDependencies,
          parentNodeId: parentNodeId,
          profileId: profileId,
        );

  CreateFolderFormControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.parentNodeId,
    required this.profileId,
  }) : super.internal();

  final String? parentNodeId;
  final String profileId;

  @override
  CreateFolderFormState runNotifierBuild(
    covariant CreateFolderFormController notifier,
  ) {
    return notifier.build(
      parentNodeId: parentNodeId,
      profileId: profileId,
    );
  }

  @override
  Override overrideWith(CreateFolderFormController Function() create) {
    return ProviderOverride(
      origin: this,
      override: CreateFolderFormControllerProvider._internal(
        () => create()
          ..parentNodeId = parentNodeId
          ..profileId = profileId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        parentNodeId: parentNodeId,
        profileId: profileId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<CreateFolderFormController,
      CreateFolderFormState> createElement() {
    return _CreateFolderFormControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateFolderFormControllerProvider &&
        other.parentNodeId == parentNodeId &&
        other.profileId == profileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, parentNodeId.hashCode);
    hash = _SystemHash.combine(hash, profileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CreateFolderFormControllerRef
    on AutoDisposeNotifierProviderRef<CreateFolderFormState> {
  /// The parameter `parentNodeId` of this provider.
  String? get parentNodeId;

  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _CreateFolderFormControllerProviderElement
    extends AutoDisposeNotifierProviderElement<CreateFolderFormController,
        CreateFolderFormState> with CreateFolderFormControllerRef {
  _CreateFolderFormControllerProviderElement(super.provider);

  @override
  String? get parentNodeId =>
      (origin as CreateFolderFormControllerProvider).parentNodeId;
  @override
  String get profileId =>
      (origin as CreateFolderFormControllerProvider).profileId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
