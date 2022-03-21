import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ServiceRequestGbn {
  ServiceRequestGbn();

  bool selected = false;
  String CODE;
  String CODE_NM;

  factory ServiceRequestGbn.fromJson(Map<String,dynamic> json) =>
      _$ModelFromJson(json);

  Map<String,dynamic> toJson() => _$ModelToJson(this);
}

ServiceRequestGbn _$ModelFromJson(Map<String, dynamic> json) {
  return ServiceRequestGbn()
    ..selected = json['selected'] as bool
    ..CODE = json['CODE'] as String
    ..CODE_NM = json['CODE_NM'] as String;
}

Map<String,dynamic> _$ModelToJson(ServiceRequestGbn instance) => <String, dynamic>{
  'selected': instance.selected,
  'CODE': instance.CODE,
  'CODE_NM': instance.CODE_NM
};