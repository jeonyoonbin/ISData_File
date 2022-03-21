import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopReviewStoreConfirmModel {
  ShopReviewStoreConfirmModel();

  String store_code;
  String store_sub_idx = "00";
  String member_company_code = "daegu";
  String store_name;
  String owner = "";
  String addr1 = "";
  String addr2 = "";
  String tel_num = "";
  String email = "";
  String memo = "";
  String user_id;

  factory ShopReviewStoreConfirmModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopReviewStoreConfirmModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopReviewStoreConfirmModel()
    ..store_code = json['store_code'] as String
    ..store_sub_idx = json['store_sub_idx'] as String
    ..member_company_code = json['member_company_code'] as String
    ..store_name = json['store_name'] as String
    ..owner = json['owner'] as String
    ..addr1 = json['addr1'] as String
    ..addr2 = json['addr2'] as String
    ..tel_num = json['tel_num'] as String
    ..email = json['email'] as String
    ..memo = json['memo'] as String
    ..user_id = json['user_id'] as String;

}

Map<String, dynamic> _$ModelToJson(ShopReviewStoreConfirmModel instance) => <String, dynamic>{
  'store_code': instance.store_code,
  'store_sub_idx': instance.store_sub_idx,
  'member_company_code': instance.member_company_code,
  'store_name': instance.store_name,
  'owner': instance.owner,
  'addr1': instance.addr1,
  'addr2': instance.addr2,
  'tel_num': instance.tel_num,
  'email': instance.email,
  'memo': instance.memo,
  'user_id': instance.user_id
};