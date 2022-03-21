import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class StatOrderCategoryModel {
  StatOrderCategoryModel();

  String ITEM_CD;
  int COUNT = 0;
  int MENU_AMT = 0;
  int DELI_TIP_AMT = 0;
  int DISC_USE_AMT = 0;

  factory StatOrderCategoryModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

StatOrderCategoryModel _$ModelFromJson(Map<String, dynamic> json) {
  return StatOrderCategoryModel()
    ..ITEM_CD = json['ITEM_CD'] as String
    ..COUNT = json['COUNT'] as int
    ..MENU_AMT = json['MENU_AMT'] as int
    ..DELI_TIP_AMT = json['DELI_TIP_AMT'] as int
    ..DISC_USE_AMT = json['DISC_USE_AMT'] as int;
}

Map<String, dynamic> _$ModelToJson(StatOrderCategoryModel instance) => <String, dynamic>{
  'ITEM_CD': instance.ITEM_CD,
  'COUNT': instance.COUNT,
  'MENU_AMT': instance.MENU_AMT,
  'DELI_TIP_AMT': instance.DELI_TIP_AMT,
  'DISC_USE_AMT': instance.DISC_USE_AMT
};
