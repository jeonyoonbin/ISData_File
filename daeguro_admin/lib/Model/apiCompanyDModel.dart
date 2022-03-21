import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ApiCompanyDModel {
  ApiCompanyDModel();

  bool selected;
  String seq;
  String comType;
  String comGbn;
  String comName;
  String comToken;
  String comAuth;
  String userCode;
  String userName;

  factory ApiCompanyDModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ApiCompanyDModel _$ModelFromJson(Map<String, dynamic> json) {
  return ApiCompanyDModel()
    ..selected = json['selected'] as bool
    ..seq = json['seq'] as String
    ..comType = json['comType'] as String
    ..comGbn = json['comGbn'] as String
    ..comName = json['comName'] as String
    ..comToken = json['comToken'] as String
    ..comAuth = json['comAuth'] as String
    ..userCode = json['userCode'] as String
    ..userName = json['userName'] as String;
}

Map<String, dynamic> _$ModelToJson(ApiCompanyDModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'seq': instance.seq,
  'comType': instance.comType,
  'comGbn': instance.comGbn,
  'comName': instance.comName,
  'comToken': instance.comToken,
  'comAuth': instance.comAuth,
  'userCode': instance.userCode,
  'userName': instance.userName
};
