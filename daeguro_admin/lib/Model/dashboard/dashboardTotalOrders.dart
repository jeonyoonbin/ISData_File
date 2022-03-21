import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class DashBoardTotalOrders {
  DashBoardTotalOrders();

  String status = '';
  int count = 0;

  factory DashBoardTotalOrders.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

DashBoardTotalOrders _$ModelFromJson(Map<String, dynamic> json) {
  return DashBoardTotalOrders()
    ..status = json['STATUS'] as String
    ..count = json['COUNT'] as int;
}

Map<String, dynamic> _$ModelToJson(DashBoardTotalOrders instance) => <String, dynamic>{
  'STATUS': instance.status,
  'COUNT': instance.count,
};
