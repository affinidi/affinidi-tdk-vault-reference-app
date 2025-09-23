// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_preview_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FilePreviewPageState {
  Uint8List? get data => throw _privateConstructorUsedError;
  DocumentType? get documentType => throw _privateConstructorUsedError;

  /// Create a copy of FilePreviewPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FilePreviewPageStateCopyWith<FilePreviewPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FilePreviewPageStateCopyWith<$Res> {
  factory $FilePreviewPageStateCopyWith(FilePreviewPageState value,
          $Res Function(FilePreviewPageState) then) =
      _$FilePreviewPageStateCopyWithImpl<$Res, FilePreviewPageState>;
  @useResult
  $Res call({Uint8List? data, DocumentType? documentType});
}

/// @nodoc
class _$FilePreviewPageStateCopyWithImpl<$Res,
        $Val extends FilePreviewPageState>
    implements $FilePreviewPageStateCopyWith<$Res> {
  _$FilePreviewPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FilePreviewPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? documentType = freezed,
  }) {
    return _then(_value.copyWith(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      documentType: freezed == documentType
          ? _value.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as DocumentType?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FilePreviewPageStateImplCopyWith<$Res>
    implements $FilePreviewPageStateCopyWith<$Res> {
  factory _$$FilePreviewPageStateImplCopyWith(_$FilePreviewPageStateImpl value,
          $Res Function(_$FilePreviewPageStateImpl) then) =
      __$$FilePreviewPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Uint8List? data, DocumentType? documentType});
}

/// @nodoc
class __$$FilePreviewPageStateImplCopyWithImpl<$Res>
    extends _$FilePreviewPageStateCopyWithImpl<$Res, _$FilePreviewPageStateImpl>
    implements _$$FilePreviewPageStateImplCopyWith<$Res> {
  __$$FilePreviewPageStateImplCopyWithImpl(_$FilePreviewPageStateImpl _value,
      $Res Function(_$FilePreviewPageStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of FilePreviewPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? documentType = freezed,
  }) {
    return _then(_$FilePreviewPageStateImpl(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      documentType: freezed == documentType
          ? _value.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as DocumentType?,
    ));
  }
}

/// @nodoc

class _$FilePreviewPageStateImpl
    with DiagnosticableTreeMixin
    implements _FilePreviewPageState {
  _$FilePreviewPageStateImpl({this.data, this.documentType});

  @override
  final Uint8List? data;
  @override
  final DocumentType? documentType;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'FilePreviewPageState(data: $data, documentType: $documentType)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'FilePreviewPageState'))
      ..add(DiagnosticsProperty('data', data))
      ..add(DiagnosticsProperty('documentType', documentType));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilePreviewPageStateImpl &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.documentType, documentType) ||
                other.documentType == documentType));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(data), documentType);

  /// Create a copy of FilePreviewPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FilePreviewPageStateImplCopyWith<_$FilePreviewPageStateImpl>
      get copyWith =>
          __$$FilePreviewPageStateImplCopyWithImpl<_$FilePreviewPageStateImpl>(
              this, _$identity);
}

abstract class _FilePreviewPageState implements FilePreviewPageState {
  factory _FilePreviewPageState(
      {final Uint8List? data,
      final DocumentType? documentType}) = _$FilePreviewPageStateImpl;

  @override
  Uint8List? get data;
  @override
  DocumentType? get documentType;

  /// Create a copy of FilePreviewPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FilePreviewPageStateImplCopyWith<_$FilePreviewPageStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
