@JS()
library javascript_bundler;

import 'dart:async';
import 'dart:convert';

import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/Model/requestPutModel.dart';
import 'package:daeguro_admin_app/Model/serviceRequestDetail.dart';
import 'package:daeguro_admin_app/Model/user/user_code_name.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/RequestManager/requestManager_controller.dart';
import 'package:daeguro_admin_app/View/UserManager/user_controller.dart';
import 'package:js/js.dart';

import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

@JS('downloadImg')
external void showConfirm(var _uri);

class RestListDetail_100 extends StatefulWidget {
  final String seq;

  //final ShopInfo sData;
  const RestListDetail_100({Key key, this.seq}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RestListDetail_100State();
  }
}

class RestListDetail_100State extends State<RestListDetail_100> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ServiceRequestDetail formData = ServiceRequestDetail();
  RequestPutModel editData;

  String RepImagePath;

  String a_reg_no = '';
  String a_buss_owner = '';
  String a_buss_con = '';
  String a_buss_type = '';
  String a_buss_addr = '';
  String a_buss_tax_type = '';
  String a_owner = '';
  String image_url = '';

  String b_reg_no = '';
  String b_buss_owner = '';
  String b_buss_con = '';
  String b_buss_type = '';
  String b_buss_addr = '';
  String b_buss_tax_type = '';
  String b_owner = '';

  String _a_data = '';
  String _b_data = '';

  List<String> shopImageList = [];
  List<String> shopImageDownList = [];
  List<String> shopImageViewList = [];
  List<bool> _shopimgGbn = [];
  int errorcnt = 0;

  List<SelectOptionVO> selectBox_DivCode = [];
  List<SelectOptionVO> selectBox_Status = [];

  int current_tabIdx = 0;

  List<SelectOptionVO> selectBox_operator = [];

  String _alloc_ucode;
  String _alloc_uname;

  loadOperatorListData() async {
    selectBox_operator.clear();

    await UserController.to.getUserCodeNameOperator('2', '6').then((value) {
      if (value == null) {
        ISAlert(context, '사용자ID 또는 비밀번호를 확인하십시오.');
      } else {
        selectBox_operator.add(new SelectOptionVO(
          value: 'null',
          label: '--',
          label2: '',
        ));

        // 오퍼레이터 바인딩
        value.forEach((element) {
          UserCodeName tempData = UserCodeName.fromJson(element);

          selectBox_operator.add(new SelectOptionVO(
            value: tempData.code,
            label: '[' + tempData.code + '] ' + tempData.name,
            label2: tempData.name,
          ));
        });

        //setState(() {});
      }
    });
  }

  loadData() async {
    await RequestController.to.getDetailData(widget.seq, context);

    if (this.mounted) {
      setState(() {
        formData = ServiceRequestDetail.fromJson(RequestController.to.qDataDetail);

        _alloc_ucode = formData.ALLOC_UCODE.toString();
        _alloc_uname = formData.ALLOC_UNAME;

        Map<String, dynamic> _tojson = jsonDecode(formData.SERVICE_DATA);

        a_reg_no = Utils.getStoreRegNumberFormat(_tojson['a_reg_no'], false);
        a_buss_owner = _tojson['a_buss_owner'];
        a_buss_con = _tojson['a_buss_con'];
        a_buss_type = _tojson['a_buss_type'];
        a_buss_addr = _tojson['a_buss_addr'];
        a_buss_tax_type = _tojson['a_buss_tax_type'];
        a_owner = _tojson['a_owner'];
        image_url = _tojson['image_url'];

        b_reg_no = Utils.getStoreRegNumberFormat(_tojson['b_reg_no'], false);
        b_buss_owner = _tojson['b_buss_owner'];
        b_buss_con = _tojson['b_buss_con'];
        b_buss_type = _tojson['b_buss_type'];
        b_buss_addr = _tojson['b_buss_addr'];
        b_buss_tax_type = _tojson['b_buss_tax_type'];
        b_owner = _tojson['b_owner'];

        if (a_buss_tax_type == '1') {
          a_buss_tax_type = '[1] 일반';
        } else {
          a_buss_tax_type = '[3] 간이';
        }

        if (b_buss_tax_type == '1') {
          b_buss_tax_type = '[1] 일반';
        } else {
          b_buss_tax_type = '[3] 간이';
        }

        _a_data = '사업자 번호 : ' +
            a_reg_no.toString() +
            '\n대표자명 : ' +
            b_owner.toString() +
            '\n업태 : ' +
            a_buss_con.toString() +
            '\n업종 : ' +
            a_buss_type.toString() +
            '\n사업장 주소: ' +
            a_buss_addr.toString() +
            '\n사업자유형 : ' +
            a_buss_tax_type.toString() +
            '\n사업자 대표자명 : ' +
            a_buss_owner.toString();
        _b_data = '사업자 번호 : ' +
            b_reg_no.toString() +
            '\n대표자명 : ' +
            b_owner.toString() +
            '\n업태 : ' +
            b_buss_con.toString() +
            '\n업종 : ' +
            b_buss_type.toString() +
            '\n사업장 주소: ' +
            b_buss_addr.toString() +
            '\n사업자유형 : ' +
            b_buss_tax_type.toString() +
            '\n사업자 대표자명 : ' +
            b_buss_owner.toString();
        //formData.SERVICE_DATA = '사업자번호 : ' + _reg_no + '\n대표자명 : ' + _owner + '\n업태 : ' + _buss_con + '\n업종 : ' + _buss_type + '\n사업장 주소 : ' + _buss_addr + '\n과세구분 : ' + _buss_tax_type;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();

    PaintingBinding.instance.imageCache.clearLiveImages();
    PaintingBinding.instance.imageCache.clear();
  }

  @override
  void initState() {
    super.initState();

    //_deleteCacheDir();

    //Get.put(AgentController());
    //formKey.currentState.reset();

    _shopimgGbn.add(false); // 사업자등록증
    _shopimgGbn.add(false); // 영업신고증
    _shopimgGbn.add(false); // 통장사본

    selectBox_Status.add(new SelectOptionVO(value: '10', label: '접수(요청)'));
    selectBox_Status.add(new SelectOptionVO(value: '30', label: '진행중(심사중)'));
    selectBox_Status.add(new SelectOptionVO(value: '35', label: '보완'));
    selectBox_Status.add(new SelectOptionVO(value: '40', label: '완료'));
    selectBox_Status.add(new SelectOptionVO(value: '50', label: '취소'));

    editData = new RequestPutModel();

    WidgetsBinding.instance.addPostFrameCallback((c) {
      setState(() {
        loadOperatorListData();
        loadData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 8.0),
              child: Row(
                children: [
                    Flexible(
                      flex: 3,
                      child: ISInput(
                        value: formData.SERVICE_GBN ?? '',
                        context: context,
                        readOnly: true,
                        label: '서비스 구분',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: ISSearchDropdown(
                        label: '상태',
                        value: formData.STATUS,
                        onChange: (value) {
                          setState(() {
                            formData.STATUS = value;
                          });
                        },
                        item: [
                          DropdownMenuItem(
                            value: '10',
                            child: Text('접수(요청)'),
                          ),
                          DropdownMenuItem(
                            value: '30',
                            child: Text('진행중(심사중)'),
                          ),
                          DropdownMenuItem(
                            value: '35',
                            child: Text('보완'),
                          ),
                          DropdownMenuItem(
                            value: '40',
                            child: Text('완료'),
                          ),
                          DropdownMenuItem(
                              value: '50',
                              child: Text(
                                '취소',
                                style: TextStyle(color: Colors.black54),
                              ),
                              enabled: false),
                        ].cast<DropdownMenuItem<String>>(),
                      ),
                    )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 8.0),
              child: Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: ISInput(
                        value: formData.SHOP_CD ?? '',
                        context: context,
                        readOnly: true,
                        label: '가맹점 코드',
                        keyboardType: TextInputType.number,
                        onChange: (v) {
                          formData.SHOP_CD = v.toString().replaceAll('-', '');
                        },
                    )
                  ),
                  Flexible(
                    flex: 3,
                    child: ISInput(
                        value: formData.SHOP_NAME ?? '',
                        context: context,
                        readOnly: true,
                        label: '가맹점명',
                        keyboardType: TextInputType.number,
                    )
                  ),
                  Flexible(
                    flex: 2,
                    child: ISSearchDropdown(
                      label: '작업자',
                      value: _alloc_ucode.toString(),
                      item: selectBox_operator.map((item) {
                        return new DropdownMenuItem<String>(
                            child: new Text(
                              item.label,
                              style: TextStyle(fontSize: 13, color: Colors.black),
                            ),
                            value: item.value);
                      }).toList(),
                      onChange: (v) {
                        selectBox_operator.forEach((element) {
                          if (v == element.value) {
                            if (element.value.toString() != 'null') {
                              formData.STATUS = '30';
                            }

                            _alloc_ucode = element.value;
                            _alloc_uname = element.label2;
                          }
                        });

                        setState(() {});
                      },
                    )
                  ),
                ],
              ),
            ),
            Divider(
              height: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 0, 5),
                  width: 850,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('현재 사업자 정보', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ),
                Card(
                  child: Row(
                    children: <Widget>[
                      ISInput(
                        value: _b_data,
                        context: context,
                        readOnly: true,
                        contentPadding: 20,
                        textStyle: TextStyle(fontSize: 12),
                        keyboardType: TextInputType.multiline,
                        maxLines: 7,
                        width: 574,
                        height: 150,
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 0, 5),
                  width: 850,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('변경 요청 사업자 정보', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ),
                Card(
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  width: 100,
                                  child: Text(
                                    '요청 이미지',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Visibility(
                                      visible: image_url == 'null' ? false : true,
                                      child: InkWell(
                                  child: Container(
                                      width: 30,
                                            child: Icon(
                                              Icons.pageview_outlined,
                                              size: 20,
                                              color: Colors.blue,
                                            )),
                                  onTap: () async {
                                          _launchInBrowser(image_url);
                                  },
                                ),
                                    ),
                                    Visibility(
                                      visible: image_url == 'null' ? false : true,
                                      child: InkWell(
                                        child: Container(
                                            child: Visibility(
                                                child: Icon(
                                          Icons.file_download,
                                          size: 16,
                                          color: Colors.blue,
                                        ))),
                                        onTap: () async {
                                          showConfirm(image_url.replaceAll('https://ceo.daeguro.co.kr/RequestServiceImage/', '/request-images/').toString());
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            InkWell(
                                child: SizedBox(
                                  width: 150,
                                  height: 150,
                              child: image_url == null
                                      ? Image.asset('assets/empty_menu.png')
                                      : Image.network(
                                      image_url.replaceAll('https://ceo.daeguro.co.kr/RequestServiceImage/', '/request-images/').toString(),
                                          gaplessPlayback: true,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Image.asset('assets/empty_menu.png');
                                          },
                                        ),
                            )),
                    ],
                  ),
                ),
                    ISInput(
                        value: _a_data,
                      context: context,
                      readOnly: true,
                      contentPadding: 20,
                      textStyle: TextStyle(fontSize: 12),
                      keyboardType: TextInputType.multiline,
                        maxLines: 7,
                      width: 404,
                        height: 150,
                      ),
                    ],
                  ),
                    ),
                    ISInput(
                      value: formData.ANSWER_TEXT,
                      context: context,
                      label: '답변',
                      keyboardType: TextInputType.multiline,
                  onChange: (v) {
                        formData.ANSWER_TEXT = v;
                      },
                    ),
                  ],
            ),
        ],
      ),
    );

    ButtonBar buttonBar = ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        ISButton(
          label: '저장',
          iconData: Icons.cancel,
          onPressed: () async {
            FormState form = formKey.currentState;
            if (!form.validate()) {
              return;
            }

            if (formData.STATUS == '10') {
              ISAlert(context, '접수상태일때는 저장 할 수 없습니다.');
              return;
            }

            if (_alloc_ucode == 'null') {
              ISAlert(context, '작업자를 선택 해주십시오.');
              return;
            }

            form.save();

            if (formData.ANSWER_TEXT.toString() == 'null') {
              formData.ANSWER_TEXT = '';
            }

            editData.seq = widget.seq;
            editData.status = formData.STATUS;
            editData.alloc_ucode = _alloc_ucode;
            editData.alloc_uname = _alloc_uname;
            editData.answer = formData.ANSWER_TEXT;
            editData.mod_ucode = GetStorage().read('logininfo')['uCode'];
            editData.mod_name = GetStorage().read('logininfo')['name'];

            RequestController.to.putServiceRequest(editData.toJson(), context);

            Navigator.pop(context, true);
          },
        ),
        ISButton(
          label: '닫기',
          iconData: Icons.cancel,
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );

    // var result = Scaffold(
    //   appBar: AppBar(
    //     title: Text('가맹점 매장정보 수정'),
    //   ),
    //   body: SingleChildScrollView(
    //     child: Column(
    //       children: [
    //         SizedBox(height: 10),
    //         form,
    //       ],
    //     ),
    //   ),
    //   bottomNavigationBar: buttonBar,
    // );

    return SizedBox(
      width: 600,
      height: 800,
      child: Scaffold(
        appBar: AppBar(
          title: Text('요청 관리 상세'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10,),
              Container(padding: EdgeInsets.symmetric(horizontal: 8.0), child: form),
            ],
          ),
        ),
        bottomNavigationBar: current_tabIdx == 0 ? buttonBar : null,
      ),
    );
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false, //true로 설정시, iOS 인앱 브라우저를 통해픈
        forceWebView: false, //true로 설정시, Android 인앱 브라우저를 통해 오픈
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Web Request Fail $url';
    }
  }

  Future _deleteImageFromCache() async {
    //await CachedNetworkImage.evictFromCache(url);

    PaintingBinding.instance.imageCache.clearLiveImages();
    PaintingBinding.instance.imageCache.clear();

    //await DefaultCacheManager().removeFile(key);
    //await DefaultCacheManager().emptyCache();
    setState(() {});
  }
}
