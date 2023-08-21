import 'dart:convert';

import 'package:daeguro_ceo_app/common/constant.dart';
import 'package:daeguro_ceo_app/iswidgets/is_alertdialog.dart';
import 'package:daeguro_ceo_app/iswidgets/is_dialog.dart';
import 'package:daeguro_ceo_app/iswidgets/is_optionModel.dart';
import 'package:daeguro_ceo_app/iswidgets/is_progressDialog.dart';
import 'package:daeguro_ceo_app/iswidgets/isd_button.dart';
import 'package:daeguro_ceo_app/models/OrderManager/orderDetailMenuModel.dart';
import 'package:daeguro_ceo_app/models/OrderManager/orderDetailModel.dart';
import 'package:daeguro_ceo_app/screen/AccountManager/accountManagerController.dart';
import 'package:daeguro_ceo_app/theme.dart';
import 'package:daeguro_ceo_app/util/utils.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluentUI;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class OrderDetailInfoBundle extends StatefulWidget {
  final String? orderNo;

  const OrderDetailInfoBundle({Key? key, this.orderNo}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OrderDetailInfoBundleState();
  }
}

class OrderDetailInfoBundleState extends State<OrderDetailInfoBundle> {

  OrderDetailModel mDetailList = OrderDetailModel();

  final List<OrderDetailMenuModel> menuDataList = <OrderDetailMenuModel>[];
  final List<OrderDetailMenuModel> mDetailAmount = <OrderDetailMenuModel>[];
  OrderDetailMenuModel temp2 = OrderDetailMenuModel();

  final List<List<String>> menuList = [];

  String _shopNameGbn = '';

