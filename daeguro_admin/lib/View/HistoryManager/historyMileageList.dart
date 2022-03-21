
import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/Model/mileageHistoryModel.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/View/CustomerManager/customerList.dart';
import 'package:daeguro_admin_app/View/HistoryManager/history_controller.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/OrderManager/orderDetail.dart';
import 'package:daeguro_admin_app/View/OrderManager/orderManager_controller.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccountList.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/constants/constant.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class HistoryMileageList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HistoryMileageListState();
  }
}

class HistoryMileageListState extends State {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final List<mileageHistoryModel> dataList = <mileageHistoryModel>[];

  SearchItems _searchItems = new SearchItems();

  //int rowsPerPage = 10;

  int _totalRowCnt = 0;
  int _selectedpagerows = 15;

  int _currentPage = 1;
  int _totalPages = 0;

  void _pageMove(int _page) {
    _query();
  }

  _reset() {
    _searchItems = null;
    _searchItems = new SearchItems();

    _searchItems.startdate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', '01']);
    _searchItems.enddate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    //loadData();
  }

  _query() {
    HistoryController.to.fromDate.value = _searchItems.startdate.replaceAll('-', '');
    HistoryController.to.toDate.value = _searchItems.enddate.replaceAll('-', '');

    HistoryController.to.page.value = _currentPage;
    HistoryController.to.raw.value = _selectedpagerows;
    loadData();
  }

  loadData() async {
    await ISProgressDialog(context).show(status: 'Loading...');

    dataList.clear();

    await HistoryController.to.getHistoryMileageData().then((value) {
      if (this.mounted) {
        if (value == null) {
          ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
        }
        else{
          setState(() {
            dataList.clear();
            value.forEach((e) {
              mileageHistoryModel temp = mileageHistoryModel.fromJson(e);
              temp.LOG_DATE = temp.LOG_DATE.replaceAll('T', '  ');
              dataList.add(temp);
            });

            _totalRowCnt = int.parse(HistoryController.to.totalHistoryCnt.toString());
            _totalPages = (_totalRowCnt / _selectedpagerows).ceil();
          });
        }
      }
    });
    // dataList.clear();
    //
    // await NoticeController.to.getData(context);
    //
    // if (this.mounted) {
    //   setState(() {
    //     NoticeController.to.qData.forEach((e) {
    //       noticeListModel temp = noticeListModel.fromJson(e);
    //       dataList.add(temp);
    //     });
    //
    //     _totalRowCnt = NoticeController.to.totalRowCnt;
    //     _totalPages = (_totalRowCnt / _selectedpagerows).ceil();
    //   });
    // }

    await ISProgressDialog(context).dismiss();
  }

