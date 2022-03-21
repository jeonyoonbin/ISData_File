import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
// ignore: camel_case_types
class mileageSaleInOutModel {
  mileageSaleInOutModel();

  int MCODE = 0;
  String MNAME;
  String MEMO;
  String FR_DATE;
  String TO_DATE;
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

  factory mileageSaleInOutModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

mileageSaleInOutModel _$ModelFromJson(Map<String, dynamic> json) {
  return mileageSaleInOutModel()
    ..MCODE = json['MCODE'] as int
    ..MNAME = json['MNAME'] as String
    ..MEMO = json['MEMO'] as String
    ..FR_DATE = json['FR_DATE'] as String
    ..TO_DATE = json['TO_DATE'] as String
    ..LOG_CUST_MILEAGE = json['LOG_CUST_MILEAGE'] as int
    ..IN_CNT = json['IN_CNT'] as int
    ..IN_AMT = json['IN_AMT'] as int
    ..ORDER_IN_CNT = json['ORDER_IN_CNT'] as int
    ..ORDER_IN_AMT = json['ORDER_IN_AMT'] as int
    ..SALE_IN_CNT = json['SALE_IN_CNT'] as int
    ..SALE_IN_AMT = json['SALE_IN_AMT'] as int
    ..ORDER_OUT_AMT = json['ORDER_OUT_AMT'] as int
    ..SALE_OUT_AMT = json['SALE_OUT_AMT'] as int
    ..OUT_AMT = json['OUT_AMT'] as int;
}

Map<String, dynamic> _$ModelToJson(mileageSaleInOutModel instance) => <String, dynamic>{
  'MCODE': instance.MCODE,
  'MNAME': instance.MNAME,
  'MEMO': instance.MEMO,
  'FR_DATE': instance.FR_DATE,
  'TO_DATE': instance.TO_DATE,
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
};
