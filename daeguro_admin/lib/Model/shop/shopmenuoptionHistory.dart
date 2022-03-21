import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopMenuOptionHistoryModel {
  ShopMenuOptionHistoryModel();

  bool selected = false;
  int NO;
  String MOD_TIME;
  String MOD_DESC;

  factory ShopMenuOptionHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopMenuOptionHistoryModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopMenuOptionHistoryModel()
    ..selected = json['selected'] as bool
    ..NO = json['NO'] as int
    ..MOD_TIME = json['MOD_TIME'] as String
    ..MOD_DESC = json['MOD_DESC'] as String;

}

Map<String, dynamic> _$ModelToJson(ShopMenuOptionHistoryModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'NO': instance.NO,
  'MOD_TIME': instance.MOD_TIME,
  'MOD_DESC': instance.MOD_DESC
};