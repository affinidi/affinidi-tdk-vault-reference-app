// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ErrorResponseImpl _$$ErrorResponseImplFromJson(Map<String, dynamic> json) => _$ErrorResponseImpl(
      type: $enumDecodeNullable(_$ErrorResponseTypeEnumMap, json['name'], unknownValue: ErrorResponseType.other) ??
          ErrorResponseType.other,
      message: json['message'] as String,
      details:
          (json['details'] as List<dynamic>?)?.map((e) => ErrorDetails.fromJson(e as Map<String, dynamic>)).toList() ??
              const [],
    );

const _$ErrorResponseTypeEnumMap = {
  ErrorResponseType.operationNotAllowed: 'OperationNotAllowedError',
  ErrorResponseType.nodeCreationError: 'NodeCreationError',
  ErrorResponseType.nodeUpdateError: 'NodeUpdateError',
  ErrorResponseType.other: 'other',
};
