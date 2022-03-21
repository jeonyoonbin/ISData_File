

import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/Model/coupon/B2BUsercouponDetailModel.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/View/CouponManager/coupon_controller.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';


class B2BUserCouponRegist extends StatefulWidget {
  const B2BUserCouponRegist({Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return B2BUserCouponRegistState();
  }
}

class B2BUserCouponRegistState extends State<B2BUserCouponRegist> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  B2BUsercouponDetailModel formData = B2BUsercouponDetailModel();

  List<SelectOptionVO> selectBox_couponType = [];

  setDropDown() async {
    selectBox_couponType.clear();

    await CouponController.to.getDataB2BCodeItems(context).then((value) {
      if(value == null){
        ISAlert(context, '쿠폰정보를 가져오지 못했습니다. \n\n관리자에게 문의 바랍니다');
      }
      else{
        value.forEach((element) {
          selectBox_couponType.add(new SelectOptionVO(value: element['code'], label: '[${element['code']}] '+element['codeName']));
        });
      }
    });

    setState(() {});
  }

  _reset() {
    formData.USE_YN = 'Y';
    formData.NAME = '';
    formData.LOGIN_ID = '';
    formData.LOGIN_PWD = '';
    formData.MOBILE = '';
    formData.COUPON_TYPE = '';

    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();

    Get.put(CouponController());

    WidgetsBinding.instance.addPostFrameCallback((c) {
      setDropDown();
      _reset();
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
          visible: true,//formData.RETIRE_DATE == null ? true : false,
          child: ISButton(
            label: '저장',
            iconData: Icons.save,
            onPressed: () async {
              FormState form = formKey.currentState;
              if (!form.validate()) {
                return;
              }

              form.save();

              //print('regist formData.toJson():${formData.toJson().toString()}');

              if (formData.COUPON_TYPE == null || formData.COUPON_TYPE == ''){
                ISAlert(context, '쿠폰타입을 확인해주세요.');
                return;
              }

              if (formData.NAME == null || formData.NAME == ''){
                ISAlert(context, '회원명을 확인해주세요.');
                return;
              }

              if (formData.MOBILE == null || formData.MOBILE == ''){
                ISAlert(context, '연락처를 확인해주세요.');
                return;
              }

              if (formData.LOGIN_ID == null || formData.LOGIN_ID == ''){
                ISAlert(context, '로그인 아이디를 확인해주세요.');
                return;
              }

              if (formData.LOGIN_PWD == null || formData.LOGIN_PWD == ''){
                ISAlert(context, '로그인 패스워드를 확인해주세요.');
                return;
              }

              String validatePass = Utils.validatePassword(formData.LOGIN_PWD);
              if (validatePass != null){
                ISAlert(context, '${validatePass}');
                return;
              }

              await CouponController.to.postB2BUserData(formData.toJson()).then((value) {
                if (value != null) {
                  ISAlert(context, value);
                  return;
                }
                else
                  Navigator.pop(context, true);
              });
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
        title: Text('제휴 쿠폰 처리자 등록'),
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
      width: 400,
      height: 360,
      child: result,
    );
  }

  Widget getInfoView() {
    return Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
          Row(
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: new BoxDecoration(
                      color: formData.USE_YN == 'Y' ? Colors.blue[200] : Colors.red[200],
                      borderRadius: new BorderRadius.circular(6)),
                  child: SwitchListTile(
                    dense: true,
                    value: formData.USE_YN == 'Y' ? true : false,
                    title: Text('사용여부', style: TextStyle(fontSize: 12, color: Colors.white),),
                    onChanged: (v) {
                      // setState(() {
                      //   formData.USE_YN = v ? 'Y' : 'N';
                      //   formKey.currentState.save();
                      // });
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: ISSelect(
                  label: '쿠폰타입',
                  value: formData.COUPON_TYPE,
                  dataList: selectBox_couponType,
                  onChange: (v) {
                    setState(() {
                      formData.COUPON_TYPE = v;
                      //print('formData.COUPON_TYPE:${formData.COUPON_TYPE}');

                      formKey.currentState.save();
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Flexible(
                  flex: 1,
                  child: ISInput(
                    textStyle: TextStyle(fontSize: 12),
                    label: '회원명',
                    value: formData.NAME.toString() ?? '',
                    // height: 64,
                    // maxLength: 10,
                    onChange: (v){
                      formData.NAME = v;
                    },
                  )
              ),
              Flexible(
                  flex: 1,
                  child: ISInput(
                    textStyle: TextStyle(fontSize: 12),
                    label: '연락처',
                    value: formData.MOBILE.toString() ?? '',
                    // height: 64,
                    // maxLength: 12,
                    onChange: (v){
                      formData.MOBILE = v;
                    },
                  )
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Flexible(
                  flex: 1,
                  child: ISInput(
                    textStyle: TextStyle(fontSize: 12),
                    label: '로그인아이디',
                    value: formData.LOGIN_ID.toString() ?? '',
                    onChange: (v){
                      formData.LOGIN_ID = v;
                    },
                  )
              ),
              Flexible(
                  flex: 1,
                  child: ISInput(
                    textStyle: TextStyle(fontSize: 12),
                    label: '로그인패스워드',
                    obscureText: true,
                    value: formData.LOGIN_PWD.toString() ?? '',
                    onChange: (v){
                      formData.LOGIN_PWD = v;
                    },
                  )
              ),
            ],
          ),
        ],
      ),
    );
  }
}
