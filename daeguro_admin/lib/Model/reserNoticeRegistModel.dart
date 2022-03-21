import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ReserNoticeRegistModel {
  ReserNoticeRegistModel();

  bool selected = false;
  String noticeGbn;
  String dispGbn;
  String dispFrDate;
  String dispToDate;
  String title;
  String contents;
  String url2;
  String orderDate;
  int ucode;
  String userName;
  String insDate;

  factory ReserNoticeRegistModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ReserNoticeRegistModel _$ModelFromJson(Map<String, dynamic> json) {
  return ReserNoticeRegistModel()
    ..selected = json['selected'] as bool
    ..noticeGbn = json['noticeGbn'] as String
    ..dispGbn = json['dispGbn'] as String
    ..dispFrDate = json['dispFrDate'] as String
    ..dispToDate = json['dispToDate'] as String
    ..title = json['title'] as String
    ..contents = json['contents'] as String
    ..url2 = json['url2'] as String
    ..orderDate = json['orderDate'] as String
    ..ucode = json['insUcode'] as int
    ..userName = json['insName'] as String
    ..insDate = json['insDate'] as String;
}

Map<String, dynamic> _$ModelToJson(ReserNoticeRegistModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'noticeGbn': instance.noticeGbn,
  'dispGbn': instance.dispGbn,
  'dispFrDate': instance.dispFrDate,
  'dispToDate': instance.dispToDate,
  'title': instance.title,
  'contents': instance.contents,
  'url2': instance.url2,
  'orderDate': instance.orderDate,
  'ucode': instance.ucode,
  'userName': instance.userName,
  'insDate': instance.insDate
};
