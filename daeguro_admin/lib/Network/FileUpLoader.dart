import 'dart:convert';
import 'dart:typed_data';

import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as Im;
import 'package:flutter/foundation.dart' show compute;

//curl -X POST "http://172.16.10.65:5000/Shop/PostFiles?shop_cd=1&kind=20" -H  "accept: */*" -H  "Content-Type: multipart/form-data" -F "files=@logo.png;type=image/png" -F "files=@logo2.png;type=image/png"

class FileUpLoadProvider extends ChangeNotifier {
  String type;
  var src;
  var responseData;

  Future setResource(String type, src) async {
    this.type = type;
    this.src = src;
    this.notifyListeners();
  }

  Future makeShopMenuPutResourceRequest(String ccCode, String shopCode, String menuCode, BuildContext context) async {
    var headers = {};
    String mURL = ServerInfo.REST_URL_IMAGE + '?menu_cd=$menuCode&cccode=$ccCode&shop_cd=$shopCode';

    var uri = Uri.parse(mURL);

    // print('menu upload type['+ this.type+']:'+mURL);
    // if (this.src == null){
    //   print('resource is NULL');
    // }
    // else
    //   print('resource path -> '+this.src.path);

    var request = http.MultipartRequest('PUT', uri);
    //request.headers.addAll(headers);

    if (type == 'image') {
      Uint8List data = await this.src.readAsBytes();
      List<int> list = data.cast();
      request.files.add(http.MultipartFile.fromBytes('formFile', list, filename: 'upload_temp.png'));
    }
    else if (type == 'file') {
      var bytes = src.files.first.bytes;
      String filename = src.files.first.name;

      request.files.add(
          http.MultipartFile.fromBytes('formFile', bytes, filename: filename));
    }

    var response = await request.send();
    response.stream.bytesToString().asStream().listen((event) {
      responseData = json.decode(event);
      if(responseData['code'] != '00')
        {
          ISAlert(context, '이미지 등록에 실패 했습니다. \n\n관리자에게 문의 바랍니다');
        }
    });
  }

  Future makeRepImagePostResourceRequest(String div, String ccCode, String shopCode, BuildContext context) async {
    var headers = {};

    String uCode = GetStorage().read('logininfo')['uCode'];
    String uName = GetStorage().read('logininfo')['name'];

    String mURL = ServerInfo.REST_URL_IMAGE + '?div=$div&cccode=$ccCode&shop_cd=$shopCode&salesmanCode=$uCode&salesmanName=$uName';

    var uri = Uri.parse(mURL);

    var request = http.MultipartRequest('POST', uri);

    if (type == 'image') {
      Uint8List data = await this.src.readAsBytes();
      List<int> list = data.cast();

      if (div == '4'){
        request.files.add(http.MultipartFile.fromBytes('formFile', list, filename: 'upload_temp.png'));
      }
      else{
        Im.Image image = await compressImage(list);
        request.files.add(http.MultipartFile.fromBytes('formFile', Im.encodeJpg(image, quality: 100), filename: 'upload_temp.png'));
      }
    }
    else if (type == 'file') {
      var bytes = src.files.first.bytes;
      String filename = src.files.first.name;

      request.files.add(http.MultipartFile.fromBytes('formFile', bytes, filename: filename));
    }

    var response = await request.send();
    response.stream.bytesToString().asStream().listen((event) {
      responseData = json.decode(event);
      if(responseData['code'] != '00') {
        //print('--- code[${responseData['code']}] msg: ${responseData['msg']}');
        ISAlert(context, '이미지 등록에 실패 했습니다. \n\n관리자에게 문의 바랍니다');
      }
    });
  }

  static Future<Im.Image> compressImage(List<int> list) async {
    return compute(_decodeImage, list);
  }

  static Im.Image _decodeImage(List<int> list) {
    Im.Image retImage = null;

    Im.Image image = Im.decodeImage(list);
    //print('original_image w:${image.width}, h:${image.height}, length:${image.length}');
    if (image.width > 1024) {
      retImage = Im.copyResize(image, width: 1024); // choose the size here, it will maintain aspect ratio
      //print('resize_image w:${retImage.width}, h:${retImage.height}, length:${retImage.length}');
    }
    else
      retImage = image;

    return retImage;
  }

