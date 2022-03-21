import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
// ignore: camel_case_types
class couponHistoryModel {
  couponHistoryModel();

  String STATUS;
  int ORDER_NO = 0;
  String COUPON_NAME;
  String COUPON_NO;
  String ORDER_DATE;
  String INS_DATE;
  String ST_DATE;
  String EXP_DATE;
  int COUPON_AMT = 0;
  String SHOP_NAME;

  factory couponHistoryModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

couponHistoryModel _$ModelFromJson(Map<String, dynamic> json) {
  return couponHistoryModel()
    ..STATUS = json['STATUS'] as String
    ..ORDER_NO = json['ORDER_NO'] as int
    ..COUPON_NAME = json['COUPON_NAME'] as String
    ..COUPON_NO = json['COUPON_NO'] as String
    ..ORDER_DATE = json['ORDER_DATE'] as String
    ..INS_DATE = json['INS_DATE'] as String
    ..ST_DATE = json['ST_DATE'] as String
    ..EXP_DATE = json['EXP_DATE'] as String
    ..COUPON_AMT = json['COUPON_AMT'] as int
    ..SHOP_NAME = json['SHOP_NAME'] as String;
}

Map<String, dynamic> _$ModelToJson(couponHistoryModel instance) => <String, dynamic>{
  'STATUS': instance.STATUS,
  'ORDER_NO': instance.ORDER_NO,
  'COUPON_NAME': instance.COUPON_NAME,
  'COUPON_NO': instance.COUPON_NO,
  'ORDER_DATE': instance.ORDER_DATE,
  'INS_DATE': instance.INS_DATE,
  'ST_DATE': instance.ST_DATE,
  'EXP_DATE': instance.EXP_DATE,
  'COUPON_AMT': instance.COUPON_AMT,
  'SHOP_NAME': instance.SHOP_NAME,
};
