import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopSectorInfoModel {
  ShopSectorInfoModel();

  bool selected = false;
  String siguName;
  String dongName;

  factory ShopSectorInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopSectorInfoModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopSectorInfoModel()
    ..selected = json['selected'] as bool
    ..siguName = json['siguName'] as String
    ..dongName = json['dongName'] as String;

}

Map<String, dynamic> _$ModelToJson(ShopSectorInfoModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'siguName': instance.siguName,
  'dongName': instance.dongName
};