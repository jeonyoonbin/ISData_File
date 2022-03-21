import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class OrderCompleteToCancelModel {
  OrderCompleteToCancelModel();

  bool selected = false;
  String orderNo;
  String payGbn;
  String orderTime;
  String shopTelNo;
  String regNo;
  String shopName;
  String orderAmount;
  String status;
  String custCode;
  String customerTelNo;
  String tuid;
  String cardName;
  String appNo;
  String cardAmount;
  String directPay;
  String custIdGbn;
  String posInstalled;
  String posLogined;
  String shopCd;
  String cancelType;
  String apiComCode;
  String packOrderYn;

  String modeUcode;
  String modeName;

  factory OrderCompleteToCancelModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

OrderCompleteToCancelModel _$ModelFromJson(Map<String, dynamic> json) {
  return OrderCompleteToCancelModel()
    ..selected = json['selected'] as bool
    ..orderNo = json['orderNo'] as String
    ..payGbn = json['payGbn'] as String
    ..orderTime = json['orderTime'] as String
    ..shopTelNo = json['shopTelNo'] as String
    ..regNo = json['regNo'] as String
    ..shopName = json['shopName'] as String
    ..orderAmount = json['orderAmount'] as String
    ..status = json['status'] as String
    ..custCode = json['custCode'] as String
    ..customerTelNo = json['customerTelNo'] as String
    ..tuid = json['tuid'] as String
    ..cardName = json['cardName'] as String
    ..appNo = json['appNo'] as String
    ..cardAmount = json['cardAmount'] as String
    ..directPay = json['directPay'] as String
    ..posInstalled = json['posInstalled'] as String
    ..posLogined = json['posLogined'] as String
    ..shopCd = json['shopCd'] as String
    ..cancelType = json['cancelType'] as String
    ..apiComCode = json['apiComCode'] as String
    ..modeUcode = json['modeUcode'] as String
    ..modeName = json['modeName'] as String
    ..custIdGbn = json['custIdGbn'] as String
    ..packOrderYn = json['packOrderYn'] as String;
}

Map<String, dynamic> _$ModelToJson(OrderCompleteToCancelModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'orderNo': instance.orderNo,
  'payGbn': instance.payGbn,
  'orderTime': instance.orderTime,
  'shopTelNo': instance.shopTelNo,
  'regNo': instance.regNo,
  'shopName': instance.shopName,
  'orderAmount': instance.orderAmount,
  'status': instance.status,
  'custCode': instance.custCode,
  'customerTelNo': instance.customerTelNo,
  'tuid': instance.tuid,
  'cardName': instance.cardName,
  'appNo': instance.appNo,
  'cardAmount': instance.cardAmount,
  'directPay': instance.directPay,
  'posInstalled': instance.posInstalled,
  'posLogined': instance.posLogined,
  'shopCd': instance.shopCd,
  'cancelType': instance.cancelType,
  'apiComCode': instance.apiComCode,
  'modeUcode': instance.modeUcode,
  'modeName': instance.modeName,
  'custIdGbn': instance.custIdGbn,
  'packOrderYn': instance.packOrderYn
};
