import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class codeListModel {
  codeListModel();

  bool selected = false;
  String CODE_GRP;
  String CODE;
  String CODE_NM;
  String MEMO = '';
  double ETC_AMT1 = 0.0;
  double ETC_AMT2 = 0.0;
  double ETC_AMT3 = 0.0;
  double ETC_AMT4 = 0.0;
  String ETC_CODE_GBN1 = '';//쿠폰 이미지로고
  String ETC_CODE_GBN3 = '';//쿠폰 배경색
  String ETC_CODE_GBN4 = '';
  String ETC_CODE_GBN5 = '';
  String ETC_CODE_GBN6 = '';
  String ETC_CODE_GBN7 = '';
  String ETC_CODE_GBN8 = '';
  String ETC_CODE_GBN9 = '';
  String ETC_CODE_GBN10 = '';
  String ETC_CODE1; // QR 코드 사용날짜 기한
  String ETC_CODE2; // QR 여부
  String USE_GBN;
  String INS_DATE;
  int INS_UCODE;
  String INS_NAME;
  String MOD_DATE;
  int MOD_UCODE;
  String MOD_NAME;

  factory codeListModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

codeListModel _$ModelFromJson(Map<String, dynamic> json) {
  return codeListModel()
    ..selected = json['selected'] as bool
    ..CODE_GRP = json['CODE_GRP'] as String
    ..CODE = json['CODE'] as String
    ..CODE_NM = json['CODE_NM'] as String
    ..MEMO = json['MEMO'] as String
    ..ETC_AMT1 = json['ETC_AMT1'] as double
    ..ETC_AMT2 = json['ETC_AMT2'] as double
    ..ETC_AMT3 = json['ETC_AMT3'] as double
    ..ETC_AMT4 = json['ETC_AMT4'] as double
    ..ETC_CODE_GBN1 = json['ETC_CODE_GBN1'] as String
    ..ETC_CODE_GBN3 = json['ETC_CODE_GBN3'] as String
    ..ETC_CODE_GBN4 = json['ETC_CODE_GBN4'] as String
    ..ETC_CODE_GBN5 = json['ETC_CODE_GBN5'] as String
    ..ETC_CODE_GBN6 = json['ETC_CODE_GBN6'] as String
    ..ETC_CODE_GBN7 = json['ETC_CODE_GBN7'] as String
    ..ETC_CODE_GBN8 = json['ETC_CODE_GBN8'] as String
    ..ETC_CODE_GBN9 = json['ETC_CODE_GBN9'] as String
    ..ETC_CODE_GBN10 = json['ETC_CODE_GBN10'] as String
    ..ETC_CODE1 = json['ETC_CODE1'] as String
    ..ETC_CODE2 = json['ETC_CODE2'] as String
    ..USE_GBN = json['USE_GBN'] as String
    ..INS_DATE = json['INS_DATE'] as String
    ..INS_UCODE = json['INS_UCODE'] as int
    ..INS_NAME = json['INS_NAME'] as String
    ..MOD_DATE = json['MOD_DATE'] as String
    ..MOD_UCODE = json['MOD_UCODE'] as int
    ..MOD_NAME = json['MOD_NAME'] as String
  ;
}

Map<String, dynamic> _$ModelToJson(codeListModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'CODE_GRP': instance.CODE_GRP,
  'CODE': instance.CODE,
  'CODE_NM': instance.CODE_NM,
  'MEMO': instance.MEMO,
  'ETC_AMT1': instance.ETC_AMT1,
  'ETC_AMT2': instance.ETC_AMT2,
  'ETC_AMT3': instance.ETC_AMT3,
  'ETC_AMT4': instance.ETC_AMT4,
  'ETC_CODE_GBN1': instance.ETC_CODE_GBN1,
  'ETC_CODE_GBN3': instance.ETC_CODE_GBN3,
  'ETC_CODE_GBN4': instance.ETC_CODE_GBN4,
  'ETC_CODE_GBN5': instance.ETC_CODE_GBN5,
  'ETC_CODE_GBN6': instance.ETC_CODE_GBN6,
  'ETC_CODE_GBN7': instance.ETC_CODE_GBN7,
  'ETC_CODE_GBN8': instance.ETC_CODE_GBN8,
  'ETC_CODE_GBN9': instance.ETC_CODE_GBN9,
  'ETC_CODE_GBN10': instance.ETC_CODE_GBN10,
  'ETC_CODE1': instance.ETC_CODE1,
  'ETC_CODE2': instance.ETC_CODE2,
  'USE_GBN': instance.USE_GBN,
  'INS_DATE': instance.INS_DATE,
  'INS_UCODE': instance.INS_UCODE,
  'INS_NAME': instance.INS_NAME,
  'MOD_DATE': instance.MOD_DATE,
  'MOD_UCODE': instance.MOD_UCODE,
  'MOD_NAME': instance.MOD_NAME,
};
