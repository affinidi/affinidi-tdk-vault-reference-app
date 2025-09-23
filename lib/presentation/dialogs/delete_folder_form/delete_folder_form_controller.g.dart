// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_folder_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$deleteFolderFormControllerHash() => r'395b22ed9659e12032270b93bec5418a93aad839';

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

abstract class _$DeleteFolderFormController extends BuildlessAutoDisposeNotifier<DeleteFolderFormState> {
  late final Item folder;
  late final String? parentNodeId;
  late final String profileId;

  DeleteFolderFormState build({
    required Item folder,
    required String? parentNodeId,
    required String profileId,
  });
}

/// See also [DeleteFolderFormController].
@ProviderFor(DeleteFolderFormController)
const deleteFolderFormControllerProvider = DeleteFolderFormControllerFamily();

/// See also [DeleteFolderFormController].
class DeleteFolderFormControllerFamily extends Family<DeleteFolderFormState> {
  /// See also [DeleteFolderFormController].
  const DeleteFolderFormControllerFamily();

  /// See also [DeleteFolderFormController].
  DeleteFolderFormControllerProvider call({
    required Item folder,
    required String? parentNodeId,
    required String profileId,
  }) {
    return DeleteFolderFormControllerProvider(
      folder: folder,
      parentNodeId: parentNodeId,
      profileId: profileId,
    );
  }

  @override
  DeleteFolderFormControllerProvider getProviderOverride(
    covariant DeleteFolderFormControllerProvider provider,
  ) {
    return call(
      folder: provider.folder,
      parentNodeId: provider.parentNodeId,
      profileId: provider.profileId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies => _allTransitiveDependencies;

  @override
  String? get name => r'deleteFolderFormControllerProvider';
}

/// See also [DeleteFolderFormController].
class DeleteFolderFormControllerProvider
    extends AutoDisposeNotifierProviderImpl<DeleteFolderFormController, DeleteFolderFormState> {
  /// See also [DeleteFolderFormController].
  DeleteFolderFormControllerProvider({
    required Item folder,
    required String? parentNodeId,
    required String profileId,
  }) : this._internal(
          () => DeleteFolderFormController()
            ..folder = folder
            ..parentNodeId = parentNodeId
            ..profileId = profileId,
          from: deleteFolderFormControllerProvider,
          name: r'deleteFolderFormControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$deleteFolderFormControllerHash,
          dependencies: DeleteFolderFormControllerFamily._dependencies,
          allTransitiveDependencies: DeleteFolderFormControllerFamily._allTransitiveDependencies,
          folder: folder,
          parentNodeId: parentNodeId,
          profileId: profileId,
        );

  DeleteFolderFormControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.folder,
    required this.parentNodeId,
    required this.profileId,
  }) : super.internal();

  final Item folder;
  final String? parentNodeId;
  final String profileId;

  @override
  DeleteFolderFormState runNotifierBuild(
    covariant DeleteFolderFormController notifier,
  ) {
    return notifier.build(
      folder: folder,
      parentNodeId: parentNodeId,
      profileId: profileId,
    );
  }

  @override
  Override overrideWith(DeleteFolderFormController Function() create) {
    return ProviderOverride(
      origin: this,
      override: DeleteFolderFormControllerProvider._internal(
        () => create()
          ..folder = folder
          ..parentNodeId = parentNodeId
          ..profileId = profileId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        folder: folder,
        parentNodeId: parentNodeId,
        profileId: profileId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<DeleteFolderFormController, DeleteFolderFormState> createElement() {
    return _DeleteFolderFormControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteFolderFormControllerProvider &&
        other.folder == folder &&
        other.parentNodeId == parentNodeId &&
        other.profileId == profileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, folder.hashCode);
    hash = _SystemHash.combine(hash, parentNodeId.hashCode);
    hash = _SystemHash.combine(hash, profileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DeleteFolderFormControllerRef on AutoDisposeNotifierProviderRef<DeleteFolderFormState> {
  /// The parameter `folder` of this provider.
  Item get folder;

  /// The parameter `parentNodeId` of this provider.
  String? get parentNodeId;

  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _DeleteFolderFormControllerProviderElement
    extends AutoDisposeNotifierProviderElement<DeleteFolderFormController, DeleteFolderFormState>
    with DeleteFolderFormControllerRef {
  _DeleteFolderFormControllerProviderElement(super.provider);

  @override
  Item get folder => (origin as DeleteFolderFormControllerProvider).folder;
  @override
  String? get parentNodeId => (origin as DeleteFolderFormControllerProvider).parentNodeId;
  @override
  String get profileId => (origin as DeleteFolderFormControllerProvider).profileId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
