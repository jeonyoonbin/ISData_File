
class CalculateCommissionModel {
  CalculateCommissionModel();

  bool selected = false;
  String yymm;
  String ccName;
  String shopCd;
  String shopName;
  String telNo;
  String regNo;
  String regNoStatus;
  String taxNo;
  int pgmInAmt;
  int pgmOutAmt;
  int pgmAmt;
  int totCnt;
  int compCnt;
  int cancelCnt;
  String prtYn;
  String status;

  factory CalculateCommissionModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String,dynamic> toJson() => _$ModelToJson(this);
}

CalculateCommissionModel _$ModelFromJson(Map<String,dynamic> json) {
  return CalculateCommissionModel()
      ..selected = json['selected'] as bool
      ..yymm = json['YYMM'] as String
      ..ccName = json['CCNAME'] as String
      ..shopCd = json['SHOP_CD'] as String
      ..shopName = json['SHOP_NAME'] as String
      ..telNo = json['TELNO'] as String
      ..regNo = json['REG_NO'] as String
      ..regNoStatus = json['REG_NO_STATUS'] as String
      ..taxNo = json['TAX_NO'] as String
      ..pgmInAmt = json['PGM_IN_AMT'] as int
      ..pgmOutAmt = json['PGM_OUT_AMT'] as int
      ..pgmAmt = json['PGM_AMT'] as int
      ..totCnt = json['TOT_CNT'] as int
      ..compCnt = json['COMP_CNT'] as int
      ..cancelCnt = json['CANCEL_CNT'] as int
      ..prtYn = json['PRT_YN'] as String
      ..status = json['STATUS'] as String;
}

Map<String,dynamic> _$ModelToJson(CalculateCommissionModel instance) => <String,dynamic> {
  'selected': instance.selected,
  'YYMM': instance.yymm,
  'CCNAME': instance.ccName,
  'SHOP_CD': instance.shopCd,
  'SHOP_NAME': instance.shopName,
  'TELNO': instance.telNo,
  'REG_NO': instance.regNo,
  'REG_NO_STATUS': instance.regNoStatus,
  'TAX_NO': instance.taxNo,
  'PGM_IN_AMT': instance.pgmInAmt,
  'PGM_OUT_AMT': instance.pgmOutAmt,
  'PGM_AMT': instance.pgmAmt,
  'TOT_CNT': instance.totCnt,
  'COMP_CNT': instance.compCnt,
  'CANCEL_CNT': instance.cancelCnt,
  'PRT_YN': instance.prtYn,
  'STATUS': instance.status
};