  Future makeNoticePostResourceRequest(String noticeGbn, String dispGbn, String dispFromDate, String dispToDate, String noticeTitle, String noticeContents,
      String noticeUrl_1, String noticeUrl_2, String orderDate, String insDate, String insUCode, String insName, String extUrlYn) async {

    String mURL = ServerInfo.REST_URL_NOTICE;

    var uri = Uri.parse(mURL);

    var request = http.MultipartRequest('POST', uri);

    request.headers.addAll({'Content-Type' : 'application/x-www-form-urlencoded'});

    request.fields['noticeGbn'] = noticeGbn;
    request.fields['dispGbn'] = dispGbn;
    request.fields['dispFromDate'] = dispFromDate;
    request.fields['dispToDate'] = dispToDate;
    request.fields['noticeTitle'] = noticeTitle;
    request.fields['noticeContents'] = noticeContents;
    request.fields['noticeUrl_1'] = noticeUrl_1;
    request.fields['noticeUrl_2'] = noticeUrl_2;
    request.fields['orderDate'] = orderDate;
    request.fields['insDate'] = insDate;
    request.fields['insUCode'] = insUCode;
    request.fields['insName'] = insName;
    request.fields['extUrlYn'] = extUrlYn;

    if (type == 'image') {
      Uint8List data = await this.src.readAsBytes();
      List<int> list = data.cast();
      request.files.add(http.MultipartFile.fromBytes('formFile', list, filename: 'upload_temp.png'));
    }
    else if (type == 'file') {
      var bytes = src.files.first.bytes;
      String filename = src.files.first.name;

      request.files.add(http.MultipartFile.fromBytes('formFile', bytes, filename: filename));
    }

    var response = await request.send();
    response.stream.bytesToString().asStream().listen((event) {
      responseData = json.decode(event);
      //print(response.statusCode);
    });
  }

  //REST_URL_NOTICEFILE

  Future makeNoticePutResourceRequest(String noticeSeq, String noticeGbn, String dispGbn, String dispFromDate, String dispToDate, String noticeTitle, String noticeContents,
      String noticeUrl_1, String noticeUrl_2, String orderDate, String modUcode, String modName, String extUrlYn) async {

    String mURL = ServerInfo.REST_URL_NOTICE;

    var uri = Uri.parse(mURL);

    var request = http.MultipartRequest('PUT', uri);

    request.headers.addAll({'Content-Type' : 'application/x-www-form-urlencoded'});

    request.fields['noticeSeq'] = noticeSeq;
    request.fields['noticeGbn'] = noticeGbn;
    request.fields['dispGbn'] = dispGbn;
    request.fields['dispFromDate'] = dispFromDate;
    request.fields['dispToDate'] = dispToDate;
    request.fields['noticeTitle'] = noticeTitle;
    request.fields['noticeContents'] = noticeContents;
    request.fields['noticeUrl_1'] = noticeUrl_1;
    request.fields['noticeUrl_2'] = noticeUrl_2;
    request.fields['orderDate'] = orderDate;
    request.fields['modUCode'] = modUcode;
    request.fields['modName'] = modName;
    request.fields['extUrlYn'] = extUrlYn;

    if (type == 'image') {
      if (src == null) {
        var response = await request.send();
        response.stream.bytesToString().asStream().listen((event) {
          // print('event: ' + event);
          responseData = json.decode(event);
        });

        return;
      }

      Uint8List data = await this.src.readAsBytes();
      List<int> list = data.cast();
      request.files.add(http.MultipartFile.fromBytes('formFile', list, filename: 'upload_temp.png'));
    }
    else if (type == 'file') {
      var bytes = src.files.first.bytes;
      String filename = src.files.first.name;

      request.files.add(http.MultipartFile.fromBytes('formFile', bytes, filename: filename));
    }

    var response = await request.send();

    response.stream.bytesToString().asStream().listen((event) {
      responseData = json.decode(event);
    });
  }

  Future makeReserNoticePostResourceRequest(String noticeGbn, String dispGbn, String dispFromDate, String dispToDate, String noticeTitle, String noticeContents,
      String noticeUrl_2, String orderDate, String insDate, String insUCode, String insName) async {

    String mURL = ServerInfo.REST_RESERVEURL+'/notice';

    var uri = Uri.parse(mURL);

    var request = http.MultipartRequest('POST', uri);

    request.headers.addAll({'Content-Type' : 'application/x-www-form-urlencoded'});

    request.fields['noticeGbn'] = noticeGbn;
    request.fields['dispGbn'] = dispGbn;
    request.fields['dispFrDate'] = dispFromDate;
    request.fields['dispToDate'] = dispToDate;
    request.fields['title'] = noticeTitle;
    request.fields['contents'] = noticeContents;
    request.fields['url2'] = noticeUrl_2;
    request.fields['orderDate'] = orderDate;
    request.fields['ucode'] = insDate;
    request.fields['userName'] = insUCode;
    request.fields['insDate'] = insName;

    if (type == 'image') {
      Uint8List data = await this.src.readAsBytes();
      List<int> list = data.cast();
      request.files.add(http.MultipartFile.fromBytes('file', list, filename: 'upload_temp.png'));
    }
    else if (type == 'file') {
      var bytes = src.files.first.bytes;
      String filename = src.files.first.name;

      request.files.add(http.MultipartFile.fromBytes('file', bytes, filename: filename));
    }

    var response = await request.send();
    response.stream.bytesToString().asStream().listen((event) {
      responseData = json.decode(event);
      //print(response.statusCode);
    });
  }

