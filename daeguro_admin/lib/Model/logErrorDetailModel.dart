import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class logErrorDetailModel {
  logErrorDetailModel();

  bool selected = false;
  int SEQ;
  String DIV;
  String POSITION;
  String MSG;
  String INSERT_TIME;

  factory logErrorDetailModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

logErrorDetailModel _$ModelFromJson(Map<String, dynamic> json) {
  return logErrorDetailModel()
    ..selected = json['selected'] as bool
    ..SEQ = json['SEQ'] as int
    ..DIV = json['DIV'] as String
    ..POSITION = json['POSITION'] as String
    ..MSG = json['MSG'] as String
    ..INSERT_TIME = json['INSERT_TIME'] as String;
}

Map<String, dynamic> _$ModelToJson(logErrorDetailModel instance) => <String, dynamic> {
  'selected': instance.selected,
  'SEQ': instance.SEQ,
  'DIV': instance.DIV,
  'POSITION': instance.POSITION,
  'MSG': instance.MSG,
  'INSERT_TIME': instance.INSERT_TIME
};