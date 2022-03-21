import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class DrgCouponStaticModel {
  DrgCouponStaticModel();

  bool selected;
  String MON;
  int COUPON_AMT = 0;
  int INS_CNT = 0;
  int USE_CNT = 0;
  int DIS_USE_CNT = 0;
  int EXP_CNT = 0;
  int INS_AMT = 0;
  int USE_AMT = 0;
  int DIS_USE_AMT = 0;
  int EXP_AMT = 0;



  factory DrgCouponStaticModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

DrgCouponStaticModel _$ModelFromJson(Map<String, dynamic> json) {
  return DrgCouponStaticModel()
    ..selected = json['selected'] as bool
    ..MON = json['MON'] as String
    ..COUPON_AMT = json['COUPON_AMT'] as int
    ..INS_CNT = json['INS_CNT'] as int
    ..USE_CNT = json['USE_CNT'] as int
    ..DIS_USE_CNT = json['DIS_USE_CNT'] as int
    ..EXP_CNT = json['EXP_CNT'] as int
    ..INS_AMT = json['INS_AMT'] as int
    ..USE_AMT = json['USE_AMT'] as int
    ..DIS_USE_AMT = json['DIS_USE_AMT'] as int
    ..EXP_AMT = json['EXP_AMT'] as int;
}

Map<String, dynamic> _$ModelToJson(DrgCouponStaticModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'MON': instance.MON,
  'COUPON_AMT': instance.COUPON_AMT,
  'INS_CNT': instance.INS_CNT,
  'USE_CNT': instance.USE_CNT,
  'DIS_USE_CNT': instance.DIS_USE_CNT,
  'EXP_CNT': instance.EXP_CNT,
  'INS_AMT': instance.INS_AMT,
  'USE_AMT': instance.USE_AMT,
  'DIS_USE_AMT': instance.DIS_USE_AMT,
  'EXP_AMT': instance.EXP_AMT,
};
