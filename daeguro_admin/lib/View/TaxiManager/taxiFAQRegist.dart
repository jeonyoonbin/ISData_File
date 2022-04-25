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



class taxiFAQRegist extends StatefulWidget {
  final String name;

  const taxiFAQRegist({Key key, this.name}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return taxiFAQRegistState();
  }
}

class taxiFAQRegistState extends State<taxiFAQRegist> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String _setGbn1;
  String _setGbn2;
  String _setMemo;

  List<SelectOptionVO> selectBox_gbn = [
    new SelectOptionVO(value: '00', label: '호출/결제'),
    new SelectOptionVO(value: '10', label: '회원정보'),
    new SelectOptionVO(value: '20', label: '이용문의'),
  ];

  List<SelectOptionVO> selectBox_gbn2 = [
    new SelectOptionVO(value: '00', label: '게시'),
    new SelectOptionVO(value: '10', label: '미게시'),
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
          Row(
            children: [
              Expanded(
                flex: 1,
                child: ISSelect(
                  label: '분류',
                  value: _setGbn1,
                  dataList: selectBox_gbn,
                  onChange: (value) {
                    setState(() {
                      _setGbn1 = value;
                      formKey.currentState.save();
                    });
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: ISSelect(
                  label: '게시유무',
                  value: _setGbn2,
                  dataList: selectBox_gbn2,
                  onChange: (value) {
                    setState(() {
                      _setGbn2 = value;
                      formKey.currentState.save();
                    });
                  },
                ),
              ),
            ],
          ),
          ISInput(
            value: widget.name ?? '',
            context: context,
            label: '제목',
            //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
            //prefixIcon: Icon(Icons.person, color: Colors.grey,),
            textStyle: TextStyle(fontSize: 12),
          ),
          ISInput(
            value: _setMemo ?? '',
            context: context,
            label: '답변',
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
          label: '등록',
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
        title: Text('FAQ 등록'),
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
