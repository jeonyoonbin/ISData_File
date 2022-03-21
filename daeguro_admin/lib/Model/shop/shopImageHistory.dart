import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopImageHistoryModel {
  ShopImageHistoryModel();

  bool selected = false;
  int no;
  String histDate;
  String memo;

  factory ShopImageHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopImageHistoryModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopImageHistoryModel()
      ..selected = json['selected'] as bool
      ..no = json['NO'] as int
      ..histDate = json['HIST_DATE'] as String
      ..memo = json['MEMO'] as String;
}

Map<String, dynamic> _$ModelToJson(ShopImageHistoryModel instance) => <String, dynamic> {
  'selected': instance.selected,
  'no': instance.no,
  'histDate': instance.histDate,
  'memo': instance.memo
};