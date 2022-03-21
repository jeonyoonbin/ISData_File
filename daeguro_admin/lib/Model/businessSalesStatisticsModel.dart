import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class BuinessSalesStatisticsModel {
  BuinessSalesStatisticsModel();

  bool selected;
  String p_gungu;
  String GUNGU_NAME;
  String DONG_NAME;
  String SALESMAN_NAME;
  int COUNT;

  factory BuinessSalesStatisticsModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

BuinessSalesStatisticsModel _$ModelFromJson(Map<String, dynamic> json) {
  return BuinessSalesStatisticsModel()
    ..selected = json['selected'] as bool
    ..GUNGU_NAME = json['GUNGU_NAME'] as String
    ..DONG_NAME = json['DONG_NAME'] as String
    ..SALESMAN_NAME = json['SALESMAN_NAME'] as String
    ..COUNT = json['COUNT'] as int;
}

Map<String, dynamic> _$ModelToJson(BuinessSalesStatisticsModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'GUNGU_NAME': instance.GUNGU_NAME,
  'DONG_NAME': instance.DONG_NAME,
  'SALESMAN_NAME': instance.SALESMAN_NAME,
  'COUNT': instance.COUNT
};
