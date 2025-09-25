// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedStoragesHash() => r'c2deed9aaacf3f46ff49a9309937d38f70e2f370';

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

/// Provider that returns all shared storages for a given profile.
///
/// Copied from [sharedStorages].
@ProviderFor(sharedStorages)
const sharedStoragesProvider = SharedStoragesFamily();

/// Provider that returns all shared storages for a given profile.
///
/// Copied from [sharedStorages].
class SharedStoragesFamily extends Family<AsyncValue<List<SharedStorage>>> {
  /// Provider that returns all shared storages for a given profile.
  ///
  /// Copied from [sharedStorages].
  const SharedStoragesFamily();

  /// Provider that returns all shared storages for a given profile.
  ///
  /// Copied from [sharedStorages].
  SharedStoragesProvider call(
    String profileId,
  ) {
    return SharedStoragesProvider(
      profileId,
    );
  }

  @override
  SharedStoragesProvider getProviderOverride(
    covariant SharedStoragesProvider provider,
  ) {
    return call(
      provider.profileId,
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
  String? get name => r'sharedStoragesProvider';
}

/// Provider that returns all shared storages for a given profile.
///
/// Copied from [sharedStorages].
class SharedStoragesProvider
    extends AutoDisposeFutureProvider<List<SharedStorage>> {
  /// Provider that returns all shared storages for a given profile.
  ///
  /// Copied from [sharedStorages].
  SharedStoragesProvider(
    String profileId,
  ) : this._internal(
          (ref) => sharedStorages(
            ref as SharedStoragesRef,
            profileId,
          ),
          from: sharedStoragesProvider,
          name: r'sharedStoragesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sharedStoragesHash,
          dependencies: SharedStoragesFamily._dependencies,
          allTransitiveDependencies:
              SharedStoragesFamily._allTransitiveDependencies,
          profileId: profileId,
        );

  SharedStoragesProvider._internal(
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
  Override overrideWith(
    FutureOr<List<SharedStorage>> Function(SharedStoragesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SharedStoragesProvider._internal(
        (ref) => create(ref as SharedStoragesRef),
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
  AutoDisposeFutureProviderElement<List<SharedStorage>> createElement() {
    return _SharedStoragesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SharedStoragesProvider && other.profileId == profileId;
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
mixin SharedStoragesRef on AutoDisposeFutureProviderRef<List<SharedStorage>> {
  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _SharedStoragesProviderElement
    extends AutoDisposeFutureProviderElement<List<SharedStorage>>
    with SharedStoragesRef {
  _SharedStoragesProviderElement(super.provider);

  @override
  String get profileId => (origin as SharedStoragesProvider).profileId;
}

String _$sharedStorageByIdHash() => r'502aec0c9fa595d8c1ce90f24dd1220e5ae4aaf9';

/// Provider that returns a specific shared storage by ID.
///
/// Copied from [sharedStorageById].
@ProviderFor(sharedStorageById)
const sharedStorageByIdProvider = SharedStorageByIdFamily();

/// Provider that returns a specific shared storage by ID.
///
/// Copied from [sharedStorageById].
class SharedStorageByIdFamily extends Family<AsyncValue<SharedStorage>> {
  /// Provider that returns a specific shared storage by ID.
  ///
  /// Copied from [sharedStorageById].
  const SharedStorageByIdFamily();

  /// Provider that returns a specific shared storage by ID.
  ///
  /// Copied from [sharedStorageById].
  SharedStorageByIdProvider call(
    String storageId,
  ) {
    return SharedStorageByIdProvider(
      storageId,
    );
  }

  @override
  SharedStorageByIdProvider getProviderOverride(
    covariant SharedStorageByIdProvider provider,
  ) {
    return call(
      provider.storageId,
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
  String? get name => r'sharedStorageByIdProvider';
}

/// Provider that returns a specific shared storage by ID.
///
/// Copied from [sharedStorageById].
class SharedStorageByIdProvider
    extends AutoDisposeFutureProvider<SharedStorage> {
  /// Provider that returns a specific shared storage by ID.
  ///
  /// Copied from [sharedStorageById].
  SharedStorageByIdProvider(
    String storageId,
  ) : this._internal(
          (ref) => sharedStorageById(
            ref as SharedStorageByIdRef,
            storageId,
          ),
          from: sharedStorageByIdProvider,
          name: r'sharedStorageByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sharedStorageByIdHash,
          dependencies: SharedStorageByIdFamily._dependencies,
          allTransitiveDependencies:
              SharedStorageByIdFamily._allTransitiveDependencies,
          storageId: storageId,
        );

  SharedStorageByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.storageId,
  }) : super.internal();

  final String storageId;

  @override
  Override overrideWith(
    FutureOr<SharedStorage> Function(SharedStorageByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SharedStorageByIdProvider._internal(
        (ref) => create(ref as SharedStorageByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        storageId: storageId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<SharedStorage> createElement() {
    return _SharedStorageByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SharedStorageByIdProvider && other.storageId == storageId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, storageId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SharedStorageByIdRef on AutoDisposeFutureProviderRef<SharedStorage> {
  /// The parameter `storageId` of this provider.
  String get storageId;
}

class _SharedStorageByIdProviderElement
    extends AutoDisposeFutureProviderElement<SharedStorage>
    with SharedStorageByIdRef {
  _SharedStorageByIdProviderElement(super.provider);

  @override
  String get storageId => (origin as SharedStorageByIdProvider).storageId;
}

String _$sharedStorageFilesHash() =>
    r'88462e42570227f6ccb651da6ab63448ea09f64c';

/// Provider that returns files from a shared storage.
///
/// Copied from [sharedStorageFiles].
@ProviderFor(sharedStorageFiles)
const sharedStorageFilesProvider = SharedStorageFilesFamily();

/// Provider that returns files from a shared storage.
///
/// Copied from [sharedStorageFiles].
class SharedStorageFilesFamily extends Family<AsyncValue<List<dynamic>>> {
  /// Provider that returns files from a shared storage.
  ///
  /// Copied from [sharedStorageFiles].
  const SharedStorageFilesFamily();

  /// Provider that returns files from a shared storage.
  ///
  /// Copied from [sharedStorageFiles].
  SharedStorageFilesProvider call(
    String storageId,
  ) {
    return SharedStorageFilesProvider(
      storageId,
    );
  }

  @override
  SharedStorageFilesProvider getProviderOverride(
    covariant SharedStorageFilesProvider provider,
  ) {
    return call(
      provider.storageId,
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
  String? get name => r'sharedStorageFilesProvider';
}

/// Provider that returns files from a shared storage.
///
/// Copied from [sharedStorageFiles].
class SharedStorageFilesProvider
    extends AutoDisposeFutureProvider<List<dynamic>> {
  /// Provider that returns files from a shared storage.
  ///
  /// Copied from [sharedStorageFiles].
  SharedStorageFilesProvider(
    String storageId,
  ) : this._internal(
          (ref) => sharedStorageFiles(
            ref as SharedStorageFilesRef,
            storageId,
          ),
          from: sharedStorageFilesProvider,
          name: r'sharedStorageFilesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sharedStorageFilesHash,
          dependencies: SharedStorageFilesFamily._dependencies,
          allTransitiveDependencies:
              SharedStorageFilesFamily._allTransitiveDependencies,
          storageId: storageId,
        );

  SharedStorageFilesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.storageId,
  }) : super.internal();

  final String storageId;

  @override
  Override overrideWith(
    FutureOr<List<dynamic>> Function(SharedStorageFilesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SharedStorageFilesProvider._internal(
        (ref) => create(ref as SharedStorageFilesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        storageId: storageId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<dynamic>> createElement() {
    return _SharedStorageFilesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SharedStorageFilesProvider && other.storageId == storageId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, storageId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SharedStorageFilesRef on AutoDisposeFutureProviderRef<List<dynamic>> {
  /// The parameter `storageId` of this provider.
  String get storageId;
}

class _SharedStorageFilesProviderElement
    extends AutoDisposeFutureProviderElement<List<dynamic>>
    with SharedStorageFilesRef {
  _SharedStorageFilesProviderElement(super.provider);

  @override
  String get storageId => (origin as SharedStorageFilesProvider).storageId;
}

String _$storageServiceHash() => r'e3ca4589aeee9ef4035012369dbc575043da5366';

abstract class _$StorageService
    extends BuildlessAutoDisposeNotifier<StorageServiceState> {
  late final String? parentNodeId;
  late final String profileId;

  StorageServiceState build({
    required String? parentNodeId,
    required String profileId,
  });
}

/// Service responsible for managing file storage operations within a vault profile.
///
/// This service provides functionality to:
/// - List files and folders in a directory
/// - Create, rename, and delete folders
/// - Upload and delete files
/// - Access file content
/// - Manage shared storage
///
/// The service supports both VFS (cloud-based) and Edge (local) storage types,
/// automatically handling the differences between storage implementations.
///
/// Copied from [StorageService].
@ProviderFor(StorageService)
const storageServiceProvider = StorageServiceFamily();

/// Service responsible for managing file storage operations within a vault profile.
///
/// This service provides functionality to:
/// - List files and folders in a directory
/// - Create, rename, and delete folders
/// - Upload and delete files
/// - Access file content
/// - Manage shared storage
///
/// The service supports both VFS (cloud-based) and Edge (local) storage types,
/// automatically handling the differences between storage implementations.
///
/// Copied from [StorageService].
class StorageServiceFamily extends Family<StorageServiceState> {
  /// Service responsible for managing file storage operations within a vault profile.
  ///
  /// This service provides functionality to:
  /// - List files and folders in a directory
  /// - Create, rename, and delete folders
  /// - Upload and delete files
  /// - Access file content
  /// - Manage shared storage
  ///
  /// The service supports both VFS (cloud-based) and Edge (local) storage types,
  /// automatically handling the differences between storage implementations.
  ///
  /// Copied from [StorageService].
  const StorageServiceFamily();

  /// Service responsible for managing file storage operations within a vault profile.
  ///
  /// This service provides functionality to:
  /// - List files and folders in a directory
  /// - Create, rename, and delete folders
  /// - Upload and delete files
  /// - Access file content
  /// - Manage shared storage
  ///
  /// The service supports both VFS (cloud-based) and Edge (local) storage types,
  /// automatically handling the differences between storage implementations.
  ///
  /// Copied from [StorageService].
  StorageServiceProvider call({
    required String? parentNodeId,
    required String profileId,
  }) {
    return StorageServiceProvider(
      parentNodeId: parentNodeId,
      profileId: profileId,
    );
  }

  @override
  StorageServiceProvider getProviderOverride(
    covariant StorageServiceProvider provider,
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
  String? get name => r'storageServiceProvider';
}

/// Service responsible for managing file storage operations within a vault profile.
///
/// This service provides functionality to:
/// - List files and folders in a directory
/// - Create, rename, and delete folders
/// - Upload and delete files
/// - Access file content
/// - Manage shared storage
///
/// The service supports both VFS (cloud-based) and Edge (local) storage types,
/// automatically handling the differences between storage implementations.
///
/// Copied from [StorageService].
class StorageServiceProvider extends AutoDisposeNotifierProviderImpl<
    StorageService, StorageServiceState> {
  /// Service responsible for managing file storage operations within a vault profile.
  ///
  /// This service provides functionality to:
  /// - List files and folders in a directory
  /// - Create, rename, and delete folders
  /// - Upload and delete files
  /// - Access file content
  /// - Manage shared storage
  ///
  /// The service supports both VFS (cloud-based) and Edge (local) storage types,
  /// automatically handling the differences between storage implementations.
  ///
  /// Copied from [StorageService].
  StorageServiceProvider({
    required String? parentNodeId,
    required String profileId,
  }) : this._internal(
          () => StorageService()
            ..parentNodeId = parentNodeId
            ..profileId = profileId,
          from: storageServiceProvider,
          name: r'storageServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$storageServiceHash,
          dependencies: StorageServiceFamily._dependencies,
          allTransitiveDependencies:
              StorageServiceFamily._allTransitiveDependencies,
          parentNodeId: parentNodeId,
          profileId: profileId,
        );

  StorageServiceProvider._internal(
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
  StorageServiceState runNotifierBuild(
    covariant StorageService notifier,
  ) {
    return notifier.build(
      parentNodeId: parentNodeId,
      profileId: profileId,
    );
  }

  @override
  Override overrideWith(StorageService Function() create) {
    return ProviderOverride(
      origin: this,
      override: StorageServiceProvider._internal(
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
  AutoDisposeNotifierProviderElement<StorageService, StorageServiceState>
      createElement() {
    return _StorageServiceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StorageServiceProvider &&
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
mixin StorageServiceRef on AutoDisposeNotifierProviderRef<StorageServiceState> {
  /// The parameter `parentNodeId` of this provider.
  String? get parentNodeId;

  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _StorageServiceProviderElement extends AutoDisposeNotifierProviderElement<
    StorageService, StorageServiceState> with StorageServiceRef {
  _StorageServiceProviderElement(super.provider);

  @override
  String? get parentNodeId => (origin as StorageServiceProvider).parentNodeId;
  @override
  String get profileId => (origin as StorageServiceProvider).profileId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
