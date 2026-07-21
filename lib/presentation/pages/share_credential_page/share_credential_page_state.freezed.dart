// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'share_credential_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ShareCredentialPageState {
  String get requestJwt => throw _privateConstructorUsedError;
  String? get clientId => throw _privateConstructorUsedError;
  ShareFlowStage get stage => throw _privateConstructorUsedError;
  Map<String, OpenVaultParams> get vaultRegistry =>
      throw _privateConstructorUsedError;
  String? get selectedVaultId =>
      throw _privateConstructorUsedError; // null = not yet loaded; [] = loaded but vault has no profiles.
  List<Profile>? get profiles => throw _privateConstructorUsedError;
  String? get selectedProfileId =>
      throw _privateConstructorUsedError; // Parsed and validated OID4VP request — set after validateRequest().
  Oid4vpShareRequest? get shareRequest =>
      throw _privateConstructorUsedError; // Result of matching vault VCs against the request requirements (PEX or DCQL).
  MatchedCredentialsResult? get matchResult =>
      throw _privateConstructorUsedError; // Resolved verifier identity and branding from VerifierMetadataService.
  VerifierClientMetadata? get verifierMetadata =>
      throw _privateConstructorUsedError; // Credential selection.
  Set<String> get selectedCredentialIds => throw _privateConstructorUsedError;
  bool get autoAllowConsent => throw _privateConstructorUsedError;
  bool get isConsentManagementEnabled => throw _privateConstructorUsedError;

  /// Create a copy of ShareCredentialPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShareCredentialPageStateCopyWith<ShareCredentialPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShareCredentialPageStateCopyWith<$Res> {
  factory $ShareCredentialPageStateCopyWith(ShareCredentialPageState value,
          $Res Function(ShareCredentialPageState) then) =
      _$ShareCredentialPageStateCopyWithImpl<$Res, ShareCredentialPageState>;
  @useResult
  $Res call(
      {String requestJwt,
      String? clientId,
      ShareFlowStage stage,
      Map<String, OpenVaultParams> vaultRegistry,
      String? selectedVaultId,
      List<Profile>? profiles,
      String? selectedProfileId,
      Oid4vpShareRequest? shareRequest,
      MatchedCredentialsResult? matchResult,
      VerifierClientMetadata? verifierMetadata,
      Set<String> selectedCredentialIds,
      bool autoAllowConsent,
      bool isConsentManagementEnabled});
}

