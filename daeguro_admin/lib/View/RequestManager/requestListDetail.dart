@JS()
library javascript_bundler;

import 'dart:async';
import 'dart:convert';

import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/Model/serviceRequestDetail.dart';
import 'package:daeguro_admin_app/Model/shop/shopImageHistory.dart';
import 'package:daeguro_admin_app/View/RequestManager/requestManager_controller.dart';
import 'package:js/js.dart';

import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:url_launcher/url_launcher.dart';

@JS('downloadImg')
external void showConfirm(var _uri);

class RestListDetail extends StatefulWidget {
  final String seq;

  //final ShopInfo sData;
  const RestListDetail({Key key, this.seq}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RestListDetailState();
  }
}

class RestListDetailState extends State<RestListDetail> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ServiceRequestDetail formData = ServiceRequestDetail();
  String RepImagePath;

  String _reg_no = '';
  String _ceo_name = '';
  String _image_url = '';
  String _test = '';

  List<String> shopImageList = [];
  List<String> shopImageDownList = [];
  List<String> shopImageViewList = [];
  List<bool> _shopimgGbn = [];
  int errorcnt = 0;

  List<SelectOptionVO> selectBox_DivCode = [];

  final List<ShopImageHistoryModel> imageHistoryList = <ShopImageHistoryModel>[];

  int current_tabIdx = 0;

  loadData() async {
    await RequestController.to.getDetailData(widget.seq, context);

    if (this.mounted) {
      setState(() {
        formData = ServiceRequestDetail.fromJson(RequestController.to.qDataDetail);

        Map<String, dynamic> _tojson = jsonDecode(formData.SERVICE_DATA);

        _reg_no = _tojson['reg_no'];
        _ceo_name = _tojson['ceo_name'];
        _image_url = _tojson['image_url'];
        _test = _tojson['test'];

        formData.SERVICE_DATA = '사업자번호 : ' + _reg_no + '\n대표자명 : ' + _ceo_name + '\n이미지 주소 : ' + _image_url + '\ntest : ' + _test;
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

    WidgetsBinding.instance.addPostFrameCallback((c) {
      setState(() {
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
          ISInput(
            value: formData.SERVICE_GBN ?? '',
            context: context,
            readOnly: true,
            width: 220,
            label: '서비스 구분',
            keyboardType: TextInputType.number,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
            child: ISSearchDropdown(
              label: '상태',
              width: 220,
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
                  child: Text('취소'),
                ),
              ].cast<DropdownMenuItem<String>>(),
            ),
          ),
          ISInput(
            value: formData.SHOP_CD ?? '',
            context: context,
            readOnly: true,
            width: 220,
            label: '가맹점 코드',
            keyboardType: TextInputType.number,
            onChange: (v) {
              formData.SHOP_CD = v.toString().replaceAll('-', '');
            },
          ),
          ISInput(
            value: formData.SHOP_NAME ?? '',
            context: context,
            readOnly: true,
            width: 220,
            label: '가맹점명',
            keyboardType: TextInputType.number,
          ),
          ISSelect(
            label: '작업자',
            value: formData.ALLOC_UNAME,
            width: 186,
            // LabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            // DropdownStyle: TextStyle(fontSize: 14),
            dataList: selectBox_DivCode,
            onChange: (v) {
              formData.ALLOC_UNAME = v;
              //loadGunguData(v);
            },
            onSaved: (v) {
              //formData.cLevel = v;
            },
          ),
          Divider(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
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
                              InkWell(
                                child: Container(
                                  width: 30,
                                    child: Icon(
                                  Icons.pageview_outlined,
                                  size: 20,
                                  color: Colors.blue,
                                )),
                                onTap: () async {
                                  _launchInBrowser(_image_url);
                                },
                              ),
                              // InkWell(
                              //   child: Container(
                              //     child: Icon(
                              //       Icons.file_download,
                              //       size: 20,
                              //       color: Colors.blue,
                              //     ),
                              //   ),
                              //   onTap: () async {
                              //     showConfirm(_image_url);
                              //   },
                              // ),
                            ],
                          ),
                          SizedBox(height: 5),
                          InkWell(
                              child: SizedBox(
                            width: 150,
                            height: 150,
                            child: _image_url == null
                                ? Image.asset('assets/empty_menu.png')
                                : Image.network(
                                    _image_url,
                                    gaplessPlayback: true,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset('assets/empty_menu.png');
                                    },
                                  ),
                          )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Divider(
            height: 20,
          ),
          ISInput(
            value: formData.SERVICE_DATA.toString(),
            context: context,
            readOnly: true,
            label: '내용',
            contentPadding: 20,
            keyboardType: TextInputType.multiline,
            maxLines: 5,
          ),
          ISInput(
            value: formData.ANSWER_TEXT,
            context: context,
            label: '답변',
            keyboardType: TextInputType.multiline,
            onSaved: (v) {
              formData.ANSWER_TEXT = v;
            },
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

    var result = Scaffold(
      appBar: AppBar(
        title: Text('요청 관리 상세'),
      ),
      body: form,
      bottomNavigationBar: current_tabIdx == 0 ? buttonBar : null,
    );
    return SizedBox(
      width: 560,
      height: 900,
      child: result,
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
