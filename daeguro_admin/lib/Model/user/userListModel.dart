import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class UserListModel {
  UserListModel();

  bool selected = false;
  String uCode;
  String ccCode;
  String id;
  String name;
  String insertDate;
  String retireDate;
  String level;
  String memo;
  String working;

  factory UserListModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

UserListModel _$ModelFromJson(Map<String, dynamic> json) {
  return UserListModel()
    ..selected = json['selected'] as bool
    ..uCode = json['uCode'] as String
    ..ccCode = json['ccCode'] as String
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..insertDate = json['insertDate'] as String
    ..retireDate = json['retireDate'] as String
    ..level = json['level'] as String
    ..memo = json['memo'] as String
    ..working = json['working'] as String;
}

Map<String, dynamic> _$ModelToJson(UserListModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'uCode': instance.uCode,
  'ccCode': instance.ccCode,
  'id': instance.id,
  'name': instance.name,
  'insertDate': instance.insertDate,
  'retireDate': instance.retireDate,
  'level': instance.level,
  'memo': instance.memo,
  'working': instance.working
};
