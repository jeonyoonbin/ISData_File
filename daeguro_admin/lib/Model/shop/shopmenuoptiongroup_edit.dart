import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopMenuOptionGroupEditModel {
  ShopMenuOptionGroupEditModel();

  bool selected = false;
  String shopCd;
  String optionGroupCd;
  String optionGroupName;
  String optionGroupMemo;
  String useYn;
  String insertName;
  String minCount = '0';
  String maxCount = '0';
  String multiYn;

  factory ShopMenuOptionGroupEditModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopMenuOptionGroupEditModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopMenuOptionGroupEditModel()
    ..selected = json['selected'] as bool
    ..shopCd = json['shopCd'] as String
    ..optionGroupCd = json['optionGroupCd'] as String
    ..optionGroupName = json['optionGroupName'] as String
    ..optionGroupMemo = json['optionGroupMemo'] as String
    ..useYn = json['useYn'] as String
    ..insertName = json['insertName'] as String
    ..minCount = json['minCount'] as String
    ..maxCount = json['maxCount'] as String
    ..multiYn = json['multiYn'] as String;
}

Map<String, dynamic> _$ModelToJson(ShopMenuOptionGroupEditModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'shopCd': instance.shopCd,
  'optionGroupCd': instance.optionGroupCd,
  'optionGroupName': instance.optionGroupName,
  'optionGroupMemo': instance.optionGroupMemo,
  'useYn': instance.useYn,
  'insertName': instance.insertName,
  'minCount': instance.minCount,
  'maxCount': instance.maxCount,
  'multiYn': instance.multiYn
};