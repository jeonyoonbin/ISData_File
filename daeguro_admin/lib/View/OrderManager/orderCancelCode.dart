
import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class OrderCancelCode extends StatefulWidget {
  const OrderCancelCode({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OrderCancelCodeState();
  }
}

class OrderCancelCodeState extends State<OrderCancelCode> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<SelectOptionVO> selectBox_cancelcode = [
    new SelectOptionVO(value: '00', label: '사유없음'),
    new SelectOptionVO(value: '10', label: '회원본인취소'),
    new SelectOptionVO(value: '11', label: '시간지연'),
    new SelectOptionVO(value: '12', label: '재접수'),
    new SelectOptionVO(value: '20', label: '가맹점취소'),
    new SelectOptionVO(value: '23', label: '가맹점휴무'),
    new SelectOptionVO(value: '21', label: '배달불가'),
    new SelectOptionVO(value: '22', label: '메뉴품절'),
  ];

  var _selCancelCode = '00';
  var _selCancelReason = '';

  List<String> ret = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
          ISSelect(
            label: '취소코드',
            width: 200,
            value: '00',
            dataList: selectBox_cancelcode,
            onChange: (v) {
              setState(() {
                _selCancelCode = v;
                formKey.currentState.save();
              });
            },
          ),
          ISInput(
            label: '취소사유',
            value: _selCancelReason,
            autofocus: true,
            context: context,
            maxLines: 5,
            height: 100,
            maxLength: 25,
            onChange: (v) {
              _selCancelReason = v;
              //formData.telNo = v;
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
            ret.add(_selCancelCode);
            ret.add(_selCancelReason);

            FormState form = formKey.currentState;
            if (!form.validate()) {
              return;
            }

            Navigator.pop(context, ret);
          },
        ),
      ],
    );

    var result = Scaffold(
      appBar: AppBar(
        title: Text('취소 사유 선택'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: form
          ),
        ],
      ),
      bottomNavigationBar: buttonBar,
    );
    return SizedBox(
      width: 400,
      height: 300,
      child: result,
    );
  }
}
