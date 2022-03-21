import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopReivewHistoryModel {
  ShopReivewHistoryModel();

  bool selected = false;
  String NO;
  String HIST_DATE;
  String MEMO;
  String MOD_UCODE;
  String USER_NAME;

  factory ShopReivewHistoryModel.fromJson(Map<String, dynamic> json) => _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopReivewHistoryModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopReivewHistoryModel()
    ..selected = json['selected'] as bool
    ..NO = json['NO'] as String
    ..HIST_DATE = json['HIST_DATE'] as String
    ..MEMO = json['MEMO'] as String
    ..MOD_UCODE = json['MOD_UCODE'] as String
    ..USER_NAME = json['USER_NAME'] as String;
}

Map<String, dynamic> _$ModelToJson(ShopReivewHistoryModel instance) => <String, dynamic>{
      'selected': instance.selected,
      'NO': instance.NO,
      'HIST_DATE': instance.HIST_DATE,
      'MEMO': instance.MEMO,
      'MOD_UCODE': instance.MOD_UCODE,
      'USER_NAME': instance.USER_NAME
    };
