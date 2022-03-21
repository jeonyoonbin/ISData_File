import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class DashBoardNoticeModel {
  DashBoardNoticeModel();

  int NOTICE_SEQ;
  String NOTICE_GBN;
  String TITLE;

  factory DashBoardNoticeModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

DashBoardNoticeModel _$ModelFromJson(Map<String, dynamic> json) {
  return DashBoardNoticeModel()
    ..NOTICE_SEQ = json['NOTICE_SEQ'] as int
    ..NOTICE_GBN = json['NOTICE_GBN'] as String
    ..TITLE = json['TITLE'] as String;
}

Map<String, dynamic> _$ModelToJson(DashBoardNoticeModel instance) => <String, dynamic>{
  'NOTICE_SEQ': instance.NOTICE_SEQ,
  'NOTICE_GBN': instance.NOTICE_GBN,
  'TITLE': instance.TITLE
};
