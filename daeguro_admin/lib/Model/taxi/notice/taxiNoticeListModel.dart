import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class taxiNoticeListModel {
  taxiNoticeListModel();

  bool selected = false;
  String seqBoard;
  String noParent;
  String noThread;
  String noDepth;
  String idBoard;
  String divBoard;
  String divBoardText;
  String divSubBoard;
  String divSubBoardText;
  String dtmIns;
  String idUsrIns;
  String nmUsrIns;
  String ipIns;
  String dtmUpd;
  String idUsrUpd;
  String nmUsrUpd;
  String ipUpd;
  String cdComp;
  String cdCust;
  String dtOrdno;
  String seqOrdno;
  String nmSector;
  String email;
  String subject;
  String contHtml;
  String contText;
  String ynOpen;
  String dtStart;
  String dtEnd;
  String noPwd;
  String imgThubm;
  String imgCont1;
  String imgCont2;
  String imgCont3;
  String cntAttach;
  String cntRead;

  factory taxiNoticeListModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

taxiNoticeListModel _$ModelFromJson(Map<String, dynamic> json) {
  return taxiNoticeListModel()
    ..selected = json['selected'] as bool
    ..seqBoard = json['seqBoard'] as String
    ..noParent = json['noParent'] as String
    ..noThread = json['noThread'] as String
    ..noDepth = json['noDepth'] as String
    ..idBoard = json['idBoard'] as String
    ..divBoard = json['divBoard'] as String
    ..divBoardText = json['divBoardText'] as String
    ..divSubBoard = json['divSubBoard'] as String
    ..divSubBoardText = json['divSubBoardText'] as String
    ..dtmIns = json['dtmIns'] as String
    ..idUsrIns = json['idUsrIns'] as String
    ..nmUsrIns = json['nmUsrIns'] as String
    ..ipIns = json['ipIns'] as String
    ..dtmUpd = json['dtmUpd'] as String
    ..idUsrUpd = json['idUsrUpd'] as String
    ..nmUsrUpd = json['nmUsrUpd'] as String
    ..ipUpd = json['ipUpd'] as String
    ..cdComp = json['cdComp'] as String
    ..cdCust = json['cdCust'] as String
    ..dtOrdno = json['dtOrdno'] as String
    ..seqOrdno = json['seqOrdno'] as String
    ..nmSector = json['nmSector'] as String
    ..email = json['email'] as String
    ..subject = json['subject'] as String
    ..contHtml = json['contHtml'] as String
    ..contText = json['contText'] as String
    ..ynOpen = json['ynOpen'] as String
    ..dtStart = json['dtStart'] as String
    ..dtEnd = json['dtEnd'] as String
    ..noPwd = json['noPwd'] as String
    ..imgThubm = json['imgThubm'] as String
    ..imgCont1 = json['imgCont1'] as String
    ..imgCont2 = json['imgCont2'] as String
    ..imgCont3 = json['imgCont3'] as String
    ..cntAttach = json['cntAttach'] as String
    ..cntRead = json['cntRead'] as String;

}

Map<String, dynamic> _$ModelToJson(taxiNoticeListModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'seqBoard': instance.seqBoard,
  'noParent': instance.noParent,
  'noThread': instance.noThread,
  'noDepth': instance.noDepth,
  'idBoard': instance.idBoard,
  'divBoard': instance.divBoard,
  'divBoardText': instance.divBoardText,
  'divSubBoard': instance.divSubBoard,
  'divSubBoardText': instance.divSubBoardText,
  'dtmIns': instance.dtmIns,
  'idUsrIns': instance.idUsrIns,
  'nmUsrIns': instance.nmUsrIns,
  'ipIns': instance.ipIns,
  'dtmUpd': instance.dtmUpd,
  'idUsrUpd': instance.idUsrUpd,
  'nmUsrUpd': instance.nmUsrUpd,
  'ipUpd': instance.ipUpd,
  'cdComp': instance.cdComp,
  'cdCust': instance.cdCust,
  'dtOrdno': instance.dtOrdno,
  'seqOrdno': instance.seqOrdno,
  'nmSector': instance.nmSector,
  'email': instance.email,
  'subject': instance.subject,
  'contHtml': instance.contHtml,
  'contText': instance.contText,
  'ynOpen': instance.ynOpen,
  'dtStart': instance.dtStart,
  'dtEnd': instance.dtEnd,
  'noPwd': instance.noPwd,
  'imgThubm': instance.imgThubm,
  'imgCont1': instance.imgCont1,
  'imgCont2': instance.imgCont2,
  'imgCont3': instance.imgCont3,
  'cntAttach': instance.cntAttach,
  'cntRead': instance.cntRead
};
