
class CalculateSearchShopTaxModel {
  CalculateSearchShopTaxModel();

  bool selected = false;
  String orderYm;
  String mcode;
  String cccode;
  String shopCd;
  String shopName;
  String issymd;
  String taxNo;
  String taxGbn;
  String saleGbn;
  String supamt;
  String vatamt;
  String amt;
  String memo;
  String prtYn;
  String prtDate;
  String prtGbn;
  String etaxYn;
  String reqDate;
  String status;
  String rtnMsg;
  String rtnDate;
  String isrtUcode;
  String isrtDate;
  String modUcode;
  String modDate;
  String canReason;
  String receiptId;
  String etaxSeq;
  String taxAcc;
  String feeYm;
  String fdiaGbn;
  String apiComGbn;
  String cret_yn;
  String mName;
  String mainCcname;
  String regNo;


  factory CalculateSearchShopTaxModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String,dynamic> toJson() => _$ModelToJson(this);
}

CalculateSearchShopTaxModel _$ModelFromJson(Map<String,dynamic> json) {
  return CalculateSearchShopTaxModel()
    ..orderYm = json['orderYm'] as String
    ..mcode = json['mcode'] as String
    ..cccode = json['cccode'] as String
    ..shopCd = json['shopCd'] as String
    ..shopName = json['shopName'] as String
    ..issymd = json['issymd'] as String
    ..taxNo = json['taxNo'] as String
    ..taxGbn = json['taxGbn'] as String
    ..saleGbn = json['saleGbn'] as String
    ..supamt = json['supamt'] as String
    ..vatamt = json['vatamt'] as String
    ..amt = json['amt'] as String
    ..memo = json['memo'] as String
    ..prtYn = json['prtYn'] as String
    ..prtDate = json['prtDate'] as String
    ..prtGbn = json['prtGbn'] as String
    ..etaxYn = json['etaxYn'] as String
    ..reqDate = json['reqDate'] as String
    ..status = json['status'] as String
    ..rtnMsg = json['rtnMsg'] as String
    ..rtnDate = json['rtnDate'] as String
    ..isrtUcode = json['isrtUcode'] as String
    ..isrtDate = json['isrtDate'] as String
    ..modUcode = json['modUcode'] as String
    ..modDate = json['modDate'] as String
    ..canReason = json['canReason'] as String
    ..receiptId = json['receiptId'] as String
    ..etaxSeq = json['etaxSeq'] as String
    ..taxAcc = json['taxAcc'] as String
    ..feeYm = json['feeYm'] as String
    ..fdiaGbn = json['fdiaGbn'] as String
    ..apiComGbn = json['apiComGbn'] as String
    ..cret_yn = json['cret_yn'] as String
    ..mName = json['mName'] as String
    ..mainCcname = json['mainCcname'] as String
    ..regNo = json['regNo'] as String;
}

Map<String,dynamic> _$ModelToJson(CalculateSearchShopTaxModel instance) => <String,dynamic> {
  'orderYm': instance.orderYm,
  'mcode': instance.mcode,
  'cccode': instance.cccode,
  'shopCd': instance.shopCd,
  'shopName': instance.shopName,
  'issymd': instance.issymd,
  'taxNo': instance.taxNo,
  'taxGbn': instance.taxGbn,
  'saleGbn': instance.saleGbn,
  'supamt': instance.supamt,
  'vatamt': instance.vatamt,
  'amt': instance.amt,
  'memo': instance.memo,
  'prtYn': instance.prtYn,
  'prtDate': instance.prtDate,
  'prtGbn': instance.prtGbn,
  'etaxYn': instance.etaxYn,
  'reqDate': instance.reqDate,
  'status': instance.status,
  'rtnMsg': instance.rtnMsg,
  'rtnDate': instance.rtnDate,
  'isrtUcode': instance.isrtUcode,
  'isrtDate': instance.isrtDate,
  'modUcode': instance.modUcode,
  'modDate': instance.modDate,
  'canReason': instance.canReason,
  'receiptId': instance.receiptId,
  'etaxSeq': instance.etaxSeq,
  'taxAcc': instance.taxAcc,
  'feeYm': instance.feeYm,
  'fdiaGbn': instance.fdiaGbn,
  'apiComGbn': instance.apiComGbn,
  'cret_yn': instance.cret_yn,
  'mName': instance.mName,
  'mainCcname': instance.mainCcname,
  'regNo': instance.regNo,
};