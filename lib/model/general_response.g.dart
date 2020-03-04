// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'general_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeneralResponse _$GeneralResponseFromJson(Map<String, dynamic> json) {
  return GeneralResponse(
    json['success'] as bool,
    json['message'] as String,
    json['code'] as int,
    json['result'],
    json['timestamp'] as int,
  );
}

Map<String, dynamic> _$GeneralResponseToJson(GeneralResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'code': instance.code,
      'result': instance.result,
      'timestamp': instance.timestamp,
    };
