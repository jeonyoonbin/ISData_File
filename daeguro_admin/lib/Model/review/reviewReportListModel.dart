import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class reviewReportListModel {
  reviewReportListModel();

  bool selected = false;
  int CUST_CODE;
  String CUST_NAME;
  int RNUM;
  int REVIEW_SEQNO;
  String REPORT_REASON;
  String INSERT_DATE;
  String USE_YN;

  factory reviewReportListModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

reviewReportListModel _$ModelFromJson(Map<String, dynamic> json) {
  return reviewReportListModel()
    ..selected = json['selected'] as bool
    ..CUST_CODE = json['CUST_CODE'] as int
    ..CUST_NAME = json['CUST_NAME'] as String
    ..RNUM = json['RNUM'] as int
    ..REVIEW_SEQNO = json['REVIEW_SEQNO'] as int
    ..REPORT_REASON = json['REPORT_REASON'] as String
    ..INSERT_DATE = json['INSERT_DATE'] as String
    ..USE_YN = json['USE_YN'] as String;
}

Map<String, dynamic> _$ModelToJson(reviewReportListModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'CUST_CODE': instance.CUST_CODE,
  'CUST_NAME': instance.CUST_NAME,
  'RNUM': instance.RNUM,
  'REVIEW_SEQNO': instance.REVIEW_SEQNO,
  'REPORT_REASON': instance.REPORT_REASON,
  'INSERT_DATE': instance.INSERT_DATE,
  'USE_YN': instance.USE_YN,
};
