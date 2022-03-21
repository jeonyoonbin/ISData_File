import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class VoucherTypeListModel {
  VoucherTypeListModel();

  bool selected = false;
  String CODE;
  String CODE_NM;
  int ETC_AMT1;

  factory VoucherTypeListModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

VoucherTypeListModel _$ModelFromJson(Map<String, dynamic> json) {
  return VoucherTypeListModel()
    ..selected = json['selected'] as bool
    ..CODE = json['CODE'] as String
    ..CODE_NM = json['CODE_NM'] as String
    ..ETC_AMT1 = json['ETC_AMT1'] as int;

}

Map<String, dynamic> _$ModelToJson(VoucherTypeListModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'CODE': instance.CODE,
  'CODE_NM': instance.CODE_NM,
  'ETC_AMT1': instance.ETC_AMT1,
};