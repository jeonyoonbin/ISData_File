import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class CalculateOrderPayMentCountModel {
  CalculateOrderPayMentCountModel();

  int COUNT = 0;
  int COMP = 0 ;
  int CANC = 0;
  int SUM_MENU_AMT = 0;
  int SUM_DELI_TIP_AMT = 0;
  int SUM_TOT_AMT = 0;
  int SUM_COUPON_AMT = 0;
  int SUM_MILEAGE_USE_AMT = 0;
  int SUM_ETC_DISC_AMT = 0;
  int SUM_DISC_AMT = 0;
  int SUM_AMOUNT = 0;
  int SUM_PGM_AMT = 0;
  int SUM_PG_PGM_AMT = 0;
  int SUM_PGM_SUM_AMT = 0;

  factory CalculateOrderPayMentCountModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

CalculateOrderPayMentCountModel _$ModelFromJson(Map<String, dynamic> json) {
  return CalculateOrderPayMentCountModel()
    ..COUNT = json['COUNT'] as int
    ..COMP = json['COMP'] as int
    ..CANC = json['CANC'] as int
    ..SUM_MENU_AMT = json['SUM_MENU_AMT'] as int
    ..SUM_DELI_TIP_AMT = json['SUM_DELI_TIP_AMT'] as int
    ..SUM_TOT_AMT = json['SUM_TOT_AMT'] as int
    ..SUM_COUPON_AMT = json['SUM_COUPON_AMT'] as int
    ..SUM_MILEAGE_USE_AMT = json['SUM_MILEAGE_USE_AMT'] as int
    ..SUM_ETC_DISC_AMT = json['SUM_ETC_DISC_AMT'] as int
    ..SUM_DISC_AMT = json['SUM_DISC_AMT'] as int
    ..SUM_AMOUNT = json['SUM_AMOUNT'] as int
    ..SUM_PGM_AMT = json['SUM_PGM_AMT'] as int
    ..SUM_PG_PGM_AMT = json['SUM_PG_PGM_AMT'] as int
    ..SUM_PGM_SUM_AMT = json['SUM_PGM_SUM_AMT'] as int;
}

Map<String, dynamic> _$ModelToJson(CalculateOrderPayMentCountModel instance) => <String, dynamic>{
  'COUNT': instance.COUNT,
  'COMP': instance.COMP,
  'CANC': instance.CANC,
  'SUM_MENU_AMT': instance.SUM_MENU_AMT,
  'SUM_DELI_TIP_AMT': instance.SUM_DELI_TIP_AMT,
  'SUM_TOT_AMT': instance.SUM_TOT_AMT,
  'SUM_COUPON_AMT': instance.SUM_COUPON_AMT,
  'SUM_MILEAGE_USE_AMT': instance.SUM_MILEAGE_USE_AMT,
  'SUM_ETC_DISC_AMT': instance.SUM_ETC_DISC_AMT,
  'SUM_DISC_AMT': instance.SUM_DISC_AMT,
  'SUM_AMOUNT': instance.SUM_AMOUNT,
  'SUM_PGM_AMT': instance.SUM_PGM_AMT,
  'SUM_PG_PGM_AMT': instance.SUM_PG_PGM_AMT,
  'SUM_PGM_SUM_AMT': instance.SUM_PGM_SUM_AMT,
};
