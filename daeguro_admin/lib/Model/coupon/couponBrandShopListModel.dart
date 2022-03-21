import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
// ignore: camel_case_types
class couponBrandShopListModel {
  couponBrandShopListModel();

  int RNUM;
  String SHOP_CD;
  String SHOP_NAME;
  String COUPON_TYPE;
  String CODE_NM;
  String USE_YN;
  int USE_MAX_COUNT = 0;

  factory couponBrandShopListModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

couponBrandShopListModel _$ModelFromJson(Map<String, dynamic> json) {
  return couponBrandShopListModel()
    ..RNUM = json['RNUM'] as int
    ..SHOP_CD = json['SHOP_CD'] as String
    ..SHOP_NAME = json['SHOP_NAME'] as String
    ..COUPON_TYPE = json['COUPON_TYPE'] as String
    ..CODE_NM = json['CODE_NM'] as String
    ..USE_YN = json['USE_YN'] as String
    ..USE_MAX_COUNT = json['USE_MAX_COUNT'] as int;
}

Map<String, dynamic> _$ModelToJson(couponBrandShopListModel instance) => <String, dynamic>{
  'RNUM': instance.RNUM,
  'SHOP_CD': instance.SHOP_CD,
  'SHOP_NAME': instance.SHOP_NAME,
  'COUPON_TYPE': instance.COUPON_TYPE,
  'CODE_NM': instance.CODE_NM,
  'USE_YN': instance.USE_YN,
  'USE_MAX_COUNT': instance.USE_MAX_COUNT,
};
