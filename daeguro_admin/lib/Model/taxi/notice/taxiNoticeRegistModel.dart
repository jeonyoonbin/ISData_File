import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class taxiNoticeRegistModel {
  taxiNoticeRegistModel();

  bool selected = false;
  String idUsrIns;
  String nmUsrIns;
  String ipIns;
  String noParent;
  String noThread;
  String noDepth;
  String idBoard;
  String divBoard;
  String divSubBoard;
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
  String imgThumb;
  String imgCont1;
  String imgCont2;
  String imgCont3;
  String seqBoard;

  factory taxiNoticeRegistModel.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

taxiNoticeRegistModel _$ModelFromJson(Map<String, dynamic> json) {
  return taxiNoticeRegistModel()
    ..selected = json['selected'] as bool
    ..idUsrIns = json['idUsrIns'] as String
    ..nmUsrIns = json['nmUsrIns'] as String
    ..ipIns = json['ipIns'] as String
    ..noParent = json['noParent'] as String
    ..noThread = json['noThread'] as String
    ..noDepth = json['noDepth'] as String
    ..idBoard = json['idBoard'] as String
    ..divBoard = json['divBoard'] as String
    ..divSubBoard = json['divSubBoard'] as String
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
    ..imgThumb = json['imgThumb'] as String
    ..imgCont1 = json['imgCont1'] as String
    ..imgCont2 = json['imgCont2'] as String
    ..imgCont3 = json['imgCont3'] as String
    ..seqBoard = json['seqBoard'] as String;
}

Map<String, dynamic> _$ModelToJson(taxiNoticeRegistModel instance) => <String, dynamic>{
  'selected': instance.selected,
  'idUsrIns': instance.idUsrIns,
  'nmUsrIns': instance.nmUsrIns,
  'ipIns': instance.ipIns,
  'noParent': instance.noParent,
  'noThread': instance.noThread,
  'noDepth': instance.noDepth,
  'idBoard': instance.idBoard,
  'divBoard': instance.divBoard,
  'divSubBoard': instance.divSubBoard,
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
  'imgThumb': instance.imgThumb,
  'imgCont1': instance.imgCont1,
  'imgCont2': instance.imgCont2,
  'imgCont3': instance.imgCont3,
  'seqBoard': instance.seqBoard,
};
