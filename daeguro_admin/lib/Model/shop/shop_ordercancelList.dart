import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopOrderCancelListModel {
  ShopOrderCancelListModel();

  bool selected = false;
  String ccCode;
  String shopCd;
  String shopName;
  String telNo;
  String posInstall;
  String posLogin;
  String cancelCnt;
  String absentYn;
  String totalCnt;
  String loginTime;
  String lastCancelTime;

  factory ShopOrderCancelListModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopOrderCancelListModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopOrderCancelListModel()
    ..selected = json['selected'] as bool
    ..ccCode = json['cccode'] as String
    ..shopCd = json['shopCd'] as String
    ..shopName = json['shopName'] as String
    ..telNo = json['telNo'] as String
    ..posInstall = json['posInstall'] as String
    ..posLogin = json['posLogin'] as String
    ..cancelCnt = json['cancelcnt'] as String
    ..absentYn = json['absentYn'] as String
    ..totalCnt = json['totalcnt'] as String
    ..loginTime = json['loginTime'] as String
    ..lastCancelTime = json['lastCancelTime'] as String;
}

Map<String, dynamic> _$ModelToJson(ShopOrderCancelListModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'cccode': instance.ccCode,
  'shopCd': instance.shopCd,
  'shopName': instance.shopName,
  'telNo': instance.telNo,
  'posInstall': instance.posInstall,
  'posLogin': instance.posLogin,
  'cancelcnt': instance.cancelCnt,
  'absentYn': instance.absentYn,
  'totalcnt': instance.totalCnt,
  'loginTime': instance.loginTime,
  'lastCancelTime': instance.lastCancelTime,
};