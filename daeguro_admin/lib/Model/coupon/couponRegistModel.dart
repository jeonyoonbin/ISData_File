import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
// ignore: camel_case_types
class couponRegistModel {
  couponRegistModel();

  String couponType;
  String itemType;
  String title;
  String couponCount;
  String isdAmt;
  //String startDate;
  String insertUcode;
  String insertName;

  factory couponRegistModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

couponRegistModel _$ModelFromJson(Map<String, dynamic> json) {
  return couponRegistModel()
    ..couponType = json['couponType'] as String
    ..itemType = json['itemType'] as String
    ..title = json['title'] as String
    ..couponCount = json['couponCount'] as String
    ..isdAmt = json['isdAmt'] as String
    //..startDate = json['startDate'] as String
    ..insertUcode = json['insertUcode'] as String
    ..insertName = json['insertName'] as String;
}

Map<String, dynamic> _$ModelToJson(couponRegistModel instance) => <String, dynamic>{
  'couponType': instance.couponType,
  'itemType': instance.itemType,
  'title': instance.title,
  'couponCount': instance.couponCount,
  'isdAmt': instance.isdAmt,
  //'startDate': instance.startDate,
  'insertUcode': instance.insertUcode,
  'insertName': instance.insertName,
};
