import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Model/stat/statShopDailyEventCountModel.dart';
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

class StatShopDailyEventCountList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StatShopDailyEventCountListState();
  }
}

class DailyDataSource extends DataGridSource {
  DailyDataSource({List<StatShopDailyEventCountModel> dailyDataSource}) {
    _data = dailyDataSource
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(
                columnName: 'ORDER_DATE',
                value: e.ORDER_DATE.toString() == '합계' ? '합계' : DateFormat("yyyy-MM-dd").format(DateTime.parse(e.ORDER_DATE.toString())).toString(),
              ),
              DataGridCell<String>(columnName: 'COMP_CNT', value: Utils.getCashComma(e.COMP_CNT.toString())),
              DataGridCell<String>(columnName: 'COMP_SUM', value: Utils.getCashComma(e.COMP_SUM.toString())),
              DataGridCell<String>(columnName: 'CANC_CNT', value: Utils.getCashComma(e.CANC_CNT.toString())),
              DataGridCell<String>(columnName: 'CANC_SUM', value: Utils.getCashComma(e.CANC_SUM.toString()))
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
            child: Text(dataGridCell.value.toString(), overflow: TextOverflow.ellipsis, style: getRowTextStyle()),
          );
        }).toList());
  }
}

class StatShopDailyEventCountListState extends State with AutomaticKeepAliveClientMixin {
  List<StatShopDailyEventCountModel> dataList = <StatShopDailyEventCountModel>[];
  DailyDataSource _dailyDataSource;

  SearchItems _searchItems = new SearchItems();

  int _sumCOMP_CNT = 0;
  int _sumCOMP_SUM = 0;
  int _sumCANC_CNT = 0;
  int _sumCANC_SUM = 0;

  final Map<String, dynamic> sumData = new Map<String, dynamic>();

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

    _sumCOMP_CNT = 0;
    _sumCOMP_SUM = 0;
    _sumCANC_CNT = 0;
    _sumCANC_SUM = 0;

    await StatController.to.getDailyEventCountData().then((value) {
      dataList.clear();

      if (this.mounted) {
        setState(() {
          value.forEach((element) {
            StatShopDailyEventCountModel temp = StatShopDailyEventCountModel.fromJson(element);

            if (temp.COMP_CNT == null) temp.COMP_CNT = 0;
            if (temp.COMP_SUM == null) temp.COMP_SUM = 0;
            if (temp.CANC_CNT == null) temp.CANC_CNT = 0;
            if (temp.CANC_SUM == null) temp.CANC_SUM = 0;

            _sumCOMP_CNT = _sumCOMP_CNT + temp.COMP_CNT;
            _sumCOMP_SUM = _sumCOMP_SUM + temp.COMP_SUM;
            _sumCANC_CNT = _sumCANC_CNT + temp.CANC_CNT;
            _sumCANC_SUM = _sumCANC_SUM + temp.CANC_SUM;

            dataList.add(temp);
          });

          // 합계 추가
          sumData['COMP_CNT'] = _sumCOMP_CNT;
          sumData['COMP_SUM'] = _sumCOMP_SUM;
          sumData['CANC_CNT'] = _sumCANC_CNT;
          sumData['CANC_SUM'] = _sumCANC_SUM;
          sumData['ORDER_DATE'] = '합계';

          dataList.add(StatShopDailyEventCountModel.fromJson(sumData));

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
          Expanded(
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
                                child: Text('일자',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                        GridColumn(
                            columnName: 'COMP_CNT',
                            width: 100,
                            label: Container(
                                color: Colors.blue[50],
                                alignment: Alignment.center,
                                child: Text('주문 수',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                        GridColumn(
                            columnName: 'COMP_SUM',
                            width: 120,
                            label: Container(
                                color: Colors.blue[50],
                                alignment: Alignment.center,
                                child: Text('주문 금액',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                        GridColumn(
                            columnName: 'CANC_CNT',
                            width: 100,
                            label: Container(
                                color: Colors.blue[50],
                                alignment: Alignment.center,
                                child: Text('주문 수',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                        GridColumn(
                            columnName: 'CANC_SUM',
                            width: 120,
                            label: Container(
                                color: Colors.blue[50],
                                alignment: Alignment.center,
                                child: Text('주문 금액',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 12)))),
                      ],
                      stackedHeaderRows: <StackedHeaderRow>[
                        StackedHeaderRow(cells: [
                          StackedHeaderCell(
                              columnNames: ['COMP_CNT', 'COMP_SUM'],
                              child: Container(
                                  color: Colors.blue[50],
                                  child: Center(
                                      child: Text('완료',
                                          style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13))))),
                          StackedHeaderCell(
                              columnNames: ['CANC_CNT', 'CANC_SUM'],
                              child: Container(
                                  color: Colors.blue[50],
                                  child: Center(
                                      child: Text('취소',
                                          style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', fontSize: 13))))),
                        ]),
                      ],
                    ),
                  ),
          ),
          Divider(
            height: 20,
          ),
          SizedBox(
            height: 30,
          )
          //showPagerBar(),
        ],
      ), //bottomNavigationBar: showPagerBar(),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