  requestAPIData() async {
    mDetailList = OrderDetailModel();
    menuDataList.clear();

    var value = await showDialog(context: context, barrierColor: Colors.transparent,builder: (context) => FutureProgressDialog(AccountController.to.getShopOrderDetail('10', widget.orderNo.toString())));

    if (value == null) {
      ISAlert(context, content: '정상조회가 되지 않았습니다. \n\n다시 시도해 주세요');
      //Navigator.of(context).pop;
    } else {
      mDetailList.orderNo = value['orderNo'] as String;
      mDetailList.status = value['status'] as String;
      mDetailList.appPayGbn = value['appPayGbn'] as String;
      mDetailList.payGbn = value['payGbn'] as String;
      mDetailList.myNumber = value['myNumber'] as String;
      // mDetailList.shopRoadAddr = value['shopRoadAddr'] as String;
      // mDetailList.shopDongAddr = value['shopDongAddr'] as String;
      // mDetailList.shopAddrDetail = value['shopAddrDetail'] as String;
      mDetailList.custDongAddr = value['custDongAddr'] as String;
      mDetailList.custRoadAddr = value['custRoadAddr'] as String;
      mDetailList.custAddrDetail = value['custAddrDetail'] as String;
      mDetailList.shopDeliMemo = value['shopDeliMemo'] as String;
      mDetailList.riderDeliMemo = value['riderDeliMemo'] as String;
      mDetailList.menuDesc = value['menuDesc'] as String;

      String tempStr = mDetailList.menuDesc.toString();
      String editStr = tempStr.replaceAll(RegExp('\\.'), '');

      List<dynamic> conData = jsonDecode(editStr);

      // 메뉴 상세 내역
      conData.forEach((element) {
        OrderDetailMenuModel shopNameInfo = OrderDetailMenuModel();

        // 위에 상품과 가맹점 명이 다를경우 표시.(처음 상품은 무조건 가맹점명 표시)
        if (_shopNameGbn != element['shopName'].toString()) {
          _shopNameGbn = element['shopName'].toString();

          shopNameInfo.menuName = element['shopName'].toString();
          shopNameInfo.menuCost = null;
          shopNameInfo.count = null;
          shopNameInfo.cost = null;
          shopNameInfo.dataGbn = 'SHOP';

          menuDataList.add(shopNameInfo);
        }

        OrderDetailMenuModel temp = OrderDetailMenuModel();

        temp.menuName = element['name'];
        temp.menuCost = element['saleCost'] == element['cost'] ? element['cost'] : element['saleCost']; // 금액이 다를 경우 이벤트 값 적용
        temp.count = element['count'];
        temp.cost = element['cost'];
        temp.dataGbn = 'P';

        menuDataList.add(temp);

        if (element['options'].toString() != '[]') {
          List<dynamic> optionsData = element['options'];

          optionsData.forEach((data) {
            temp2 = OrderDetailMenuModel();

            temp2.menuName = '  필수/선택 옵션 : ' + data['name'];
            temp2.menuCost = data['cost'];
            temp2.count = 1;
            temp2.cost = data['cost'];
            temp2.dataGbn = 'C';

            menuDataList.add(temp2);
          });
        }

        if (element['addOptions'].toString() != '[]') {
          List<dynamic> optionsData = element['addOptions'];

          optionsData.forEach((data) {
            temp2 = OrderDetailMenuModel();

            temp2.menuName = '  추가상품 : ' + data['name'];
            temp2.menuCost = data['cost'];
            temp2.count = 1;
            temp2.cost = data['cost'];
            temp2.dataGbn = 'C';

            menuDataList.add(temp2);
          });
        }
      });

      // 배달팁
      if(value['orderAmtTip'] != '0') {
        temp2 = OrderDetailMenuModel();

        temp2.menuName = '배달팁';
        temp2.menuCost = null;
        temp2.count = null;
        temp2.cost = double.parse(value['orderAmtTip'].toString());
        temp2.dataGbn = 'T';

        menuDataList.add(temp2);
      }

      // 배달팁 할인
      if(value['deliTipDiscAmt'] != '0') {
        temp2 = OrderDetailMenuModel();

        temp2.menuName = '   배달팁 할인';
        temp2.menuCost = null;
        temp2.count = null;
        temp2.cost = double.parse(value['deliTipDiscAmt'].toString()) * -1;
        temp2.dataGbn = 'TDC';

        menuDataList.add(temp2);
      }

      // 포장 할인
      if(value['toGoDiscAmt'] != '0') {
        temp2 = OrderDetailMenuModel();

        temp2.menuName = '포장 할인';
        temp2.menuCost = null;
        temp2.count = null;
        temp2.cost = double.parse(value['toGoDiscAmt'].toString()) * -1;
        temp2.dataGbn = 'T';

        menuDataList.add(temp2);
      }

      // 아동급식 할인
      if(value['happyDiscAmt'] != '0') {
        temp2 = OrderDetailMenuModel();

        temp2.menuName = '행복페이 할인';
        temp2.menuCost = null;
        temp2.count = null;
        temp2.cost = double.parse(value['happyDiscAmt'].toString()) * -1;
        temp2.dataGbn = 'T';

        menuDataList.add(temp2);
      }

      // 쿠폰 할인
      if(value['couponAmt'] != '0') {
        temp2 = OrderDetailMenuModel();

        temp2.menuName = '쿠폰';
        temp2.menuCost = null;
        temp2.count = null;
        temp2.cost = double.parse(value['couponAmt'].toString()) * -1;
        temp2.dataGbn = 'T';

        menuDataList.add(temp2);
      }

      // 가맹점 할인
      if(value['shopCouponAmt'] != '0') {
        temp2 = OrderDetailMenuModel();

        temp2.menuName = '가맹점 쿠폰';
        temp2.menuCost = null;
        temp2.count = null;
        temp2.cost = double.parse(value['shopCouponAmt'].toString()) * -1;
        temp2.dataGbn = 'T';

        menuDataList.add(temp2);
      }

      // 착한매장 할인
      if(value['goodShopDiscAmt'] != '0') {
        temp2 = OrderDetailMenuModel();

        temp2.menuName = '착한매장 할인';
        temp2.menuCost = null;
        temp2.count = null;
        temp2.cost = double.parse(value['goodShopDiscAmt'].toString()) * -1;
        temp2.dataGbn = 'T';

        menuDataList.add(temp2);
      }

      // 마일리지 사용
      if(value['mileageUseAmt'] != '0') {
        temp2 = OrderDetailMenuModel();

        temp2.menuName = '마일리지';
        temp2.menuCost = null;
        temp2.count = null;
        temp2.cost = double.parse(value['mileageUseAmt'].toString()) * -1;
        temp2.dataGbn = 'T';

        menuDataList.add(temp2);
      }

      // 총 합계 표시
      temp2 = OrderDetailMenuModel();
      temp2.menuName = '총 결제 금액';
      temp2.menuCost = null;
      temp2.count = null;
      temp2.cost = double.parse(value['amount']);
      temp2.dataGbn = 'A';

      menuDataList.add(temp2);
    }

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    mDetailList = OrderDetailModel();
    menuDataList.clear();
    mDetailAmount.clear();
    temp2 = OrderDetailMenuModel();
    menuList.clear();
  }

