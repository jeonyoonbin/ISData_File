import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class OrderStatusEditModel {
  OrderStatusEditModel();

  bool selected = false;
  String orderNo;
  String status;
  String riderInfo;
  String modCode;
  String modName;
  String cancelCode;
  String cancelReason;

  factory OrderStatusEditModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

OrderStatusEditModel _$ModelFromJson(Map<String, dynamic> json) {
  return OrderStatusEditModel()
    ..selected = json['selected'] as bool
    ..orderNo = json['orderNo'] as String
    ..status = json['status'] as String
    ..riderInfo = json['riderInfo'] as String
    ..modCode = json['modCode'] as String
    ..modName = json['modName'] as String
    ..cancelCode = json['cancelCode'] as String
    ..cancelReason = json['cancelReason'] as String;
}

Map<String, dynamic> _$ModelToJson(OrderStatusEditModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'orderNo': instance.orderNo,
  'status': instance.status,
  'riderInfo': instance.riderInfo,
  'modCode': instance.modCode,
  'modName': instance.modName,
  'cancelCode': instance.cancelCode,
  'cancelReason': instance.cancelReason
};
