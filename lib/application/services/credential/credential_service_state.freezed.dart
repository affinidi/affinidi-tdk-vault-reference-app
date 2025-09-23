// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'credential_service_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CredentialServiceState {
  List<DigitalCredential>? get claimedCredentials => throw _privateConstructorUsedError;
  List<String?> get lastEvaluatedItemIdStack => throw _privateConstructorUsedError; // for pagination
  int get currentPageIndex => throw _privateConstructorUsedError;

  /// Create a copy of CredentialServiceState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CredentialServiceStateCopyWith<CredentialServiceState> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CredentialServiceStateCopyWith<$Res> {
  factory $CredentialServiceStateCopyWith(CredentialServiceState value, $Res Function(CredentialServiceState) then) =
      _$CredentialServiceStateCopyWithImpl<$Res, CredentialServiceState>;
  @useResult
  $Res call(
      {List<DigitalCredential>? claimedCredentials, List<String?> lastEvaluatedItemIdStack, int currentPageIndex});
}

/// @nodoc
class _$CredentialServiceStateCopyWithImpl<$Res, $Val extends CredentialServiceState>
    implements $CredentialServiceStateCopyWith<$Res> {
  _$CredentialServiceStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CredentialServiceState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? claimedCredentials = freezed,
    Object? lastEvaluatedItemIdStack = null,
    Object? currentPageIndex = null,
  }) {
    return _then(_value.copyWith(
      claimedCredentials: freezed == claimedCredentials
          ? _value.claimedCredentials
          : claimedCredentials // ignore: cast_nullable_to_non_nullable
              as List<DigitalCredential>?,
      lastEvaluatedItemIdStack: null == lastEvaluatedItemIdStack
          ? _value.lastEvaluatedItemIdStack
          : lastEvaluatedItemIdStack // ignore: cast_nullable_to_non_nullable
              as List<String?>,
      currentPageIndex: null == currentPageIndex
          ? _value.currentPageIndex
          : currentPageIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CredentialServiceStateImplCopyWith<$Res> implements $CredentialServiceStateCopyWith<$Res> {
  factory _$$CredentialServiceStateImplCopyWith(
          _$CredentialServiceStateImpl value, $Res Function(_$CredentialServiceStateImpl) then) =
      __$$CredentialServiceStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<DigitalCredential>? claimedCredentials, List<String?> lastEvaluatedItemIdStack, int currentPageIndex});
}

/// @nodoc
class __$$CredentialServiceStateImplCopyWithImpl<$Res>
    extends _$CredentialServiceStateCopyWithImpl<$Res, _$CredentialServiceStateImpl>
    implements _$$CredentialServiceStateImplCopyWith<$Res> {
  __$$CredentialServiceStateImplCopyWithImpl(
      _$CredentialServiceStateImpl _value, $Res Function(_$CredentialServiceStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of CredentialServiceState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? claimedCredentials = freezed,
    Object? lastEvaluatedItemIdStack = null,
    Object? currentPageIndex = null,
  }) {
    return _then(_$CredentialServiceStateImpl(
      claimedCredentials: freezed == claimedCredentials
          ? _value._claimedCredentials
          : claimedCredentials // ignore: cast_nullable_to_non_nullable
              as List<DigitalCredential>?,
      lastEvaluatedItemIdStack: null == lastEvaluatedItemIdStack
          ? _value._lastEvaluatedItemIdStack
          : lastEvaluatedItemIdStack // ignore: cast_nullable_to_non_nullable
              as List<String?>,
      currentPageIndex: null == currentPageIndex
          ? _value.currentPageIndex
          : currentPageIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$CredentialServiceStateImpl implements _CredentialServiceState {
  _$CredentialServiceStateImpl(
      {final List<DigitalCredential>? claimedCredentials,
      final List<String?> lastEvaluatedItemIdStack = const [],
      this.currentPageIndex = 0})
      : _claimedCredentials = claimedCredentials,
        _lastEvaluatedItemIdStack = lastEvaluatedItemIdStack;

  final List<DigitalCredential>? _claimedCredentials;
  @override
  List<DigitalCredential>? get claimedCredentials {
    final value = _claimedCredentials;
    if (value == null) return null;
    if (_claimedCredentials is EqualUnmodifiableListView) return _claimedCredentials;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String?> _lastEvaluatedItemIdStack;
  @override
  @JsonKey()
  List<String?> get lastEvaluatedItemIdStack {
    if (_lastEvaluatedItemIdStack is EqualUnmodifiableListView) return _lastEvaluatedItemIdStack;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lastEvaluatedItemIdStack);
  }

// for pagination
  @override
  @JsonKey()
  final int currentPageIndex;

  @override
  String toString() {
    return 'CredentialServiceState(claimedCredentials: $claimedCredentials, lastEvaluatedItemIdStack: $lastEvaluatedItemIdStack, currentPageIndex: $currentPageIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CredentialServiceStateImpl &&
            const DeepCollectionEquality().equals(other._claimedCredentials, _claimedCredentials) &&
            const DeepCollectionEquality().equals(other._lastEvaluatedItemIdStack, _lastEvaluatedItemIdStack) &&
            (identical(other.currentPageIndex, currentPageIndex) || other.currentPageIndex == currentPageIndex));
  }

  @override
  int get hashCode => Object.hash(runtimeType, const DeepCollectionEquality().hash(_claimedCredentials),
      const DeepCollectionEquality().hash(_lastEvaluatedItemIdStack), currentPageIndex);

  /// Create a copy of CredentialServiceState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CredentialServiceStateImplCopyWith<_$CredentialServiceStateImpl> get copyWith =>
      __$$CredentialServiceStateImplCopyWithImpl<_$CredentialServiceStateImpl>(this, _$identity);
}

abstract class _CredentialServiceState implements CredentialServiceState {
  factory _CredentialServiceState(
      {final List<DigitalCredential>? claimedCredentials,
      final List<String?> lastEvaluatedItemIdStack,
      final int currentPageIndex}) = _$CredentialServiceStateImpl;

  @override
  List<DigitalCredential>? get claimedCredentials;
  @override
  List<String?> get lastEvaluatedItemIdStack; // for pagination
  @override
  int get currentPageIndex;

  /// Create a copy of CredentialServiceState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CredentialServiceStateImplCopyWith<_$CredentialServiceStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
