import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/Model/businessMenuItem.dart';
import 'package:daeguro_admin_app/Model/businessSalesStatisticsModel.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/View/StatManager/stat_controller.dart';
import 'package:daeguro_admin_app/Util/utils.dart';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:convert';
import 'package:excel/excel.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:universal_html/html.dart' show AnchorElement;

class StatShopSalesList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StatShopSalesListState();
  }
}

class StatShopSalesListState extends State with AutomaticKeepAliveClientMixin{
  List<BuinessSalesStatisticsModel> dataList = <BuinessSalesStatisticsModel>[];

  List<String> rightColumnTitle = [];
  List<BusinessMenuItem> leftColumnList = [];
  List<BuinessSalesStatisticsModel> exportTotalList = <BuinessSalesStatisticsModel>[];

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
    loadData();
  }

  loadData() async {
    await ISProgressDialog(context).show(status: 'Loading...');

    if (rightColumnTitle != null) rightColumnTitle.clear();
    if (dataList != null) dataList.clear();
    if (leftColumnList != null) leftColumnList.clear();

    await StatController.to.getShopSalesData(_searchItems.startdate, _searchItems.enddate).then((value) {
      if(value == null){
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else{
        rightColumnTitle.add('합계');
        value.forEach((element) {
          BuinessSalesStatisticsModel temp = BuinessSalesStatisticsModel.fromJson(element);
          dataList.add(temp);

          if (temp.SALESMAN_NAME != null) {
            int compareIdx = rightColumnTitle.indexWhere((item) => item == temp.SALESMAN_NAME);
            if (compareIdx == -1) {
              rightColumnTitle.add(temp.SALESMAN_NAME.toString());
            }
          }

          if (temp.GUNGU_NAME != null) {
            int compareIdx = leftColumnList.indexWhere((item) => item.title.toString() == temp.GUNGU_NAME);
            if (compareIdx == -1) {
              leftColumnList.add(new BusinessMenuItem(title: temp.GUNGU_NAME.toString(), isOpened: false));
            }
          }
        });
        leftColumnList.add(new BusinessMenuItem(title: '합계', isOpened: false));

        if (listDummyMaxSize > rightColumnTitle.length) {
          int dummyCount = listDummyMaxSize - rightColumnTitle.length;
          for (int i = 0; i<dummyCount; i++){
            rightColumnTitle.add('');
          }
        }

        exportTotalList.clear();
        exportTotalList = List.from(dataList);
      }
    });

    if (this.mounted) {
      setState(() {

      });
    }
    await ISProgressDialog(context).dismiss();
  }

  addDetailData(String gungu) async {
    List<BuinessSalesStatisticsModel> tempDataList = [];
    await StatController.to.getShopSalesDetailData(gungu, _searchItems.startdate, _searchItems.enddate).then((List<dynamic> value) {
      //tempDataList = List.from(getDetailData(gungu, value));
      value.forEach((element) {
        BuinessSalesStatisticsModel temp = BuinessSalesStatisticsModel.fromJson(element);
        temp.p_gungu = gungu;
        temp.GUNGU_NAME = temp.DONG_NAME;
        tempDataList.add(temp);
      });
    });

    setState(() {
      tempDataList.forEach((element) {
        int leftColumnindex =
            leftColumnList.indexWhere((item) => item.title.toString() == gungu);
        if (element.GUNGU_NAME != null) {
          int compareIdx = leftColumnList.indexWhere(
              (item) => item.title.toString() == element.GUNGU_NAME);
          if (compareIdx == -1) {
            leftColumnList.insert(
                leftColumnindex + 1,
                new BusinessMenuItem(
                    title: element.GUNGU_NAME.toString(),
                    isChildItem: true,
                    isOpened: false,
                    ptitle: gungu));
          }
        }

        dataList.insert(dataList.length, element);
      });
    });
  }

  removeDetailData(String gungu) {
    setState(() {
      dataList.removeWhere((item) => (item.p_gungu == gungu));
      leftColumnList.removeWhere((item) => (item.ptitle == gungu));
    });
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

    if (exportTotalList != null){
      exportTotalList.clear();
      exportTotalList = null;
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
          showPagerBar(),
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
            child: Text('군/구', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', color: Colors.black54, fontSize: 14), textAlign: TextAlign.center), alignment: Alignment.center)));

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
      color: leftColumnList[index].title.toString() == '합계' ? MaterialStateColor.resolveWith((states) => Colors.blue[50]) : Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          (leftColumnList[index].title.toString() == '합계' || leftColumnList[index].isChildItem == true)
              ? Container()
              : IconButton(
                  icon: Icon(leftColumnList[index].isOpened == true ? Icons.remove_circle : Icons.add_circle, color: Colors.blue, size: 20),
                  onPressed: () {
                    if (leftColumnList[index].isOpened == true) {
                      leftColumnList[index].isOpened = false;
                      removeDetailData(leftColumnList[index].title.toString());
                    }
                    else {
                      leftColumnList[index].isOpened = true;
                      addDetailData(leftColumnList[index].title.toString());
                    }
                  },
                ),
          Text(leftColumnList[index].title.toString(), style: TextStyle(color: Colors.black,
              fontWeight: leftColumnList[index].title.toString() == '합계' ? FontWeight.bold : FontWeight.normal,
              fontFamily: 'NotoSansKR', fontSize: leftColumnList[index].isChildItem == true ? 12 : 14),
          ),
        ],
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
          color: leftColumnList[index].title.toString() == '합계' ? MaterialStateColor.resolveWith((states) => Colors.blue[50]) : Colors.transparent,
          child: Text(value, style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontFamily: 'NotoSansKR', fontSize: fontSize),),
        ),
      );
    });

    return Row(
      children: tempWidget,
    );
  }

  String getCurrentValue(List<BuinessSalesStatisticsModel> targetList,
      String gungu, String header) {
    String tempValue = '0';

    for (final element in targetList) {
      if (gungu == '합계') {
        if (header == '합계') {
          if (element.GUNGU_NAME == null && element.SALESMAN_NAME == null) {
            tempValue = element.COUNT.toString();
            break;
          }
        } else if (element.GUNGU_NAME == null &&
            element.SALESMAN_NAME == header) {
          tempValue = element.COUNT.toString();
          break;
        }
      } else {
        if (header == '합계') {
          if (element.GUNGU_NAME == gungu && element.SALESMAN_NAME == null) {
            tempValue = element.COUNT.toString();
            break;
          }
        } else if (element.GUNGU_NAME == gungu &&
            element.SALESMAN_NAME == header) {
          tempValue = element.COUNT.toString();
          break;
        }
      }
    }
    return tempValue;
  }

  String getCurrentDongValue(List<BuinessSalesStatisticsModel> targetList,
      String p_gungu, String dongName, String title) {
    String tempValue = '0';

    for (final element in targetList) {
      if (dongName == null || dongName == 'null') {
        if (title == '합계') {
          if (element.p_gungu == p_gungu &&
              element.DONG_NAME == null &&
              element.SALESMAN_NAME == null) {
            tempValue = element.COUNT.toString();
            break;
          }
        } else if (element.p_gungu == p_gungu &&
            element.DONG_NAME == null &&
            element.SALESMAN_NAME == title) {
          tempValue = element.COUNT.toString();
          break;
        }
      } else {
        if (title == '합계') {
          if (element.p_gungu == p_gungu &&
              element.DONG_NAME == dongName &&
              element.SALESMAN_NAME == null) {
            tempValue = element.COUNT.toString();
            break;
          }
        } else if (element.p_gungu == p_gungu &&
            element.DONG_NAME == dongName &&
            element.SALESMAN_NAME == title) {
          tempValue = element.COUNT.toString();
          break;
        }
      }
    }
    return tempValue;
  }

  Container showPagerBar() {
    return Container(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: AuthUtil.isAuthDownloadEnabled('12') == true ? ISButton(
          label: 'Excel저장',
          iconColor: Colors.white,
          iconData: Icons.reply,
          textStyle: TextStyle(color: Colors.white),
          onPressed: () {
            SaveExcelExport();
          }) : Container(height: 30,),
    );
  }

  void SaveExcelExport() async {
    var excel = Excel.createExcel();

    compute(computeExcelExportData, excel).then((value) {
      DateTime now = DateTime.now();
      DateTime date = DateTime(now.year, now.month, now.day);

      AnchorElement(href: 'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(value.encode())}')
        ..setAttribute('download', '가맹점누적집계현황[영업자별]_' + formatDate(date, [yy, mm, dd]) + '.xlsx')
        ..click();
    });
  }

  Future<Excel> computeExcelExportData(Excel excel) async {
    List<BuinessSalesStatisticsModel> exportDataList = <BuinessSalesStatisticsModel>[];
    List<BusinessMenuItem> leftTitleList = [];

    List<String> gunguName = [
      '달서구',
      '달성군',
      '중구',
      '남구',
      '서구',
      '동구',
      '북구',
      '수성구',
      '합계'
    ];

    gunguName.forEach((gungu_element) async {
      //leftTitleList.add(new BusinessMenuItem(title: gungu_element, isChildItem: false));
      await StatController.to.getShopSalesDetailData(gungu_element, _searchItems.startdate, _searchItems.enddate).then((List<dynamic> value) async {
        value.forEach((element) {
          BuinessSalesStatisticsModel temp = BuinessSalesStatisticsModel.fromJson(element);
          temp.p_gungu = gungu_element;
          temp.GUNGU_NAME = temp.DONG_NAME;
          // if (temp.GUNGU_NAME == null)
          //   temp.GUNGU_NAME = '합계';

          exportDataList.add(temp);
        });

        exportDataList.forEach((element) {
          int leftColumnindex = leftTitleList.indexWhere((item) => item.title.toString() == gungu_element);
          if (element.GUNGU_NAME == null) {
            //print('-> 합계 p_gungu: '+element.p_gungu.toString()+', DONG_NAME: '+element.DONG_NAME.toString()+', SALESMAN_NAME: '+element.SALESMAN_NAME.toString()+', COUNT: '+element.COUNT.toString());
            int compareIdx = leftTitleList.indexWhere((item) => (item.title.toString() == element.GUNGU_NAME.toString() && item.ptitle.toString() == element.p_gungu.toString()));
            if (compareIdx == -1) {
              leftTitleList.insert(leftColumnindex + 1, new BusinessMenuItem(title: element.GUNGU_NAME.toString(), isChildItem: false, ptitle: element.p_gungu.toString()));
            }
          }
        });

        exportDataList.forEach((element) {
          int leftColumnindex = leftTitleList.indexWhere((item) => item.title.toString() == gungu_element);
          if (element.GUNGU_NAME != null) {
            int compareIdx = leftTitleList.indexWhere((item) => item.title.toString() == element.GUNGU_NAME.toString());
            if (compareIdx == -1) {
              leftTitleList.insert(leftColumnindex + 1, new BusinessMenuItem(title: element.GUNGU_NAME.toString(), isChildItem: true, ptitle: gungu_element.toString()));
            }
          }
        });
      });
    });

    await Future.delayed(Duration(milliseconds: 1000), () {
      int totalIndex = 1;
      gunguName.forEach((gungu_element) {
        Sheet sheetObject = excel[gungu_element];
        excel.setDefaultSheet(gungu_element);

        CellStyle cellStyle = CellStyle(fontFamily: '맑은 고딕', fontSize: 11, horizontalAlign: HorizontalAlign.Center);

        var cell = null;
        int rightColumnIndex = 1;
        String tempTotalTitle;

        rightColumnTitle.forEach((rightColumnElement) {
          cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: rightColumnIndex, rowIndex: 0)); //.indexByString(key));
          cell.value = rightColumnElement;
          cell.cellStyle = cellStyle;

          int rowIndex = 1;
          leftTitleList.forEach((leftElement) {
            if (gungu_element == leftElement.ptitle) {
              String value = getCurrentDongValue(exportDataList, leftElement.ptitle, leftElement.title, rightColumnElement.toString());
              String tempStr = leftElement.title.toString();
              if (tempStr == null || tempStr == 'null') {
                tempStr = '합계';
              }

              excel.updateCell(gungu_element.toString(), CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex), tempStr, cellStyle: cellStyle);
              if (rightColumnElement.toString() == '')
                excel.updateCell(gungu_element.toString(), CellIndex.indexByColumnRow(columnIndex: rightColumnIndex, rowIndex: rowIndex), '', cellStyle: cellStyle);
              else
                excel.updateCell(gungu_element.toString(), CellIndex.indexByColumnRow(columnIndex: rightColumnIndex, rowIndex: rowIndex), int.parse(value), cellStyle: cellStyle);

              rowIndex++;
            }
          });

          if (tempTotalTitle != gungu_element.toString()) {
            String value = getCurrentValue(exportTotalList, gungu_element.toString(), rightColumnElement.toString());

            excel.updateCell('합계', CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: totalIndex), gungu_element.toString(), cellStyle: cellStyle);
            if (rightColumnElement.toString() == '')
              excel.updateCell('합계', CellIndex.indexByColumnRow(columnIndex: rightColumnIndex, rowIndex: totalIndex), '', cellStyle: cellStyle);
            else
              excel.updateCell('합계', CellIndex.indexByColumnRow(columnIndex: rightColumnIndex, rowIndex: totalIndex), int.parse(value), cellStyle: cellStyle);

            tempTotalTitle = gungu_element.toString();
          }
          else {
            String value = getCurrentValue(exportTotalList, gungu_element.toString(), rightColumnElement.toString());

            if (rightColumnElement.toString() == '')
              excel.updateCell('합계', CellIndex.indexByColumnRow(columnIndex: rightColumnIndex, rowIndex: totalIndex), '', cellStyle: cellStyle);
            else
              excel.updateCell('합계', CellIndex.indexByColumnRow(columnIndex: rightColumnIndex, rowIndex: totalIndex), int.parse(value), cellStyle: cellStyle);
          }

          rightColumnIndex++;
        });
        totalIndex++;
      });
    });

    excel.delete('Sheet1');

    return excel;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
