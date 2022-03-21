import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class RequestListModel {
  RequestListModel();

  bool selected = false;
  int SEQ;
  String INSERT_DATE;
  String SHOP_NAME;
  String STATUS;
  String SERVICE_GBN_CODE;
  String SERVICE_GBN;
  String CANCEL_REQ_YN;
  int ALLOC_UCODE;
  String ALLOC_UNAME;

  factory RequestListModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

RequestListModel _$ModelFromJson(Map<String, dynamic> json) {
  return RequestListModel()
    ..selected = json['selected'] as bool
    ..SEQ = json['SEQ'] as int
    ..INSERT_DATE = json['INSERT_DATE'] as String
    ..SHOP_NAME = json['SHOP_NAME'] as String
    ..STATUS = json['STATUS'] as String
    ..SERVICE_GBN_CODE = json['SERVICE_GBN_CODE'] as String
    ..SERVICE_GBN = json['SERVICE_GBN'] as String
    ..CANCEL_REQ_YN = json['CANCEL_REQ_YN'] as String
    ..ALLOC_UCODE = json['ALLOC_UCODE'] as int
    ..ALLOC_UNAME = json['ALLOC_UNAME'] as String;
}

Map<String, dynamic> _$ModelToJson(RequestListModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'SEQ': instance.SEQ,
  'INSERT_DATE': instance.INSERT_DATE,
  'SHOP_NAME': instance.SHOP_NAME,
  'STATUS': instance.STATUS,
  'SERVICE_GBN_CODE': instance.SERVICE_GBN_CODE,
  'SERVICE_GBN': instance.SERVICE_GBN,
  'CANCEL_REQ_YN': instance.CANCEL_REQ_YN,
  'ALLOC_UCODE': instance.ALLOC_UCODE,
  'ALLOC_UNAME': instance.ALLOC_UNAME,
};
