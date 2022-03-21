import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class StatOrderTimeModel {
  StatOrderTimeModel();

  String ITEM_CD;
  String HH;
  int COUNT = 0;

  factory StatOrderTimeModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

StatOrderTimeModel _$ModelFromJson(Map<String, dynamic> json) {
  return StatOrderTimeModel()
    ..ITEM_CD = json['ITEM_CD'] as String
    ..HH = json['HH'] as String
    ..COUNT = json['COUNT'] as int;
}

Map<String, dynamic> _$ModelToJson(StatOrderTimeModel instance) => <String, dynamic>{
  'ITEM_CD': instance.ITEM_CD,
  'HH': instance.HH,
  'COUNT': instance.COUNT
};
