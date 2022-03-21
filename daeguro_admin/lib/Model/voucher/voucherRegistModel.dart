import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
// ignore: camel_case_types
class voucherRegistModel {
  voucherRegistModel();

  String voucherType;
  String ucode;

  factory voucherRegistModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

voucherRegistModel _$ModelFromJson(Map<String, dynamic> json) {
  return voucherRegistModel()
    ..voucherType = json['voucherType'] as String
    ..ucode = json['ucode'] as String

  ;
}

Map<String, dynamic> _$ModelToJson(voucherRegistModel instance) => <String, dynamic>{
  'voucherType': instance.voucherType,
  'ucode': instance.ucode,

};
