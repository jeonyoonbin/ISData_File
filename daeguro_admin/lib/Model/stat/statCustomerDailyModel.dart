import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class StatCustomerDailyModel {
  StatCustomerDailyModel();

  String REG_DATE;
  String CUST_ID_GBN;
  int COUNT = 0;

  //날짜 세로로 되게 변경 (v2)
  int A = 0; // 공공앱
  int B = 0; // 구글
  int C = 0; // 카카오
  int D = 0; // 네이버
  int E = 0; // 애플
  int F = 0; // 비회원

  factory StatCustomerDailyModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

StatCustomerDailyModel _$ModelFromJson(Map<String, dynamic> json) {
  return StatCustomerDailyModel()
    ..REG_DATE = json['REG_DATE'] as String
    ..CUST_ID_GBN = json['CUST_ID_GBN'] as String
    ..COUNT = json['COUNT'] as int
    ..A = json['A'] as int
    ..B = json['B'] as int
    ..C = json['C'] as int
    ..D = json['D'] as int
    ..E = json['E'] as int
    ..F = json['F'] as int;
}

Map<String, dynamic> _$ModelToJson(StatCustomerDailyModel instance) => <String, dynamic>{
  'REG_DATE': instance.REG_DATE,
  'CUST_ID_GBN': instance.CUST_ID_GBN,
  'COUNT': instance.COUNT,
  'A': instance.A,
  'B': instance.B,
  'C': instance.C,
  'D': instance.D,
  'E': instance.E,
  'F': instance.F,
};
