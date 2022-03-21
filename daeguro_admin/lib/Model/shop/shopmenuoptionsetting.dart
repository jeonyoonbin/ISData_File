import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopMenuOptionSettingModel {
  ShopMenuOptionSettingModel();

  String selected;
  String menuOptionGroupCd;
  String optionGroupCd;
  String optionGroupName;
  String optionNames;
  bool isFlag = false;

  factory ShopMenuOptionSettingModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopMenuOptionSettingModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopMenuOptionSettingModel()
    ..selected = json['selected'] as String
    ..menuOptionGroupCd = json['menuOptionGroupCd'] as String
    ..optionGroupCd = json['optionGroupCd'] as String
    ..optionGroupName = json['optionGroupName'] as String
    ..optionNames = json['optionNames'] as String;
}

Map<String, dynamic> _$ModelToJson(ShopMenuOptionSettingModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'menuOptionGroupCd': instance.menuOptionGroupCd,
  'optionGroupCd': instance.optionGroupCd,
  'optionGroupName': instance.optionGroupName,
  'optionNames': instance.optionNames
};