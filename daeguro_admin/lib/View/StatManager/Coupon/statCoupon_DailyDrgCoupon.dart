import 'dart:convert';
import 'dart:html';

import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Model/stat/statCouponDailyDrgCouponModel.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';

import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/CouponManager/coupon_controller.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/View/StatManager/stat_controller.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:excel/excel.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';



class StatCouponDailyDrgCoupon extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StatCouponDailyDrgCouponState();
  }
}

class DailyDataSource extends DataGridSource {
  DailyDataSource({List<StatCouponDailyDrgCouponModel> dailyDataSource}) {
    _data = dailyDataSource
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'OPEN_DATE', value: e.DAILY.toString() == 'null' ? '합계' : e.DAILY.substring(0, 10)),
      DataGridCell<String>(columnName: 'A', value: e.A.toString()),
      DataGridCell<String>(columnName: 'A2', value: e.A2.toString()),
      DataGridCell<String>(columnName: 'B', value: e.B.toString()),
      DataGridCell<String>(columnName: 'B2', value: e.B2.toString()),
      DataGridCell<String>(columnName: 'C', value: e.C.toString()),
      DataGridCell<String>(columnName: 'C2', value: e.C2.toString()),
      DataGridCell<String>(columnName: 'D', value: e.D.toString()),
      DataGridCell<String>(columnName: 'D2', value: e.D2.toString()),
      DataGridCell<String>(columnName: 'E', value: e.E.toString()),
      DataGridCell<String>(columnName: 'E2', value: e.E2.toString()),
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

class StatCouponDailyDrgCouponState extends State with AutomaticKeepAliveClientMixin {
  List<StatCouponDailyDrgCouponModel> dataList = <StatCouponDailyDrgCouponModel>[];
  List<StatCouponDailyDrgCouponModel> exportTotalList = <StatCouponDailyDrgCouponModel>[];

  DailyDataSource _dailyDataSource;

  final Map<String, dynamic> sumData = new Map<String, dynamic>();

  final CustomColumnSizer _customColumnSizer = CustomColumnSizer();

  SearchItems _searchItems = new SearchItems();
  final ScrollController _scrollHorizontalController = ScrollController();

  int listDummyMaxSize = 25;
  String _couponType = ' ';

  List<SelectOptionVO> items = List();

  String _type = '0';
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

