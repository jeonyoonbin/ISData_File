import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class DashBoardTotalYearMembers {
  DashBoardTotalYearMembers();

  String year = '';
  int count = 0;

  factory DashBoardTotalYearMembers.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

DashBoardTotalYearMembers _$ModelFromJson(Map<String, dynamic> json) {
  return DashBoardTotalYearMembers()
    ..year = json['YEAR'] as String
    ..count = json['COUNT'] as int;
}

Map<String, dynamic> _$ModelToJson(DashBoardTotalYearMembers instance) => <String, dynamic>{
  'YEAR': instance.year,
  'COUNT': instance.count,
};
