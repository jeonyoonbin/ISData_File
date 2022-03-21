import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class logTaxListModel {
  logTaxListModel();

  bool selected = false;
  String SEQ;
  String ERROR_GBN;
  String DIV;
  String INS_TIME;
  String POSITION;
  String ERROR_MSG;
  String INS_UCODE;
  String USER_NAME;
  String PARAMETER;

  factory logTaxListModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

logTaxListModel _$ModelFromJson(Map<String, dynamic> json) {
  return logTaxListModel()
    ..selected = json['selected'] as bool
    ..SEQ = json['SEQ'] as String
    ..ERROR_GBN = json['ERROR_GBN'] as String
    ..DIV = json['DIV'] as String
    ..INS_TIME = json['INS_TIME'] as String
    ..POSITION = json['POSITION'] as String
    ..ERROR_MSG = json['ERROR_MSG'] as String
    ..INS_UCODE = json['INS_UCODE'] as String
    ..USER_NAME = json['USER_NAME'] as String
    ..PARAMETER = json['PARAMETER'] as String;
}

Map<String, dynamic> _$ModelToJson(logTaxListModel instance) => <String, dynamic> {
  'selected': instance.selected,
  'SEQ': instance.SEQ,
  'ERROR_GBN': instance.ERROR_GBN,
  'DIV': instance.DIV,
  'INS_TIME': instance.INS_TIME,
  'POSITION': instance.POSITION,
  'ERROR_MSG': instance.ERROR_MSG,
  'INS_UCODE': instance.INS_UCODE,
  'USER_NAME': instance.USER_NAME,
  'PARAMETER': instance.PARAMETER
};