  @override
  void initState() {
    super.initState();

    Get.put(AccountController());

    WidgetsBinding.instance.addPostFrameCallback((c) {
      requestAPIData();
    });
  }

  @override
  Widget build(BuildContext context) {
    assert(fluentUI.debugCheckHasFluentTheme(context));

    final appTheme = context.watch<AppTheme>(); //.watch<AppTheme>();

    const receiptTitleTextStyle = TextStyle(fontSize: 13, fontFamily: FONT_FAMILY, fontWeight: FONT_BOLD, color: Colors.black87);
    const receiptContentTextStyle = TextStyle(fontSize: 13, fontFamily: FONT_FAMILY, fontWeight: FONT_NORMAL, color: Colors.black87);

    return ContentDialog(
      constraints: const BoxConstraints(maxWidth: 400.0, maxHeight: 640),
      contentPadding: const EdgeInsets.all(0.0),
      //const EdgeInsets.symmetric(horizontal: 20),
      isFillActions: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 20),
          const Text('주문 상세', style: TextStyle(fontSize: 22, fontFamily: FONT_FAMILY),),
          fluentUI.SmallIconButton(
            child: fluentUI.Tooltip(
              message: fluentUI.FluentLocalizations.of(context).closeButtonLabel,
              child: fluentUI.IconButton(
                icon: const Icon(fluentUI.FluentIcons.chrome_close),
                onPressed: Navigator.of(context).pop,
              ),
            ),
          ),
        ],
      ),
      content: Material(
        color: Colors.transparent,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: DataTable(
                        headingRowHeight: 24,
                        dataRowHeight: 24.0,
                        headingRowColor: MaterialStateProperty.all(Colors.blue[100],),
                        // dataRowMinHeight: 22.0,
                        // dataRowMaxHeight: 40.0,
                        columnSpacing: 0,
                        horizontalMargin: 8,
                        headingTextStyle: const TextStyle(fontSize: 12, fontFamily: FONT_FAMILY, fontWeight: FONT_BOLD, color: Colors.black54),
                        dataTextStyle: const TextStyle(fontSize: 14, fontFamily: FONT_FAMILY, fontWeight: FONT_NORMAL),
                        dividerThickness: 0.01,
                        columns: const [
                          DataColumn(label: Expanded(child: Text('항목', textAlign: TextAlign.left))),
                          DataColumn(label: Expanded(child: Text('단가', textAlign: TextAlign.center))),
                          DataColumn(label: Expanded(child: Text('수량', textAlign: TextAlign.center))),
                          DataColumn(label: Expanded(child: Text('금액', textAlign: TextAlign.right))),
                        ],
                        rows: menuDataList.map((item) {
                          return DataRow(cells: [
                            DataCell(Align(alignment: Alignment.centerLeft,
                                child: Text(item.menuName.toString(), style: TextStyle(fontSize: _getFontSize(item.dataGbn.toString()), color: _getFontColor(item.dataGbn.toString()))))),
                            DataCell(Align(
                                alignment: Alignment.center,
                                child: Text(item.menuCost == null ? '' : Utils.getCashComma(item.menuCost.toString()),
                                    style: TextStyle(fontSize: _getFontSize(item.dataGbn.toString()), color: _getFontColor(item.dataGbn.toString()))))),
                            DataCell(Align(
                                alignment: Alignment.center,
                                child: Text(item.count == null ? '' : Utils.getCashComma(item.count.toString()),
                                    style: TextStyle(fontSize: _getFontSize(item.dataGbn.toString()), color: _getFontColor(item.dataGbn.toString()))))),
                            DataCell(Align(
                                alignment: Alignment.centerRight,
                                child: Text(item.dataGbn == 'SHOP' ? '' :
                                    item.dataGbn == 'A' || item.dataGbn == 'T' || item.dataGbn == 'TDC'
                                        ? Utils.getCashComma(item.cost.toString())
                                        : Utils.getCashComma((double.parse(item.menuCost.toString()) * double.parse(item.count.toString())).toString()),
                                    style: TextStyle(fontSize: _getFontSize(item.dataGbn.toString()), color: _getFontColor(item.dataGbn.toString()))))),
                          ],
                          color: item.dataGbn == 'SHOP' ? MaterialStateProperty.all(Colors.grey[200]) : null);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.black),
                const SizedBox(height: 8,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 120, child: Text('주문유형', style: receiptTitleTextStyle)),
                          SizedBox(width: 220, child: Text(_getStatus(mDetailList.status.toString()), style: receiptContentTextStyle)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 120, child: Text('결제방법', style: receiptTitleTextStyle)),
                          SizedBox(width: 220, child: Text(mDetailList.appPayGbn.toString(), style: receiptContentTextStyle)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 120, child: Text('결제수단', style: receiptTitleTextStyle)),
                          SizedBox(width: 220, child: Text(mDetailList.payGbn.toString(), style: receiptContentTextStyle)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 120, child: Text('연락처', style: receiptTitleTextStyle)),
                          SizedBox(width: 220, child: Text(Utils.getPhoneNumFormat(mDetailList.myNumber.toString(), true), style: receiptContentTextStyle)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 120, child: Text('배달주소(도로명)', style: receiptTitleTextStyle)),
                          SizedBox(width: 220, child: Text(mDetailList.custRoadAddr.toString(), style: receiptContentTextStyle)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 120, child: Text('배달주소(지번)', style: receiptTitleTextStyle)),
                          SizedBox(width: 220, child: Text(mDetailList.custDongAddr.toString(), style: receiptContentTextStyle)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 120, child: Text('배달 상세주소', style: receiptTitleTextStyle)),
                          SizedBox(width: 220, child: Text(mDetailList.custAddrDetail.toString(), style: receiptContentTextStyle)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 120, child: Text('매장 요청사항', style: receiptTitleTextStyle)),
                          SizedBox(width: 220, child: Text(mDetailList.shopDeliMemo.toString(), style: receiptContentTextStyle)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 120, child: Text('배달 요청사항', style: receiptTitleTextStyle)),
                          SizedBox(width: 220, child: Text(maxLines: 5, mDetailList.riderDeliMemo.toString(), style: receiptContentTextStyle)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      // actions: [
      //   SizedBox(
      //     child: FilledButton(
      //       style: appTheme.popupButtonStyleLeft,
      //       onPressed: () {
      //         Navigator.pop(context);
      //       },
      //       child: const Text('취소', style: TextStyle(fontSize: 18, fontFamily: FONT_FAMILY)),
      //     ),
      //   ),
      //   SizedBox(
      //     child: FilledButton(
      //       style: appTheme.popupButtonStyleRight,
      //       onPressed: () {
      //
      //       },
      //       child: const Text('등록', style: TextStyle(fontSize: 18, fontFamily: FONT_FAMILY)),
      //     ),
      //   ),
      // ],
    );
  }

  String _getStatus(String value) {
    String retValue = '--';

    if (value.toString().compareTo('10') == 0)
      retValue = '접수';
    else if (value.toString().compareTo('20') == 0)
      retValue = '대기';
    else if (value.toString().compareTo('30') == 0)
      retValue = '가맹점 접수확인';
    else if (value.toString().compareTo('33') == 0)
      retValue = '포장준비완료';
    else if (value.toString().compareTo('35') == 0)
      retValue = '운행';
    else if (value.toString().compareTo('40') == 0)
      retValue = '완료';
    else if (value.toString().compareTo('50') == 0)
      retValue = '취소';
    else if (value.toString().compareTo('80') == 0)
      retValue = '결제대기';
    else
      retValue = '--';

    return retValue;
  }

  double _getFontSize(String value) {
    double retValue;

    if (value.toString().compareTo('P') == 0 || value.toString().compareTo('T') == 0)
      retValue = 14;
    else if (value.toString().compareTo('A') == 0)
      retValue = 14;
    else
      retValue = 13;

    return retValue;
  }

  // SHOP:가맹점명, P:메인메뉴, C:옵션, A:총결제금액, T:포장할인,배달팁, TDC:배달팁할인
  Color _getFontColor(String value) {
    Color retValue;

    if (value.toString().compareTo('SHOP') == 0 ||value.toString().compareTo('P') == 0 || value.toString().compareTo('T') == 0)
      retValue = Colors.black;
    else if (value.toString().compareTo('A') == 0)
      retValue = Colors.blueAccent;
    else
      retValue = Colors.black54;

    return retValue;
  }
}
