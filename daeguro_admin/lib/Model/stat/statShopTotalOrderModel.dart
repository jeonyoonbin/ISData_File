import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class StatShopTotalOrderModel {
  StatShopTotalOrderModel();

  String ORDER_DATE;
  int CNT = 0;
  int AMT = 0;
  int OK_CNT = 0;
  int OK_AMT = 0;
  int CANCEL_CNT = 0;
  int CANCEL_AMT = 0;
  int SHOP_CONFIRM = 0;
  var COMP_PER;

  factory StatShopTotalOrderModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

StatShopTotalOrderModel _$ModelFromJson(Map<String, dynamic> json) {
  return StatShopTotalOrderModel()
    ..ORDER_DATE = json['ORDER_DATE'] as String
    ..CNT = json['CNT'] as int
    ..AMT = json['AMT'] as int
    ..OK_CNT = json['OK_CNT'] as int
    ..OK_AMT = json['OK_AMT'] as int
    ..CANCEL_CNT = json['CANCEL_CNT'] as int
    ..CANCEL_AMT = json['CANCEL_AMT'] as int
    ..SHOP_CONFIRM = json['SHOP_CONFIRM'] as int
    ..COMP_PER = json['COMP_PER'];
}

Map<String, dynamic> _$ModelToJson(StatShopTotalOrderModel instance) => <String, dynamic>{
  'ORDER_DATE': instance.ORDER_DATE,
  'CNT': instance.CNT,
  'AMT': instance.AMT,
  'OK_CNT': instance.OK_CNT,
  'OK_AMT': instance.OK_AMT,
  'CANCEL_CNT': instance.CANCEL_CNT,
  'CANCEL_AMT': instance.CANCEL_AMT,
  'SHOP_CONFIRM': instance.SHOP_CONFIRM,
  'COMP_PER': instance.COMP_PER
};
