import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopInfoModel {
  ShopInfoModel();

  bool selected = false;
  String shopCd;
  String shopName;
  String telNo;
  String itemCd1;
  String itemCd2;
  String itemCd3;
  String appMinAmt;
  String shopType;
  String modUCode;
  String modName;
  String shopId;
  String current;  // 현재 비밀번호
  String shopPass;
  String shopImg;
  String bussImg;
  String idcardImg;
  String bankImg;
  String reserveYn;
  String useGbn;

  factory ShopInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopInfoModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopInfoModel()
    ..selected = json['selected'] as bool
    ..shopCd = json['shopCd'] as String
    ..shopName = json['shopName'] as String
    ..telNo = json['telNo'] as String
    ..itemCd1 = json['itemCd1'] as String
    ..itemCd2 = json['itemCd2'] as String
    ..itemCd3 = json['itemCd3'] as String
    ..appMinAmt = json['appMinAmt'] as String
    ..shopType = json['shopType'] as String
    ..modUCode = json['modUCode'] as String
    ..modName = json['modName'] as String
    ..shopId = json['shopId'] as String
    ..current = json['current'] as String
    ..shopPass = json['shopPass'] as String
    ..shopImg = json['shopImg'] as String
    ..bussImg = json['bussImg'] as String
    ..idcardImg = json['idcardImg'] as String
    ..bankImg = json['bankImg'] as String
    ..reserveYn = json['reserveYn'] as String
    ..useGbn = json['useGbn'] as String;

}

Map<String, dynamic> _$ModelToJson(ShopInfoModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'shopCd': instance.shopCd,
  'shopName': instance.shopName,
  'telNo': instance.telNo,
  'itemCd1': instance.itemCd1,
  'itemCd2': instance.itemCd2,
  'itemCd3': instance.itemCd3,
  'appMinAmt': instance.appMinAmt,
  'shopType': instance.shopType,
  'modUCode': instance.modUCode,
  'modName': instance.modName,
  'shopId': instance.shopId,
  'current': instance.current,
  'shopPass': instance.shopPass,
  'shopImg': instance.shopImg,
  'bussImg': instance.bussImg,
  'idcardImg': instance.idcardImg,
  'bankImg': instance.bankImg,
  'reserveYn': instance.reserveYn,
  'useGbn': instance.useGbn
};