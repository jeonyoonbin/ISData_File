import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class MappingDModel {
  MappingDModel();

  bool selected;
  String shopCd;
  String ccCode;
  String shopName;
  String shopMapSeq;
  String apiUseYn;
  String apiType;
  String apiComGbn;
  String apiComCode;
  String apiComCode2;
  String apiComToken;
  String apiComAuth;
  String apiComId;
  String apiComPass;
  String apiDailyToken;
  String apiMemo;
  String userCode;
  String userName;

  factory MappingDModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

MappingDModel _$ModelFromJson(Map<String, dynamic> json) {
  return MappingDModel()
    ..selected = json['selected'] as bool
    ..shopCd = json['shopCd'] as String
    ..ccCode = json['ccCode'] as String
    ..shopName = json['shopName'] as String
    ..shopMapSeq = json['shopMapSeq'] as String
    ..apiUseYn = json['apiUseYn'] as String
    ..apiType = json['apiType'] as String
    ..apiComGbn = json['apiComGbn'] as String
    ..apiComCode = json['apiComCode'] as String
    ..apiComCode2 = json['apiComCode2'] as String
    ..apiComToken = json['apiComToken'] as String
    ..apiComAuth = json['apiComAuth'] as String
    ..apiComId = json['apiComId'] as String
    ..apiComPass = json['apiComPass'] as String
    ..apiDailyToken = json['apiDailyToken'] as String
    ..apiMemo = json['apiMemo'] as String
    ..userCode = json['userCode'] as String
    ..userName = json['userName'] as String;
}

Map<String, dynamic> _$ModelToJson(MappingDModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'shopCd': instance.shopCd,
  'ccCode': instance.ccCode,
  'shopName': instance.shopName,
  'shopMapSeq': instance.shopMapSeq,
  'apiUseYn': instance.apiUseYn,
  'apiType': instance.apiType,
  'apiComGbn': instance.apiComGbn,
  'apiComCode': instance.apiComCode,
  'apiComCode2': instance.apiComCode2,
  'apiComToken': instance.apiComToken,
  'apiComAuth': instance.apiComAuth,
  'apiComId': instance.apiComId,
  'apiComPass': instance.apiComPass,
  'apiDailyToken': instance.apiDailyToken,
  'apiMemo': instance.apiMemo,
  'userCode': instance.userCode,
  'userName': instance.userName,
};
