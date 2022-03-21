import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopEventHistoryModel {
  ShopEventHistoryModel();

  bool selected = false;
  int NO;
  int HIST_SEQ;
  String HIST_DATE;
  String MEMO;

  factory ShopEventHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopEventHistoryModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopEventHistoryModel()
    ..selected = json['selected'] as bool
    ..NO = json['NO'] as int
    ..HIST_SEQ = json['HIST_SEQ'] as int
    ..HIST_DATE = json['HIST_DATE'] as String
    ..MEMO = json['MEMO'] as String;
}

Map<String, dynamic> _$ModelToJson(ShopEventHistoryModel instance) => <String, dynamic> {
  'selected': instance.selected,
  'NO': instance.NO,
  'HIST_SEQ': instance.HIST_SEQ,
  'HIST_DATE': instance.HIST_DATE,
  'MEMO': instance.MEMO,
};