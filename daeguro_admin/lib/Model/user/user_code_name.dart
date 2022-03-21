import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class UserCodeName {
  UserCodeName();

  bool selected = false;
  String code;
  String name;

  factory UserCodeName.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

UserCodeName _$ModelFromJson(Map<String, dynamic> json) {
  return UserCodeName()
    ..selected = json['selected'] as bool
    ..code = json['code'] as String
    ..name = json['name'] as String;

}

Map<String, dynamic> _$ModelToJson(UserCodeName instance) => <String, dynamic>{
  'selected': instance.selected,
  'code': instance.code,
  'name': instance.name
};