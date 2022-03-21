import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class MappingListModel {
  MappingListModel();

  bool selected;
  String shopMapSeq;
  String shopName;
  String companyName;

  factory MappingListModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

MappingListModel _$ModelFromJson(Map<String, dynamic> json) {
  return MappingListModel()
    ..selected = json['selected'] as bool
    ..shopMapSeq = json['shopMapSeq'] as String
    ..shopName = json['shopName'] as String
    ..companyName = json['companyName'] as String;
}

Map<String, dynamic> _$ModelToJson(MappingListModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'shopMapSeq': instance.shopMapSeq,
  'shopName': instance.shopName,
  'companyName': instance.companyName
};
