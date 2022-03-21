import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopSaleDayTimeModel {
  ShopSaleDayTimeModel({this.tipdayName, this.tipDay});

  String tipdayName = "";
  String tipDay = "";
  String tipFrStand = "";
  String tipToStand = "";
  String tipNextDay = "N";

  factory ShopSaleDayTimeModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopSaleDayTimeModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopSaleDayTimeModel()
    ..tipDay = json['tipDay'] as String
    ..tipFrStand = json['tipFrStand'] as String
    ..tipToStand = json['tipToStand'] as String
    ..tipNextDay = json['tipNextDay'] as String;
}

Map<String, dynamic> _$ModelToJson(ShopSaleDayTimeModel instance) => <String, dynamic>{
  'tipDay': instance.tipDay,
  'tipFrStand': instance.tipFrStand,
  'tipToStand': instance.tipToStand,
  'tipNextDay': instance.tipNextDay
};