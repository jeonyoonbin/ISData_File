
import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/View/CustomerManager/customer_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CustomerRetire extends StatefulWidget {
  final String custCode ;
  const CustomerRetire({Key key, this.custCode}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CustomerRetireState();
  }
}

class CustomerRetireState extends State<CustomerRetire> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var _selCancelReason = '';

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
          ISInput(
            value: _selCancelReason,
            label: '탈퇴사유',
            maxLength: 25,
            maxLines: 1,
            height: 80,
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
          label: '탈퇴',
          iconData: Icons.person_remove_alt_1,
          onPressed: () {

            FormState form = formKey.currentState;
            if (!form.validate()) {
              return;
            }

            ISConfirm(context, '회원 탈퇴', '회원 탈퇴 하시겠습니까?', (context) async {
              Navigator.pop(context, true);
              await CustomerController.to.deleteCustomerRetire(widget.custCode, _selCancelReason, context);
              Navigator.pop(context, true);
              setState(() {});
            });
          },
        ),
      ],
    );

    var result = Scaffold(
      appBar: AppBar(
        title: Text('회원 탈퇴'),
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
      height: 220,
      child: result,
    );
  }
}
