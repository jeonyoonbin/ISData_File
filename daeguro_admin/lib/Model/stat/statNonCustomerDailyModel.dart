import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class StatNonCustomerDailyModel {
  StatNonCustomerDailyModel();

  String INSERT_DATE;
  int COUNT = 0;

  factory StatNonCustomerDailyModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

StatNonCustomerDailyModel _$ModelFromJson(Map<String, dynamic> json) {
  return StatNonCustomerDailyModel()
    ..INSERT_DATE = json['INSERT_DATE'] as String
    ..COUNT = json['COUNT'] as int;
}

Map<String, dynamic> _$ModelToJson(StatNonCustomerDailyModel instance) => <String, dynamic>{
  'INSERT_DATE': instance.INSERT_DATE,
  'COUNT': instance.COUNT
};
