// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_files_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myFilesPageControllerHash() => r'6441fdc5a690700713d9adcbb9e04b37ca9a89ee';

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

abstract class _$MyFilesPageController extends BuildlessAutoDisposeNotifier<MyFilesPageState> {
  late final String? parentNodeId;
  late final String profileId;

  MyFilesPageState build({
    required String? parentNodeId,
    required String profileId,
  });
}

/// See also [MyFilesPageController].
@ProviderFor(MyFilesPageController)
const myFilesPageControllerProvider = MyFilesPageControllerFamily();

/// See also [MyFilesPageController].
class MyFilesPageControllerFamily extends Family<MyFilesPageState> {
  /// See also [MyFilesPageController].
  const MyFilesPageControllerFamily();

  /// See also [MyFilesPageController].
  MyFilesPageControllerProvider call({
    required String? parentNodeId,
    required String profileId,
  }) {
    return MyFilesPageControllerProvider(
      parentNodeId: parentNodeId,
      profileId: profileId,
    );
  }

  @override
  MyFilesPageControllerProvider getProviderOverride(
    covariant MyFilesPageControllerProvider provider,
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
  Iterable<ProviderOrFamily>? get allTransitiveDependencies => _allTransitiveDependencies;

  @override
  String? get name => r'myFilesPageControllerProvider';
}

/// See also [MyFilesPageController].
class MyFilesPageControllerProvider extends AutoDisposeNotifierProviderImpl<MyFilesPageController, MyFilesPageState> {
  /// See also [MyFilesPageController].
  MyFilesPageControllerProvider({
    required String? parentNodeId,
    required String profileId,
  }) : this._internal(
          () => MyFilesPageController()
            ..parentNodeId = parentNodeId
            ..profileId = profileId,
          from: myFilesPageControllerProvider,
          name: r'myFilesPageControllerProvider',
          debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$myFilesPageControllerHash,
          dependencies: MyFilesPageControllerFamily._dependencies,
          allTransitiveDependencies: MyFilesPageControllerFamily._allTransitiveDependencies,
          parentNodeId: parentNodeId,
          profileId: profileId,
        );

  MyFilesPageControllerProvider._internal(
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
  MyFilesPageState runNotifierBuild(
    covariant MyFilesPageController notifier,
  ) {
    return notifier.build(
      parentNodeId: parentNodeId,
      profileId: profileId,
    );
  }

  @override
  Override overrideWith(MyFilesPageController Function() create) {
    return ProviderOverride(
      origin: this,
      override: MyFilesPageControllerProvider._internal(
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
  AutoDisposeNotifierProviderElement<MyFilesPageController, MyFilesPageState> createElement() {
    return _MyFilesPageControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MyFilesPageControllerProvider && other.parentNodeId == parentNodeId && other.profileId == profileId;
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
mixin MyFilesPageControllerRef on AutoDisposeNotifierProviderRef<MyFilesPageState> {
  /// The parameter `parentNodeId` of this provider.
  String? get parentNodeId;

  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _MyFilesPageControllerProviderElement
    extends AutoDisposeNotifierProviderElement<MyFilesPageController, MyFilesPageState> with MyFilesPageControllerRef {
  _MyFilesPageControllerProviderElement(super.provider);

  @override
  String? get parentNodeId => (origin as MyFilesPageControllerProvider).parentNodeId;
  @override
  String get profileId => (origin as MyFilesPageControllerProvider).profileId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
