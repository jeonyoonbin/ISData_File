import 'dart:convert';

import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopDetailNotifierData.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/Model/shop/shop_bankcode.dart';
import 'package:daeguro_admin_app/Model/shop/shopcalc_info.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ShopCalcInfo extends StatefulWidget {
  final Stream<ShopDetailNotifierData> stream;
  final Function callback;
  //final ShopDetailNotifierData detailData;

  const ShopCalcInfo({Key key, this.stream, this.callback}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShopCalcInfoState();
  }
}

class ShopCalcInfoState extends State<ShopCalcInfo> with AutomaticKeepAliveClientMixin{
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ShopCalcInfoModel formData = ShopCalcInfoModel();
  List<SelectOptionVO> selectBox_BankCode = [];
  ShopDetailNotifierData detailData;
  bool isListSaveEnabled = false;
  bool isReceiveDataEnabled = false;



  void refreshWidget(ShopDetailNotifierData element){
    detailData = element;
    if (detailData != null) {
      //print('shopCalc refreshWidget() is not NULL -> [${element.selected_shopCode}]');

      loadData();

      isReceiveDataEnabled = true;
    }
    else{
      //print('shopCalc refreshWidget() is NULL');

      formData = null;
      formData = ShopCalcInfoModel();

      isReceiveDataEnabled = false;

      setState(() {
      });
    }
  }

