import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/Model/shop/shopmenuoption_edit.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/Util/multi_masked_formatter.dart';
import 'package:daeguro_admin_app/Util/utils.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get_storage/get_storage.dart';

class ShopMenuOptionEdit extends StatefulWidget {
  final String shopCd;
  final String optionGroupCd;

  final ShopMenuOptionEditModel sData;

  const ShopMenuOptionEdit(
      {Key key, this.shopCd, this.optionGroupCd, this.sData})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShopMenuOptionEditState();
  }
}

class ShopMenuOptionEditState extends State<ShopMenuOptionEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ShopMenuOptionEditModel formData;

  @override
  void initState() {
    super.initState();

    if (widget.sData != null) {
      //print('EditData');
      formData = widget.sData;
    } else {
      //print('NewData');
      formData = ShopMenuOptionEditModel();
      formData.shopCd = widget.shopCd;
      formData.optionGroupCd = widget.optionGroupCd;

      formData.optionName = null;
      formData.optionMemo = null;
      formData.cost = '0';
      formData.useYn = 'Y';
      formData.noFlag = 'N';
      formData.insertName = null;
    }

    // WidgetsBinding.instance.addPostFrameCallback((c) {
    //   _query();
    // });
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
                flex: 8,
                child: ISInput(
                  autofocus: true,
                  value: formData.optionName,
                  //padding: 0,
                  height: 64,
                  label: '옵션명',
                  maxLength: 25,
                  context: context,
                  inputFormatters: <TextInputFormatter>[
                    BlacklistingTextInputFormatter(RegExp('[;]')),
                  ],
                  onChange: (v) {
                    formData.optionName = v;
                  },
                ),
              ),
              Flexible(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.only(bottom: 24),
                  child: ISInput(
                    value: formData.cost == null ? '' : Utils.getCashComma(formData.cost) ?? '',
                    label: '금액',
                    maxLines: 1,
                    context: context,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      MultiMaskedTextInputFormatter(masks: ['x,xxx', 'xx,xxx', 'xxx,xxx'], separator: ',')
                    ],
                    onChange: (v) {
                      setState(() {
                        formData.cost = v.toString().replaceAll(',', '');
                      });
                    },
                    // validator: (v) {
                    //   return v.isEmpty ? '[필수] 금액' : null;
                    // },
                  ),
                ),
              ),
            ],
          ),
          ISInput(
            value: formData.optionMemo,
            height: 120,
            label: '옵션메모',
            maxLength: 250,
            maxLines: 8,
            keyboardType: TextInputType.multiline,
            context: context,
            onChange: (v) {
              formData.optionMemo = v;
            },
          ),
          Divider(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Container(
                    height: 40,
                    decoration: new BoxDecoration(
                        color: formData.useYn == 'Y' ? Colors.blue[200] : Colors.red[200],
                        borderRadius: new BorderRadius.only(topLeft: Radius.circular(6.0), bottomLeft: Radius.circular(6.0))
                    ),
                    width: 185,
                    child: SwitchListTile(
                      dense: true,
                      value: formData.useYn == 'Y' ? true : false,
                      title: Text('사용', style: TextStyle(fontSize: 12, color: Colors.white),),
                      onChanged: (v) {
                        setState(() {
                          formData.useYn = v ? 'Y' : 'N';

                          //print('formData.useYn--> '+formData.useYn.toString());

                          formKey.currentState.save();
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(width: 0.3),
                Flexible(
                  child: Container(
                    height: 40,
                    decoration: new BoxDecoration(
                        color: formData.adultOnly == 'Y' ? Colors.blue[200] : Colors.red[200],
                        borderRadius: new BorderRadius.circular(0)
                    ),
                    width: 185,
                    child: SwitchListTile(
                      dense: true,
                      value: formData.adultOnly == 'Y' ? true : false,
                      title: Text('성인', style: TextStyle(fontSize: 12, color: Colors.white),),
                      onChanged: (v) {
                        setState(() {
                          formData.adultOnly = v ? 'Y' : 'N';

                          //print('formData.useYn--> '+formData.useYn.toString());

                          formKey.currentState.save();
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(width: 0.3),
                Flexible(
                  child: Container(
                    height: 40,
                    decoration: new BoxDecoration(
                        color: formData.noFlag == 'Y' ? Colors.blue[200] : Colors.red[200],
                        borderRadius: new BorderRadius.only(topRight: Radius.circular(6.0), bottomRight: Radius.circular(6.0))
                    ),
                    width: 185,
                    child: SwitchListTile(
                      dense: true,
                      value: formData.noFlag == 'Y' ? true : false,
                      title: Text('품절', style: TextStyle(fontSize: 12, color: Colors.white),),
                      onChanged: (v) {
                        setState(() {
                          formData.noFlag = v ? 'Y' : 'N';

                          //print('formData.useYn--> '+formData.useYn.toString());

                          formKey.currentState.save();
                        });
                      },
                    ),
                  ),
                ),
              ]),
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

            String titleStr = '옵션 변경';
            String commentStr = '변경된 정보를 저장합니다.';

            if (/*formData.cost == '0' || */formData.cost == ''){
              ISAlert(context, '금액을 입력해 주세요.');
              return;
            }

            if(int.parse(formData.cost) % 10 != 0)
            {
              ISAlert(context, '10 원 단위의 금액만 입력 가능합니다.');
              return;
            }

            if (widget.sData == null) {
              titleStr = '옵션 등록';
              commentStr = '새로운 옵션을 등록합니다.';
            }

            formData.insertName = GetStorage().read('logininfo')['name'];
            //print('formData--> '+formData.toJson().toString());

            if (widget.sData == null)
              ShopController.to
                  .postOptionDetailData(formData.toJson(), context);
            else
              ShopController.to.putOptionDetailData(formData.toJson(), context);

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
        title: Text(widget.sData == null ? '옵션 신규 등록' : '옵션 정보 수정'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15),
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
      width: 464,
      height: widget.sData == null ? 420 : 420,
      child: result,
    );
  }
}
