// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_preview_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filePreviewPageControllerHash() =>
    r'8aed26710c26fc237c57141ebf92e92259c9922b';

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

abstract class _$FilePreviewPageController
    extends BuildlessAutoDisposeNotifier<FilePreviewPageState> {
  late final String nodeId;
  late final String profileId;
  late final String? parentNodeId;
  late final bool isSharedProfile;

  FilePreviewPageState build({
    required String nodeId,
    required String profileId,
    String? parentNodeId,
    bool isSharedProfile = false,
  });
}

/// See also [FilePreviewPageController].
@ProviderFor(FilePreviewPageController)
const filePreviewPageControllerProvider = FilePreviewPageControllerFamily();

/// See also [FilePreviewPageController].
class FilePreviewPageControllerFamily extends Family<FilePreviewPageState> {
  /// See also [FilePreviewPageController].
  const FilePreviewPageControllerFamily();

  /// See also [FilePreviewPageController].
  FilePreviewPageControllerProvider call({
    required String nodeId,
    required String profileId,
    String? parentNodeId,
    bool isSharedProfile = false,
  }) {
    return FilePreviewPageControllerProvider(
      nodeId: nodeId,
      profileId: profileId,
      parentNodeId: parentNodeId,
      isSharedProfile: isSharedProfile,
    );
  }

  @override
  FilePreviewPageControllerProvider getProviderOverride(
    covariant FilePreviewPageControllerProvider provider,
  ) {
    return call(
      nodeId: provider.nodeId,
      profileId: provider.profileId,
      parentNodeId: provider.parentNodeId,
      isSharedProfile: provider.isSharedProfile,
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
  String? get name => r'filePreviewPageControllerProvider';
}

/// See also [FilePreviewPageController].
class FilePreviewPageControllerProvider extends AutoDisposeNotifierProviderImpl<
    FilePreviewPageController, FilePreviewPageState> {
  /// See also [FilePreviewPageController].
  FilePreviewPageControllerProvider({
    required String nodeId,
    required String profileId,
    String? parentNodeId,
    bool isSharedProfile = false,
  }) : this._internal(
          () => FilePreviewPageController()
            ..nodeId = nodeId
            ..profileId = profileId
            ..parentNodeId = parentNodeId
            ..isSharedProfile = isSharedProfile,
          from: filePreviewPageControllerProvider,
          name: r'filePreviewPageControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$filePreviewPageControllerHash,
          dependencies: FilePreviewPageControllerFamily._dependencies,
          allTransitiveDependencies:
              FilePreviewPageControllerFamily._allTransitiveDependencies,
          nodeId: nodeId,
          profileId: profileId,
          parentNodeId: parentNodeId,
          isSharedProfile: isSharedProfile,
        );

  FilePreviewPageControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.nodeId,
    required this.profileId,
    required this.parentNodeId,
    required this.isSharedProfile,
  }) : super.internal();

  final String nodeId;
  final String profileId;
  final String? parentNodeId;
  final bool isSharedProfile;

  @override
  FilePreviewPageState runNotifierBuild(
    covariant FilePreviewPageController notifier,
  ) {
    return notifier.build(
      nodeId: nodeId,
      profileId: profileId,
      parentNodeId: parentNodeId,
      isSharedProfile: isSharedProfile,
    );
  }

  @override
  Override overrideWith(FilePreviewPageController Function() create) {
    return ProviderOverride(
      origin: this,
      override: FilePreviewPageControllerProvider._internal(
        () => create()
          ..nodeId = nodeId
          ..profileId = profileId
          ..parentNodeId = parentNodeId
          ..isSharedProfile = isSharedProfile,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        nodeId: nodeId,
        profileId: profileId,
        parentNodeId: parentNodeId,
        isSharedProfile: isSharedProfile,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<FilePreviewPageController,
      FilePreviewPageState> createElement() {
    return _FilePreviewPageControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilePreviewPageControllerProvider &&
        other.nodeId == nodeId &&
        other.profileId == profileId &&
        other.parentNodeId == parentNodeId &&
        other.isSharedProfile == isSharedProfile;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, nodeId.hashCode);
    hash = _SystemHash.combine(hash, profileId.hashCode);
    hash = _SystemHash.combine(hash, parentNodeId.hashCode);
    hash = _SystemHash.combine(hash, isSharedProfile.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FilePreviewPageControllerRef
    on AutoDisposeNotifierProviderRef<FilePreviewPageState> {
  /// The parameter `nodeId` of this provider.
  String get nodeId;

  /// The parameter `profileId` of this provider.
  String get profileId;

  /// The parameter `parentNodeId` of this provider.
  String? get parentNodeId;

  /// The parameter `isSharedProfile` of this provider.
  bool get isSharedProfile;
}

class _FilePreviewPageControllerProviderElement
    extends AutoDisposeNotifierProviderElement<FilePreviewPageController,
        FilePreviewPageState> with FilePreviewPageControllerRef {
  _FilePreviewPageControllerProviderElement(super.provider);

  @override
  String get nodeId => (origin as FilePreviewPageControllerProvider).nodeId;
  @override
  String get profileId =>
      (origin as FilePreviewPageControllerProvider).profileId;
  @override
  String? get parentNodeId =>
      (origin as FilePreviewPageControllerProvider).parentNodeId;
  @override
  bool get isSharedProfile =>
      (origin as FilePreviewPageControllerProvider).isSharedProfile;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
