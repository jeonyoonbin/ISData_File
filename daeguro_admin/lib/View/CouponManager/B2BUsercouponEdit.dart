

import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/Model/coupon/B2BUsercouponDetailModel.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/View/CouponManager/coupon_controller.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';


class B2BUserCouponEdit extends StatefulWidget {
  final String userId;

  const B2BUserCouponEdit({Key key, this.userId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return B2BUserCouponEditState();
  }
}

class B2BUserCouponEditState extends State<B2BUserCouponEdit> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  B2BUsercouponDetailModel formData = B2BUsercouponDetailModel();

  List<SelectOptionVO> selectBox_couponType = [];

  loadData() async {
    await CouponController.to.getB2BUserDetailCoupon(widget.userId).then((value) {
      if (this.mounted) {
        if (value == null) {
          //print('value is NULL');
          ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
        }
        else{
          formData = B2BUsercouponDetailModel.fromJson(value);

          if (formData.REG_DATE == 'null' || formData.REG_DATE == null)
            formData.REG_DATE = '';
          else
            formData.REG_DATE = formData.REG_DATE.replaceAll('T', '  ');

          if (formData.MOD_DATE == 'null' || formData.MOD_DATE == null)
            formData.MOD_DATE = '';
          else
            formData.MOD_DATE = formData.MOD_DATE.replaceAll('T', '  ');

          if (formData.REG_NAME == 'null' || formData.REG_NAME == null)
            formData.REG_NAME = '';

          if (formData.MOD_NAME == 'null' || formData.MOD_NAME == null)
            formData.MOD_NAME = '';

          formData.LOGIN_PWD = '';

          setState(() {
            // if (formData.INSERT_DATE != null)
            //   formData.INSERT_DATE = formData.INSERT_DATE.replaceAll('T', '  ');
            //
            // if (formData.DEL_DATE != null)
            //   formData.DEL_DATE = formData.DEL_DATE.replaceAll('T', '  ');
            //
            // if(formData.DEL_DATE == null && formData.RETIRE_DATE != null)
            //   _RetireGbn = 'Y';
          });
        }
      }
    });
  }

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

  @override
  void initState() {
    super.initState();

    Get.put(CouponController());

    WidgetsBinding.instance.addPostFrameCallback((c) {
      setDropDown();
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
          visible: (AuthUtil.isAuthEditEnabled('28') == true),//formData.RETIRE_DATE == null ? true : false,
          child: ISButton(
            label: '저장',
            iconData: Icons.save,
            onPressed: () async {
              FormState form = formKey.currentState;
              if (!form.validate()) {
                return;
              }

              form.save();

              String validatePass = Utils.validatePassword(formData.LOGIN_PWD);
              if (validatePass != null){
                ISAlert(context, '${validatePass}');
                return;
              }

              await CouponController.to.putB2BUserData(formData.toJson()).then((value) {
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
        title: Text('제휴 쿠폰 처리자 정보'),
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
      height: 460,
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
                      setState(() {
                        formData.USE_YN = v ? 'Y' : 'N';
                        formKey.currentState.save();
                      });
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
                    label: '회원아이디',
                    readOnly: true,
                    // height: 64,
                    // maxLength: 10,
                    value: formData.USER_ID.toString() ?? '',
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                    ],
                    onChange: (v) {
                      formData.USER_ID = int.parse(v);
                    },
                  ),
              ),
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
                    // height: 64,
                    // maxLength: 12,
                    value: formData.MOBILE,
                    onChange: (v){
                      formData.MOBILE = v.toString().replaceAll('-', '');
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
                    //validator: (v) => Utils.validatePassword(v),
                  )
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Flexible(flex: 1, child: ISInput(readOnly: true, textStyle: TextStyle(fontSize: 12), label: '등록일', value: formData.REG_DATE.toString() ?? '',)),
              Flexible(flex: 1, child: ISInput(readOnly: true, textStyle: TextStyle(fontSize: 12), label: '등록자', value: '[${formData.REG_UCODE.toString()}] ${formData.REG_NAME}')),
            ],
          ),
          Row(
            children: <Widget>[
              Flexible(flex: 1, child: ISInput(readOnly: true, textStyle: TextStyle(fontSize: 12), label: '수정일', value: formData.MOD_DATE.toString() ?? '',)),
              Flexible(flex: 1, child: ISInput(readOnly: true, textStyle: TextStyle(fontSize: 12), label: '수정자', value: '[${formData.MOD_UCODE.toString()}] ${formData.MOD_NAME}')),
            ],
          ),
        ],
      ),
    );
  }
}
