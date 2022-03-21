import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class StatOrderPayModel {
  StatOrderPayModel();

  String ORDER_DATE;
  String PAY_GBN;
  int COUNT = 0;

  // 날짜 가로 세로 변경
  int A = 0;  // 만나서 현금
  int B = 0;  // 앱 카드
  int C = 0;  // 행복페이
  int D = 0;  // 만나서카드
  int E = 0;  // 네이버 페이
  int F = 0;  // 합계

  factory StatOrderPayModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

StatOrderPayModel _$ModelFromJson(Map<String, dynamic> json) {
  return StatOrderPayModel()
    ..ORDER_DATE = json['ORDER_DATE'] as String
    ..PAY_GBN = json['PAY_GBN'] as String
    ..COUNT = json['COUNT'] as int
    ..A = json['A'] as int
    ..B = json['B'] as int
    ..C = json['C'] as int
    ..D = json['D'] as int
    ..E = json['E'] as int
    ..F = json['F'] as int;
}

Map<String, dynamic> _$ModelToJson(StatOrderPayModel instance) => <String, dynamic>{
  'ORDER_DATE': instance.ORDER_DATE,
  'PAY_GBN': instance.PAY_GBN,
  'COUNT': instance.COUNT,
  'A': instance.A,
  'B': instance.B,
  'C': instance.C,
  'D': instance.D,
  'E': instance.E,
  'F': instance.F,
};