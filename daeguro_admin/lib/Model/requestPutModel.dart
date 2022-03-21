import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
// ignore: camel_case_types
class RequestPutModel {
  RequestPutModel();

  String seq;
  String status;
  String alloc_ucode;
  String alloc_uname;
  String answer;
  String mod_ucode;
  String mod_name;

  factory RequestPutModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

RequestPutModel _$ModelFromJson(Map<String, dynamic> json) {
  return RequestPutModel()
    ..seq = json['seq'] as String
    ..status = json['status'] as String
    ..alloc_ucode = json['alloc_ucode'] as String
    ..alloc_uname = json['alloc_uname'] as String
    ..answer = json['answer'] as String
    ..mod_ucode = json['mod_ucode'] as String
    ..mod_name = json['mod_name'] as String;
}

Map<String, dynamic> _$ModelToJson(RequestPutModel instance) => <String, dynamic>{
  'seq': instance.seq,
  'status': instance.status,
  'alloc_ucode': instance.alloc_ucode,
  'alloc_uname': instance.alloc_uname,
  'answer': instance.answer,
  'mod_ucode': instance.mod_ucode,
  'mod_name': instance.mod_name,
};
