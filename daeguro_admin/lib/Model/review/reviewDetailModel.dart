import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class reviewDetailModel {
  reviewDetailModel();

  bool selected = false;
  int CUST_CODE;
  String CUST_NAME;
  String CONTENT_TEXT;
  String FILE_IMG_1;
  String FILE_IMG_2;
  String FILE_IMG_3;
  String BLIND_REQ_DT;
  String BLIND_STAND_DT;
  String BLIND_END_DT;
  String CODE_NM;
  String BLIEND_REASON;
  String ANSWER_TEXT;
  String BLIEND_AGREE_GBN;

  factory reviewDetailModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

reviewDetailModel _$ModelFromJson(Map<String, dynamic> json) {
  return reviewDetailModel()
    ..selected = json['selected'] as bool
    ..CUST_CODE = json['CUST_CODE'] as int
    ..CUST_NAME = json['CUST_NAME'] as String
    ..CONTENT_TEXT = json['CONTENT_TEXT'] as String
    ..FILE_IMG_1 = json['FILE_IMG_1'] as String
    ..FILE_IMG_2 = json['FILE_IMG_2'] as String
    ..FILE_IMG_3 = json['FILE_IMG_3'] as String
    ..BLIND_REQ_DT = json['BLIND_REQ_DT'] as String
    ..BLIND_STAND_DT = json['BLIND_STAND_DT'] as String
    ..BLIND_END_DT = json['BLIND_END_DT'] as String
    ..CODE_NM = json['CODE_NM'] as String
    ..BLIEND_REASON = json['BLIEND_REASON'] as String
    ..ANSWER_TEXT = json['ANSWER_TEXT'] as String
    ..BLIEND_AGREE_GBN = json['BLIEND_AGREE_GBN'] as String;
}

Map<String, dynamic> _$ModelToJson(reviewDetailModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'CUST_CODE': instance.CUST_CODE,
  'CUST_NAME': instance.CUST_NAME,
  'CONTENT_TEXT': instance.CONTENT_TEXT,
  'FILE_IMG_1': instance.FILE_IMG_1,
  'FILE_IMG_2': instance.FILE_IMG_2,
  'FILE_IMG_3': instance.FILE_IMG_3,
  'BLIND_REQ_DT': instance.BLIND_REQ_DT,
  'BLIND_STAND_DT': instance.BLIND_STAND_DT,
  'BLIND_END_DT': instance.BLIND_END_DT,
  'CODE_NM': instance.CODE_NM,
  'BLIEND_REASON': instance.BLIEND_REASON,
  'ANSWER_TEXT': instance.ANSWER_TEXT,
  'BLIEND_AGREE_GBN': instance.BLIEND_AGREE_GBN
};
