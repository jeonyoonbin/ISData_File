import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/Model/coupon/B2BcouponHistoryModel.dart';
import 'package:daeguro_admin_app/Model/coupon/couponBrandDetailModel.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/CouponManager/coupon_controller.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class BrandCouponEdit extends StatefulWidget {
  final String couponNo;

  const BrandCouponEdit({Key key, this.couponNo}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BrandCouponEditState();
  }
}

class BrandCouponEditState extends State<BrandCouponEdit> with SingleTickerProviderStateMixin{
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  TabController _nestedTabController;

  ScrollController _scrollController;

  List<B2BcouponHistoryModel> dataHistoryList = <B2BcouponHistoryModel>[];

  couponBrandDetailModel formData = couponBrandDetailModel();


  loadData() async {
    _nestedTabController.index = 0;

    formData = null;
    formData = couponBrandDetailModel();

    dataHistoryList.clear();

    await CouponController.to.getBrandDetailCoupon(widget.couponNo).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else{
        formData = couponBrandDetailModel.fromJson(value);
      }
    });


    await CouponController.to.getBrandChangeData(widget.couponNo).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else{
        value.forEach((element) {
          B2BcouponHistoryModel tempData = B2BcouponHistoryModel.fromJson(element);
          dataHistoryList.add(tempData);
        });
      }
    });

    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();

    Get.put(CouponController());

    _nestedTabController = new TabController(length: 2, vsync: this);
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((c) {
      loadData();
    });
  }

  @override
  void dispose() {
    _nestedTabController.dispose();

    _scrollController.dispose();



    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[

        ],
      ),
    );

    ButtonBar buttonBar = ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        // ISButton(
        //   label: '저장',
        //   iconData: Icons.save,
        //   onPressed: () {
        //     FormState form = formKey.currentState;
        //     if (!form.validate()) {
        //       return;
        //     }
        //
        //     if (idchk_gbn == false) {
        //       ISAlert(context, '아이디 중복체크를 확인 바랍니다.');
        //       return;
        //     }
        //
        //     form.save();
        //
        //     if (formData.password == _passwordChk) {
        //       UserController.to.postData(formData.toJson(), context);
        //       Navigator.pop(context, true);
        //     } else {
        //       ISAlert(context, '비밀번호를 확인해 주세요.');
        //       //await EasyLoading.showError('비밀번호를 확인 하여 주십시오.', maskType: EasyLoadingMaskType.black, duration: Duration(seconds: 3), dismissOnTap: true);
        //     }
        //   },
        // ),
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
        title: Text('브랜드 쿠폰 상세'),
      ),
      body: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                child: Container(
                  height: 30.0,
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200, width: 2.0), borderRadius: BorderRadius.circular(5), color: Colors.grey.shade200,),
                  child: TabBar(
                    controller: _nestedTabController,
                    labelStyle: TextStyle(fontSize: 12, fontFamily: 'NotoSansKR'),
                    unselectedLabelColor: Colors.black45,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BubbleTabIndicator(
                      indicatorRadius: 5.0,
                      indicatorHeight: 25.0,
                      indicatorColor: Colors.blue,
                      tabBarIndicatorSize: TabBarIndicatorSize.tab,
                    ),
                    tabs: [
                      Tab(text: '기본정보',),
                      Tab(text: '변경이력',)
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 520,
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _nestedTabController,
                  children: [
                    Container(
                        padding: EdgeInsets.all(8.0),
                        child: getInfoTabView()
                    ),
                    Container(
                        padding: EdgeInsets.all(8.0),
                        child: getHistoryTabView()
                    ),
                  ],
                ),
              )
            ]
        ),
      ),
      bottomNavigationBar: buttonBar,
    );
    return SizedBox(
      width: 400,
      height: 680,
      child: result,
    );
  }

  Widget getInfoTabView() {
    return Scrollbar(
      isAlwaysShown: false,
      controller: _scrollController,
      child: ListView(
        controller: _scrollController,
        children: [
          Form(
            key: formKey,
            child: Wrap(
              children: <Widget>[
                ISInput(readOnly: true, textStyle: TextStyle(fontSize: 12), label: '쿠폰번호', value: formData.COUPON_NO ?? ''),
                Row(
                  children: <Widget>[
                    Flexible(flex: 1, child: ISInput(readOnly: true, textStyle: TextStyle(fontSize: 12), label: '쿠폰코드', value: formData.COUPON_TYPE ?? '')),
                    Flexible(flex: 1, child: ISInput(readOnly: true, textStyle: TextStyle(fontSize: 12), label: '쿠폰명', value: formData.COUPON_NAME ?? '', )),
                  ],
                ),
                Row(
                  children: <Widget>[
                    ISInput(readOnly: true, width: 80, textStyle: TextStyle(fontSize: 12), label: '승인유무', value: formData.CONF_YN ?? '', ),
                    Flexible(flex: 2, child: ISInput(readOnly: true, textStyle: TextStyle(fontSize: 12), label: '쿠폰상태', value: _getStatus(formData.STATUS ?? ''), )),
                    ISInput(readOnly: true, width: 100, textStyle: TextStyle(fontSize: 12), label: '인성부담금', value: Utils.getCashComma(formData.ISD_AMT ?? ''), ),
                    ISInput(readOnly: true, width: 100, textStyle: TextStyle(fontSize: 12), label: '타사부담금', value: Utils.getCashComma(formData.OTHER_AMT ?? ''), )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(flex: 1, child: ISInput(readOnly: true, textStyle: TextStyle(fontSize: 12), label: '사용고객코드', value: formData.USE_APP_CUST_CODE ?? '', )),
                    Flexible(flex: 1, child: ISInput(readOnly: true, textStyle: TextStyle(fontSize: 12), label: '사용고객명', value: formData.USE_CUST_NAME ?? '', )),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(flex: 1, child: ISInput(readOnly: true, textStyle: TextStyle(fontSize: 12), label: '고객명', value: formData.CUST_NAME ?? '', )),
                    Flexible(flex: 1, child: ISInput(readOnly: true, textStyle: TextStyle(fontSize: 12), label: '연락처', value: formData.TELNO ?? '', )),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(flex: 1, child: ISInput(readOnly: true, textStyle: TextStyle(fontSize: 12), label: '등록일', value: formData.INS_DATE ?? '', )),
                    Flexible(flex: 1, child: ISInput(readOnly: true, textStyle: TextStyle(fontSize: 12), label: '등록자', value: '[${formData.INS_UCODE}] ${formData.INS_NAME}')),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(flex: 1, child: ISInput(readOnly: true, textStyle: TextStyle(fontSize: 12), label: '승인일', value: formData.CONF_DATE ?? '', )),
                    Flexible(flex: 1, child: ISInput(readOnly: true, textStyle: TextStyle(fontSize: 12), label: '승인자', value: '[${formData.CONF_UCODE}] ${formData.CONF_NAME}')),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(flex: 1, child: ISInput(readOnly: true, textStyle: TextStyle(fontSize: 12), label: 'SMS발송일', value: formData.SMS_SEND_DATE ?? '', )),
                    Flexible(flex: 1, child: ISInput(readOnly: true, textStyle: TextStyle(fontSize: 12), label: 'SMS발송수', value: formData.SMS_SEND_CNT ?? '')),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(flex: 1, child: ISInput(readOnly: true, textStyle: TextStyle(fontSize: 12), label: 'PUSH발송일', value: formData.PUSH_SEND_DATE ?? '', )),
                    Flexible(flex: 1, child: ISInput(readOnly: true, textStyle: TextStyle(fontSize: 12), label: 'PUSH발송수', value: formData.PUSH_SEND_CNT ?? '')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getHistoryTabView() {
    return ListView.builder(
      controller: _scrollController,
      //padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      itemCount: dataHistoryList.length,
      itemBuilder: (BuildContext context, int index) {
        return dataHistoryList != null ? GestureDetector(
          child: Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: Row(
                children: [
                  //Text('No.' + imageHistoryList[index].no.toString() ?? '--', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Container(
                      width: 340,
                      padding: EdgeInsets.only(top: 5),
                      child: SelectableText(dataHistoryList[index].memo ?? '--', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87), showCursor: true,)
                  ),
                ],
              ),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      alignment: Alignment.centerRight,
                      child: Text(dataHistoryList[index].histDate ?? '--', style: TextStyle(fontSize: 12), textAlign: TextAlign.right)
                  )
                ],
              ),
            ),
          ),
        ) : Text('Data is Empty');
      },
    );
  }

  String _getStatus(String value) {
    String retValue = '--';

    if (value.toString().compareTo('00') == 0)
      retValue = '대기';
    else if (value.toString().compareTo('10') == 0)
      retValue = '승인';
    else if (value.toString().compareTo('20') == 0)
      retValue = '발행(고객)';
    else if (value.toString().compareTo('30') == 0)
      retValue = '사용(고객)';
    else if (value.toString().compareTo('99') == 0)
      retValue = '폐기';
    else
      retValue = '--';

    return retValue;
  }

}
