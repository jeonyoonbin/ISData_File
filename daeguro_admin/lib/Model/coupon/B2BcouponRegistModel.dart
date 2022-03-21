import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
// ignore: camel_case_types
class B2BcouponRegistModel {
  B2BcouponRegistModel();

  String telno;
  String couponType;
  String couponNo;
  String status;

  factory B2BcouponRegistModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

B2BcouponRegistModel _$ModelFromJson(Map<String, dynamic> json) {
  return B2BcouponRegistModel()
    ..telno = json['telno'] as String
    ..couponType = json['couponType'] as String
    ..couponNo = json['couponNo'] as String
    ..status = json['status'] as String;
}

Map<String, dynamic> _$ModelToJson(B2BcouponRegistModel instance) => <String, dynamic>{
  'telno': instance.telno,
  'couponType': instance.couponType,
  'couponNo': instance.couponNo,
  'status': instance.status,
};
