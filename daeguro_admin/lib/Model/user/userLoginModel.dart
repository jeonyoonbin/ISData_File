import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class userLoginModel {
  userLoginModel();

  bool selected = false;
  String uCode;
  String ccCode;
  String id;
  String name;
  String password;
  String modUCode;
  String modName;
  String insertDate;
  String retireDate;
  String level;
  String memo;
  String working;

  factory userLoginModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

userLoginModel _$ModelFromJson(Map<String, dynamic> json) {
  return userLoginModel()
    ..selected = json['selected'] as bool
    ..uCode = json['uCode'] as String
    ..ccCode = json['ccCode'] as String
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..password = json['password'] as String
    ..modUCode = json['modUCode'] as String
    ..modName = json['modName'] as String
    ..insertDate = json['insertDate'] as String
    ..retireDate = json['retireDate'] as String
    ..level = json['level'] as String
    ..memo = json['memo'] as String
    ..working = json['working'] as String;
}

Map<String, dynamic> _$ModelToJson(userLoginModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'uCode': instance.uCode,
  'ccCode': instance.ccCode,
  'id': instance.id,
  'name': instance.name,
  'password': instance.password,
  'modUCode': instance.modUCode,
  'modName': instance.modName,
  'insertDate': instance.insertDate,
  'retireDate': instance.retireDate,
  'level': instance.level,
  'memo': instance.memo,
  'working': instance.working
};
