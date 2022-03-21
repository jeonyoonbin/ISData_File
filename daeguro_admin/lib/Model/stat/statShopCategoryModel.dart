import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class StatShopCategoryModel {
  StatShopCategoryModel();

  String OPEN_DATE;
  String ITEM_NAME;
  int COUNT = 0;

  // 날짜 세로로 변경(v2)
  int A = 0;
  int B = 0;
  int C = 0;
  int D = 0;
  int E = 0;
  int F = 0;
  int G = 0;
  int H = 0;
  int I = 0;
  int J = 0;
  int K = 0;
  int L = 0;
  int M = 0;
  int N = 0;
  int O = 0;
  int P = 0;
  int Q = 0;
  int R = 0;

  factory StatShopCategoryModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

StatShopCategoryModel _$ModelFromJson(Map<String, dynamic> json) {
  return StatShopCategoryModel()
    ..OPEN_DATE = json['OPEN_DATE'] as String
    ..ITEM_NAME = json['ITEM_NAME'] as String
    ..A = json['A'] as int
    ..B = json['B'] as int
    ..C = json['C'] as int
    ..D = json['D'] as int
    ..E = json['E'] as int
    ..F = json['F'] as int
    ..G = json['G'] as int
    ..H = json['H'] as int
    ..I = json['I'] as int
    ..J = json['J'] as int
    ..K = json['K'] as int
    ..L = json['L'] as int
    ..M = json['M'] as int
    ..N = json['N'] as int
    ..O = json['O'] as int
    ..P = json['P'] as int
    ..Q = json['Q'] as int
    ..R = json['R'] as int;
}

Map<String, dynamic> _$ModelToJson(StatShopCategoryModel instance) => <String, dynamic>{
  'OPEN_DATE': instance.OPEN_DATE,
  'ITEM_NAME': instance.ITEM_NAME,
  'COUNT': instance.COUNT,
  'A': instance.A,
  'B': instance.B,
  'C': instance.C,
  'D': instance.D,
  'E': instance.E,
  'F': instance.F,
  'G': instance.G,
  'H': instance.H,
  'I': instance.I,
  'J': instance.J,
  'K': instance.K,
  'L': instance.L,
  'M': instance.M,
  'N': instance.N,
  'O': instance.O,
  'P': instance.P,
  'Q': instance.Q,
  'R': instance.R,
};
