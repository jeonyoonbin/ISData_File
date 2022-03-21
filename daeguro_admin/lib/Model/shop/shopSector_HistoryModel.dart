import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
// ignore: camel_case_types
class ShopSectorHistoryModel {
  ShopSectorHistoryModel();

  int NO;
  String HIST_DATE;
  String MEMO;

  factory ShopSectorHistoryModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopSectorHistoryModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopSectorHistoryModel()
    ..NO = json['NO'] as int
    ..HIST_DATE = json['HIST_DATE'] as String
    ..MEMO = json['MEMO'] as String;
}

Map<String, dynamic> _$ModelToJson(ShopSectorHistoryModel instance) => <String, dynamic>{
  'NO': instance.NO,
  'HIST_DATE': instance.HIST_DATE,
  'MEMO': instance.MEMO
};
