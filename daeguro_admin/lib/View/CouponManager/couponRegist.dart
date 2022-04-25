import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/ISWidget/is_select_date.dart';
import 'package:daeguro_admin_app/Model/coupon/couponRegistModel.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/View/CouponManager/coupon_controller.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CouponRegist extends StatefulWidget {
  final List couponTypeItems;
  final String selectedCouponType;

  const CouponRegist({Key key, this.couponTypeItems, this.selectedCouponType}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CouponRegistState();
  }
}

class CouponRegistState extends State<CouponRegist> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  couponRegistModel formData;
  String _couponCnt;

  String _expDate;
  String _expDateFormat;
  bool _expDateVisible = false;

  List<SelectOptionVO> selectBox_couponType = List();

  @override
  void initState() {
    super.initState();

    Get.put(CouponController());
    formData = couponRegistModel();

    //items = CouponController.to.qDataItems;
    widget.couponTypeItems.forEach((element) {
      selectBox_couponType
          .add(new SelectOptionVO(value: element['code'], label: '[${element['code']}] ' + element['codeName'], label2: element['limit'].toString()));

      if (element['code'] == widget.selectedCouponType) {
        if (element['limit'] == 0) {
          formData.exp_date = formatDate(DateTime.now(), [yyyy, '', mm, '', dd]);
          _expDateVisible = true;
        } else {
          formData.exp_date = '';
          _expDateVisible = false;
        }
      }
    });

    formData.couponType = widget.selectedCouponType; //'IS_C100';
    _expDate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    //_expDateFormat = formatDate(DateTime.now(), [yyyy, '', mm, '', dd]);
    formData.isdAmt = '0';
    formData.insertUcode = GetStorage().read('logininfo')['uCode'];
    formData.insertName = GetStorage().read('logininfo')['name'];
  }

  @override
  void dispose() {
    selectBox_couponType.clear();

    selectBox_couponType = null;
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
                child: ISSelect(
                  label: '쿠폰종류',
                  value: formData.couponType,
                  dataList: selectBox_couponType,
                  onChange: (value) {
                    setState(() {
                      formData.couponType = value;

                      // 쿠폰타입의 limit 값을 가져와서 비교
                      selectBox_couponType.forEach((element) {
                        if (element.value == value) {
                          if (element.label2.toString() == '0') {
                            _expDateVisible = true;
                            _expDate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
                            formData.exp_date = formatDate(DateTime.now(), [yyyy, '', mm, '', dd]);
                          } else {
                            _expDateVisible = false;
                            _expDate = '';
                            formData.exp_date = '';
                          }
                        }
                      });

                      setState(() {});

                      formKey.currentState.save();
                    });
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
                  label: '발행수량(숫자)',
                  validator: (v) {
                    return v.isEmpty ? '수량을 입력해주세요' : null;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
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
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                  onSaved: (v) {
                    formData.isdAmt = v;
                  },
                ),
              ),
            ],
          ),
          Visibility(
            visible: _expDateVisible,
            child: ISSelectDate(
              context,
              label: '사용기한',
              value: _expDate,
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
                    _expDate = formatDate(picked, [yyyy, '-', mm, '-', dd]);
                    formData.exp_date = formatDate(picked, [yyyy, '', mm, '', dd]);
                  }
                });

                formKey.currentState.save();
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

            //formData.startDate = _startDate;
            CouponController.to.postData(formData.toJson(), context);

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
        title: Text('쿠폰 생성'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Container(padding: EdgeInsets.symmetric(horizontal: 8.0), child: form),
          ],
        ),
      ),
      bottomNavigationBar: buttonBar,
    );
    return SizedBox(
      width: 360,
      height: 300,
      child: result,
    );
  }
}
