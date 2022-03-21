import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopPosUpdateModel {
  ShopPosUpdateModel();

  String job_gbn;
  String mcode;
  String cccode;
  String shop_cd;
  String use_gbn;
  String login_id;
  String login_pw;
  String shop_name;
  String address;
  String address_detail;
  String sido;
  String sigungu;
  String bdong;
  String hdong;  // 현재 비밀번호
  String ri;
  String road;
  double lon;
  double lat;
  String telno;
  String mobile;
  String reg_no;
  String owner;
  String zone_code;
  String shop_token;
  String mod_ucode;

  factory ShopPosUpdateModel.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopPosUpdateModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopPosUpdateModel()
    ..job_gbn = json['job_gbn'] as String
    ..mcode = json['mcode'] as String
    ..cccode = json['cccode'] as String
    ..shop_cd = json['shop_cd'] as String
    ..use_gbn = json['use_gbn'] as String
    ..login_id = json['login_id'] as String
    ..login_pw = json['login_pw'] as String
    ..shop_name = json['shop_name'] as String
    ..address = json['address'] as String
    ..address_detail = json['address_detail'] as String
    ..sido = json['sido'] as String
    ..sigungu = json['sigungu'] as String
    ..bdong = json['bdong'] as String
    ..hdong = json['hdong'] as String
    ..ri = json['ri'] as String
    ..road = json['road'] as String
    ..lon = json['lon'] as double
    ..lat = json['lat'] as double
    ..telno = json['telno'] as String
    ..mobile = json['mobile'] as String
    ..reg_no = json['reg_no'] as String
    ..owner = json['owner'] as String
    ..zone_code = json['zone_code'] as String
    ..shop_token = json['shop_token'] as String
    ..mod_ucode = json['mod_ucode'] as String;

}

Map<String, dynamic> _$ModelToJson(ShopPosUpdateModel instance) => <String, dynamic>{
  '"job_gbn"': '"' + instance.job_gbn + '"',
  '"mcode"': '"' + instance.mcode + '"',
  '"cccode"': '"' + instance.cccode + '"',
  '"shop_cd"': '"' + instance.shop_cd + '"',
  '"use_gbn"': '"' + instance.use_gbn + '"',
  '"login_id"': '"' + instance.login_id + '"',
  '"login_pw"': '"' + instance.login_pw + '"',
  '"shop_name"': '"' + instance.shop_name + '"',
  '"address"': '"' + instance.address + '"',
  '"address_detail"': '"' + instance.address_detail + '"',
  '"sido"': '"' + instance.sido + '"',
  '"sigungu"': '"' + instance.sigungu + '"',
  '"bdong"': '"' + instance.bdong + '"',
  '"hdong"': '"' + instance.hdong + '"',
  '"ri"': '"' + instance.ri + '"',
  '"road"': '"' + instance.road + '"',
  '"lon"': instance.lon,
  '"lat"': instance.lat,
  '"telno"': '"' + instance.telno + '"',
  '"mobile"': '"' + instance.mobile + '"',
  '"reg_no"': '"' + instance.reg_no + '"',
  '"owner"': '"' + instance.owner + '"',
  '"zone_code"': '"' + instance.zone_code + '"',
  '"shop_token"': '"' + instance.shop_token + '"',
  '"mod_ucode"': '"' + instance.mod_ucode + '"'
};