import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Model/stat/statDailyAgeToOrderModel.dart';
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

class StatDailyAgeToOrder extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StatDailyAgeToOrderState();
  }
}

class DailyDataSource extends DataGridSource {
  DailyDataSource({List<StatDailyAgeToOrderModel> dailyDataSource}) {
    _data = dailyDataSource
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(
        columnName: 'ORDER_DATE',
        value: DateFormat("yyyy-MM-dd").format(DateTime.parse(e.ORDER_DATE.toString())).toString(),
      ),
      DataGridCell<String>(columnName: 'A', value: Utils.getCashComma(e.A.toString())),
      DataGridCell<String>(columnName: 'A_COMP', value: Utils.getCashComma(e.A_COMP.toString())),
      DataGridCell<String>(columnName: 'A_CANC', value: Utils.getCashComma(e.A_CANC.toString())),
      DataGridCell<String>(columnName: 'B', value: Utils.getCashComma(e.B.toString())),
      DataGridCell<String>(columnName: 'B_COMP', value: Utils.getCashComma(e.B_COMP.toString())),
      DataGridCell<String>(columnName: 'B_CANC', value: Utils.getCashComma(e.B_CANC.toString())),
      DataGridCell<String>(columnName: 'C', value: Utils.getCashComma(e.C.toString())),
      DataGridCell<String>(columnName: 'C_COMP', value: Utils.getCashComma(e.C_COMP.toString())),
      DataGridCell<String>(columnName: 'C_CANC', value: Utils.getCashComma(e.C_CANC.toString())),
      DataGridCell<String>(columnName: 'D', value: Utils.getCashComma(e.D.toString())),
      DataGridCell<String>(columnName: 'D_COMP', value: Utils.getCashComma(e.D_COMP.toString())),
      DataGridCell<String>(columnName: 'D_CANC', value: Utils.getCashComma(e.D_CANC.toString())),
      DataGridCell<String>(columnName: 'E', value: Utils.getCashComma(e.E.toString())),
      DataGridCell<String>(columnName: 'E_COMP', value: Utils.getCashComma(e.E_COMP.toString())),
      DataGridCell<String>(columnName: 'E_CANC', value: Utils.getCashComma(e.E_CANC.toString())),
      DataGridCell<String>(columnName: 'F', value: Utils.getCashComma(e.F.toString())),
      DataGridCell<String>(columnName: 'F_COMP', value: Utils.getCashComma(e.F_COMP.toString())),
      DataGridCell<String>(columnName: 'F_CANC', value: Utils.getCashComma(e.F_CANC.toString())),
      DataGridCell<String>(columnName: 'G', value: Utils.getCashComma(e.G.toString())),
      DataGridCell<String>(columnName: 'G_COMP', value: Utils.getCashComma(e.G_COMP.toString())),
      DataGridCell<String>(columnName: 'G_CANC', value: Utils.getCashComma(e.G_CANC.toString())),
      DataGridCell<String>(columnName: 'H', value: Utils.getCashComma(e.H.toString())),
      DataGridCell<String>(columnName: 'H_COMP', value: Utils.getCashComma(e.H_COMP.toString())),
      DataGridCell<String>(columnName: 'H_CANC', value: Utils.getCashComma(e.H_CANC.toString())),
      DataGridCell<String>(columnName: 'I', value: Utils.getCashComma(e.I.toString())),
      DataGridCell<String>(columnName: 'I_COMP', value: Utils.getCashComma(e.I_COMP.toString())),
      DataGridCell<String>(columnName: 'I_CANC', value: Utils.getCashComma(e.I_CANC.toString())),
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
            child: Text(dataGridCell.value.toString(), overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14)),
          );
        }).toList());
  }
}

class StatDailyAgeToOrderState extends State with AutomaticKeepAliveClientMixin{
  List<StatDailyAgeToOrderModel> dataList = <StatDailyAgeToOrderModel>[];
  DailyDataSource _dailyDataSource;

  int _A = 0;
  int _B = 0;
  int _C = 0;
  int _D = 0;
  int _E = 0;
  int _F = 0;
  int _G = 0;
  int _H = 0;
  int _I = 0;

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

