import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class BuinessTypeStatisticsModel {
  BuinessTypeStatisticsModel();

  bool selected;
  String GUNGU_NAME;
  String DONG_NAME;
  String ITEM_CD;
  int COUNT = 0;


  factory BuinessTypeStatisticsModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

BuinessTypeStatisticsModel _$ModelFromJson(Map<String, dynamic> json) {
  return BuinessTypeStatisticsModel()
    ..selected = json['selected'] as bool
    ..GUNGU_NAME = json['GUNGU_NAME'] as String
    ..DONG_NAME = json['DONG_NAME'] as String
    ..ITEM_CD = json['ITEM_CD'] as String
    ..COUNT = json['COUNT'] as int;
}

Map<String, dynamic> _$ModelToJson(BuinessTypeStatisticsModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'GUNGU_NAME': instance.GUNGU_NAME,
  'DONG_NAME': instance.DONG_NAME,
  'ITEM_CD': instance.ITEM_CD,
  'COUNT': instance.COUNT
};
