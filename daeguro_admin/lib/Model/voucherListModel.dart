import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class voucherListModel {
  voucherListModel();

  bool selected = false;
  String RNUM;
  String VOUCHER_TYPE;
  String VOUCHER_NAME;
  int VOUCHER_AMT;
  int VOUCHER_REMAIN_AMT;
  String VOUCHER_NO;
  String STATUS;
  String REG_DATE;
  String REG_EXP_DATE;
  String INS_DATE;
  String INS_UCODE;
  String INS_NAME;
  String EXTENSION_YN;
  String CUST_CODE;
  String CUST_TELNO;
  String CUST_NAME;

  factory voucherListModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

voucherListModel _$ModelFromJson(Map<String, dynamic> json) {
  return voucherListModel()
    ..selected = json['selected'] as bool
    ..RNUM  = json['RNUM'] as String
    ..VOUCHER_TYPE = json['VOUCHER_TYPE'] as String
    ..VOUCHER_NAME = json['VOUCHER_NAME'] as String
    ..VOUCHER_AMT = json['VOUCHER_AMT'] as int
    ..VOUCHER_REMAIN_AMT = json['VOUCHER_REMAIN_AMT'] as int
    ..VOUCHER_NO = json['VOUCHER_NO'] as String
    ..STATUS = json['STATUS'] as String
    ..REG_DATE = json['REG_DATE'] as String
    ..REG_EXP_DATE = json['REG_EXP_DATE'] as String
    ..INS_DATE = json['INS_DATE'] as String
    ..INS_UCODE = json['INS_UCODE'] as String
    ..INS_NAME = json['INS_NAME'] as String
    ..EXTENSION_YN = json['EXTENSION_YN'] as String
    ..CUST_CODE = json['CUST_CODE'] as String
    ..CUST_TELNO = json['CUST_TELNO'] as String
    ..CUST_NAME = json['CUST_NAME'] as String
  ;
}

Map<String, dynamic> _$ModelToJson(voucherListModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'RNUM' : instance.RNUM,
  'VOUCHER_TYPE' : instance.VOUCHER_TYPE,
  'VOUCHER_NAME' : instance.VOUCHER_NAME,
  'VOUCHER_AMT' : instance.VOUCHER_AMT,
  'VOUCHER_REMAIN_AMT' : instance.VOUCHER_REMAIN_AMT,
  'VOUCHER_NO' : instance.VOUCHER_NO,
  'STATUS' : instance.STATUS,
  'REG_DATE' : instance.REG_DATE,
  'REG_EXP_DATE' : instance.REG_EXP_DATE,
  'INS_DATE' : instance.INS_DATE,
  'INS_UCODE' : instance.INS_UCODE,
  'INS_NAME' : instance.INS_NAME,
  'EXTENSION_YN' : instance.EXTENSION_YN,
  'CUST_CODE' : instance.CUST_CODE,
  'CUST_TELNO' : instance.CUST_TELNO,
  'CUST_NAME' : instance.CUST_NAME,
};
