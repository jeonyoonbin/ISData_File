import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopMemoHistoryModel {
  ShopMemoHistoryModel();

  bool selected = false;
  int NO;
  String HIST_DATE;
  String MEMO;

  factory ShopMemoHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopMemoHistoryModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopMemoHistoryModel()
    ..selected = json['selected'] as bool
    ..NO = json['NO'] as int
    ..HIST_DATE = json['HIST_DATE'] as String
    ..MEMO = json['MEMO'] as String;

}

Map<String, dynamic> _$ModelToJson(ShopMemoHistoryModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'NO': instance.NO,
  'HIST_DATE': instance.HIST_DATE,
  'MEMO': instance.MEMO
};