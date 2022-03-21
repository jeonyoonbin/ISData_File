import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopSectorAddressModel {
  ShopSectorAddressModel();

  bool selected = false;
  String sidoName = '';
  String gunGuName = '';
  String dongName;
  String riName;

  factory ShopSectorAddressModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopSectorAddressModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopSectorAddressModel()
    ..selected = json['selected'] as bool
    ..sidoName = json['sidoName'] as String
    ..gunGuName = json['gunGuName'] as String
    ..dongName = json['dongName'] as String
    ..riName = json['riName'] as String;

}

Map<String, dynamic> _$ModelToJson(ShopSectorAddressModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'sidoName': instance.sidoName,
  'gunGuName': instance.gunGuName,
  'dongName': instance.dongName,
  'riName': instance.riName
};