import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
// ignore: camel_case_types
class couponBrandShopRegistModel {
  couponBrandShopRegistModel();

  String chainCode;
  String couponType;
  String couponName;
  String useMaxCount;
  String useYn;
  String ucode;
  String uname;

  factory couponBrandShopRegistModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

couponBrandShopRegistModel _$ModelFromJson(Map<String, dynamic> json) {
  return couponBrandShopRegistModel()
    ..chainCode = json['chainCode'] as String
    ..couponType = json['couponType'] as String
    ..couponName = json['couponName'] as String
    ..useMaxCount = json['useMaxCount'] as String
    ..useYn = json['useYn'] as String
    ..ucode = json['ucode'] as String
    ..uname = json['uname'] as String;
}

Map<String, dynamic> _$ModelToJson(couponBrandShopRegistModel instance) => <String, dynamic>{
  'chainCode': instance.chainCode,
  'couponType': instance.couponType,
  'couponName': instance.couponName,
  'useMaxCount': instance.useMaxCount,
  'useYn': instance.useYn,
  'ucode': instance.ucode,
  'uname': instance.uname
};
