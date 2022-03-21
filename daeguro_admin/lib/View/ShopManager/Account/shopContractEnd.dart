
import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_select_date.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ShopContractEnd extends StatefulWidget {
  final String shopCode ;
  final String shopName ;
  const ShopContractEnd({Key key, this.shopCode, this.shopName}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShopContractEndState();
  }
}

class ShopContractEndState extends State<ShopContractEnd> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var dispFromDate = '';

  @override
  void initState() {
    super.initState();

    Get.put(ShopController());
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
          ISSelectDate(
            context,
            label: '해지 실행일',
            value: dispFromDate.replaceAll('.', '-'),
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
                  dispFromDate = formatDate(picked, [yyyy, '-', mm, '-', dd]);
                }
              });

              formKey.currentState.save();
            },
          ),
          Container(
              child: Center(
                  child: Text('입력하신 실행일에 해지 처리됩니다.', style: TextStyle(fontSize: 12),)
              )
          ),
          Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Center(
                  child: Text('[가맹점 해지처리 후, 복구가 불가능합니다]', style: TextStyle(color: Colors.red),)
              )
          )
        ],
      ),
    );

    ButtonBar buttonBar = ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        ISButton(
          label: '해지처리',
          iconData: Icons.store,
          onPressed: () {
            ISConfirm(context, '가맹점 해지', '가맹점 해지처리 후, 복구가 불가능합니다.\n\n[${widget.shopName}] 가맹점을 해지 하시겠습니까?', (context) async {
              await ShopController.to.putShopContractEnd(context, widget.shopCode, dispFromDate.replaceAll('-', '')).then((value) {
                if (value == '00'){
                  Navigator.pop(context);
                  Navigator.pop(context, true);

                  setState(() {
                  });
                }
              });
            });
          },
        ),
      ],
    );

    var result = Scaffold(
      appBar: AppBar(
        title: Text('가맹점 해지'),
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: form
          ),
        ],
      ),
      bottomNavigationBar: buttonBar,
    );
    return SizedBox(
      width: 300,
      height: 240,
      child: result,
    );
  }
}
