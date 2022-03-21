


import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/ISWidget/is_select_date.dart';
import 'package:daeguro_admin_app/Model/coupon/couponBrandAppListModel.dart';
import 'package:daeguro_admin_app/Model/coupon/couponBrandCodeList.dart';
import 'package:daeguro_admin_app/Model/coupon/couponTypeList.dart';
import 'package:daeguro_admin_app/Util/multi_masked_formatter.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/CouponManager/coupon_controller.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';



class BrandCouponAppRegist  extends StatefulWidget {
  const BrandCouponAppRegist({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BrandCouponAppRegistState();
  }
}

class BrandCouponAppRegistState extends State<BrandCouponAppRegist > {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  couponBrandAppListModel formData;
  String _chainCode = ' ';
  String _couponType = ' ';
  String _couponCnt;

  //List<SelectOptionVO> selectBox_couponType = List();

  List<SelectOptionVO> BrandNameItems = [];
  List<SelectOptionVO> BrandCouponTypeItems = [];

  // loadTypeData() async {
  //   await CouponController.to.getDataB2BCodeItems(context);
  //
  //   //print('codeList:${CouponController.to.qB2BDataItems.toString()}');
  //
  //   //codeItems = CouponController.to.qB2BDataItems;
  //   CouponController.to.qB2BDataItems.forEach((element) {
  //     selectBox_couponType.add(new SelectOptionVO(value: element['code'], label: element['codeName']));
  //   });
  //
  //   setState(() {});
  // }

  loadBrandListData() async {
    BrandNameItems.clear();

    await CouponController.to.getBrandListItems().then((value) {
      BrandNameItems.add(new SelectOptionVO(value: ' ', label: '', label2: '',));

      value.forEach((element) {
        CouponBrandCodeListModel tempData = CouponBrandCodeListModel.fromJson(element);

        //ChainListItems.add(new SelectOptionVO(value: tempData.CODE, label: '[' + tempData.CODE + '] ' + tempData.CODE_NM, label2: tempData.CODE_NM,));
        BrandNameItems.add(new SelectOptionVO(value: tempData.CODE, label: tempData.CODE_NM, label2: tempData.CODE_NM,));
      });

      setState(() {
      });
    });
  }

  loadBrandCouponListData(String _chainCode) async {
    BrandCouponTypeItems.clear();

    await CouponController.to.getBrandCouponListItems(_chainCode).then((value) {
      BrandCouponTypeItems.add(new SelectOptionVO(value: ' ', label: '', label2: '',));

      value.forEach((element) {
        CouponTypeListModel tempData = CouponTypeListModel.fromJson(element);

        //ChainCouponListItems.add(new SelectOptionVO(value: tempData.CODE, label: '[' + tempData.CODE + '] ' + tempData.CODE_NM, label2: tempData.CODE_NM,));
        //BrandCouponTypeItems.add(new SelectOptionVO(value: tempData.CODE, label: tempData.CODE_NM, label2: tempData.CODE_NM,));
        BrandCouponTypeItems.add(new SelectOptionVO(value: tempData.CODE, label: '[${tempData.CODE}] '+ tempData.CODE_NM, label2: '[${tempData.CODE}] '+ tempData.CODE_NM));
      });

      setState(() {
      });
    });
  }

  @override
  void initState() {
    super.initState();

    Get.put(CouponController());

    formData = couponBrandAppListModel();

    formData.USE_YN = 'Y';
    formData.DELIVERY_YN = 'Y';
    formData.PACK_YN = 'Y';

    formData.COUPON_TYPE = '';
    formData.ORDER_MIN_AMT = '0';
    formData.PAY_MIN_AMT = '0';

    // _startDate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    // _endDate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    formData.DISPLAY_ST_DATE = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    formData.DISPLAY_EXP_DATE = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);

    formData.INS_UCODE = GetStorage().read('logininfo')['uCode'];
    formData.INS_NAME = GetStorage().read('logininfo')['name'];

    WidgetsBinding.instance.addPostFrameCallback((c) {
      loadBrandListData();
      loadBrandCouponListData('');
    });
  }

