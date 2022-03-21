
import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/Model/coupon/couponRegistModel.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/View/CouponManager/coupon_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class B2BCouponRegist  extends StatefulWidget {
  const B2BCouponRegist({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return B2BCouponRegistState();
  }
}

class B2BCouponRegistState extends State<B2BCouponRegist> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  couponRegistModel formData;
  String _couponCnt;
  String _startDate = '';

  List<SelectOptionVO> selectBox_couponType = List();
  List<SelectOptionVO> selectBox_couponItem = List();

  loadTypeData() async {
    await CouponController.to.getDataB2BCodeItems(context).then((value) {
      if(value == null){
        ISAlert(context, '쿠폰정보를 가져오지 못했습니다. \n\n관리자에게 문의 바랍니다');
      }
      else{
        value.forEach((element) {
          selectBox_couponType.add(new SelectOptionVO(value: element['code'], label: '[${element['code']}] ' + element['codeName']));
        });
      }
    });

    setState(() {});
  }

  loadItemData(String coupon_type) async {
    selectBox_couponItem.clear();

    await CouponController.to.getDataB2BItems(coupon_type).then((value) {
      if(value == null){
        ISAlert(context, '쿠폰정보를 가져오지 못했습니다. \n\n관리자에게 문의 바랍니다');
      }
      else{
        value.forEach((element) {
          selectBox_couponItem.add(new SelectOptionVO(value: element['ITEM_CD'], label: element['ITEM_NM']));
        });
      }
    });

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    Get.put(CouponController());

    //items = CouponController.to.qDataItems;
    // CouponController.to.qFcDataItems.forEach((element) {
    //   selectBox_couponType.add(new SelectOptionVO(
    //       value: element['code'], label: element['codeName']));
    // });

    formData = couponRegistModel();

    formData.couponType = 'B2B_C100';
    //formData.startDate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    //_startDate = formatDate(DateTime.now(), [yyyy, '', mm, '', dd]);
    formData.insertUcode = GetStorage().read('logininfo')['uCode'];
    formData.insertName = GetStorage().read('logininfo')['name'];

    WidgetsBinding.instance.addPostFrameCallback((c) {
      loadTypeData();
      loadItemData('B2B_C100');
    });
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
                  label: '쿠폰타입',
                  value: formData.couponType,
                  dataList: selectBox_couponType,
                  onChange: (value) {
                    setState(() {
                      formData.couponType = value;
                      loadItemData(value);
                      formKey.currentState.save();
                      formData.itemType = null;
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
                child: ISSelect(
                  label: '쿠폰종류',
                  value: formData.itemType,
                  dataList: selectBox_couponItem,
                  onChange: (value) {
                    setState(() {
                      formData.itemType = value;

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
              // Flexible(
              //   flex: 1,
              //   child: ISSelectDate(
              //     context,
              //     label: '시작일',
              //     value: formData.startDate,
              //     onTap: () async {
              //       DateTime valueDt = DateTime.now();
              //       final DateTime picked = await showDatePicker(
              //         context: context,
              //         initialDate: valueDt,
              //         firstDate: DateTime(1900, 1),
              //         lastDate: DateTime(2031, 12),
              //       );
              //
              //       setState(() {
              //         if (picked != null) {
              //           formData.startDate = formatDate(picked, [yyyy, '-', mm, '-', dd]);
              //           _startDate = formatDate(picked, [yyyy, '', mm, '', dd]);
              //         }
              //       });
              //
              //       formKey.currentState.save();
              //     },
              //   ),
              // ),
              // Flexible(
              //   flex: 1,
              //   child: ISInput(
              //     value: formData.insertUcode,
              //     readOnly: true,
              //     label: '등록자 ID',
              //     onSaved: (v) {
              //       formData.insertUcode = v;
              //     },
              //   ),
              // ),
              // Flexible(
              //   flex: 1,
              //   child: ISInput(
              //     value: formData.insertName,
              //     readOnly: true,
              //     label: '등록자 명',
              //     onSaved: (v) {
              //       formData.insertName = v;
              //     },
              //   ),
              // ),
            ],
          ),
          ISInput(
              autofocus: true,
              value: formData.title,
              label: '쿠폰 타이틀',
              onSaved: (v) {
                formData.title = v;
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
          onPressed: () {
            FormState form = formKey.currentState;
            if (!form.validate()) {
              return;
            }

            form.save();

            if (formData.itemType == null) {
              ISAlert(context, '쿠폰종류를 확인해주세요.');
              return;
            }

            // if (formData.startDate == null || formData.startDate == '') {
            //   ISAlert(context, '시작일을 확인해주세요.');
            //   return;
            // }

            if (formData.couponCount == null || formData.couponCount == '' || formData.couponCount == '0') {
              ISAlert(context, '발행수량을 확인해주세요.');
              return;
            }

            //formData.startDate = _startDate;
            CouponController.to.postB2BData(formData.toJson(), context);

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
        title: Text('제휴 쿠폰 생성'),
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
      height: 360,
      child: result,
    );
  }
}
