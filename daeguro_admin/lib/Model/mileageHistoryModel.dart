import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
// ignore: camel_case_types
class mileageHistoryModel {
  mileageHistoryModel();

  int ORDER_NO = 0;
  String LOG_DATE;
  String CUST_NAME;
  String CUST_CODE;
  int MILEAGE_AMT = 0;
  int MILEAGE_USE_AMT = 0;
  String SHOP_NAME;
  String MEMO;

  factory mileageHistoryModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

mileageHistoryModel _$ModelFromJson(Map<String, dynamic> json) {
  return mileageHistoryModel()
    ..ORDER_NO = json['ORDER_NO'] as int
    ..LOG_DATE = json['LOG_DATE'] as String
    ..CUST_NAME = json['CUST_NAME'] as String
    ..CUST_CODE = json['CUST_CODE'] as String
    ..MILEAGE_AMT = json['MILEAGE_AMT'] as int
    ..MILEAGE_USE_AMT = json['MILEAGE_USE_AMT'] as int
    ..SHOP_NAME = json['SHOP_NAME'] as String
    ..MEMO = json['MEMO'] as String;
}

Map<String, dynamic> _$ModelToJson(mileageHistoryModel instance) => <String, dynamic>{
  'ORDER_NO': instance.ORDER_NO,
  'LOG_DATE': instance.LOG_DATE,
  'CUST_NAME': instance.CUST_NAME,
  'CUST_CODE': instance.CUST_CODE,
  'MILEAGE_AMT': instance.MILEAGE_AMT,
  'MILEAGE_USE_AMT': instance.MILEAGE_USE_AMT,
  'SHOP_NAME': instance.SHOP_NAME,
  'MEMO': instance.MEMO,
};
