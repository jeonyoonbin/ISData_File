import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class noticeSortListModel {
  noticeSortListModel();

  bool selected = false;
  int NOTICE_SEQ;
  String NOTICE_GBN;
  String NOTICE_TITLE;
  String DISP_FR_DATE;
  String DISP_TO_DATE;

  factory noticeSortListModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

noticeSortListModel _$ModelFromJson(Map<String, dynamic> json) {
  return noticeSortListModel()
    ..selected = json['selected'] as bool
    ..NOTICE_SEQ = json['NOTICE_SEQ'] as int
    ..NOTICE_GBN = json['NOTICE_GBN'] as String
    ..NOTICE_TITLE = json['NOTICE_TITLE'] as String
    ..DISP_FR_DATE = json['DISP_FR_DATE'] as String
    ..DISP_TO_DATE = json['DISP_TO_DATE'] as String;
}

Map<String, dynamic> _$ModelToJson(noticeSortListModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'NOTICE_SEQ': instance.NOTICE_SEQ,
  'NOTICE_GBN': instance.NOTICE_GBN,
  'NOTICE_TITLE': instance.NOTICE_TITLE,
  'DISP_FR_DATE': instance.DISP_FR_DATE,
  'DISP_TO_DATE': instance.DISP_TO_DATE,
};
