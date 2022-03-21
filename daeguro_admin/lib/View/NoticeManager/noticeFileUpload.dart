
import 'dart:convert';

import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:file_picker/file_picker.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;


class NoticeFileUpload extends StatefulWidget {
  const NoticeFileUpload({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NoticeFileUploadState();
  }
}

class NoticeFileUploadState extends State<NoticeFileUpload> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String _pickedImagePath = '';
  String _pickedFilePath = '';
  var _fileImage = null;
  var _fileHtml = null;
  var _showResult = '';
  var _returnResult = '';

  bool isImageSaveEnabled = false;
  bool isFileSaveEnabled = false;

  @override
  void dispose(){
    PaintingBinding.instance.imageCache.clearLiveImages();
    PaintingBinding.instance.imageCache.clear();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  Text('- 이미지 파일', style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(width: 10,),
                  AnimatedOpacity(
                    opacity: isImageSaveEnabled ? 1.0 : 0.0,
                    duration: Duration(seconds: 1),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.red, size: 18,),
                        Text('저장 완료', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                      ],
                    ),
                    onEnd: (){
                      setState(() {
                        isImageSaveEnabled = false;
                      });
                    },
                  ),
                ],
              )
          ),
          ISInput(
            value: _pickedImagePath,
            readOnly: true,
            context: context,
            label: '파일 선택(클릭)',
            //hintText: '클릭 후, 파일 선택',
            onTap: () async {
              FilePickerResult result = await FilePicker.platform.pickFiles(withReadStream: false);

              if (result != null) {
                _fileImage = null;
                _fileImage = result;

                String fileName = result.files.first.name;
                _pickedImagePath = fileName;
              }
              else {
                // User canceled the picker
              }

              setState(() {});
            },
            prefixIcon: Icon(_fileImage == null ? Icons.help_outline : Icons.check_circle_outline, color: _fileImage == null ? Colors.red : Colors.blue, size: 18,),
            suffixIcon: MaterialButton(
              color: Colors.blue,
              minWidth: 40,
              child: Icon(Icons.file_upload, color: Colors.white, size: 18,),//Text('저장', style: TextStyle(color: Colors.white, fontSize: 14),),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
              onPressed: () async {
                if (_fileImage == null || _pickedImagePath == '') {
                  ISAlert(context, '선택된 파일이 없습니다.');
                  return;
                }

                // FileUpLoadProvider provider = FileUpLoadProvider();
                // provider.setResource('file', _fileImage);
                // provider.makeNoticePostWebDataRequest('0');
                //
                // setState(() {});

                var request = http.MultipartRequest('POST', Uri.parse(ServerInfo.REST_URL_NOTICEFILE+'?div=0'));
                request.headers.addAll({'Content-Type' : 'multipart/form-data'});

                var bytes = _fileImage.files.first.bytes;
                String filename = _fileImage.files.first.name;

                request.files.add(http.MultipartFile.fromBytes('formFile', bytes, filename: filename));

                request.send().then((response) {
                  if (response.statusCode == 200) {
                    response.stream.bytesToString().asStream().listen((event) {
                      var responseData = json.decode(event);
                      print('response code:${response.statusCode}, responseData:${responseData.toString()}');
                      print('response path:${responseData['msg'].toString()}');

                      setState(() {
                        isImageSaveEnabled = true;
                      });
                    });
                  }
                  else{
                    _showResult = '[전송오류] 관리자에게 문의하세요.';
                  }
                });

                //Navigator.pop(context, true);
              },
            ),
            onChange: (v) {
              //editData.noticeTitle = v;
            },
          ),
          Container(
            padding: EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                Text('- HTML 파일', style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(width: 10,),
                AnimatedOpacity(
                  opacity: isFileSaveEnabled ? 1.0 : 0.0,
                  duration: Duration(seconds: 1),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.red, size: 18,),
                      Text('저장 완료', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                    ],
                  ),
                  onEnd: (){
                    setState(() {
                      isFileSaveEnabled = false;
                    });
                  },
                ),
              ],
            )
          ),
          ISInput(
            value: _pickedFilePath,
            readOnly: true,
            context: context,
            label: '파일 선택(클릭)',
            onTap: () async {
              FilePickerResult result = await FilePicker.platform.pickFiles(withReadStream: false);

              if (result != null) {
                _fileHtml = null;
                _fileHtml = result;

                String fileName = result.files.first.name;
                _pickedFilePath = fileName;
              }
              else {
                // User canceled the picker
              }

              setState(() {});
            },
            prefixIcon: Icon(_fileHtml == null ? Icons.help_outline : Icons.check_circle_outline, color: _fileHtml == null ? Colors.red : Colors.blue, size: 18,),
            suffixIcon: MaterialButton(
              color: Colors.blue,
              minWidth: 40,
              child: Icon(Icons.file_upload, color: Colors.white, size: 18,),//Text('저장', style: TextStyle(color: Colors.white, fontSize: 14),),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
              onPressed: () async {
                if (_fileHtml == null || _pickedFilePath == '') {
                  ISAlert(context, '선택된 파일이 없습니다.');
                  return;
                }

                var request = http.MultipartRequest('POST', Uri.parse(ServerInfo.REST_URL_NOTICEFILE+'?div=1'));
                request.headers.addAll({'Content-Type' : 'multipart/form-data'});

                var bytes = _fileHtml.files.first.bytes;
                String filename = _fileHtml.files.first.name;

                request.files.add(http.MultipartFile.fromBytes('formFile', bytes, filename: filename));

                request.send().then((response) {
                  if (response.statusCode == 200) {
                    response.stream.bytesToString().asStream().listen((event) {
                      var responseData = json.decode(event);
                      //print('response code:${response.statusCode}, responseData:${responseData.toString()}');
                      //print('response path:${responseData['msg'].toString()}');

                      setState(() {
                        isFileSaveEnabled = true;
                        _returnResult = responseData['msg'].toString();
                        _showResult = '[등록성공] \n-> ${_returnResult}';
                      });
                    });
                  }
                  else{
                    _showResult = '[전송오류] 관리자에게 문의하세요.';
                  }
                });
              },
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: 16, left: 10),
              child: SelectableText(_showResult, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold), showCursor: true,)
          ),
        ],
      ),
    );

    ButtonBar buttonBar = ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        ISButton(
          label: '닫기',
          iconData: Icons.cancel,
          onPressed: () {
            Navigator.pop(context, _returnResult);
          },
        )
      ],
    );

    var result = Scaffold(
      appBar: AppBar(
        title: Text('HTML파일 업로드'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: form
            ),
          ],
        ),
      ),
      bottomNavigationBar: buttonBar,
    );
    return SizedBox(
      width: 360,
      height: 360,
      child: result,
    );
  }
}