  loadBankCodeData() async {
    selectBox_BankCode.clear();

    await ShopController.to.getDataBankItems().then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        value.forEach((element) {
          ShopBankCodeModel tempData = ShopBankCodeModel.fromJson(element);

          selectBox_BankCode.add(new SelectOptionVO(value: tempData.bankCode, label: tempData.bankName));
        });
      }
    });


  }

  loadData() async {
    await ShopController.to.getCalcData(detailData.selected_shopCode.toString()).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        formData = ShopCalcInfoModel.fromJson(value);
      }
    });

    //if (this.mounted) {
      setState(() {
      });
   // }
  }

  @override
  void initState() {
    super.initState();

    loadBankCodeData();

    // WidgetsBinding.instance.addPostFrameCallback((c) {
    //   loadData();
    // });
    //if (widget.streamIsInit == false){
      widget.stream.listen((element) {
        refreshWidget(element);
      });
    //}
  }

  @override
  void dispose() {
    formData = null;
    selectBox_BankCode.clear();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  Text('   정산 계좌', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                ],
              ),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: <Widget>[
              Flexible(
                flex: 2,
                child: ISSelect(
                  label: '은행명',
                  value: formData.bankCode ?? '',
                  dataList: selectBox_BankCode,
                  onChange: (v) {
                    formData.bankCode = v;
                    setState(() {});
                  },
                  onSaved: (v) {
                    //formData.cLevel = v;
                    setState(() {});
                  },
                ),
              ),
              Flexible(
                flex: 3,
                child: ISInput(
                  value: formData.accountNo ?? '',
                  label: '계좌번호',
                  context: context,
                  prefixIcon: Icon(Icons.account_balance_wallet, color: Colors.grey),
                  textStyle: TextStyle(fontSize: 14),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                  onChange: (v) {
                    formData.accountNo = v;
                  },
                ),
              ),
            ],
          ),
          ISInput(
            value: formData.accOwner ?? '',
            context: context,
            label: '예금주명',
            prefixIcon: Icon(Icons.account_box, color: Colors.grey),
            textStyle: TextStyle(fontSize: 14),
            onChange: (v) {
              formData.accOwner = v;
            },
          ),
          Container(
            height: 40,
            margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            decoration: new BoxDecoration(color: formData.payConfirm == 'Y' ? Colors.blue[200] : Colors.red[200], borderRadius: new BorderRadius.all(Radius.circular(6.0))),
            child: SwitchListTile(
              dense: true,
              value: formData.payConfirm == 'Y' ? true : false,
              title: Text('출금여부', style: TextStyle(fontSize: 12, color: Colors.white),),
              onChanged: (v) {
                setState(() {
                  formData.payConfirm = v ? 'Y' : 'N';
                  formKey.currentState.save();
                });
              },
            ),
          ),
          // ISInput(value: formData.remainAmt ?? '', width: 260, label: '출금가능여부', prefixIcon: Icon(Icons.money, color: Colors.grey,), textStyle: TextStyle(fontSize: 12),
          //   onChange: (v) {
          //     formData.remainAmt = v;
          //   },
          // ),
          Divider(),
        ],
      ),
    );

    return Column(
      children: [
        SizedBox(height: 50),
        buttonBar(),//(formData.bankCode == '' || formData == null) ? Container(height: 30) : buttonBar(),
        Container(
            padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),//EdgeInsets.all(8.0),
            child: form
        ),
      ],
    );
  }

  Widget buttonBar(){
    return Container(
      height: 30,
      padding: EdgeInsets.only(right: 16),
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedOpacity(
            opacity: isListSaveEnabled ? 1.0 : 0.0,
            duration: Duration(seconds: 1),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.red, size: 18,),
                Text('저장 완료', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
              ],
            ),
            onEnd: (){
              setState(() {
                isListSaveEnabled = false;
              });
            },
          ),
          SizedBox(width: 10,),
          ISButton(
            iconData: Icons.refresh,
            iconColor: Colors.white,
            tip: '갱신',
            onPressed: (){
              if (isReceiveDataEnabled == true) {
                loadData();
              }
            },
          ),
          SizedBox(width: 10,),
          if (AuthUtil.isAuthEditEnabled('96') == true)
          ISButton(
            label: '저장',
            iconData: Icons.save,
            iconColor: Colors.white,
            textStyle: TextStyle(color: Colors.white),
            //enable: (formData.bankCode == '' || formData == null) ? false : true,
            onPressed: () async {
              FormState form = formKey.currentState;
              if (!form.validate()) {
                return;
              }

              form.save();

              await ISProgressDialog(context).show(status: '예금주 확인중');

              var headerData = {
                "content-type": "application/json",
                //"Accept": "application/json",
              };

              // 기존
              //var bodyData = {'"bank_code"': '"' + formData.bankCode + '"', '"account_no"': '"' + formData.accountNo + '"', '"account_owner"': '"' + formData.accOwner + '"'};

              // 버전2 (2021-09-15)
              //var bodyData = {'"bankCd"': '"' + formData.bankCode + '"', '"accountNo"': '"' + formData.accountNo + '"', '"accountNm"': '"' + formData.accOwner + '"'};

              // admin rest
              var bodyData = {
                '"bankCode"': '"' + formData.bankCode + '"',
                '"accountNo"': '"' + formData.accountNo + '"',
                '"accOwner"': '"' + formData.accOwner + '"',
                '"modUCode"': '"' + GetStorage().read('logininfo')['uCode'] + '"',
                '"modName"': '"' + GetStorage().read('logininfo')['name'] + '"'
              };

              // controller 작업 진행 중
              //await ShopController.to.postCalcConfirmData(bodyData, formData.toJson(), detailData.selected_shopCode, context);

              await http
                  .post(Uri.parse(ServerInfo.REST_URL_SHOPCALC_CONFIRM), headers: headerData, body: bodyData.toString())
                  .then((http.Response response) async {
                //String responseBody = utf8.decode(res.bodyBytes);
                if (response.statusCode == 200) {
                  var decodeBody = jsonDecode(response.body);
                  //print('decodeStr: ' + decodeBody.toString());

                  print(decodeBody);

                  if (decodeBody['code'] == '0000') {
                    formData.modUCode = GetStorage().read('logininfo')['uCode'];
                    formData.modName = GetStorage().read('logininfo')['name'];
                    //print('formData--> '+formData.toJson().toString());

                    await ISProgressDialog(context).dismiss();

                    ShopController.to.putCalcData(formData.toJson(), context).then((value) {
                      if (value == '00') {
                        ShopController.to.postSetBankConfirm(detailData.selected_shopCode, 'Y', context);

                        //Navigator.pop(context, true);
                      } else
                        ShopController.to.postSetBankConfirm(detailData.selected_shopCode, 'N', context);

                      setState(()  {
                        isListSaveEnabled = true;
                      });
                    });

                    widget.callback();
                  } else {
                    await ISProgressDialog(context).dismiss();
                    ShopController.to.postSetBankConfirm(detailData.selected_shopCode, 'N', context);

                    //print(decodeBody);

                    ISAlert(context, '계좌 인증 오류 - [' + decodeBody['code'].toString() + ']\n\n' + decodeBody['msg'].toString() + ' 입니다.');
                }
                } else {
                  await ISProgressDialog(context).dismiss();

                  ISAlert(context, '계좌 인증 통신 오류 \n\n관리자에게 문의 바랍니다');
                }
              });
            },
          ),

        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}