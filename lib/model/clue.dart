import 'package:json_annotation/json_annotation.dart';

part 'clue.g.dart';

@JsonSerializable()
class Clue {
  /// 线索主键
  final String id;

  /// 线索标题
  final String xsbt;

  /// 线索详情
  final String xsxq;

  /// 地址编号
  final String xsddbh;

  /// 地址名称
  final String xsddmc;

  /// 采集时间
  final DateTime cjsj;

  /// 上传时间
  final DateTime scsj;

  /// 采集人编号
  final String cjrbh;

  /// 采集部门编号
  final String cjbmbh;

  /// 线索类型
  final String xslx;

  /// 附加信息
  final String fjxx;

  /// 后台计算结果：危险等级
  final String wxdj;

  /// 后台计算结果：提示详情
  final String tsxq;

  /// 后台比对标记：Y是，N否
  final String htbdbj;

  /// 涉稳事件编号
  final String swsjbh;

  /// 信息编号
  final String zdasjqbxxbh;

  /// 创建人登录名称
  final String createBy;

  /// 创建日期
  final DateTime createTime;

  /// 更新人登录名称
  final String updateBy;

  /// 更新日期
  final DateTime updateTime;

  /// 任务id
  final String rwid;

  /// 封面媒体路劲
  final String fmmtlj;

  /// 手机号
  final String sjh;

  Clue({
    this.id,
    this.xsbt,
    this.xsxq,
    this.xsddbh,
    this.xsddmc,
    this.cjsj,
    this.scsj,
    this.cjrbh,
    this.cjbmbh,
    this.xslx,
    this.fjxx,
    this.wxdj,
    this.tsxq,
    this.htbdbj,
    this.swsjbh,
    this.zdasjqbxxbh,
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.rwid,
    this.fmmtlj,
    this.sjh,
  });

  factory Clue.fromJson(Map<String, dynamic> json) => _$ClueFromJson(json);

  Map<String, dynamic> toJson() => _$ClueToJson(this);
}
