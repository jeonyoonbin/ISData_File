import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopNewModel {
  ShopNewModel({this.tabName, this.isSaved});

  bool selected = false;
  String tabName;
  String ccCode;
  String shopCode;
  bool isSaved = false;


  factory ShopNewModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopNewModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopNewModel()
    ..selected = json['selected'] as bool
    ..tabName = json['tabName'] as String
    ..ccCode = json['ccCode'] as String
    ..shopCode = json['shopCode'] as String
    ..isSaved = json['isSaved'] as bool;

}

Map<String, dynamic> _$ModelToJson(ShopNewModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'tabName': instance.tabName,
  'ccCode': instance.ccCode,
  'shopCode': instance.shopCode,
  'isSaved': instance.isSaved
};