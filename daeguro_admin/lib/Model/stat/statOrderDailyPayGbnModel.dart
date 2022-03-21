import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class StatOrderDailyPayGbnModel {
  StatOrderDailyPayGbnModel();

  String ORDER_DATE;
  String ORDER_STATE;
  int APP_CARD_CNT = 0;
  int APP_CARD_AMT = 0;
  int HAPPYPAY_CNT = 0;
  int HAPPYPAY_AMT = 0;
  int CARD_CNT = 0;
  int CARD_AMT = 0;
  int CASH_CNT = 0;
  int CASH_AMT = 0;

  int N_PAY_CNT = 0;
  int N_PAY_AMT = 0;

  factory StatOrderDailyPayGbnModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

StatOrderDailyPayGbnModel _$ModelFromJson(Map<String, dynamic> json) {
  return StatOrderDailyPayGbnModel()
    ..ORDER_DATE = json['주문일'] as String
    ..ORDER_STATE = json['결제구분'] as String
    ..APP_CARD_CNT = json['일반카드건수'] as int
    ..APP_CARD_AMT = json['일반카드금액'] as int
    ..HAPPYPAY_CNT = json['행복페이건수'] as int
    ..HAPPYPAY_AMT = json['행복페이금액'] as int
    ..CARD_CNT = json['만나서카드건수'] as int
    ..CARD_AMT = json['만나서카드금액'] as int
    ..CASH_CNT = json['만나서현금건수'] as int
    ..CASH_AMT = json['만나서현금금액'] as int
    ..N_PAY_CNT = json['네이버페이건수'] as int
    ..N_PAY_AMT = json['네이버페이금액'] as int;
}

Map<String, dynamic> _$ModelToJson(StatOrderDailyPayGbnModel instance) => <String, dynamic>{
  '주문일': instance.ORDER_DATE,
  '결제구분': instance.ORDER_STATE,
  '일반카드건수': instance.APP_CARD_CNT,
  '일반카드금액': instance.APP_CARD_AMT,
  '행복페이건수': instance.HAPPYPAY_CNT,
  '행복페이금액': instance.HAPPYPAY_AMT,
  '만나서카드건수': instance.CARD_CNT,
  '만나서카드금액': instance.CARD_AMT,
  '만나서현금건수': instance.CASH_CNT,
  '만나서현금금액': instance.CASH_AMT,
  '네이버페이건수': instance.N_PAY_CNT,
  '네이버페이금액': instance.N_PAY_AMT,
};
