import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Model/stat/statOrderPayModel.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/View/StatManager/stat_controller.dart';
import 'package:date_format/date_format.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class StatOrderPayList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StatOrderPayListState();
  }
}

class DailyDataSource extends DataGridSource {
  DailyDataSource({List<StatOrderPayModel> dailyDataSource}) {
    _data = dailyDataSource
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(
        columnName: 'ORDER_DATE',
        value: e.ORDER_DATE.toString() != '합계'
            ? DateFormat("yyyy-MM-dd").format(DateTime.parse(e.ORDER_DATE.toString())).toString()
            : e.ORDER_DATE.toString(),
      ),
      DataGridCell<String>(columnName: 'F', value: e.F.toString()),
      DataGridCell<String>(columnName: 'A', value: e.A.toString()),
      DataGridCell<String>(columnName: 'B', value: e.B.toString()),
      DataGridCell<String>(columnName: 'C', value: e.C.toString()),
      DataGridCell<String>(columnName: 'D', value: e.D.toString()),
      DataGridCell<String>(columnName: 'E', value: e.E.toString()),
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
            child: Row(
              mainAxisAlignment: dataGridCell.columnName == 'ORDER_DATE' ? MainAxisAlignment.center : MainAxisAlignment.end,
              children: [
                dataGridCell.columnName == 'ORDER_DATE'
                    ? Text(dataGridCell.value.toString(), overflow: TextOverflow.ellipsis, style: getRowTextStyle())
                    : dataGridCell.columnName == 'F'
                    ? Text(Utils.getCashComma(dataGridCell.value), overflow: TextOverflow.ellipsis, style: getRowTextStyle())
                    : Row(
                  children: [
                    Text(Utils.getCashComma(dataGridCell.value), overflow: TextOverflow.ellipsis, style: getRowTextStyle()),
                    Text(' (' + (double.parse(dataGridCell.value) / double.parse(_getsum(dataGridCell.value)) * 100).toStringAsFixed(1) + '%)',
                        overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.blue)),
                  ],
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

class StatOrderPayListState extends State {
  List<StatOrderPayModel> dataList = <StatOrderPayModel>[];
  final CustomColumnSizer _customColumnSizer = CustomColumnSizer();

  final Map<String, dynamic> sumData = new Map<String, dynamic>();

  DailyDataSource _dailyDataSource;

  SearchItems _searchItems = new SearchItems();

  int listDummyMaxSize = 25;
  int _sum_A;
  int _sum_B;
  int _sum_C;
  int _sum_D;
  int _sum_E;
  int _sum_F;

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

    _sum_A = 0;
    _sum_B = 0;
    _sum_C = 0;
    _sum_D = 0;
    _sum_E = 0;
    _sum_F = 0;

    if (dataList != null) dataList.clear();

    if (sumData != null) sumData.clear();

    await StatController.to.getOrderPayData().then((value) {
      if (this.mounted) {
        if (value == null) {
          ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
        } else {
          setState(() {
            value.forEach((element) {
              StatOrderPayModel temp = StatOrderPayModel.fromJson(element);

              if (temp.A == null) temp.A = 0;

              if (temp.B == null) temp.B = 0;

              if (temp.C == null) temp.C = 0;

              if (temp.D == null) temp.D = 0;

              if (temp.E == null) temp.E = 0;

              if (temp.E == null) temp.F = 0;

              _sum_A = _sum_A + temp.A;
              _sum_B = _sum_B + temp.B;
              _sum_C = _sum_C + temp.C;
              _sum_D = _sum_D + temp.D;
              _sum_E = _sum_E + temp.E;
              _sum_F = _sum_F + temp.F;

              dataList.add(temp);
            });

            // 합계 추가
            sumData['A'] = _sum_A;
            sumData['B'] = _sum_B;
            sumData['C'] = _sum_C;
            sumData['D'] = _sum_D;
            sumData['E'] = _sum_E;
            sumData['F'] = _sum_F;
            sumData['ORDER_DATE'] = '합계';

            dataList.add(StatOrderPayModel.fromJson(sumData));
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

    if (sumData != null) {
      sumData.clear();
    }

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
          Expanded(
            //height: MediaQuery.of(context).size.height - 286,
            //padding: const EdgeInsets.only(top: 10.0),
            //height: 400,
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
                      columnName: 'ORDER_DATE',
                      label: Container(
                          color: Colors.blue[50],
                          alignment: Alignment.center,
                          child: Text('일자',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                  GridColumn(
                      width: 100,
                      columnName: 'F',
                      label: Container(
                          color: Colors.blue[50],
                          alignment: Alignment.center,
                          child: Text('합계',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                  GridColumn(
                      width: 120,
                      columnName: 'A',
                      label: Container(
                          color: Colors.blue[50],
                          alignment: Alignment.center,
                          child: Text('만나서 카드',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                  GridColumn(
                      width: 120,
                      columnName: 'B',
                      label: Container(
                          color: Colors.blue[50],
                          alignment: Alignment.center,
                          child: Text('앱 카드',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                  GridColumn(
                      width: 120,
                      columnName: 'C',
                      label: Container(
                          color: Colors.blue[50],
                          alignment: Alignment.center,
                          child: Text('행복페이',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                  GridColumn(
                      width: 120,
                      columnName: 'D',
                      label: Container(
                          color: Colors.blue[50],
                          alignment: Alignment.center,
                          child: Text('만나서카드',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                  GridColumn(
                      width: 120,
                      columnName: 'E',
                      label: Container(
                          color: Colors.blue[50],
                          alignment: Alignment.center,
                          child: Text('네이버페이',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                ],
              ),
            ),
          ),
          Divider(
            height: 16,
          ),
        ],
      ),
    );
  }
}