import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
// ignore: camel_case_types
class mileageInOutModel {
  mileageInOutModel();

  String RNUM;
  int MCODE = 0;
  String MNAME;
  String CUST_GBN;
  String CUST_GBN_NM;
  int CUST_CODE = 0;
  String CUST_NAME;
  int CUST_MILEAGE = 0;
  int LOG_CUST_MILEAGE = 0;
  int IN_CNT = 0;
  int IN_AMT = 0;
  int ORDER_IN_CNT = 0;
  int ORDER_IN_AMT = 0;
  int SALE_IN_CNT = 0;
  int SALE_IN_AMT = 0;
  int ORDER_OUT_AMT = 0;
  int SALE_OUT_AMT = 0;
  int OUT_AMT = 0;
  int TERMINATE_AMT = 0;
  factory mileageInOutModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

mileageInOutModel _$ModelFromJson(Map<String, dynamic> json) {
  return mileageInOutModel()
    ..RNUM = json['RNUM'] as String
    ..MCODE = json['MCODE'] as int
    ..MNAME = json['MNAME'] as String
    ..CUST_GBN = json['CUST_GBN'] as String
    ..CUST_GBN_NM = json['CUST_GBN_NM'] as String
    ..CUST_CODE = json['CUST_CODE'] as int
    ..CUST_NAME = json['CUST_NAME'] as String
    ..CUST_MILEAGE = json['CUST_MILEAGE'] as int
    ..LOG_CUST_MILEAGE = json['LOG_CUST_MILEAGE'] as int
    ..IN_CNT = json['IN_CNT'] as int
    ..IN_AMT = json['IN_AMT'] as int
    ..ORDER_IN_CNT = json['ORDER_IN_CNT'] as int
    ..ORDER_IN_AMT = json['ORDER_IN_AMT'] as int
    ..SALE_IN_CNT = json['SALE_IN_CNT'] as int
    ..SALE_IN_AMT = json['SALE_IN_AMT'] as int
    ..ORDER_OUT_AMT = json['ORDER_OUT_AMT'] as int
    ..SALE_OUT_AMT = json['SALE_OUT_AMT'] as int
    ..OUT_AMT = json['OUT_AMT'] as int
    ..TERMINATE_AMT = json['TERMINATE_AMT'] as int;
}

Map<String, dynamic> _$ModelToJson(mileageInOutModel instance) => <String, dynamic>{
  'RNUM': instance.RNUM,
  'MCODE': instance.MCODE,
  'MNAME': instance.MNAME,
  'CUST_GBN': instance.CUST_GBN,
  'CUST_GBN_NM': instance.CUST_GBN_NM,
  'CUST_CODE': instance.CUST_CODE,
  'CUST_NAME': instance.CUST_NAME,
  'CUST_MILEAGE': instance.CUST_MILEAGE,
  'LOG_CUST_MILEAGE': instance.LOG_CUST_MILEAGE,
  'IN_CNT': instance.IN_CNT,
  'IN_AMT': instance.IN_AMT,
  'ORDER_IN_CNT': instance.ORDER_IN_CNT,
  'ORDER_IN_AMT': instance.ORDER_IN_AMT,
  'SALE_IN_CNT': instance.SALE_IN_CNT,
  'SALE_IN_AMT': instance.SALE_IN_AMT,
  'ORDER_OUT_AMT': instance.ORDER_OUT_AMT,
  'SALE_OUT_AMT': instance.SALE_OUT_AMT,
  'OUT_AMT': instance.OUT_AMT,
  'TERMINATE_AMT': instance.TERMINATE_AMT,
};