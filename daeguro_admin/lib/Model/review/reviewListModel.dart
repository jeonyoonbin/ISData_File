import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class reviewListModel {
  reviewListModel();

  bool selected = false;
  int RNUM;
  String SHOP_CD;
  String SHOP_NAME;
  int ORDER_SEQNO;
  String BLIEND_TYPE;
  String BLIEND_AGREE_GBN;
  String VISBLE_GBN;
  int STAR_RATING;
  int CUST_CODE;
  String TELNO;
  String CUST_NAME;
  int REPORT_COUNT;
  String CONTENT;
  String INSERT_DATE;
  String BLIND_REQ_DT;
  String IMAGE_YN;
  String STATUS;

  factory reviewListModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

reviewListModel _$ModelFromJson(Map<String, dynamic> json) {
  return reviewListModel()
    ..selected = json['selected'] as bool
    ..RNUM = json['RNUM'] as int
    ..SHOP_CD = json['SHOP_CD'] as String
    ..SHOP_NAME = json['SHOP_NAME'] as String
    ..ORDER_SEQNO = json['ORDER_SEQNO'] as int
    ..BLIEND_TYPE = json['BLIEND_TYPE'] as String
    ..BLIEND_AGREE_GBN = json['BLIEND_AGREE_GBN'] as String
    ..VISBLE_GBN = json['VISBLE_GBN'] as String
    ..STAR_RATING = json['STAR_RATING'] as int
    ..CUST_CODE = json['CUST_CODE'] as int
    ..TELNO = json['TELNO'] as String
    ..CUST_NAME = json['CUST_NAME'] as String
    ..REPORT_COUNT = json['REPORT_COUNT'] as int
    ..CONTENT = json['CONTENT'] as String
    ..INSERT_DATE = json['INSERT_DATE'] as String
    ..BLIND_REQ_DT = json['BLIND_REQ_DT'] as String
    ..IMAGE_YN = json['IMAGE_YN'] as String
    ..STATUS = json['STATUS'] as String;
}

Map<String, dynamic> _$ModelToJson(reviewListModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'RNUM': instance.RNUM,
  'SHOP_CD': instance.SHOP_CD,
  'SHOP_NAME': instance.SHOP_NAME,
  'ORDER_SEQNO': instance.ORDER_SEQNO,
  'BLIEND_TYPE': instance.BLIEND_TYPE,
  'BLIEND_AGREE_GBN': instance.BLIEND_AGREE_GBN,
  'VISBLE_GBN': instance.VISBLE_GBN,
  'STAR_RATING': instance.STAR_RATING,
  'CUST_CODE': instance.CUST_CODE,
  'TELNO': instance.TELNO,
  'CUST_NAME': instance.CUST_NAME,
  'REPORT_COUNT': instance.REPORT_COUNT,
  'CONTENT': instance.CONTENT,
  'INSERT_DATE': instance.INSERT_DATE,
  'BLIND_REQ_DT': instance.BLIND_REQ_DT,
  'IMAGE_YN': instance.IMAGE_YN,
  'STATUS': instance.STATUS,
};
