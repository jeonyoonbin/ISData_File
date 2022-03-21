

import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/ISWidget/is_select_date.dart';
import 'package:daeguro_admin_app/Model/coupon/couponBrandAppListModel.dart';
import 'package:daeguro_admin_app/Model/coupon/couponBrandCodeList.dart';
import 'package:daeguro_admin_app/Model/coupon/couponTypeList.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/Util/multi_masked_formatter.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/View/CouponManager/coupon_controller.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';


class BrandCouponAppEdit extends StatefulWidget {
  final String couponType;

  const BrandCouponAppEdit({Key key, this.couponType})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BrandCouponAppEditState();
  }
}

class BrandCouponAppEditState extends State<BrandCouponAppEdit> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  couponBrandAppListModel formData = couponBrandAppListModel();

  List<SelectOptionVO> BrandNameItems = [];
  List<SelectOptionVO> BrandCouponTypeItems = [];

  String _chainCode = ' ';
  String _couponType = ' ';
  String _startDate = '';
  String _endDate = '';

  loadBrandListData() async {
    BrandNameItems.clear();

    await CouponController.to.getBrandListItems().then((value) {
      BrandNameItems.add(new SelectOptionVO(value: ' ', label: '', label2: '',));

      value.forEach((element) {
        CouponBrandCodeListModel tempData = CouponBrandCodeListModel.fromJson(element);

        //ChainListItems.add(new SelectOptionVO(value: tempData.CODE, label: '[' + tempData.CODE + '] ' + tempData.CODE_NM, label2: tempData.CODE_NM,));
        BrandNameItems.add(new SelectOptionVO(value: tempData.CODE, label: tempData.CODE_NM, label2: tempData.CODE_NM,));
      });

      setState(() {
      });
    });
  }

  loadBrandCouponListData(String _chainCode) async {
    BrandCouponTypeItems.clear();

    await CouponController.to.getBrandCouponListItems(_chainCode).then((value) {
      BrandCouponTypeItems.add(new SelectOptionVO(value: ' ', label: '', label2: '',));

      value.forEach((element) {
        CouponTypeListModel tempData = CouponTypeListModel.fromJson(element);

        //ChainCouponListItems.add(new SelectOptionVO(value: tempData.CODE, label: '[' + tempData.CODE + '] ' + tempData.CODE_NM, label2: tempData.CODE_NM,));
        //BrandCouponTypeItems.add(new SelectOptionVO(value: tempData.CODE, label: tempData.CODE_NM, label2: tempData.CODE_NM,));
        BrandCouponTypeItems.add(new SelectOptionVO(value: tempData.CODE, label: '[${tempData.CODE}] '+ tempData.CODE_NM, label2: '[${tempData.CODE}] '+ tempData.CODE_NM));
      });

      setState(() {
      });
    });
  }

  loadData() async {
    await CouponController.to.getBrandCouponAppDetail(widget.couponType).then((value) {
      if (this.mounted) {
        if (value == null) {
          //print('value is NULL');
          ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
        }
        else{
          formData = couponBrandAppListModel.fromJson(value);

          _chainCode = formData.CHAIN_CODE;
          _couponType = formData.COUPON_TYPE;

          // if (formData.REG_DATE == 'null' || formData.REG_DATE == null)
          //   formData.REG_DATE = '';
          // else
          //   formData.REG_DATE = formData.REG_DATE.replaceAll('T', '  ');
          //
          // if (formData.MOD_DATE == 'null' || formData.MOD_DATE == null)
          //   formData.MOD_DATE = '';
          // else
          //   formData.MOD_DATE = formData.MOD_DATE.replaceAll('T', '  ');
          //
          // if (formData.REG_NAME == 'null' || formData.REG_NAME == null)
          //   formData.REG_NAME = '';
          //
          // if (formData.MOD_NAME == 'null' || formData.MOD_NAME == null)
          //   formData.MOD_NAME = '';
          //
          // formData.LOGIN_PWD = '';

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

  @override
  void initState() {
    super.initState();

    Get.put(CouponController());

    WidgetsBinding.instance.addPostFrameCallback((c) {
      loadBrandListData();
      loadBrandCouponListData('');
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
          visible: (AuthUtil.isAuthEditEnabled('29') == true),//formData.RETIRE_DATE == null ? true : false,
          child: ISButton(
            label: '저장',
            iconData: Icons.save,
            onPressed: () async {
              FormState form = formKey.currentState;
              if (!form.validate()) {
                return;
              }

              form.save();

              // String validatePass = Utils.validatePassword(formData.LOGIN_PWD);
              // if (validatePass != null){
              //   ISAlert(context, '${validatePass}');
              //   return;
              // }

              await CouponController.to.putBrandCouponAppData(formData.toJson()).then((value) {
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
        Visibility(
          visible: (AuthUtil.isAuthDeleteEnabled('29') == true),
          child: ISButton(
            label: '삭제',
            iconData: Icons.remove_circle,
            onPressed: () {
              ISConfirm(context, '앱설정 삭제', '앱설정을 삭제 하시겠습니까?', (context) async {
                CouponController.to.deleteBrandCouponAppData(context, formData.COUPON_TYPE);
                Navigator.pop(context);
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
        title: Text('브랜드 앱설정 상세'),
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
      width: 450,
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
            children: [
              Flexible(
                flex: 2,
                child: ISSelect(
                  ignoring: true,
                  label: '브랜드 구분',
                  value: _chainCode,
                  dataList: BrandNameItems,
                  onChange: (value) {
                    BrandNameItems.forEach((element) {
                      if (value == element.value) {
                        _chainCode = element.value;

                        formData.CHAIN_CODE = _chainCode;
                      }
                    });

                    _couponType = ' ';

                    loadBrandCouponListData(value);

                    // setState(() {
                    //   formData.couponType = value;
                    //
                    //   formKey.currentState.save();
                    // });
                  },
                ),
              ),
              Flexible(
                flex: 3,
                child: ISSelect(
                  ignoring: true,
                  label: '쿠폰 타입',
                  value: _couponType,//formData.couponType,
                  dataList: BrandCouponTypeItems,
                  onChange: (value) {
                    BrandCouponTypeItems.forEach((element) {
                      if (value == element.value) {
                        _couponType = element.value;

                        formData.COUPON_TYPE = _couponType;
                      }
                    });
                    // setState(() {
                    //   formData.couponType = value;
                    //
                    //   formKey.currentState.save();
                    // });
                  },
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: new BoxDecoration(
                      color: formData.DELIVERY_YN == 'Y' ? Colors.blue[200] : Colors.red[200],
                      borderRadius: new BorderRadius.circular(6)),
                  child: SwitchListTile(
                    dense: true,
                    value: formData.DELIVERY_YN == 'Y' ? true : false,
                    title: Text('배달주문 사용', style: TextStyle(fontSize: 12, color: Colors.white),),
                    onChanged: (v) {
                      setState(() {
                        formData.DELIVERY_YN = v ? 'Y' : 'N';
                        formKey.currentState.save();
                      });
                    },
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: new BoxDecoration(
                      color: formData.PACK_YN == 'Y' ? Colors.blue[200] : Colors.red[200],
                      borderRadius: new BorderRadius.circular(6)),
                  child: SwitchListTile(
                    dense: true,
                    value: formData.PACK_YN == 'Y' ? true : false,
                    title: Text('포장주문 사용', style: TextStyle(fontSize: 12, color: Colors.white),),
                    onChanged: (v) {
                      setState(() {
                        formData.PACK_YN = v ? 'Y' : 'N';
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
                child: ISInput(
                  autofocus: true,
                  value: Utils.getCashComma(formData.ORDER_MIN_AMT.toString()),
                  label: '최소 주문 금액(숫자만 입력)',
                  // validator: (v) {
                  //   return v.isEmpty ? '수량을 입력해주세요' : null;
                  // },
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    MultiMaskedTextInputFormatter(masks: ['x,xxx', 'xx,xxx', 'xxx,xxx'], separator: ',')
                  ],
                  onChange: (v) {
                    setState(() {
                      formData.ORDER_MIN_AMT = v.toString().replaceAll(',', '');
                    });
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: ISInput(
                  autofocus: true,
                  value: Utils.getCashComma(formData.PAY_MIN_AMT.toString()),
                  label: '최소 결제 금액(숫자만 입력)',
                  // validator: (v) {
                  //   return v.isEmpty ? '수량을 입력해주세요' : null;
                  // },
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    MultiMaskedTextInputFormatter(masks: ['x,xxx', 'xx,xxx', 'xxx,xxx'], separator: ',')
                  ],
                  onChange: (v) {
                    setState(() {
                      formData.PAY_MIN_AMT = v.toString().replaceAll(',', '');
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: ISSelectDate(
                  context,
                  label: '발급가능 시작일',
                  value: formData.DISPLAY_ST_DATE,
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
                        formData.DISPLAY_ST_DATE = formatDate(picked, [yyyy, '-', mm, '-', dd]);
                        _startDate = formatDate(picked, [yyyy, '', mm, '', dd]);
                      }
                    });

                    formKey.currentState.save();
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: ISSelectDate(
                  context,
                  label: '발급가능 종료일',
                  value: formData.DISPLAY_EXP_DATE,
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
                        formData.DISPLAY_EXP_DATE = formatDate(picked, [yyyy, '-', mm, '-', dd]);
                        _endDate = formatDate(picked, [yyyy, '', mm, '', dd]);
                      }
                    });

                    formKey.currentState.save();
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
                  value: formData.INS_UCODE,
                  readOnly: true,
                  label: '등록자 ID',
                  onSaved: (v) {
                    formData.INS_UCODE = v;
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: ISInput(
                  value: formData.INS_NAME,
                  readOnly: true,
                  label: '등록자 명',
                  onSaved: (v) {
                    formData.INS_NAME = v;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
