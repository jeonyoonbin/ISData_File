import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
// ignore: camel_case_types
class B2BUsercouponDetailModel {
  B2BUsercouponDetailModel();

  int USER_ID;
  String NAME;
  String LOGIN_ID;
  String LOGIN_PWD = '';
  String MOBILE;
  String COUPON_TYPE;
  String REG_DATE;
  int REG_UCODE;
  String MOD_DATE;
  int MOD_UCODE;
  String USE_YN;
  String REG_NAME;
  String MOD_NAME;

  factory B2BUsercouponDetailModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

B2BUsercouponDetailModel _$ModelFromJson(Map<String, dynamic> json) {
  return B2BUsercouponDetailModel()
    ..USER_ID = json['USER_ID'] as int
    ..NAME = json['NAME'] as String
    ..LOGIN_ID = json['LOGIN_ID'] as String
    ..LOGIN_PWD = json['LOGIN_PWD'] as String
    ..MOBILE = json['MOBILE'] as String
    ..COUPON_TYPE = json['COUPON_TYPE'] as String
    ..REG_DATE = json['REG_DATE'] as String
    ..REG_UCODE = json['REG_UCODE'] as int
    ..MOD_DATE = json['MOD_DATE'] as String
    ..MOD_UCODE = json['MOD_UCODE'] as int
    ..USE_YN = json['USE_YN'] as String
    ..REG_NAME = json['REG_NAME'] as String
    ..MOD_NAME = json['MOD_NAME'] as String;
}

Map<String, dynamic> _$ModelToJson(B2BUsercouponDetailModel instance) => <String, dynamic>{
  'USER_ID': instance.USER_ID,
  'NAME': instance.NAME,
  'LOGIN_ID': instance.LOGIN_ID,
  'LOGIN_PWD': instance.LOGIN_PWD,
  'MOBILE': instance.MOBILE,
  'COUPON_TYPE': instance.COUPON_TYPE,
  'REG_DATE': instance.REG_DATE,
  'REG_UCODE': instance.REG_UCODE,
  'MOD_DATE': instance.MOD_DATE,
  'MOD_UCODE': instance.MOD_UCODE,
  'USE_YN': instance.USE_YN,
  'REG_NAME': instance.REG_NAME,
  'MOD_NAME': instance.MOD_NAME
};
