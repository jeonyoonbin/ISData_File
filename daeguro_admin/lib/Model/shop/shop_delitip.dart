import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopDeliTipModel {
  ShopDeliTipModel();

  bool selected = false;
  String shopCd;
  String tipSeq;
  String tipDay;
  String tipGbn;
  String tipFromStand;
  String tipNextDay;
  String tipToStand;
  String appOrderyn;
  String useGbn;
  String happyPayUseGbn;
  String tipAmt;
  String tipAmtRate;
  String closedLogin;
  String supportFund;
  String reserveYn;
  String modUCode;
  String modName;

  factory ShopDeliTipModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopDeliTipModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopDeliTipModel()
    ..selected = json['selected'] as bool
    ..shopCd = json['shopCd'] as String
    ..tipSeq = json['tipSeq'] as String
    ..tipDay = json['tipDay'] as String
    ..tipGbn = json['tipGbn'] as String
    ..tipFromStand = json['tipFromStand'] as String
    ..tipNextDay = json['tipNextDay'] as String
    ..tipToStand = json['tipToStand'] as String
    ..appOrderyn = json['appOrderyn'] as String
    ..useGbn = json['useGbn'] as String
    ..happyPayUseGbn = json['happyPayUseGbn'] as String
    ..tipAmt = json['tipAmt'] as String
    ..tipAmtRate = json['tipAmtRate'] as String
    ..closedLogin = json['closedLogin'] as String
    ..supportFund = json['supportFund'] as String
    ..reserveYn = json['reserveYn'] as String
    ..modUCode = json['modUCode'] as String
    ..modName = json['modName'] as String;

}

Map<String, dynamic> _$ModelToJson(ShopDeliTipModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'shopCd': instance.shopCd,
  'tipSeq': instance.tipSeq,
  'tipDay': instance.tipDay,
  'tipGbn': instance.tipGbn,
  'tipFromStand': instance.tipFromStand,
  'tipNextDay': instance.tipNextDay,
  'tipToStand': instance.tipToStand,
  'appOrderyn': instance.appOrderyn,
  'useGbn': instance.useGbn,
  'happyPayUseGbn': instance.happyPayUseGbn,
  'tipAmt': instance.tipAmt,
  'tipAmtRate': instance.tipAmtRate,
  'closedLogin': instance.closedLogin,
  'supportFund': instance.supportFund,
  'reserveYn': instance.reserveYn,
  'modUCode': instance.modUCode,
  'modName': instance.modName
};