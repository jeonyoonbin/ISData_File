import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class taxiCouponDetailModel {
  taxiCouponDetailModel();

  bool selected = false;
  String noCoup;
  String dtmIns;
  String idUsrIns;
  String nmUsrIns;
  String dtmUpd;
  String idUsrUpd;
  String nmUsrUpd;
  String cdComp;
  String nmComp;
  String cdCoup;
  String cdCoupText;
  String nmCoup;
  String ynUse;
  String ynUseText;
  String cntMax;
  String divStatus;
  String divStatusText;
  String dtmStatus;
  String amtCoup;
  String amtIsd;
  String dtmConf;
  String idConfUsr;
  String nmConfUsr;
  String dtStart;
  String dtEnd;
  String dtDis;
  String urlLink;
  String idPers;
  String idUsePers;
  String dtmUse;
  String amtMinCoupon;
  String divCoup;
  String divCoupText;
  String dtOrdNoFr;
  String seqOrdNoFr;
  String dtOrdNo;
  String seqOrdNo;
  String cdCompPers;
  String cdCompUsePers;

  factory taxiCouponDetailModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

taxiCouponDetailModel _$ModelFromJson(Map<String, dynamic> json) {
  return taxiCouponDetailModel()
    ..selected = json['selected'] as bool
    ..noCoup = json['noCoup'] as String
    ..dtmIns = json['dtmIns'] as String
    ..idUsrIns = json['idUsrIns'] as String
    ..nmUsrIns = json['nmUsrIns'] as String
    ..dtmUpd = json['dtmUpd'] as String
    ..idUsrUpd = json['idUsrUpd'] as String
    ..nmUsrUpd = json['nmUsrUpd'] as String
    ..cdComp = json['cdComp'] as String
    ..nmComp = json['nmComp'] as String
    ..cdCoup = json['cdCoup'] as String
    ..cdCoupText = json['cdCoupText'] as String
    ..nmCoup = json['nmCoup'] as String
    ..ynUse = json['ynUse'] as String
    ..ynUseText = json['ynUseText'] as String
    ..cntMax = json['cntMax'] as String
    ..divStatus = json['divStatus'] as String
    ..divStatusText = json['divStatusText'] as String
    ..dtmStatus = json['dtmStatus'] as String
    ..amtCoup = json['amtCoup'] as String
    ..amtIsd = json['amtIsd'] as String
    ..dtmConf = json['dtmConf'] as String
    ..idConfUsr = json['idConfUsr'] as String
    ..nmConfUsr = json['nmConfUsr'] as String
    ..dtStart = json['dtStart'] as String
    ..dtEnd = json['dtEnd'] as String
    ..dtDis = json['dtDis'] as String
    ..urlLink = json['urlLink'] as String
    ..idPers = json['idPers'] as String
    ..idUsePers = json['idUsePers'] as String
    ..dtmUse = json['dtmUse'] as String
    ..amtMinCoupon = json['amtMinCoupon'] as String
    ..divCoup = json['divCoup'] as String
    ..divCoupText = json['divCoupText'] as String
    ..dtOrdNoFr = json['dtOrdNoFr'] as String
    ..seqOrdNoFr = json['seqOrdNoFr'] as String
    ..dtOrdNo = json['dtOrdNo'] as String
    ..seqOrdNo = json['seqOrdNo'] as String
    ..cdCompPers = json['cdCompPers'] as String
    ..cdCompUsePers = json['cdCompUsePers'] as String;

}

Map<String, dynamic> _$ModelToJson(taxiCouponDetailModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'noCoup': instance.noCoup,
  'dtmIns': instance.dtmIns,
  'idUsrIns': instance.idUsrIns,
  'nmUsrIns': instance.nmUsrIns,
  'dtmUpd': instance.dtmUpd,
  'idUsrUpd': instance.idUsrUpd,
  'nmUsrUpd': instance.nmUsrUpd,
  'cdComp': instance.cdComp,
  'nmComp': instance.nmComp,
  'cdCoup': instance.cdCoup,
  'cdCoupText': instance.cdCoupText,
  'nmCoup': instance.nmCoup,
  'ynUse': instance.ynUse,
  'ynUseText': instance.ynUseText,
  'cntMax': instance.cntMax,
  'divStatus': instance.divStatus,
  'divStatusText': instance.divStatusText,
  'dtmStatus': instance.dtmStatus,
  'amtCoup': instance.amtCoup,
  'amtIsd': instance.amtIsd,
  'dtmConf': instance.dtmConf,
  'idConfUsr': instance.idConfUsr,
  'nmConfUsr': instance.nmConfUsr,
  'dtStart': instance.dtStart,
  'dtEnd': instance.dtEnd,
  'dtDis': instance.dtDis,
  'urlLink': instance.urlLink,
  'idPers': instance.idPers,
  'idUsePers': instance.idUsePers,
  'dtmUse': instance.dtmUse,
  'amtMinCoupon': instance.amtMinCoupon,
  'divCoup': instance.divCoup,
  'divCoupText': instance.divCoupText,
  'dtOrdNoFr': instance.dtOrdNoFr,
  'seqOrdNoFr': instance.seqOrdNoFr,
  'dtOrdNo': instance.dtOrdNo,
  'seqOrdNo': instance.seqOrdNo,
  'cdCompPers': instance.cdCompPers,
  'cdCompUsePers': instance.cdCompUsePers
};
