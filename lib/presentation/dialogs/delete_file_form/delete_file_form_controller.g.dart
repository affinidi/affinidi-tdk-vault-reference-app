// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_file_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$deleteFileFormControllerHash() => r'9073a2639f364bd84cd81de864f46b7c93b4056c';

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

abstract class _$DeleteFileFormController extends BuildlessAutoDisposeNotifier<void> {
  late final Item file;
  late final String? parentNodeId;
  late final String profileId;

  void build({
    required Item file,
    String? parentNodeId,
    required String profileId,
  });
}

/// See also [DeleteFileFormController].
@ProviderFor(DeleteFileFormController)
const deleteFileFormControllerProvider = DeleteFileFormControllerFamily();

/// See also [DeleteFileFormController].
class DeleteFileFormControllerFamily extends Family<void> {
  /// See also [DeleteFileFormController].
  const DeleteFileFormControllerFamily();

  /// See also [DeleteFileFormController].
  DeleteFileFormControllerProvider call({
    required Item file,
    String? parentNodeId,
    required String profileId,
  }) {
    return DeleteFileFormControllerProvider(
      file: file,
      parentNodeId: parentNodeId,
      profileId: profileId,
    );
  }

  @override
  DeleteFileFormControllerProvider getProviderOverride(
    covariant DeleteFileFormControllerProvider provider,
  ) {
    return call(
      file: provider.file,
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
  String? get name => r'deleteFileFormControllerProvider';
}

/// See also [DeleteFileFormController].
class DeleteFileFormControllerProvider extends AutoDisposeNotifierProviderImpl<DeleteFileFormController, void> {
  /// See also [DeleteFileFormController].
  DeleteFileFormControllerProvider({
    required Item file,
    String? parentNodeId,
    required String profileId,
  }) : this._internal(
          () => DeleteFileFormController()
            ..file = file
            ..parentNodeId = parentNodeId
            ..profileId = profileId,
          from: deleteFileFormControllerProvider,
          name: r'deleteFileFormControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$deleteFileFormControllerHash,
          dependencies: DeleteFileFormControllerFamily._dependencies,
          allTransitiveDependencies: DeleteFileFormControllerFamily._allTransitiveDependencies,
          file: file,
          parentNodeId: parentNodeId,
          profileId: profileId,
        );

  DeleteFileFormControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.file,
    required this.parentNodeId,
    required this.profileId,
  }) : super.internal();

  final Item file;
  final String? parentNodeId;
  final String profileId;

  @override
  void runNotifierBuild(
    covariant DeleteFileFormController notifier,
  ) {
    return notifier.build(
      file: file,
      parentNodeId: parentNodeId,
      profileId: profileId,
    );
  }

  @override
  Override overrideWith(DeleteFileFormController Function() create) {
    return ProviderOverride(
      origin: this,
      override: DeleteFileFormControllerProvider._internal(
        () => create()
          ..file = file
          ..parentNodeId = parentNodeId
          ..profileId = profileId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        file: file,
        parentNodeId: parentNodeId,
        profileId: profileId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<DeleteFileFormController, void> createElement() {
    return _DeleteFileFormControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteFileFormControllerProvider &&
        other.file == file &&
        other.parentNodeId == parentNodeId &&
        other.profileId == profileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, file.hashCode);
    hash = _SystemHash.combine(hash, parentNodeId.hashCode);
    hash = _SystemHash.combine(hash, profileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DeleteFileFormControllerRef on AutoDisposeNotifierProviderRef<void> {
  /// The parameter `file` of this provider.
  Item get file;

  /// The parameter `parentNodeId` of this provider.
  String? get parentNodeId;

  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _DeleteFileFormControllerProviderElement
    extends AutoDisposeNotifierProviderElement<DeleteFileFormController, void> with DeleteFileFormControllerRef {
  _DeleteFileFormControllerProviderElement(super.provider);

  @override
  Item get file => (origin as DeleteFileFormControllerProvider).file;
  @override
  String? get parentNodeId => (origin as DeleteFileFormControllerProvider).parentNodeId;
  @override
  String get profileId => (origin as DeleteFileFormControllerProvider).profileId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
