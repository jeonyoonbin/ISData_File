import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopSaleTimeModel {
  ShopSaleTimeModel();

  bool selected = false;
  String saleFromTime;
  String saleToTime;
  String saleNextDay;
  String appOrderYn;
  String useGbn;
  String happyPayUseGbn;
  String confirmYn;
  String confirmDate;
  String closedLogin;
  String supportFund;
  String reserveYn;
  String shopType;

  factory ShopSaleTimeModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopSaleTimeModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopSaleTimeModel()
    ..selected = json['selected'] as bool
    ..saleFromTime = json['saleFromTime'] as String
    ..saleToTime = json['saleToTime'] as String
    ..saleNextDay = json['saleNextDay'] as String
    ..appOrderYn = json['appOrderYn'] as String
    ..useGbn = json['useGbn'] as String
    ..happyPayUseGbn = json['happyPayUseGbn'] as String
    ..confirmYn = json['confirmYn'] as String
    ..confirmDate = json['confirmDate'] as String
    ..closedLogin = json['closedLogin'] as String
    ..supportFund = json['supportFund'] as String
    ..reserveYn = json['reserveYn'] as String
    ..shopType = json['shopType'] as String;
}

Map<String, dynamic> _$ModelToJson(ShopSaleTimeModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'saleFromTime': instance.saleFromTime,
  'saleToTime': instance.saleToTime,
  'saleNextDay': instance.saleNextDay,
  'appOrderYn': instance.appOrderYn,
  'useGbn': instance.useGbn,
  'happyPayUseGbn': instance.happyPayUseGbn,
  'confirmYn': instance.confirmYn,
  'confirmDate': instance.confirmDate,
  'closedLogin': instance.closedLogin,
  'supportFund': instance.supportFund,
  'reserveYn': instance.reserveYn,
  'shopType': instance.shopType
};