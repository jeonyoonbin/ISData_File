import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopMenuListInfoModel {
  ShopMenuListInfoModel();

  bool selected = false;
  String menuCd;
  String name;
  String cost;
  String aloneOrderYn;
  String mainMenuYn;
  String fileName;
  String useGbn;
  String noFlag;
  String adultOnly;
  String menuEventYn;

  factory ShopMenuListInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopMenuListInfoModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopMenuListInfoModel()
    ..selected = json['selected'] as bool
    ..menuCd = json['menuCd'] as String
    ..name = json['name'] as String
    ..cost = json['cost'] as String
    ..aloneOrderYn = json['aloneOrderYn'] as String
    ..mainMenuYn = json['mainMenuYn'] as String
    ..fileName = json['fileName'] as String
    ..useGbn = json['useGbn'] as String
    ..noFlag = json['noFlag'] as String
    ..adultOnly = json['adultOnly'] as String
    ..menuEventYn = json['menuEventYn'] as String;
}

Map<String, dynamic> _$ModelToJson(ShopMenuListInfoModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'menuCd': instance.menuCd,
  'name': instance.name,
  'cost': instance.cost,
  'aloneOrderYn': instance.aloneOrderYn,
  'mainMenuYn': instance.mainMenuYn,
  'fileName': instance.fileName,
  'useGbn': instance.useGbn,
  'noFlag': instance.noFlag,
  'adultOnly': instance.adultOnly,
  'menuEventYn': instance.menuEventYn
};