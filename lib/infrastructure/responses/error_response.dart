import 'package:freezed_annotation/freezed_annotation.dart';

import 'error_details.dart';

part 'error_response.freezed.dart';
part 'error_response.g.dart';

@Freezed(fromJson: true, toJson: false)
class ErrorResponse with _$ErrorResponse {
  factory ErrorResponse({
    @Default(ErrorResponseType.other)
    @JsonKey(name: 'name', unknownEnumValue: ErrorResponseType.other)
    ErrorResponseType type,
    required String message,
    @Default([]) List<ErrorDetails> details,
  }) = _ErrorResponse;

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);
}

enum ErrorResponseType {
  @JsonValue('OperationNotAllowedError')
  operationNotAllowed,
  @JsonValue('NodeCreationError')
  nodeCreationError,
  @JsonValue('NodeUpdateError')
  nodeUpdateError,
  other,
  ;
}
