import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class DashBoardTotalCancel {
  DashBoardTotalCancel();

  String cancel_code = '';
  int count = 0;

  factory DashBoardTotalCancel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

DashBoardTotalCancel _$ModelFromJson(Map<String, dynamic> json) {
  return DashBoardTotalCancel()
    ..cancel_code = json['CANCEL_CODE'] as String
    ..count = json['COUNT'] as int;
}

Map<String, dynamic> _$ModelToJson(DashBoardTotalCancel instance) => <String, dynamic>{
  'CANCEL_CODE': instance.cancel_code,
  'COUNT': instance.count,
};
