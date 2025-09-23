// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_credentials_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myCredentialsPageControllerHash() => r'474e78674cb063d8179f9a0782a97d85f8ab9865';

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

abstract class _$MyCredentialsPageController extends BuildlessAutoDisposeNotifier<MyCredentialsPageState> {
  late final String profileId;

  MyCredentialsPageState build({
    required String profileId,
  });
}

/// See also [MyCredentialsPageController].
@ProviderFor(MyCredentialsPageController)
const myCredentialsPageControllerProvider = MyCredentialsPageControllerFamily();

/// See also [MyCredentialsPageController].
class MyCredentialsPageControllerFamily extends Family<MyCredentialsPageState> {
  /// See also [MyCredentialsPageController].
  const MyCredentialsPageControllerFamily();

  /// See also [MyCredentialsPageController].
  MyCredentialsPageControllerProvider call({
    required String profileId,
  }) {
    return MyCredentialsPageControllerProvider(
      profileId: profileId,
    );
  }

  @override
  MyCredentialsPageControllerProvider getProviderOverride(
    covariant MyCredentialsPageControllerProvider provider,
  ) {
    return call(
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
  String? get name => r'myCredentialsPageControllerProvider';
}

/// See also [MyCredentialsPageController].
class MyCredentialsPageControllerProvider
    extends AutoDisposeNotifierProviderImpl<MyCredentialsPageController, MyCredentialsPageState> {
  /// See also [MyCredentialsPageController].
  MyCredentialsPageControllerProvider({
    required String profileId,
  }) : this._internal(
          () => MyCredentialsPageController()..profileId = profileId,
          from: myCredentialsPageControllerProvider,
          name: r'myCredentialsPageControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$myCredentialsPageControllerHash,
          dependencies: MyCredentialsPageControllerFamily._dependencies,
          allTransitiveDependencies: MyCredentialsPageControllerFamily._allTransitiveDependencies,
          profileId: profileId,
        );

  MyCredentialsPageControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.profileId,
  }) : super.internal();

  final String profileId;

  @override
  MyCredentialsPageState runNotifierBuild(
    covariant MyCredentialsPageController notifier,
  ) {
    return notifier.build(
      profileId: profileId,
    );
  }

  @override
  Override overrideWith(MyCredentialsPageController Function() create) {
    return ProviderOverride(
      origin: this,
      override: MyCredentialsPageControllerProvider._internal(
        () => create()..profileId = profileId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        profileId: profileId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<MyCredentialsPageController, MyCredentialsPageState> createElement() {
    return _MyCredentialsPageControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MyCredentialsPageControllerProvider && other.profileId == profileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MyCredentialsPageControllerRef on AutoDisposeNotifierProviderRef<MyCredentialsPageState> {
  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _MyCredentialsPageControllerProviderElement
    extends AutoDisposeNotifierProviderElement<MyCredentialsPageController, MyCredentialsPageState>
    with MyCredentialsPageControllerRef {
  _MyCredentialsPageControllerProviderElement(super.provider);

  @override
  String get profileId => (origin as MyCredentialsPageControllerProvider).profileId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
