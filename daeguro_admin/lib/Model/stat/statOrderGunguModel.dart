import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class StatOrderGunguModel {
  StatOrderGunguModel();

  String ORDER_DATE;

  // 날짜 세로로 되도록 수정
  int A;   // 남구
  int B;   // 달서구
  int C;   // 달성군
  int D;   // 동구
  int E;   // 북구
  int F;   // 서구
  int G;   // 수성구
  int H;   // 중구
  int I;   // 포장

  factory StatOrderGunguModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

StatOrderGunguModel _$ModelFromJson(Map<String, dynamic> json) {
  return StatOrderGunguModel()
    ..ORDER_DATE = json['ORDER_DATE'] as String
    ..A = json['A'] as int
    ..B = json['B'] as int
    ..C = json['C'] as int
    ..D = json['D'] as int
    ..E = json['E'] as int
    ..F = json['F'] as int
    ..G = json['G'] as int
    ..H = json['H'] as int
    ..I = json['I'] as int;
}

Map<String, dynamic> _$ModelToJson(StatOrderGunguModel instance) => <String, dynamic>{
  'ORDER_DATE': instance.ORDER_DATE,
  'A': instance.A,
  'B': instance.B,
  'C': instance.C,
  'D': instance.D,
  'E': instance.E,
  'F': instance.F,
  'G': instance.G,
  'H': instance.H,
  'I': instance.I,
};
