

import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/Model/coupon/couponEditModel.dart';
import 'package:daeguro_admin_app/Model/taxi/coupon/taxiCouponEditModel.dart';
import 'package:daeguro_admin_app/View/CouponManager/coupon_controller.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';



class TaxiCouponEdit extends StatefulWidget {
  final List couponTypeItems;

  const TaxiCouponEdit({Key key, this.couponTypeItems}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TaxiCouponEditState();
  }
}

class TaxiCouponEditState extends State<TaxiCouponEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  taxiCouponEditModel formData;
  String _couponCnt;

  List<SelectOptionVO> selectBox_status = [
    new SelectOptionVO(value: '00', label: '대기'),
    new SelectOptionVO(value: '10', label: '승인'),
    new SelectOptionVO(value: '20', label: '발행(회원)'),
    new SelectOptionVO(value: '30', label: '사용(회원)'),
    new SelectOptionVO(value: '99', label: '폐기'),
  ];

  List<SelectOptionVO> selectBox_service = [
    new SelectOptionVO(value: '2', label: '주문'),
    new SelectOptionVO(value: '3', label: '택시'),
    new SelectOptionVO(value: '4', label: '꽃배달'),
    new SelectOptionVO(value: '5', label: '퀵'),
    new SelectOptionVO(value: '6', label: '대리'),
  ];



  List<SelectOptionVO> selectBox_couponType = List();

  @override
  void initState() {
    super.initState();

    Get.put(CouponController());


    widget.couponTypeItems.forEach((element) {
      selectBox_couponType.add(new SelectOptionVO(value: element['code'], label: '[${element['code']}] '+element['codeName']));
    });

    formData = taxiCouponEditModel();

    formData.couponType = 'IS_C100';
    formData.jobUcode = GetStorage().read('logininfo')['uCode'];
    formData.jobName = GetStorage().read('logininfo')['name'];
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
                flex: 2,
                child: ISSelect(
                  label: '쿠폰종류',
                  value: formData.couponType,
                  dataList: selectBox_couponType,
                  onChange: (value) {
                    setState(() {
                      formData.couponType = value;
                      formKey.currentState.save();
                    });
                  },
                ),
              ),
              // Flexible(
              //   flex: 1,
              //   child: ISSelect(
              //     label: '서비스 선택',
              //     value: formData.service,
              //     dataList: selectBox_service,
              //     onChange: (value) {
              //       setState(() {
              //         formData.service = value;
              //
              //         formKey.currentState.save();
              //       });
              //     },
              //   ),
              // ),
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
              Flexible(
                flex: 1,
                child: ISInput(
                  autofocus: true,
                  padding: 10,
                  value: formData.couponCount,
                  label: '발행수량(숫자)',
                  // validator: (v) {
                  //   return v.isEmpty ? '수량을 입력해주세요' : null;
                  // },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                  onSaved: (v) {
                    formData.couponCount = v;
                  },
                ),
              )
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

            CouponController.to.putData(formData.toJson(), context);

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
        title: Text('쿠폰 상태 변경'),
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
      width: 460,
      height: 260,
      child: result,
    );
  }
}
