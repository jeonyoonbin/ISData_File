import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class DashBoardWeekOrderModel {
  DashBoardWeekOrderModel();

  String ORDER_DATE;
  int COUNT;
  int COMPLETE_COUNT;

  factory DashBoardWeekOrderModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

DashBoardWeekOrderModel _$ModelFromJson(Map<String, dynamic> json) {
  return DashBoardWeekOrderModel()
    ..ORDER_DATE = json['ORDER_DATE'] as String
    ..COUNT = json['COUNT'] as int
    ..COMPLETE_COUNT = json['COMPLETE_COUNT'] as int;
}

Map<String, dynamic> _$ModelToJson(DashBoardWeekOrderModel instance) => <String, dynamic>{
  'ORDER_DATE': instance.ORDER_DATE,
  'COUNT': instance.COUNT,
  'COMPLETE_COUNT': instance.COMPLETE_COUNT
};
