import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Model/stat/statOrderDailyCompletedCanceledModel.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/View/StatManager/stat_controller.dart';
import 'package:date_format/date_format.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class StatOrderDailyCompletedCanceled extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StatOrderDailyCompletedCanceledState();
  }
}

class DailyDataSource extends DataGridSource {
  DailyDataSource({List<StatOrderDailyCompletedCanceledModel> dailyDataSource}) {
    _data = dailyDataSource
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(
        columnName: 'ORDER_DATE',
        value: DateFormat("yyyy-MM-dd").format(DateTime.parse(e.ORDER_DATE.toString())).toString(),
      ),
      DataGridCell<String>(columnName: 'CNT', value: Utils.getCashComma(e.CNT.toString())),
      DataGridCell<String>(columnName: 'TOT_AMT', value: Utils.getCashComma(e.TOT_AMT.toString())),
      DataGridCell<String>(columnName: 'TOT_DELITIP', value: Utils.getCashComma(e.TOT_DELITIP.toString())),
      DataGridCell<String>(columnName: 'FIRST_COUPON', value: Utils.getCashComma(e.FIRST_COUPON.toString())),
      DataGridCell<String>(columnName: 'RE_COUPON', value: Utils.getCashComma(e.RE_COUPON.toString())),
      DataGridCell<String>(columnName: 'MILEAGE', value: Utils.getCashComma(e.MILEAGE.toString())),
      DataGridCell<String>(columnName: 'HAPPYPAY_DISC', value: Utils.getCashComma(e.HAPPYPAY_DISC.toString())),
      DataGridCell<String>(columnName: 'C_CNT', value: Utils.getCashComma(e.C_CNT.toString())),
      DataGridCell<String>(columnName: 'C_TOT_AMT', value: Utils.getCashComma(e.C_TOT_AMT.toString())),
      DataGridCell<String>(columnName: 'C_TOT_DELITIP', value: Utils.getCashComma(e.C_TOT_DELITIP.toString())),
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

class StatOrderDailyCompletedCanceledState extends State with AutomaticKeepAliveClientMixin{
  List<StatOrderDailyCompletedCanceledModel> dataList = <StatOrderDailyCompletedCanceledModel>[];
  final CustomColumnSizer _customColumnSizer = CustomColumnSizer();

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

    await StatController.to.getDailyOrderCompletedCanceled().then((value) {
      dataList.clear();

      if (this.mounted) {
        setState(() {
          int _cnt = 0;

          value.forEach((element) {
            StatOrderDailyCompletedCanceledModel temp = StatOrderDailyCompletedCanceledModel.fromJson(element);

            dataList.add(temp);

            if (temp.ORDER_STATE == '취소') {
              int compareIdx = dataList.indexWhere((item) => item.ORDER_DATE == temp.ORDER_DATE);
              dataList[compareIdx].ORDER_STATE = temp.ORDER_STATE;

              dataList[compareIdx].C_CNT = temp.CNT;
              dataList[compareIdx].C_TOT_AMT = temp.TOT_AMT;
              dataList[compareIdx].C_TOT_DELITIP = temp.TOT_DELITIP;
              dataList[compareIdx].C_FIRST_COUPON = temp.FIRST_COUPON;
              dataList[compareIdx].C_RE_COUPON = temp.RE_COUPON;
              dataList[compareIdx].C_MILEAGE = temp.MILEAGE;
              dataList[compareIdx].C_HAPPYPAY_DISC = temp.HAPPYPAY_DISC;

              dataList.removeAt(dataList.length - 1);
            }
          });

          _dailyDataSource = DailyDataSource(dailyDataSource: dataList);
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
            SizedBox(width: 8,),
            ISSearchButton(
              label: '조회',
              iconData: Icons.search,
              onPressed: () {
                _query();
              },
            ),
          ],
        )
    );

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10,),
          buttonBar,
          Divider(),
          Scrollbar(
            isAlwaysShown: true,
            controller: _scrollHorizontalController,
            child: Container(
              width: Responsive.isDesktop(context) == true ? MediaQuery.of(context).size.width-285 : 1260,
              height: MediaQuery.of(context).size.height-240,
              child: ListView(
                  controller: _scrollHorizontalController,
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      width: Responsive.isDesktop(context) == true ? MediaQuery.of(context).size.width-285 : 1260,
                      height: MediaQuery.of(context).size.height-240,
                      child: dataList.length == 0
                          ? Container()
                          : MediaQuery(
                        data: MediaQueryData(textScaleFactor: 1.0),
                        child: SfDataGrid(
                          source: _dailyDataSource,
                          columnSizer: _customColumnSizer,
                          columnWidthMode: ColumnWidthMode.fill,
                          gridLinesVisibility: GridLinesVisibility.vertical,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          onQueryRowHeight: (details) {
                            if (details.rowIndex == 0 || details.rowIndex == 1 || details.rowIndex == 2) {
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
                                    child: Text('일자', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                columnName: 'CNT',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('완료 건수', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                columnName: 'TOT_AMT',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('총 음식금액', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                columnName: 'TOT_DELITIP',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('총 배달팁', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                columnName: 'FIRST_COUPON',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('첫주문쿠폰', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                columnName: 'RE_COUPON',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('재주문쿠폰', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                columnName: 'MILEAGE',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('마일리지', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                columnName: 'HAPPYPAY_DISC',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('행복페이할인', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                columnName: 'C_CNT',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('취소건수', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                columnName: 'C_TOT_AMT',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('총음식금액', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                columnName: 'C_TOT_DELITIP',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('총 배달팁', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                          ],
                          stackedHeaderRows: <StackedHeaderRow>[
                            StackedHeaderRow(cells: [
                              StackedHeaderCell(
                                  columnNames: ['CNT', 'TOT_AMT', 'TOT_DELITIP', 'FIRST_COUPON', 'RE_COUPON', 'MILEAGE', 'HAPPYPAY_DISC'],
                                  child: Container(
                                      color: Colors.blue[50],
                                      child: Center(child: Text('완료', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13))))),
                              StackedHeaderCell(
                                  columnNames: ['C_CNT', 'C_TOT_AMT', 'C_TOT_DELITIP'],
                                  child: Container(
                                      color: Colors.blue[50],
                                      child: Center(child: Text('취소', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))))
                            ]),
                            StackedHeaderRow(cells: [
                              StackedHeaderCell(
                                  columnNames: ['TOT_AMT', 'TOT_DELITIP'],
                                  child: Container(
                                      color: Colors.blue[50],
                                      child: Center(child: Text('총 주문금액', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13))))),
                              StackedHeaderCell(
                                  columnNames: ['FIRST_COUPON', 'RE_COUPON', 'MILEAGE', 'HAPPYPAY_DISC'],
                                  child: Container(
                                      color: Colors.blue[50],
                                      child: Center(child: Text('인성할인', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13))))),
                              StackedHeaderCell(
                                  columnNames: ['C_TOT_AMT', 'C_TOT_DELITIP'],
                                  child: Container(
                                      color: Colors.blue[50],
                                      child: Center(child: Text('총 주문금액', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))))
                            ]),
                          ],
                        ),
                      )
                    )
                  ]
              ),
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

class CustomColumnSizer extends ColumnSizer {
  @override
  double computeHeaderCellWidth(GridColumn column, TextStyle style) {
    if (column.columnName == 'CNT') {
      style = TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.bold);
    }

    return super.computeHeaderCellWidth(column, style);
  }

  @override
  double computeCellWidth(GridColumn column, DataGridRow row, Object cellValue, TextStyle textStyle) {
    if (column.columnName == 'CNT') {
      textStyle = TextStyle(fontSize: 10, fontWeight: FontWeight.bold);
    }

    return super.computeCellWidth(column, row, cellValue, textStyle);
  }
}