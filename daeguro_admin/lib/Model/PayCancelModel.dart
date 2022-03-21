import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class PayCancelModel {
  PayCancelModel();

  String order_no;
  String trade_kcp_no;
  String cancel_reason;

  factory PayCancelModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

PayCancelModel _$ModelFromJson(Map<String, dynamic> json) {
  return PayCancelModel()
    ..order_no = json['order_no'] as String
    ..trade_kcp_no = json['trade_kcp_no'] as String
    ..cancel_reason = json['cancel_reason'] as String;
}

Map<String, dynamic> _$ModelToJson(PayCancelModel instance) => <String, dynamic>{
  'order_no': instance.order_no,
  'trade_kcp_no': instance.trade_kcp_no,
  'cancel_reason': instance.cancel_reason
};