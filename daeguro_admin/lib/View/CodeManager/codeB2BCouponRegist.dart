


import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/Model/codeListModel.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/CodeManager/code_controller.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';



class CodeB2BCouponRegist extends StatefulWidget {
  const CodeB2BCouponRegist({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CodeB2BCouponRegistState();
  }
}

class CodeB2BCouponRegistState extends State<CodeB2BCouponRegist> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  codeListModel formData;

  List<SelectOptionVO> selectBox_qrGbn = [
    new SelectOptionVO(value: 'Y', label: '사용'),
    new SelectOptionVO(value: 'N', label: '미사용'),
  ];

  List<SelectOptionVO> selectBox_useGbn = [
    new SelectOptionVO(value: 'Y', label: '사용'),
    new SelectOptionVO(value: 'N', label: '미사용'),
  ];

  List<SelectOptionVO> selectBox_Gbn4 = [
    new SelectOptionVO(value: '1', label: '실시간'),
    new SelectOptionVO(value: '3', label: '일마감'),
  ];

  List<SelectOptionVO> selectBox_Gbn7 = [
    new SelectOptionVO(value: 'Y', label: '예'),
    new SelectOptionVO(value: 'N', label: '아니오'),
  ];

  @override
  void initState() {
    super.initState();

    Get.put(CodeController());

    formData = codeListModel();
    formData.CODE_GRP = 'B2BCOUPON_TYPE';
    formData.USE_GBN = 'N';
    formData.ETC_CODE2 = 'Y';
    formData.ETC_CODE_GBN4 = '1';
    formData.ETC_CODE_GBN7 = 'N';
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
                    readOnly: true,
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
                    autofocus: true,
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
                    label: '쿠폰금액',
                    validator: (v) {
                      return v.isEmpty ? '금액을 입력해주세요' : null;
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
              // Flexible(
              //   flex: 1,
              //   child: Container(
              //     padding: EdgeInsets.only(right: 8),
              //     child: ISSearchSelectDate(
              //       context,
              //       label: '사용종료일',
              //       value: Utils.getYearMonthDayFormat(formData.ETC_CODE1),
              //       onTap: () async {
              //         DateTime valueDt;
              //         if(formData.ETC_CODE1 == null)
              //         {
              //           valueDt = DateTime.now();
              //         } else {
              //           valueDt = DateTime.parse(formData.ETC_CODE1);
              //         }
              //
              //         final DateTime picked = await showDatePicker(
              //           context: context,
              //           initialDate: valueDt,
              //           firstDate: DateTime(1900, 1),
              //           lastDate: DateTime(2031, 12),
              //         );
              //
              //         setState(() {
              //           if (picked != null) {
              //             formData.ETC_CODE1 = formatDate(picked, [yyyy, '-', mm, '-', dd]);
              //           }
              //         });
              //       },
              //     ),
              //   ),
              // ),
              Flexible(
                flex: 1,
                child: ISSelect(
                  label: 'QR 사용',
                  value: formData.ETC_CODE2,
                  onChange: (value) {
                    setState(() {
                      formData.ETC_CODE2 = value;
                      //loadData();
                    });
                  },
                  dataList: selectBox_qrGbn,
                ),
              ),
            ],
          ),
          Container(
            child: ISInput(
              autofocus: true,
              value: formData.ETC_CODE_GBN5,
              label: '쿠폰발행 메시지(@1:만료일)',
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
              label: '쿠폰 만료 안내 메시지(@1:남은시간)',
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
              value: formData.ETC_CODE_GBN8,
              textStyle: TextStyle(fontSize: 12),
              maxLines: 8,
              height: 120,
              keyboardType: TextInputType.multiline,
              label: '유의사항',
              // validator: (v) {
              //   return v.isEmpty ? '수량을 입력해주세요' : null;
              // },
              onSaved: (v) {
                formData.ETC_CODE_GBN8 = v;
              },
            ),
          ),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: Container(
                    child: ISSelect(
                      value: formData.ETC_CODE_GBN4,
                      label: '발급기준(실시간/일마감)',
                      onChange: (value) {
                        setState(() {
                          formData.ETC_CODE_GBN4 = value;
                          //loadData();
                        });
                      },
                      dataList: selectBox_Gbn4,
                    )
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  child: ISSelect(
                    value: formData.ETC_CODE_GBN7,
                    label: '중복사용',
                    onChange: (value) {
                      setState(() {
                        formData.ETC_CODE_GBN7 = value;
                        //loadData();
                      });
                    },
                    dataList: selectBox_Gbn7,
                  ),
                ),
              )
            ],
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

            if (formData.ETC_CODE1 == null || formData.ETC_CODE1 == ''){
              ISAlert(context, '시작일을 확인해주세요.');
              return;
            }

            CodeController.to.postListData(context, formData.CODE_GRP, formData.CODE, formData.CODE_NM, formData.MEMO, formData.ETC_CODE1.replaceAll('-', ''), formData.USE_GBN, formData.ETC_CODE2,
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
        title: Text('제휴 쿠폰 코드 등록'),
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
      height: 770,
      child: result,
    );
  }
}