    await StatController.to.getDailyAgeToOrderData().then((value) {
      dataList.clear();

      if (this.mounted) {
        setState(() {
          value.forEach((element) {
            StatDailyAgeToOrderModel temp = StatDailyAgeToOrderModel.fromJson(element);
            dataList.add(temp);
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
              width: Responsive.isDesktop(context) == true ? MediaQuery.of(context).size.width+400 : 1600,
              height: MediaQuery.of(context).size.height-240,
              child: ListView(
                  controller: _scrollHorizontalController,
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      width: Responsive.isDesktop(context) == true ? MediaQuery.of(context).size.width+400 : 1600,
                      height: MediaQuery.of(context).size.height-240,
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
                              return 35;
                            }
                            return 35;
                          },
                          columns: <GridColumn>[
                            GridColumn(
                                columnName: 'ORDER_DATE',
                                width: 100,
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('일자', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                            GridColumn(
                                columnName: 'A',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('전체', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                            GridColumn(
                                columnName: 'A_COMP',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('완료', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                            GridColumn(
                                columnName: 'A_CANC',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('취소', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                            GridColumn(
                                columnName: 'B',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('전체', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                            GridColumn(
                                columnName: 'B_COMP',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('완료', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                            GridColumn(
                                columnName: 'B_CANC',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('취소', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                            GridColumn(
                                columnName: 'C',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('전체', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                            GridColumn(
                                columnName: 'C_COMP',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('완료', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                            GridColumn(
                                columnName: 'C_CANC',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('취소', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                            GridColumn(
                                columnName: 'D',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('전체', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                            GridColumn(
                                columnName: 'D_COMP',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('완료', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                            GridColumn(
                                columnName: 'D_CANC',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('취소', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                            GridColumn(
                                columnName: 'E',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('전체', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                            GridColumn(
                                columnName: 'E_COMP',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('완료', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                            GridColumn(
                                columnName: 'E_CANC',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('취소', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                            GridColumn(
                                columnName: 'F',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('전체', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                            GridColumn(
                                columnName: 'F_COMP',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('완료', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                            GridColumn(
                                columnName: 'F_CANC',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('취소', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                            GridColumn(
                                columnName: 'G',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('전체', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                            GridColumn(
                                columnName: 'G_COMP',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('완료', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                            GridColumn(
                                columnName: 'G_CANC',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('취소', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                            GridColumn(
                                columnName: 'H',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('전체', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                            GridColumn(
                                columnName: 'H_COMP',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('완료', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                            GridColumn(
                                columnName: 'H_CANC',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('취소', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                            GridColumn(
                                columnName: 'I',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('전체', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                            GridColumn(
                                columnName: 'I_COMP',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('완료', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                            GridColumn(
                                columnName: 'I_CANC',
                                label: Container(
                                    color: Colors.blue[50],
                                    alignment: Alignment.center,
                                    child: Text('취소', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                          ],
                          stackedHeaderRows: <StackedHeaderRow>[
                            StackedHeaderRow(cells: [
                              StackedHeaderCell(
                                  columnNames: ['A', 'A_COMP', 'A_CANC'],
                                  child: Container(
                                      color: Colors.blue[50],
                                      child: Center(child: Text('10대', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13))))),
                              StackedHeaderCell(
                                  columnNames: ['B', 'B_COMP', 'B_CANC'],
                                  child: Container(
                                      color: Colors.blue[50],
                                      child: Center(child: Text('20대', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13))))), StackedHeaderCell(
                                  columnNames: ['C', 'C_COMP', 'C_CANC'],
                                  child: Container(
                                      color: Colors.blue[50],
                                      child: Center(child: Text('30대', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13))))),
                              StackedHeaderCell(
                                  columnNames: ['D', 'D_COMP', 'D_CANC'],
                                  child: Container(
                                      color: Colors.blue[50],
                                      child: Center(child: Text('40대', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13))))),
                              StackedHeaderCell(
                                  columnNames: ['E', 'E_COMP', 'E_CANC'],
                                  child: Container(
                                      color: Colors.blue[50],
                                      child: Center(child: Text('50대', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13))))),
                              StackedHeaderCell(
                                  columnNames: ['F', 'F_COMP', 'F_CANC'],
                                  child: Container(
                                      color: Colors.blue[50],
                                      child: Center(child: Text('60대', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13))))),
                              StackedHeaderCell(
                                  columnNames: ['G', 'G_COMP', 'G_CANC'],
                                  child: Container(
                                      color: Colors.blue[50],
                                      child: Center(child: Text('70대', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13))))),
                              StackedHeaderCell(
                                  columnNames: ['H', 'H_COMP', 'H_CANC'],
                                  child: Container(
                                      color: Colors.blue[50],
                                      child: Center(child: Text('80대', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13))))),
                              StackedHeaderCell(
                                  columnNames: ['I', 'I_COMP', 'I_CANC'],
                                  child: Container(
                                      color: Colors.blue[50],
                                      child: Center(child: Text('90대', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13))))),
                            ]),
                          ],
                        ),
                      ),
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
