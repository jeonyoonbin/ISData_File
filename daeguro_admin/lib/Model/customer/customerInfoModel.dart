import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class CustomerInfoModel {
  CustomerInfoModel();

  bool selected = false;
  String CUST_NAME;
  String TELNO;
  String CUST_ID;
  String CUST_PASSWORD;
  String BIRTHDAY;
  String INSERT_DATE;
  String DEL_DATE;
  String OLD_ADDR;
  String NEW_ADDR;
  String CUST_ID_GBN;
  String MEMO;
  String RETIRE_DATE;

  factory CustomerInfoModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

CustomerInfoModel _$ModelFromJson(Map<String, dynamic> json) {
  return CustomerInfoModel()
    ..selected = json['selected'] as bool
    ..CUST_NAME = json['CUST_NAME'] as String
    ..TELNO = json['TELNO'] as String
    ..CUST_ID = json['CUST_ID'] as String
    ..CUST_PASSWORD = json['CUST_PASSWORD'] as String
    ..BIRTHDAY = json['BIRTHDAY'] as String
    ..INSERT_DATE = json['INSERT_DATE'] as String
    ..DEL_DATE = json['DEL_DATE'] as String
    ..OLD_ADDR = json['OLD_ADDR'] as String
    ..NEW_ADDR = json['NEW_ADDR'] as String
    ..CUST_ID_GBN = json['CUST_ID_GBN'] as String
    ..MEMO = json['MEMO'] as String
    ..RETIRE_DATE = json['RETIRE_DATE'] as String;
}

Map<String, dynamic> _$ModelToJson(CustomerInfoModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'CUST_NAME': instance.CUST_NAME,
  'TELNO': instance.TELNO,
  'CUST_ID': instance.CUST_ID,
  'CUST_PASSWORD': instance.CUST_PASSWORD,
  'BIRTHDAY': instance.BIRTHDAY,
  'INSERT_DATE': instance.INSERT_DATE,
  'DEL_DATE': instance.DEL_DATE,
  'OLD_ADDR': instance.OLD_ADDR,
  'NEW_ADDR': instance.NEW_ADDR,
  'CUST_ID_GBN': instance.CUST_ID_GBN,
  'MEMO': instance.MEMO,
  'RETIRE_DATE': instance.RETIRE_DATE,
};
