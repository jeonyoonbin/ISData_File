

import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/Model/coupon/couponEditModel.dart';
import 'package:daeguro_admin_app/View/CouponManager/coupon_controller.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';



class B2BCouponChange extends StatefulWidget {
  const B2BCouponChange({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return B2BCouponChangeState();
  }
}

class B2BCouponChangeState extends State<B2BCouponChange> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  couponEditModel formData;
  String _couponCnt;

  List<SelectOptionVO> selectBox_status = [
    new SelectOptionVO(value: '00', label: '대기'),
    new SelectOptionVO(value: '10', label: '승인'),
    new SelectOptionVO(value: '20', label: '발행(회원)'),
    new SelectOptionVO(value: '30', label: '사용(회원)'),
    new SelectOptionVO(value: '99', label: '폐기'),
  ];

  List<SelectOptionVO> selectBox_couponType = List();
  List<SelectOptionVO> selectBox_couponItem = List();

  loadTypeData() async {
    await CouponController.to.getDataB2BCodeItems(context).then((value) {
      if(value == null){
        ISAlert(context, '쿠폰정보를 가져오지 못했습니다. \n\n관리자에게 문의 바랍니다');
      }
      else{
        value.forEach((element) {
          selectBox_couponType.add(new SelectOptionVO(value: element['code'], label: '[${element['code']}] '+element['codeName']));
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


    // CouponController.to.qDataItems.forEach((element) {
    //   selectBox_couponType.add(new SelectOptionVO(
    //       value: element['code'], label: element['codeName']));
    // });

    formData = couponEditModel();

    formData.couponType = 'B2B_C100';
    formData.jobUcode = GetStorage().read('logininfo')['uCode'];
    formData.jobName = GetStorage().read('logininfo')['name'];

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
                    flex: 2,
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
              Flexible(
                flex: 1,
                child: ISInput(
                  autofocus: true,
                  padding: 10,
                  value: formData.couponCount,
                  label: '발행수량',
                  validator: (v) {
                    return v.isEmpty ? '수량을 입력해주세요' : null;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                  onSaved: (v) {
                    formData.couponCount = v;
                  },
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: ISSelect(
                  label: '변경 전 상태',
                  value: formData.oldStatus,
                  dataList: selectBox_status,
                  onSaved: (v) {
                    formData.oldStatus = v;
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: ISSelect(
                  label: '변경 후 상태',
                  value: formData.newStatus,
                  dataList: selectBox_status,
                  onSaved: (v) {
                    formData.newStatus = v;
                  },
                ),
              ),
            ],
          ),

          // Row(
          //   children: <Widget>[
          //     Flexible(
          //       flex: 1,
          //       child: ISInput(
          //         value: formData.jobUcode,
          //         readOnly: true,
          //         label: '변경자 ID',
          //         onSaved: (v) {
          //           formData.jobUcode = v;
          //         },
          //       ),
          //     ),
          //     Flexible(
          //       flex: 1,
          //       child: ISInput(
          //         value: formData.jobName,
          //         readOnly: true,
          //         label: '변경자 명',
          //         onSaved: (v) {
          //           formData.jobName = v;
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

            if (formData.itemType == null) {
              ISAlert(context, '쿠폰종류를 확인해주세요.');
              return;
            }

            formData.jobUcode = GetStorage().read('logininfo')['uCode'];
            formData.jobName = GetStorage().read('logininfo')['name'];

            CouponController.to.putB2BData(formData.toJson(), context);

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
        title: Text('제휴 쿠폰 상태 변경'),
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
      width: 400,
      height: 320,
      child: result,
    );
  }
}
