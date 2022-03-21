import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class StatShopDailyEventCountModel {
  StatShopDailyEventCountModel();

  String ORDER_DATE;

  // 날짜 세로로 변경
  int COMP_CNT = 0;
  int COMP_SUM = 0;
  int CANC_CNT = 0;
  int CANC_SUM = 0;

  factory StatShopDailyEventCountModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

StatShopDailyEventCountModel _$ModelFromJson(Map<String, dynamic> json) {
  return StatShopDailyEventCountModel()
    ..ORDER_DATE = json['ORDER_DATE'] as String
    ..COMP_CNT = json['COMP_CNT'] as int
    ..COMP_SUM = json['COMP_SUM'] as int
    ..CANC_CNT = json['CANC_CNT'] as int
    ..CANC_SUM = json['CANC_SUM'] as int;
}

Map<String, dynamic> _$ModelToJson(StatShopDailyEventCountModel instance) => <String, dynamic>{
  'ORDER_DATE': instance.ORDER_DATE,
  'COMP_CNT': instance.COMP_CNT,
  'COMP_SUM': instance.COMP_SUM,
  'CANC_CNT': instance.CANC_CNT,
  'CANC_SUM': instance.CANC_SUM,
};
