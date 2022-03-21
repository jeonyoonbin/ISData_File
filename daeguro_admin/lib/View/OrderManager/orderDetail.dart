import 'dart:convert';
import 'dart:ui';

import 'package:daeguro_admin_app/Model/order/orderD.dart';
import 'package:daeguro_admin_app/View/OrderManager/orderManager_controller.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';


class OrderDetail extends StatefulWidget {
  final String orderNo;

  const OrderDetail({Key key, this.orderNo}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OrderDetailState();
  }
}

class OrderDetailState extends State<OrderDetail> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final List<OrderAccountMenuD> dataList = <OrderAccountMenuD>[];

  final List<List<String>> menuList = [];
  final List<List<String>> menuTotal = [];
  final List<List<String>> couponList = [];
  final List<List<String>> beforeTotal = [];
  final List<List<String>> amountTotal = [];

  final List<dynamic> statusHistories = [];

  String _appDate = '';
  int _menuCnt = 0;
  int _saleCost = 0;
  int _listCnt = 0;
  double _listHeight = 0;

  //List<dynamic> odrderMenuList = [];

  _query() {
    //formKey.currentState.reset();
    //formKey.currentState.save();
    //loadData();

    dataList.clear();
    menuList.clear();
    menuTotal.clear();
    couponList.clear();
    beforeTotal.clear();
    amountTotal.clear();
    statusHistories.clear();

    //var tempStr = OrderController.to.qDataDetail;
    // List<dynamic> conData = jsonDecode(tempStr['menuDesc']);
    // tempStr.forEach((element) {
    //   dataList.add(element);
    // });

    String tempStr = OrderController.to.qDataDetailMenuInfo;
    String editStr = tempStr.replaceAll(RegExp('\\.'), '');

    List<dynamic> conData = jsonDecode(editStr);

    conData.forEach((element) {
      OrderAccountMenuD temp = OrderAccountMenuD.fromJson(element);
      dataList.add(temp);
      menuList.add([
        element['menuName'],
        element['count'].toString(),
        element['menuCost'].toString(),
        'P',
      ]);

      _menuCnt = _menuCnt + element['count'];

      if (element['eventYn'].toString() == 'Y') {
        _saleCost = int.parse(element['menuCost'].toString()) - int.parse(element['saleCost'].toString());
        menuList.add(['        [이벤트 : ' + Utils.getCashComma(_saleCost.toString()) + ' 원 할인]', element['count'].toString(), element['saleCost'].toString(), 'C']);
      }

      if (element['orderUnitOptions'].toString() != '[]') {
        List<dynamic> optionsData = element['orderUnitOptions'];

        optionsData.forEach((data) {
          menuList.add(['        옵션 : ' + data['name'], '1'.toString(), data['cost'].toString(), 'C']);
        });
      }
    });

    menuTotal.add(['메뉴금액'.toString(), _menuCnt.toString(), OrderController.to.qDataDetail['menuAmt'].toString()]);
    menuTotal.add(['배달팁'.toString(), '', OrderController.to.qDataDetail['deliTipAmt'].toString()]);

    beforeTotal.add(['합계금액'.toString(), ''.toString(), OrderController.to.qDataDetail['beforeAmount']]);

    // 쿠폰 정보 확인
    if (OrderController.to.qDataDetail['couponAmt'] != '') {
      if (OrderController.to.qDataDetail['couponAmt'] != '0') {
        if (OrderController.to.qDataDetail['couponName'].toString() == '') {
          couponList.add(['', '-' + OrderController.to.qDataDetail['couponAmt'], 'P']);
        } else {
          couponList.add(['할인금액', '-' + OrderController.to.qDataDetail['couponAmt'], 'P']);
          couponList.add(['  ' + OrderController.to.qDataDetail['couponName'].toString() + ' (' + OrderController.to.qDataDetail['couponNo'].toString() + ')', '-' + OrderController.to.qDataDetail['couponAmt'], 'C']);
        }
      }
    }

    // 브랜드 쿠폰 정보 확인
    if (OrderController.to.qDataDetail['couponAmt2'] != '') {
      if (OrderController.to.qDataDetail['couponAmt2'] != '0') {
        if (OrderController.to.qDataDetail['couponName2'].toString() == '') {
          couponList.add(['', '-' + OrderController.to.qDataDetail['couponAmt2'], 'P']);
        } else {
          couponList.add(['할인금액', '-' + OrderController.to.qDataDetail['couponAmt2'], 'P']);
          couponList.add(['  ' + OrderController.to.qDataDetail['couponName2'].toString() + ' (' + OrderController.to.qDataDetail['couponNo2'].toString() + ')', '-' + OrderController.to.qDataDetail['couponAmt2'], 'C']);
        }
      }
    }

    // 마일리지 정보 확인
    if (OrderController.to.qDataDetail['mileage'] != '0') {
      menuTotal.add(['마일리지'.toString(), ''.toString(), '-' + OrderController.to.qDataDetail['mileage']]);
    }

    // eventDisc 정보 확인
    if (OrderController.to.qDataDetail['eventDisc'] != '') {
      List<String> _event = OrderController.to.qDataDetail['eventDisc'].split("");
      var _eventList;

      _event.forEach((value) {
        _eventList = value.split(',');

        if (_eventList[0] == '10') {
          menuTotal.add([_eventList[1].toString(), ''.toString(), '-' + _eventList[2].toString()]);
        } else {
          beforeTotal.add([_eventList[1].toString(), ''.toString(), _eventList[2].toString()]);
        }
      });
    }

    _listCnt = menuTotal.length + beforeTotal.length + couponList.length;
    _listHeight = _listCnt.toDouble() * 25;
    amountTotal.add(['총 결제 금액'.toString(), ''.toString(), OrderController.to.qDataDetail['amount']]);

    var _statusHistories = OrderController.to.qDataDetail;
    List<dynamic> jsonStatusHistories = _statusHistories['statusHistories'];
    jsonStatusHistories.forEach((element) {
      if (element['modDesc'].toString().contains('안심번호')) {
        if (element['status'] == '40' || element['status'] == '50') {
          element['modDesc'] = '[안심번호 해제]';
          element['modUser'] = ''; // 상세 내역 표시를 위해 user 정보 뺌
        } else {
          element['modDesc'] = '[안심번호 생성]';
        }
      } else if (element['modDesc'].toString().contains('카드결제')) {
        element['modDesc'] = '[카드결제]';
      } else if (element['modDesc'].toString().contains('카드취소')) {
        element['modDesc'] = '[카드취소]';
        element['modUser'] = ''; // 상세 내역 표시를 위해 user 정보 뺌
      } else {
        element['modDesc'] = '';
      }

      statusHistories.add(element);
    });

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    //print('orderNo: ${widget.orderNo}, appDate: ${OrderController.to.qDataDetail['appDate']}');

    if (OrderController.to.qDataDetail['appDate'].toString() != '') {
      _appDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(OrderController.to.qDataDetail['appDate'].toString().substring(0, 8))).toString() +
          ' ' + OrderController.to.qDataDetail['appDate'].toString().substring(8, 10) +
          ':' + OrderController.to.qDataDetail['appDate'].toString().substring(10, 12) +
          ':' + OrderController.to.qDataDetail['appDate'].toString().substring(12, 14);
    }
    else {
      _appDate = '';
    }

    WidgetsBinding.instance.addPostFrameCallback((c) {
      _query();
    });
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Align(alignment: Alignment.centerLeft, child: Text('배달지', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),),
            SizedBox(height: 5),
            Align(alignment: Alignment.centerLeft, child: Text('  [지번]', style: TextStyle(fontSize: 11, color: Colors.black54)),),
            Align(alignment: Alignment.centerLeft, child: SelectableText('  ' + OrderController.to.qDataDetail['addr1'] + ' ' + OrderController.to.qDataDetail['loc'] ?? '--', style: TextStyle(fontSize: 13), showCursor: true),),
            SizedBox(height: 5),
            Align(alignment: Alignment.centerLeft, child: Text('  [도로명]', style: TextStyle(fontSize: 11, color: Colors.black54)),),
            Align(alignment: Alignment.centerLeft, child: SelectableText('  ' + OrderController.to.qDataDetail['addr2'] + ' ' + OrderController.to.qDataDetail['loc'] ?? '--', style: TextStyle(fontSize: 13), showCursor: true),),
            SizedBox(height: 5),
            Align(alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text('  [회원번호]', style: TextStyle(fontSize: 11, color: Colors.black54)),
                  SelectableText(' ' + Utils.getPhoneNumFormat(OrderController.to.qDataDetail['telNo'], false) ?? '--', style: TextStyle(fontSize: 13), showCursor: true),
                ],
              ),
            ),
            Container(margin: EdgeInsets.fromLTRB(5, 0, 5, 0), child: Divider()),
            Align(alignment: Alignment.centerLeft,
              child: SelectableText(OrderController.to.qDataDetail['shopName']  ?? '--', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), showCursor: true),
            ),
            //SizedBox(height: 10),
            Align(alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text('  [사업자번호] ', style: TextStyle(fontSize: 11, color: Colors.black54)),
                    SelectableText(Utils.getStoreRegNumberFormat(OrderController.to.qDataDetail['regNo'], false) , style: TextStyle(fontSize: 12, color: Colors.black), showCursor: true)
                  ],
                )
            ),
            Align(alignment: Alignment.centerLeft, child: Text('  [주소]', style: TextStyle(fontSize: 11, color: Colors.black54)),),
            Align(alignment: Alignment.centerLeft, child: SelectableText('  ' + OrderController.to.qDataDetail['shopAddr'] + ' ' + OrderController.to.qDataDetail['shopLoc'] ?? '--', style: TextStyle(fontSize: 13), showCursor: true),),

            Align(alignment: Alignment.centerLeft, child: Text('  [요청사항]', style: TextStyle(fontSize: 11, color: Colors.black54)),),
            Align(alignment: Alignment.centerLeft, child: SelectableText('  [고객] ${OrderController.to.qDataDetail['shopDeliMemo'] ?? '--'}', maxLines: 1, style: TextStyle(fontSize: 11), showCursor: true),),
            Align(alignment: Alignment.centerLeft, child: SelectableText('  [배달] ${OrderController.to.qDataDetail['riderDeliMemo'] ?? '--'}', maxLines: 1, style: TextStyle(fontSize: 11), showCursor: true),),
          ],
        ),
      ),
    );

    Container MenuTable = Container(
      padding: const EdgeInsets.all(10.0),
      child: ListView(
        controller: ScrollController(),
        children: <Widget>[
          DataTable(
            headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blue[50]),
            headingTextStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', color: Colors.black54, fontSize: 12),
            headingRowHeight: 24,
            dataRowHeight: 32,
            dividerThickness: 0.01,
            dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white),
            dataTextStyle: TextStyle(fontWeight: FontWeight.normal, fontFamily: 'NotoSansKR', fontSize: 12),
            columnSpacing: 0,
            columns: <DataColumn>[
              DataColumn(label: Expanded(child: Text('메뉴명', textAlign: TextAlign.left)),),
              DataColumn(label: Expanded(child: Text('수량', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('금액', textAlign: TextAlign.right)),),
            ],
            //source: listDS,
            rows: menuList.map((item) {
              return DataRow(cells: [
                DataCell(Container(child: Text(item[0], style: TextStyle(fontSize: 12, fontWeight: item[3] == 'P' ? FontWeight.bold : FontWeight.normal, color: item[3] == 'P' ? Colors.black : Colors.black54),), width: 240)),
                DataCell(Container(child: Center(child: Text(item[1].toString(), style: TextStyle(fontSize: 12, fontWeight: item[3] == 'P' ? FontWeight.bold : FontWeight.normal, color: item[3] == 'P' ? Colors.black : Colors.black54))))),
                DataCell(Container(child: Align(child: Text(Utils.getCashComma(item[2].toString()) ?? '--', style: TextStyle(fontSize: 12, fontWeight: item[3] == 'P' ? FontWeight.bold : FontWeight.normal, color: item[3] == 'P' ? Colors.black : Colors.black54)), alignment: Alignment.centerRight))),
              ]);
            }).toList(),
          ),
        ],
      ),
    );

    var result = Scaffold(
      appBar: AppBar(
        title: Text('주문 상세 조회'),
      ),
      body: Row(
        children: [
          Container(
            width: 450,
            height: 520,
            margin: EdgeInsets.only(left: 15, top: 15, bottom: 15),
            child: Column(
              children: [
                Container(
                  height: 288,
                  child: form,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), border: Border.all(width: 1, color: Colors.grey.withOpacity(.3))),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('결제내역', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Container(
                            width: 180,
                            height: 190,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Align(alignment: Alignment.centerLeft, child: Text('  결제카드', style: TextStyle(fontSize: 11, color: Colors.black54)),),
                                  Align(alignment: Alignment.centerLeft, child: SelectableText('       ' + OrderController.to.qDataDetail['cardName'] ?? '--', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), showCursor: true),),
                                  SizedBox(height: 4),
                                  Align(alignment: Alignment.centerLeft, child: Text('  카드번호', style: TextStyle(fontSize: 11, color: Colors.black54)),),
                                  Align(alignment: Alignment.centerLeft, child: SelectableText('       ' + OrderController.to.qDataDetail['cardNo'] ?? '--', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), showCursor: true),),
                                  SizedBox(height: 4),
                                  Align(alignment: Alignment.centerLeft, child: Text('  승인번호', style: TextStyle(fontSize: 11, color: Colors.black54)),),
                                  Align(alignment: Alignment.centerLeft, child: SelectableText('       ' + OrderController.to.qDataDetail['appNo'] ?? '--', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), showCursor: true),),
                                  SizedBox(height: 4),
                                  Align(alignment: Alignment.centerLeft, child: Text('  승인시간', style: TextStyle(fontSize: 11, color: Colors.black54)),),
                                  Align(alignment: Alignment.centerLeft, child: SelectableText('       ' + _appDate ?? '--', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), showCursor: true),
                                  ),
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), border: Border.all(width: 1, color: Colors.grey.withOpacity(.3)))
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('상태변경 이력', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Container(
                            alignment: Alignment.centerLeft,
                            width: 260,
                            height: 190,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Container(
                                child: ListView.builder(
                                  controller: ScrollController(),
                                  itemCount: statusHistories.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Column(
                                      children: <Widget>[
                                        Container(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: statusHistories[index]['modUser'] == ''
                                                ? SelectableText(_getStatus(statusHistories[index]['status']) + ' ' + statusHistories[index]['modDesc'], style: TextStyle(fontSize: 11, color: _getStatusFontColor(statusHistories[index]['status'])), showCursor: true)
                                                : SelectableText(_getStatus(statusHistories[index]['status']) + ' [수정자 : ' + statusHistories[index]['modUser'] + ']' ?? '--', style: TextStyle(fontSize: 11, color: _getStatusFontColor(statusHistories[index]['status'])), showCursor: true),
                                          ),
                                          margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: SelectableText('       ' + statusHistories[index]['regTime'] ?? '--', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), showCursor: true),
                                        ),
                                        SizedBox(height: 5)
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), border: Border.all(width: 1, color: Colors.grey.withOpacity(.3)))
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 10,),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), border: Border.all(width: 1, color: Colors.grey.withOpacity(.3))),
            width: 410,
            height: 520,
            margin: EdgeInsets.only(right: 15, top: 15, bottom: 15),//EdgeInsets.all(15),
            child: Wrap(children: [
              Container(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text('주문번호', style: TextStyle(fontSize: 13, color: Colors.black54)),
                      SelectableText('  ' + widget.orderNo ?? '--', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), showCursor: true),
                    ],
                  ),
                ),
                margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
              ),
              Container(margin: EdgeInsets.fromLTRB(5, 0, 5, 0), child: Divider(thickness: 1)),
              Container(color: Colors.white, width: 410, height: 380 - _listHeight, child: MenuTable),
              Container(margin: EdgeInsets.fromLTRB(5, 0, 5, 0), child: Divider()),
              DataTable(
                headingRowHeight: 0,
                dataRowHeight: 25,
                dividerThickness: 0.01,
                dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white),
                dataTextStyle: TextStyle(fontWeight: FontWeight.normal, fontFamily: 'NotoSansKR', fontSize: 12),
                columnSpacing: 0,
                columns: <DataColumn>[
                  DataColumn(label: Expanded(child: Text('상품명', textAlign: TextAlign.left)),),
                  DataColumn(label: Expanded(child: Text('수량', textAlign: TextAlign.center)),),
                  DataColumn(label: Expanded(child: Text('금액', textAlign: TextAlign.center)),),
                ],
                //source: listDS,
                rows: menuTotal.map((item) {
                  return DataRow(cells: [
                    DataCell(Container(child: Text(item[0], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),), width: 300)),
                    DataCell(Container(child: Center(child: Text('', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black), )))),
                    DataCell(Container(child: Align(child: Text(Utils.getCashComma(item[2].toString()) ?? '--', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),), alignment: Alignment.centerRight))),
                  ]);
                }).toList(),
              ),
              DataTable(
                headingRowHeight: 0,
                dataRowHeight: 25,
                dividerThickness: 0.01,
                dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white),
                dataTextStyle: TextStyle(fontWeight: FontWeight.normal, fontFamily: 'NotoSansKR', fontSize: 12),
                columnSpacing: 0,
                columns: <DataColumn>[
                  DataColumn(label: Expanded(child: Text('쿠폰명', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold))),),
                  DataColumn(label: Expanded(child: Text('수량', textAlign: TextAlign.center)),),
                  DataColumn(label: Expanded(child: Text('금액', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),),
                ],
                //source: listDS,
                rows: couponList.map((item) {
                  return DataRow(cells: [
                    DataCell(Container(child: Text(item[0], style: TextStyle(fontSize: 12, fontWeight: item[2] == 'P' ? FontWeight.bold : FontWeight.normal, color: item[2] == 'P' ? Colors.black : Colors.black54),), width: 300)),
                    DataCell(Container(child: Center(child: Text('', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), )))),
                    DataCell(Container(child: Align(child: Text(Utils.getCashComma(item[1].toString()) ?? '--', style: TextStyle(fontSize: 12, fontWeight: item[2] == 'P' ? FontWeight.bold : FontWeight.normal, color: item[2] == 'P' ? Colors.black : Colors.black54),), alignment: Alignment.centerRight))),
                  ]);
                }).toList(),
              ),
              Container(margin: EdgeInsets.fromLTRB(5, 0, 5, 0), child: Divider()),
              DataTable(
                headingRowHeight: 0,
                dataRowHeight: 25,
                dividerThickness: 0.01,
                dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white),
                dataTextStyle: TextStyle(fontWeight: FontWeight.normal, fontFamily: 'NotoSansKR', fontSize: 12),
                columnSpacing: 0,
                columns: <DataColumn>[
                  DataColumn(label: Expanded(child: Text('상품명', textAlign: TextAlign.left)),),
                  DataColumn(label: Expanded(child: Text('수량', textAlign: TextAlign.center)),),
                  DataColumn(label: Expanded(child: Text('금액', textAlign: TextAlign.center)),),
                ],
                //source: listDS,
                rows: beforeTotal.map((item) {
                  return DataRow(cells: [
                    DataCell(Container(child: Text(item[0], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),), width: 300)),
                    DataCell(Container(child: Center(child: Text(item[1].toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),)))),
                    DataCell(Container(child: Align(child: Text(Utils.getCashComma(item[2].toString()) ?? '--', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),), alignment: Alignment.centerRight))),
                  ]);
                }).toList(),
              ),
              Container(margin: EdgeInsets.fromLTRB(5, 0, 5, 0), child: Divider(thickness: 5)),
              DataTable(
                headingRowHeight: 0,
                dataRowHeight: 25,
                dividerThickness: 0.01,
                dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white),
                dataTextStyle: TextStyle(fontWeight: FontWeight.normal, fontFamily: 'NotoSansKR', fontSize: 13),
                columnSpacing: 0,
                columns: <DataColumn>[
                  DataColumn(label: Expanded(child: Text('상품명', textAlign: TextAlign.left)),),
                  DataColumn(label: Expanded(child: Text('수량', textAlign: TextAlign.center)),),
                  DataColumn(label: Expanded(child: Text('금액', textAlign: TextAlign.center)),),
                ],
                //source: listDS,
                rows: amountTotal.map((item) {
                  return DataRow(cells: [
                    DataCell(Container(child: Text(item[0], style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),), width: 300)),
                    DataCell(Container(child: Center(child: Text(item[1].toString(), style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),)))),
                    DataCell(Container(child: Align(child: Text(Utils.getCashComma(item[2].toString()) ?? '--', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),), alignment: Alignment.centerRight))),
                  ]);
                }).toList(),
              ),
            ]),
          ),
        ],
      ),
    );

    return SizedBox(
      width: 900,
      height: 610,
      child: result,
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('상세보기'),
    //   ),
    //   body: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: <Widget>[
    //       SizedBox(height: 10),
    //       form,
    //       Expanded(
    //         child: table,
    //       ),
    //     ],
    //   ),
    // );
  }

  String _getStatus(String status) {
    String retValue = '--';

    if (status.toString().compareTo('10') == 0)
      retValue = '접수';
    else if (status.toString().compareTo('20') == 0)
      retValue = '대기';
    else if (status.toString().compareTo('30') == 0)
      retValue = '가맹점접수확인';
    else if (status.toString().compareTo('35') == 0)
      retValue = '운행';
    else if (status.toString().compareTo('40') == 0)
      retValue = '완료';
    else if (status.toString().compareTo('50') == 0)
      retValue = '취소';
    else if (status.toString().compareTo('80') == 0) retValue = '결제대기';

    return retValue;
  }

  Color _getStatusFontColor(String status) {
    Color retValue = Colors.black54;

    if (status.toString().compareTo('10') == 0)
      retValue = Colors.black54;
    else if (status.toString().compareTo('20') == 0)
      retValue = Colors.black54;
    else if (status.toString().compareTo('30') == 0)
      retValue = Colors.black54;
    else if (status.toString().compareTo('35') == 0)
      retValue = Colors.green;
    else if (status.toString().compareTo('40') == 0)
      retValue = Colors.blue;
    else if (status.toString().compareTo('50') == 0)
      retValue = Colors.red;
    else if (status.toString().compareTo('80') == 0)
      retValue = Colors.black54;

    return retValue;
  }

  String _getPayGbn(String payGbn) {
    String retValue = '--';

    if (payGbn.toString().compareTo('1') == 0)
      retValue = '현금';
    else if (payGbn.toString().compareTo('2') == 0)
      retValue = '카드';
    else if (payGbn.toString().compareTo('3') == 0)
      retValue = '외상';
    else if (payGbn.toString().compareTo('4') == 0)
      retValue = '쿠폰(가맹점 자체)';
    else if (payGbn.toString().compareTo('5') == 0)
      retValue = '마일리지';
    else if (payGbn.toString().compareTo('7') == 0)
      retValue = '행복페이';
    else if (payGbn.toString().compareTo('8') == 0)
      retValue = '제로페이';
    else if (payGbn.toString().compareTo('9') == 0)
      retValue = '선결제';
    else if (payGbn.toString().compareTo('P') == 0)
      retValue = '휴대폰';
    else if (payGbn.toString().compareTo('B') == 0) retValue = '계좌이체';

    return retValue;
  }
}
