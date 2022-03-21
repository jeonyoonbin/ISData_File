import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Model/stat/StatOrderDailyCancelReasonModel.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/View/StatManager/stat_controller.dart';
import 'package:date_format/date_format.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class StatOrderDailyCancelReason extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StatOrderDailyCancelReasonState();
  }
}

class StatOrderDailyCancelReasonState extends State with AutomaticKeepAliveClientMixin{
  List<StatOrderDailyCancelReasonModel> dataList = <StatOrderDailyCancelReasonModel>[];

  SearchItems _searchItems = new SearchItems();

  List<SelectOptionVO> selectBox_Gungu = [];

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

    await StatController.to.getDailyOrderCancelReason().then((value) {
      if (this.mounted) {
        setState(() {
          dataList.clear();

          int _cnt = 0;

          value.forEach((element) {
            StatOrderDailyCancelReasonModel temp = StatOrderDailyCancelReasonModel.fromJson(element);

            if (_cnt == 0) {
              dataList.add(temp);
              _cnt++;
            }

            dataList.add(temp);
            int compareIdx = dataList.indexWhere((item) => item.ORDER_DATE == temp.ORDER_DATE);

            if (temp.CANCEL_CODE != null) {
              if (compareIdx != -1) {
                if (temp.CANCEL_CODE == '고객본인취소') {
                  dataList[compareIdx].COUNT_1 = temp.COUNT;
                  dataList.removeAt(dataList.length - 1);
                } else if (temp.CANCEL_CODE == '시간지연') {
                  dataList[compareIdx].COUNT_2 = temp.COUNT;
                  dataList.removeAt(dataList.length - 1);
                } else if (temp.CANCEL_CODE == '가맹점취소') {
                  dataList[compareIdx].COUNT_3 = temp.COUNT;
                  dataList.removeAt(dataList.length - 1);
                } else if (temp.CANCEL_CODE == '주소입력오류') {
                  dataList[compareIdx].COUNT_4 = temp.COUNT;
                  dataList.removeAt(dataList.length - 1);
                } else if (temp.CANCEL_CODE == '가맹점 정산 접수거부') {
                  dataList[compareIdx].COUNT_5 = temp.COUNT;
                  dataList.removeAt(dataList.length - 1);
                } else if (temp.CANCEL_CODE == '사유없음') {
                  dataList[compareIdx].COUNT_6 = temp.COUNT;
                  dataList.removeAt(dataList.length - 1);
                } else if (temp.CANCEL_CODE == '메뉴품절') {
                  dataList[compareIdx].COUNT_7 = temp.COUNT;
                  dataList.removeAt(dataList.length - 1);
                } else if (temp.CANCEL_CODE == '가맹점휴무') {
                  dataList[compareIdx].COUNT_8 = temp.COUNT;
                  dataList.removeAt(dataList.length - 1);
                } else if (temp.CANCEL_CODE == '배달불가') {
                  dataList[compareIdx].COUNT_9 = temp.COUNT;
                  dataList.removeAt(dataList.length - 1);
                } else if (temp.CANCEL_CODE == 'POS서버 응답없음') {
                  dataList[compareIdx].COUNT_10 = temp.COUNT;
                  dataList.removeAt(dataList.length - 1);
                } else if (temp.CANCEL_CODE == '재접수') {
                  dataList[compareIdx].COUNT_11 = temp.COUNT;
                  dataList.removeAt(dataList.length - 1);
                } else if (temp.CANCEL_CODE == '결재대기 자동취소') {
                  dataList[compareIdx].COUNT_12 = temp.COUNT;
                  dataList.removeAt(dataList.length - 1);
                } else if (temp.CANCEL_CODE == '예약주문 가맹점 취소') {
                  dataList[compareIdx].COUNT_13 = temp.COUNT;
                  dataList.removeAt(dataList.length - 1);
                } else if (temp.CANCEL_CODE == 'POS 매핑 없음') {
                  dataList[compareIdx].COUNT_14 = temp.COUNT;
                  dataList.removeAt(dataList.length - 1);
                }

              } else {
                dataList.add(temp);
              }
            } else {
              dataList[compareIdx].COUNT_SUM = temp.COUNT;
              dataList.removeAt(dataList.length - 1);
              _cnt = 0;
            }
          });
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
          Expanded(
            child: dataList.length == 0
                ? Container()
                : ISDatatable(
              controller: ScrollController(),
              //panelHeight: MediaQuery.of(context).size.height-280,
              listWidth: Responsive.getResponsiveWidth(context, 720),
              //scrollDirection: Axis.horizontal,
              dataRowHeight: 30.0,
              rows: getDataRow(),
              columns: getDataColumn(),
            ),
          ),
          Divider(),
          //showPagerBar(),
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

      tempData.add(DataRow(selected: totalSelected, cells: [
        DataCell(Align(child: Text(DateFormat("yyyy-MM-dd").format(DateTime.parse(element.ORDER_DATE.toString())).toString(), style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),), alignment: Alignment.center)),
        DataCell(Align(child: Text(element.COUNT_SUM.toString() == 'null' ? '0' : Utils.getCashComma(element.COUNT_SUM.toString()), style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),), alignment: Alignment.centerRight)),
        DataCell(Align(child: Text(element.COUNT_1.toString() == 'null' ? '0' : Utils.getCashComma(element.COUNT_1.toString()), style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),), alignment: Alignment.centerRight)),
        DataCell(Align(child: Text(element.COUNT_2.toString() == 'null' ? '0' : Utils.getCashComma(element.COUNT_2.toString()), style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),), alignment: Alignment.centerRight)),
        DataCell(Align(child: Text(element.COUNT_3.toString() == 'null' ? '0' : Utils.getCashComma(element.COUNT_3.toString()), style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),), alignment: Alignment.centerRight)),
        DataCell(Align(child: Text(element.COUNT_4.toString() == 'null' ? '0' : Utils.getCashComma(element.COUNT_4.toString()), style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),), alignment: Alignment.centerRight)),
        DataCell(Align(child: Text(element.COUNT_5.toString() == 'null' ? '0' : Utils.getCashComma(element.COUNT_5.toString()), style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),), alignment: Alignment.centerRight)),
        DataCell(Align(child: Text(element.COUNT_6.toString() == 'null' ? '0' : Utils.getCashComma(element.COUNT_6.toString()), style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),), alignment: Alignment.centerRight)),
        DataCell(Align(child: Text(element.COUNT_7.toString() == 'null' ? '0' : Utils.getCashComma(element.COUNT_7.toString()), style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),), alignment: Alignment.centerRight)),
        DataCell(Align(child: Text(element.COUNT_8.toString() == 'null' ? '0' : Utils.getCashComma(element.COUNT_8.toString()), style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),), alignment: Alignment.centerRight)),
        DataCell(Align(child: Text(element.COUNT_9.toString() == 'null' ? '0' : Utils.getCashComma(element.COUNT_9.toString()), style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),), alignment: Alignment.centerRight)),
        DataCell(Align(child: Text(element.COUNT_10.toString() == 'null' ? '0' : Utils.getCashComma(element.COUNT_10.toString()), style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),), alignment: Alignment.centerRight)),
        DataCell(Align(child: Text(element.COUNT_11.toString() == 'null' ? '0' : Utils.getCashComma(element.COUNT_11.toString()), style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),), alignment: Alignment.centerRight)),
        DataCell(Align(child: Text(element.COUNT_12.toString() == 'null' ? '0' : Utils.getCashComma(element.COUNT_12.toString()), style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),), alignment: Alignment.centerRight)),
        DataCell(Align(child: Text(element.COUNT_13.toString() == 'null' ? '0' : Utils.getCashComma(element.COUNT_13.toString()), style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),), alignment: Alignment.centerRight)),
        DataCell(Align(child: Text(element.COUNT_14.toString() == 'null' ? '0' : Utils.getCashComma(element.COUNT_14.toString()), style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),), alignment: Alignment.centerRight)),
      ]));
    });

    return tempData;
  }

  List<DataColumn> getDataColumn() {
    List<DataColumn> tempData = [];

    tempData.add(DataColumn(label: Expanded(child: Text('주문일', textAlign: TextAlign.center)),));
    tempData.add(DataColumn(label: Expanded(child: Text('합계', textAlign: TextAlign.right)),));
    tempData.add(DataColumn(label: Expanded(child: Text('고객본인취소', textAlign: TextAlign.right)),));
    tempData.add(DataColumn(label: Expanded(child: Text('시간지연', textAlign: TextAlign.right)),));
    tempData.add(DataColumn(label: Expanded(child: Text('가맹점취소', textAlign: TextAlign.right)),));
    tempData.add(DataColumn(label: Expanded(child: Text('주소입력오류', textAlign: TextAlign.right)),));
    tempData.add(DataColumn(label: Expanded(child: Text('가맹점 정산 \n접수거부', style: TextStyle(fontSize: 12), textAlign: TextAlign.right)),));
    tempData.add(DataColumn(label: Expanded(child: Text('사유없음', textAlign: TextAlign.right)),));
    tempData.add(DataColumn(label: Expanded(child: Text('메뉴품절', textAlign: TextAlign.right)),));
    tempData.add(DataColumn(label: Expanded(child: Text('가맹점휴무', textAlign: TextAlign.right)),));
    tempData.add(DataColumn(label: Expanded(child: Text('배달불가', textAlign: TextAlign.right)),));
    tempData.add(DataColumn(label: Expanded(child: Text('POS서버\n응답없음', style: TextStyle(fontSize: 12), textAlign: TextAlign.right)),));
    tempData.add(DataColumn(label: Expanded(child: Text('재접수', textAlign: TextAlign.right)),));
    tempData.add(DataColumn(label: Expanded(child: Text('결재대기\n자동취소', style: TextStyle(fontSize: 12), textAlign: TextAlign.right)),));
    tempData.add(DataColumn(label: Expanded(child: Text('예약주문\n가맹점취소', style: TextStyle(fontSize: 12), textAlign: TextAlign.right)),));
    tempData.add(DataColumn(label: Expanded(child: Text('POS\n매핑 없음', style: TextStyle(fontSize: 12), textAlign: TextAlign.right)),));


    return tempData;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
