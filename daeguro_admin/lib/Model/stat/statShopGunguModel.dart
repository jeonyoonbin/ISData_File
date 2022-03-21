import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class StatShopGunguModel {
  StatShopGunguModel();

  String OPEN_DATE;
  String GUNGU_NAME;
  int COUNT = 0;

  // 날짜 세로로 변경 (v2)
  int A = 0;
  int B = 0;
  int C = 0;
  int D = 0;
  int E = 0;
  int F = 0;
  int G = 0;
  int H = 0;

  factory StatShopGunguModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

StatShopGunguModel _$ModelFromJson(Map<String, dynamic> json) {
  return StatShopGunguModel()
    ..OPEN_DATE = json['OPEN_DATE'] as String
    ..GUNGU_NAME = json['GUNGU_NAME'] as String
    ..COUNT = json['COUNT'] as int
    ..A = json['A'] as int
    ..B = json['B'] as int
    ..C = json['C'] as int
    ..D = json['D'] as int
    ..E = json['E'] as int
    ..F = json['F'] as int
    ..G = json['G'] as int
    ..H = json['H'] as int;
}

Map<String, dynamic> _$ModelToJson(StatShopGunguModel instance) => <String, dynamic>{
  'OPEN_DATE': instance.OPEN_DATE,
  'GUNGU_NAME': instance.GUNGU_NAME,
  'COUNT': instance.COUNT,
  'A': instance.A,
  'B': instance.B,
  'C': instance.C,
  'D': instance.D,
  'E': instance.E,
  'F': instance.F,
  'G': instance.G,
  'H': instance.H,
};
