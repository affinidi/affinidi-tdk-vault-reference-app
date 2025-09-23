import 'package:flutter/foundation.dart';

/// Enum representing different types of profiles that can be created
enum ProfileType {
  /// Affinidi Cloud profile - stores data in the cloud
  affinidiCloud('affinidi_cloud', 'Affinidi Cloud'),

  /// Edge profile - stores data locally using Drift database
  edge('edge', 'Edge');

  const ProfileType(this.value, this.displayName);

  final String value;
  final String displayName;

  /// Get ProfileType from string value
  static ProfileType fromValue(String value) {
    return ProfileType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => ProfileType.affinidiCloud,
    );
  }

  bool get isCloudBased => this == ProfileType.affinidiCloud;

  bool get isLocal => this == ProfileType.edge;

  /// Get the storage type description
  String get storageDescription {
    switch (this) {
      case ProfileType.affinidiCloud:
        return 'Cloud Storage';
      case ProfileType.edge:
        return kIsWeb
            ? 'Local Storage (WASM/IndexedDB)'
            : 'Local Storage (Drift)';
    }
  }
}
