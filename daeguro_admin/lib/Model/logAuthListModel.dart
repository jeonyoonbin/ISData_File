import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class logAuthListModel {
  logAuthListModel();

  int NO;
  int ID;
  String NAME;
  String USER_NAME;
  String MEMO;
  String HIST_DATE;
  int MOD_UCODE;
  String MOD_NAME;
  String DIV;


  factory logAuthListModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

logAuthListModel _$ModelFromJson(Map<String, dynamic> json) {
  return logAuthListModel()
    ..NO = json['NO'] as int
    ..ID = json['ID'] as int
    ..NAME = json['NAME'] as String
    ..USER_NAME = json['USER_NAME'] as String
    ..MEMO = json['MEMO'] as String
    ..HIST_DATE = json['HIST_DATE'] as String
    ..MOD_UCODE = json['MOD_UCODE'] as int
    ..MOD_NAME = json['MOD_NAME'] == 'null' ? '' as String : json['MOD_NAME'] as String
    // ..DIV = json['DIV'] == 'D'
    //     ? 'Y' as String
    //     : 'N' as String;
  ;
}

Map<String, dynamic> _$ModelToJson(logAuthListModel instance) => <String, dynamic> {
  'NO': instance.NO,
  'ID': instance.ID,
  'NAME': instance.NAME,
  'USER_NAME': instance.USER_NAME,
  'MEMO': instance.MEMO,
  'HIST_DATE': instance.HIST_DATE,
  'MOD_UCODE': instance.MOD_UCODE,
  'MOD_NAME': instance.MOD_NAME,
  // 'DIV': instance.DIV,
};