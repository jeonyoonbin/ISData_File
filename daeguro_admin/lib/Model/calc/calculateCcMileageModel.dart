
class CalculateCcMileageModel {
  CalculateCcMileageModel();

  bool selected = false;
  int rNum;
  int seqNo;
  String ccCode;
  String ccName;
  String orderDate;
  String chargeDate;
  String chargeGbn;
  String chargeGbnNm;
  int preAmt;
  int inAmt;
  int outAmt;
  int chargeUcode;
  String chargeName;
  String memo;
  int mCode;
  String mName;
  String groupId;
  int orderNo;
  String shopCd;
  String shopName;
  int orderMcode;
  int preAmtSum;

  factory CalculateCcMileageModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String,dynamic> toJson() => _$ModelToJson(this);
}

CalculateCcMileageModel _$ModelFromJson(Map<String,dynamic> json) {
  return CalculateCcMileageModel()
      ..selected = json['selected'] as bool
      ..rNum = json['RNUM'] as int
      ..seqNo = json['SEQNO'] as int
      ..ccCode = json['CCCODE'] as String
      ..ccName = json['CCNAME'] as String
      ..orderDate = json['ORDER_DATE'] as String
      ..chargeDate = json['CHARGE_DATE'] as String
      ..chargeGbn = json['CHARGE_GBN'] as String
      ..chargeGbnNm = json['CHARGE_GBN_NM'] as String
      ..preAmt = json['PRE_AMT'] as int
      ..inAmt = json['IN_AMT'] as int
      ..outAmt = json['OUT_AMT'] as int
      ..chargeUcode = json['CHARGE_UCODE'] as int
      ..chargeName = json['CHARGE_NAME'] as String
      ..memo = json['MEMO'] as String
      ..mCode = json['MCODE'] as int
      ..mName = json['MNAME'] as String
      ..groupId = json['GROUP_ID'] as String
      ..orderNo = json['ORDER_NO'] as int
      ..shopCd  = json['SHOP_CD'] as String
      ..shopName = json['SHOP_NAME'] as String
      ..orderMcode = json['ORDER_MCODE'] as int
      ..preAmtSum = json['PRE_AMT_SUM'] as int;
}

Map<String,dynamic> _$ModelToJson(CalculateCcMileageModel instance) => <String,dynamic> {
  'selected': instance.selected,
  'RNUM': instance.rNum,
  'SEQNO': instance.seqNo,
  'CCCODE': instance.ccCode,
  'CCNAME': instance.ccName,
  'ORDER_DATE': instance.orderDate,
  'CHARGE_DATE': instance.chargeDate,
  'CHARGE_GBN': instance.chargeGbn,
  'CHARGE_GBN_NM': instance.chargeGbnNm,
  'PRE_AMT': instance.preAmt,
  'IN_AMT': instance.inAmt,
  'OUT_AMT': instance.outAmt,
  'CHARGE_UCODE': instance.chargeUcode,
  'CHARGE_NAME': instance.chargeName,
  'MEMO': instance.memo,
  'MCODE': instance.mCode,
  'MNAME': instance.mName,
  'GROUP_ID': instance.groupId,
  'ORDER_NO': instance.orderNo,
  'SHOP_CD': instance.shopCd,
  'SHOP_NAME': instance.shopName,
  'ORDER_MCODE': instance.orderMcode,
  'PRE_AMT_SUM': instance.preAmtSum
};