import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class TaxiRegiHistModel {
  TaxiRegiHistModel();

  bool selected = false;
  String no;
  String HIST_DATE;
  String MEMO;

  factory TaxiRegiHistModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

TaxiRegiHistModel _$ModelFromJson(Map<String, dynamic> json) {
  return TaxiRegiHistModel()
    ..selected = json['selected'] as bool
    ..no = json['no'] as String
    ..HIST_DATE = json['HIST_DATE'] as String
    ..MEMO = json['MEMO'] as String;

}

Map<String, dynamic> _$ModelToJson(TaxiRegiHistModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'no': instance.no,
  'HIST_DATE': instance.HIST_DATE,
  'MEMO': instance.MEMO
};