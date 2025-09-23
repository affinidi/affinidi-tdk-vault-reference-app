// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shared_profile_details_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SharedProfileDetailsPageState {
  bool get isLoading => throw _privateConstructorUsedError;
  List<Item>? get items => throw _privateConstructorUsedError;

  /// Create a copy of SharedProfileDetailsPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SharedProfileDetailsPageStateCopyWith<SharedProfileDetailsPageState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SharedProfileDetailsPageStateCopyWith<$Res> {
  factory $SharedProfileDetailsPageStateCopyWith(
          SharedProfileDetailsPageState value,
          $Res Function(SharedProfileDetailsPageState) then) =
      _$SharedProfileDetailsPageStateCopyWithImpl<$Res,
          SharedProfileDetailsPageState>;
  @useResult
  $Res call({bool isLoading, List<Item>? items});
}

/// @nodoc
class _$SharedProfileDetailsPageStateCopyWithImpl<$Res,
        $Val extends SharedProfileDetailsPageState>
    implements $SharedProfileDetailsPageStateCopyWith<$Res> {
  _$SharedProfileDetailsPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SharedProfileDetailsPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? items = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      items: freezed == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Item>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SharedProfileDetailsPageStateImplCopyWith<$Res>
    implements $SharedProfileDetailsPageStateCopyWith<$Res> {
  factory _$$SharedProfileDetailsPageStateImplCopyWith(
          _$SharedProfileDetailsPageStateImpl value,
          $Res Function(_$SharedProfileDetailsPageStateImpl) then) =
      __$$SharedProfileDetailsPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, List<Item>? items});
}

/// @nodoc
class __$$SharedProfileDetailsPageStateImplCopyWithImpl<$Res>
    extends _$SharedProfileDetailsPageStateCopyWithImpl<$Res,
        _$SharedProfileDetailsPageStateImpl>
    implements _$$SharedProfileDetailsPageStateImplCopyWith<$Res> {
  __$$SharedProfileDetailsPageStateImplCopyWithImpl(
      _$SharedProfileDetailsPageStateImpl _value,
      $Res Function(_$SharedProfileDetailsPageStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of SharedProfileDetailsPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? items = freezed,
  }) {
    return _then(_$SharedProfileDetailsPageStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      items: freezed == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Item>?,
    ));
  }
}

/// @nodoc

class _$SharedProfileDetailsPageStateImpl
    implements _SharedProfileDetailsPageState {
  _$SharedProfileDetailsPageStateImpl(
      {this.isLoading = false, final List<Item>? items})
      : _items = items;

  @override
  @JsonKey()
  final bool isLoading;
  final List<Item>? _items;
  @override
  List<Item>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'SharedProfileDetailsPageState(isLoading: $isLoading, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SharedProfileDetailsPageStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, isLoading, const DeepCollectionEquality().hash(_items));

  /// Create a copy of SharedProfileDetailsPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SharedProfileDetailsPageStateImplCopyWith<
          _$SharedProfileDetailsPageStateImpl>
      get copyWith => __$$SharedProfileDetailsPageStateImplCopyWithImpl<
          _$SharedProfileDetailsPageStateImpl>(this, _$identity);
}

abstract class _SharedProfileDetailsPageState
    implements SharedProfileDetailsPageState {
  factory _SharedProfileDetailsPageState(
      {final bool isLoading,
      final List<Item>? items}) = _$SharedProfileDetailsPageStateImpl;

  @override
  bool get isLoading;
  @override
  List<Item>? get items;

  /// Create a copy of SharedProfileDetailsPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SharedProfileDetailsPageStateImplCopyWith<
          _$SharedProfileDetailsPageStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
