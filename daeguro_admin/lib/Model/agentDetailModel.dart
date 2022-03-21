import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class AgentDetailModel {
  AgentDetailModel();

  bool selected;
  int mCode;
  String ccCode;
  String ccName;
  String cLevel;
  String useGbn;
  String remainAmt;
  String ddd;
  String telNo;
  String faxNo;
  String owner;
  String mobile;
  String zipCode;
  String addr1;
  String addr2;
  String email;
  String bussType;
  String bussCon;
  String regNo;
  String bankCode;
  String accountNo;
  String accOwner;
  String insert_Date;
  String closed_Date;
  String memo;
  String userCode;
  String userName;

  factory AgentDetailModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

AgentDetailModel _$ModelFromJson(Map<String, dynamic> json) {
  return AgentDetailModel()
    ..selected = json['selected'] as bool
    ..mCode = json['mCode'] as int
    ..ccCode = json['ccCode'] as String
    ..ccName = json['ccName'] as String
    ..cLevel = json['cLevel'] as String
    ..useGbn = json['useGbn'] as String
    ..remainAmt = json['remainAmt'] as String
    ..ddd = json['ddd'] as String
    ..telNo = json['telNo'] as String
    ..faxNo = json['faxNo'] as String
    ..owner = json['owner'] as String
    ..mobile = json['mobile'] as String
    ..zipCode = json['zipCode'] as String
    ..addr1 = json['addr1'] as String
    ..addr2 = json['addr2'] as String
    ..email = json['email'] as String
    ..bussType = json['bussType'] as String
    ..bussCon = json['bussCon'] as String
    ..regNo = json['regNo'] as String
    ..bankCode = json['bankCode'] as String
    ..accountNo = json['accountNo'] as String
    ..accOwner = json['accOwner'] as String
    ..insert_Date = json['insert_Date'] as String
    ..closed_Date = json['closed_Date'] as String
    ..memo = json['memo'] as String
    ..userCode = json['userCode'] as String
    ..userName = json['userName'] as String;

}

Map<String, dynamic> _$ModelToJson(AgentDetailModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'mCode': instance.mCode,
  'ccCode': instance.ccCode,
  'ccName': instance.ccName,
  'cLevel': instance.cLevel,
  'useGbn': instance.useGbn,
  'remainAmt': instance.remainAmt,
  'ddd': instance.ddd,
  'telNo': instance.telNo,
  'faxNo': instance.faxNo,
  'owner': instance.owner,
  'mobile': instance.mobile,
  'zipCode': instance.zipCode,
  'addr1': instance.addr1,
  'addr2': instance.addr2,
  'email': instance.email,
  'bussType': instance.bussType,
  'bussCon': instance.bussCon,
  'regNo': instance.regNo,
  'bankCode': instance.bankCode,
  'accountNo': instance.accountNo,
  'accOwner': instance.accOwner,
  'insert_Date': instance.insert_Date,
  'closed_Date': instance.closed_Date,
  'memo': instance.memo,
  'userCode': instance.userCode,
  'userName': instance.userName
};
