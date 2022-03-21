import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopMenuOptionEditModel {
  ShopMenuOptionEditModel();

  bool selected = false;
  String shopCd;
  String optionGroupCd;
  String optionCd;
  String optionName;
  String optionMemo;
  String cost;
  String useYn;
  String insertName;
  String noFlag;
  String adultOnly;

  factory ShopMenuOptionEditModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopMenuOptionEditModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopMenuOptionEditModel()
    ..selected = json['selected'] as bool
    ..shopCd = json['shopCd'] as String
    ..optionGroupCd = json['optionGroupCd'] as String
    ..optionCd = json['optionCd'] as String
    ..optionName = json['optionName'] as String
    ..optionMemo = json['optionMemo'] as String
    ..cost = json['cost'] as String
    ..useYn = json['useYn'] as String
    ..insertName = json['insertName'] as String
    ..noFlag = json['noFlag'] as String
    ..adultOnly = json['adultOnly'] as String;
}

Map<String, dynamic> _$ModelToJson(ShopMenuOptionEditModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'shopCd': instance.shopCd,
  'optionGroupCd': instance.optionGroupCd,
  'optionCd': instance.optionCd,
  'optionName': instance.optionName,
  'optionMemo': instance.optionMemo,
  'cost': instance.cost,
  'useYn': instance.useYn,
  'insertName': instance.insertName,
  'noFlag': instance.noFlag,
  'adultOnly': instance.adultOnly
};