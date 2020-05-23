import 'package:json_annotation/json_annotation.dart';
part 'directive.g.dart';

@JsonSerializable()
class Directive {
  /// 主键
  final String rwlzbh;

  /// 流程类别
  final String lclb;

  /// 任务类别
  final String rwlb;

  /// 信息源编号
  final String ybh;

  /// 发起人编号
  final String fqrbh;

  /// 目标信息类型
  final String mblx;

  /// 目标编号
  final String mbbh;

  /// 任务状态
  final String rwzt;

  /// 接收人编号
  final String jsrbh;

  /// 接收时间,pattern = "yyyy-MM-dd"
  final DateTime jssj;

  /// 处理意见
  final String clyj;

  /// 处理结果
  final String cljg;

  /// 发起部门编号
  final String fqbmbh;

  /// 目标部门编号
  final String mbbmbh;

  /// 办结时间,pattern = "yyyy-MM-dd"
  final DateTime bjsj;

  /// 发起时间,pattern = "yyyy-MM-dd"
  final DateTime fqsj;

  /// 任务标题
  final String rwbt;

  /// 已归档入库（暂时未用到）
  final String ygdrk;

  /// 发送意见
  final String fsyj;

  /// 流转方式（信息流转：XXLZ，人员采集指令：RYCJZL，线索采集指令:XSCJZL）
  final String lzfs;

  /// 反馈截止时间,pattern = "yyyy-MM-dd"
  final DateTime fkjzsj;

  /// 反馈说明
  final String fksm;

  /// 实际反馈时间,pattern = "yyyy-MM-dd"
  final DateTime sjfksj;

  /// 发起参数
  final int fqcs;

  Directive(
      {this.rwlzbh,
      this.lclb,
      this.rwlb,
      this.ybh,
      this.fqrbh,
      this.mblx,
      this.mbbh,
      this.rwzt,
      this.jsrbh,
      this.jssj,
      this.clyj,
      this.cljg,
      this.fqbmbh,
      this.mbbmbh,
      this.bjsj,
      this.fqsj,
      this.rwbt,
      this.ygdrk,
      this.fsyj,
      this.lzfs,
      this.fkjzsj,
      this.fksm,
      this.sjfksj,
      this.fqcs});

  factory Directive.fromJson(Map<String, dynamic> json) =>
      _$DirectiveFromJson(json);

  Map<String, dynamic> toJson() => _$DirectiveToJson(this);
}
