import 'package:json_annotation/json_annotation.dart';
part 'clue_attachment.g.dart';

@JsonSerializable()
class ClueAttachment {
  /// id
  final String id;

  /// 文件路劲
  final String wjlj;

  /// 附件名称
  final String fjmc;

  /// 附件上传时间
  final DateTime fjscsj;
  
  /// 线索主键
  final String swxsbh;

  /// 上传设备编码
  final String scsbbm;

  /// 创建人登录名称
  final String createBy;

  /// 创建日期
  final DateTime createTime;

  /// 更新人登录名称
  final String updateBy;

  /// 更新日期
  final DateTime updateTime;

  ClueAttachment(
      {this.id,
      this.wjlj,
      this.fjmc,
      this.fjscsj,
      this.swxsbh,
      this.scsbbm,
      this.createBy,
      this.createTime,
      this.updateBy,
      this.updateTime});

  factory ClueAttachment.fromJson(Map<String, dynamic> json) =>
      _$ClueAttachmentFromJson(json);

  Map<String, dynamic> toJson() => _$ClueAttachmentToJson(this);
}
