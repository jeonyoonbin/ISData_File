import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopEventMenuModel {
  ShopEventMenuModel();

  bool selected = false;
  int RNUM;
  String MENU_NAME;
  int MENU_COST;
  String EVENT_AMT_GBN;
  int EVENT_AMT;
  int DISC_COST;
  String FROM_TIME;
  String TO_TIME;
  String STATE;

  factory ShopEventMenuModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopEventMenuModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopEventMenuModel()
    ..selected = json['selected'] as bool
    ..RNUM = json['RNUM'] as int
    ..MENU_NAME = json['MENU_NAME'] as String
    ..MENU_COST = json['MENU_COST'] as int
    ..EVENT_AMT_GBN = json['EVENT_AMT_GBN'] as String
    ..EVENT_AMT = json['EVENT_AMT'] as int
    ..DISC_COST = json['DISC_COST'] as int
    ..FROM_TIME = json['FROM_TIME'] as String
    ..TO_TIME = json['TO_TIME'] as String
    ..STATE = json['STATE'] as String;
}

Map<String, dynamic> _$ModelToJson(ShopEventMenuModel instance) => <String, dynamic> {
  'selected': instance.selected,
  'RNUM': instance.RNUM,
  'MENU_NAME': instance.MENU_NAME,
  'MENU_COST': instance.MENU_COST,
  'EVENT_AMT_GBN': instance.EVENT_AMT_GBN,
  'EVENT_AMT': instance.EVENT_AMT,
  'DISC_COST': instance.DISC_COST,
  'FROM_TIME': instance.FROM_TIME,
  'TO_TIME': instance.TO_TIME,
  'STATE': instance.STATE,
};