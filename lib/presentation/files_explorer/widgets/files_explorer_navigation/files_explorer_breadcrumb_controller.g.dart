// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'files_explorer_breadcrumb_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filesExplorerBreadcrumbControllerHash() =>
    r'25c102ac817864e0cee428cfa17d78f93b4d1bc2';

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

abstract class _$FilesExplorerBreadcrumbController
    extends BuildlessAutoDisposeNotifier<Map<String, String>> {
  late final String screenKey;

  Map<String, String> build(
    String screenKey,
  );
}

/// See also [FilesExplorerBreadcrumbController].
@ProviderFor(FilesExplorerBreadcrumbController)
const filesExplorerBreadcrumbControllerProvider =
    FilesExplorerBreadcrumbControllerFamily();

/// See also [FilesExplorerBreadcrumbController].
class FilesExplorerBreadcrumbControllerFamily
    extends Family<Map<String, String>> {
  /// See also [FilesExplorerBreadcrumbController].
  const FilesExplorerBreadcrumbControllerFamily();

  /// See also [FilesExplorerBreadcrumbController].
  FilesExplorerBreadcrumbControllerProvider call(
    String screenKey,
  ) {
    return FilesExplorerBreadcrumbControllerProvider(
      screenKey,
    );
  }

  @override
  FilesExplorerBreadcrumbControllerProvider getProviderOverride(
    covariant FilesExplorerBreadcrumbControllerProvider provider,
  ) {
    return call(
      provider.screenKey,
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
  String? get name => r'filesExplorerBreadcrumbControllerProvider';
}

/// See also [FilesExplorerBreadcrumbController].
class FilesExplorerBreadcrumbControllerProvider
    extends AutoDisposeNotifierProviderImpl<FilesExplorerBreadcrumbController,
        Map<String, String>> {
  /// See also [FilesExplorerBreadcrumbController].
  FilesExplorerBreadcrumbControllerProvider(
    String screenKey,
  ) : this._internal(
          () => FilesExplorerBreadcrumbController()..screenKey = screenKey,
          from: filesExplorerBreadcrumbControllerProvider,
          name: r'filesExplorerBreadcrumbControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$filesExplorerBreadcrumbControllerHash,
          dependencies: FilesExplorerBreadcrumbControllerFamily._dependencies,
          allTransitiveDependencies: FilesExplorerBreadcrumbControllerFamily
              ._allTransitiveDependencies,
          screenKey: screenKey,
        );

  FilesExplorerBreadcrumbControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.screenKey,
  }) : super.internal();

  final String screenKey;

  @override
  Map<String, String> runNotifierBuild(
    covariant FilesExplorerBreadcrumbController notifier,
  ) {
    return notifier.build(
      screenKey,
    );
  }

  @override
  Override overrideWith(FilesExplorerBreadcrumbController Function() create) {
    return ProviderOverride(
      origin: this,
      override: FilesExplorerBreadcrumbControllerProvider._internal(
        () => create()..screenKey = screenKey,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        screenKey: screenKey,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<FilesExplorerBreadcrumbController,
      Map<String, String>> createElement() {
    return _FilesExplorerBreadcrumbControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilesExplorerBreadcrumbControllerProvider &&
        other.screenKey == screenKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, screenKey.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FilesExplorerBreadcrumbControllerRef
    on AutoDisposeNotifierProviderRef<Map<String, String>> {
  /// The parameter `screenKey` of this provider.
  String get screenKey;
}

class _FilesExplorerBreadcrumbControllerProviderElement
    extends AutoDisposeNotifierProviderElement<
        FilesExplorerBreadcrumbController,
        Map<String, String>> with FilesExplorerBreadcrumbControllerRef {
  _FilesExplorerBreadcrumbControllerProviderElement(super.provider);

  @override
  String get screenKey =>
      (origin as FilesExplorerBreadcrumbControllerProvider).screenKey;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
