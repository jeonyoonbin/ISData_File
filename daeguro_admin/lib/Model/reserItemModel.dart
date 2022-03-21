import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ReserItemModel {
  ReserItemModel();

  bool selected = false;
  String code;
  String nameMain;
  String name;
  String url;

  factory ReserItemModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ReserItemModel _$ModelFromJson(Map<String, dynamic> json) {
  return ReserItemModel()
    ..selected = json['selected'] as bool
    ..code = json['code'] as String
    ..nameMain = json['nameMain'] as String
    ..name = json['name'] as String
    ..url = json['url'] as String;

}

Map<String, dynamic> _$ModelToJson(ReserItemModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'code': instance.code,
  'nameMain': instance.nameMain,
  'name': instance.name,
  'url': instance.url
};