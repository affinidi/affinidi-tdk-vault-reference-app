import 'package:freezed_annotation/freezed_annotation.dart';

part 'error_details.freezed.dart';
part 'error_details.g.dart';

@Freezed(fromJson: true, toJson: false)
class ErrorDetails with _$ErrorDetails {
  factory ErrorDetails({
    String? issue,
    String? field,
    String? value,
  }) = _ErrorDetails;

  factory ErrorDetails.fromJson(Map<String, dynamic> json) =>
      _$ErrorDetailsFromJson(json);
}
