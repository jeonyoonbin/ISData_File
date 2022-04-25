import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/Model/mappingDModel.dart';
import 'package:daeguro_admin_app/View/ApiCompanyManager/apiCompany_controller.dart';
import 'package:daeguro_admin_app/View/MappingManager/mapping_controller.dart';
import 'package:daeguro_admin_app/View/MappingManager/searchShopList.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MappingRegist extends StatefulWidget {
  const MappingRegist({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MappingRegistState();
  }
}

class MappingRegistState extends State<MappingRegist> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  MappingDModel formData = MappingDModel();
  List<SelectOptionVO> selectBox_com = List();
  List<SelectOptionVO> selectBox_apiType = List();

  _query() async {
    selectBox_com.clear();

    await ApiCompanyController.to.getData(formData.apiType, '').then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        value.forEach((element) {
          selectBox_com.add(new SelectOptionVO(
              value: element['companyGbn'], label: element['companyName']));
        });
      }
    });


    setState(() {});
  }

  _searchShop() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Container(width: 500, height: 670, child: SearchShopList(popWidth: 500, popHeight: 670)),
      ),
    ).then((v) async {
      if (v != null) {
        formData.shopCd = v[0];
        formData.shopName = v[1];
        formData.ccCode = v[2];

        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();

    Get.put(ApiCompanyController());

    selectBox_apiType.clear();

    selectBox_apiType.add(new SelectOptionVO(value: '1', label: '주문'));
    selectBox_apiType.add(new SelectOptionVO(value: '3', label: 'POS(배달)'));

    formData.apiUseYn = 'Y';
    formData.apiType = '3';
    formData.apiComGbn = 'ISPOS';
    _query();
  }

  @override
  void dispose() {
    selectBox_com.clear();
    selectBox_apiType.clear();

    formData = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(8.0),
            decoration: new BoxDecoration(
                color: formData.apiUseYn == 'Y' ? Colors.blue[200] : Colors.red[200],
                borderRadius: new BorderRadius.circular(6)),
            child: SwitchListTile(
              dense: true,
              value: formData.apiUseYn == 'Y' ? true : false,
              title: Text('사용 여부', style: TextStyle(fontSize: 12, color: Colors.white),),
              onChanged: (v) {
                setState(() {
                  formData.apiUseYn = v ? 'Y' : 'N';
                  formKey.currentState.save();
                });
              },
            ),
          ),
          Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: ISSelect(
                  label: '업체타입',
                  value: formData.apiType,
                  dataList: selectBox_apiType,
                  onChange: (value) {
                    setState(() {
                      formData.apiType = value;
                      formData.apiComGbn = '';
                      _query();
                    });
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: ISSelect(
                    label: '업체명',
                    value: formData.apiComGbn.toString(),
                    dataList: selectBox_com,
                    onChange: (v) {
                      formData.apiComGbn = v;
                    }
                    ),
              ),

            ],
          ),
          Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: ISInput(
                  value: formData.shopCd ?? '',
                  readOnly: true,
                  context: context,
                  label: '가맹점번호',
                  validator: (v) {
                    return v.isEmpty ? '[필수] 가맹점번호' : null;
                  },
                  textStyle: TextStyle(fontSize: 12),
                  onChange: (v) {
                    formData.shopCd = v;
                  },
                ),
              ),
              Flexible(
                flex: 3,
                child: ISInput(
                  value: formData.shopName ?? '',
                  readOnly: true,
                  context: context,
                  label: '가맹점명',
                  validator: (v) {
                    return v.isEmpty ? '[필수] 가맹점명' : null;
                  },
                  textStyle: TextStyle(fontSize: 12),
                  onChange: (v) {
                    formData.shopName = v;
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: ISButton(
                  height: 40,
                  textStyle: TextStyle(fontSize: 13, color: Colors.white),
                  label: '가맹점 검색',
                  onPressed: () {
                    _searchShop();
                  },
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: ISInput(
                  value: formData.apiComCode ?? '',
                  autofocus: true,
                  context: context,
                  label: '연동사 상점코드1',
                  textStyle: TextStyle(fontSize: 12),
                  onChange: (v) {
                    formData.apiComCode = v;
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: ISInput(
                  value: formData.apiComCode2 ?? '',
                  context: context,
                  label: '연동사 상점코드2',
                  textStyle: TextStyle(fontSize: 12),
                  onChange: (v) {
                    formData.apiComCode2 = v;
                  },
                ),
              ),
            ],
          ),

          ISInput(
            value: formData.apiComToken ?? '',
            context: context,
            label: '토큰',
            textStyle: TextStyle(fontSize: 12),
            onChange: (v) {
              formData.apiComToken = v;
            },
          ),
          ISInput(
            value: formData.apiComAuth ?? '',
            context: context,
            label: '인증키',
            textStyle: TextStyle(fontSize: 12),
            onChange: (v) {
              formData.apiComAuth = v;
            },
          ),
          Row(
            children: <Widget>[
              Flexible(
                flex: 2,
                child: ISInput(
                  value: formData.apiComId ?? '',
                  context: context,
                  label: '연동사 상점 아이디',
                  textStyle: TextStyle(fontSize: 12),
                  onChange: (v) {
                    formData.apiComId = v;
                  },
                ),
              ),
              Flexible(
                flex: 3,
                child: ISInput(
                  value: formData.apiComPass ?? '',
                  context: context,
                  label: '연동사 상점 비밀번호',
                  textStyle: TextStyle(fontSize: 12),
                  onChange: (v) {
                    formData.apiComPass = v;
                  },
                ),
              ),
            ],
          ),

          ISInput(
            value: formData.apiMemo ?? '',
            context: context,
            label: '메모',
            maxLines: 8,
            height: 100,
            keyboardType: TextInputType.multiline,
            textStyle: TextStyle(fontSize: 12),
            onChange: (v) {
              formData.apiMemo = v;
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
          iconData: Icons.save,
          onPressed: () async {
            if(formData.apiComGbn == '')
            {
              ISAlert(context, '업체명을 선택 해 주십시오.');
              return;
            }

            FormState form = formKey.currentState;
            if (!form.validate()) {
              return;
            }

            form.save();

            formData.userCode = GetStorage().read('logininfo')['uCode'];
            formData.userName = GetStorage().read('logininfo')['name'];

            MappingController.to.postData(formData.toJson(), context);

            Navigator.pop(context, true);
          },
        ),
        ISButton(
          label: '취소',
          iconData: Icons.cancel,
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );

    var result = Scaffold(
      appBar: AppBar(
        title: Text('POS 업체 연동 추가'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
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
      width: 500,
      height: 600,
      child: result,
    );
  }
}
