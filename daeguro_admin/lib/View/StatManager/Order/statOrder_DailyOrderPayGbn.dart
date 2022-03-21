import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Model/stat/statOrderDailyPayGbnModel.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/View/StatManager/stat_controller.dart';
import 'package:date_format/date_format.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class StatOrderDailyPayGbn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StatOrderDailyPayGbnState();
  }
}

class DailyDataSource extends DataGridSource {
  DailyDataSource({List<StatOrderDailyPayGbnModel> dailyDataSource}) {
    _data = dailyDataSource
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(
                columnName: 'ORDER_DATE',
                value: DateFormat("yyyy-MM-dd").format(DateTime.parse(e.ORDER_DATE.toString())).toString(),
              ),
              DataGridCell<String>(columnName: 'APP_CARD_CNT', value: Utils.getCashComma(e.APP_CARD_CNT.toString())),
              DataGridCell<String>(columnName: 'APP_CARD_AMT', value: Utils.getCashComma(e.APP_CARD_AMT.toString())),
              DataGridCell<String>(columnName: 'HAPPYPAY_CNT', value: Utils.getCashComma(e.HAPPYPAY_CNT.toString())),
              DataGridCell<String>(columnName: 'HAPPYPAY_AMT', value: Utils.getCashComma(e.HAPPYPAY_AMT.toString())),
              DataGridCell<String>(columnName: 'CARD_CNT', value: Utils.getCashComma(e.CARD_CNT.toString())),
              DataGridCell<String>(columnName: 'CARD_AMT', value: Utils.getCashComma(e.CARD_AMT.toString())),
              DataGridCell<String>(columnName: 'CASH_CNT', value: Utils.getCashComma(e.CASH_CNT.toString())),
              DataGridCell<String>(columnName: 'CASH_AMT', value: Utils.getCashComma(e.CASH_AMT.toString())),
      DataGridCell<String>(columnName: 'N_PAY_CNT', value: Utils.getCashComma(e.N_PAY_CNT.toString())),
      DataGridCell<String>(columnName: 'N_PAY_AMT', value: Utils.getCashComma(e.N_PAY_AMT.toString())),
            ]))
        .toList();
  }

  List<DataGridRow> _data = [];

  @override
  List<DataGridRow> get rows => _data;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      AlignmentGeometry _alignment;
      EdgeInsetsGeometry _margin;
      if (dataGridCell.columnName == 'ORDER_DATE') {
        _alignment = Alignment.center;
      } else {
        _alignment = Alignment.centerRight;
        _margin = EdgeInsets.fromLTRB(0, 0, 10, 0);
      }

      return Container(
        alignment: _alignment,
        margin: _margin,
        padding: EdgeInsets.all(2.0),
        child: Text(dataGridCell.value.toString(), overflow: TextOverflow.ellipsis),
      );
    }).toList());
  }
}

class StatOrderDailyPayGbnState extends State with AutomaticKeepAliveClientMixin {
  List<StatOrderDailyPayGbnModel> dataList = <StatOrderDailyPayGbnModel>[];
  DailyDataSource _dailyDataSource;

  SearchItems _searchItems = new SearchItems();

  final ScrollController _scrollHorizontalController = ScrollController();

  _reset() {
    _searchItems = null;
    _searchItems = new SearchItems();

    _searchItems.name = '';
    _searchItems.startdate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', '01']);
    _searchItems.enddate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
  }

  _query() {
    StatController.to.fromDate.value = _searchItems.startdate.replaceAll('-', '');
    StatController.to.toDate.value = _searchItems.enddate.replaceAll('-', '');

    loadData();
  }

  loadData() async {
    await ISProgressDialog(context).show(status: 'Loading...');

    await StatController.to.getDailyOrderPayGbn().then((value) {
      dataList.clear();

      if (this.mounted) {
        setState(() {
          int _cnt = 0;

          value.forEach((element) {
            StatOrderDailyPayGbnModel temp = StatOrderDailyPayGbnModel.fromJson(element);

            //처음에 두번 생성 후 하나 삭제 처리
            if (_cnt == 0) {
              dataList.add(temp);
              _cnt++;
            }

            dataList.add(temp);

            if (temp.ORDER_STATE == '네이버페이') {
              int compareIdx = dataList.indexWhere((item) => item.ORDER_DATE == temp.ORDER_DATE);

              dataList[compareIdx].N_PAY_CNT = temp.N_PAY_CNT;
              dataList[compareIdx].N_PAY_AMT = temp.N_PAY_AMT;

              dataList.removeAt(dataList.length - 1);
            } else if (temp.ORDER_STATE == '만나서 카드') {
              int compareIdx = dataList.indexWhere((item) => item.ORDER_DATE == temp.ORDER_DATE);

              dataList[compareIdx].CARD_CNT = temp.CARD_CNT;
              dataList[compareIdx].CARD_AMT = temp.CARD_AMT;

              dataList.removeAt(dataList.length - 1);
            } else if (temp.ORDER_STATE == '만나서 현금') {
              int compareIdx = dataList.indexWhere((item) => item.ORDER_DATE == temp.ORDER_DATE);

              dataList[compareIdx].CASH_CNT = temp.CASH_CNT;
              dataList[compareIdx].CASH_AMT = temp.CASH_AMT;

              dataList.removeAt(dataList.length - 1);
            } else if (temp.ORDER_STATE == '앱 카드') {
              int compareIdx = dataList.indexWhere((item) => item.ORDER_DATE == temp.ORDER_DATE);

              dataList[compareIdx].APP_CARD_CNT = temp.APP_CARD_CNT;
              dataList[compareIdx].APP_CARD_AMT = temp.APP_CARD_AMT;

              dataList.removeAt(dataList.length - 1);
            } else if (temp.ORDER_STATE == '행복페이') {
              int compareIdx = dataList.indexWhere((item) => item.ORDER_DATE == temp.ORDER_DATE);

              dataList[compareIdx].HAPPYPAY_CNT = temp.HAPPYPAY_CNT;
              dataList[compareIdx].HAPPYPAY_AMT = temp.HAPPYPAY_AMT;

              dataList.removeAt(dataList.length - 1);

              // 구분값 초기화 날짜 바뀔때마다 두번씩 생성해야됨
              _cnt = 0;
            }
          });

          _dailyDataSource = DailyDataSource(dailyDataSource: dataList);

          _scrollHorizontalController.jumpTo(10.0);
        });
      }
    });

    await ISProgressDialog(context).dismiss();
  }

