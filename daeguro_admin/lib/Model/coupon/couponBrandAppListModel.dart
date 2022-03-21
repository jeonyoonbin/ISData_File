import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
// ignore: camel_case_types
class couponBrandAppListModel {
  couponBrandAppListModel();

  String COUPON_NAME;
  String CHAIN_NAME;
  String RNUM;
  String COUPON_TYPE;
  String CHAIN_CODE;
  String ORDER_MIN_AMT;
  String PAY_MIN_AMT;
  String DELIVERY_YN;
  String PACK_YN;
  String DISPLAY_ST_DATE;
  String DISPLAY_EXP_DATE;

  String INS_DATE;
  String INS_UCODE;
  String INS_NAME;
  String MOD_UCODE;
  String MOD_NAME;
  String MOD_DATE;

  String USE_YN;

  factory couponBrandAppListModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

couponBrandAppListModel _$ModelFromJson(Map<String, dynamic> json) {
  return couponBrandAppListModel()
    ..COUPON_NAME = json['COUPON_NAME'] as String
    ..CHAIN_NAME = json['CHAIN_NAME'] as String
    ..RNUM = json['RNUM'] as String
    ..COUPON_TYPE = json['COUPON_TYPE'] as String
    ..CHAIN_CODE = json['CHAIN_CODE'] as String
    ..ORDER_MIN_AMT = json['ORDER_MIN_AMT'] as String
    ..PAY_MIN_AMT = json['PAY_MIN_AMT'] as String
    ..DELIVERY_YN = json['DELIVERY_YN'] as String
    ..PACK_YN = json['PACK_YN'] as String
    ..DISPLAY_ST_DATE = json['DISPLAY_ST_DATE'] as String
    ..DISPLAY_EXP_DATE = json['DISPLAY_EXP_DATE'] as String

    ..INS_DATE = json['INS_DATE'] as String
    ..INS_UCODE = json['INS_UCODE'] as String
    ..INS_NAME = json['INS_NAME'] as String
    ..MOD_UCODE = json['MOD_UCODE'] as String
    ..MOD_NAME = json['MOD_NAME'] as String
    ..MOD_DATE = json['MOD_DATE'] as String

    ..USE_YN = json['USE_YN'] as String;
}

Map<String, dynamic> _$ModelToJson(couponBrandAppListModel instance) => <String, dynamic>{
  'COUPON_NAME': instance.COUPON_NAME,
  'CHAIN_NAME': instance.CHAIN_NAME,
  'RNUM': instance.RNUM,
  'COUPON_TYPE': instance.COUPON_TYPE,
  'CHAIN_CODE': instance.CHAIN_CODE,
  'ORDER_MIN_AMT': instance.ORDER_MIN_AMT,
  'PAY_MIN_AMT': instance.PAY_MIN_AMT,
  'DELIVERY_YN': instance.DELIVERY_YN,
  'PACK_YN': instance.PACK_YN,
  'DISPLAY_ST_DATE': instance.DISPLAY_ST_DATE,
  'DISPLAY_EXP_DATE': instance.DISPLAY_EXP_DATE,

  'INS_DATE': instance.INS_DATE,
  'INS_UCODE': instance.INS_UCODE,
  'INS_NAME': instance.INS_NAME,
  'MOD_UCODE': instance.MOD_UCODE,
  'MOD_NAME': instance.MOD_NAME,
  'MOD_DATE': instance.MOD_DATE,

  'USE_YN': instance.USE_YN,
};
