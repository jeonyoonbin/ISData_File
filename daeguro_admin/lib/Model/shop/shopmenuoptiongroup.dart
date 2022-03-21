import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopMenuOptionGroupModel {
  ShopMenuOptionGroupModel();

  bool boolselected = false;
  String selected;
  String optionGroupCd;
  String optionGroupName;
  String optionNames;
  String useYn;
  bool isFlag = false;

  factory ShopMenuOptionGroupModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopMenuOptionGroupModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopMenuOptionGroupModel()
    ..selected = json['selected'] as String
    ..optionGroupCd = json['optionGroupCd'] as String
    ..optionGroupName = json['optionGroupName'] as String
    ..useYn = json['useYn'] as String
    ..optionNames = json['optionNames'] as String;
}

Map<String, dynamic> _$ModelToJson(ShopMenuOptionGroupModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'optionGroupCd': instance.optionGroupCd,
  'optionGroupName': instance.optionGroupName,
  'useYn': instance.useYn,
  'optionNames': instance.optionNames
};