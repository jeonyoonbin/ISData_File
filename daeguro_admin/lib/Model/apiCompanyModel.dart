import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ApiCompanyModel {
  ApiCompanyModel();

  bool selected;
  String seq;
  String companyType;
  String companyGbn;
  String companyName;
  
  factory ApiCompanyModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ApiCompanyModel _$ModelFromJson(Map<String, dynamic> json) {
  return ApiCompanyModel()
    ..selected = json['selected'] as bool
    ..seq = json['seq'] as String
    ..companyType = json['companyType'] as String
    ..companyGbn = json['companyGbn'] as String
    ..companyName = json['companyName'] as String;
}

Map<String, dynamic> _$ModelToJson(ApiCompanyModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'seq': instance.seq,
  'companyType': instance.companyType,
  'companyGbn': instance.companyGbn,
  'companyName': instance.companyName
};
