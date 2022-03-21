import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class StatOrderDailyCompletedCanceledModel {
  StatOrderDailyCompletedCanceledModel();

  String ORDER_DATE;
  String ORDER_STATE;
  int CNT = 0;
  int TOT_AMT = 0;
  int TOT_DELITIP = 0;
  int FIRST_COUPON = 0;
  int RE_COUPON = 0;
  int MILEAGE = 0;
  int HAPPYPAY_DISC = 0;

  // 취소 오더 정보 저장
  int C_CNT = 0;
  int C_TOT_AMT = 0;
  int C_TOT_DELITIP = 0;
  int C_FIRST_COUPON = 0;
  int C_RE_COUPON = 0;
  int C_MILEAGE = 0;
  int C_HAPPYPAY_DISC = 0;

  factory StatOrderDailyCompletedCanceledModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

StatOrderDailyCompletedCanceledModel _$ModelFromJson(Map<String, dynamic> json) {
  return StatOrderDailyCompletedCanceledModel()
    ..ORDER_DATE = json['주문일'] as String
    ..ORDER_STATE = json['상태'] as String
    ..CNT = json['수량'] as int
    ..TOT_AMT = json['총음식금액'] as int
    ..TOT_DELITIP = json['총배달팁'] as int
    ..FIRST_COUPON = json['첫주문쿠폰'] as int
    ..RE_COUPON = json['재구매쿠폰'] as int
    ..MILEAGE = json['마일리지'] as int
    ..HAPPYPAY_DISC = json['행복페이할인'] as int;
}

Map<String, dynamic> _$ModelToJson(StatOrderDailyCompletedCanceledModel instance) => <String, dynamic>{
  '주문일': instance.ORDER_DATE,
  '상태': instance.ORDER_STATE,
  '수량': instance.CNT,
  '총음식금액': instance.TOT_AMT,
  '총배달팁': instance.TOT_DELITIP,
  '첫주문쿠폰': instance.FIRST_COUPON,
  '재구매쿠폰': instance.RE_COUPON,
  '마일리지': instance.MILEAGE,
  '행복페이할인': instance.HAPPYPAY_DISC,
};
