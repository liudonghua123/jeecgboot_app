// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Clue _$ClueFromJson(Map<String, dynamic> json) {
  return Clue(
    id: json['id'] as String,
    xsbt: json['xsbt'] as String,
    xsxq: json['xsxq'] as String,
    xsddbh: json['xsddbh'] as String,
    xsddmc: json['xsddmc'] as String,
    cjsj: json['cjsj'] == null ? null : DateTime.parse(json['cjsj'] as String),
    scsj: json['scsj'] == null ? null : DateTime.parse(json['scsj'] as String),
    cjrbh: json['cjrbh'] as String,
    cjbmbh: json['cjbmbh'] as String,
    xslx: json['xslx'] as String,
    fjxx: json['fjxx'] as String,
    wxdj: json['wxdj'] as String,
    tsxq: json['tsxq'] as String,
    htbdbj: json['htbdbj'] as String,
    swsjbh: json['swsjbh'] as String,
    zdasjqbxxbh: json['zdasjqbxxbh'] as String,
    createBy: json['createBy'] as String,
    createTime: json['createTime'] == null
        ? null
        : DateTime.parse(json['createTime'] as String),
    updateBy: json['updateBy'] as String,
    updateTime: json['updateTime'] == null
        ? null
        : DateTime.parse(json['updateTime'] as String),
    rwid: json['rwid'] as String,
    fmmtlj: json['fmmtlj'] as String,
  );
}

Map<String, dynamic> _$ClueToJson(Clue instance) => <String, dynamic>{
      'id': instance.id,
      'xsbt': instance.xsbt,
      'xsxq': instance.xsxq,
      'xsddbh': instance.xsddbh,
      'xsddmc': instance.xsddmc,
      'cjsj': instance.cjsj?.toIso8601String(),
      'scsj': instance.scsj?.toIso8601String(),
      'cjrbh': instance.cjrbh,
      'cjbmbh': instance.cjbmbh,
      'xslx': instance.xslx,
      'fjxx': instance.fjxx,
      'wxdj': instance.wxdj,
      'tsxq': instance.tsxq,
      'htbdbj': instance.htbdbj,
      'swsjbh': instance.swsjbh,
      'zdasjqbxxbh': instance.zdasjqbxxbh,
      'createBy': instance.createBy,
      'createTime': instance.createTime?.toIso8601String(),
      'updateBy': instance.updateBy,
      'updateTime': instance.updateTime?.toIso8601String(),
      'rwid': instance.rwid,
      'fmmtlj': instance.fmmtlj,
    };
