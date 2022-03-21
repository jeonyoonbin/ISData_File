

import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/Model/coupon/couponBrandCodeList.dart';
import 'package:daeguro_admin_app/Model/coupon/couponEditModel.dart';
import 'package:daeguro_admin_app/Model/coupon/couponTypeList.dart';
import 'package:daeguro_admin_app/View/CouponManager/coupon_controller.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';



class BrandCouponChange extends StatefulWidget {
  const BrandCouponChange({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BrandCouponChangeState();
  }
}

class BrandCouponChangeState extends State<BrandCouponChange> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  couponEditModel formData;
  String _couponCnt;

  List<SelectOptionVO> BrandNameItems = [];
  List<SelectOptionVO> BrandCouponTypeItems = [];

  List<SelectOptionVO> selectBox_status = [
    new SelectOptionVO(value: '00', label: '대기'),
    new SelectOptionVO(value: '10', label: '승인'),
    new SelectOptionVO(value: '20', label: '발행(회원)'),
    new SelectOptionVO(value: '30', label: '사용(회원)'),
    new SelectOptionVO(value: '99', label: '폐기'),
  ];

  //List<SelectOptionVO> selectBox_couponType = List();

  String _chainCode = ' ';
  String _couponType = ' ';

  // loadTypeData() async {
  //   await CouponController.to.getDataB2BCodeItems(context);
  //
  //   //print('codeList:${CouponController.to.qB2BDataItems.toString()}');
  //
  //   //codeItems = CouponController.to.qB2BDataItems;
  //   CouponController.to.qB2BDataItems.forEach((element) {
  //     selectBox_couponType.add(new SelectOptionVO(value: element['code'], label: element['codeName']));
  //   });
  //
  //   setState(() {});
  // }

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
        BrandCouponTypeItems.add(new SelectOptionVO(value: tempData.CODE, label: '[${tempData.CODE}] '+ tempData.CODE_NM, label2: '[${tempData.CODE}] '+ tempData.CODE_NM));
      });

      setState(() {
      });
    });
  }

  @override
  void initState() {
    super.initState();

    Get.put(CouponController());


    // CouponController.to.qDataItems.forEach((element) {
    //   selectBox_couponType.add(new SelectOptionVO(
    //       value: element['code'], label: element['codeName']));
    // });

    formData = couponEditModel();

    formData.couponType = '';
    formData.jobUcode = GetStorage().read('logininfo')['uCode'];
    formData.jobName = GetStorage().read('logininfo')['name'];

    WidgetsBinding.instance.addPostFrameCallback((c) {
      loadBrandListData();
      loadBrandCouponListData('');
    });
  }

  @override
  void dispose() {
    // selectBox_couponType.clear();
    // selectBox_couponType = null;
    formData = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
          Row(
            children: [
              Flexible(
                flex: 2,
                child: ISSelect(
                  label: '브랜드 구분',
                  value: _chainCode,
                  dataList: BrandNameItems,
                  onChange: (value) {
                    BrandNameItems.forEach((element) {
                      if (value == element.value) {
                        _chainCode = element.value;

                        //formData.chainCode = _chainCode;
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
                  label: '쿠폰 타입',
                  value: _couponType,//formData.couponType,
                  dataList: BrandCouponTypeItems,
                  onChange: (value) {
                    BrandCouponTypeItems.forEach((element) {
                      if (value == element.value) {
                        _couponType = element.value;

                        formData.couponType = _couponType;
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
              // Flexible(
              //   flex: 1,
              //   child: ISSelect(
              //     label: '쿠폰종류',
              //     value: formData.couponType,
              //     dataList: selectBox_couponType,
              //     onChange: (value) {
              //       setState(() {
              //         formData.couponType = value;
              //         formKey.currentState.save();
              //       });
              //     },
              //   ),
              // ),

            ],
          ),
          Row(
            children: <Widget>[
              Flexible(
                flex: 3,
                child: ISInput(
                  autofocus: true,
                  padding: 10,
                  value: formData.couponCount,
                  label: '발행수량',
                  // validator: (v) {
                  //   return v.isEmpty ? '수량을 입력해주세요' : null;
                  // },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                  onSaved: (v) {
                    formData.couponCount = v;
                  },
                ),
              ),
              Flexible(
                flex: 4,
                child: ISSelect(
                  label: '변경 전 상태',
                  value: formData.oldStatus,
                  dataList: selectBox_status,
                  onSaved: (v) {
                    formData.oldStatus = v;
                  },
                ),
              ),
              Flexible(
                flex: 4,
                child: ISSelect(
                  label: '변경 후 상태',
                  value: formData.newStatus,
                  dataList: selectBox_status,
                  onSaved: (v) {
                    formData.newStatus = v;
                  },
                ),
              ),
            ],
          ),

          // Row(
          //   children: <Widget>[
          //     Flexible(
          //       flex: 1,
          //       child: ISInput(
          //         value: formData.jobUcode,
          //         readOnly: true,
          //         label: '변경자 ID',
          //         onSaved: (v) {
          //           formData.jobUcode = v;
          //         },
          //       ),
          //     ),
          //     Flexible(
          //       flex: 1,
          //       child: ISInput(
          //         value: formData.jobName,
          //         readOnly: true,
          //         label: '변경자 명',
          //         onSaved: (v) {
          //           formData.jobName = v;
          //         },
          //       ),
          //     ),
          //   ],
          // ),

        ],
      ),
    );

    ButtonBar buttonBar = ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        ISButton(
          label: '저장',
          iconData: Icons.save,
          onPressed: () async {
            FormState form = formKey.currentState;
            if (!form.validate()) {
              return;
            }

            form.save();

            if (formData.couponType == null || formData.couponType == ''){
              ISAlert(context, '쿠폰 타입을 확인해주세요.');
              return;
            }

            if (formData.couponCount == null || formData.couponCount == ''){
              ISAlert(context, '수량을 확인해주세요.');
              return;
            }

            if (formData.oldStatus == null || formData.oldStatus == ''){
              ISAlert(context, '변경 전 상태를 확인해주세요.');
              return;
            }

            if (formData.newStatus == null || formData.newStatus == ''){
              ISAlert(context, '변경 후 상태를 확인해주세요.');
              return;
            }

            formData.jobUcode = GetStorage().read('logininfo')['uCode'];
            formData.jobName = GetStorage().read('logininfo')['name'];

            await CouponController.to.putBrandData(formData.toJson()).then((value) {
              Navigator.pop(context, value);
            });
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
        title: Text('브랜드 쿠폰 상태 변경'),
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
      width: 450,
      height: 260,
      child: result,
    );
  }
}