/// @nodoc
class _$ShareCredentialPageStateCopyWithImpl<$Res,
        $Val extends ShareCredentialPageState>
    implements $ShareCredentialPageStateCopyWith<$Res> {
  _$ShareCredentialPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShareCredentialPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestJwt = null,
    Object? clientId = freezed,
    Object? stage = null,
    Object? vaultRegistry = null,
    Object? selectedVaultId = freezed,
    Object? profiles = freezed,
    Object? selectedProfileId = freezed,
    Object? shareRequest = freezed,
    Object? matchResult = freezed,
    Object? verifierMetadata = freezed,
    Object? selectedCredentialIds = null,
    Object? autoAllowConsent = null,
    Object? isConsentManagementEnabled = null,
  }) {
    return _then(_value.copyWith(
      requestJwt: null == requestJwt
          ? _value.requestJwt
          : requestJwt // ignore: cast_nullable_to_non_nullable
              as String,
      clientId: freezed == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String?,
      stage: null == stage
          ? _value.stage
          : stage // ignore: cast_nullable_to_non_nullable
              as ShareFlowStage,
      vaultRegistry: null == vaultRegistry
          ? _value.vaultRegistry
          : vaultRegistry // ignore: cast_nullable_to_non_nullable
              as Map<String, OpenVaultParams>,
      selectedVaultId: freezed == selectedVaultId
          ? _value.selectedVaultId
          : selectedVaultId // ignore: cast_nullable_to_non_nullable
              as String?,
      profiles: freezed == profiles
          ? _value.profiles
          : profiles // ignore: cast_nullable_to_non_nullable
              as List<Profile>?,
      selectedProfileId: freezed == selectedProfileId
          ? _value.selectedProfileId
          : selectedProfileId // ignore: cast_nullable_to_non_nullable
              as String?,
      shareRequest: freezed == shareRequest
          ? _value.shareRequest
          : shareRequest // ignore: cast_nullable_to_non_nullable
              as Oid4vpShareRequest?,
      matchResult: freezed == matchResult
          ? _value.matchResult
          : matchResult // ignore: cast_nullable_to_non_nullable
              as MatchedCredentialsResult?,
      verifierMetadata: freezed == verifierMetadata
          ? _value.verifierMetadata
          : verifierMetadata // ignore: cast_nullable_to_non_nullable
              as VerifierClientMetadata?,
      selectedCredentialIds: null == selectedCredentialIds
          ? _value.selectedCredentialIds
          : selectedCredentialIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      autoAllowConsent: null == autoAllowConsent
          ? _value.autoAllowConsent
          : autoAllowConsent // ignore: cast_nullable_to_non_nullable
              as bool,
      isConsentManagementEnabled: null == isConsentManagementEnabled
          ? _value.isConsentManagementEnabled
          : isConsentManagementEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShareCredentialPageStateImplCopyWith<$Res>
    implements $ShareCredentialPageStateCopyWith<$Res> {
  factory _$$ShareCredentialPageStateImplCopyWith(
          _$ShareCredentialPageStateImpl value,
          $Res Function(_$ShareCredentialPageStateImpl) then) =
      __$$ShareCredentialPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String requestJwt,
      String? clientId,
      ShareFlowStage stage,
      Map<String, OpenVaultParams> vaultRegistry,
      String? selectedVaultId,
      List<Profile>? profiles,
      String? selectedProfileId,
      Oid4vpShareRequest? shareRequest,
      MatchedCredentialsResult? matchResult,
      VerifierClientMetadata? verifierMetadata,
      Set<String> selectedCredentialIds,
      bool autoAllowConsent,
      bool isConsentManagementEnabled});
}

/// @nodoc
class __$$ShareCredentialPageStateImplCopyWithImpl<$Res>
    extends _$ShareCredentialPageStateCopyWithImpl<$Res,
        _$ShareCredentialPageStateImpl>
    implements _$$ShareCredentialPageStateImplCopyWith<$Res> {
  __$$ShareCredentialPageStateImplCopyWithImpl(
      _$ShareCredentialPageStateImpl _value,
      $Res Function(_$ShareCredentialPageStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShareCredentialPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestJwt = null,
    Object? clientId = freezed,
    Object? stage = null,
    Object? vaultRegistry = null,
    Object? selectedVaultId = freezed,
    Object? profiles = freezed,
    Object? selectedProfileId = freezed,
    Object? shareRequest = freezed,
    Object? matchResult = freezed,
    Object? verifierMetadata = freezed,
    Object? selectedCredentialIds = null,
    Object? autoAllowConsent = null,
    Object? isConsentManagementEnabled = null,
  }) {
    return _then(_$ShareCredentialPageStateImpl(
      requestJwt: null == requestJwt
          ? _value.requestJwt
          : requestJwt // ignore: cast_nullable_to_non_nullable
              as String,
      clientId: freezed == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String?,
      stage: null == stage
          ? _value.stage
          : stage // ignore: cast_nullable_to_non_nullable
              as ShareFlowStage,
      vaultRegistry: null == vaultRegistry
          ? _value._vaultRegistry
          : vaultRegistry // ignore: cast_nullable_to_non_nullable
              as Map<String, OpenVaultParams>,
      selectedVaultId: freezed == selectedVaultId
          ? _value.selectedVaultId
          : selectedVaultId // ignore: cast_nullable_to_non_nullable
              as String?,
      profiles: freezed == profiles
          ? _value._profiles
          : profiles // ignore: cast_nullable_to_non_nullable
              as List<Profile>?,
      selectedProfileId: freezed == selectedProfileId
          ? _value.selectedProfileId
          : selectedProfileId // ignore: cast_nullable_to_non_nullable
              as String?,
      shareRequest: freezed == shareRequest
          ? _value.shareRequest
          : shareRequest // ignore: cast_nullable_to_non_nullable
              as Oid4vpShareRequest?,
      matchResult: freezed == matchResult
          ? _value.matchResult
          : matchResult // ignore: cast_nullable_to_non_nullable
              as MatchedCredentialsResult?,
      verifierMetadata: freezed == verifierMetadata
          ? _value.verifierMetadata
          : verifierMetadata // ignore: cast_nullable_to_non_nullable
              as VerifierClientMetadata?,
      selectedCredentialIds: null == selectedCredentialIds
          ? _value._selectedCredentialIds
          : selectedCredentialIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      autoAllowConsent: null == autoAllowConsent
          ? _value.autoAllowConsent
          : autoAllowConsent // ignore: cast_nullable_to_non_nullable
              as bool,
      isConsentManagementEnabled: null == isConsentManagementEnabled
          ? _value.isConsentManagementEnabled
          : isConsentManagementEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ShareCredentialPageStateImpl implements _ShareCredentialPageState {
  _$ShareCredentialPageStateImpl(
      {required this.requestJwt,
      this.clientId,
      this.stage = const StageValidatingRequest(),
      final Map<String, OpenVaultParams> vaultRegistry = const {},
      this.selectedVaultId,
      final List<Profile>? profiles,
      this.selectedProfileId,
      this.shareRequest,
      this.matchResult,
      this.verifierMetadata,
      final Set<String> selectedCredentialIds = const <String>{},
      this.autoAllowConsent = false,
      this.isConsentManagementEnabled = false})
      : _vaultRegistry = vaultRegistry,
        _profiles = profiles,
        _selectedCredentialIds = selectedCredentialIds;

  @override
  final String requestJwt;
  @override
  final String? clientId;
  @override
  @JsonKey()
  final ShareFlowStage stage;
  final Map<String, OpenVaultParams> _vaultRegistry;
  @override
  @JsonKey()
  Map<String, OpenVaultParams> get vaultRegistry {
    if (_vaultRegistry is EqualUnmodifiableMapView) return _vaultRegistry;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_vaultRegistry);
  }

  @override
  final String? selectedVaultId;
// null = not yet loaded; [] = loaded but vault has no profiles.
  final List<Profile>? _profiles;
// null = not yet loaded; [] = loaded but vault has no profiles.
  @override
  List<Profile>? get profiles {
    final value = _profiles;
    if (value == null) return null;
    if (_profiles is EqualUnmodifiableListView) return _profiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? selectedProfileId;
// Parsed and validated OID4VP request — set after validateRequest().
  @override
  final Oid4vpShareRequest? shareRequest;
// Result of matching vault VCs against the request requirements (PEX or DCQL).
  @override
  final MatchedCredentialsResult? matchResult;
// Resolved verifier identity and branding from VerifierMetadataService.
  @override
  final VerifierClientMetadata? verifierMetadata;
// Credential selection.
  final Set<String> _selectedCredentialIds;
// Credential selection.
  @override
  @JsonKey()
  Set<String> get selectedCredentialIds {
    if (_selectedCredentialIds is EqualUnmodifiableSetView)
      return _selectedCredentialIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedCredentialIds);
  }

  @override
  @JsonKey()
  final bool autoAllowConsent;
  @override
  @JsonKey()
  final bool isConsentManagementEnabled;

  @override
  String toString() {
    return 'ShareCredentialPageState(requestJwt: $requestJwt, clientId: $clientId, stage: $stage, vaultRegistry: $vaultRegistry, selectedVaultId: $selectedVaultId, profiles: $profiles, selectedProfileId: $selectedProfileId, shareRequest: $shareRequest, matchResult: $matchResult, verifierMetadata: $verifierMetadata, selectedCredentialIds: $selectedCredentialIds, autoAllowConsent: $autoAllowConsent, isConsentManagementEnabled: $isConsentManagementEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShareCredentialPageStateImpl &&
            (identical(other.requestJwt, requestJwt) ||
                other.requestJwt == requestJwt) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.stage, stage) || other.stage == stage) &&
            const DeepCollectionEquality()
                .equals(other._vaultRegistry, _vaultRegistry) &&
            (identical(other.selectedVaultId, selectedVaultId) ||
                other.selectedVaultId == selectedVaultId) &&
            const DeepCollectionEquality().equals(other._profiles, _profiles) &&
            (identical(other.selectedProfileId, selectedProfileId) ||
                other.selectedProfileId == selectedProfileId) &&
            (identical(other.shareRequest, shareRequest) ||
                other.shareRequest == shareRequest) &&
            (identical(other.matchResult, matchResult) ||
                other.matchResult == matchResult) &&
            (identical(other.verifierMetadata, verifierMetadata) ||
                other.verifierMetadata == verifierMetadata) &&
            const DeepCollectionEquality()
                .equals(other._selectedCredentialIds, _selectedCredentialIds) &&
            (identical(other.autoAllowConsent, autoAllowConsent) ||
                other.autoAllowConsent == autoAllowConsent) &&
            (identical(other.isConsentManagementEnabled,
                    isConsentManagementEnabled) ||
                other.isConsentManagementEnabled ==
                    isConsentManagementEnabled));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      requestJwt,
      clientId,
      stage,
      const DeepCollectionEquality().hash(_vaultRegistry),
      selectedVaultId,
      const DeepCollectionEquality().hash(_profiles),
      selectedProfileId,
      shareRequest,
      matchResult,
      verifierMetadata,
      const DeepCollectionEquality().hash(_selectedCredentialIds),
      autoAllowConsent,
      isConsentManagementEnabled);

  /// Create a copy of ShareCredentialPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShareCredentialPageStateImplCopyWith<_$ShareCredentialPageStateImpl>
      get copyWith => __$$ShareCredentialPageStateImplCopyWithImpl<
          _$ShareCredentialPageStateImpl>(this, _$identity);
}

abstract class _ShareCredentialPageState implements ShareCredentialPageState {
  factory _ShareCredentialPageState(
      {required final String requestJwt,
      final String? clientId,
      final ShareFlowStage stage,
      final Map<String, OpenVaultParams> vaultRegistry,
      final String? selectedVaultId,
      final List<Profile>? profiles,
      final String? selectedProfileId,
      final Oid4vpShareRequest? shareRequest,
      final MatchedCredentialsResult? matchResult,
      final VerifierClientMetadata? verifierMetadata,
      final Set<String> selectedCredentialIds,
      final bool autoAllowConsent,
      final bool isConsentManagementEnabled}) = _$ShareCredentialPageStateImpl;

  @override
  String get requestJwt;
  @override
  String? get clientId;
  @override
  ShareFlowStage get stage;
  @override
  Map<String, OpenVaultParams> get vaultRegistry;
  @override
  String?
      get selectedVaultId; // null = not yet loaded; [] = loaded but vault has no profiles.
  @override
  List<Profile>? get profiles;
  @override
  String?
      get selectedProfileId; // Parsed and validated OID4VP request — set after validateRequest().
  @override
  Oid4vpShareRequest?
      get shareRequest; // Result of matching vault VCs against the request requirements (PEX or DCQL).
  @override
  MatchedCredentialsResult?
      get matchResult; // Resolved verifier identity and branding from VerifierMetadataService.
  @override
  VerifierClientMetadata? get verifierMetadata; // Credential selection.
  @override
  Set<String> get selectedCredentialIds;
  @override
  bool get autoAllowConsent;
  @override
  bool get isConsentManagementEnabled;

  /// Create a copy of ShareCredentialPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShareCredentialPageStateImplCopyWith<_$ShareCredentialPageStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
