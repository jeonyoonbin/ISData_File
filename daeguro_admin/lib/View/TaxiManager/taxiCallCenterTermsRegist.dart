import 'package:daeguro_admin_app/ISWidget/is_button.dart';
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



class taxiCallCenterTermsRegist extends StatefulWidget {
  final String name;

  const taxiCallCenterTermsRegist({Key key, this.name}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return taxiCallCenterTermsRegistState();
  }
}

class taxiCallCenterTermsRegistState extends State<taxiCallCenterTermsRegist> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String _setTitle;
  String _setMemo;

  List<SelectOptionVO> selectBox_title = [
    new SelectOptionVO(value: '00', label: '운영정책'),
    new SelectOptionVO(value: '10', label: '이용약관'),
    new SelectOptionVO(value: '20', label: '개인정보처리방침'),
    new SelectOptionVO(value: '30', label: '개인정보수집및이용'),
    new SelectOptionVO(value: '40', label: '개인정보취급위탁'),
    new SelectOptionVO(value: '50', label: '개인정보제3자제공'),
    new SelectOptionVO(value: '60', label: '위치기반서비스이용약관'),
    new SelectOptionVO(value: '70', label: '전자금융거래이용약관'),
    new SelectOptionVO(value: '80', label: '위수탁전자세금계산서이용약관'),
    new SelectOptionVO(value: '90', label: '푸쉬알림수신동의'),
  ];

  @override
  void initState() {
    super.initState();

    Get.put(CouponController());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
          ISInput(
            value: widget.name ?? '',
            context: context,
            readOnly: true,
            label: '지점(콜센터) 명',
            //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
            //prefixIcon: Icon(Icons.person, color: Colors.grey,),
            textStyle: TextStyle(fontSize: 12),
          ),
          ISSelect(
            label: '제목',
            value: _setTitle,
            dataList: selectBox_title,
            onChange: (value) {
              setState(() {
                _setTitle = value;
                formKey.currentState.save();
              });
            },
          ),
          ISInput(
            value: _setMemo ?? '',
            context: context,
            label: '내용',
            //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
            maxLines: 16,
            height: 250,
            keyboardType: TextInputType.multiline,
            prefixIcon: Icon(Icons.event_note, color: Colors.grey),
            textStyle: TextStyle(fontSize: 12),
            onChange: (v) {
              _setMemo = v;
            },
          ),
        ],
      ),
    );

    ButtonBar buttonBar = ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        ISButton(
          label: '수정',
          iconData: Icons.save,
          onPressed: () {
            FormState form = formKey.currentState;
            if (!form.validate()) {
              return;
            }

            form.save();

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
        title: Text('지점(콜센터) 약관/정책 등록'),
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
      width: 600,
      height: 500,
      child: result,
    );
  }
}
