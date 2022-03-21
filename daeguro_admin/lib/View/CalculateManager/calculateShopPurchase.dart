
import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/Model/calc/calculateShopMileageModel.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/View/CalculateManager/calculate_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class CalculateShopPurchase extends StatefulWidget {
  final calculateShopMileageModel sData;

  const CalculateShopPurchase({Key key, this.sData})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CalculateShopPurchaseState();
  }
}

class CalculateShopPurchaseState extends State<CalculateShopPurchase> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  //ApiCompanyDModel formData = ApiCompanyDModel();

  String _ioGbn = 'I';
  String _amt = '';
  String _memo = '';

  List<SelectOptionVO> selectBox_ioGbnType = List();

  @override
  void initState() {
    super.initState();

    selectBox_ioGbnType.clear();

    selectBox_ioGbnType.add(new SelectOptionVO(value: 'I', label: '입금'));
    selectBox_ioGbnType.add(new SelectOptionVO(value: 'O', label: '출금'));

    // if (widget.sData != null) {
    //   formData = widget.sData;
    // } else {
    //   formData = ApiCompanyDModel();
    // }
  }

  @override
  void dispose() {
    selectBox_ioGbnType.clear();

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
                  label: '사입 구분',
                  value: _ioGbn,
                  dataList: selectBox_ioGbnType,
                  onChange: (value) {
                    setState(() {
                      _ioGbn = value;
                    });
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: ISInput(
                  autofocus: true,
                  value: _amt,//formData.MEMO,
                  label: '금액',
                  validator: (v) {
                    return v.isEmpty ? '금액을 입력해주세요' : null;
                  },
                  onChange: (v) {
                    _amt = v;
                  },
                )
              ),
            ],
          ),
          Container(
            child: ISInput(
              autofocus: true,
              value: _memo,//formData.MEMO,
              label: '메모',
              textStyle: TextStyle(fontSize: 12),
              maxLines: 8,
              height: 120,
              keyboardType: TextInputType.multiline,
              // validator: (v) {
              //   return v.isEmpty ? '수량을 입력해주세요' : null;
              // },
              onChange: (v) {
                _memo = v;
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
          label: '실행',
          iconData: Icons.save,
          onPressed: () async {
            FormState form = formKey.currentState;
            if (!form.validate()) {
              return;
            }

            form.save();

            String _uCode = GetStorage().read('logininfo')['uCode'];
            // formData.userName = GetStorage().read('logininfo')['name'];

            CalculateController.to.postShopCharge(context, widget.sData.MCODE.toString(), widget.sData.CCCODE, widget.sData.SHOP_CD, _ioGbn, _amt, _memo, _uCode);

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
        title: Text('사입 처리'),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
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
      height: 310,
      child: result,
    );
  }
}
