import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopDivCodeModel {
  ShopDivCodeModel();

  bool selected = false;
  String itemCd;
  String itemName;

  factory ShopDivCodeModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopDivCodeModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopDivCodeModel()
    ..selected = json['selected'] as bool
    ..itemCd = json['itemCd'] as String
    ..itemName = json['itemName'] as String;

}

Map<String, dynamic> _$ModelToJson(ShopDivCodeModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'itemCd': instance.itemCd,
  'itemName': instance.itemName
};