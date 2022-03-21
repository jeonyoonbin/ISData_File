import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Model/shop/shop_divcode.dart';
import 'package:daeguro_admin_app/Model/stat/statShopCategoryModel.dart';

import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/View/StatManager/stat_controller.dart';
import 'package:date_format/date_format.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class StatShopCategoryList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StatShopCategoryListState();
  }
}

class DailyDataSource extends DataGridSource {
  DailyDataSource({List<StatShopCategoryModel> dailyDataSource}) {
    _data = dailyDataSource
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(
                  columnName: 'OPEN_DATE',
                  value: e.OPEN_DATE.toString() == 'null' ? '합계' : DateFormat("yyyy-MM-dd").format(DateTime.parse(e.OPEN_DATE.toString())).toString()),
              DataGridCell<String>(columnName: 'R', value: e.R.toString()),
              DataGridCell<String>(columnName: 'A', value: e.A.toString()),
              DataGridCell<String>(columnName: 'B', value: e.B.toString()),
              DataGridCell<String>(columnName: 'C', value: e.C.toString()),
              DataGridCell<String>(columnName: 'D', value: e.D.toString()),
              DataGridCell<String>(columnName: 'E', value: e.E.toString()),
              DataGridCell<String>(columnName: 'F', value: e.F.toString()),
              DataGridCell<String>(columnName: 'G', value: e.G.toString()),
              DataGridCell<String>(columnName: 'H', value: e.H.toString()),
              DataGridCell<String>(columnName: 'I', value: e.I.toString()),
              DataGridCell<String>(columnName: 'J', value: e.J.toString()),
              DataGridCell<String>(columnName: 'K', value: e.K.toString()),
              DataGridCell<String>(columnName: 'L', value: e.L.toString()),
              DataGridCell<String>(columnName: 'M', value: e.M.toString()),
              DataGridCell<String>(columnName: 'N', value: e.N.toString()),
              DataGridCell<String>(columnName: 'O', value: e.O.toString()),
              DataGridCell<String>(columnName: 'P', value: e.P.toString()),
              DataGridCell<String>(columnName: 'Q', value: e.Q.toString()),
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
        return TextStyle(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'NotoSansKR');
      } else {
        return TextStyle(fontSize: 13);
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

          if (dataGridCell.columnName == 'OPEN_DATE') {
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
              mainAxisAlignment: dataGridCell.columnName == 'OPEN_DATE' ? MainAxisAlignment.center : MainAxisAlignment.end,
              children: [
                dataGridCell.columnName == 'OPEN_DATE'
                    ? Text(dataGridCell.value.toString(), overflow: TextOverflow.ellipsis, style: getRowTextStyle())
                    : Text(Utils.getCashComma(dataGridCell.value), overflow: TextOverflow.ellipsis, style: getRowTextStyle())
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

class StatShopCategoryListState extends State with AutomaticKeepAliveClientMixin {
  List<StatShopCategoryModel> dataList = <StatShopCategoryModel>[];
  List<ShopDivCodeModel> divList = <ShopDivCodeModel>[];

  DailyDataSource _dailyDataSource;

  final Map<String, dynamic> sumData = new Map<String, dynamic>();

  final CustomColumnSizer _customColumnSizer = CustomColumnSizer();

  SearchItems _searchItems = new SearchItems();
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

    if (dataList != null) dataList.clear();
    if (divList != null) divList.clear();

    await ShopController.to.getDataDivItems().then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        value.forEach((element) {
          ShopDivCodeModel tempDivData = ShopDivCodeModel.fromJson(element);
          divList.add(tempDivData);
        });
      }
    });


    await StatController.to.getShopCategoryData().then((value) {
      if (this.mounted) {
        if (value == null) {
          ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
        } else {
          setState(() {
            value.forEach((element) {
              StatShopCategoryModel temp = StatShopCategoryModel.fromJson(element);

              dataList.add(temp);
            });

            _scrollHorizontalController.jumpTo(10.0);
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
    if (dataList != null) {
      dataList.clear();
      dataList = null;
    }

    if (divList != null) {
      divList.clear();
      divList = null;
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
                              width: 100,
                              columnName: 'OPEN_DATE',
                              label: Container(
                                  color: Colors.blue[50],
                                  alignment: Alignment.center,
                                  child: Text('일자',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                          GridColumn(
                              width: 80,
                              columnName: 'R',
                              label: Container(
                                  color: Colors.blue[50],
                                  alignment: Alignment.center,
                                  child: Text('합계',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                          GridColumn(
                              width: 80,
                              columnName: 'A',
                              label: Container(
                                  color: Colors.blue[50],
                                  alignment: Alignment.center,
                                  child: Text('1인분',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                          GridColumn(
                              width: 80,
                              columnName: 'B',
                              label: Container(
                                  color: Colors.blue[50],
                                  alignment: Alignment.center,
                                  child: Text('도시락/죽',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                          GridColumn(
                              width: 80,
                              columnName: 'C',
                              label: Container(
                                  color: Colors.blue[50],
                                  alignment: Alignment.center,
                                  child: Text('돈까스/일식',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                          GridColumn(
                              width: 80,
                              columnName: 'D',
                              label: Container(
                                  color: Colors.blue[50],
                                  alignment: Alignment.center,
                                  child: Text('반찬',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                          GridColumn(
                              width: 80,
                              columnName: 'E',
                              label: Container(
                                  color: Colors.blue[50],
                                  alignment: Alignment.center,
                                  child: Text('분식',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                          GridColumn(
                              width: 80,
                              columnName: 'F',
                              label: Container(
                                  color: Colors.blue[50],
                                  alignment: Alignment.center,
                                  child: Text('아시안/양식',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                          GridColumn(
                              width: 80,
                              columnName: 'G',
                              label: Container(
                                  color: Colors.blue[50],
                                  alignment: Alignment.center,
                                  child: Text('야식',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                          GridColumn(
                              width: 80,
                              columnName: 'H',
                              label: Container(
                                  color: Colors.blue[50],
                                  alignment: Alignment.center,
                                  child: Text('정육',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                          GridColumn(
                              width: 80,
                              columnName: 'I',
                              label: Container(
                                  color: Colors.blue[50],
                                  alignment: Alignment.center,
                                  child: Text('족발/보쌈',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                          GridColumn(
                              width: 80,
                              columnName: 'J',
                              label: Container(
                                  color: Colors.blue[50],
                                  alignment: Alignment.center,
                                  child: Text('중식',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                          GridColumn(
                              width: 80,
                              columnName: 'K',
                              label: Container(
                                  color: Colors.blue[50],
                                  alignment: Alignment.center,
                                  child: Text('찜/탕',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                          GridColumn(
                              width: 80,
                              columnName: 'L',
                              label: Container(
                                  color: Colors.blue[50],
                                  alignment: Alignment.center,
                                  child: Text('치킨/찜닭',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                          GridColumn(
                              width: 80,
                              columnName: 'M',
                              label: Container(
                                  color: Colors.blue[50],
                                  alignment: Alignment.center,
                                  child: Text('카페/디저트',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                          GridColumn(
                              width: 80,
                              columnName: 'N',
                              label: Container(
                                  color: Colors.blue[50],
                                  alignment: Alignment.center,
                                  child: Text('패스트푸드',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                          GridColumn(
                              width: 80,
                              columnName: 'O',
                              label: Container(
                                  color: Colors.blue[50],
                                  alignment: Alignment.center,
                                  child: Text('펫',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                          GridColumn(
                              width: 80,
                              columnName: 'P',
                              label: Container(
                                  color: Colors.blue[50],
                                  alignment: Alignment.center,
                                  child: Text('피자',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                          GridColumn(
                              width: 80,
                              columnName: 'Q',
                              label: Container(
                                  color: Colors.blue[50],
                                  alignment: Alignment.center,
                                  child: Text('한식',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                        ],
                      ),
                    ),
                  )
                ]
              ),
            ),
          ),
          Divider(
            height: 20,
      ),
          SizedBox(
            height: 30,
          )
        ],
        ),
      );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
