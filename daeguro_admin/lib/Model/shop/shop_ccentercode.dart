import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopCCenterCodeModel {
  ShopCCenterCodeModel();

  bool selected = false;
  String ccCode;
  String ccName;

  factory ShopCCenterCodeModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopCCenterCodeModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopCCenterCodeModel()
    ..selected = json['selected'] as bool
    ..ccCode = json['ccCode'] as String
    ..ccName = json['ccName'] as String;

}

Map<String, dynamic> _$ModelToJson(ShopCCenterCodeModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'ccCode': instance.ccCode,
  'ccName': instance.ccName
};