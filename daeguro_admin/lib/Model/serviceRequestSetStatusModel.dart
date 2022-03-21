import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ServiceRequestSetStatusModel {
  ServiceRequestSetStatusModel();

  bool selected = false;
  String seq;
  String status;
  String mod_ucode;
  String mod_name;

  factory ServiceRequestSetStatusModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ServiceRequestSetStatusModel _$ModelFromJson(Map<String, dynamic> json) {
  return ServiceRequestSetStatusModel()
    ..selected = json['selected'] as bool
    ..seq = json['seq'] as String
    ..status = json['status'] as String
    ..mod_ucode = json['mod_ucode'] as String
    ..mod_name = json['mod_name'] as String;
}

Map<String, dynamic> _$ModelToJson(ServiceRequestSetStatusModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'seq': instance.seq,
  'status': instance.status,
  'mod_ucode': instance.mod_ucode,
  'mod_name': instance.mod_name,
};
