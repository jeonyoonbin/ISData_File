import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/Model/shop/shopmenulist_edit.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/Util/multi_masked_formatter.dart';
import 'package:daeguro_admin_app/Util/utils.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get_storage/get_storage.dart';

class ShopMenuListEdit extends StatefulWidget {
  final String shopCode;
  final String groupCode;
  final ShopMenuListEditModel sData;

  const ShopMenuListEdit(
      {Key key, this.shopCode, this.groupCode, this.sData})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShopMenuListEditState();
  }
}

class ShopMenuListEditState extends State<ShopMenuListEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ShopMenuListEditModel formData;

  @override
  void initState() {
    super.initState();

    if (widget.sData != null) {
      // print('EditData');
      formData = widget.sData;

      if (formData.insertName == '') formData.insertName = null;
    } else {
      // print('NewData');
      formData = ShopMenuListEditModel();
      formData.shopCd = widget.shopCode;
      formData.groupCd = widget.groupCode;

      formData.menuName = null;
      formData.menuCost = '0';
      formData.useYn = 'Y';
      formData.aloneOrder = 'N';
      formData.mainYn = 'N';
      formData.noFlag = 'N';
      formData.insertName = null;
    }

    //formData.shopCd = widget.sShopCode;

    WidgetsBinding.instance.addPostFrameCallback((c) {
      setState(() { });
    });
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
                  height: 64,
                  value: formData.menuName,
                  context: context,
                  label: '메뉴이름',
                  maxLength: 50,
                  onChange: (v) {
                    formData.menuName = v;
                  },
                ),
              ),
              Flexible(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.only(bottom: 24),
                  child: ISInput(
                    value: formData.menuCost == null ? '' : Utils.getCashComma(formData.menuCost) ?? '',
                    context: context,
                    label: '금액',
                    maxLines: 1,
                    onChange: (v) {
                      //formData.menuCost = v;
                      setState(() {
                        formData.menuCost = v.toString().replaceAll(',', '');
                      });
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      MultiMaskedTextInputFormatter(masks: ['x,xxx', 'xx,xxx', 'xxx,xxx'], separator: ',')
                    ],
                    // validator: (v) {
                    //   return v.isEmpty ? '[필수] 금액' : null;
                    // },
                  ),
                ),
              ),
            ],
          ),
          ISInput(
            value: formData.menuDesc,
            context: context,
            height: 120,
            maxLength: 75,
            maxLines: 8,
            keyboardType: TextInputType.multiline,
            label: '메모',
            onChange: (v) {
              formData.menuDesc = v;
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
                  child: SwitchListTile(
                    dense: true,
                    value: formData.useYn == 'Y' ? true : false,
                    title: Text('사용', style: TextStyle(fontSize: 12, color: Colors.white),),
                    onChanged: (v) {
                      setState(() {
                        formData.useYn = v ? 'Y' : 'N';
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
                        borderRadius: new BorderRadius.only(topRight: Radius.circular(6.0), bottomRight: Radius.circular(6.0))
                  ),
                  child: SwitchListTile(
                      dense: true,
                      value: formData.adultOnly == 'Y' ? true : false,
                      title: Text('성인', style: TextStyle(fontSize: 12, color: Colors.white),),
                      onChanged: (v) {
                        setState(() {
                            formData.adultOnly = v ? 'Y' : 'N';

                          formKey.currentState.save();
                        });
                      },
                  ),
                ),
                ),
              ]
            ),
          ),
          SizedBox(height: 10, width: 430,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      height: 40,
                      decoration: new BoxDecoration(
                      color: formData.mainYn == 'Y' ? Colors.blue[200] : Colors.red[200],
                          borderRadius: new BorderRadius.only(topLeft: Radius.circular(6.0), bottomLeft: Radius.circular(6.0))
                      ),
                      child: SwitchListTile(
                        dense: true,
                        value: formData.mainYn == 'Y' ? true : false,
                        title: Text('대표', style: TextStyle(fontSize: 12, color: Colors.white),),
                        onChanged: (v) {
                          setState(() {
                            formData.mainYn = v ? 'Y' : 'N';
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
                          color: formData.aloneOrder == 'Y' ? Colors.blue[200] : Colors.red[200],
                          borderRadius: new BorderRadius.circular(0)),
                      child: SwitchListTile(
                        dense: true,
                        value: formData.aloneOrder == 'Y' ? true : false,
                        title: Text('1인', style: TextStyle(fontSize: 12, color: Colors.white),),
                        onChanged: (v) {
                          setState(() {
                            formData.aloneOrder = v ? 'Y' : 'N';
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
                          borderRadius: new BorderRadius.only(topRight: Radius.circular(6.0), bottomRight: Radius.circular(6.0))),
                  child: SwitchListTile(
                    dense: true,
                    value: formData.noFlag == 'Y' ? true : false,
                    title: Text('품절', style: TextStyle(fontSize: 12, color: Colors.white),),
                    onChanged: (v) {
                      setState(() {
                        formData.noFlag = v ? 'Y' : 'N';

                        formKey.currentState.save();
                      });
                    },
                  ),
                ),
                  ),
                ]
            ),
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
            if(ShopController.to.SumMainCount.value >= 5 && formData.mainYn == 'Y'){
              ISAlert(context, '대표메뉴 설정은 최대 5개입니다. \n이전 대표메뉴를 해제 후, 설정해주세요.');
              return;
            }

            FormState form = formKey.currentState;
            if (!form.validate()) {
              return;
            }

            form.save();

            String titleStr = '메뉴 변경';
            String commentStr = '변경된 정보를 저장합니다.';

            if (widget.sData == null) {
              titleStr = '메뉴 등록';
              commentStr = '새로운 메뉴를 등록합니다.';
            }

            if (/*formData.menuCost == '0' || */formData.menuCost == ''){
              ISAlert(context, '금액을 입력해 주세요.');
              return;
            }

            if(int.parse(formData.menuCost) % 10 != 0)
            {
              ISAlert(context, '10 원 단위의 금액만 입력 가능합니다.');
              return;
            }

            formData.insertName = GetStorage().read('logininfo')['name'];

            // print('formData--> ' + formData.toJson().toString());

            if (widget.sData == null)
              ShopController.to.postMenuDetailData(formData.toJson(), context);
            else
              ShopController.to.putMenuDetailData(formData.toJson(), context);

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
        title: Text(widget.sData == null ? '메뉴 신규 등록' : '메뉴 정보 수정'),
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
      height: 460,
      child: result,
    );
  }
}
