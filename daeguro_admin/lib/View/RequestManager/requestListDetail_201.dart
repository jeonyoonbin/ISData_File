@JS()
library javascript_bundler;

import 'dart:async';
import 'dart:convert';

import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/Model/requestPutModel.dart';
import 'package:daeguro_admin_app/Model/serviceRequestDetail.dart';
import 'package:daeguro_admin_app/Model/user/user_code_name.dart';
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

class RestListDetail_201 extends StatefulWidget {
  final String seq;

  //final ShopInfo sData;
  const RestListDetail_201({Key key, this.seq}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RestListDetail_201State();
  }
}

class RestListDetail_201State extends State<RestListDetail_201> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ServiceRequestDetail formData = ServiceRequestDetail();
  RequestPutModel editData;

  String RepImagePath;

  String _a_item_cd = '';
  String _a_item_cd2 = '';
  String _a_item_cd3 = '';

  String _b_item_cd = '';
  String _b_item_cd2 = '';
  String _b_item_cd3 = '';

  List<String> shopImageList = [];
  List<String> shopImageDownList = [];
  List<String> shopImageViewList = [];
  List<bool> _shopimgGbn = [];
  int errorcnt = 0;

  List<SelectOptionVO> selectBox_DivCode = [];

  int current_tabIdx = 0;

  List<SelectOptionVO> selectBox_operator = [];

  String _alloc_ucode;
  String _alloc_uname;

  loadOperatorListData() async {
    selectBox_operator.clear();

    await UserController.to.getUserCodeName('2', '6').then((value) {
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
    await RequestController.to.getDetailData(widget.seq).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        formData = ServiceRequestDetail.fromJson(value);

        _alloc_ucode = formData.ALLOC_UCODE.toString();
        _alloc_uname = formData.ALLOC_UNAME;

        Map<String, dynamic> _tojson = jsonDecode(formData.SERVICE_DATA);

        _a_item_cd = _tojson['a_item_cd'];
        _a_item_cd2 = _tojson['a_item_cd2'];
        _a_item_cd3 = _tojson['a_item_cd3'];

        _b_item_cd = _tojson['b_item_cd'];
        _b_item_cd2 = _tojson['b_item_cd2'];
        _b_item_cd3 = _tojson['b_item_cd3'];

        formData.SERVICE_DATA = '[업종1] \n ' +
            setItemCd(_b_item_cd) +
            '  →  ' +
            setItemCd(_a_item_cd) +
            '\n[업종2] \n ' +
            setItemCd(_b_item_cd2) +
            '  →  ' +
            setItemCd(_a_item_cd2) +
            '\n[업종3] \n ' +
            setItemCd(_b_item_cd3) +
            '  →  ' +
            setItemCd(_a_item_cd3);
      }
    });

    //if (this.mounted) {
      setState(() {

      });
    //}
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
                  )
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
                            child: Text('취소', style: TextStyle(color: Colors.black54),),
                            enabled: false
                        ),
                      ].cast<DropdownMenuItem<String>>(),
                    )
                ),
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
          ISInput(
            value: formData.SERVICE_DATA.toString(),
            height: 150,
            context: context,
            readOnly: true,
            label: '요청 내용',
            contentPadding: 20,
            keyboardType: TextInputType.multiline,
            maxLines: 6,
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

            if(formData.STATUS == '10'){
              ISAlert(context, '접수상태일때는 저장 할 수 없습니다.');
              return;
            }

            if(_alloc_ucode == 'null'){
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

    var result = Scaffold(
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
    );
    return SizedBox(
      width: 560,
      height: 530,
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
    //await CachedNetworkImage.evictFrromCache(url);

    PaintingBinding.instance.imageCache.clearLiveImages();
    PaintingBinding.instance.imageCache.clear();

    //await DefaultCacheManager().removeFile(key);
    //await DefaultCacheManager().emptyCache();
    setState(() {});
  }

  setItemCd(String itemCd) {
    switch (itemCd) {
      case '1013':
        return '돈까스/일식';
      case '1014':
        return '아시안/양식';
      case '9000':
        return '기타';
      case '1001':
        return '치킨/찜닭';
      case '1003':
        return '피자';
      case '1004':
        return '중식';
      case '1005':
        return '분식';
      case '1006':
        return '족발/보쌈';
      case '1007':
        return '야식';
      case '1008':
        return '한식';
      case '1024':
        return '패스트푸드';
      case '1025':
        return '도시락/죽';
      case '1026':
        return '카페/디저트';
      case '1000':
        return '1인분';
      case '1027':
        return '반찬';
      case '1028':
        return '찜/탕';
      case '1029':
        return '정육';
      case '1030':
        return '펫';
    }
    return '';
  }
}
