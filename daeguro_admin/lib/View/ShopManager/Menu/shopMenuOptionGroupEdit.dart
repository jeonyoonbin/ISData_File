import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/Model/shop/shopmenuoptiongroup_edit.dart';
import 'package:daeguro_admin_app/Util/multi_masked_formatter.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get_storage/get_storage.dart';

class ShopMenuOptionGroupEdit extends StatefulWidget {
  final String shopCode;
  final String menuCode;
  final ShopMenuOptionGroupEditModel sData;

  const ShopMenuOptionGroupEdit(
      {Key key, this.shopCode, this.menuCode, this.sData})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShopMenuOptionGroupEditState();
  }
}

class ShopMenuOptionGroupEditState extends State<ShopMenuOptionGroupEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ShopMenuOptionGroupEditModel formData;

  @override
  void initState() {
    super.initState();

    if (widget.sData != null) {
      //print('EditData');
      formData = widget.sData;
    } else {
      //print('NewData');
      formData = ShopMenuOptionGroupEditModel();
      formData.shopCd = widget.shopCode;

      formData.optionGroupCd = null;
      formData.optionGroupName = null;
      formData.optionGroupMemo = null;
      formData.useYn = 'Y';
      formData.multiYn = 'Y';
      formData.insertName = null;
    }

    //formData.shopCd = widget.sShopCode;

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
          ISInput(
            autofocus: true,
            value: formData.optionGroupName,
            height: 64,
            //padding: 0,
            context: context,
            label: '옵션그룹명',
            maxLength: 25,
            onChange: (v) {
              formData.optionGroupName = v;
            },
          ),
          // ISInput(
          //   value: formData.optionGroupMemo,
          //   height: 120,
          //   //padding: 0,
          //   context: context,
          //   label: '옵션그룹메모',
          //   keyboardType: TextInputType.multiline,
          //   maxLines: 8,
          //   maxLength: 250,
          //   onChange: (v) {
          //     formData.optionGroupMemo = v;
          //   },
          // ),
          Divider(
            height: 20,
          ),
          Container(
            //padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Flexible(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Align(child: Text('옵션 선택 설정', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)), alignment: Alignment.centerLeft),
                  )
                ),
                Flexible(
                  flex: 7,
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: ISInput(
                          autofocus: true,
                          value: Utils.getCashComma(formData.minCount.toString()),
                          textAlign: TextAlign.center,
                          context: context,
                          label: '최소수량',
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            MultiMaskedTextInputFormatter(masks: ['x,xxx'], separator: ',')
                          ],
                          onChange: (v) {
                            setState(() {
                              formData.minCount = v.toString().replaceAll(',', '');
                            });

                          },
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: ISInput(
                          value: Utils.getCashComma(formData.maxCount.toString()),
                          textAlign: TextAlign.center,
                          context: context,
                          label: '최대수량',
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            MultiMaskedTextInputFormatter(masks: ['x,xxx'], separator: ',')
                          ],
                          onChange: (v) {
                            setState(() {
                              formData.maxCount = v.toString().replaceAll(',', '');
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                        borderRadius: new BorderRadius.only(topLeft: Radius.circular(15.0), bottomLeft: Radius.circular(15.0))
                    ),
                    child: SwitchListTile(
                      dense: true,
                      value: formData.useYn == 'Y' ? true : false,
                      title: Text('사용', style: TextStyle(fontSize: 12, color: Colors.white),),
                      onChanged: (v) {
                        setState(() {
                          formData.useYn = v ? 'Y' : 'N';

                          // print('formData.useYn--> ' + formData.useYn.toString());

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
                            color: formData.multiYn == 'Y' ? Colors.blue[200] : Colors.red[200],
                            borderRadius: new BorderRadius.only(topRight: Radius.circular(15.0), bottomRight: Radius.circular(15.0))
                      ),
                      child: SwitchListTile(
                        dense: true,
                        value: formData.multiYn == 'Y' ? true : false,
                        title: Text('다중선택', style: TextStyle(fontSize: 12, color: Colors.white),),
                        onChanged: (v) {
                          setState(() {
                            formData.multiYn = v ? 'Y' : 'N';

                            formKey.currentState.save();
                          });
                        },
                      ),
                    ),
                ),
              ]),
          ),
          Divider(
            height: 20,
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

            String titleStr = '메뉴옵션 변경';
            String commentStr = '변경된 정보를 저장합니다.';

            if (widget.sData == null) {
              titleStr = '메뉴옵션 등록';
              commentStr = '새로운 메뉴옵션을 등록합니다.';
            }

            if (formData.minCount != '' && formData.maxCount != '') {
              if (int.parse(formData.minCount) > int.parse(formData.maxCount)) {
                ISAlert(context, '최소수량이 최대수량보다 많습니다.');
                return;
              }
            }

            formData.insertName = GetStorage().read('logininfo')['name'];

            if (widget.sData == null)
              ShopController.to
                  .postOptionGroupDetailData(formData.toJson(), context);
            else
              ShopController.to
                  .putOptionGroupDetailData(formData.toJson(), context);

            //EasyLoading.showSuccess('등록 성공', maskType: EasyLoadingMaskType.clear);

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
        title: Text(widget.sData == null ? '옵션그룹 신규 등록' : '옵션그룹 정보 수정'),
      ),
      body: Column(
        children: [
          SizedBox(height: 15),
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
      height: 360,
      child: result,
    );
  }
}
