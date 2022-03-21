import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class couponList {
  couponList();

  bool selected = false;
  String couponType;
  String couponName;
  String couponNo;
  String randomNo;
  String barCode;
  String status;
  String appCustCode;
  String custName;
  String telNo;
  String useAppCustCode;
  String useCustName;
  String useTelNo;
  String orderDate;
  String orderNo;
  String useDate;
  String couponAmt;
  String linkUrl;
  String insDate;
  String insUCode;
  String insName;
  String expDate;
  String stDate;
  String confYN;
  String confDate;
  String confUCode;
  String confName;
  String shopName;


  factory couponList.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

couponList _$ModelFromJson(Map<String, dynamic> json) {
  return couponList()
    ..selected = json['selected'] as bool
    ..couponType = json['couponType'] as String
    ..couponName = json['couponName'] as String
    ..couponNo = json['couponNo'] as String
    ..randomNo = json['randomNo'] as String
    ..barCode = json['barCode'] as String
    ..status = json['status'] as String
    ..appCustCode = json['appCustCode'] as String
    ..custName = json['custName'] as String
    ..telNo = json['telNo'] as String
    ..useAppCustCode = json['useAppCustCode'] as String
    ..useCustName = json['useCustName'] as String
    ..useTelNo = json['useTelNo'] as String
    ..orderDate = json['orderDate'] as String
    ..orderNo = json['orderNo'] as String
    ..useDate = json['useDate'] as String
    ..couponAmt = json['couponAmt'] as String
    ..linkUrl = json['linkUrl'] as String
    ..insDate = json['insDate'] as String
    ..insUCode = json['insUCode'] as String
    ..insName = json['insName'] as String
    ..expDate = json['expDate'] as String
    ..stDate = json['stDate'] as String
    ..confYN = json['confYN'] as String
    ..confDate = json['confDate'] as String
    ..confUCode = json['confUCode'] as String
    ..confName = json['confName'] as String
    ..shopName = json['shopName'] as String;
}

Map<String, dynamic> _$ModelToJson(couponList instance) => <String, dynamic>{
  'selected': instance.selected,
  'couponType': instance.couponType,
  'couponName': instance.couponName,
  'couponNo': instance.couponNo,
  'randomNo': instance.randomNo,
  'barCode': instance.barCode,
  'status': instance.status,
  'appCustCode': instance.appCustCode,
  'custName': instance.custName,
  'telNo': instance.telNo,
  'useAppCustCode': instance.useAppCustCode,
  'useCustName': instance.useCustName,
  'useTelNo': instance.useTelNo,
  'orderDate': instance.orderDate,
  'orderNo': instance.orderNo,
  'useDate': instance.useDate,
  'couponAmt': instance.couponAmt,
  'linkUrl': instance.linkUrl,
  'insDate': instance.insDate,
  'insUCode': instance.insUCode,
  'insName': instance.insName,
  'expDate': instance.expDate,
  'stDate': instance.stDate,
  'confYN': instance.confYN,
  'confDate': instance.confDate,
  'confUCode': instance.confUCode,
  'confName': instance.confName,
  'shopName': instance.shopName,
};
