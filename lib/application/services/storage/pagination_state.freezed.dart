// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pagination_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaginationState _$PaginationStateFromJson(Map<String, dynamic> json) {
  return _PaginationState.fromJson(json);
}

/// @nodoc
mixin _$PaginationState {
  List<String?> get lastEvaluatedItemIdStack =>
      throw _privateConstructorUsedError;
  int get currentPageIndex => throw _privateConstructorUsedError;

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginationStateCopyWith<PaginationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationStateCopyWith<$Res> {
  factory $PaginationStateCopyWith(
          PaginationState value, $Res Function(PaginationState) then) =
      _$PaginationStateCopyWithImpl<$Res, PaginationState>;
  @useResult
  $Res call({List<String?> lastEvaluatedItemIdStack, int currentPageIndex});
}

/// @nodoc
class _$PaginationStateCopyWithImpl<$Res, $Val extends PaginationState>
    implements $PaginationStateCopyWith<$Res> {
  _$PaginationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lastEvaluatedItemIdStack = null,
    Object? currentPageIndex = null,
  }) {
    return _then(_value.copyWith(
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
abstract class _$$PaginationStateImplCopyWith<$Res>
    implements $PaginationStateCopyWith<$Res> {
  factory _$$PaginationStateImplCopyWith(_$PaginationStateImpl value,
          $Res Function(_$PaginationStateImpl) then) =
      __$$PaginationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String?> lastEvaluatedItemIdStack, int currentPageIndex});
}

/// @nodoc
class __$$PaginationStateImplCopyWithImpl<$Res>
    extends _$PaginationStateCopyWithImpl<$Res, _$PaginationStateImpl>
    implements _$$PaginationStateImplCopyWith<$Res> {
  __$$PaginationStateImplCopyWithImpl(
      _$PaginationStateImpl _value, $Res Function(_$PaginationStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lastEvaluatedItemIdStack = null,
    Object? currentPageIndex = null,
  }) {
    return _then(_$PaginationStateImpl(
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
@JsonSerializable(createToJson: false)
class _$PaginationStateImpl implements _PaginationState {
  const _$PaginationStateImpl(
      {final List<String?> lastEvaluatedItemIdStack = const [],
      this.currentPageIndex = 0})
      : _lastEvaluatedItemIdStack = lastEvaluatedItemIdStack;

  factory _$PaginationStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginationStateImplFromJson(json);

  final List<String?> _lastEvaluatedItemIdStack;
  @override
  @JsonKey()
  List<String?> get lastEvaluatedItemIdStack {
    if (_lastEvaluatedItemIdStack is EqualUnmodifiableListView)
      return _lastEvaluatedItemIdStack;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lastEvaluatedItemIdStack);
  }

  @override
  @JsonKey()
  final int currentPageIndex;

  @override
  String toString() {
    return 'PaginationState(lastEvaluatedItemIdStack: $lastEvaluatedItemIdStack, currentPageIndex: $currentPageIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationStateImpl &&
            const DeepCollectionEquality().equals(
                other._lastEvaluatedItemIdStack, _lastEvaluatedItemIdStack) &&
            (identical(other.currentPageIndex, currentPageIndex) ||
                other.currentPageIndex == currentPageIndex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_lastEvaluatedItemIdStack),
      currentPageIndex);

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginationStateImplCopyWith<_$PaginationStateImpl> get copyWith =>
      __$$PaginationStateImplCopyWithImpl<_$PaginationStateImpl>(
          this, _$identity);
}

abstract class _PaginationState implements PaginationState {
  const factory _PaginationState(
      {final List<String?> lastEvaluatedItemIdStack,
      final int currentPageIndex}) = _$PaginationStateImpl;

  factory _PaginationState.fromJson(Map<String, dynamic> json) =
      _$PaginationStateImpl.fromJson;

  @override
  List<String?> get lastEvaluatedItemIdStack;
  @override
  int get currentPageIndex;

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginationStateImplCopyWith<_$PaginationStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
