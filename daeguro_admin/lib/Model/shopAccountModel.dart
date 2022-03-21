import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ShopAccountModel {
  ShopAccountModel();

  bool selected = false;
  bool viewSelected = false;
  String ccCode;
  String shopCd;
  String shopName;
  String regNo;
  String regNoYn;
  //String telNo;
  //String owner;
  //String addr1;
  //String addr2;
  String useGbn;
  //String shopId;
  //String shopPwd;
  String openDate;
  String salesmanCode;
  String salesmanName;
  String operatorCode;
  String operatorName;
  String imageStatus;
  String memo;
  String absentYn;
  String calcYn;
  String shopInfoYn;
  String menuYn;
  String deliYn;
  String tipYn;
  String saleYn;
  String basicInfoYn;
  String appOrderYn;
  String isCharged;
  String isPosInstalled;
  String isPosLogined;
  String loginTime;
  String apiComCode;
  String shopImageYn;
  String menuComplete;
  String franchiseCd;
  String reserveYn;

  factory ShopAccountModel.fromJson(Map<String, dynamic> json) =>      _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

ShopAccountModel _$ModelFromJson(Map<String, dynamic> json) {
  return ShopAccountModel()
    ..selected = json['selected'] as bool
    ..ccCode = json['ccCode'] as String
    ..shopCd = json['shopCd'] as String
    ..shopName = json['shopName'] as String
    ..regNo = json['regNo'] as String
    ..regNoYn = json['regNoYn'] as String
    //..telNo = json['telNo'] as String
    //..owner = json['owner'] as String
    //..addr1 = json['addr1'] as String
    //..addr2 = json['addr2'] as String
    ..useGbn = json['useGbn'] as String
    //..shopId = json['shopId'] as String
    //..shopPwd = json['shopPwd'] as String
    ..openDate = json['openDate'] as String
    ..salesmanCode = json['salesmanCode'] as String
    ..salesmanName = json['salesmanName'] as String
    ..operatorCode = json['operatorCode'] as String
    ..operatorName = json['operatorName'] as String
    ..imageStatus = json['imageStatus'] as String
    ..memo = json['memo'] as String
    ..absentYn = json['absentYn'] as String
    ..calcYn = json['calcYn'] as String
    ..shopInfoYn = json['shopInfoYn'] as String
    ..menuYn = json['menuYn'] as String
    ..deliYn = json['deliYn'] as String
    ..tipYn = json['tipYn'] as String
    ..saleYn = json['saleYn'] as String
    ..basicInfoYn = json['basicInfoYn'] as String
    ..appOrderYn = json['appOrderYn'] as String
    ..isCharged = json['isCharged'] as String
    ..isPosInstalled = json['isPosInstalled'] as String
    ..isPosLogined = json['isPosLogined'] as String
    ..loginTime = json['loginTime'] as String
    ..apiComCode = json['apiComCode'] as String
    ..shopImageYn = json['shopImageYn'] as String
    ..menuComplete = json['menuComplete'] as String
    ..franchiseCd = json['franchiseCd'] as String
    ..reserveYn = json['reserveYn'] as String;
}

Map<String, dynamic> _$ModelToJson(ShopAccountModel instance) => <String, dynamic>{
      'selected': instance.selected,
      'ccCode': instance.ccCode,
      'shopCd': instance.shopCd,
      'shopName': instance.shopName,
      'regNo': instance.regNo,
      'regNoYn': instance.regNoYn,
      //'telNo': instance.telNo,
      //'owner': instance.owner,
      //'addr1': instance.addr1,
      //'addr2': instance.addr2,
      'useGbn': instance.useGbn,
      //'shopId': instance.shopId,
      //'shopPwd': instance.shopPwd,
      'openDate': instance.openDate,
      'salesmanCode': instance.salesmanCode,
      'salesmanName': instance.salesmanName,
      'operatorCode': instance.operatorCode,
      'operatorName': instance.operatorName,
      'imageStatus': instance.imageStatus,
      'memo': instance.memo,
      'absentYn': instance.absentYn,
      'calcYn': instance.calcYn,
      'shopInfoYn': instance.shopInfoYn,
      'menuYn': instance.menuYn,
      'deliYn': instance.deliYn,
      'tipYn': instance.tipYn,
      'saleYn': instance.saleYn,
      'basicInfoYn': instance.basicInfoYn,
      'appOrderYn': instance.appOrderYn,
      'isCharged': instance.isCharged,
      'isPosInstalled': instance.isPosInstalled,
      'isPosLogined': instance.isPosLogined,
      'loginTime': instance.loginTime,
      'apiComCode': instance.apiComCode,
      'shopImageYn': instance.shopImageYn,
      'menuComplete': instance.menuComplete,
      'franchiseCd': instance.franchiseCd,
      'reserveYn': instance.reserveYn
    };
