import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class CustomerListModel {
  CustomerListModel();

  bool selected = false;
  int CUST_CODE;
  String CUST_NAME;
  String TELNO;
  String CUST_ID;
  String CUST_PASSWORD;
  String INSERT_DATE;
  String DEL_DATE;
  int ORDER_COUNT;
  int ORDER_AMT;
  int MILEAGE_AMT;
  String CUST_ID_GBN;
  String MEMO;

  factory CustomerListModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

CustomerListModel _$ModelFromJson(Map<String, dynamic> json) {
  return CustomerListModel()
    ..selected = json['selected'] as bool
    ..CUST_CODE = json['CUST_CODE'] as int
    ..CUST_NAME = json['CUST_NAME'] as String
    ..TELNO = json['TELNO'] as String
    ..CUST_ID = json['CUST_ID'] as String
    ..CUST_PASSWORD = json['CUST_PASSWORD'] as String
    ..INSERT_DATE = json['INSERT_DATE'] as String
    ..DEL_DATE = json['DEL_DATE'] as String
    ..ORDER_COUNT = json['ORDER_COUNT'] as int
    ..ORDER_AMT = json['ORDER_AMT'] as int
    ..MILEAGE_AMT = json['MILEAGE_AMT'] as int
    ..CUST_ID_GBN = json['CUST_ID_GBN'] as String
    ..MEMO = json['MEMO'] as String;
}

Map<String, dynamic> _$ModelToJson(CustomerListModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'CUST_CODE': instance.CUST_CODE,
  'CUST_NAME': instance.CUST_NAME,
  'TELNO': instance.TELNO,
  'CUST_ID': instance.CUST_ID,
  'CUST_PASSWORD': instance.CUST_PASSWORD,
  'INSERT_DATE': instance.INSERT_DATE,
  'DEL_DATE': instance.DEL_DATE,
  'ORDER_COUNT': instance.ORDER_COUNT,
  'ORDER_AMT': instance.ORDER_AMT,
  'MILEAGE_AMT': instance.MILEAGE_AMT,
  'CUST_ID_GBN': instance.CUST_ID_GBN,
  'MEMO': instance.MEMO
};
