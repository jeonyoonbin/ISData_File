import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopModificationRegNoModel {
  ShopModificationRegNoModel();

  bool selected;
  String shop_cd;
  int seqno;
  String shop_name;
  String owner;
  String telno;
  String hist_date;
  String regno_hist;

  factory ShopModificationRegNoModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopModificationRegNoModel _$ModelFromJson(Map<String,dynamic> json) {
  return ShopModificationRegNoModel()
      ..selected = json ['selected'] as bool
      ..shop_cd = json ['SHOP_CD'] as String
      ..seqno = json ['SEQNO'] as int
      ..shop_name = json ['SHOP_NAME'] as String
      ..owner = json ['OWNER'] as String
      ..telno = json ['TELNO'] as String
      ..hist_date = json ['HIST_DATE'] as String
      ..regno_hist = json ['REGNO_HIST'] as String;
}

Map<String, dynamic> _$ModelToJson(ShopModificationRegNoModel instance) => <String, dynamic> {
  'selected': instance.selected,
  'SHOP_CD': instance.shop_cd,
  'SEQNO': instance.seqno,
  'SHOP_NAME': instance.shop_name,
  'OWNER': instance.owner,
  'TELNO': instance.telno,
  'HIST_DATE': instance.hist_date,
  'REGNO_HIST': instance.regno_hist,
};