import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopEventListModel {
  ShopEventListModel();

  bool selected = false;
  int RNUM;
  String SHOP_CD;
  String SHOP_NAME;
  String INS_DATE;
  String INS_NAME;
  String FROM_TIME;
  String TO_TIME;
  String STATE;
  String EVENT_TITLE_M;

  factory ShopEventListModel.fromJson(Map<String, dynamic> json) => _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopEventListModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopEventListModel()
    ..selected = json['selected'] as bool
    ..RNUM = json['RNUM'] as int
    ..SHOP_CD = json['SHOP_CD'] as String
    ..SHOP_NAME = json['SHOP_NAME'] as String
    ..INS_DATE = json['INS_DATE'] as String
    ..INS_NAME = json['INS_NAME'] as String
    ..FROM_TIME = json['FROM_TIME'] as String
    ..TO_TIME = json['TO_TIME'] as String
    ..STATE = json['STATE'] as String
    ..EVENT_TITLE_M = json['EVENT_TITLE_M'] as String;
}

Map<String, dynamic> _$ModelToJson(ShopEventListModel instance) => <String, dynamic>{
      'selected': instance.selected,
      'RNUM': instance.RNUM,
      'SHOP_CD': instance.SHOP_CD,
      'SHOP_NAME': instance.SHOP_NAME,
      'INS_DATE': instance.INS_DATE,
      'INS_NAME': instance.INS_NAME,
      'FROM_TIME': instance.FROM_TIME,
      'TO_TIME': instance.TO_TIME,
      'STATE': instance.STATE,
      'EVENT_TITLE_M': instance.EVENT_TITLE_M,
    };
