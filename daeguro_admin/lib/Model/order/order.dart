import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class OrderAccount {
  OrderAccount();

  bool selected = false;
  int ORDER_NO;
  String PAY_GBN;
  String ORDER_TIME;
  String SHOP_TELNO;
  String REG_NO;
  String SHOP_NAME;
  int ORDER_AMOUNT;
  String STATUS;
  String CUSTOMER_TELNO;
  String TUID;
  String CARD_NAME;
  String APP_NO;
  int CARD_AMOUNT;
  String DIRECT_PAY;
  String CUST_ID_GBN;
  String POS_INSTALL;
  String POS_LOGIN;
  String SHOP_CD;
  String CANCEL_TYPE;
  String API_COM_CODE;
  String PACK_ORDER_YN;
  String cardApprovalGbn;
  String RIDER_DELI_MEMO;
  String SHOP_DELI_MEMO;
  String APP_PAY_GBN;
  String APP_CUST_CODE;
  int REMAIN_AMT;

  String modeUcode;
  String modeName;

  factory OrderAccount.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

OrderAccount _$ModelFromJson(Map<String, dynamic> json) {
  return OrderAccount()
    ..selected = json['selected'] as bool
    ..ORDER_NO = json['ORDER_NO'] as int
    ..PAY_GBN = json['PAY_GBN'] as String
    ..ORDER_TIME = json['ORDER_TIME'] as String
    ..SHOP_TELNO = json['SHOP_TELNO'] as String
    ..REG_NO = json['REG_NO'] as String
    ..SHOP_NAME = json['SHOP_NAME'] as String
    ..ORDER_AMOUNT = json['ORDER_AMOUNT'] as int
    ..STATUS = json['STATUS'] as String
    ..CUSTOMER_TELNO = json['CUSTOMER_TELNO'] as String
    ..TUID = json['TUID'] as String
    ..CARD_NAME = json['CARD_NAME'] as String
    ..APP_NO = json['APP_NO'] as String
    ..CARD_AMOUNT = json['CARD_AMOUNT'] as int
    ..DIRECT_PAY = json['DIRECT_PAY'] as String
    ..CUST_ID_GBN = json['CUST_ID_GBN'] as String
    ..POS_INSTALL = json['POS_INSTALL'] as String
    ..POS_LOGIN = json['POS_LOGIN'] as String
    ..SHOP_CD = json['SHOP_CD'] as String
    ..CANCEL_TYPE = json['CANCEL_TYPE'] as String
    ..API_COM_CODE = json['API_COM_CODE'] as String
    ..modeUcode = json['modeUcode'] as String
    ..modeName = json['modeName'] as String
    ..PACK_ORDER_YN = json['PACK_ORDER_YN'] as String
    ..cardApprovalGbn = json['cardApprovalGbn'] as String
    ..RIDER_DELI_MEMO = json['RIDER_DELI_MEMO'] as String
    ..SHOP_DELI_MEMO = json['SHOP_DELI_MEMO'] as String
    ..APP_PAY_GBN = json['APP_PAY_GBN'] as String
    ..APP_CUST_CODE = json['APP_CUST_CODE'] as String
    ..REMAIN_AMT = json['REMAIN_AMT'] as int;
}

Map<String, dynamic> _$ModelToJson(OrderAccount instance) => <String, dynamic>{
  'selected': instance.selected,
  'ORDER_NO': instance.ORDER_NO,
  'PAY_GBN': instance.PAY_GBN,
  'ORDER_TIME': instance.ORDER_TIME,
  'SHOP_TELNO': instance.SHOP_TELNO,
  'REG_NO': instance.REG_NO,
  'SHOP_NAME': instance.SHOP_NAME,
  'ORDER_AMOUNT': instance.ORDER_AMOUNT,
  'STATUS': instance.STATUS,
  'CUSTOMER_TELNO': instance.CUSTOMER_TELNO,
  'TUID': instance.TUID,
  'CARD_NAME': instance.CARD_NAME,
  'APP_NO': instance.APP_NO,
  'CARD_AMOUNT': instance.CARD_AMOUNT,
  'DIRECT_PAY': instance.DIRECT_PAY,
  'POS_INSTALL': instance.POS_INSTALL,
  'POS_LOGIN': instance.POS_LOGIN,
  'SHOP_CD': instance.SHOP_CD,
  'CANCEL_TYPE': instance.CANCEL_TYPE,
  'API_COM_CODE': instance.API_COM_CODE,
  'modeUcode': instance.modeUcode,
  'modeName': instance.modeName,
  'CUST_ID_GBN': instance.CUST_ID_GBN,
  'PACK_ORDER_YN': instance.PACK_ORDER_YN,
  'cardApprovalGbn': instance.cardApprovalGbn,
  'RIDER_DELI_MEMO': instance.RIDER_DELI_MEMO,
  'SHOP_DELI_MEMO': instance.SHOP_DELI_MEMO,
  'APP_PAY_GBN': instance.APP_PAY_GBN,
  'APP_CUST_CODE': instance.APP_CUST_CODE,
  'REMAIN_AMT': instance.REMAIN_AMT,
};