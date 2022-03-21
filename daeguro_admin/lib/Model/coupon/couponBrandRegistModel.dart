import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
// ignore: camel_case_types
class couponBrandRegistModel {
  couponBrandRegistModel();

  String couponType;
  String couponCount;
  String chainCode;
  String startDate;
  String endDate;
  String isdAmt;
  String insertUcode;
  String insertName;

  factory couponBrandRegistModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

couponBrandRegistModel _$ModelFromJson(Map<String, dynamic> json) {
  return couponBrandRegistModel()
    ..couponType = json['couponType'] as String
    ..couponCount = json['couponCount'] as String
    ..chainCode = json['chainCode'] as String
    ..startDate = json['startDate'] as String
    ..endDate = json['endDate'] as String
    ..isdAmt = json['isdAmt'] as String
    ..insertUcode = json['insertUcode'] as String
    ..insertName = json['insertName'] as String;
}

Map<String, dynamic> _$ModelToJson(couponBrandRegistModel instance) => <String, dynamic>{
  'couponType': instance.couponType,
  'couponCount': instance.couponCount,
  'chainCode': instance.chainCode,
  'startDate': instance.startDate,
  'endDate': instance.endDate,
  'isdAmt': instance.isdAmt,
  'insertUcode': instance.insertUcode,
  'insertName': instance.insertName,
};
