import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class DashBoardModel {
  DashBoardModel();

  String imageStatus_0 = '0';
  String imageStatus_1 = '0';
  String imageStatus_2 = '0';
  String imageStatus_3 = '0';
  String imageStatus_4 = '0';
  String totalShopCount = '0';
  String newShopCount = '0';
  String useShopCount = '0';
  String stopShopCount = '0';

  factory DashBoardModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

DashBoardModel _$ModelFromJson(Map<String, dynamic> json) {
  return DashBoardModel()
    ..imageStatus_0 = json['imageStatus_0'] as String
    ..imageStatus_1 = json['imageStatus_1'] as String
    ..imageStatus_2 = json['imageStatus_2'] as String
    ..imageStatus_3 = json['imageStatus_3'] as String
    ..imageStatus_4 = json['imageStatus_4'] as String
    ..totalShopCount = json['totalShopCount'] as String
    ..newShopCount = json['newShopCount'] as String
    ..useShopCount = json['useShopCount'] as String
    ..stopShopCount = json['stopShopCount'] as String;
}

Map<String, dynamic> _$ModelToJson(DashBoardModel instance) => <String, dynamic>{
  'imageStatus_0': instance.imageStatus_0,
  'imageStatus_1': instance.imageStatus_1,
  'imageStatus_2': instance.imageStatus_2,
  'imageStatus_3': instance.imageStatus_3,
  'imageStatus_4': instance.imageStatus_4,
  'totalShopCount': instance.totalShopCount,
  'newShopCount': instance.newShopCount,
  'useShopCount': instance.useShopCount,
  'stopShopCount': instance.stopShopCount
};
