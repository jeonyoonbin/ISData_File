import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class StatCustomerRankOrderModel {
  StatCustomerRankOrderModel();

  int ORDER_COUNT = 0;
  String CUST_NAME;
  String TELNO;

  factory StatCustomerRankOrderModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

StatCustomerRankOrderModel _$ModelFromJson(Map<String, dynamic> json) {
  return StatCustomerRankOrderModel()
    ..ORDER_COUNT = json['ORDER_COUNT'] as int
    ..CUST_NAME = json['CUST_NAME'] as String
    ..TELNO = json['TELNO'] as String;
}

Map<String, dynamic> _$ModelToJson(StatCustomerRankOrderModel instance) => <String, dynamic>{
  'ORDER_COUNT': instance.ORDER_COUNT,
  'CUST_NAME': instance.CUST_NAME,
  'TELNO': instance.TELNO
};
