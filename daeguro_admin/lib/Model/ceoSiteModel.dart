import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class CeoSiteModel {
  CeoSiteModel();

  bool selected = false;
  String uCode;
  String uName;
  String jobName;
  String shopCd;

  factory CeoSiteModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

CeoSiteModel _$ModelFromJson(Map<String, dynamic> json) {
  return CeoSiteModel()
    ..selected = json['selected'] as bool
    ..uCode = json['uCode'] as String
    ..uName = json['uName'] as String
    ..jobName = json['jobName'] as String
    ..shopCd = json['shopCd'] as String;

}

Map<String, dynamic> _$ModelToJson(CeoSiteModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'uCode': instance.uCode,
  'uName': instance.uName,
  'jobName': instance.jobName,
  'shopCd': instance.shopCd,
};