// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rename_file_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$renameFileFormControllerHash() =>
    r'8e712dc9583a5b417f8333beb1542a290790340e';

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

abstract class _$RenameFileFormController
    extends BuildlessAutoDisposeNotifier<RenameFileFormState> {
  late final Item item;
  late final String? parentNodeId;
  late final String profileId;

  RenameFileFormState build({
    required Item item,
    required String? parentNodeId,
    required String profileId,
  });
}

/// See also [RenameFileFormController].
@ProviderFor(RenameFileFormController)
const renameFileFormControllerProvider = RenameFileFormControllerFamily();

/// See also [RenameFileFormController].
class RenameFileFormControllerFamily extends Family<RenameFileFormState> {
  /// See also [RenameFileFormController].
  const RenameFileFormControllerFamily();

  /// See also [RenameFileFormController].
  RenameFileFormControllerProvider call({
    required Item item,
    required String? parentNodeId,
    required String profileId,
  }) {
    return RenameFileFormControllerProvider(
      item: item,
      parentNodeId: parentNodeId,
      profileId: profileId,
    );
  }

  @override
  RenameFileFormControllerProvider getProviderOverride(
    covariant RenameFileFormControllerProvider provider,
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
  String? get name => r'renameFileFormControllerProvider';
}

/// See also [RenameFileFormController].
class RenameFileFormControllerProvider extends AutoDisposeNotifierProviderImpl<
    RenameFileFormController, RenameFileFormState> {
  /// See also [RenameFileFormController].
  RenameFileFormControllerProvider({
    required Item item,
    required String? parentNodeId,
    required String profileId,
  }) : this._internal(
          () => RenameFileFormController()
            ..item = item
            ..parentNodeId = parentNodeId
            ..profileId = profileId,
          from: renameFileFormControllerProvider,
          name: r'renameFileFormControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$renameFileFormControllerHash,
          dependencies: RenameFileFormControllerFamily._dependencies,
          allTransitiveDependencies:
              RenameFileFormControllerFamily._allTransitiveDependencies,
          item: item,
          parentNodeId: parentNodeId,
          profileId: profileId,
        );

  RenameFileFormControllerProvider._internal(
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
  RenameFileFormState runNotifierBuild(
    covariant RenameFileFormController notifier,
  ) {
    return notifier.build(
      item: item,
      parentNodeId: parentNodeId,
      profileId: profileId,
    );
  }

  @override
  Override overrideWith(RenameFileFormController Function() create) {
    return ProviderOverride(
      origin: this,
      override: RenameFileFormControllerProvider._internal(
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
  AutoDisposeNotifierProviderElement<RenameFileFormController,
      RenameFileFormState> createElement() {
    return _RenameFileFormControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RenameFileFormControllerProvider &&
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
mixin RenameFileFormControllerRef
    on AutoDisposeNotifierProviderRef<RenameFileFormState> {
  /// The parameter `item` of this provider.
  Item get item;

  /// The parameter `parentNodeId` of this provider.
  String? get parentNodeId;

  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _RenameFileFormControllerProviderElement
    extends AutoDisposeNotifierProviderElement<RenameFileFormController,
        RenameFileFormState> with RenameFileFormControllerRef {
  _RenameFileFormControllerProviderElement(super.provider);

  @override
  Item get item => (origin as RenameFileFormControllerProvider).item;
  @override
  String? get parentNodeId =>
      (origin as RenameFileFormControllerProvider).parentNodeId;
  @override
  String get profileId =>
      (origin as RenameFileFormControllerProvider).profileId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
