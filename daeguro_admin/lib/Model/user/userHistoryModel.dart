import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class UserHistoryModel {
  UserHistoryModel();

  bool selected = false;
  int NO;
  int SEQNO;
  int UCODE;
  String HIST_DATE;
  String MEMO;

  factory UserHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

UserHistoryModel _$ModelFromJson(Map<String, dynamic> json) {
  return UserHistoryModel()
    ..selected = json['selected'] as bool
    ..NO = json['NO'] as int
    ..SEQNO = json['SEQNO'] as int
    ..UCODE = json['UCODE'] as int
    ..HIST_DATE = json['HIST_DATE'] as String
    ..MEMO = json['MEMO'] as String;
}

Map<String, dynamic> _$ModelToJson(UserHistoryModel instance) => <String, dynamic> {
  'selected': instance.selected,
  'NO': instance.NO,
  'SEQNO': instance.SEQNO,
  'UCODE': instance.UCODE,
  'HIST_DATE': instance.HIST_DATE,
  'MEMO': instance.MEMO,
};