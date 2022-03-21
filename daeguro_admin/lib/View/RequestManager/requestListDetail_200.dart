@JS()
library javascript_bundler;

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

class RestListDetail_200 extends StatefulWidget {
  final String seq;

  //final ShopInfo sData;
  const RestListDetail_200({Key key, this.seq}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RestListDetail_200State();
  }
}

class RestListDetail_200State extends State<RestListDetail_200> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ServiceRequestDetail formData = ServiceRequestDetail();
  RequestPutModel editData;

  String a_roadAdd = '';
  String a_jibun = '';
  String a_detail_address = '';
  String a_lat = '';
  String a_lon = '';
  String a_SIDO = '';
  String a_SIGUGUN = '';
  String a_DONGMYUN = '';
  String a_ROAD_NAME = '';
  String a_BUILDING_NUMBER = '';
  String a_LAND_NUMBER = '';
  String a_POSTAL_CODE = '';

  String b_roadAdd = '';
  String b_jibun = '';
  String b_detail_address = '';


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

        a_roadAdd = _tojson['a_roadAdd'];
        a_jibun = _tojson['a_jibun'];
        a_detail_address = _tojson['a_detail_address'];
        a_lat = _tojson['a_lat'];
        a_lon = _tojson['a_lon'];
        a_SIDO = _tojson['a_SIDO'];
        a_SIGUGUN = _tojson['a_SIGUGUN'];
        a_DONGMYUN = _tojson['a_DONGMYUN'];
        a_ROAD_NAME = _tojson['a_ROAD_NAME'];
        a_BUILDING_NUMBER = _tojson['a_BUILDING_NUMBER'];
        a_LAND_NUMBER = _tojson['a_LAND_NUMBER'];
        a_POSTAL_CODE = _tojson['a_POSTAL_CODE'];
        b_roadAdd = _tojson['b_roadAdd'];
        b_jibun = _tojson['b_jibun'];
        b_detail_address = _tojson['b_detail_address'];

       formData.SERVICE_DATA = '주소 : ' + a_roadAdd;
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
                        DropdownMenuItem(value: '10', child: Text('접수(요청)'),),
                        DropdownMenuItem(value: '30', child: Text('진행중(심사중)'),),
                        DropdownMenuItem(value: '35', child: Text('보완'),),
                        DropdownMenuItem(value: '40', child: Text('완료'),),
                        DropdownMenuItem(value: '50', child: Text('취소', style: TextStyle(color: Colors.black54),), enabled: false),
                      ].cast<DropdownMenuItem<String>>(),
                    ),
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
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 0, 5),
            width: 850,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('현재 주소 정보', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
          ),
          ISInput(
            value: b_jibun.toString(),
            context: context,
            readOnly: true,
            label: '지번 주소',
            contentPadding: 20,
            keyboardType: TextInputType.multiline,
            maxLines: 6,
          ),
          ISInput(
            value: b_roadAdd.toString(),
            context: context,
            readOnly: true,
            label: '도로명 주소',
            contentPadding: 20,
            keyboardType: TextInputType.multiline,
            maxLines: 6,
          ),
          ISInput(
            value: b_detail_address.toString(),
            context: context,
            readOnly: true,
            label: '상세 주소',
            contentPadding: 20,
            keyboardType: TextInputType.multiline,
            maxLines: 6,
          ),
          Divider(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 0, 5),
            width: 850,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('변경 요청 주소', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
          ),
          ISInput(
            value: a_jibun.toString(),
            context: context,
            readOnly: true,
            label: '지번 주소',
            contentPadding: 20,
            keyboardType: TextInputType.multiline,
            maxLines: 6,
          ),
          ISInput(
            value: a_roadAdd.toString(),
            context: context,
            readOnly: true,
            label: '도로명 주소',
            contentPadding: 20,
            keyboardType: TextInputType.multiline,
            maxLines: 6,
          ),
          ISInput(
            value: a_detail_address.toString(),
            context: context,
            readOnly: true,
            label: '상세 주소',
            contentPadding: 20,
            keyboardType: TextInputType.multiline,
            maxLines: 6,
          ),
          Divider(
            height: 20,
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
      height: 850,
      child: result,
    );
  }
}
