import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
// ignore: camel_case_types
class taxiCouponStatusChangeModel {
  taxiCouponStatusChangeModel();

  String divDevice;
  String idUsrUpd;
  String nmUsrUpd;
  String noCoup;
  String cdComp;
  String divStatus;
  String idConfUsr;
  String nmConfUsr;
  String idPers;
  String cdCompPers;
  String dtOrdNo;
  String seqOrdNo;

  factory taxiCouponStatusChangeModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

taxiCouponStatusChangeModel _$ModelFromJson(Map<String, dynamic> json) {
  return taxiCouponStatusChangeModel()
    ..divDevice = json['divDevice'] as String
    ..idUsrUpd = json['idUsrUpd'] as String
    ..nmUsrUpd = json['nmUsrUpd'] as String
    ..noCoup = json['noCoup'] as String
    ..cdComp = json['cdComp'] as String
    ..divStatus = json['divStatus'] as String
    ..idConfUsr = json['idConfUsr'] as String
    ..nmConfUsr = json['nmConfUsr'] as String
    ..idPers = json['idPers'] as String
    ..cdCompPers = json['cdCompPers'] as String
    ..dtOrdNo = json['dtOrdNo'] as String
    ..seqOrdNo = json['seqOrdNo'] as String;
}

Map<String, dynamic> _$ModelToJson(taxiCouponStatusChangeModel instance) => <String, dynamic>{
  'divDevice': instance.divDevice,
  'idUsrUpd': instance.idUsrUpd,
  'nmUsrUpd': instance.nmUsrUpd,
  'noCoup': instance.noCoup,
  'cdComp': instance.cdComp,
  'divStatus': instance.divStatus,
  'idConfUsr': instance.idConfUsr,
  'nmConfUsr': instance.nmConfUsr,
  'idPers': instance.idPers,
  'cdCompPers': instance.cdCompPers,
  'dtOrdNo': instance.dtOrdNo,
  'seqOrdNo': instance.seqOrdNo,
};