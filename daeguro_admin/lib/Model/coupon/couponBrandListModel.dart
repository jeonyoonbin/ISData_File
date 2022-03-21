import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class couponBrandListModel {
  couponBrandListModel();

  bool selected = false;
  String RNUM;
  String COUPON_TYPE;
  String COUPON_NAME;
  String COUPON_NO;
  String RANDOM_NO;
  String BARCODE;
  String STATUS;
  String APP_SHOP_CODE;
  String SHOP_NAME;
  String APP_CUST_CODE;
  String CUST_NAME;
  String TELNO;
  String USE_APP_CUST_CODE;
  String USE_CUST_NAME;
  String USE_TELNO;
  String ORDER_DATE;
  String USE_DATE;
  String COUPON_AMT;
  String LINK_URL;
  String INS_DATE;
  String INS_UCODE;
  String INS_NAME;
  String EXP_DATE;
  String ST_DATE;
  String CONF_YN;
  String CONF_DATE;
  String CONF_UCODE;
  String CONF_NAME;
  String ORDER_NO;

  factory couponBrandListModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

couponBrandListModel _$ModelFromJson(Map<String, dynamic> json) {
  return couponBrandListModel()
    ..selected = json['selected'] as bool
    .. RNUM = json['RNUM'] as String
    ..COUPON_TYPE = json['COUPON_TYPE'] as String
    ..COUPON_NAME = json['COUPON_NAME'] as String
    ..COUPON_NO = json['COUPON_NO'] as String
    ..RANDOM_NO = json['RANDOM_NO'] as String
    ..BARCODE = json['BARCODE'] as String
    ..STATUS = json['STATUS'] as String
    ..APP_SHOP_CODE = json['APP_SHOP_CODE'] as String
    ..SHOP_NAME = json['SHOP_NAME'] as String
    ..APP_CUST_CODE = json['APP_CUST_CODE'] as String
    ..CUST_NAME = json['CUST_NAME'] as String
    ..TELNO = json['TELNO'] as String
    ..USE_APP_CUST_CODE = json['USE_APP_CUST_CODE'] as String
    ..USE_CUST_NAME = json['USE_CUST_NAME'] as String
    ..USE_TELNO = json['USE_TELNO'] as String
    ..ORDER_DATE = json['ORDER_DATE'] as String
    ..USE_DATE = json['USE_DATE'] as String
    ..COUPON_AMT = json['COUPON_AMT'] as String
    ..LINK_URL = json['LINK_URL'] as String
    ..INS_DATE = json['INS_DATE'] as String
    ..INS_UCODE = json['INS_UCODE'] as String
    ..INS_NAME = json['INS_NAME'] as String
    ..EXP_DATE = json['EXP_DATE'] as String
    ..ST_DATE = json['ST_DATE'] as String
    ..CONF_YN = json['CONF_YN'] as String
    ..CONF_DATE = json['CONF_DATE'] as String
    ..CONF_UCODE = json['CONF_UCODE'] as String
    ..CONF_NAME = json['CONF_NAME'] as String
    ..ORDER_NO = json['ORDER_NO'] as String
    ;
}

Map<String, dynamic> _$ModelToJson(couponBrandListModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'RNUM' : instance.RNUM,
   'COUPON_TYPE' : instance.COUPON_TYPE,
   'COUPON_NAME' : instance.COUPON_NAME,
   'COUPON_NO' : instance.COUPON_NO,
   'RANDOM_NO' : instance.RANDOM_NO,
   'BARCODE' : instance.BARCODE,
   'STATUS' : instance.STATUS,
   'APP_SHOP_CODE' : instance.APP_SHOP_CODE,
   'SHOP_NAME' : instance.SHOP_NAME,
   'APP_CUST_CODE' : instance.APP_CUST_CODE,
   'CUST_NAME' : instance.CUST_NAME,
   'TELNO' : instance.TELNO,
   'USE_APP_CUST_CODE' : instance.USE_APP_CUST_CODE,
   'USE_CUST_NAME' : instance.USE_CUST_NAME,
   'USE_TELNO' : instance.USE_TELNO,
   'ORDER_DATE' : instance.ORDER_DATE,
   'USE_DATE' : instance.USE_DATE,
   'COUPON_AMT' : instance.COUPON_AMT,
   'LINK_URL' : instance.LINK_URL,
   'INS_DATE' : instance.INS_DATE,
   'INS_UCODE' : instance.INS_UCODE,
   'INS_NAME' : instance.INS_NAME,
   'EXP_DATE' : instance.EXP_DATE,
   'ST_DATE' : instance.ST_DATE,
   'CONF_YN' : instance.CONF_YN,
   'CONF_DATE' : instance.CONF_DATE,
   'CONF_UCODE' : instance.CONF_UCODE,
   'CONF_NAME' : instance.CONF_NAME,
    'ORDER_NO' : instance.ORDER_NO,
};
