import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ImageList {
  ImageList();

  String menuImageCd;
  String menuName;
  String fileName;
  String insertDate;

  factory ImageList.fromJson(Map<String,dynamic> json) => _$ImageFromJson(json);
  Map<String, dynamic> toJson() => _$ImageToJson(this);
}

ImageList _$ImageFromJson(Map<String, dynamic> json) {
  return ImageList()
    ..menuImageCd = json['menuImageCd'] as String
    ..menuName = json['menuName'] as String
    ..fileName = json['fileName'] as String
    ..insertDate = json['insertDate'] as String;
}

Map<String, dynamic> _$ImageToJson(ImageList instance) => <String, dynamic>{
  'menuImageCd': instance.menuImageCd,
  'menuName': instance.menuName,
  'fileName': instance.fileName,
  'insertDate': instance.insertDate
};
