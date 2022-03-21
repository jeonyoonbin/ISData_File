
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Model/stat/statOrderGunguModel.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/View/StatManager/stat_controller.dart';
import 'package:date_format/date_format.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class StatOrderGunguList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StatOrderGunguListState();
  }
}

class DailyDataSource extends DataGridSource {
  DailyDataSource({List<StatOrderGunguModel> dailyDataSource}) {
    _data = dailyDataSource
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(
                columnName: 'ORDER_DATE',
                value: e.ORDER_DATE.toString() == 'null'
                    ? '합계'
                    : DateFormat("yyyy-MM-dd").format(DateTime.parse(e.ORDER_DATE.toString())).toString()
              ),
              DataGridCell<String>(columnName: 'A', value: e.A.toString()),
              DataGridCell<String>(columnName: 'B', value: e.B.toString()),
              DataGridCell<String>(columnName: 'C', value: e.C.toString()),
              DataGridCell<String>(columnName: 'D', value: e.D.toString()),
              DataGridCell<String>(columnName: 'E', value: e.E.toString()),
              DataGridCell<String>(columnName: 'F', value: e.F.toString()),
              DataGridCell<String>(columnName: 'G', value: e.G.toString()),
              DataGridCell<String>(columnName: 'H', value: e.H.toString()),
              DataGridCell<String>(columnName: 'I', value: e.I.toString()),
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

class StatOrderGunguListState extends State {
  DailyDataSource _dailyDataSource;

  final CustomColumnSizer _customColumnSizer = CustomColumnSizer();

  List<StatOrderGunguModel> dataList = <StatOrderGunguModel>[];

  SearchItems _searchItems = new SearchItems();

  final ScrollController _scrollHorizontalController = ScrollController();

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

    if (dataList != null) dataList.clear();

    await StatController.to.getOrderGunguData().then((value) {
      if (this.mounted) {
        if (value == null) {
          ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
        } else {
          setState(() {
            value.forEach((element) {
              StatOrderGunguModel temp = StatOrderGunguModel.fromJson(element);

              dataList.add(temp);
            });
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
      _scrollHorizontalController.jumpTo(10.0);
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

    if (_scrollHorizontalController != null) _scrollHorizontalController.dispose();

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
              width: 1500,
              height: MediaQuery.of(context).size.height-240,
              child: ListView(
                  controller: _scrollHorizontalController,
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      width: 1500,
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
                                columnName: 'ORDER_DATE',
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
                                    child: Text('남구',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                width: 100,
                                columnName: 'B',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('달서구',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                width: 100,
                                columnName: 'C',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('달성군',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                width: 100,
                                columnName: 'D',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('동구',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                width: 100,
                                columnName: 'E',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('북구',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                width: 100,
                                columnName: 'F',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('서구',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                width: 100,
                                columnName: 'G',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('수성구',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                width: 100,
                                columnName: 'H',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('중구',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                width: 100,
                                columnName: 'I',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('포장',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                          ],
                        ),
                      ),
                    )
                  ]
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
