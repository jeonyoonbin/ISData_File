import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class DashBoardWeekCustomerModel {
  DashBoardWeekCustomerModel();

  String INSERT_DATE;
  int INSTALL_COUNT;
  int NEW_COSTOMER_COUNT;

  factory DashBoardWeekCustomerModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

DashBoardWeekCustomerModel _$ModelFromJson(Map<String, dynamic> json) {
  return DashBoardWeekCustomerModel()
    ..INSERT_DATE = json['INSERT_DATE'] as String
    ..INSTALL_COUNT = json['INSTALL_COUNT'] as int
    ..NEW_COSTOMER_COUNT = json['NEW_COSTOMER_COUNT'] as int;
}

Map<String, dynamic> _$ModelToJson(DashBoardWeekCustomerModel instance) => <String, dynamic>{
  'INSERT_DATE': instance.INSERT_DATE,
  'INSTALL_COUNT': instance.INSTALL_COUNT,
  'NEW_COSTOMER_COUNT': instance.NEW_COSTOMER_COUNT
};
