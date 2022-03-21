import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopAccountMenuCompleteModel {
  ShopAccountMenuCompleteModel();

  bool selected = false;

  String SHOP_CD;
  String MENU_COMPLETE;

  factory ShopAccountMenuCompleteModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopAccountMenuCompleteModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopAccountMenuCompleteModel()
      ..selected = json['selected'] as bool
      ..SHOP_CD = json['SHOP_CD'] as String
      ..MENU_COMPLETE = json['MENU_COMPLETE'] as String;
}

Map<String, dynamic> _$ModelToJson(ShopAccountMenuCompleteModel instance) => <String, dynamic> {
  'selected': instance.selected,
  'SHOP_CD': instance.SHOP_CD,
  'MENU_COMPLETE': instance.MENU_COMPLETE
};