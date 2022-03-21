import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class logCouponListModel {
  logCouponListModel();

  bool selected = false;
  String SEQ;
  String TYPE_GBN;
  String DIV;
  String HIST_DATE;
  String POSITION;
  String MSG;
  String INS_UCODE;
  String USER_NAME;
  String PARAMETER;

  factory logCouponListModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

logCouponListModel _$ModelFromJson(Map<String, dynamic> json) {
  return logCouponListModel()
    ..selected = json['selected'] as bool
    ..SEQ = json['SEQ'] as String
    ..TYPE_GBN = json['TYPE_GBN'] as String
    ..DIV = json['DIV'] as String
    ..HIST_DATE = json['HIST_DATE'] as String
    ..POSITION = json['POSITION'] as String
    ..MSG = json['MSG'] as String
    ..INS_UCODE = json['INS_UCODE'] as String
    ..USER_NAME = json['USER_NAME'] as String
    ..PARAMETER = json['PARAMETER'] as String;
}

Map<String, dynamic> _$ModelToJson(logCouponListModel instance) => <String, dynamic> {
  'selected': instance.selected,
  'SEQ': instance.SEQ,
  'TYPE_GBN': instance.TYPE_GBN,
  'DIV': instance.DIV,
  'HIST_DATE': instance.HIST_DATE,
  'POSITION': instance.POSITION,
  'MSG': instance.MSG,
  'INS_UCODE': instance.INS_UCODE,
  'USER_NAME': instance.USER_NAME,
  'PARAMETER': instance.PARAMETER
};