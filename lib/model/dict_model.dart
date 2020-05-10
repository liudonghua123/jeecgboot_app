import 'package:json_annotation/json_annotation.dart';

part 'dict_model.g.dart';

@JsonSerializable()
class DictModel {
  /// 字典value
  final String value;

  /// 字典文本
  final String text;

  DictModel({this.value, this.text});

  factory DictModel.fromJson(Map<String, dynamic> json) => _$DictModelFromJson(json);

  Map<String, dynamic> toJson() => _$DictModelToJson(this);
}
