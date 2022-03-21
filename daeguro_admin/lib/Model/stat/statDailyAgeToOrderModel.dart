import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class StatDailyAgeToOrderModel {
  StatDailyAgeToOrderModel();

  String ORDER_DATE;
  // 10대
  int A = 0;
  int A_COMP = 0;
  int A_CANC = 0;

  // 20대
  int B = 0;
  int B_COMP = 0;
  int B_CANC = 0;

  // 30대
  int C = 0;
  int C_COMP = 0;
  int C_CANC = 0;

  // 40대
  int D = 0;
  int D_COMP = 0;
  int D_CANC = 0;

  // 50대
  int E = 0;
  int E_COMP = 0;
  int E_CANC = 0;

  // 60대
  int F = 0;
  int F_COMP = 0;
  int F_CANC = 0;

  // 70대
  int G = 0;
  int G_COMP = 0;
  int G_CANC = 0;

  // 80대
  int H = 0;
  int H_COMP = 0;
  int H_CANC = 0;

  // 90대
  int I = 0;
  int I_COMP = 0;
  int I_CANC = 0;

  factory StatDailyAgeToOrderModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

StatDailyAgeToOrderModel _$ModelFromJson(Map<String, dynamic> json) {
  return StatDailyAgeToOrderModel()
    ..ORDER_DATE = json['ORDER_DATE'] as String
    ..A = json['A'] as int
    ..A_COMP = json['A_COMP'] as int
    ..A_CANC = json['A_CANC'] as int
    ..B = json['B'] as int
    ..B_COMP = json['B_COMP'] as int
    ..B_CANC = json['B_CANC'] as int
    ..C = json['C'] as int
    ..C_COMP = json['C_COMP'] as int
    ..C_CANC = json['C_CANC'] as int
    ..D = json['D'] as int
    ..D_COMP = json['D_COMP'] as int
    ..D_CANC = json['D_CANC'] as int
    ..E = json['E'] as int
    ..E_COMP = json['E_COMP'] as int
    ..E_CANC = json['E_CANC'] as int
    ..F = json['F'] as int
    ..F_COMP = json['F_COMP'] as int
    ..F_CANC = json['F_CANC'] as int
    ..G = json['G'] as int
    ..G_COMP = json['G_COMP'] as int
    ..G_CANC = json['G_CANC'] as int
    ..H = json['H'] as int
    ..H_COMP = json['H_COMP'] as int
    ..H_CANC = json['H_CANC'] as int
    ..I = json['I'] as int
    ..I_COMP = json['I_COMP'] as int
    ..I_CANC = json['I_CANC'] as int;
}

Map<String, dynamic> _$ModelToJson(StatDailyAgeToOrderModel instance) => <String, dynamic>{
  'ORDER_DATE': instance.ORDER_DATE,
  'A': instance.A,
  'A_COMP': instance.A_COMP,
  'A_CANC': instance.A_CANC,
  'B': instance.B,
  'B_COMP': instance.B_COMP,
  'B_CANC': instance.B_CANC,
  'C': instance.C,
  'C_COMP': instance.C_COMP,
  'C_CANC': instance.C_CANC,
  'D': instance.D,
  'D_COMP': instance.D_COMP,
  'D_CANC': instance.D_CANC,
  'E': instance.E,
  'E_COMP': instance.E_COMP,
  'E_CANC': instance.E_CANC,
  'F': instance.F,
  'F_COMP': instance.F_COMP,
  'F_CANC': instance.F_CANC,
  'G': instance.G,
  'G_COMP': instance.G_COMP,
  'G_CANC': instance.G_CANC,
  'H': instance.H,
  'H_COMP': instance.H_COMP,
  'H_CANC': instance.H_CANC,
  'I': instance.I,
  'I_COMP': instance.I_COMP,
  'I_CANC': instance.I_CANC,
};
