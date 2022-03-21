import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class calculateShopMileageModel {
  calculateShopMileageModel();

  bool selected = false;




  // 신규 UI
  int RNUM;
  int MCODE;
  String CCCODE;
  String SHOP_CD;
  String SHOP_NAME;
  int REMAIN_AMT;
  int ALL_AMT;
  int IN_AMT;
  int P_AMT;
  int K_AMT;
  int TAKE_COUNT;
  int TAKE_AMT;

  factory calculateShopMileageModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

calculateShopMileageModel _$ModelFromJson(Map<String, dynamic> json) {
  return calculateShopMileageModel()
    ..selected = json['selected'] as bool
    ..MCODE = json['MCODE'] as int
    ..CCCODE = json['CCCODE'] as String
    ..SHOP_CD = json['SHOP_CD'] as String
    ..SHOP_NAME = json['SHOP_NAME'] as String
    ..RNUM = json['RNUM'] as int
    ..REMAIN_AMT = json['REMAIN_AMT'] as int
    ..ALL_AMT = json['ALL_AMT'] as int
    ..IN_AMT = json['IN_AMT'] as int
    ..P_AMT = json['P_AMT'] as int
    ..K_AMT = json['K_AMT'] as int
    ..TAKE_COUNT = json['TAKE_COUNT'] as int
    ..TAKE_AMT = json['TAKE_AMT'] as int;
}

Map<String, dynamic> _$ModelToJson(calculateShopMileageModel instance) =>
    <String, dynamic>{
      'selected': instance.selected,
      'MCODE': instance.MCODE,
      'CCCODE': instance.CCCODE,
      'SHOP_CD': instance.SHOP_CD,
      'SHOP_NAME': instance.SHOP_NAME,
      'RNUM': instance.RNUM,
      'REMAIN_AMT': instance.REMAIN_AMT,
      'ALL_AMT': instance.ALL_AMT,
      'IN_AMT': instance.IN_AMT,
      'P_AMT': instance.P_AMT,
      'K_AMT': instance.K_AMT,
      'TAKE_COUNT': instance.TAKE_COUNT,
      'TAKE_AMT': instance.TAKE_AMT,
    };