import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
// ignore: camel_case_types
class couponEditModel {
  couponEditModel();

  String couponType;
  String itemType;
  String couponCount;
  String oldStatus;
  String newStatus;
  String jobUcode;
  String jobName;

  factory couponEditModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

couponEditModel _$ModelFromJson(Map<String, dynamic> json) {
  return couponEditModel()
    ..couponType = json['couponType'] as String
    ..itemType = json['itemType'] as String
    ..couponCount = json['couponCount'] as String
    ..oldStatus = json['oldStatus'] as String
    ..newStatus = json['newStatus'] as String
    ..jobUcode = json['jobUcode'] as String
    ..jobName = json['jobName'] as String;
}

Map<String, dynamic> _$ModelToJson(couponEditModel instance) => <String, dynamic>{
  'couponType': instance.couponType,
  'itemType': instance.itemType,
  'couponCount': instance.couponCount,
  'oldStatus': instance.oldStatus,
  'newStatus': instance.newStatus,
  'jobUcode': instance.jobUcode,
  'jobName': instance.jobName,
};
