import 'package:json_annotation/json_annotation.dart';

// @JsonSerializable()
class TaxiRegiListModel {
  TaxiRegiListModel({String RNUM, String regNo, String bussAddr, String shopName, String bussTaxType, String bussOwner, String bussType, String shopCd});

  bool selected = false;
  String RNUM;
  String shopName; //매장명
  String shopCd;
  String bussType; //사업자유형
  String bussTaxType; //사업자유형
  String bussOwner;  //대표자명
  String bussAddr; // 주소
  String regNo;  // 사업자등록번호
  //
  //
  // String mCode;
  // String ccCode;
  // String franchiseCd = '';
  // String shopId;
  //
  //
  //
  // String email;
  // String owner;
  // String mobile;
  // String addr1;
  // String addr2;
  // String lon;
  // String lat;
  // String zipCode;
  // String modUCode;
  // String modName;
  // String memo;
  // String bussCon;
  // String bussType;
  //
  //
  // String salesmanCode = '';
  // String salesmanName = '';
  // String operatorCode = '';
  // String operatorName = '';
  // String sidoName = '';
  // String gunguName = '';
  // String dongName = '';
  // String destJibun = '';
  // String roadDestDong = '';
  // String roadDestAddr = '';
  // String roadDestBuilding = '';
  // String loc = '';
  // String useGbn = '';
  // String telNo = '';
  // String apiComCode = '';
  // String contractEndDt = '';

  // factory TaxiRegiListModel.fromJson(Map<String, dynamic> json) =>
  //     _$ModelFromJson(json);
  //
  // Map<String, dynamic> toJson() => _$ModelToJson(this);
}

// TaxiRegiListModel _$ModelFromJson(Map<String, dynamic> json) {
//   return TaxiRegiListModel()
//     ..selected = json['selected'] as bool
//     // ..mCode = json['mCode'] as String
//     // ..ccCode = json['ccCode'] as String
//     // ..franchiseCd = json['franchiseCd'] as String
//     // ..shopId = json['shopId'] as String
//     ..shopCd = json['shopCd'] as String
//     ..shopName = json['shopName'] as String
//     ..regNo = json['regNo'] as String
//     // ..email = json['email'] as String
//     // ..owner = json['owner'] as String
//     // ..mobile = json['mobile'] as String
//     // ..addr1 = json['addr1'] as String
//     // ..addr2 = json['addr2'] as String
//     // ..lon = json['lon'] as String
//     // ..lat = json['lat'] as String
//     // ..zipCode = json['zipCode'] as String
//     // ..modUCode = json['modUCode'] as String
//     // ..modName = json['modName'] as String
//     // ..memo = json['memo'] as String
//     // ..bussCon = json['bussCon'] as String
//     ..bussType = json['bussType'] as String
//     ..bussTaxType = json['bussTaxType'] as String
//     ..bussOwner = json['bussOwner'] as String
//     ..bussAddr = json['bussAddr'] as String
//     // ..salesmanCode = json['salesmanCode'] as String
//     // ..salesmanName = json['salesmanName'] as String
//     // ..operatorCode = json['operatorCode'] as String
//     // ..operatorName = json['operatorName'] as String
//     // ..sidoName = json['sidoName'] as String
//     // ..gunguName = json['gunguName'] as String
//     // ..dongName = json['dongName'] as String
//     // ..destJibun = json['destJibun'] as String
//     // ..roadDestDong = json['roadDestDong'] as String
//     // ..roadDestAddr = json['roadDestAddr'] as String
//     // ..roadDestBuilding = json['roadDestBuilding'] as String
//     // ..loc = json['loc'] as String
//     // ..useGbn = json['useGbn'] as String
//     // ..telNo = json['telNo'] as String
//     // ..apiComCode = json['apiComCode'] as String
//     // ..contractEndDt = json['contractEndDt'] as String
//   ;
//
// }
//
// Map<String, dynamic> _$ModelToJson(TaxiRegiListModel instance) => <String, dynamic>{
//   'selected': instance.selected,
//   // 'mCode': instance.mCode,
//   // 'ccCode': instance.ccCode,
//   // 'franchiseCd': instance.franchiseCd,
//   // 'shopId': instance.shopId,
//   'shopCd': instance.shopCd,
//   'shopName': instance.shopName,
//   'regNo': instance.regNo,
//   // 'email': instance.email,
//   // 'owner': instance.owner,
//   // 'mobile': instance.mobile,
//   // 'addr1': instance.addr1,
//   // 'addr2': instance.addr2,
//   // 'lon': instance.lon,
//   // 'lat': instance.lat,
//   // 'zipCode': instance.zipCode,
//   // 'modUCode': instance.modUCode,
//   // 'modName': instance.modName,
//   // 'memo': instance.memo,
//   // 'bussCon': instance.bussCon,
//   // 'bussType': instance.bussType,
//   // 'bussTaxType': instance.bussTaxType,
//   // 'bussOwner': instance.bussOwner,
//   // 'bussAddr': instance.bussAddr,
//   // 'salesmanCode': instance.salesmanCode,
//   // 'salesmanName': instance.salesmanName,
//   // 'operatorCode': instance.operatorCode,
//   // 'operatorName': instance.operatorName,
//   // 'sidoName': instance.sidoName,
//   // 'gunguName': instance.gunguName,
//   // 'dongName': instance.dongName,
//   // 'destJibun': instance.destJibun,
//   // 'roadDestDong': instance.roadDestDong,
//   // 'roadDestAddr': instance.roadDestAddr,
//   // 'roadDestBuilding': instance.roadDestBuilding,
//   // 'loc': instance.loc,
//   // 'useGbn': instance.useGbn,
//   // 'telNo': instance.telNo,
//   // 'apiComCode': instance.apiComCode,
//   // 'contractEndDt': instance.contractEndDt,
// };