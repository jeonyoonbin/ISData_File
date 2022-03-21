import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/Model/shop/shop_delitip.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/Util/multi_masked_formatter.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/Util/utils.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get_storage/get_storage.dart';

class ShopDeliTipEdit extends StatefulWidget {
  final String shopCode;
  final String tipGbn;
  final ShopDeliTipModel sData;

  const ShopDeliTipEdit(
      {Key key, this.shopCode, this.tipGbn, this.sData})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShopDeliTipEditState();
  }
}

class ShopDeliTipEditState extends State<ShopDeliTipEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ShopDeliTipModel formData;

  List<SelectOptionVO> selectBox_day = [
    new SelectOptionVO(value: '1', label: '일요일'),
    new SelectOptionVO(value: '2', label: '월요일'),
    new SelectOptionVO(value: '3', label: '화요일'),
    new SelectOptionVO(value: '4', label: '수요일'),
    new SelectOptionVO(value: '5', label: '목요일'),
    new SelectOptionVO(value: '6', label: '금요일'),
    new SelectOptionVO(value: '7', label: '토요일'),
  ];

  @override
  void initState() {
    super.initState();

    if (widget.sData != null) {
      //print('EditData');
      formData = widget.sData;
    }
    else {
      //print('NewData');
      formData = ShopDeliTipModel();
      formData.tipGbn = widget.tipGbn;
      formData.tipAmt = '0';

      if (widget.tipGbn == '3') {
        formData.tipDay = '1';
        formData.tipFromStand = '0';
      } else if (widget.tipGbn == '9') {
        formData.tipDay = '1';
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((c) {
      //loadBankListData();
    });
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: getEditWidget(),
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

            if(int.parse(formData.tipAmt) % 100 != 0)
            {
              ISAlert(context, '100 원 단위의 금액만 입력 가능합니다.');
              return;
            }

            if (formData.tipGbn == '7') {
              if (formData.tipDay == null || formData.tipDay == '') {
                ISAlert(context, '선택된 영업요일이 없습니다. \n\n영업요일 선택 후, 다시 시도해주세요.');
                return;
              }

              if (formData.tipFromStand != '') {
                if (formData.tipFromStand.length != 4 ) {
                  ISAlert(context, '[오픈시간] 잘못된 시간형식 입니다.');
                  return;

                }
                if (int.parse(formData.tipFromStand) > 2359) {
                  ISAlert(context, '오픈 시간은 최대 23:59 입니다.');
                  return;
                }

                if (int.parse(formData.tipFromStand.substring(2,4)) > 59) {
                  ISAlert(context, '[오픈시간] 잘못된 시간형식 입니다.');
                  return;
                }
              }

              if (formData.tipToStand != '') {
                if (formData.tipToStand.length != 4 ) {
                  ISAlert(context, '[마감시간] 잘못된 시간형식 입니다.');
                  return;
                }

                if (int.parse(formData.tipToStand) > 2359) {
                  ISAlert(context, '마감시간은 최대 23:59 입니다.');
                  return;
                }

                if (int.parse(formData.tipToStand.substring(2,4)) > 59) {
                  ISAlert(context, '[마감시간] 잘못된 시간형식 입니다.');
                  return;
                }
              }


            }
            else if (formData.tipGbn == '3') {
              formData.tipToStand = '0'; //(int.parse(formData.tipFromStand) + 1).toString();

              if(int.parse(formData.tipFromStand) % 100 != 0)
              {
                ISAlert(context, '100 원 단위의 금액만 입력 가능합니다.');
                return;
              }
            }
            else if (formData.tipGbn == '9') {
              formData.tipToStand = '0';
            }

            String titleStr = '배달팁 변경';
            String commentStr = '변경된 정보를 저장합니다.';

            if (widget.sData == null) {
              titleStr = '배달팁 등록';
              commentStr = '새로운 배달팁을 등록합니다.';
            }

            formData.shopCd = widget.shopCode;

            formData.modUCode = GetStorage().read('logininfo')['uCode'];
            formData.modName = GetStorage().read('logininfo')['name'];

            if (widget.sData == null) {
              //print('new formData--> '+formData.toJson().toString());
              ShopController.to.postDeliTipData(formData.toJson(), context);
            } else {
              //print('edit formData--> '+formData.toJson().toString());
              ShopController.to.putDeliTipData(formData.toJson(), context);
            }

            Navigator.pop(context, formData.tipGbn);
          },
        ),
        ISButton(
          label: '취소',
          iconData: Icons.cancel,
          onPressed: () {
            Navigator.pop(context);
            formKey.currentState.reset();
          },
        )
      ],
    );

    var result = Scaffold(
      appBar: AppBar(
        title: Text(widget.sData == null ? '배달팁 등록' : '배달팁 수정'),
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
      width: 360,
      height: 240,
      child: result,
    );
  }

  List<Widget> getEditWidget() {
    List<Widget> retList;

    if (formData.tipGbn == '7')
      retList = getTimeTipEditWidget();
    else if (formData.tipGbn == '3')
      retList = getCostTipEditWidget();
    else if (formData.tipGbn == '9')
      retList = getLocalTipEditWidget();

    return retList;
  }

  List<Widget> getTimeTipEditWidget() {
    return <Widget>[
      Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: ISSelect(
              label: '영업일',
              value: formData.tipDay,
              dataList: selectBox_day,
              onChange: (v) {
                formData.tipDay = v;
              },
              onSaved: (v) {
                //formData.cLevel = v;
              },
            ),
          ),
          Flexible(
            flex: 1,
            child: ISInput(
              autofocus: true,
              value: formData.tipAmt == null ? '' : Utils.getCashComma(formData.tipAmt) ?? '',
              label: '배달팁',
              prefixIcon: Icon(Icons.money, color: Colors.grey,),
              context: context,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                MultiMaskedTextInputFormatter(masks: ['x,xxx', 'xx,xxx', 'xxx,xxx'], separator: ',')
              ],
              onChange: (v) {
                setState(() {
                  formData.tipAmt = v.toString().replaceAll(',', '');
                });
              },
              // validator: (v) {
              //   return v.isEmpty ? '[필수] 배달팁' : null;
              // },
            ),
          ),
        ],
      ),
      Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: ISInput(
              value: Utils.getTimeFormat(formData.tipFromStand) ?? '',
              context: context,
              label: '오픈시간',
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                MultiMaskedTextInputFormatter(masks: ['x:xx', 'xx:xx'], separator: ':')
              ],
              prefixIcon: Icon(Icons.confirmation_number, color: Colors.grey,),
              onChange: (v) {
                formData.tipFromStand = v.toString().replaceAll(':', '');
              },
              validator: (v) {
                return v.isEmpty ? '[필수] 오픈시간' : null;
              },
            ),
          ),
          Flexible(
            flex: 1,
            child: ISInput(
              value: Utils.getTimeFormat(formData.tipToStand) ?? '',
              context: context,
              label: '마감시간',
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                MultiMaskedTextInputFormatter(masks: ['x:xx', 'xx:xx'], separator: ':')
              ],
              prefixIcon: Icon(Icons.confirmation_number, color: Colors.grey,),
              onChange: (v) {
                formData.tipToStand = v.toString().replaceAll(':', '');
              },
              validator: (v) {
                return v.isEmpty ? '[필수] 마감시간' : null;
              },
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> getCostTipEditWidget() {
    return <Widget>[
      ISInput(
        autofocus: true,
        value: formData.tipFromStand == null ? '' : Utils.getCashComma(formData.tipFromStand) ?? '', //
        context: context,
        label: '금액',
        prefixIcon: Icon(Icons.confirmation_number, color: Colors.grey,),
        onChange: (v) {
          setState(() {
            formData.tipFromStand = v.toString().replaceAll(',', '');
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
      ISInput(
        value: formData.tipAmt == null ? '' : Utils.getCashComma(formData.tipAmt) ?? '', //formData. ?? '',
        context: context,
        label: '배달팁',
        prefixIcon: Icon(Icons.money, color: Colors.grey,),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          MultiMaskedTextInputFormatter(masks: ['x,xxx', 'xx,xxx', 'xxx,xxx'], separator: ',')
        ],
        onChange: (v) {
          setState(() {
            formData.tipAmt = v.toString().replaceAll(',', '');
          });
        },
        // validator: (v) {
        //   return v.isEmpty ? '[필수] 배달팁' : null;
        // },
      ),
    ];
  }

  List<Widget> getLocalTipEditWidget() {
    return <Widget>[
      ISInput(
        //autofocus: true,
        readOnly: true,
        value: formData.tipFromStand ?? '',
        context: context,
        label: '동명',
        prefixIcon: Icon(Icons.confirmation_number, color: Colors.grey,),
        onChange: (v) {
          formData.tipFromStand = v;
        },
        validator: (v) {
          return v.isEmpty ? '[필수] 동명' : null;
        },
      ),
      ISInput(
        autofocus: true,
        value: formData.tipAmt == null ? '' : Utils.getCashComma(formData.tipAmt) ?? '', //formData.tipAmt ?? '',
        context: context,
        label: '배달팁',
        prefixIcon: Icon(Icons.money, color: Colors.grey,),
        onChange: (v) {
          setState(() {
            formData.tipAmt = v.toString().replaceAll(',', '');
          });
        },
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          MultiMaskedTextInputFormatter(masks: ['x,xxx', 'xx,xxx', 'xxx,xxx'], separator: ',')
        ],
        // validator: (v) {
        //   return v.isEmpty ? '[필수] 배달팁' : null;
        // },
      ),
    ];
  }
}
