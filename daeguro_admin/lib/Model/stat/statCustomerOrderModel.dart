import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class StatCustomerOrderModel {
  StatCustomerOrderModel();

  int DAY_COUNT;
  int ORDER_COUNT = 0;

  factory StatCustomerOrderModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

StatCustomerOrderModel _$ModelFromJson(Map<String, dynamic> json) {
  return StatCustomerOrderModel()
    ..DAY_COUNT = json['DAY_COUNT'] as int
    ..ORDER_COUNT = json['ORDER_COUNT'] as int;
}

Map<String, dynamic> _$ModelToJson(StatCustomerOrderModel instance) => <String, dynamic>{
  'DAY_COUNT': instance.DAY_COUNT,
  'ORDER_COUNT': instance.ORDER_COUNT
};
