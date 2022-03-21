import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopMenuListEditModel {
  ShopMenuListEditModel();

  bool selected = false;
  String shopCd;
  String groupCd;
  String menuCd;
  String menuName;
  String menuCost;
  String menuDesc;
  String useYn;
  String noFlag;
  String aloneOrder;
  String mainYn;
  String insertName;
  String adultOnly;


  factory ShopMenuListEditModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopMenuListEditModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopMenuListEditModel()
    ..selected = json['selected'] as bool
    ..shopCd = json['shopCd'] as String
    ..groupCd = json['groupCd'] as String
    ..menuCd = json['menuCd'] as String
    ..menuName = json['menuName'] as String
    ..menuCost = json['menuCost'] as String
    ..menuDesc = json['menuDesc'] as String
    ..useYn = json['useYn'] as String
    ..noFlag = json['noFlag'] as String
    ..aloneOrder = json['aloneOrder'] as String
    ..mainYn = json['mainYn'] as String
    ..insertName = json['insertName'] as String
    ..adultOnly = json['adultOnly'] as String;
}

Map<String, dynamic> _$ModelToJson(ShopMenuListEditModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'shopCd': instance.shopCd,
  'groupCd': instance.groupCd,
  'menuCd': instance.menuCd,
  'menuName': instance.menuName,
  'menuCost': instance.menuCost,
  'menuDesc': instance.menuDesc,
  'useYn': instance.useYn,
  'noFlag': instance.noFlag,
  'aloneOrder': instance.aloneOrder,
  'mainYn': instance.mainYn,
  'insertName': instance.insertName,
  'adultOnly': instance.adultOnly
};