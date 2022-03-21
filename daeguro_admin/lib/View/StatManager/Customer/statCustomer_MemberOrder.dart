import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/Model/businessMenuItem.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Model/stat/statCustomerOrderModel.dart';
import 'package:daeguro_admin_app/View/StatManager/stat_controller.dart';
import 'package:daeguro_admin_app/Util/utils.dart';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:horizontal_data_table/horizontal_data_table.dart';

class StatCustomerOrderList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StatCustomerOrderListState();
  }
}

class StatCustomerOrderListState extends State with AutomaticKeepAliveClientMixin{
  List<StatCustomerOrderModel> dataList = <StatCustomerOrderModel>[];

  List<String> rightColumnTitle = [];
  List<BusinessMenuItem> leftColumnList = [];

  SearchItems _searchItems = new SearchItems();

  final double left_ColumnWidth = 130;
  final double right_ColumnWidth = 120;
  final double ColumnHeight = 30;

  final ScrollController _scrollHorizontalController = ScrollController();

  int listDummyMaxSize = 25;
  int mTotalOrderCount = 0;

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

    await StatController.to.getCustomerOrderData().then((value) {
      if (this.mounted) {
        if (value == null) {
          ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
        }
        else {
          setState(() {
            //rightColumnTitle.add('합계');

            rightColumnTitle.add('ORDER_COUNT');

            mTotalOrderCount = 0;
            value.forEach((element) {
              StatCustomerOrderModel temp = StatCustomerOrderModel.fromJson(element);
              //print('dataList temp.ITEM_CD: '+temp.ITEM_CD.toString());
              // if (temp.ITEM_CD == null || temp.ITEM_CD == 'null')
              //   temp.ITEM_CD = '합계';

              mTotalOrderCount += temp.ORDER_COUNT;

              dataList.add(temp);

              if (temp.DAY_COUNT != null) {
                int compareIdx = leftColumnList.indexWhere((item) => item.title.toString() == temp.DAY_COUNT);
                if (compareIdx == -1) {
                  leftColumnList.add(new BusinessMenuItem(title: temp.DAY_COUNT.toString(), isOpened: false));
                }
              }
            });



            leftColumnList.add(new BusinessMenuItem(title: '합계', isOpened: false));

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

  String getHeaderTitle(String title){
    String tempStr = '';

    if (title == '합계')
      return '합계';

    if (title == 'ORDER_COUNT')           tempStr = '건수';

    return tempStr;
  }

  @override
  void initState() {
    super.initState();

    Get.put(StatController());

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
            child: Text('구분', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', color: Colors.black54, fontSize: 14), textAlign: TextAlign.center), alignment: Alignment.center))
    );

    rightColumnTitle.forEach((element) {
      tempWidget.add(Container(
          color: MaterialStateColor.resolveWith((states) => Colors.blue[50]),
          width: right_ColumnWidth,
          height: ColumnHeight,
          alignment: Alignment.centerRight,
          child: Text(getHeaderTitle(element), style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', color: Colors.black54, fontSize: 14,), textAlign: TextAlign.center,))
      );
    });

    return tempWidget;
  }

  Widget generateLeftSideColumn(BuildContext context, int index) {
    String leftTitle = leftColumnList[index].title.toString() + '회';
    if (leftColumnList[index].title == '7')
      leftTitle = leftColumnList[index].title.toString() + '회 이상';

    return Container(
      width: left_ColumnWidth,
      height: ColumnHeight,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      color: leftColumnList[index].title.toString() == '합계' ? MaterialStateColor.resolveWith((states) => Colors.blue[50]) : Colors.transparent,
      child: Text(leftColumnList[index].title.toString() == '합계' ? '합계' : leftTitle, style: TextStyle(color: Colors.black,
          fontWeight: leftColumnList[index].title.toString() == '합계' ? FontWeight.bold : FontWeight.normal,
          fontFamily: 'NotoSansKR', fontSize: leftColumnList[index].isChildItem == true ? 12 : 14),
      ),
    );
  }

  Widget generateRightSideColumn(BuildContext context, int index) {
    List<Widget> tempWidget = [];

    rightColumnTitle.forEach((headerElement) {
      String compareTitle = leftColumnList[index].title.toString();
      String value = '';

      if (compareTitle.toString() == '합계')
        compareTitle = 'null';

      int compareIdx = dataList.indexWhere((item) => item.DAY_COUNT.toString() == compareTitle);
      if (compareIdx == -1){
      }
      else{
       if (headerElement == 'ORDER_COUNT')                  value = dataList[compareIdx].ORDER_COUNT.toString();
        // else if (headerElement == 'MENU_AMT')          value = dataList[compareIdx].MENU_AMT.toString();
        // else if (headerElement == 'DELI_TIP_AMT')      value = dataList[compareIdx].DELI_TIP_AMT.toString();
        // else if (headerElement == 'DISC_USE_AMT')      value = dataList[compareIdx].DISC_USE_AMT.toString();
        // else                                           value ='';
      }

      if (headerElement.toString() == '' || headerElement.toString() == null) {
        value = '';
      }

      tempWidget.add(getValueWidget(index, value, headerElement.toString()));
    });

    return Row(
      children: tempWidget,
    );
  }

  Widget getValueWidget(int index, String value, String headerTitle){
    double fontSize = 14.0;
    FontWeight fontWeight = FontWeight.normal;

    if (leftColumnList[index].title.toString() == '합계' || headerTitle == '합계')
      fontWeight = FontWeight.bold;

    if (leftColumnList[index].isChildItem == true)
      fontSize = 12.0;

    if (headerTitle == '')
      value = '';
    else if (leftColumnList[index].title.toString() == '합계')
      value = Utils.getCashComma(mTotalOrderCount.toString());
    else
      value = Utils.getCashComma(value.toString());

    return  Container(
      width: right_ColumnWidth,
      height: ColumnHeight,
      alignment: Alignment.centerRight,
      color: leftColumnList[index].title.toString() == '합계' ? MaterialStateColor.resolveWith((states) => Colors.blue[50]) : Colors.transparent,
      child: Text(value, style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontFamily: 'NotoSansKR', fontSize: fontSize),),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}
