import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class reserNoticeSortListModel {
  reserNoticeSortListModel();

  bool selected = false;
  int noticeSeq;
  String noticeGbn;
  String title;
  String frDate;
  String toDate;

  factory reserNoticeSortListModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

reserNoticeSortListModel _$ModelFromJson(Map<String, dynamic> json) {
  return reserNoticeSortListModel()
    ..selected = json['selected'] as bool
    ..noticeSeq = json['noticeSeq'] as int
    ..noticeGbn = json['noticeGbn'] as String
    ..title = json['title'] as String
    ..frDate = json['frDate'] as String
    ..toDate = json['toDate'] as String;
}

Map<String, dynamic> _$ModelToJson(reserNoticeSortListModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'noticeSeq': instance.noticeSeq,
  'noticeGbn': instance.noticeGbn,
  'title': instance.title,
  'frDate': instance.frDate,
  'toDate': instance.toDate,
};
