

import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/Model/customer/customerInfoModel.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/CustomerManager/customerRetire.dart';
import 'package:daeguro_admin_app/View/CustomerManager/customer_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class CustomerInfo extends StatefulWidget {
  final String custCode;

  const CustomerInfo({Key key, this.custCode})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CustomerInfoState();
  }
}

class CustomerInfoState extends State<CustomerInfo> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CustomerInfoModel formData = CustomerInfoModel();

  String _RetireGbn = 'N';

  _retireCustomer({String cust_code }) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: CustomerRetire(custCode: cust_code,),
      ),
    ).then((v) async {
      //if (v != null) {
      await Future.delayed(Duration(milliseconds: 500), () {
        loadData();
      });
      //}
    });
  }

  loadData() async {
    await CustomerController.to.getInfoData(widget.custCode).then((value) {
      if (value == null) {
        //print('value is NULL');
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else{
        formData = CustomerInfoModel.fromJson(value);
        if (formData.INSERT_DATE != null)
          formData.INSERT_DATE = formData.INSERT_DATE.replaceAll('T', '  ');

        if (formData.DEL_DATE != null)
          formData.DEL_DATE = formData.DEL_DATE.replaceAll('T', '  ');

        if(formData.DEL_DATE == null && formData.RETIRE_DATE != null)
          _RetireGbn = 'Y';
      }

      setState(() {
      });

      // if (this.mounted) {
      //
      // }
    });


  }

  @override
  void initState() {
    super.initState();

    Get.put(CustomerController());

    WidgetsBinding.instance.addPostFrameCallback((c) {
      loadData();
    });
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ButtonBar buttonBar = ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        Visibility(
          visible: AuthUtil.isAuthEditEnabled('36') == true,//formData.RETIRE_DATE == null ? true : false,
          child: ISButton(
            label: '저장',
            iconData: Icons.save,
            onPressed: () async {
              FormState form = formKey.currentState;
              if (!form.validate()) {
                return;
              }

              form.save();

              await CustomerController.to.putJoinInfo(widget.custCode, formData.CUST_ID, formData.MEMO, GetStorage().read('logininfo')['uCode'], GetStorage().read('logininfo')['name'], context);

              Navigator.pop(context, true);

              // ISConfirm(context, '회원 가입내역 수정', '회원 가입내역을 수정 하시겠습니까?', (context) async {
              //   await CustomerController.to.putJoinInfo(widget.custCode, formData.CUST_ID, formData.MEMO, GetStorage().read('logininfo')['uCode'], GetStorage().read('logininfo')['name'], context);
              //   setState(() {});
              //
              //   Navigator.pop(context, true);
              // });
            },
          ),
        ),
        ISButton(
          label: '닫기',
          iconData: Icons.cancel,
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );

    var result = Scaffold(
      appBar: AppBar(
        title: Text('회원 가입내역'),
        actions: <Widget>[
          Visibility(
            visible: (formData.RETIRE_DATE == null && (AuthUtil.isAuthEditEnabled('217') == true)) ? true : false,
            child: Container(
              margin: EdgeInsets.all(10),
              child: MaterialButton(
                color: Colors.red[300],
                child: Text('회원탈퇴', style: TextStyle(color: Colors.white, fontSize: 14),),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                onPressed: () async {
                  _retireCustomer(cust_code: widget.custCode);
                },
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: getInfoView()
          ),
        ],
      ),
      bottomNavigationBar: buttonBar,
    );

    return SizedBox(
      width: 460,
      height: 600,
      child: result,
    );
  }

  Widget getInfoView() {
    return Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(flex: 1, child: ISInput(readOnly: true, textStyle: TextStyle(fontSize: 12), label: '회원명', value: formData.CUST_NAME ?? '', prefixIcon: Icon(Icons.person, color: Colors.grey,),)),
              Flexible(flex: 1, child: ISInput(readOnly: true, textStyle: TextStyle(fontSize: 12), label: '가입유형', value: formData.CUST_ID_GBN ?? '', )),
            ],
          ),
          Row(
            children: <Widget>[
              Flexible(flex: 1, child: ISInput(readOnly: true, textStyle: TextStyle(fontSize: 12), label: '연락처', value: Utils.getPhoneNumFormat(formData.TELNO, false)  ?? '', prefixIcon: Icon(Icons.phone_android, color: Colors.grey,),)),
              Flexible(flex: 1, child: ISInput(readOnly: true, textStyle: TextStyle(fontSize: 12), label: '생년월일', value: Utils.getBirthFormat(formData.BIRTHDAY, false)  ?? '', )),
            ],
          ),
          Row(
            children: <Widget>[
              //Flexible(flex: 1, child: ISInput(readOnly: true, textStyle: TextStyle(fontSize: 12), label: '아이디', value: formData.CUST_ID ?? '', )),
              Flexible(flex: 1,
                  child: ISInput(
                    readOnly: GetStorage().read('logininfo')['uCode'] == '35' // 전윤빈 대리
                        || GetStorage().read('logininfo')['uCode'] == '28' // 이나연 대리
                        || GetStorage().read('logininfo')['uCode'] == '183' // 이나연 대리
                        || GetStorage().read('logininfo')['uCode'] == '48' // 이성훈 과장
                        || GetStorage().read('logininfo')['uCode'] == '3' // 이인찬 부장
                        ? formData.CUST_ID_GBN == '네이버' ? false : false
                        : false,
                    width: 230,
                    textStyle: TextStyle(fontSize: 12),
                    label: '아이디',
                    value: formData.CUST_ID ?? '',
                    onChange: (v) {
                      formData.CUST_ID = v;
                      //setState(() {});
                    },
                  ),
              ),
              Flexible(flex: 1, child: ISInput(readOnly: true, textStyle: TextStyle(fontSize: 12), label: '패스워드', value: formData.CUST_PASSWORD ?? '', )),
            ],
          ),
          ISInput(readOnly: true, textStyle: TextStyle(fontSize: 12), label: '구 주소(지번)', value: formData.OLD_ADDR ?? '', prefixIcon: Icon(Icons.home, color: Colors.grey,),),
          ISInput(readOnly: true, textStyle: TextStyle(fontSize: 12), label: '신주소(도로명)', value: formData.NEW_ADDR ?? '', prefixIcon: Icon(Icons.home, color: Colors.grey,),),
          Row(
            children: <Widget>[
              Flexible(flex: 1, child: ISInput(readOnly: true, textStyle: TextStyle(fontSize: 12), label: '가입일', value: formData.INSERT_DATE ?? '',)),
              Flexible(flex: 1, child: ISInput(readOnly: true, textStyle: TextStyle(fontSize: 12), label: '탈퇴일', value: formData.DEL_DATE ?? '',)),
            ],
          ),
          ISInput(
            label: '메모',
            value: formData.MEMO ?? '',
            textStyle: TextStyle(fontSize: 12),
            maxLines: 8,
            height: 100,
            keyboardType: TextInputType.multiline,
            onChange: (v) {
              formData.MEMO = v;
            },
            prefixIcon: Icon(
              Icons.edit,
              color: Colors.grey,
            ),
          ),
          Visibility(
            visible: _RetireGbn == 'Y' ? true : false,
            child: Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Center(
                    child: Text('[회원 탈퇴 진행 중입니다. 익일 오전 탈퇴 처리 됩니다.]', style: TextStyle(color: Colors.red[400]),))),
          )
        ],
      ),
    );
  }
}
