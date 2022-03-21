import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopDeliTipHistoryModel {
  ShopDeliTipHistoryModel();

  bool selected = false;
  int no;
  String modTime;
  String modDesc;

  factory ShopDeliTipHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopDeliTipHistoryModel _$ModelFromJson(Map<String,dynamic> json) {
  return ShopDeliTipHistoryModel()
      ..selected = json['selected'] as bool
      ..no = json['NO'] as int
      ..modTime = json['MOD_TIME'] as String
      ..modDesc = json['MOD_DESC'] as String;
}

Map<String,dynamic> _$ModelToJson(ShopDeliTipHistoryModel instance) => <String, dynamic> {
  'selected': instance.selected,
  'NO': instance.no,
  'MOD_TIME': instance.modTime,
  'MOD_DESC': instance.modDesc
};