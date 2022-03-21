import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
// ignore: camel_case_types
class B2BUsercouponListModel {
  B2BUsercouponListModel();

  int RNUM;
  int USER_ID;
  String NAME;
  String LOGIN_ID;
  String MOBILE;
  String COUPON_TYPE;
  String REG_DATE;
  String USE_YN;

  factory B2BUsercouponListModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

B2BUsercouponListModel _$ModelFromJson(Map<String, dynamic> json) {
  return B2BUsercouponListModel()
    ..RNUM = json['RNUM'] as int
    ..USER_ID = json['USER_ID'] as int
    ..NAME = json['NAME'] as String
    ..LOGIN_ID = json['LOGIN_ID'] as String
    ..MOBILE = json['MOBILE'] as String
    ..COUPON_TYPE = json['COUPON_TYPE'] as String
    ..REG_DATE = json['REG_DATE'] as String
    ..USE_YN = json['USE_YN'] as String;
}

Map<String, dynamic> _$ModelToJson(B2BUsercouponListModel instance) => <String, dynamic>{
  'RNUM': instance.RNUM,
  'USER_ID': instance.USER_ID,
  'NAME': instance.NAME,
  'LOGIN_ID': instance.LOGIN_ID,
  'MOBILE': instance.MOBILE,
  'COUPON_TYPE': instance.COUPON_TYPE,
  'REG_DATE': instance.REG_DATE,
  'USE_YN': instance.USE_YN
};
