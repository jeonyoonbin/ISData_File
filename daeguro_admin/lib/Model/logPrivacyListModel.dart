import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class logPrivacyListModel {
  logPrivacyListModel();

  bool selected = false;
  int SEQ;
  String UCODE;
  String USER_NAME;
  String LOG_TIME;
  String PID;
  String PNAME;
  String LOG_GBN;
  String POSITION;
  String CONTENT;

  factory logPrivacyListModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

logPrivacyListModel _$ModelFromJson(Map<String, dynamic> json) {
  return logPrivacyListModel()
    ..selected = json['selected'] as bool
    ..SEQ = json['SEQ'] as int
    ..UCODE = json['UCODE'] as String
    ..USER_NAME = json['USER_NAME'] as String
    ..LOG_TIME = json['LOG_TIME'] as String
    ..PID = json['PID'] as String
    ..PNAME = json['PNAME'] as String
    ..LOG_GBN = json['LOG_GBN'] as String
    ..POSITION = json['POSITION'] as String
    ..CONTENT = json['CONTENT'] as String;
}

Map<String, dynamic> _$ModelToJson(logPrivacyListModel instance) => <String, dynamic> {
  'selected': instance.selected,
  'SEQ': instance.SEQ,
  'UCODE': instance.UCODE,
  'USER_NAME': instance.USER_NAME,
  'LOG_TIME': instance.LOG_TIME,
  'PID': instance.PID,
  'PNAME': instance.PNAME,
  'LOG_GBN': instance.LOG_GBN,
  'POSITION': instance.POSITION,
  'CONTENT': instance.CONTENT
};