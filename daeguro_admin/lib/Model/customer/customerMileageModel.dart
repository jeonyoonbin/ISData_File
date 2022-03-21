import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class CustomerMileageModel {
  CustomerMileageModel();

  bool selected = false;
  String ORDER_DATE;
  int ORDER_NO;
  String SHOP_NAME;
  String REG_NO;
  String LOG_DATE;
  String LOG_GBN;
  int MILEAGE_AMT;
  String MEMO;

  factory CustomerMileageModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

CustomerMileageModel _$ModelFromJson(Map<String, dynamic> json) {
  return CustomerMileageModel()
    ..selected = json['selected'] as bool
    ..ORDER_DATE = json['ORDER_DATE'] as String
    ..ORDER_NO = json['ORDER_NO'] as int
    ..SHOP_NAME = json['SHOP_NAME'] as String
    ..REG_NO = json['REG_NO'] as String
    ..LOG_DATE = json['LOG_DATE'] as String
    ..LOG_GBN = json['LOG_GBN'] as String
    ..MILEAGE_AMT = json['MILEAGE_AMT'] as int
    ..MEMO = json['MEMO'] as String;
}

Map<String, dynamic> _$ModelToJson(CustomerMileageModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'ORDER_DATE': instance.ORDER_DATE,
  'ORDER_NO': instance.ORDER_NO,
  'SHOP_NAME': instance.SHOP_NAME,
  'REG_NO': instance.REG_NO,
  'LOG_DATE': instance.LOG_DATE,
  'LOG_GBN': instance.LOG_GBN,
  'MILEAGE_AMT': instance.MILEAGE_AMT,
  'MEMO': instance.MEMO
};
