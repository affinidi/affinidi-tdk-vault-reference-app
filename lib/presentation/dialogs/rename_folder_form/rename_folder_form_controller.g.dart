// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rename_folder_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$renameFolderFormControllerHash() =>
    r'a17d6037eadcb741fbd575a016143ee0e885785d';

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

abstract class _$RenameFolderFormController
    extends BuildlessAutoDisposeNotifier<RenameFolderFormState> {
  late final Item item;
  late final String? parentNodeId;
  late final String profileId;

  RenameFolderFormState build({
    required Item item,
    required String? parentNodeId,
    required String profileId,
  });
}

/// See also [RenameFolderFormController].
@ProviderFor(RenameFolderFormController)
const renameFolderFormControllerProvider = RenameFolderFormControllerFamily();

/// See also [RenameFolderFormController].
class RenameFolderFormControllerFamily extends Family<RenameFolderFormState> {
  /// See also [RenameFolderFormController].
  const RenameFolderFormControllerFamily();

  /// See also [RenameFolderFormController].
  RenameFolderFormControllerProvider call({
    required Item item,
    required String? parentNodeId,
    required String profileId,
  }) {
    return RenameFolderFormControllerProvider(
      item: item,
      parentNodeId: parentNodeId,
      profileId: profileId,
    );
  }

  @override
  RenameFolderFormControllerProvider getProviderOverride(
    covariant RenameFolderFormControllerProvider provider,
  ) {
    return call(
      item: provider.item,
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
  String? get name => r'renameFolderFormControllerProvider';
}

/// See also [RenameFolderFormController].
class RenameFolderFormControllerProvider
    extends AutoDisposeNotifierProviderImpl<RenameFolderFormController,
        RenameFolderFormState> {
  /// See also [RenameFolderFormController].
  RenameFolderFormControllerProvider({
    required Item item,
    required String? parentNodeId,
    required String profileId,
  }) : this._internal(
          () => RenameFolderFormController()
            ..item = item
            ..parentNodeId = parentNodeId
            ..profileId = profileId,
          from: renameFolderFormControllerProvider,
          name: r'renameFolderFormControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$renameFolderFormControllerHash,
          dependencies: RenameFolderFormControllerFamily._dependencies,
          allTransitiveDependencies:
              RenameFolderFormControllerFamily._allTransitiveDependencies,
          item: item,
          parentNodeId: parentNodeId,
          profileId: profileId,
        );

  RenameFolderFormControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.item,
    required this.parentNodeId,
    required this.profileId,
  }) : super.internal();

  final Item item;
  final String? parentNodeId;
  final String profileId;

  @override
  RenameFolderFormState runNotifierBuild(
    covariant RenameFolderFormController notifier,
  ) {
    return notifier.build(
      item: item,
      parentNodeId: parentNodeId,
      profileId: profileId,
    );
  }

  @override
  Override overrideWith(RenameFolderFormController Function() create) {
    return ProviderOverride(
      origin: this,
      override: RenameFolderFormControllerProvider._internal(
        () => create()
          ..item = item
          ..parentNodeId = parentNodeId
          ..profileId = profileId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        item: item,
        parentNodeId: parentNodeId,
        profileId: profileId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<RenameFolderFormController,
      RenameFolderFormState> createElement() {
    return _RenameFolderFormControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RenameFolderFormControllerProvider &&
        other.item == item &&
        other.parentNodeId == parentNodeId &&
        other.profileId == profileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, item.hashCode);
    hash = _SystemHash.combine(hash, parentNodeId.hashCode);
    hash = _SystemHash.combine(hash, profileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RenameFolderFormControllerRef
    on AutoDisposeNotifierProviderRef<RenameFolderFormState> {
  /// The parameter `item` of this provider.
  Item get item;

  /// The parameter `parentNodeId` of this provider.
  String? get parentNodeId;

  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _RenameFolderFormControllerProviderElement
    extends AutoDisposeNotifierProviderElement<RenameFolderFormController,
        RenameFolderFormState> with RenameFolderFormControllerRef {
  _RenameFolderFormControllerProviderElement(super.provider);

  @override
  Item get item => (origin as RenameFolderFormControllerProvider).item;
  @override
  String? get parentNodeId =>
      (origin as RenameFolderFormControllerProvider).parentNodeId;
  @override
  String get profileId =>
      (origin as RenameFolderFormControllerProvider).profileId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
