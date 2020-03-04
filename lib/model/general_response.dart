import 'package:json_annotation/json_annotation.dart';
part 'general_response.g.dart';

@JsonSerializable()
class GeneralResponse {
  final bool success;
  final String message;
  final int code;
  final dynamic result;
  final int timestamp;

  GeneralResponse(
      this.success, this.message, this.code, this.result, this.timestamp);

  factory GeneralResponse.fromJson(Map<String, dynamic> json) =>
      _$GeneralResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GeneralResponseToJson(this);
}
