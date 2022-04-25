import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopReviewImageModel {
  ShopReviewImageModel();

  bool selected = false;
  int seq;
  String noticeName;
  String fileName;
  String fileUrl;
  int sortSeq;

  factory ShopReviewImageModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopReviewImageModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopReviewImageModel()
    ..selected = json['selected'] as bool
    ..seq = json['seq'] as int
    ..noticeName = json['noticeName'] as String
    ..fileName = json['fileName'] as String
    ..fileUrl = json['fileUrl'] as String
    ..sortSeq = json['sortSeq'] as int;
}

Map<String, dynamic> _$ModelToJson(ShopReviewImageModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'seq': instance.seq,
  'noticeName': instance.noticeName,
  'fileName': instance.fileName,
  'fileUrl': instance.fileUrl,
  'sortSeq': instance.sortSeq
};
