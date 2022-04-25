import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_text_box.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/AgentManager/agentAccount_Controller.dart';
import 'package:daeguro_admin_app/View/OrderManager/orderDetail.dart';
import 'package:daeguro_admin_app/View/OrderManager/orderManager_controller.dart';

import 'package:date_format/date_format.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class CalculateOutstandingAmountDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CalculateOutstandingAmountDetailState();
  }
}

class CalculateOutstandingAmountDetailState extends State<CalculateOutstandingAmountDetail> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final List<Map> dataList = [];
  final List<Map> list = <Map>[
    {
      '주문번호': '98994',
      '적립일자': '2021-06-14\n18:00:11',
      '적립구분': '음식값정산',
      '상점NO': '1090',
      '상점명': '인성족발',
      '사업자번호': '5038150051',
      '총주문금액': '28500',
      '총결제금액': null,
      '적립잔액': '28500',
      '미납액': '0',
      '작업자': 'system',
      '메모': '음식값 정산콜센터에서 입금\nBC카드 / 85071146'
    },
    {
      '주문번호': '2686',
      '적립일자': '2021-06-14\n18:00:11',
      '적립구분': '음식값정산',
      '상점NO': '1090',
      '상점명': '인성족발',
      '사업자번호': '5038150051',
      '총주문금액': '28500',
      '총결제금액': null,
      '적립잔액': '28500',
      '미납액': '0',
      '작업자': 'system',
      '메모': '음식값 정산콜센터에서 입금\nBC카드 / 85071146'
    },
    {
      '주문번호': null,
      '적립일자': '2021-06-14\n18:00:11',
      '적립구분': '음식값정산',
      '상점NO': '1090',
      '상점명': '인성족발',
      '사업자번호': '5038150051',
      '총주문금액': '28500',
      '총결제금액': null,
      '적립잔액': '28500',
      '미납액': '0',
      '작업자': 'system',
      '메모': '음식값 정산콜센터에서 입금\nBC카드 / 85071146'
    },
  ];

  //페이지정보
  int _totalRowCnt = 0;
  int _selectedpagerows = 15;

  int _currentPage = 1;
  int _totalPages = 0;

  SearchItems _searchItems = new SearchItems();

  //합계
  var weight;
  var mInSum = 0;
  var mOutSum = 0;
  var unpayed = 0;
  var balance = 0;

  void _pageMove(int _page) {
    _query();
  }

  _reset() {
    _searchItems = null;
    _searchItems = new SearchItems();

    _searchItems.startdate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);

    _searchItems.enddate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
  }

  _query() {
    OrderController.to.startdate.value = _searchItems.startdate.replaceAll('-', '');
    OrderController.to.enddate.value = _searchItems.enddate.replaceAll('-', '');
    OrderController.to.tel.value = _searchItems.tel;
    OrderController.to.name.value = _searchItems.name;
    OrderController.to.page.value = _currentPage.round().toString();
    OrderController.to.raw.value = _selectedpagerows.toString();
    loadData();
  }

  _detail({String orderNo}) async {
    await OrderController.to.getDetailData(orderNo.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: OrderDetail(orderNo: orderNo),
      ),
    );
  }

  loadData() async {
    dataList.clear();

    dataList.assignAll(list);

    //데이터 로드후 합계 계산해서 값 추가
    dataList.forEach((e) {
      mInSum = mInSum + int.parse(e['미수금액'] ?? '0');
      mOutSum = mOutSum + int.parse(e['발생건수'] ?? '0');
      unpayed = unpayed + int.parse(e['합계'] ?? '0');
    });

    balance = mInSum - mOutSum;

    var sum = {
      '주문번호': '합계',
      '미수금액': mInSum.toString(),
      '발생건수': mOutSum.toString(),
      '합계': unpayed.toString(),
    };
    dataList.add(sum);
    // dataList.clear();
    //
    // value.forEach((e) {
    //   OrderAccount temp = OrderAccount.fromJson(e);
    //   if (temp.orderTime.contains('오전'))
    //     temp.orderTime = temp.orderTime.replaceAll(' 오전 ', '\n오전');
    //   else
    //     temp.orderTime = temp.orderTime.replaceAll(' 오후 ', '\n오후');
    //
    //   String currentTodayTime = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    //   if (temp.orderTime.contains(currentTodayTime) == true)
    //     temp.orderTime = temp.orderTime.replaceAll(currentTodayTime+'\n', '');
    //
    //   // dataList.add(temp);
    // });

    _totalRowCnt = OrderController.to.totalRowCnt;
    _totalPages = (_totalRowCnt / _selectedpagerows).ceil();

    setState(() {

    });

    return;
  }

  @override
  void initState() {
    super.initState();

    Get.put(OrderController());
    Get.put(AgentController());

    WidgetsBinding.instance.addPostFrameCallback((c) {
      _reset();
      _query();
    });

    setState(() {});
  }

  @override
  void dispose() {
    dataList.clear();

    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
          //_getSearchBox(),
        ],
      ),
    );

    Container bar2 = Container(
      padding: EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ISButton(label: 'Excel저장', iconColor: Colors.white, iconData: Icons.reply, textStyle: TextStyle(color: Colors.white), onPressed: () {}),
          SizedBox(
            width: 20,
          ),
          ISTextBox(
            label: '미납액',
            value: unpayed.toString(),
          ),
          SizedBox(
            width: 20,
          ),
          ISTextBox(
            label: '잔액',
            value: balance.toString(),
          ),
        ],
      ),
    );

    var result = Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 50, right: 50, bottom: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            form,
            bar2,
            Expanded(
              child: ISDatatable(
                rows: dataList.map((item) {
                  if (item['주문번호'] == '합계') {
                    weight = FontWeight.bold;
                  } else {
                    weight = FontWeight.normal;
                  }
                  return DataRow(cells: [
                    DataCell(Center(child: SelectableText(item['주문번호'] ?? '', style: TextStyle(color: Colors.black, fontWeight: weight), showCursor: true))),
                    DataCell(Center(child: SelectableText(item['적립일자'] ?? '', style: TextStyle(color: Colors.black, fontSize: 12), textAlign: TextAlign.center, showCursor: true))),
                    DataCell(Center(child: SelectableText(item['적립구분'] ?? '', style: TextStyle(color: Colors.black), showCursor: true))),
                    DataCell(Center(child: SelectableText(item['상점NO'] ?? '', style: TextStyle(color: Colors.black), showCursor: true))),
                    DataCell(Center(child: SelectableText(item['상점명'] ?? '', style: TextStyle(color: Colors.black), showCursor: true))),
                    DataCell(Center(child: SelectableText(item['사업자번호'] ?? '', style: TextStyle(color: Colors.black), showCursor: true))),
                    DataCell(Center(child: SelectableText(Utils.getCashComma(item['총주문금액']) ?? '', style: TextStyle(color: Colors.black, fontWeight: weight), showCursor: true))),
                    DataCell(Center(child: SelectableText(Utils.getCashComma(item['총결제금액']) ?? '', style: TextStyle(color: Colors.black, fontWeight: weight), showCursor: true))),
                    DataCell(Center(child: SelectableText(Utils.getCashComma(item['적립잔액']) ?? '', style: TextStyle(color: Colors.black, fontWeight: weight), showCursor: true))),
                    DataCell(Center(child: SelectableText(Utils.getCashComma(item['미납액']) ?? '', style: TextStyle(color: Colors.black, fontWeight: weight), showCursor: true))),
                    DataCell(Center(child: SelectableText(item['작업자'] ?? '', style: TextStyle(color: Colors.black), showCursor: true))),
                    DataCell(Center(child: SelectableText(item['메모'] ?? '', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true))),
                    DataCell(Center(
                        child: item['주문번호'] == '합계'
                            ? Container()
                            : IconButton(
                                onPressed: () {
                                 // _detail(orderNo: item['주문번호']);
                                },
                                icon: Icon(Icons.receipt_long),
                                tooltip: '상세',
                              ))),
                  ]);
                }).toList(),
                columns: <DataColumn>[
                  DataColumn(
                    label: Expanded(child: Text('주문번호', textAlign: TextAlign.center)),
                  ),
                  DataColumn(
                    label: Expanded(child: Text('적립일자', textAlign: TextAlign.center)),
                  ),
                  DataColumn(
                    label: Expanded(child: Text('적립구분', textAlign: TextAlign.center)),
                  ),
                  DataColumn(
                    label: Expanded(child: Text('상점NO', textAlign: TextAlign.center)),
                  ),
                  DataColumn(
                    label: Expanded(child: Text('상점명', textAlign: TextAlign.center)),
                  ),
                  DataColumn(
                    label: Expanded(child: Text('사업자번호', textAlign: TextAlign.center)),
                  ),
                  DataColumn(
                    label: Expanded(child: Text('총주문금액', textAlign: TextAlign.center)),
                  ),
                  DataColumn(
                    label: Expanded(child: Text('총결제금액', textAlign: TextAlign.center)),
                  ),
                  DataColumn(
                    label: Expanded(child: Text('적립잔액', textAlign: TextAlign.center)),
                  ),
                  DataColumn(
                    label: Expanded(child: Text('미납액', textAlign: TextAlign.center)),
                  ),
                  DataColumn(
                    label: Expanded(child: Text('작업자', textAlign: TextAlign.center)),
                  ),
                  DataColumn(
                    label: Expanded(child: Text('메모', textAlign: TextAlign.center)),
                  ),
                  DataColumn(
                    label: Expanded(child: Text('상세', textAlign: TextAlign.center)),
                  ),
                ],
              ),
            ),
            Divider(),
            SizedBox(
              height: 0,
            ),
            // showPagerBar(),
          ],
        ),
      ),
      //bottomNavigationBar: showPagerBar(),
    );

    return SizedBox(
      width: 1400,
      height: 700,
      child: result,
    );
  }

  Container showPagerBar() {
    return Container(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(),
              ),
              Expanded(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                        onPressed: () {
                          _currentPage = 1;

                          _pageMove(_currentPage);
                        },
                        icon: Icon(Icons.first_page)),
                    IconButton(
                        onPressed: () {
                          if (_currentPage == 1) return;

                          _pageMove(_currentPage--);
                        },
                        icon: Icon(Icons.chevron_left)),
                    Container(
                      width: 70,
                      child: Text(_currentPage.toInt().toString() + ' / ' + _totalPages.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ),
                    IconButton(
                        onPressed: () {
                          if (_currentPage >= _totalPages) return;

                          _pageMove(_currentPage++);
                        },
                        icon: Icon(Icons.chevron_right)),
                    IconButton(
                        onPressed: () {
                          _currentPage = _totalPages;
                          _pageMove(_currentPage);
                        },
                        icon: Icon(Icons.last_page))
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '조회 데이터 : ',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                    Text(
                      OrderController.to.totalRowCnt.toString() + ' / ' + OrderController.to.total_count.toString(),
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      '페이지당 행 수',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                    Container(
                      width: 70,
                      child: DropdownButton(
                          value: _selectedpagerows,
                          isExpanded: true,
                          style: TextStyle(fontSize: 12, color: Colors.black, fontFamily: 'NotoSansKR'),
                          items: Utils.getPageRowList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedpagerows = value;
                              _currentPage = 1;
                              _query();
                            });
                          }),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
