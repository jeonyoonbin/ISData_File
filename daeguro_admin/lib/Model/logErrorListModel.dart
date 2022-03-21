import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class logErrorListModel {
  logErrorListModel();

  bool selected = false;
  int SEQ;
  String DIV;
  String POSITION;
  String MSG;
  String INSERT_TIME;

  factory logErrorListModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

logErrorListModel _$ModelFromJson(Map<String, dynamic> json) {
  return logErrorListModel()
      ..selected = json['selected'] as bool
      ..SEQ = json['SEQ'] as int
      ..DIV = json['DIV'] as String
      ..POSITION = json['POSITION'] as String
      ..MSG = json['MSG'] as String
      ..INSERT_TIME = json['INSERT_TIME'] as String;
}

Map<String, dynamic> _$ModelToJson(logErrorListModel instance) => <String, dynamic> {
  'selected': instance.selected,
  'SEQ': instance.SEQ,
  'DIV': instance.DIV,
  'POSITION': instance.POSITION,
  'MSG': instance.MSG,
  'INSERT_TIME': instance.INSERT_TIME
};