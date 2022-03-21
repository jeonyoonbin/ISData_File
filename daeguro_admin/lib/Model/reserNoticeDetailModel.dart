import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ReserNoticeDetailModel {
  ReserNoticeDetailModel();

  bool selected = false;
  int noticeSeq;
  String noticeGbn;
  String dispGbn;
  String frDate;
  String toDate;
  String title;
  String contents;
  String url1;
  String url2;
  String url3;
  String orderDate;
  String insDate;

  factory ReserNoticeDetailModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ReserNoticeDetailModel _$ModelFromJson(Map<String, dynamic> json) {
  return ReserNoticeDetailModel()
    ..selected = json['selected'] as bool
    ..noticeSeq = json['noticeSeq'] as int
    ..noticeGbn = json['noticeGbn'] as String
    ..dispGbn = json['dispGbn'] as String
    ..frDate = json['frDate'] as String
    ..toDate = json['toDate'] as String
    ..title = json['title'] as String
    ..contents = json['contents'] as String
    ..url1 = json['url1'] as String
    ..url2 = json['url2'] as String
    ..url3 = json['url3'] as String
    ..orderDate = json['orderDate'] as String
    ..insDate = json['insDate'] as String;
}

Map<String, dynamic> _$ModelToJson(ReserNoticeDetailModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'noticeSeq': instance.noticeSeq,
  'noticeGbn': instance.noticeGbn,
  'dispGbn': instance.dispGbn,
  'frDate': instance.frDate,
  'toDate': instance.toDate,
  'title': instance.title,
  'contents': instance.contents,
  'url1': instance.url1,
  'url2': instance.url2,
  'url3': instance.url3,
  'orderDate': instance.orderDate,
  'insDate': instance.insDate
};
