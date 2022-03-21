import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopMenuOptionModel {
  ShopMenuOptionModel();

  bool selected = false;
  String optionCd;
  String name;
  String memo;
  String cost;
  String useYn;
  String sortSeq;
  String noFlag;
  String adultOnly;
  //String fileName;


  factory ShopMenuOptionModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopMenuOptionModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopMenuOptionModel()
    ..selected = json['selected'] as bool
    ..optionCd = json['optionCd'] as String
    ..name = json['name'] as String
    ..memo = json['memo'] as String
    ..cost = json['cost'] as String
    ..useYn = json['useYn'] as String
    ..sortSeq = json['sortSeq'] as String
    ..noFlag = json['noFlag'] as String
    ..adultOnly = json['adultOnly'] as String;
    //..fileName = json['fileName'] as String;
}

Map<String, dynamic> _$ModelToJson(ShopMenuOptionModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'optionCd': instance.optionCd,
  'name': instance.name,
  'memo': instance.memo,
  'cost': instance.cost,
  'useYn': instance.useYn,
  'sortSeq': instance.sortSeq,
  'noFlag': instance.noFlag,
  'adultOnly': instance.adultOnly,
  //'fileName': instance.fileName
};