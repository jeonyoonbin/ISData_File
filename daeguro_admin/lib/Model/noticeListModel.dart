import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class noticeListModel {
  noticeListModel();

  bool selected = false;
  String noticeSeq;
  String noticeGbn;
  String dispGbn;
  String dispFromDate;
  String dispToDate;
  String noticeTitle;
  String noticeContents;
  String noticeUrl_1;
  String noticeUrl_2;
  String noticeUrl_3;
  String orderDate;
  String insDate;
  String insUCode;
  String insName;
  String modUCode;
  String modName;

  factory noticeListModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

noticeListModel _$ModelFromJson(Map<String, dynamic> json) {
  return noticeListModel()
    ..selected = json['selected'] as bool
    ..noticeSeq = json['noticeSeq'] as String
    ..noticeGbn = json['noticeGbn'] as String
    ..dispGbn = json['dispGbn'] as String
    ..dispFromDate = json['dispFromDate'] as String
    ..dispToDate = json['dispToDate'] as String
    ..noticeTitle = json['noticeTitle'] as String
    ..noticeContents = json['noticeContents'] as String
    ..noticeUrl_1 = json['noticeUrl_1'] as String
    ..noticeUrl_2 = json['noticeUrl_2'] as String
    ..noticeUrl_3 = json['noticeUrl_3'] as String
    ..orderDate = json['orderDate'] as String
    ..insDate = json['insDate'] as String
    ..insUCode = json['insUCode'] as String
    ..insName = json['insName'] as String
    ..modUCode = json['modUCode'] as String
    ..modName = json['modName'] as String;
}

Map<String, dynamic> _$ModelToJson(noticeListModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'noticeSeq': instance.noticeSeq,
  'noticeGbn': instance.noticeGbn,
  'dispGbn': instance.dispGbn,
  'dispFromDate': instance.dispFromDate,
  'dispToDate': instance.dispToDate,
  'noticeTitle': instance.noticeTitle,
  'noticeContents': instance.noticeContents,
  'noticeUrl_1': instance.noticeUrl_1,
  'noticeUrl_2': instance.noticeUrl_2,
  'noticeUrl_3': instance.noticeUrl_3,
  'orderDate': instance.orderDate,
  'insDate': instance.insDate,
  'insUCode': instance.insUCode,
  'insName': instance.insName,
  'modUCode': instance.modUCode,
  'modName': instance.modName,
};