  @override
  void initState() {
    super.initState();

    Get.put(OrderController());
    Get.put(HistoryController());

    WidgetsBinding.instance.addPostFrameCallback((c) {
      _reset();
      _query();
    });

    setState(() {
      _searchItems.startdate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', '01']);
      _searchItems.enddate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    });
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
          //testSearchBox(),
        ],
      ),
    );

    var buttonBar = Expanded(
      flex: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Text('총: ${Utils.getCashComma(HistoryController.to.totalHistoryCnt.toString())}건', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
            ],
          ),
          Row(
            children: [
              ISSearchSelectDate(
                context,
                label: '시작일',
                width: 120,
                value: _searchItems.startdate.toString(),
                onTap: () async {
                  DateTime valueDt = isBlank
                      ? DateTime.now()
                      : DateTime.parse(_searchItems.startdate);
                  final DateTime picked = await showDatePicker(
                    context: context,
                    initialDate: valueDt,
                    firstDate: DateTime(1900, 1),
                    lastDate: DateTime(2031, 12),
                  );

                  setState(() {
                    if (picked != null) {
                      _searchItems.startdate =
                          formatDate(picked, [yyyy, '-', mm, '-', dd]);
                    }
                  });
                },
              ),
              ISSearchSelectDate(
                context,
                label: '종료일',
                width: 120,
                value: _searchItems.enddate.toString(),
                onTap: () async {
                  DateTime valueDt = isBlank
                      ? DateTime.now()
                      : DateTime.parse(_searchItems.enddate);
                  final DateTime picked = await showDatePicker(
                    context: context,
                    initialDate: valueDt,
                    firstDate: DateTime(1900, 1),
                    lastDate: DateTime(2031, 12),
                  );

                  setState(() {
                    if (picked != null) {
                      _searchItems.enddate =
                          formatDate(picked, [yyyy, '-', mm, '-', dd]);
                    }
                  });
                },
              ),
              SizedBox(
                width: 8,
              ),
              ISSearchButton(
                  label: '조회',
                  iconData: Icons.search,
                  onPressed: () => {_currentPage = 1, _query()}),
            ],
          )
        ],
      ),
    );

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          form,
          buttonBar,
          Divider(),
          ISDatatable(
            panelHeight: (MediaQuery.of(context).size.height-defaultContentsHeight),
            listWidth: Responsive.getResponsiveWidth(context, 720), // Responsive.isTablet(context) ? MediaQuery.of(context).size.width : contentListWidth,
            rows: dataList.map((item) {
              return DataRow(cells: [
                //DataCell(Center(child: Text(item.ORDER_NO.toString() ?? '--', style: TextStyle(color: Colors.black), ))),
                DataCell(Center( child: Text(item.LOG_DATE.toString() ?? '--', style: TextStyle(color: Colors.black)),)),
                DataCell(Center(child: Text(Utils.getCashComma(item.MILEAGE_AMT.toString() ?? '0') , style: TextStyle(color: Colors.black), ))),
                DataCell(Center(child: Text(Utils.getCashComma(item.MILEAGE_USE_AMT.toString() ?? '0') , style: TextStyle(color: Colors.black), ))),
                DataCell(Center(child: MaterialButton(
                  height: 30.0,
                  color: Color.fromRGBO(0, 168, 181, 1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  child: Text(item.CUST_NAME.toString(), style: TextStyle(fontSize: 13, color: Colors.white)),
                  onPressed: () {
                    double poupWidth = 700;
                    double poupHeight = 600;

                    showDialog(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                        child: SizedBox(
                          width: poupWidth,
                          height: poupHeight,
                          child: Scaffold(
                            appBar: AppBar(
                              title: Text('회원 정보'),
                            ),
                            body: CustomerList(custCode: item.CUST_CODE, popWidth: poupWidth, popHeight: poupHeight),
                          ),
                        ),
                      ),
                    );
                  },
                )),
                ),
                DataCell(Align(child: (item.SHOP_NAME.toString() == null || item.SHOP_NAME.toString() == 'null') ? Container() : MaterialButton(
                  height: 30.0,
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  child: Text(item.SHOP_NAME.toString(), style: TextStyle(fontSize: 13, color: Colors.white)),
                  onPressed: () {
                    double poupWidth = 1040;
                    double poupHeight = 600;

                    showDialog(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                        child: SizedBox(
                          width: poupWidth,
                          height: poupHeight,
                          child: Scaffold(
                            appBar: AppBar(
                              title: Text('사용 가맹점 - ${item.SHOP_NAME}'),
                            ),
                            body: ShopAccountList(shopName: item.SHOP_NAME, popWidth: poupWidth, popHeight: poupHeight),
                          ),
                        ),
                      ),
                    );
                  },
                ), alignment: Alignment.centerLeft),
                ),
                DataCell(Center(child: (item.ORDER_NO.toString() == null || item.ORDER_NO.toString() == 'null') ? Container() : MaterialButton(
                  height: 30.0,
                  color: Color.fromRGBO(192, 108, 132, 1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  child: Text('주문번호: ${item.ORDER_NO.toString()}', style: TextStyle(fontSize: 13, color: Colors.white)),
                  onPressed: () async {
                    await OrderController.to.getDetailData(item.ORDER_NO.toString(), context);

                    showDialog(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                        child: OrderDetail(orderNo: item.ORDER_NO.toString()),
                      ),
                    );
                  },
                )),
                ),
              ]);
            }).toList(),
            columns: <DataColumn>[
              DataColumn(label: Expanded(child: Text('적립일시', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('적립금액', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('사용금액', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('회원명', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('사용처', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('사용내역', textAlign: TextAlign.center)), ),
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
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontFamily: 'NotoSansKR'),
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

  String _getNoticeGbn(String value) {
    String retValue = '--';

    if (value.toString().compareTo('1') == 0)
      retValue = '공지';
    else if (value.toString().compareTo('3') == 0) retValue = '이벤트';

    return retValue;
  }
}