    await StatController.to.getDailyDrgCouponData(_type, _couponType).then((value) {
      if (this.mounted) {
        if (value == null) {
          ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
        } else {
          setState(() {
            value.forEach((element) {
              StatCouponDailyDrgCouponModel temp = StatCouponDailyDrgCouponModel.fromJson(element);

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

  setDropDown() async {
    await CouponController.to.getDataCodeItems(context).then((value) {
      if(value == null){
        ISAlert(context, '쿠폰정보를 가져오지 못했습니다. \n\n관리자에게 문의 바랍니다');
      }
      else{
        //couponTypeItems = value;
        items.add(new SelectOptionVO(value: ' ', label: '전체', label2: '',));

        value.forEach((value) {
          items.add(new SelectOptionVO(value: value['code'], label: '[' + value['code'] + '] ' + value['codeName'], label2: value['codeName'],));
        });
      }
    });

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    Get.put(StatController());
    Get.put(ShopController());
    Get.put(CouponController());

    WidgetsBinding.instance.addPostFrameCallback((c) {
      _reset();
      setDropDown();
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
          ISSearchDropdown(
            label: '업무상태',
            width: 120,
            value: _type,
            onChange: (value) {
              setState(() {
                _type = value;
                _query();
              });
            },
            item: [
              DropdownMenuItem(value: '0', child: Text('발행'),),
              DropdownMenuItem(value: '1', child: Text('지급'),),
              DropdownMenuItem(value: '2', child: Text('사용'),),
              DropdownMenuItem(value: '3', child: Text('폐기'),),
              DropdownMenuItem(value: '4', child: Text('만료'),),
            ].cast<DropdownMenuItem<String>>(),
          ),
          ISSearchDropdown(
            label: '쿠폰종류',
            value: _couponType,
            width: 250,
            item: items.map((item) {
              return new DropdownMenuItem<String>(
                  child: new Text(
                    item.label,
                    style: TextStyle(fontSize: 13, color: Colors.black),
                  ),
                  value: item.value);
            }).toList(),
            onChange: (v) {
              items.forEach((element) {
                if (v == element.value) {
                  _couponType = element.value;
                }
              });
              _query();
            },
          ),
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
              height: MediaQuery.of(context).size.height - 240,
              child: ListView(
                  controller: _scrollHorizontalController,
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      width: 1600,
                      height: MediaQuery.of(context).size.height - 240,
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
                                columnName: 'DAILY',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('일자',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                width: 120,
                                columnName: 'A',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('건수',
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                width: 120,
                                columnName: 'A2',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('금액',
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                width: 120,
                                columnName: 'B',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('건수',
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                width: 120,
                                columnName: 'B2',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('금액',
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                width: 120,
                                columnName: 'C',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('건수',
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                width: 120,
                                columnName: 'C2',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('금액',
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                width: 120,
                                columnName: 'D',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('건수',
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                width: 120,
                                columnName: 'D2',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('금액',
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                width: 120,
                                columnName: 'E',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('건수',
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                            GridColumn(
                                width: 120,
                                columnName: 'E2',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('금액',
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13)))),
                          ],
                          stackedHeaderRows: <StackedHeaderRow>[
                            StackedHeaderRow(cells: [
                              StackedHeaderCell(
                                  columnNames: ['A', 'A2'],
                                  child: Container(
                                      color: Colors.blue[50],
                                      child: Center(
                                          child: Text('500원 쿠폰',
                                              style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13))))),
                              StackedHeaderCell(
                                  columnNames: ['B', 'B2'],
                                  child: Container(
                                      color: Colors.blue[50],
                                      child: Center(
                                          child: Text('2,000원 쿠폰',
                                              style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13))))),
                              StackedHeaderCell(
                                  columnNames: ['C', 'C2'],
                                  child: Container(
                                      color: Colors.blue[50],
                                      child: Center(
                                          child: Text('3,000원 쿠폰',
                                              style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13))))),
                              StackedHeaderCell(
                                  columnNames: ['D', 'D2'],
                                  child: Container(
                                      color: Colors.blue[50],
                                      child: Center(
                                          child: Text('5,000원 쿠폰',
                                              style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13))))),
                              StackedHeaderCell(
                                  columnNames: ['E', 'E2'],
                                  child: Container(
                                      color: Colors.blue[50],
                                      child: Center(
                                          child: Text('10,000원 쿠폰',
                                              style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13))))),
                            ]),
                          ],
                        ),
                      ),
                    )
                  ]),
            ),
          ),
          Divider(
            height: 20,
          ),
          showPagerBar()
        ],
      ),
    );
  }

  Container showPagerBar() {
    return Container(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: AuthUtil.isAuthDownloadEnabled('15') == true ? ISButton(
          label: 'Excel저장',
          iconColor: Colors.white,
          iconData: Icons.reply,
          textStyle: TextStyle(color: Colors.white),
          onPressed: () {
            SaveExcelExport();
          })  : Container(height: 30,),
    );
  }

  void SaveExcelExport() async {
    var excel = Excel.createExcel();

    compute(computeExcelExportData, excel).then((value) {
      DateTime now = DateTime.now();
      DateTime date = DateTime(now.year, now.month, now.day);

      AnchorElement(href: 'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(value.encode())}')
        ..setAttribute('download', '대구로 쿠폰통계[일자별]_' + formatDate(date, [yy, mm, dd]) + '.xlsx')
        ..click();
    });
  }

  Future<Excel> computeExcelExportData(Excel excel) async {
    List<StatCouponDailyDrgCouponModel> exportDataList = <StatCouponDailyDrgCouponModel>[];
    List<String> sheetName = ['일자별'];

    sheetName.forEach((sheet_name) async {
      Sheet sheetObject = excel[sheet_name];
      excel.setDefaultSheet(sheet_name);

      CellStyle cellStyle = CellStyle(fontFamily: '맑은 고딕', fontSize: 11, horizontalAlign: HorizontalAlign.Center);

      sheetObject.merge(CellIndex.indexByString("B1"), CellIndex.indexByString("C1"), customValue: "500원");
      sheetObject.merge(CellIndex.indexByString("D1"), CellIndex.indexByString("E1"), customValue: "2,000원");
      sheetObject.merge(CellIndex.indexByString("F1"), CellIndex.indexByString("G1"), customValue: "3,000원");
      sheetObject.merge(CellIndex.indexByString("H1"), CellIndex.indexByString("I1"), customValue: "5,000원");
      sheetObject.merge(CellIndex.indexByString("J1"), CellIndex.indexByString("K1"), customValue: "10,000원");

      CellStyle cellStyle2 = CellStyle(fontFamily: '맑은 고딕', fontSize: 11, verticalAlign: VerticalAlign.Center, horizontalAlign: HorizontalAlign.Center, backgroundColorHex: '#B0E0E6');

      sheetObject.merge(CellIndex.indexByString("A1"), CellIndex.indexByString("A2"), customValue: "일자");

      var cell2 = sheetObject.cell(CellIndex.indexByString("A1"));
      cell2.cellStyle = cellStyle2;

      var cell3 = sheetObject.cell(CellIndex.indexByString("B1"));
      cell3.cellStyle = cellStyle2;

      var cell4 = sheetObject.cell(CellIndex.indexByString("D1"));
      cell4.cellStyle = cellStyle2;

      var cell5 = sheetObject.cell(CellIndex.indexByString("F1"));
      cell5.cellStyle = cellStyle2;

      var cell6 = sheetObject.cell(CellIndex.indexByString("H1"));
      cell6.cellStyle = cellStyle2;

      var cell7 = sheetObject.cell(CellIndex.indexByString("J1"));
      cell7.cellStyle = cellStyle2;

      var excelCellData = {
        "B2": "건수",
        "C2": "금액",
        "D2": "건수",
        "E2": "금액",
        "F2": "건수",
        "G2": "금액",
        "H2": "건수",
        "I2": "금액",
        "J2": "건수",
        "K2": "금액",
      };

      var cell = null;
      excelCellData.forEach((key, value) {
        cell = sheetObject.cell(CellIndex.indexByString(key));
        cell.value = value;
        cell.cellStyle = cellStyle;
      });

    });

    await Future.delayed(Duration(milliseconds: 1000), () {
      CellStyle cellStyle = CellStyle(fontFamily: '맑은 고딕', fontSize: 11, horizontalAlign: HorizontalAlign.Center);
      CellStyle cellStyle2 = CellStyle(fontFamily: '맑은 고딕', fontSize: 11, horizontalAlign: HorizontalAlign.Right);

      if (dataList.length > 0) {
        int listTotalIdx = 3;
        dataList.forEach((totalElement) {
          excel.updateCell('일자별', CellIndex.indexByString('A$listTotalIdx'), totalElement.DAILY == null ? '합계': totalElement.DAILY.substring(0,10), cellStyle: cellStyle);
          excel.updateCell('일자별', CellIndex.indexByString('B$listTotalIdx'), Utils.getCashComma(totalElement.A.toString()), cellStyle: cellStyle2);
          excel.updateCell('일자별', CellIndex.indexByString('C$listTotalIdx'), Utils.getCashComma(totalElement.A2.toString()), cellStyle: cellStyle2);
          excel.updateCell('일자별', CellIndex.indexByString('D$listTotalIdx'), Utils.getCashComma(totalElement.B.toString()), cellStyle: cellStyle2);
          excel.updateCell('일자별', CellIndex.indexByString('E$listTotalIdx'), Utils.getCashComma(totalElement.B2.toString()), cellStyle: cellStyle2);
          excel.updateCell('일자별', CellIndex.indexByString('F$listTotalIdx'), Utils.getCashComma(totalElement.C.toString()), cellStyle: cellStyle2);
          excel.updateCell('일자별', CellIndex.indexByString('G$listTotalIdx'), Utils.getCashComma(totalElement.C2.toString()), cellStyle: cellStyle2);
          excel.updateCell('일자별', CellIndex.indexByString('H$listTotalIdx'), Utils.getCashComma(totalElement.D.toString()), cellStyle: cellStyle2);
          excel.updateCell('일자별', CellIndex.indexByString('I$listTotalIdx'), Utils.getCashComma(totalElement.D2.toString()), cellStyle: cellStyle2);
          excel.updateCell('일자별', CellIndex.indexByString('J$listTotalIdx'), Utils.getCashComma(totalElement.E.toString()), cellStyle: cellStyle2);
          excel.updateCell('일자별', CellIndex.indexByString('K$listTotalIdx'), Utils.getCashComma(totalElement.E2.toString()), cellStyle: cellStyle2);

          listTotalIdx++;
        });
      }
    });

    excel.delete('Sheet1');

    return excel;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}