  @override
  void initState() {
    super.initState();

    Get.put(StatController());
    Get.put(ShopController());

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
  void dispose() {
    if (dataList != null) {
      dataList.clear();
      dataList = null;
    }
    _searchItems = null;

    if (_scrollHorizontalController != null) _scrollHorizontalController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var buttonBar = Expanded(
      flex: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          ISSearchSelectDate(
            context,
            label: '시작일',
            width: 120,
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
          ISSearchSelectDate(
            context,
            label: '종료일',
            width: 120,
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
          SizedBox(
            width: 8,
          ),
          ISSearchButton(
            label: '조회',
            iconData: Icons.search,
            onPressed: () {
              _query();
            },
          ),
        ],
      ),
    );

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          buttonBar,
          Divider(),
          Scrollbar(
            isAlwaysShown: true,
            controller: _scrollHorizontalController,
            child: Container(
              width: Responsive.isDesktop(context) == true ? MediaQuery.of(context).size.width - 285 : 1260,
              height: MediaQuery.of(context).size.height - 240,
              child: ListView(
                  controller: _scrollHorizontalController,
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                        width: Responsive.isDesktop(context) == true ? MediaQuery.of(context).size.width - 285 : 1260,
                        height: MediaQuery.of(context).size.height - 240,
                      child: dataList.length == 0
                          ? Container()
                          : MediaQuery(
                        data: MediaQueryData(textScaleFactor: 1.0),
                        child: SfDataGrid(
                          source: _dailyDataSource,
                          columnWidthMode: ColumnWidthMode.fill,
                          gridLinesVisibility: GridLinesVisibility.vertical,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          onQueryRowHeight: (details) {
                            if (details.rowIndex == 0 || details.rowIndex == 1) {
                              return 30;
                            }
                            return 30;
                          },
                          columns: <GridColumn>[
                            GridColumn(
                                columnName: 'ORDER_DATE',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                      child: Text('일자',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                columnName: 'APP_CARD_CNT',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                      child: Text('일반카드건수',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                columnName: 'APP_CARD_AMT',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                      child: Text('일반카드금액',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                columnName: 'HAPPYPAY_CNT',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                      child: Text('행복페이건수',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                columnName: 'HAPPYPAY_AMT',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                      child: Text('행복페이금액',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                columnName: 'CARD_CNT',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                      child: Text('만나서카드건수',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                columnName: 'CARD_AMT',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                      child: Text('만나서카드금액',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                columnName: 'CASH_CNT',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                      child: Text('만나서현금건수',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                columnName: 'CASH_AMT',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                      child: Text('만나서현금금액',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                              GridColumn(
                                  columnName: 'N_PAY_CNT',
                                  label: Container(
                                      color: Colors.blue[50],
                                      alignment: Alignment.center,
                                      child: Text('건수',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                              GridColumn(
                                  columnName: 'N_PAY_AMT',
                                  label: Container(
                                      color: Colors.blue[50],
                                      alignment: Alignment.center,
                                      child: Text('금액',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                          ],
                          stackedHeaderRows: <StackedHeaderRow>[
                            StackedHeaderRow(cells: [
                              StackedHeaderCell(
                                  columnNames: ['APP_CARD_CNT', 'APP_CARD_AMT', 'HAPPYPAY_CNT', 'HAPPYPAY_AMT'],
                                  child: Container(
                                      color: Colors.blue[50],
                                        child: Center(
                                            child: Text('App 결제',
                                                style: TextStyle(
                                                    color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13))))),
                              StackedHeaderCell(
                                  columnNames: ['CARD_CNT', 'CARD_AMT', 'CASH_CNT', 'CASH_AMT'],
                                  child: Container(
                                      color: Colors.blue[50],
                                        child: Center(
                                            child: Text('만나서 결제',
                                                style: TextStyle(
                                                    color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13))))),
                                StackedHeaderCell(
                                    columnNames: ['N_PAY_CNT', 'N_PAY_AMT'],
                                    child: Container(
                                        color: Colors.blue[50],
                                        child: Center(
                                            child: Text('네이버 페이',
                                                style: TextStyle(
                                                    color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))))
                            ]),
                          ],
                        ),
                        ))
                  ]),
            ),
          ),
          Divider(),
          //showPagerBar(),
        ],
      ), //bottomNavigationBar: showPagerBar(),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