  @override
  void dispose() {

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
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: new BoxDecoration(
                      color: formData.USE_YN == 'Y' ? Colors.blue[200] : Colors.red[200],
                      borderRadius: new BorderRadius.circular(6)),
                  child: SwitchListTile(
                    dense: true,
                    value: formData.USE_YN == 'Y' ? true : false,
                    title: Text('사용여부', style: TextStyle(fontSize: 12, color: Colors.white),),
                    onChanged: (v) {
                      setState(() {
                        formData.USE_YN = v ? 'Y' : 'N';
                        formKey.currentState.save();
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                flex: 2,
                child: ISSelect(
                  label: '브랜드 구분',
                  value: _chainCode,
                  dataList: BrandNameItems,
                  onChange: (value) {
                    BrandNameItems.forEach((element) {
                      if (value == element.value) {
                        _chainCode = element.value;

                        formData.CHAIN_CODE = _chainCode;
                      }
                    });

                    _couponType = ' ';

                    loadBrandCouponListData(value);

                    // setState(() {
                    //   formData.couponType = value;
                    //
                    //   formKey.currentState.save();
                    // });
                  },
                ),
              ),
              Flexible(
                flex: 3,
                child: ISSelect(
                  label: '쿠폰 타입',
                  value: _couponType,//formData.couponType,
                  dataList: BrandCouponTypeItems,
                  onChange: (value) {
                    BrandCouponTypeItems.forEach((element) {
                      if (value == element.value) {
                        _couponType = element.value;

                        formData.COUPON_TYPE = _couponType;
                      }
                    });
                    // setState(() {
                    //   formData.couponType = value;
                    //
                    //   formKey.currentState.save();
                    // });
                  },
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: new BoxDecoration(
                      color: formData.DELIVERY_YN == 'Y' ? Colors.blue[200] : Colors.red[200],
                      borderRadius: new BorderRadius.circular(6)),
                  child: SwitchListTile(
                    dense: true,
                    value: formData.DELIVERY_YN == 'Y' ? true : false,
                    title: Text('배달주문 사용', style: TextStyle(fontSize: 12, color: Colors.white),),
                    onChanged: (v) {
                      setState(() {
                        formData.DELIVERY_YN = v ? 'Y' : 'N';
                        formKey.currentState.save();
                      });
                    },
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: new BoxDecoration(
                      color: formData.PACK_YN == 'Y' ? Colors.blue[200] : Colors.red[200],
                      borderRadius: new BorderRadius.circular(6)),
                  child: SwitchListTile(
                    dense: true,
                    value: formData.PACK_YN == 'Y' ? true : false,
                    title: Text('포장주문 사용', style: TextStyle(fontSize: 12, color: Colors.white),),
                    onChanged: (v) {
                      setState(() {
                        formData.PACK_YN = v ? 'Y' : 'N';
                        formKey.currentState.save();
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: ISInput(
                  autofocus: true,
                  value: Utils.getCashComma(formData.ORDER_MIN_AMT.toString()),
                  label: '최소 주문 금액(숫자만 입력)',
                  // validator: (v) {
                  //   return v.isEmpty ? '수량을 입력해주세요' : null;
                  // },
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    MultiMaskedTextInputFormatter(masks: ['x,xxx', 'xx,xxx', 'xxx,xxx'], separator: ',')
                  ],
                  onChange: (v) {
                    setState(() {
                      formData.ORDER_MIN_AMT = v.toString().replaceAll(',', '');
                    });
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: ISInput(
                  autofocus: true,
                  value: Utils.getCashComma(formData.PAY_MIN_AMT.toString()),
                  label: '최소 결제 금액(숫자만 입력)',
                  // validator: (v) {
                  //   return v.isEmpty ? '수량을 입력해주세요' : null;
                  // },

                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    MultiMaskedTextInputFormatter(masks: ['x,xxx', 'xx,xxx', 'xxx,xxx'], separator: ',')
                  ],

                  onChange: (v) {
                    setState(() {
                      formData.PAY_MIN_AMT = v.toString().replaceAll(',', '');
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: ISSelectDate(
                  context,
                  label: '발급가능 시작일',
                  value: formData.DISPLAY_ST_DATE,
                  onTap: () async {
                    DateTime valueDt = DateTime.now();
                    final DateTime picked = await showDatePicker(
                      context: context,
                      initialDate: valueDt,
                      firstDate: DateTime(1900, 1),
                      lastDate: DateTime(2031, 12),
                    );

                    setState(() {
                      if (picked != null) {
                        formData.DISPLAY_ST_DATE = formatDate(picked, [yyyy, '-', mm, '-', dd]);
                        //_startDate = formatDate(picked, [yyyy, '', mm, '', dd]);
                      }
                    });

                    formKey.currentState.save();
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: ISSelectDate(
                  context,
                  label: '발급가능 종료일',
                  value: formData.DISPLAY_EXP_DATE,
                  onTap: () async {
                    DateTime valueDt = DateTime.now();
                    final DateTime picked = await showDatePicker(
                      context: context,
                      initialDate: valueDt,
                      firstDate: DateTime(1900, 1),
                      lastDate: DateTime(2031, 12),
                    );

                    setState(() {
                      if (picked != null) {
                        formData.DISPLAY_EXP_DATE = formatDate(picked, [yyyy, '-', mm, '-', dd]);
                        //_endDate = formatDate(picked, [yyyy, '', mm, '', dd]);
                      }
                    });

                    formKey.currentState.save();
                  },
                ),
              ),
            ],
          ),
          // Row(
          //   children: <Widget>[
          //
          //     Flexible(
          //       flex: 1,
          //       child: ISInput(
          //         value: formData.INS_UCODE,
          //         readOnly: true,
          //         label: '등록자 ID',
          //         onSaved: (v) {
          //           formData.INS_UCODE = v;
          //         },
          //       ),
          //     ),
          //     Flexible(
          //       flex: 1,
          //       child: ISInput(
          //         value: formData.INS_NAME,
          //         readOnly: true,
          //         label: '등록자 명',
          //         onSaved: (v) {
          //           formData.INS_NAME = v;
          //         },
          //       ),
          //     ),
          //   ],
          // ),
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
            FormState form = formKey.currentState;
            if (!form.validate()) {
              return;
            }

            form.save();

            if (formData.CHAIN_CODE == null || formData.CHAIN_CODE == ''){
              ISAlert(context, '브랜드 구분을 확인해주세요.');
              return;
            }

            if (formData.COUPON_TYPE == null || formData.COUPON_TYPE == ''){
              ISAlert(context, '쿠폰타입을 확인해주세요.');
              return;
            }

            // formData.DISPLAY_ST_DATE = _startDate;
            // formData.DISPLAY_EXP_DATE = _endDate;

            formData.DISPLAY_ST_DATE = formData.DISPLAY_ST_DATE.replaceAll('-', '');
            formData.DISPLAY_EXP_DATE = formData.DISPLAY_EXP_DATE.replaceAll('-', '');

            await CouponController.to.postBrandCouponAppData(formData.toJson()).then((value) {
              if (value != null) {
                ISAlert(context, value);
                return;
              }
              else
                Navigator.pop(context, true);
            });
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
        title: Text('브랜드 앱설정 추가'),
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
      width: 450,
      height: 420,
      child: result,
    );
  }
}
