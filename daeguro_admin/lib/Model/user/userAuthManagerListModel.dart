import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class UserAuthManagerListModel {
  UserAuthManagerListModel();

  bool selected = false;
  bool defaultItem = false;
  int ID;
  String NAME = '';
  String SIDEBAR_YN = '';
  String READ_YN = '';
  String UPDATE_YN = '';
  String CREATE_YN = '';
  String DELETE_YN = '';
  String DOWNLOAD_YN = '';

  factory UserAuthManagerListModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

UserAuthManagerListModel _$ModelFromJson(Map<String, dynamic> json) {
  return UserAuthManagerListModel()
    ..selected = json['selected'] as bool
    ..ID = json['ID'] as int
    ..NAME = json['NAME'] as String
    ..SIDEBAR_YN = json['SIDEBAR_YN'] as String
    ..READ_YN = json['READ_YN'] as String
    ..UPDATE_YN = json['UPDATE_YN'] as String
    ..CREATE_YN = json['CREATE_YN'] as String
    ..DELETE_YN = json['DELETE_YN'] as String
    ..DOWNLOAD_YN = json['DOWNLOAD_YN'] as String;
}

Map<String, dynamic> _$ModelToJson(UserAuthManagerListModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'ID': instance.ID,
  'NAME': instance.NAME,
  'SIDEBAR_YN': instance.SIDEBAR_YN,
  'READ_YN': instance.READ_YN,
  'UPDATE_YN': instance.UPDATE_YN,
  'CREATE_YN': instance.CREATE_YN,
  'DELETE_YN': instance.DELETE_YN,
  'DOWNLOAD_YN': instance.DOWNLOAD_YN
};
