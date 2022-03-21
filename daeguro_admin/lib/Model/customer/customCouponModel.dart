import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class CustomerCouponModel {
  CustomerCouponModel();

  bool selected = false;
  String COUPON_NAME;
  String COUPON_NO;
  String INS_DATE;
  String ST_DATE;
  String USE_DATE;
  String EXP_DATE;
  int COUPON_AMT;
  String STATUS;

  factory CustomerCouponModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

CustomerCouponModel _$ModelFromJson(Map<String, dynamic> json) {
  return CustomerCouponModel()
    ..selected = json['selected'] as bool
    ..COUPON_NAME = json['COUPON_NAME'] as String
    ..COUPON_NO = json['COUPON_NO'] as String
    ..INS_DATE = json['INS_DATE'] as String
    ..ST_DATE = json['ST_DATE'] as String
    ..USE_DATE = json['USE_DATE'] as String
    ..EXP_DATE = json['EXP_DATE'] as String
    ..COUPON_AMT = json['COUPON_AMT'] as int
    ..STATUS = json['STATUS'] as String;
}

Map<String, dynamic> _$ModelToJson(CustomerCouponModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'COUPON_NAME': instance.COUPON_NAME,
  'COUPON_NO': instance.COUPON_NO,
  'INS_DATE': instance.INS_DATE,
  'ST_DATE': instance.ST_DATE,
  'USE_DATE': instance.USE_DATE,
  'EXP_DATE': instance.EXP_DATE,
  'COUPON_AMT': instance.COUPON_AMT,
  'STATUS': instance.STATUS
};