  Future makeReserNoticePutResourceRequest(String noticeSeq, String noticeGbn, String dispGbn, String dispFromDate, String dispToDate, String noticeTitle, String noticeContents,
      String noticeUrl_2, String orderDate, String modUcode, String modName) async {

    String mURL = ServerInfo.REST_RESERVEURL+'/notice';

    var uri = Uri.parse(mURL);

    var request = http.MultipartRequest('PUT', uri);

    request.headers.addAll({'Content-Type' : 'application/x-www-form-urlencoded'});

    request.fields['noticeSeq'] = noticeSeq;
    request.fields['noticeGbn'] = noticeGbn;
    request.fields['dispGbn'] = dispGbn;
    request.fields['dispFrDate'] = dispFromDate;
    request.fields['dispToDate'] = dispToDate;
    request.fields['title'] = noticeTitle;
    request.fields['contents'] = noticeContents;
    request.fields['url2'] = noticeUrl_2;
    request.fields['orderDate'] = orderDate;
    request.fields['ucode'] = modUcode;
    request.fields['userName'] = modName;

    if (type == 'image') {
      if (src == null) {
        var response = await request.send();
        response.stream.bytesToString().asStream().listen((event) {
          // print('event: ' + event);
          responseData = json.decode(event);
        });

        return;
      }

      Uint8List data = await this.src.readAsBytes();
      List<int> list = data.cast();
      request.files.add(http.MultipartFile.fromBytes('file', list, filename: 'upload_temp.png'));
    }
    else if (type == 'file') {
      var bytes = src.files.first.bytes;
      String filename = src.files.first.name;

      request.files.add(http.MultipartFile.fromBytes('file', bytes, filename: filename));
    }

    var response = await request.send();

    response.stream.bytesToString().asStream().listen((event) {
      responseData = json.decode(event);
    });
  }

  Future makeReserShopImagePostResourceRequest(String ccCode, String shopCode) async {

    String mURL = ServerInfo.REST_RESERVEURL+'/shopImage/insert';//'https://reser.daeguro.co.kr:10018/notice';

    var uri = Uri.parse(mURL);

    var request = http.MultipartRequest('PUT', uri);

    request.headers.addAll({'Content-Type' : 'application/x-www-form-urlencoded'});

    request.fields['ccCode'] = ccCode;
    request.fields['shopCode'] = shopCode;

    if (type == 'image') {
      if (src == null) {
        var response = await request.send();
        response.stream.bytesToString().asStream().listen((event) {
          // print('event: ' + event);
          responseData = json.decode(event);
        });

        return;
      }

      Uint8List data = await this.src.readAsBytes();
      List<int> list = data.cast();
      request.files.add(http.MultipartFile.fromBytes('file', list, filename: 'upload_temp.png'));
    }
    else if (type == 'file') {
      var bytes = src.files.first.bytes;
      String filename = src.files.first.name;

      request.files.add(http.MultipartFile.fromBytes('file', bytes, filename: filename));
    }

    var response = await request.send();

    response.stream.bytesToString().asStream().listen((event) {
      responseData = json.decode(event);
    });
  }

  Future makeReserShopReviewPostResourceRequest(String ccCode, String shopCode, String seq) async {

    String mURL = ServerInfo.REST_RESERVEURL+'/reviewImage/update';//'https://reser.daeguro.co.kr:10018/notice';

    var uri = Uri.parse(mURL);

    var request = http.MultipartRequest('PUT', uri);

    request.headers.addAll({'Content-Type' : 'application/x-www-form-urlencoded'});

    request.fields['ccCode'] = ccCode;
    request.fields['shopCode'] = shopCode;
    request.fields['seq'] = seq;
    request.fields['userId'] = GetStorage().read('logininfo')['uCode'];

    if (type == 'image') {
      if (src == null) {
        var response = await request.send();
        response.stream.bytesToString().asStream().listen((event) {
          // print('event: ' + event);
          responseData = json.decode(event);
        });

        return;
      }

      Uint8List data = await this.src.readAsBytes();
      List<int> list = data.cast();
      request.files.add(http.MultipartFile.fromBytes('file', list, filename: 'upload_temp.png'));
    }
    else if (type == 'file') {
      var bytes = src.files.first.bytes;
      String filename = src.files.first.name;

      request.files.add(http.MultipartFile.fromBytes('file', bytes, filename: filename));
    }

    var response = await request.send();

    response.stream.bytesToString().asStream().listen((event) {
      responseData = json.decode(event);
    });
  }
}


