import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopMenuGroupEditModel {
  ShopMenuGroupEditModel();

  bool selected = false;
  String shopCd;
  String menuGroupCd;
  String menuGroupName;
  String menuGroupMemo;
  String useYn;
  String optionYn;
  String mainImageYn;
  String sortSeq;
  String groupFileName;
  String insertName;

  factory ShopMenuGroupEditModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopMenuGroupEditModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopMenuGroupEditModel()
    ..selected = json['selected'] as bool
    ..shopCd = json['shopCd'] as String
    ..menuGroupCd = json['menuGroupCd'] as String
    ..menuGroupName = json['menuGroupName'] as String
    ..menuGroupMemo = json['menuGroupMemo'] as String
    ..useYn = json['useYn'] as String
    ..optionYn = json['optionYn'] as String
    ..mainImageYn = json['mainImageYn'] as String
    ..sortSeq = json['sortSeq'] as String
    ..groupFileName = json['groupFileName'] as String
    ..insertName = json['insertName'] as String;

}

Map<String, dynamic> _$ModelToJson(ShopMenuGroupEditModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'shopCd': instance.shopCd,
  'menuGroupCd': instance.menuGroupCd,
  'menuGroupName': instance.menuGroupName,
  'menuGroupMemo': instance.menuGroupMemo,
  'useYn': instance.useYn,
  'optionYn': instance.optionYn,
  'mainImageYn': instance.mainImageYn,
  'sortSeq': instance.sortSeq,
  'groupFileName': instance.groupFileName,
  'insertName': instance.insertName
};