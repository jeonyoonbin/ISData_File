import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopReserveImageModel {
  ShopReserveImageModel();

  bool selected = false;
  int seq;
  String noticeName;
  String fileName;
  String fileUrl;

  factory ShopReserveImageModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopReserveImageModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopReserveImageModel()
    ..selected = json['selected'] as bool
    ..seq = json['seq'] as int
    ..noticeName = json['noticeName'] as String
    ..fileName = json['fileName'] as String
    ..fileUrl = json['fileUrl'] as String;
}

Map<String, dynamic> _$ModelToJson(ShopReserveImageModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'seq': instance.seq,
  'noticeName': instance.noticeName,
  'fileName': instance.fileName,
  'fileUrl': instance.fileUrl
};
