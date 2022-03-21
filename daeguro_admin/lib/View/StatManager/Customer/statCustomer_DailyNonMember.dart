import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/Model/businessMenuItem.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Model/stat/statNonCustomerDailyModel.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/View/StatManager/stat_controller.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:horizontal_data_table/horizontal_data_table.dart';

class StatNonCustomerDailyList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StatNonCustomerDailyListState();
  }
}

class StatNonCustomerDailyListState extends State with AutomaticKeepAliveClientMixin{
    List<StatNonCustomerDailyModel> dataList = <StatNonCustomerDailyModel>[];

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

    if (rightColumnTitle != null) rightColumnTitle.clear();
    if (dataList != null) dataList.clear();
    if (leftColumnList != null) leftColumnList.clear();

    await StatController.to.getNonCustomerDailyData().then((value) {
      if (this.mounted) {
        if (value == null) {
          ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
        }
        else {
          setState(() {
            //rightColumnTitle.add('합계');

            value.forEach((element) {
              StatNonCustomerDailyModel temp = StatNonCustomerDailyModel.fromJson(element);
              if (temp.INSERT_DATE != null)
                temp.INSERT_DATE = DateTime.parse(temp.INSERT_DATE).month.toString() + '/' + DateTime.parse(temp.INSERT_DATE).day.toString();

              dataList.add(temp);

              if (temp.INSERT_DATE != null) {
                int compareIdx = rightColumnTitle.indexWhere((item) => item == temp.INSERT_DATE);
                if (compareIdx == -1) {
                  rightColumnTitle.add(temp.INSERT_DATE.toString());
                }
              }
            });

            leftColumnList.add(new BusinessMenuItem(title: '비회원', isOpened: false));

            if (listDummyMaxSize > rightColumnTitle.length) {
              int dummyCount = listDummyMaxSize - rightColumnTitle.length;
              for (int i = 0; i < dummyCount; i++) {
                rightColumnTitle.add('');
              }
            }
          });
        }
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
      _scrollHorizontalController.jumpTo(100.0);
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
            //height: MediaQuery.of(context).size.height - 286,
            //padding: const EdgeInsets.only(top: 10.0),
            //height: 400,
            child: HorizontalDataTable(
              leftHandSideColumnWidth: left_ColumnWidth,
              rightHandSideColumnWidth: (rightColumnTitle.length * right_ColumnWidth),
              isFixedHeader: true,
              headerWidgets: getTitleWidget(),
              leftSideItemBuilder: generateLeftSideColumn,
              rightSideItemBuilder: generateRightSideColumn,
              itemCount: leftColumnList.length,
              rowSeparatorWidget: const Divider(color: Colors.black12, height: 1.0, thickness: 0.0),
              leftHandSideColBackgroundColor: Color(0xffffff),
              rightHandSideColBackgroundColor: Color(0xffffff),
              verticalScrollbarStyle: const ScrollbarStyle(thumbColor: Colors.black12, isAlwaysShown: false, thickness: 8.0, radius: Radius.circular(5.0)),
              horizontalScrollbarStyle: const ScrollbarStyle(thumbColor: Colors.black12, isAlwaysShown: true, thickness: 8.0, radius: Radius.circular(5.0)),
              enablePullToRefresh: false,
              horizontalScrollController: _scrollHorizontalController,
            ),
          ),
          Divider(height: 20,),
          SizedBox(height: 30,)
        ],
      ),
    );
  }

  List<Widget> getTitleWidget() {
    List<Widget> tempWidget = [];

    tempWidget.add(Container(
        color: MaterialStateColor.resolveWith((states) => Colors.blue[50]),
        width: left_ColumnWidth,
        height: ColumnHeight,
        alignment: Alignment.center,
        child: Align(
            child: Text('구분', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', color: Colors.black54, fontSize: 14), textAlign: TextAlign.center), alignment: Alignment.center)));

    rightColumnTitle.forEach((element) {
      tempWidget.add(Container(
          color: MaterialStateColor.resolveWith((states) => Colors.blue[50]),
          width: right_ColumnWidth,
          height: ColumnHeight,
          alignment: Alignment.centerRight,
          child: Text(element, style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', color: Colors.black54, fontSize: 14,), textAlign: TextAlign.center,))
      );
    });

    return tempWidget;
  }

  Widget generateLeftSideColumn(BuildContext context, int index) {
    return Container(
      width: left_ColumnWidth,
      height: ColumnHeight,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(leftColumnList[index].title.toString(), style: TextStyle(color: Colors.black,
          fontWeight: leftColumnList[index].title.toString() == '합계' ? FontWeight.bold : FontWeight.normal,
          fontFamily: 'NotoSansKR', fontSize: leftColumnList[index].isChildItem == true ? 12 : 14),
      ),
    );
  }

  Widget generateRightSideColumn(BuildContext context, int index) {
    List<Widget> tempWidget = [];

    rightColumnTitle.forEach((headerElement) {
      double fontSize = 14.0;
      FontWeight fontWeight = FontWeight.normal;
      if (leftColumnList[index].title.toString() == '합계' || headerElement.toString() == '합계') fontWeight = FontWeight.bold;

      if (leftColumnList[index].isChildItem == true) fontSize = 12.0;

      String value = getCurrentValue(dataList, leftColumnList[index].title.toString(), headerElement.toString());

      if (headerElement.toString() == '')
        value = '';
      else
        value = Utils.getCashComma(value.toString());

      tempWidget.add(
        Container(
          width: right_ColumnWidth,
          height: ColumnHeight,
          alignment: Alignment.centerRight,
          child: Text(value, style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontFamily: 'NotoSansKR', fontSize: fontSize),),
        ),
      );
    });

    return Row(
      children: tempWidget,
    );
  }

    String getCurrentValue(List<StatNonCustomerDailyModel> targetList, String title, String header) {
      String tempValue = '0';

      for (final element in targetList) {
        if (title == '합계') {
          if (header == '합계') {
            if (element.INSERT_DATE == null) {
              tempValue = element.COUNT.toString();
              break;
            }
          } else if (element.INSERT_DATE == header) {
            tempValue = element.COUNT.toString();
            break;
          }
        } else {
          if (header == '합계') {
            if (element.INSERT_DATE == null) {
              tempValue = element.COUNT.toString();
              break;
            }
          } else if (element.INSERT_DATE == header) {
            tempValue = element.COUNT.toString();
            break;
          }
        }
      }

      return tempValue;
    }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
