import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class AgentListModel {
    AgentListModel();

    bool selected;
    String ccCode;
    String ccName;
    String cLevel;
    String ddd;
    String telNo;
    String faxNo;
    String regNo;
    String useGbn;
    String remainAmt;
    String addr;
    String owner;
    
    factory AgentListModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
    Map<String, dynamic> toJson() => _$ModelToJson(this);
}

AgentListModel _$ModelFromJson(Map<String, dynamic> json) {
    return AgentListModel()
        ..selected = json['selected'] as bool
        ..ccCode = json['ccCode'] as String
        ..ccName = json['ccName'] as String
        ..cLevel = json['cLevel'] as String
        ..ddd = json['ddd'] as String
        ..telNo = json['telNo'] as String
        ..faxNo = json['faxNo'] as String
        ..regNo = json['regNo'] as String
        ..useGbn = json['useGbn'] as String
        ..remainAmt = json['remainAmt'] as String
        ..addr = json['addr'] as String
        ..owner = json['owner'] as String;
}

Map<String, dynamic> _$ModelToJson(AgentListModel instance) => <String, dynamic>{
    'selected': instance.selected,
    'ccCode': instance.ccCode,
    'ccName': instance.ccName,
    'cLevel': instance.cLevel,
    'ddd': instance.ddd,
    'telNo': instance.telNo,
    'faxNo': instance.faxNo,
    'regNo': instance.regNo,
    'useGbn': instance.useGbn,
    'remainAmt': instance.remainAmt,
    'addr': instance.addr,
    'owner': instance.owner
};
