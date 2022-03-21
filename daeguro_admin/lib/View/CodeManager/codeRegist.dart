


import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/Model/codeListModel.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/View/CodeManager/code_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';



class CodeRegist extends StatefulWidget {
  const CodeRegist({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CodeRegistState();
  }
}

class CodeRegistState extends State<CodeRegist> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  codeListModel formData;

  List<SelectOptionVO> selectBox_useGbn = [
    new SelectOptionVO(value: 'Y', label: '사용'),
    new SelectOptionVO(value: 'N', label: '미사용'),
  ];

  @override
  void initState() {
    super.initState();

    Get.put(CodeController());

    //items = CouponController.to.qDataItems;
    // CouponController.to.qDataItems.forEach((element) {
    //   selectBox_couponType.add(new SelectOptionVO(
    //       value: element['code'], label: element['codeName']));
    // });

    formData = codeListModel();
    formData.USE_GBN = 'N';

    // formData.couponType = 'IS_C100';
    // formData.startDate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    // _startDate = formatDate(DateTime.now(), [yyyy, '', mm, '', dd]);
    // formData.insertUcode = GetStorage().read('logininfo')['uCode'];
    // formData.insertName = GetStorage().read('logininfo')['name'];
  }

  @override
  void dispose() {
    selectBox_useGbn.clear();
    selectBox_useGbn = null;

    formData = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                  flex: 1,
                  child: ISInput(
                    autofocus: true,
                    label: '코드그룹',
                    value: formData.CODE_GRP,
                    validator: (v) {
                      return v.isEmpty ? '코드그룹을 입력해주세요' : null;
                    },
                    onChange: (v) {
                      formData.CODE_GRP = v;
                    },
                  )
              ),
              Flexible(
                flex: 1,
                child: ISSelect(
                  label: '사용구분',
                  value: formData.USE_GBN,
                  onChange: (value) {
                    setState(() {
                      formData.USE_GBN = value;
                      //loadData();
                    });
                  },
                  dataList: selectBox_useGbn,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                  flex: 1,
                  child: ISInput(
                    value: formData.CODE,
                    label: '코드',
                    validator: (v) {
                      return v.isEmpty ? '코드를 입력해주세요' : null;
                    },
                    onChange: (v) {
                      formData.CODE = v;
                    },
                  )
              ),
              Flexible(
                  flex: 1,
                  child: ISInput(
                    value: formData.CODE_NM,
                    label: '코드명',
                    validator: (v) {
                      return v.isEmpty ? '코드명을 입력해주세요' : null;
                    },
                    onChange: (v) {
                      formData.CODE_NM = v;
                    },
                  )
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                  flex: 1,
                  child: ISInput(
                    value: formData.ETC_AMT1.toString(),
                    label: '설정금액1(요율)',
                    validator: (v) {
                      return v.isEmpty ? '수량을 입력해주세요' : null;
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                    ],
                    onChange: (v) {
                      formData.ETC_AMT1 = double.parse(v);
                    },
                  )
              ),
              Flexible(
                  flex: 1,
                  child: ISInput(
                    value: formData.ETC_AMT2.toString(),
                    label: '설정금액2',
                    validator: (v) {
                      return v.isEmpty ? '수량을 입력해주세요' : null;
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                    ],
                    onChange: (v) {
                      formData.ETC_AMT2 = double.parse(v);
                    },
                  )
              ),
              Flexible(
                  flex: 1,
                  child: ISInput(
                    value: formData.ETC_AMT3.toString(),
                    label: '설정금액3(사용한도)',
                    validator: (v) {
                      return v.isEmpty ? '수량을 입력해주세요' : null;
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                    ],
                    onChange: (v) {
                      formData.ETC_AMT3 = double.parse(v);
                    },
                  )
              ),
            ],
          ),
          Container(
            child: ISInput(
              autofocus: true,
              value: formData.ETC_CODE_GBN4,
              label: '설정값1',
              // validator: (v) {
              //   return v.isEmpty ? '수량을 입력해주세요' : null;
              // },
              onChange: (v) {
                formData.ETC_CODE_GBN4 = v;
              },
            )
          ),
          Container(
            child: ISInput(
              autofocus: true,
              value: formData.ETC_CODE_GBN5,
              label: '설정값2',
              textStyle: TextStyle(fontSize: 12),
              maxLines: 8,
              height: 80,
              keyboardType: TextInputType.multiline,
              // validator: (v) {
              //   return v.isEmpty ? '수량을 입력해주세요' : null;
              // },
              onChange: (v) {
                formData.ETC_CODE_GBN5 = v;
              },
            ),
          ),
          Container(
            child: ISInput(
              autofocus: true,
              value: formData.ETC_CODE_GBN6,
              label: '설정값3',
              textStyle: TextStyle(fontSize: 12),
              maxLines: 8,
              height: 80,
              keyboardType: TextInputType.multiline,
              // validator: (v) {
              //   return v.isEmpty ? '수량을 입력해주세요' : null;
              // },
              onChange: (v) {
                formData.ETC_CODE_GBN6 = v;
              },
            ),
          ),
          Container(
            child: ISInput(
              autofocus: true,
              value: formData.MEMO,
              label: '메모',
              textStyle: TextStyle(fontSize: 12),
              maxLines: 8,
              height: 80,
              keyboardType: TextInputType.multiline,
              // validator: (v) {
              //   return v.isEmpty ? '수량을 입력해주세요' : null;
              // },
              onChange: (v) {
                formData.MEMO = v;
              },
            ),
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
          onPressed: () {
            FormState form = formKey.currentState;
            if (!form.validate()) {
              return;
            }

            form.save();

            CodeController.to.postListData(context, formData.CODE_GRP, formData.CODE, formData.CODE_NM, formData.MEMO, '', formData.USE_GBN, formData.ETC_CODE2,
                formData.ETC_AMT1.toString(), formData.ETC_AMT2.toString(), formData.ETC_AMT3.toString(), formData.ETC_AMT4.toString(),
                formData.ETC_CODE_GBN1, formData.ETC_CODE_GBN3, formData.ETC_CODE_GBN4, formData.ETC_CODE_GBN5, formData.ETC_CODE_GBN6, formData.ETC_CODE_GBN7, formData.ETC_CODE_GBN8);

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
        title: Text('코드 등록'),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: form
          ),
        ],
      ),
      bottomNavigationBar: buttonBar,
    );
    return SizedBox(
      width: 430,
      height: 630,
      child: result,
    );
  }
}
