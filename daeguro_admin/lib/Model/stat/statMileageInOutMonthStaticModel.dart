import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class StatMileageInOutMonthStaticModel {
  StatMileageInOutMonthStaticModel();

  String MDATE;
  int COUNT = 0;
  int SUM_CUST_MILEAGE = 0;
  int SUM_LOG_CUST_MILEAGE = 0;
  int SUM_IN_CNT = 0;
  int SUM_IN_AMT = 0;
  int SUM_ORDER_IN_CNT = 0;
  int SUM_ORDER_IN_AMT = 0;
  int SUM_SALE_IN_CNT = 0;
  int SUM_SALE_IN_AMT = 0;
  int SUM_ORDER_OUT_AMT = 0;
  int SUM_SALE_OUT_AMT = 0;
  int SUM_OUT_AMT = 0;
  int SUM_TERMINATE_AMT = 0;


  factory StatMileageInOutMonthStaticModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

StatMileageInOutMonthStaticModel _$ModelFromJson(Map<String, dynamic> json) {
  return StatMileageInOutMonthStaticModel()
    ..MDATE = json['MDATE'] as String
    ..COUNT = json['COUNT'] as int
    ..SUM_CUST_MILEAGE = json['SUM_CUST_MILEAGE'] as int
    ..SUM_LOG_CUST_MILEAGE = json['SUM_LOG_CUST_MILEAGE'] as int
    ..SUM_IN_CNT = json['SUM_IN_CNT'] as int
    ..SUM_IN_AMT = json['SUM_IN_AMT'] as int
    ..SUM_ORDER_IN_CNT = json['SUM_ORDER_IN_CNT'] as int
    ..SUM_ORDER_IN_AMT = json['SUM_ORDER_IN_AMT'] as int
    ..SUM_SALE_IN_CNT = json['SUM_SALE_IN_CNT'] as int
    ..SUM_SALE_IN_AMT = json['SUM_SALE_IN_AMT'] as int
    ..SUM_ORDER_OUT_AMT = json['SUM_ORDER_OUT_AMT'] as int
    ..SUM_SALE_OUT_AMT = json['SUM_SALE_OUT_AMT'] as int
    ..SUM_OUT_AMT = json['SUM_OUT_AMT'] as int
    ..SUM_TERMINATE_AMT = json['SUM_TERMINATE_AMT'] as int;
}

Map<String, dynamic> _$ModelToJson(StatMileageInOutMonthStaticModel instance) => <String, dynamic>{
  'MDATE': instance.MDATE,
  'COUNT': instance.COUNT,
  'SUM_CUST_MILEAGE': instance.SUM_CUST_MILEAGE,
  'SUM_LOG_CUST_MILEAGE': instance.SUM_LOG_CUST_MILEAGE,
  'SUM_IN_CNT': instance.SUM_IN_CNT,
  'SUM_IN_AMT': instance.SUM_IN_AMT,
  'SUM_ORDER_IN_CNT': instance.SUM_ORDER_IN_CNT,
  'SUM_ORDER_IN_AMT': instance.SUM_ORDER_IN_AMT,
  'SUM_SALE_IN_CNT': instance.SUM_SALE_IN_CNT,
  'SUM_SALE_IN_AMT': instance.SUM_SALE_IN_AMT,
  'SUM_ORDER_OUT_AMT': instance.SUM_ORDER_OUT_AMT,
  'SUM_SALE_OUT_AMT': instance.SUM_SALE_OUT_AMT,
  'SUM_OUT_AMT': instance.SUM_OUT_AMT,
  'SUM_TERMINATE_AMT': instance.SUM_TERMINATE_AMT,
};
