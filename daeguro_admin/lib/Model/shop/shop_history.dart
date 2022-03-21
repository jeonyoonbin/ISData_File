import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopHistoryModel {
  ShopHistoryModel();

  bool selected = false;
  String no;
  String insertDate;
  String memo;

  factory ShopHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopHistoryModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopHistoryModel()
    ..selected = json['selected'] as bool
    ..no = json['no'] as String
    ..insertDate = json['insertDate'] as String
    ..memo = json['memo'] as String;

}

Map<String, dynamic> _$ModelToJson(ShopHistoryModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'no': instance.no,
  'insertDate': instance.insertDate,
  'memo': instance.memo
};