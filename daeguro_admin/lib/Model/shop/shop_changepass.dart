import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopChangePassModel {
  ShopChangePassModel();

  bool selected = false;
  String job_gbn;
  int mcode;
  String cccode;
  int shop_cd;
  String id;
  String current;
  String password;
  int mod_code;
  String mod_user;

  factory ShopChangePassModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopChangePassModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopChangePassModel()
    ..selected = json['selected'] as bool
    ..job_gbn = json['job_gbn'] as String
    ..mcode = json['mcode'] as int
    ..cccode = json['cccode'] as String
    ..shop_cd = json['shop_cd'] as int
    ..id = json['id'] as String
    ..current = json['current'] as String
    ..password = json['password'] as String
    ..mod_code = json['mod_code'] as int
    ..mod_user = json['mod_user'] as String;

}

Map<String, dynamic> _$ModelToJson(ShopChangePassModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'job_gbn': instance.job_gbn,
  'mcode': instance.mcode,
  'cccode': instance.cccode,
  'shop_cd': instance.shop_cd,
  'id': instance.id,
  'current': instance.current,
  'password': instance.password,
  'mod_code': instance.mod_code,
  'mod_user': instance.mod_user
};