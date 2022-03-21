import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class CalculateOrderPayMentModel {
  CalculateOrderPayMentModel();

  int RNUM;
  int ORDER_NO ;
  String ORDER_DATE;
  String ORDER_DATE_P;
  String ORDER_TIME;
  String STATUS;
  String SHOP_NAME;
  int CCODE;
  String CUST_NAME;
  String TELNO;
  int MENU_AMT;
  int DELI_TIP_AMT;
  int TOT_AMT;
  int COUPON_AMT;
  int MILEAGE_USE_AMT;
  int ETC_DISC_AMT;
  int DISC_AMT;
  int AMOUNT;
  String CARD_APPROVAL_GBN;
  String PAY_GBN;
  String APP_PAY_GBN;
  int PGM_AMT;
  int PG_PGM_AMT;
  int PGM_SUM_AMT;

  factory CalculateOrderPayMentModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

CalculateOrderPayMentModel _$ModelFromJson(Map<String, dynamic> json) {
  return CalculateOrderPayMentModel()
    ..RNUM = json['RNUM'] as int
    ..ORDER_NO = json['ORDER_NO'] as int
    ..ORDER_DATE = json['ORDER_DATE'] as String
    ..ORDER_DATE_P = json['ORDER_DATE_P'] as String
    ..ORDER_TIME = json['ORDER_TIME'] as String
    ..STATUS = json['STATUS'] as String
    ..SHOP_NAME = json['SHOP_NAME'] as String
    ..CCODE = json['CCODE'] as int
    ..CUST_NAME = json['CUST_NAME'] as String
    ..TELNO = json['TELNO'] as String
    ..MENU_AMT = json['MENU_AMT'] as int
    ..DELI_TIP_AMT = json['DELI_TIP_AMT'] as int
    ..TOT_AMT = json['TOT_AMT'] as int
    ..COUPON_AMT = json['COUPON_AMT'] as int
    ..MILEAGE_USE_AMT = json['MILEAGE_USE_AMT'] as int
    ..ETC_DISC_AMT = json['ETC_DISC_AMT'] as int
    ..DISC_AMT = json['DISC_AMT'] as int
    ..AMOUNT = json['AMOUNT'] as int
    ..CARD_APPROVAL_GBN = json['CARD_APPROVAL_GBN'] as String
    ..PAY_GBN = json['PAY_GBN'] as String
    ..APP_PAY_GBN = json['APP_PAY_GBN'] as String
    ..PGM_AMT = json['PGM_AMT'] as int
    ..PG_PGM_AMT = json['PG_PGM_AMT'] as int
    ..PGM_SUM_AMT = json['PGM_SUM_AMT'] as int;
}

Map<String, dynamic> _$ModelToJson(CalculateOrderPayMentModel instance) => <String, dynamic>{
  'RNUM': instance.RNUM,
  'ORDER_NO': instance.ORDER_NO,
  'ORDER_DATE': instance.ORDER_DATE,
  'ORDER_DATE_P': instance.ORDER_DATE_P,
  'ORDER_TIME': instance.ORDER_TIME,
  'STATUS': instance.STATUS,
  'SHOP_NAME': instance.SHOP_NAME,
  'CCODE': instance.CCODE,
  'CUST_NAME': instance.CUST_NAME,
  'TELNO': instance.TELNO,
  'MENU_AMT': instance.MENU_AMT,
  'DELI_TIP_AMT': instance.DELI_TIP_AMT,
  'TOT_AMT': instance.TOT_AMT,
  'COUPON_AMT': instance.COUPON_AMT,
  'MILEAGE_USE_AMT': instance.MILEAGE_USE_AMT,
  'ETC_DISC_AMT': instance.ETC_DISC_AMT,
  'DISC_AMT': instance.DISC_AMT,
  'AMOUNT': instance.AMOUNT,
  'CARD_APPROVAL_GBN': instance.CARD_APPROVAL_GBN,
  'PAY_GBN': instance.PAY_GBN,
  'APP_PAY_GBN': instance.APP_PAY_GBN,
  'PGM_AMT': instance.PGM_AMT,
  'PG_PGM_AMT': instance.PG_PGM_AMT,
  'PGM_SUM_AMT': instance.PGM_SUM_AMT
};
