// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directive.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Directive _$DirectiveFromJson(Map<String, dynamic> json) {
  return Directive(
    rwlzbh: json['rwlzbh'] as String,
    // createBy: json['createBy'] as String,
    // createTime: json['createTime'] == null
    //     ? null
    //     : DateTime.parse(json['createTime'] as String),
    // updateBy: json['updateBy'] as String,
    // updateTime: json['updateTime'] == null
    //     ? null
    //     : DateTime.parse(json['updateTime'] as String),
    // sysOrgCode: json['sysOrgCode'] as String,
    lclb: json['lclb'] as String,
    rwlb: json['rwlb'] as String,
    ybh: json['ybh'] as String,
    fqrbh: json['fqrbh'] as String,
    mblx: json['mblx'] as String,
    mbbh: json['mbbh'] as String,
    rwzt: json['rwzt'] as String,
    jsrbh: json['jsrbh'] as String,
    jssj: json['jssj'] == null ? null : DateTime.parse(json['jssj'] as String),
    clyj: json['clyj'] as String,
    cljg: json['cljg'] as String,
    fqbmbh: json['fqbmbh'] as String,
    mbbmbh: json['mbbmbh'] as String,
    bjsj: json['bjsj'] == null ? null : DateTime.parse(json['bjsj'] as String),
    fqsj: json['fqsj'] == null ? null : DateTime.parse(json['fqsj'] as String),
    rwbt: json['rwbt'] as String,
    ygdrk: json['ygdrk'] as String,
    fsyj: json['fsyj'] as String,
    lzfs: json['lzfs'] as String,
    fkjzsj: json['fkjzsj'] == null
        ? null
        : DateTime.parse(json['fkjzsj'] as String),
    fksm: json['fksm'] as String,
    sjfksj: json['sjfksj'] == null
        ? null
        : DateTime.parse(json['sjfksj'] as String),
    fqcs: json['fqcs'] as int,
  );
}

Map<String, dynamic> _$DirectiveToJson(Directive instance) => <String, dynamic>{
      'rwlzbh': instance.rwlzbh,
      // 'createBy': instance.createBy,
      // 'createTime': instance.createTime?.toIso8601String(),
      // 'updateBy': instance.updateBy,
      // 'updateTime': instance.updateTime?.toIso8601String(),
      // 'sysOrgCode': instance.sysOrgCode,
      'lclb': instance.lclb,
      'rwlb': instance.rwlb,
      'ybh': instance.ybh,
      'fqrbh': instance.fqrbh,
      'mblx': instance.mblx,
      'mbbh': instance.mbbh,
      'rwzt': instance.rwzt,
      'jsrbh': instance.jsrbh,
      'jssj': instance.jssj?.toIso8601String(),
      'clyj': instance.clyj,
      'cljg': instance.cljg,
      'fqbmbh': instance.fqbmbh,
      'mbbmbh': instance.mbbmbh,
      'bjsj': instance.bjsj?.toIso8601String(),
      'fqsj': instance.fqsj?.toIso8601String(),
      'rwbt': instance.rwbt,
      'ygdrk': instance.ygdrk,
      'fsyj': instance.fsyj,
      'lzfs': instance.lzfs,
      'fkjzsj': instance.fkjzsj?.toIso8601String(),
      'fksm': instance.fksm,
      'sjfksj': instance.sjfksj?.toIso8601String(),
      'fqcs': instance.fqcs,
    };
