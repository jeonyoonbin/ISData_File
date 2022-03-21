import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class DashBoardTodayCountModel {
  DashBoardTodayCountModel();

  int TOTAL_MEMBER = 0;
  int TODAY_APP_INSTALL = 0;
  int TODAY_MEMBER = 0;
  int TODAY_ORDER = 0;
  int TODAY_SHOP_CONFIRM = 0;
  int TODAY_COMPLETE_COUNT = 0;

  factory DashBoardTodayCountModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

DashBoardTodayCountModel _$ModelFromJson(Map<String, dynamic> json) {
  return DashBoardTodayCountModel()
    ..TOTAL_MEMBER = json['TOTAL_MEMBER'] as int
    ..TODAY_APP_INSTALL = json['TODAY_APP_INSTALL'] as int
    ..TODAY_MEMBER = json['TODAY_MEMBER'] as int
    ..TODAY_ORDER = json['TODAY_ORDER'] as int
    ..TODAY_SHOP_CONFIRM = json['TODAY_SHOP_CONFIRM'] as int
    ..TODAY_COMPLETE_COUNT = json['TODAY_COMPLETE_COUNT'] as int;
}

Map<String, dynamic> _$ModelToJson(DashBoardTodayCountModel instance) => <String, dynamic>{
  'TOTAL_MEMBER': instance.TOTAL_MEMBER,
  'TODAY_APP_INSTALL': instance.TODAY_APP_INSTALL,
  'TODAY_MEMBER': instance.TODAY_MEMBER,
  'TODAY_ORDER': instance.TODAY_ORDER,
  'TODAY_SHOP_CONFIRM': instance.TODAY_SHOP_CONFIRM,
  'TODAY_COMPLETE_COUNT': instance.TODAY_COMPLETE_COUNT
};
