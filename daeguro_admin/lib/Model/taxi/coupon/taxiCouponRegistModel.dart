import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
// ignore: camel_case_types
class taxiCouponRegistModel {
  taxiCouponRegistModel();

  String couponType;
  String itemType;
  String title;
  String expDate;
  String couponCount;
  String isdAmt;
  //String startDate;
  String insertUcode;
  String insertName;
  String service;

  factory taxiCouponRegistModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

taxiCouponRegistModel _$ModelFromJson(Map<String, dynamic> json) {
  return taxiCouponRegistModel()
    ..couponType = json['couponType'] as String
    ..itemType = json['itemType'] as String
    ..title = json['title'] as String
    ..expDate = json['expDate'] as String
    ..couponCount = json['couponCount'] as String
    ..isdAmt = json['isdAmt'] as String
  //..startDate = json['startDate'] as String
    ..insertUcode = json['insertUcode'] as String
    ..insertName = json['insertName'] as String
    ..service = json['service'] as String;
}

Map<String, dynamic> _$ModelToJson(taxiCouponRegistModel instance) => <String, dynamic>{
  'couponType': instance.couponType,
  'itemType': instance.itemType,
  'title': instance.title,
  'expDate': instance.expDate,
  'couponCount': instance.couponCount,
  'isdAmt': instance.isdAmt,
  //'startDate': instance.startDate,
  'insertUcode': instance.insertUcode,
  'insertName': instance.insertName,
  'service': instance.service,
};