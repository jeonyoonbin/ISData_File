import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopBankCodeModel {
  ShopBankCodeModel();

  bool selected = false;
  String bankCode;
  String bankName;

  factory ShopBankCodeModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopBankCodeModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopBankCodeModel()
    ..selected = json['selected'] as bool
    ..bankCode = json['bankCode'] as String
    ..bankName = json['bankName'] as String;

}

Map<String, dynamic> _$ModelToJson(ShopBankCodeModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'bankCode': instance.bankCode,
  'bankName': instance.bankName
};