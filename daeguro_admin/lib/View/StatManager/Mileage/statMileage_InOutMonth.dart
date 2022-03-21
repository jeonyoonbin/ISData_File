import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Model/stat/statMileageInOutMonthModel.dart';
import 'package:daeguro_admin_app/Model/stat/statMileageInOutMonthStaticModel.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/View/StatManager/stat_controller.dart';
import 'package:daeguro_admin_app/Util/utils.dart';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class StatMileageInOutMonth extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StatMileageInOutMonthState();
  }
}

class StatMileageInOutMonthState extends State with AutomaticKeepAliveClientMixin {
  List<StatMileageInOutMonthModel> dataList = <StatMileageInOutMonthModel>[];

  SearchItems _searchItems = new SearchItems();

  List<String> monthGbn = [];

  String _custGbn = '%';

  _reset() {
    _searchItems = null;
    _searchItems = new SearchItems();

    _searchItems.startdate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', '01']);
    _searchItems.enddate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
  }

  _query() {    
    loadData();
  }

  loadData() async {
    await ISProgressDialog(context).show(status: 'Loading...');

    var result =
        await StatController.to.getMileageInOutMonthData(_searchItems.startdate.replaceAll('-', ''), _searchItems.enddate.replaceAll('-', ''), _custGbn);

    result.forEach((element) {
      monthGbn.assign(element['MDATE']);
    });

    if (this.mounted) {
      setState(() {
        dataList.clear();

        result.forEach((element) {
          dataList.add(new StatMileageInOutMonthModel(
              isChild: false,
              MDATE: element['MDATE'],
              COUNT: element['COUNT'],
              SUM_CUST_MILEAGE: element['SUM_CUST_MILEAGE'],
              SUM_LOG_CUST_MILEAGE: element['SUM_LOG_CUST_MILEAGE'],
              SUM_IN_CNT: element['SUM_IN_CNT'],
              SUM_IN_AMT: element['SUM_IN_AMT'],
              SUM_ORDER_IN_CNT: element['SUM_ORDER_IN_CNT'],
              SUM_ORDER_IN_AMT: element['SUM_ORDER_IN_AMT'],
              SUM_SALE_IN_CNT: element['SUM_SALE_IN_CNT'],
              SUM_SALE_IN_AMT: element['SUM_SALE_IN_AMT'],
              SUM_ORDER_OUT_AMT: element['SUM_ORDER_OUT_AMT'],
              SUM_SALE_OUT_AMT: element['SUM_SALE_OUT_AMT'],
              SUM_OUT_AMT: element['SUM_OUT_AMT'],
              SUM_TERMINATE_AMT: element['SUM_TERMINATE_AMT']));
        });
      });
    }

    await ISProgressDialog(context).dismiss();
  }

  addDetailData(String mon) async {
    await ISProgressDialog(context).show(status: 'Loading...');

    List<StatMileageInOutMonthModel> tempDataList = [];

    await StatController.to.getMileageInOutMonthDetailData(_searchItems.startdate.replaceAll('-', ''), _searchItems.enddate.replaceAll('-', ''), _custGbn, mon).then((List<dynamic> value) {
      tempDataList = List.from(getDetailData(mon, value));
    });

    setState(() {
      int selectindex = dataList.indexWhere((item) => item.MDATE == mon);
      tempDataList.forEach((element) {
        //print('-----');
        dataList.insert(selectindex + 1, element);
      });
    });
    await ISProgressDialog(context).dismiss();
  }

  removeDetailData(String MDATE) {

    print(MDATE);
    setState(() {
      dataList.removeWhere((item) => (item.MDATE.contains(MDATE) == true && item.isChild == true));
    });
  }

