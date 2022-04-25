import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
// ignore: camel_case_types
class taxiCouponEditModel {
  taxiCouponEditModel();

  String couponType;
  String itemType;
  String couponCount;
  String oldStatus;
  String newStatus;
  String jobUcode;
  String jobName;
  String service;

  factory taxiCouponEditModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

taxiCouponEditModel _$ModelFromJson(Map<String, dynamic> json) {
  return taxiCouponEditModel()
    ..couponType = json['couponType'] as String
    ..itemType = json['itemType'] as String
    ..couponCount = json['couponCount'] as String
    ..oldStatus = json['oldStatus'] as String
    ..newStatus = json['newStatus'] as String
    ..jobUcode = json['jobUcode'] as String
    ..jobName = json['jobName'] as String
    ..service = json['service'] as String;
}

Map<String, dynamic> _$ModelToJson(taxiCouponEditModel instance) => <String, dynamic>{
  'couponType': instance.couponType,
  'itemType': instance.itemType,
  'couponCount': instance.couponCount,
  'oldStatus': instance.oldStatus,
  'newStatus': instance.newStatus,
  'jobUcode': instance.jobUcode,
  'jobName': instance.jobName,
  'service': instance.service,
};
