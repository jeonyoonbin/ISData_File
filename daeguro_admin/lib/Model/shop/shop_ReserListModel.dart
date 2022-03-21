import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopReserListModel {
  ShopReserListModel();

  bool selected = false;
  String shopCd;
  int seqNo;
  String reserDate;
  String reserTime;
  int custCode;
  String custId;
  String custName;
  String custTelno;
  String mobileNo;
  String mobileNo1;
  String injengGbn;
  int personCnt;
  String status;
  String allocDate;
  String compDate;
  String cancelDate;
  String payGbn;
  int orderNo;
  String location;
  String memo;
  String isrtDate;
  String modDate;
  String modId;
  String modGbn;
  String posSendGbn;
  String posSendDate;

  factory ShopReserListModel.fromJson(Map<String, dynamic> json) => _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopReserListModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopReserListModel()
    ..selected = json['selected'] as bool
    ..shopCd = json['shopCd'] as String
    ..seqNo = json['seqNo'] as int
    ..reserDate = json['reserDate'] as String
    ..reserTime = json['reserTime'] as String
    ..custCode = json['custCode'] as int
    ..custId = json['custId'] as String
    ..custName = json['custName'] as String
    ..custTelno = json['custTelno'] as String
    ..mobileNo = json['mobileNo'] as String
    ..mobileNo1 = json['mobileNo1'] as String
    ..injengGbn = json['injengGbn'] as String
    ..personCnt = json['personCnt'] as int
    ..status = json['status'] as String
    ..allocDate = json['allocDate'] as String
    ..compDate = json['compDate'] as String
    ..cancelDate = json['cancelDate'] as String
    ..payGbn = json['payGbn'] as String
    ..orderNo = json['orderNo'] as int
    ..location = json['location'] as String
    ..memo = json['memo'] as String
    ..isrtDate = json['isrtDate'] as String
    ..modDate = json['modDate'] as String
    ..modId = json['modId'] as String
    ..modGbn = json['modGbn'] as String
    ..posSendGbn = json['posSendGbn'] as String
    ..posSendDate = json['posSendDate'] as String;
}

Map<String, dynamic> _$ModelToJson(ShopReserListModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'shopCd': instance.shopCd,
  'seqNo': instance.seqNo,
  'reserDate': instance.reserDate,
  'reserTime': instance.reserTime,
  'custCode': instance.custCode,
  'custId': instance.custId,
  'custName': instance.custName,
  'custTelno': instance.custTelno,
  'mobileNo': instance.mobileNo,
  'mobileNo1': instance.mobileNo1,
  'injengGbn': instance.injengGbn,
  'personCnt': instance.personCnt,
  'status': instance.status,
  'allocDate': instance.allocDate,
  'compDate': instance.compDate,
  'cancelDate': instance.cancelDate,
  'payGbn': instance.payGbn,
  'orderNo': instance.orderNo,
  'location': instance.location,
  'memo': instance.memo,
  'isrtDate': instance.isrtDate,
  'modDate': instance.modDate,
  'modId': instance.modId,
  'modGbn': instance.modGbn,
  'posSendGbn': instance.posSendGbn,
  'posSendDate': instance.posSendDate
};
