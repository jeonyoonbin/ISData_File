import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select_date.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/AgentManager/agentAccount_Controller.dart';
import 'package:daeguro_admin_app/View/CalculateManager/calculateOutstandingAmount_detail.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/OrderManager/orderManager_controller.dart';
import 'package:daeguro_admin_app/constants/constant.dart';

import 'package:date_format/date_format.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class CalculateOutstandingAmount extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CalculateOutstandingAmountState();
  }
}

class CalculateOutstandingAmountState extends State<CalculateOutstandingAmount> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final List<Map> dataList = [];
  final List<Map> list = <Map>[
    {
      '적립구분': '미수금',
      '상점번호': '2610',
      '상점명': '공주찜닭',
      '상점전화': '05355530037',
      '사업자번호': '5038150051',
      '적립잔액': '0',
      '미수금액': '400',
      '발생건수': '2',
      '합계': '400',
      '출금하기': '미발행',
      '메모': '음식값 정산콜센터에서 입금\nBC카드 / 85071146'
    },
    {
      '적립구분': '미수금',
      '상점번호': '2611',
      '상점명': '롯데리아',
      '상점전화': '05355530037',
      '사업자번호': '5038150051',
      '적립잔액': '0',
      '미수금액': '1000',
      '발생건수': '5',
      '합계': '1000',
      '출금하기': '미발행',
      '메모': '음식값 정산콜센터에서 입금\nBC카드 / 85071146'
    },{
      '적립구분': '미수금',
      '상점번호': '2612',
      '상점명': '왕자치킨',
      '상점전화': '05355530037',
      '사업자번호': '5038150051',
      '적립잔액': '0',
      '미수금액': '1500',
      '발생건수': '10',
      '합계': '1500',
      '출금하기': '미발행',
      '메모': '음식값 정산콜센터에서 입금\nBC카드 / 85071146'
    },
  ];

  bool excelEnable = true;

  List MCodeListitems = List();

  String _State = ' ';

  String _mCode = '2';

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
    OrderController.to.state.value = _State;
    OrderController.to.tel.value = _searchItems.tel;
    OrderController.to.name.value = _searchItems.name;
    OrderController.to.page.value = _currentPage.round().toString();
    OrderController.to.raw.value = _selectedpagerows.toString();
    loadData();
  }

  _detail({String orderNo}) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: CalculateOutstandingAmountDetail(),
      ),
    );
  }

  loadMCodeListData() async {
    //MCodeListitems.clear();
    //MCodeListitems = await AgentController.to.getDataMCodeItems();
    //MCodeListitems = AgentController.to.qDataMCodeItems;

    MCodeListitems = Utils.getMCodeList();

    //if (this.mounted) {
      setState(() {});
    //}
  }

  loadData() async {
    dataList.clear();

    dataList.assignAll(list);

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
      loadMCodeListData();
      _reset();
      _query();
    });

    setState(() {
      _searchItems.startdate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', '01']);
      _searchItems.enddate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    });
  }

  @override
  void dispose() {
    dataList.clear();
    //MCodeListitems.clear();

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

    var buttonBar = Expanded(
      flex: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ISSearchDropdown(
            label: '회원사명',
            value: _mCode,
            onChange: (value) {
              setState(() {
                _currentPage = 1;
                _mCode = value;
                _query();
              });
            },
            width: 200,
            item: MCodeListitems.map((item) {
              return new DropdownMenuItem<String>(
                  child: new Text(
                    item['mName'],
                    style: TextStyle(fontSize: 13, color: Colors.black),
                  ),
                  value: item['mCode']);
            }).toList(),
          ),
          ISSelectDate(
            context,
            label: '시작일',
            width: 140,
            value: _searchItems.startdate.toString(),
            onTap: () async {
              DateTime valueDt = isBlank ? DateTime.now() : DateTime.parse(_searchItems.startdate);
              final DateTime picked = await showDatePicker(
                context: context,
                initialDate: valueDt,
                firstDate: DateTime(1900, 1),
                lastDate: DateTime(2031, 12),
              );

              setState(() {
                if (picked != null) {
                  _searchItems.startdate = formatDate(picked, [yyyy, '-', mm, '-', dd]);
                }
              });
            },
          ),
          ISSelectDate(
            context,
            label: '종료일',
            width: 140,
            value: _searchItems.enddate.toString(),
            onTap: () async {
              DateTime valueDt = isBlank ? DateTime.now() : DateTime.parse(_searchItems.enddate);
              final DateTime picked = await showDatePicker(
                context: context,
                initialDate: valueDt,
                firstDate: DateTime(1900, 1),
                lastDate: DateTime(2031, 12),
              );

              setState(() {
                if (picked != null) {
                  _searchItems.enddate = formatDate(picked, [yyyy, '-', mm, '-', dd]);
                }
              });
            },
          ),
          Container(
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                ISInput(
                  label: '주문번호, 전화번호, 사업자번호, 콜센터명',
                  width: 300,
                  value: _searchItems.name,
                  onChange: (v) {
                    _searchItems.name = v;
                  },
                  onFieldSubmitted: (v) {
                    _currentPage = 1;
                    _query();
                  },
                ),
              ],
            ),
          ),
          Container(
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                ISInput(
                  label: '메모',
                  width: 300,
                  value: _searchItems.name,
                  onChange: (v) {
                    _searchItems.name = v;
                  },
                  onFieldSubmitted: (v) {
                    _currentPage = 1;
                    _query();
                  },
                ),
              ],
            ),
          ),
          ISButton(
              label: '조회',
              iconData: Icons.search,
              onPressed: () => {
                _currentPage = 1,
                _query(),
              }),
        ]
      ),
    );

    Container bar2 = Container(
      padding: EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('총 미수금액: ${Utils.getCashComma('12345')}', style: TextStyle(color: Colors.black),),
              SizedBox(width: 16),
              Text('총 발생건수: ${Utils.getCashComma('1222222')}', style: TextStyle(color: Colors.black),),
              SizedBox(width: 16),
              Text('총 합계: ${Utils.getCashComma('333333')}', style: TextStyle(color: Colors.black),),
            ],
          ),
          ISButton(label: '출금하기', iconColor: Colors.white, iconData: Icons.reply, textStyle: TextStyle(color: Colors.white), onPressed: () {}),
        ],
      ),
    );

    return Container(
      //padding: EdgeInsets.only(left: 50, right: 50, bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          form,
          buttonBar,
          Divider(),
          bar2,
          ISDatatable(
            panelHeight: (MediaQuery.of(context).size.height-defaultContentsHeight),
            listWidth: Responsive.getResponsiveWidth(context, 640),
            rows: dataList.map((item) {
              if (item['적립구분'] == '합계') {
                weight = FontWeight.bold;
              } else {
                weight = FontWeight.normal;
              }
              return DataRow(cells: [
                DataCell(Center(child: SelectableText(item['적립구분'] ?? '', style: TextStyle(color: Colors.black, fontWeight: weight), showCursor: true))),
                DataCell(Center(child: SelectableText(item['상점번호'] ?? '', style: TextStyle(color: Colors.black, fontSize: 12), textAlign: TextAlign.center, showCursor: true))),
                DataCell(Center(child: SelectableText(item['상점명'] ?? '', style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center(child: SelectableText(Utils.getPhoneNumFormat(item['상점전화'], true) ?? '', style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center(child: SelectableText(Utils.getStoreRegNumberFormat(item['사업자번호'], false) ?? '', style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center(child: SelectableText(Utils.getCashComma(item['적립잔액']) ?? '', style: TextStyle(color: Colors.black, fontWeight: weight), showCursor: true))),
                DataCell(Center(child: SelectableText(Utils.getCashComma(item['미수금액']) ?? '', style: TextStyle(color: Colors.black, fontWeight: weight), showCursor: true))),
                DataCell(Center(child: SelectableText(item['발생건수'] ?? '--', style: TextStyle(color: Colors.black, fontWeight: weight), showCursor: true))),
                DataCell(Center(child: SelectableText(Utils.getCashComma(item['합계']) ?? '', style: TextStyle(color: Colors.black, fontWeight: weight), showCursor: true))),
                DataCell(Center(child: SelectableText(item['출금하기'] ?? '', style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center(child: SelectableText(item['메모'] ?? '', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true))),
                DataCell(Center(
                    child: item['적립구분'] == '합계'
                        ? Container()
                        : IconButton(
                      onPressed: () {
                        _detail(orderNo: item['상점번호']);
                      },
                      icon: Icon(Icons.receipt_long),
                      tooltip: '상세',
                    ))),
              ]);
            }).toList(),
            columns: <DataColumn>[
              DataColumn(label: Expanded(child: Text('적립구분', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('상점번호', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('상점명', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('상점전화', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('사업자번호', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('적립잔액', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('미수금액', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('발생건수', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('합계', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('출금하기', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('메모', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('상세', textAlign: TextAlign.center)),),
            ],
          ),
          Divider(),
          SizedBox(
            height: 0,
          ),
          showPagerBar(),
        ],
      ),
    );
  }

  Container showPagerBar() {
    return Container(
      //padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Row(
              children: <Widget>[
                //Text('row1'),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                    onTap: () {
                      _currentPage = 1;

                      _pageMove(_currentPage);
                    },
                    child: Icon(Icons.first_page)),
                InkWell(
                    onTap: () {
                      if (_currentPage == 1) return;

                      _pageMove(_currentPage--);
                    },
                    child: Icon(Icons.chevron_left)),
                Container(
                  //width: 70,
                  child: Text(_currentPage.toInt().toString() + ' / ' + _totalPages.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ),
                InkWell(
                    onTap: () {
                      if (_currentPage >= _totalPages) return;

                      _pageMove(_currentPage++);
                    },
                    child: Icon(Icons.chevron_right)),
                InkWell(
                    onTap: () {
                      _currentPage = _totalPages;
                      _pageMove(_currentPage);
                    },
                    child: Icon(Icons.last_page))
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Responsive.isMobile(context) ? Container(height: 48) : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text('페이지당 행 수 : ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),),
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
      ),
    );
  }
}
