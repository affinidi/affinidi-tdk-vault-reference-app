// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'storage_service_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$StorageServiceState {
  List<Item> get items => throw _privateConstructorUsedError;
  Map<String, PaginationState> get paginationStates =>
      throw _privateConstructorUsedError; // folderId -> PaginationState
  Uint8List? get fileData => throw _privateConstructorUsedError;

  /// Create a copy of StorageServiceState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StorageServiceStateCopyWith<StorageServiceState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StorageServiceStateCopyWith<$Res> {
  factory $StorageServiceStateCopyWith(
          StorageServiceState value, $Res Function(StorageServiceState) then) =
      _$StorageServiceStateCopyWithImpl<$Res, StorageServiceState>;
  @useResult
  $Res call(
      {List<Item> items,
      Map<String, PaginationState> paginationStates,
      Uint8List? fileData});
}

/// @nodoc
class _$StorageServiceStateCopyWithImpl<$Res, $Val extends StorageServiceState>
    implements $StorageServiceStateCopyWith<$Res> {
  _$StorageServiceStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StorageServiceState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? paginationStates = null,
    Object? fileData = freezed,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Item>,
      paginationStates: null == paginationStates
          ? _value.paginationStates
          : paginationStates // ignore: cast_nullable_to_non_nullable
              as Map<String, PaginationState>,
      fileData: freezed == fileData
          ? _value.fileData
          : fileData // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StorageServiceStateImplCopyWith<$Res>
    implements $StorageServiceStateCopyWith<$Res> {
  factory _$$StorageServiceStateImplCopyWith(_$StorageServiceStateImpl value,
          $Res Function(_$StorageServiceStateImpl) then) =
      __$$StorageServiceStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Item> items,
      Map<String, PaginationState> paginationStates,
      Uint8List? fileData});
}

/// @nodoc
class __$$StorageServiceStateImplCopyWithImpl<$Res>
    extends _$StorageServiceStateCopyWithImpl<$Res, _$StorageServiceStateImpl>
    implements _$$StorageServiceStateImplCopyWith<$Res> {
  __$$StorageServiceStateImplCopyWithImpl(_$StorageServiceStateImpl _value,
      $Res Function(_$StorageServiceStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of StorageServiceState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? paginationStates = null,
    Object? fileData = freezed,
  }) {
    return _then(_$StorageServiceStateImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Item>,
      paginationStates: null == paginationStates
          ? _value._paginationStates
          : paginationStates // ignore: cast_nullable_to_non_nullable
              as Map<String, PaginationState>,
      fileData: freezed == fileData
          ? _value.fileData
          : fileData // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
    ));
  }
}

/// @nodoc

class _$StorageServiceStateImpl
    with DiagnosticableTreeMixin
    implements _StorageServiceState {
  _$StorageServiceStateImpl(
      {final List<Item> items = const [],
      final Map<String, PaginationState> paginationStates = const {},
      this.fileData})
      : _items = items,
        _paginationStates = paginationStates;

  final List<Item> _items;
  @override
  @JsonKey()
  List<Item> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final Map<String, PaginationState> _paginationStates;
  @override
  @JsonKey()
  Map<String, PaginationState> get paginationStates {
    if (_paginationStates is EqualUnmodifiableMapView) return _paginationStates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_paginationStates);
  }

// folderId -> PaginationState
  @override
  final Uint8List? fileData;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'StorageServiceState(items: $items, paginationStates: $paginationStates, fileData: $fileData)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'StorageServiceState'))
      ..add(DiagnosticsProperty('items', items))
      ..add(DiagnosticsProperty('paginationStates', paginationStates))
      ..add(DiagnosticsProperty('fileData', fileData));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StorageServiceStateImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality()
                .equals(other._paginationStates, _paginationStates) &&
            const DeepCollectionEquality().equals(other.fileData, fileData));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      const DeepCollectionEquality().hash(_paginationStates),
      const DeepCollectionEquality().hash(fileData));

  /// Create a copy of StorageServiceState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StorageServiceStateImplCopyWith<_$StorageServiceStateImpl> get copyWith =>
      __$$StorageServiceStateImplCopyWithImpl<_$StorageServiceStateImpl>(
          this, _$identity);
}

abstract class _StorageServiceState implements StorageServiceState {
  factory _StorageServiceState(
      {final List<Item> items,
      final Map<String, PaginationState> paginationStates,
      final Uint8List? fileData}) = _$StorageServiceStateImpl;

  @override
  List<Item> get items;
  @override
  Map<String, PaginationState>
      get paginationStates; // folderId -> PaginationState
  @override
  Uint8List? get fileData;

  /// Create a copy of StorageServiceState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StorageServiceStateImplCopyWith<_$StorageServiceStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
