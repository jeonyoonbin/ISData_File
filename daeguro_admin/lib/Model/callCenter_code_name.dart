import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class CallCenterCodeName {
  CallCenterCodeName();

  bool selected = false;
  String ccCode;
  String ccName;

  factory CallCenterCodeName.fromJson(Map<String,dynamic> json) =>
      _$ModelFromJson(json);

  Map<String,dynamic> toJson() => _$ModelToJson(this);
}

CallCenterCodeName _$ModelFromJson(Map<String, dynamic> json) {
  return CallCenterCodeName()
      ..selected = json['selected'] as bool
      ..ccCode = json['ccCode'] as String
      ..ccName = json['ccName'] as String;
}

Map<String,dynamic> _$ModelToJson(CallCenterCodeName instance) => <String, dynamic>{
  'selected': instance.selected,
  'ccCode': instance.ccCode,
  'ccName': instance.ccName
};