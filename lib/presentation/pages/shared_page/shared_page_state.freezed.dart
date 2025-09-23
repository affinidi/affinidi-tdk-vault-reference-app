// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shared_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SharedPageState {
  bool get isLoading => throw _privateConstructorUsedError;
  List<SharedStorage> get sharedStorages => throw _privateConstructorUsedError;
  String? get selectedProfileId => throw _privateConstructorUsedError;
  Map<String, List<dynamic>> get sharedFiles => throw _privateConstructorUsedError;

  /// Create a copy of SharedPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SharedPageStateCopyWith<SharedPageState> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SharedPageStateCopyWith<$Res> {
  factory $SharedPageStateCopyWith(SharedPageState value, $Res Function(SharedPageState) then) =
      _$SharedPageStateCopyWithImpl<$Res, SharedPageState>;
  @useResult
  $Res call(
      {bool isLoading,
      List<SharedStorage> sharedStorages,
      String? selectedProfileId,
      Map<String, List<dynamic>> sharedFiles});
}

/// @nodoc
class _$SharedPageStateCopyWithImpl<$Res, $Val extends SharedPageState> implements $SharedPageStateCopyWith<$Res> {
  _$SharedPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SharedPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? sharedStorages = null,
    Object? selectedProfileId = freezed,
    Object? sharedFiles = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      sharedStorages: null == sharedStorages
          ? _value.sharedStorages
          : sharedStorages // ignore: cast_nullable_to_non_nullable
              as List<SharedStorage>,
      selectedProfileId: freezed == selectedProfileId
          ? _value.selectedProfileId
          : selectedProfileId // ignore: cast_nullable_to_non_nullable
              as String?,
      sharedFiles: null == sharedFiles
          ? _value.sharedFiles
          : sharedFiles // ignore: cast_nullable_to_non_nullable
              as Map<String, List<dynamic>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SharedPageStateImplCopyWith<$Res> implements $SharedPageStateCopyWith<$Res> {
  factory _$$SharedPageStateImplCopyWith(_$SharedPageStateImpl value, $Res Function(_$SharedPageStateImpl) then) =
      __$$SharedPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      List<SharedStorage> sharedStorages,
      String? selectedProfileId,
      Map<String, List<dynamic>> sharedFiles});
}

/// @nodoc
class __$$SharedPageStateImplCopyWithImpl<$Res> extends _$SharedPageStateCopyWithImpl<$Res, _$SharedPageStateImpl>
    implements _$$SharedPageStateImplCopyWith<$Res> {
  __$$SharedPageStateImplCopyWithImpl(_$SharedPageStateImpl _value, $Res Function(_$SharedPageStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of SharedPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? sharedStorages = null,
    Object? selectedProfileId = freezed,
    Object? sharedFiles = null,
  }) {
    return _then(_$SharedPageStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      sharedStorages: null == sharedStorages
          ? _value._sharedStorages
          : sharedStorages // ignore: cast_nullable_to_non_nullable
              as List<SharedStorage>,
      selectedProfileId: freezed == selectedProfileId
          ? _value.selectedProfileId
          : selectedProfileId // ignore: cast_nullable_to_non_nullable
              as String?,
      sharedFiles: null == sharedFiles
          ? _value._sharedFiles
          : sharedFiles // ignore: cast_nullable_to_non_nullable
              as Map<String, List<dynamic>>,
    ));
  }
}

/// @nodoc

class _$SharedPageStateImpl implements _SharedPageState {
  const _$SharedPageStateImpl(
      {this.isLoading = false,
      final List<SharedStorage> sharedStorages = const [],
      this.selectedProfileId,
      final Map<String, List<dynamic>> sharedFiles = const {}})
      : _sharedStorages = sharedStorages,
        _sharedFiles = sharedFiles;

  @override
  @JsonKey()
  final bool isLoading;
  final List<SharedStorage> _sharedStorages;
  @override
  @JsonKey()
  List<SharedStorage> get sharedStorages {
    if (_sharedStorages is EqualUnmodifiableListView) return _sharedStorages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sharedStorages);
  }

  @override
  final String? selectedProfileId;
  final Map<String, List<dynamic>> _sharedFiles;
  @override
  @JsonKey()
  Map<String, List<dynamic>> get sharedFiles {
    if (_sharedFiles is EqualUnmodifiableMapView) return _sharedFiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_sharedFiles);
  }

  @override
  String toString() {
    return 'SharedPageState(isLoading: $isLoading, sharedStorages: $sharedStorages, selectedProfileId: $selectedProfileId, sharedFiles: $sharedFiles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SharedPageStateImpl &&
            (identical(other.isLoading, isLoading) || other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(other._sharedStorages, _sharedStorages) &&
            (identical(other.selectedProfileId, selectedProfileId) || other.selectedProfileId == selectedProfileId) &&
            const DeepCollectionEquality().equals(other._sharedFiles, _sharedFiles));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, const DeepCollectionEquality().hash(_sharedStorages),
      selectedProfileId, const DeepCollectionEquality().hash(_sharedFiles));

  /// Create a copy of SharedPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SharedPageStateImplCopyWith<_$SharedPageStateImpl> get copyWith =>
      __$$SharedPageStateImplCopyWithImpl<_$SharedPageStateImpl>(this, _$identity);
}

abstract class _SharedPageState implements SharedPageState {
  const factory _SharedPageState(
      {final bool isLoading,
      final List<SharedStorage> sharedStorages,
      final String? selectedProfileId,
      final Map<String, List<dynamic>> sharedFiles}) = _$SharedPageStateImpl;

  @override
  bool get isLoading;
  @override
  List<SharedStorage> get sharedStorages;
  @override
  String? get selectedProfileId;
  @override
  Map<String, List<dynamic>> get sharedFiles;

  /// Create a copy of SharedPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SharedPageStateImplCopyWith<_$SharedPageStateImpl> get copyWith => throw _privateConstructorUsedError;
}
