
class CalculateUngeneratedTaxModel {
  CalculateUngeneratedTaxModel();

  bool selected = false;
  String shopCd;
  String shopName;
  String regNo;
  String chargeYm;
  String issymd;
  String chargeAmt;

  factory CalculateUngeneratedTaxModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String,dynamic> toJson() => _$ModelToJson(this);
}

CalculateUngeneratedTaxModel _$ModelFromJson(Map<String,dynamic> json) {
  return CalculateUngeneratedTaxModel()
    ..selected = json['selected'] as bool
    ..shopCd = json['shopCd'] as String
    ..shopName = json['shopName'] as String
    ..regNo = json['regNo'] as String
    ..chargeYm = json['chargeYm'] as String
    ..issymd = json['issymd'] as String
    ..chargeAmt = json['chargeAmt'] as String;
}

Map<String,dynamic> _$ModelToJson(CalculateUngeneratedTaxModel instance) => <String,dynamic> {
  'selected': instance.selected,
  'shopCd': instance.shopCd,
  'shopName': instance.shopName,
  'regNo': instance.regNo,
  'chargeYm': instance.chargeYm,
  'issymd': instance.issymd,
  'chargeAmt': instance.chargeAmt,
};