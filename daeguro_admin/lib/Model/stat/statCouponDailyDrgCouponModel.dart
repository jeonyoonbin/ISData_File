import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class StatCouponDailyDrgCouponModel {
  StatCouponDailyDrgCouponModel();

  String DAILY;
  int A = 0;
  int A2 = 0;
  int B = 0;
  int B2 = 0;
  int C = 0;
  int C2 = 0;
  int D = 0;
  int D2 = 0;
  int E = 0;
  int E2 = 0;

  factory StatCouponDailyDrgCouponModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

StatCouponDailyDrgCouponModel _$ModelFromJson(Map<String, dynamic> json) {
  return StatCouponDailyDrgCouponModel()
    ..DAILY = json['DAILY'] as String
    ..A = json['A'] as int
    ..A2 = json['A2'] as int
    ..B = json['B'] as int
    ..B2 = json['B2'] as int
    ..C = json['C'] as int
    ..C2 = json['C2'] as int
    ..D = json['D'] as int
    ..D2 = json['D2'] as int
    ..E = json['E'] as int
    ..E2 = json['E2'] as int;
}

Map<String, dynamic> _$ModelToJson(StatCouponDailyDrgCouponModel instance) => <String, dynamic>{
  'DAILY': instance.DAILY,
  'A': instance.A,
  'A2': instance.A2,
  'B': instance.B,
  'B2': instance.B2,
  'C': instance.C,
  'C2': instance.C2,
  'D': instance.D,
  'D2': instance.D2,
  'E': instance.E,
  'E2': instance.E2
};
