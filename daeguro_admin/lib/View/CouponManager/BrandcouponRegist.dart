


import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/ISWidget/is_select_date.dart';
import 'package:daeguro_admin_app/Model/coupon/couponBrandCodeList.dart';
import 'package:daeguro_admin_app/Model/coupon/couponBrandRegistModel.dart';
import 'package:daeguro_admin_app/Model/coupon/couponTypeList.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/View/CouponManager/coupon_controller.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';



class BrandCouponRegist  extends StatefulWidget {
  final List<SelectOptionVO> brandNameItems;
  final String selectedChainCode;
  final String selectedCouponType;

  const BrandCouponRegist({Key key, this.brandNameItems, this.selectedChainCode, this.selectedCouponType}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BrandCouponRegistState();
  }
}

class BrandCouponRegistState extends State<BrandCouponRegist > {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  couponBrandRegistModel formData;
  String _chainCode = ' ';
  String _couponType = ' ';
  String _couponCnt;
  String _startDate = '';
  String _endDate = '';

  //List<SelectOptionVO> selectBox_couponType = List();

  List<SelectOptionVO> BrandNameItems = [];
  List<SelectOptionVO> BrandCouponTypeItems = [];

  loadBrandCouponListData(String _chainCode) async {
    BrandCouponTypeItems.clear();

    await CouponController.to.getBrandCouponListItems(_chainCode).then((value) {
      BrandCouponTypeItems.add(new SelectOptionVO(value: ' ', label: '', label2: '',));

      value.forEach((element) {
        CouponTypeListModel tempData = CouponTypeListModel.fromJson(element);

        //ChainCouponListItems.add(new SelectOptionVO(value: tempData.CODE, label: '[' + tempData.CODE + '] ' + tempData.CODE_NM, label2: tempData.CODE_NM,));
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

    BrandNameItems.clear();
    BrandNameItems = widget.brandNameItems;

    formData = couponBrandRegistModel();

    _chainCode = widget.selectedChainCode;
    _couponType = widget.selectedCouponType;

    formData.couponType = '';
    formData.couponCount = '';
    formData.isdAmt = '0';
    //formData.startDate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    //_startDate = formatDate(DateTime.now(), [yyyy, '', mm, '', dd]);
    formData.insertUcode = GetStorage().read('logininfo')['uCode'];
    formData.insertName = GetStorage().read('logininfo')['name'];

    WidgetsBinding.instance.addPostFrameCallback((c) {
      loadBrandCouponListData(widget.selectedChainCode);
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
                flex: 2,
                child: ISSelect(
                  label: '브랜드 구분',
                  value: _chainCode,
                  dataList: BrandNameItems,
                  onChange: (value) {
                    BrandNameItems.forEach((element) {
                      if (value == element.value) {
                        _chainCode = element.value;

                        formData.chainCode = _chainCode;
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

                        formData.couponType = _couponType;
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
                child: ISInput(
                  autofocus: true,
                  value: formData.couponCount,
                  label: '발행수량(숫자만 입력 가능합니다)',
                  // validator: (v) {
                  //   return v.isEmpty ? '수량을 입력해주세요' : null;
                  // },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                  onSaved: (v) {
                    formData.couponCount = v;
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: ISInput(
                  autofocus: true,
                  value: formData.isdAmt,
                  label: '인성부담금(숫자만 입력 가능합니다)',
                  // validator: (v) {
                  //   return v.isEmpty ? '금액을 입력해주세요' : null;
                  // },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                  onSaved: (v) {
                    formData.isdAmt = v;
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
                  label: '시작일',
                  value: formData.startDate,
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
                        formData.startDate = formatDate(picked, [yyyy, '-', mm, '-', dd]);
                        _startDate = formatDate(picked, [yyyy, '', mm, '', dd]);
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
                  label: '종료일',
                  value: formData.endDate,
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
                        formData.endDate = formatDate(picked, [yyyy, '-', mm, '-', dd]);
                        _endDate = formatDate(picked, [yyyy, '', mm, '', dd]);
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
          //         value: formData.insertUcode,
          //         readOnly: true,
          //         label: '등록자 ID',
          //         onSaved: (v) {
          //           formData.insertUcode = v;
          //         },
          //       ),
          //     ),
          //     Flexible(
          //       flex: 1,
          //       child: ISInput(
          //         value: formData.insertName,
          //         readOnly: true,
          //         label: '등록자 명',
          //         onSaved: (v) {
          //           formData.insertName = v;
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
          onPressed: () {
            FormState form = formKey.currentState;
            if (!form.validate()) {
              return;
            }

            form.save();

            if (formData.chainCode == null || formData.chainCode == ''){
              ISAlert(context, '브랜드 구분을 확인해주세요.');
              return;
            }

            if (formData.couponType == null || formData.couponType == ''){
              ISAlert(context, '쿠폰타입을 확인해주세요.');
              return;
            }

            if (formData.startDate == null || formData.startDate == ''){
              ISAlert(context, '시작일을 확인해주세요.');
              return;
            }

            if (formData.endDate == null || formData.endDate == ''){
              ISAlert(context, '종료일을 확인해주세요.');
              return;
            }

            if (formData.couponCount == null || formData.couponCount == '' || formData.couponCount == '0'){
              ISAlert(context, '발행수량을 확인해주세요.');
              return;
            }



            formData.startDate = _startDate;
            formData.endDate = _endDate;
            CouponController.to.postBrandData(formData.toJson(), context);

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
        title: Text('브랜드 쿠폰 생성'),
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
      height: 300,
      child: result,
    );
  }
}
