// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clue_attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClueAttachment _$ClueAttachmentFromJson(Map<String, dynamic> json) {
  return ClueAttachment(
    id: json['id'] as String,
    wjlj: json['wjlj'] as String,
    fjmc: json['fjmc'] as String,
    fjscsj: json['fjscsj'] == null
        ? null
        : DateTime.parse(json['fjscsj'] as String),
    swxsbh: json['swxsbh'] as String,
    scsbbm: json['scsbbm'] as String,
    createBy: json['createBy'] as String,
    createTime: json['createTime'] == null
        ? null
        : DateTime.parse(json['createTime'] as String),
    updateBy: json['updateBy'] as String,
    updateTime: json['updateTime'] == null
        ? null
        : DateTime.parse(json['updateTime'] as String),
  );
}

Map<String, dynamic> _$ClueAttachmentToJson(ClueAttachment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'wjlj': instance.wjlj,
      'fjmc': instance.fjmc,
      'fjscsj': instance.fjscsj?.toIso8601String(),
      'swxsbh': instance.swxsbh,
      'scsbbm': instance.scsbbm,
      'createBy': instance.createBy,
      'createTime': instance.createTime?.toIso8601String(),
      'updateBy': instance.updateBy,
      'updateTime': instance.updateTime?.toIso8601String(),
    };
