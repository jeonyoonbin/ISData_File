import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class DashBoardTotalOs {
  DashBoardTotalOs();

  String device_gbn = '';
  int count = 0;

  factory DashBoardTotalOs.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

DashBoardTotalOs _$ModelFromJson(Map<String, dynamic> json) {
  return DashBoardTotalOs()
    ..device_gbn = json['DEVICE_GBN'] as String
    ..count = json['COUNT'] as int;
}

Map<String, dynamic> _$ModelToJson(DashBoardTotalOs instance) => <String, dynamic>{
  'DEVICE_GBN': instance.device_gbn,
  'COUNT': instance.count,
};
