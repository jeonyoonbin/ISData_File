import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class StatOrderDailyCancelReasonModel {
  StatOrderDailyCancelReasonModel();

  String ORDER_DATE;
  String CANCEL_CODE;
  int COUNT = 0;
  int COUNT_1 = 0;
  int COUNT_2 = 0;
  int COUNT_3 = 0;
  int COUNT_4 = 0;
  int COUNT_5 = 0;
  int COUNT_6 = 0;
  int COUNT_7 = 0;
  int COUNT_8 = 0;
  int COUNT_9 = 0;
  int COUNT_10 = 0;
  int COUNT_11 = 0;
  int COUNT_12 = 0;
  int COUNT_13 = 0;
  int COUNT_14 = 0;
  int COUNT_SUM = 0;


  factory StatOrderDailyCancelReasonModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

StatOrderDailyCancelReasonModel _$ModelFromJson(Map<String, dynamic> json) {
  return StatOrderDailyCancelReasonModel()
    ..ORDER_DATE = json['ORDER_DATE'] as String
    ..CANCEL_CODE = json['CANCEL_CODE'] as String
    ..COUNT = json['COUNT'] as int;
}

Map<String, dynamic> _$ModelToJson(StatOrderDailyCancelReasonModel instance) => <String, dynamic>{
  'ORDER_DATE': instance.ORDER_DATE,
  'CANCEL_CODE': instance.CANCEL_CODE,
  'COUNT': instance.COUNT,
};
