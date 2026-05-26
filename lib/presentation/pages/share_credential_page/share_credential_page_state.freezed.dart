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
  $Res call({String requestJwt, String? clientId});
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
  $Res call({String requestJwt, String? clientId});
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
    ));
  }
}

/// @nodoc

class _$ShareCredentialPageStateImpl implements _ShareCredentialPageState {
  _$ShareCredentialPageStateImpl({required this.requestJwt, this.clientId});

  @override
  final String requestJwt;
  @override
  final String? clientId;

  @override
  String toString() {
    return 'ShareCredentialPageState(requestJwt: $requestJwt, clientId: $clientId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShareCredentialPageStateImpl &&
            (identical(other.requestJwt, requestJwt) ||
                other.requestJwt == requestJwt) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, requestJwt, clientId);

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
      final String? clientId}) = _$ShareCredentialPageStateImpl;

  @override
  String get requestJwt;
  @override
  String? get clientId;

  /// Create a copy of ShareCredentialPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShareCredentialPageStateImplCopyWith<_$ShareCredentialPageStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
