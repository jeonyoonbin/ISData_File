import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
// ignore: camel_case_types
class B2BcouponHistoryModel {
  B2BcouponHistoryModel();

  String seqNo;
  String couponType;
  String couponNo;
  String histDate;
  String memo;

  factory B2BcouponHistoryModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

B2BcouponHistoryModel _$ModelFromJson(Map<String, dynamic> json) {
  return B2BcouponHistoryModel()
    ..seqNo = json['seqNo'] as String
    ..couponType = json['couponType'] as String
    ..couponNo = json['couponNo'] as String
    ..histDate = json['histDate'] as String
    ..memo = json['memo'] as String;
}

Map<String, dynamic> _$ModelToJson(B2BcouponHistoryModel instance) => <String, dynamic>{
  'seqNo': instance.seqNo,
  'couponType': instance.couponType,
  'couponNo': instance.couponNo,
  'histDate': instance.histDate,
  'memo': instance.memo,
};
