import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopMenuGroupInfoModel {
  ShopMenuGroupInfoModel();

  bool selected = false;
  String menuGroupCd;
  String menuGroupName;
  String menuNames;
  String useYn;
  String mainCount;

  factory ShopMenuGroupInfoModel.fromJson(Map<String, dynamic> json) => _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopMenuGroupInfoModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopMenuGroupInfoModel()
    ..selected = json['selected'] as bool
    ..menuGroupCd = json['menuGroupCd'] as String
    ..menuGroupName = json['menuGroupName'] as String
    ..menuNames = json['menuNames'] as String
    ..useYn = json['useYn'] as String
    ..mainCount = json['mainCount'] as String;
}

Map<String, dynamic> _$ModelToJson(ShopMenuGroupInfoModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'menuGroupCd': instance.menuGroupCd,
  'menuGroupName': instance.menuGroupName,
  'menuNames': instance.menuNames,
      'useYn': instance.useYn,
      'mainCount': instance.mainCount,
    };
