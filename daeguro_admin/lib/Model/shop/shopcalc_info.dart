import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopCalcInfoModel {
  ShopCalcInfoModel();

  bool selected = false;
  String shopCd;
  String bankCode = '';
  String accountNo;
  String accOwner;
  String payConfirm;
  String modUCode;
  String modName;


  factory ShopCalcInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopCalcInfoModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopCalcInfoModel()
    ..selected = json['selected'] as bool
    ..shopCd = json['shopCd'] as String
    ..bankCode = json['bankCode'] as String
    ..accountNo = json['accountNo'] as String
    ..accOwner = json['accOwner'] as String
    ..payConfirm = json['payConfirm'] as String
    ..modUCode = json['modUCode'] as String
    ..modName = json['modName'] as String;

}

Map<String, dynamic> _$ModelToJson(ShopCalcInfoModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'shopCd': instance.shopCd,
  'bankCode': instance.bankCode,
  'accountNo': instance.accountNo,
  'accOwner': instance.accOwner,
  'payConfirm': instance.payConfirm,
  'modUCode': instance.modUCode,
  'modName': instance.modName
};