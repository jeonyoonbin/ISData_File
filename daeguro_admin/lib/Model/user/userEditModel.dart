import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
// ignore: camel_case_types
class UserEditModel {
  UserEditModel();

  String uCode;
  String ccCode;
  String name;
  String id;
  String password;
  String level;
  String mobile;
  String working;
  String memo;
  String modUCode;
  String modName;
  String insertDate;
  String retireDate;

  factory UserEditModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

UserEditModel _$ModelFromJson(Map<String, dynamic> json) {
  return UserEditModel()
    ..uCode = json['uCode'] as String
    ..ccCode = json['ccCode'] as String
    ..name = json['name'] as String
    ..id = json['id'] as String
    ..password = json['password'] as String
    ..level = json['level'] as String
    ..mobile = json['mobile'] as String
    ..working = json['working'] as String
    ..memo = json['memo'] as String
    ..modUCode = json['modUCode'] as String
    ..modName = json['modName'] as String
    ..insertDate = json['insertDate'] as String
    ..retireDate = json['retireDate'] as String;
}

Map<String, dynamic> _$ModelToJson(UserEditModel instance) => <String, dynamic>{
  'uCode': instance.uCode,
  'ccCode': instance.ccCode,
  'name': instance.name,
  'id': instance.id,
  'password': instance.password,
  'level': instance.level,
  'mobile': instance.mobile,
  'working': instance.working,
  'memo': instance.memo,
  'modUCode': instance.modUCode,
  'modName': instance.modName,
  'insertDate': instance.insertDate,
  'retireDate': instance.retireDate,
};