  List<StatMileageInOutMonthModel> getDetailData(String mon, List<dynamic> targetList) {
    List<StatMileageInOutMonthModel> tempDataList = <StatMileageInOutMonthModel>[];

    int index = 0;
    targetList.forEach((e) {
      StatMileageInOutMonthStaticModel temp = StatMileageInOutMonthStaticModel.fromJson(e);

      int compareIndex = tempDataList.indexWhere((item) => item.MDATE == mon);

      //print(compareIndex);

      tempDataList.add(StatMileageInOutMonthModel(
        isChild: true,
        MDATE: temp.MDATE,
        COUNT: temp.COUNT,
        SUM_CUST_MILEAGE: temp.SUM_CUST_MILEAGE,
        SUM_LOG_CUST_MILEAGE: temp.SUM_LOG_CUST_MILEAGE,
        SUM_IN_CNT: temp.SUM_IN_CNT,
        SUM_IN_AMT: temp.SUM_IN_AMT,
        SUM_ORDER_IN_CNT: temp.SUM_ORDER_IN_CNT,
        SUM_ORDER_IN_AMT: temp.SUM_ORDER_IN_AMT,
        SUM_SALE_IN_CNT: temp.SUM_SALE_IN_CNT,
        SUM_SALE_IN_AMT: temp.SUM_SALE_IN_AMT,
        SUM_ORDER_OUT_AMT: temp.SUM_ORDER_OUT_AMT,
        SUM_SALE_OUT_AMT: temp.SUM_SALE_OUT_AMT,
        SUM_OUT_AMT: temp.SUM_OUT_AMT,
        SUM_TERMINATE_AMT: temp.SUM_TERMINATE_AMT,
      ));

      StatMileageInOutMonthModel tempListModel = tempDataList.elementAt(index);

      if (temp.MDATE == null) tempListModel.MDATE = temp.MDATE;

      index++;
      //}
    });

    return tempDataList;
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
        children: [
          ISSearchDropdown(
            label: '회원구분',
            width: 120,
            value: _custGbn,
            onChange: (value) {
              setState(() {
                _custGbn = value;
                _query();
              });
            },
            item: [
              DropdownMenuItem(value: '%', child: Text('전체'),),
              DropdownMenuItem(value: '1', child: Text('회원'),),
              DropdownMenuItem(value: '3', child: Text('탈퇴'),),
            ].cast<DropdownMenuItem<String>>(),
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
            child: ISDatatable(
                    controller: ScrollController(),
                    //scrollDirection: Axis.horizontal,
                    listWidth: Responsive.getResponsiveWidth(context, 720),
                    dataRowHeight: 35.0,
                    //listWidth: 1100,
                    rows: getDataRow(),
                    columns: getDataColumn(),
                  ),
          ),
          Divider(),
          showPagerBar(),
        ],
      ), //bottomNavigationBar: showPagerBar(),
    );
  }

  List<DataRow> getDataRow() {
    List<DataRow> tempData = [];

    dataList.forEach((element) {
      double fontSize = 14.0;
      bool totalSelected = false;
      FontWeight fontWeight = FontWeight.normal;
      if (element.MDATE == null) {
        fontWeight = FontWeight.bold;
        totalSelected = true;
      }

      if (element.isChild == false) {
        fontWeight = FontWeight.bold;
      }

      if (element.isChild == true) fontSize = 13.0;

      tempData.add(DataRow(selected: totalSelected, cells: [
        DataCell(Container(
          width: 100,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (element.MDATE == null || element.isChild == true)
                  ? Container()
                  : IconButton(
                icon: Icon(element.isOpened == true ? Icons.remove_circle : Icons.add_circle, color: Colors.blue, size: 20),
                onPressed: () {
                  if (element.isOpened == true) {
                    element.isOpened = false;
                    removeDetailData(element.MDATE);
                  } else {
                    element.isOpened = true;
                    addDetailData(element.MDATE);
                  }
                },
              ),
              Align(
                  child: Text(
                    element.MDATE.toString() == 'null'
                        ? '합계'
                        : element.isChild == false
                        ? Utils.getYearMonthFormat(element.MDATE.toString())
                        : Utils.getYearMonthDayFormat(element.MDATE.toString()),
                    style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
                  ),
                  alignment: element.isChild == true ? Alignment.centerRight : Alignment.center),
            ],
          ),
        )),
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.COUNT.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.SUM_CUST_MILEAGE.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.SUM_LOG_CUST_MILEAGE.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.SUM_IN_CNT.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.SUM_IN_AMT.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.SUM_ORDER_IN_CNT.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.SUM_ORDER_IN_AMT.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.SUM_SALE_IN_CNT.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.SUM_SALE_IN_AMT.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.SUM_ORDER_OUT_AMT.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.SUM_SALE_OUT_AMT.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.SUM_OUT_AMT.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.SUM_TERMINATE_AMT.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        //합계
      ]));
    });

    return tempData;
  }

  List<DataColumn> getDataColumn() {
    List<DataColumn> tempData = [];

    //Header
    //tempData.add(DataColumn(label: Expanded(child: Text('', textAlign: TextAlign.center)),));
    tempData.add(DataColumn(
      label: Expanded(child: Text('년/월', textAlign: TextAlign.center)),
    ));
    tempData.add(DataColumn(
      label: Expanded(child: Text('건수', textAlign: TextAlign.right)),
    ));
    tempData.add(DataColumn(
      label: Expanded(child: Text('마일리지\n잔액', style: TextStyle(fontSize: 12), textAlign: TextAlign.right)),
    ));
    tempData.add(DataColumn(
      label: Expanded(child: Text('대장 잔액', textAlign: TextAlign.right)),
    ));
    tempData.add(DataColumn(
      label: Expanded(child: Text('충전 건수', textAlign: TextAlign.right)),
    ));
    tempData.add(DataColumn(
      label: Expanded(child: Text('충전 합계', textAlign: TextAlign.right)),
    ));
    tempData.add(DataColumn(
      label: Expanded(child: Text('주문 충전\n건수', style: TextStyle(fontSize: 12), textAlign: TextAlign.right)),
    ));
    tempData.add(DataColumn(
      label: Expanded(child: Text('주문 충전', textAlign: TextAlign.right)),
    ));
    tempData.add(DataColumn(
      label: Expanded(child: Text('판매 충전', textAlign: TextAlign.right)),
    ));
    tempData.add(DataColumn(
      label: Expanded(child: Text('판매 건수', textAlign: TextAlign.right)),
    ));
    tempData.add(DataColumn(
      label: Expanded(child: Text('주문 차감', textAlign: TextAlign.right)),
    ));
    tempData.add(DataColumn(
      label: Expanded(child: Text('판매 차감', textAlign: TextAlign.right)),
    ));
    tempData.add(DataColumn(
      label: Expanded(child: Text('차감 합계', textAlign: TextAlign.right)),
    ));
    tempData.add(DataColumn(
      label: Expanded(child: Text('탈퇴\n마일리지', style: TextStyle(fontSize: 12), textAlign: TextAlign.right)),
    ));

    return tempData;
  }

  Container showPagerBar() {
    return Container(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Container(
        height: 32,
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
