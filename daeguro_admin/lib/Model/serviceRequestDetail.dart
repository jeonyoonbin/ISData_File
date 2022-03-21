import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ServiceRequestDetail {
  int SEQ;
  String INSERT_DATE;
  String INSERT_NAME;
  String SHOP_CD;
  String SHOP_NAME;
  String STATUS;
  String SERVICE_GBN;
  String CANCEL_REQ_YN;
  int ALLOC_UCODE;
  String ALLOC_UNAME;
  String SERVICE_DATA;
  //List<OrderUnitOptions> SERVICE_DATA;
  String ANSWER_TEXT;
  String MOD_DATE;
  int MOD_UCODE;
  String MOD_NAME;

  // factory OrderAccountMenuD.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  // Map<String, dynamic> toJson() => _$ModelToJson(this);

  ServiceRequestDetail({
    this.SEQ,
    this.INSERT_DATE,
    this.INSERT_NAME,
    this.SHOP_CD,
    this.SHOP_NAME,
    this.STATUS,
    this.SERVICE_GBN,
    this.CANCEL_REQ_YN,
    this.ALLOC_UCODE,
    this.ALLOC_UNAME,
    this.SERVICE_DATA,
    this.ANSWER_TEXT,
    this.MOD_DATE,
    this.MOD_UCODE,
    this.MOD_NAME,
  });

  ServiceRequestDetail.fromJson(Map<String, dynamic> json) {
    SEQ = json['SEQ'] as int;
    INSERT_DATE = json['INSERT_DATE'] as String;
    INSERT_NAME = json['INSERT_NAME'] as String;
    SHOP_CD = json['SHOP_CD'] as String;
    SHOP_NAME = json['SHOP_NAME'] as String;
    STATUS = json['STATUS'] as String;
    SERVICE_GBN = json['SERVICE_GBN'] as String;
    CANCEL_REQ_YN = json['CANCEL_REQ_YN'] as String;
    ALLOC_UCODE = json['ALLOC_UCODE'] as int;
    ALLOC_UNAME = json['ALLOC_UNAME'] as String;
    SERVICE_DATA = json['SERVICE_DATA'] as String;

    // if (json['SERVICE_DATA'] != null) {
    //   SERVICE_DATA = new List<OrderUnitOptions>();
    //   json['SERVICE_DATA'].forEach((v) {
    //     SERVICE_DATA.add(new OrderUnitOptions.fromJson(v));
    //   });
    // }

    ANSWER_TEXT = json['ANSWER_TEXT'] as String;
    MOD_DATE = json['MOD_DATE'] as String;
    MOD_UCODE = json['MOD_UCODE'] as int;
    MOD_NAME = json['MOD_NAME'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SEQ'] = this.SEQ;
    data['INSERT_DATE'] = this.INSERT_DATE;
    data['INSERT_NAME'] = this.INSERT_NAME;
    data['SHOP_CD'] = this.SHOP_CD;
    data['SHOP_NAME'] = this.SHOP_NAME;
    data['STATUS'] = this.STATUS;
    data['SERVICE_GBN'] = this.SERVICE_GBN;
    data['CANCEL_REQ_YN'] = this.CANCEL_REQ_YN;
    data['ALLOC_UCODE'] = this.ALLOC_UCODE;
    data['ALLOC_UNAME'] = this.ALLOC_UNAME;

    data['SERVICE_DATA'] = this.SERVICE_DATA;

    // if (this.SERVICE_DATA != null) {
    //   data['SERVICE_DATA'] = this.SERVICE_DATA.map((v) => v.toJson()).toList();
    // }

    data['ANSWER_TEXT'] = this.ANSWER_TEXT;
    data['MOD_DATE'] = this.MOD_DATE;
    data['MOD_UCODE'] = this.MOD_UCODE;
    data['MOD_NAME'] = this.MOD_NAME;

    return data;
  }
}

class OrderUnitOptions {
  String reg_no;
  String ceo_name;
  String image_url;
  String test;

  OrderUnitOptions({this.reg_no, this.ceo_name, this.image_url});

  OrderUnitOptions.fromJson(Map<String, dynamic> json) {
    reg_no = json['reg_no'] as String;
    ceo_name = json['ceo_name'] as String;
    image_url = json['image_url'] as String;
    test = json['test'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reg_no'] = this.reg_no;
    data['ceo_name'] = this.ceo_name;
    data['image_url'] = this.image_url;
    data['test'] = this.test;

    return data;
  }
}
