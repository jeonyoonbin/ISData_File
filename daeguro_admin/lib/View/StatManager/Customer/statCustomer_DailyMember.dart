import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/Model/businessMenuItem.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Model/stat/statCustomerDailyModel.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/View/StatManager/stat_controller.dart';
import 'package:daeguro_admin_app/Util/utils.dart';

import 'package:date_format/date_format.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class StatCustomerDailyList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StatCustomerDailyListState();
  }
}

class DailyDataSource extends DataGridSource {
  DailyDataSource({List<StatCustomerDailyModel> dailyDataSource}) {
    _data = dailyDataSource
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(
          columnName: 'REG_DATE',
          value: e.REG_DATE.toString() == '합계'
              ? '합계'
              : DateFormat("yyyy-MM-dd").format(DateTime.parse(e.REG_DATE.toString())).toString()
      ),
      DataGridCell<String>(columnName: 'A', value: e.A.toString()),
      DataGridCell<String>(columnName: 'B', value: e.B.toString()),
      DataGridCell<String>(columnName: 'C', value: e.C.toString()),
      DataGridCell<String>(columnName: 'D', value: e.D.toString()),
      DataGridCell<String>(columnName: 'E', value: e.E.toString()),
      DataGridCell<String>(columnName: 'F', value: e.F.toString()),
    ]))
        .toList();
  }

  List<DataGridRow> _data = [];

  @override
  List<DataGridRow> get rows => _data;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    Color getRowBackgroundColor() {
      final String gbn = row.getCells()[0].value;
      if (gbn == '합계') {
        return Colors.blue[50];
      } else {
        return null;
      }
      return Colors.transparent;
    }

    TextStyle getRowTextStyle() {
      final String gbn = row.getCells()[0].value;
      if (gbn == '합계') {
        return TextStyle(fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR');
      } else {
        return null;
      }
    }

    String _getsum(String _value) {
      return row.getCells()[1].value;
    }

    return DataGridRowAdapter(
        color: getRowBackgroundColor(),
        cells: row.getCells().map<Widget>((dataGridCell) {
          AlignmentGeometry _alignment;
          EdgeInsetsGeometry _margin;

          if (dataGridCell.columnName == 'REG_DATE') {
            _alignment = Alignment.center;
          } else {
            _alignment = Alignment.centerRight;
            _margin = EdgeInsets.fromLTRB(0, 0, 10, 0);
          }

          return Container(
            alignment: _alignment,
            margin: _margin,
            padding: EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: dataGridCell.columnName == 'REG_DATE' ? MainAxisAlignment.center : MainAxisAlignment.end,
              children: [
                dataGridCell.columnName == 'REG_DATE'
                    ? Text(dataGridCell.value.toString(), overflow: TextOverflow.ellipsis, style: getRowTextStyle())
                    : dataGridCell.columnName == 'E'
                    ? Text(Utils.getCashComma(dataGridCell.value), overflow: TextOverflow.ellipsis, style: getRowTextStyle())
                    : Row(
                  children: [Text(Utils.getCashComma(dataGridCell.value), overflow: TextOverflow.ellipsis, style: getRowTextStyle())],
                )
              ],
            ),
          );
        }).toList());
  }
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

class StatCustomerDailyListState extends State with AutomaticKeepAliveClientMixin{
  List<StatCustomerDailyModel> dataList = <StatCustomerDailyModel>[];

  DailyDataSource _dailyDataSource;

  int _sumA = 0;
  int _sumB = 0;
  int _sumC = 0;
  int _sumD = 0;
  int _sumE = 0;
  int _sumF = 0;

  final Map<String, dynamic> sumData = new Map<String, dynamic>();

  final CustomColumnSizer _customColumnSizer = CustomColumnSizer();

  List<String> rightColumnTitle = [];
  List<BusinessMenuItem> leftColumnList = [];

  SearchItems _searchItems = new SearchItems();

  final double left_ColumnWidth = 130;
  final double right_ColumnWidth = 60;
  final double ColumnHeight = 30;

  final ScrollController _scrollHorizontalController = ScrollController();

  int listDummyMaxSize = 25;

  _reset() {
    _searchItems = null;
    _searchItems = new SearchItems();

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

    _sumA = 0;
    _sumB = 0;
    _sumC = 0;
    _sumD = 0;
    _sumE = 0;
    _sumF = 0;

    if (dataList != null) dataList.clear();

    await StatController.to.getCustomerDailyData().then((value) {
      if (this.mounted) {
        if (value == null) {
          ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
        } else {
          setState(() {
            value.forEach((element) {
              StatCustomerDailyModel temp = StatCustomerDailyModel.fromJson(element);

              if (temp.A == null) temp.A = 0;
              if (temp.B == null) temp.B = 0;
              if (temp.C == null) temp.C = 0;
              if (temp.D == null) temp.D = 0;
              if (temp.E == null) temp.E = 0;
              if (temp.F == null) temp.F = 0;

              _sumA = _sumA + temp.A;
              _sumB = _sumB + temp.B;
              _sumC = _sumC + temp.C;
              _sumD = _sumD + temp.D;
              _sumE = _sumE + temp.E;
              _sumF = _sumF + temp.F;

              dataList.add(temp);
            });

            // 합계 추가
            sumData['A'] = _sumA;
            sumData['B'] = _sumB;
            sumData['C'] = _sumC;
            sumData['D'] = _sumD;
            sumData['E'] = _sumE;
            sumData['F'] = _sumF;
            sumData['REG_DATE'] = '합계';

            dataList.add(StatCustomerDailyModel.fromJson(sumData));

          });
        }
      }

      _dailyDataSource = DailyDataSource(dailyDataSource: dataList);
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
      //_scrollHorizontalController.jumpTo(100.0);
    });

    setState(() {
      _searchItems.startdate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', '01']);
      _searchItems.enddate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    });
  }

  @override
  void dispose() {
    if (dataList != null){
      dataList.clear();
      dataList = null;
    }

    if (rightColumnTitle != null){
      rightColumnTitle.clear();
      rightColumnTitle = null;
    }

    if (leftColumnList != null){
      leftColumnList.clear();
      leftColumnList = null;
    }

    if (_scrollHorizontalController != null)
      _scrollHorizontalController.dispose();

    _searchItems = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var buttonBar = Expanded(
      flex: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
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
      ),
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
              width: 1600,
              height: MediaQuery.of(context).size.height-240,
              child: ListView(
                  controller: _scrollHorizontalController,
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      width: 1600,
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
                          headerRowHeight: 40,
                          rowHeight: 40,
                          columns: <GridColumn>[
                            GridColumn(
                                width: 130,
                                columnName: 'REG_DATE',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('일자',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                width: 100,
                                columnName: 'A',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('공공앱',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                width: 100,
                                columnName: 'B',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('구글',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                width: 100,
                                columnName: 'C',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('카카오',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                width: 100,
                                columnName: 'D',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('네이버',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                width: 100,
                                columnName: 'E',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('애플',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                width: 100,
                                columnName: 'F',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('비회원',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                          ],
                        ),
                      )
                    )
                  ]
              ),
            ),
          ),
          Divider(height: 20,),
          SizedBox(height: 30,)
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
