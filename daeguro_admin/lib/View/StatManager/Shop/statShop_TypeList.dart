import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/Model/businessTypeListModel.dart';
import 'package:daeguro_admin_app/Model/businessTypeStatisticsModel.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Model/shop/shop_divcode.dart';
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
import 'package:universal_html/html.dart' show AnchorElement;

class StatShopTypeList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StatShopTypeListState();
  }
}

class StatShopTypeListState extends State with AutomaticKeepAliveClientMixin{
  List<ShopDivCodeModel> divList = <ShopDivCodeModel>[];
  List<BuinessTypeListModel> dataList = <BuinessTypeListModel>[];
  List<BuinessTypeListModel> exportTotalList = <BuinessTypeListModel>[];

  SearchItems _searchItems = new SearchItems();

  List<String> gunguName = ['달서구', '달성군', '중구', '남구', '서구', '동구', '북구', '수성구', '합계'];

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

    divList.clear();
    dataList.clear();

    await StatController.to.getShopTypeData(_searchItems.startdate, _searchItems.enddate).then((value) {
      gunguName.forEach((element) {
        dataList.add(new BuinessTypeListModel(
          isChild: false,
          gungu: element,
          total: 0,
          menuName_1013: 0,
          menuName_1014: 0,
          menuName_9000: 0,
          menuName_1001: 0,
          menuName_1003: 0,
          menuName_1004: 0,
          menuName_1005: 0,
          menuName_1006: 0,
          menuName_1007: 0,
          menuName_1008: 0,
          menuName_1024: 0,
          menuName_1025: 0,
          menuName_1026: 0,
          menuName_1000: 0,
          menuName_1027: 0,
          menuName_1028: 0,
          menuName_1029: 0,
          menuName_1030: 0,
          menuName_1031: 0,));
      });

      dataList.forEach((element) {
        value.forEach((e) {
          BuinessTypeStatisticsModel temp = BuinessTypeStatisticsModel.fromJson(e);
          if (element.gungu == temp.GUNGU_NAME) {
            if (temp.ITEM_CD == null)
              element.total = temp.COUNT;
            else if (temp.ITEM_CD == '1013')
              element.menuName_1013 = temp.COUNT;
            else if (temp.ITEM_CD == '1014')
              element.menuName_1014 = temp.COUNT;
            else if (temp.ITEM_CD == '9000')
              element.menuName_9000 = temp.COUNT;
            else if (temp.ITEM_CD == '1001')
              element.menuName_1001 = temp.COUNT;
            else if (temp.ITEM_CD == '1003')
              element.menuName_1003 = temp.COUNT;
            else if (temp.ITEM_CD == '1004')
              element.menuName_1004 = temp.COUNT;
            else if (temp.ITEM_CD == '1005')
              element.menuName_1005 = temp.COUNT;
            else if (temp.ITEM_CD == '1006')
              element.menuName_1006 = temp.COUNT;
            else if (temp.ITEM_CD == '1007')
              element.menuName_1007 = temp.COUNT;
            else if (temp.ITEM_CD == '1008')
              element.menuName_1008 = temp.COUNT;
            else if (temp.ITEM_CD == '1024')
              element.menuName_1024 = temp.COUNT;
            else if (temp.ITEM_CD == '1025')
              element.menuName_1025 = temp.COUNT;
            else if (temp.ITEM_CD == '1026')
              element.menuName_1026 = temp.COUNT;
            else if (temp.ITEM_CD == '1000')
              element.menuName_1000 = temp.COUNT;
            else if (temp.ITEM_CD == '1027')
              element.menuName_1027 = temp.COUNT;
            else if (temp.ITEM_CD == '1028')
              element.menuName_1028 = temp.COUNT;
            else if (temp.ITEM_CD == '1029')
              element.menuName_1029 = temp.COUNT;
            else if (temp.ITEM_CD == '1030')
              element.menuName_1030 = temp.COUNT;
            else if (temp.ITEM_CD == '1031') element.menuName_1031 = temp.COUNT;
          }            else {
            if (element.gungu == '합계' && temp.GUNGU_NAME == null) {
              if (temp.ITEM_CD == null)
                element.total = temp.COUNT;
              else if (temp.ITEM_CD == '1013')
                element.menuName_1013 = temp.COUNT;
              else if (temp.ITEM_CD == '1014')
                element.menuName_1014 = temp.COUNT;
              else if (temp.ITEM_CD == '9000')
                element.menuName_9000 = temp.COUNT;
              else if (temp.ITEM_CD == '1001')
                element.menuName_1001 = temp.COUNT;
              else if (temp.ITEM_CD == '1003')
                element.menuName_1003 = temp.COUNT;
              else if (temp.ITEM_CD == '1004')
                element.menuName_1004 = temp.COUNT;
              else if (temp.ITEM_CD == '1005')
                element.menuName_1005 = temp.COUNT;
              else if (temp.ITEM_CD == '1006')
                element.menuName_1006 = temp.COUNT;
              else if (temp.ITEM_CD == '1007')
                element.menuName_1007 = temp.COUNT;
              else if (temp.ITEM_CD == '1008')
                element.menuName_1008 = temp.COUNT;
              else if (temp.ITEM_CD == '1024')
                element.menuName_1024 = temp.COUNT;
              else if (temp.ITEM_CD == '1025')
                element.menuName_1025 = temp.COUNT;
              else if (temp.ITEM_CD == '1026')
                element.menuName_1026 = temp.COUNT;
              else if (temp.ITEM_CD == '1000')
                element.menuName_1000 = temp.COUNT;
              else if (temp.ITEM_CD == '1027')
                element.menuName_1027 = temp.COUNT;
              else if (temp.ITEM_CD == '1028')
                element.menuName_1028 = temp.COUNT;
              else if (temp.ITEM_CD == '1029')
                element.menuName_1029 = temp.COUNT;
              else if (temp.ITEM_CD == '1030')
                element.menuName_1030 = temp.COUNT;
              else if (temp.ITEM_CD == '1031') element.menuName_1031 = temp.COUNT;
            }
          }
        });
      });
      exportTotalList.clear();
      exportTotalList = List.from(dataList);
    });

    await ShopController.to.getDataDivItems().then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        value.forEach((element) {
          ShopDivCodeModel tempDivData = ShopDivCodeModel.fromJson(element);
          divList.add(tempDivData);
        });
      }
    });



    if (this.mounted) {
      setState(() {

      });
    }

    await ISProgressDialog(context).dismiss();
  }

  addDetailData(String gungu) async {
    List<BuinessTypeListModel> tempDataList = [];
    await StatController.to.getShopTypeDetailData(gungu, _searchItems.startdate, _searchItems.enddate).then((List<dynamic> value) {
      tempDataList = List.from(getDetailData(gungu, value));
    });

    setState(() {
      int selectindex = dataList.indexWhere((item) => item.gungu.toString() == gungu);
      tempDataList.forEach((element) {
        if (element.gungu != null) dataList.insert(selectindex + 1, element);
      });
    });
  }

  removeDetailData(String gungu) {
    setState(() {
      dataList.removeWhere((item) => (item.p_gungu == gungu && item.isChild == true));
    });
  }

  List<BuinessTypeListModel> getDetailData(String gungu, List<dynamic> targetList) {
    List<BuinessTypeListModel> tempDataList = <BuinessTypeListModel>[];

    int index = 0;
    targetList.forEach((e) {
      BuinessTypeStatisticsModel temp = BuinessTypeStatisticsModel.fromJson(e);

      int compareIndex = tempDataList.indexWhere((item) => item.gungu == temp.DONG_NAME);

      if (compareIndex == -1) {
        //if (temp.DONG_NAME != null){
        tempDataList.add(BuinessTypeListModel(
            isChild: true,
            p_gungu: gungu,
            gungu: temp.DONG_NAME,
            total: 0,
            menuName_1013: 0,
            menuName_1014: 0,
            menuName_9000: 0,
            menuName_1001: 0,
            menuName_1003: 0,
            menuName_1004: 0,
            menuName_1005: 0,
            menuName_1006: 0,
            menuName_1007: 0,
            menuName_1008: 0,
            menuName_1024: 0,
            menuName_1025: 0,
            menuName_1026: 0,
            menuName_1000: 0,
            menuName_1027: 0,
            menuName_1028: 0,
            menuName_1029: 0,
            menuName_1030: 0,
            menuName_1031: 0));

        BuinessTypeListModel tempListModel = tempDataList.elementAt(index);

        if (temp.ITEM_CD == null)
          tempListModel.total = temp.COUNT;
        else if (temp.ITEM_CD == '1013')
          tempListModel.menuName_1013 = temp.COUNT;
        else if (temp.ITEM_CD == '1014')
          tempListModel.menuName_1014 = temp.COUNT;
        else if (temp.ITEM_CD == '9000')
          tempListModel.menuName_9000 = temp.COUNT;
        else if (temp.ITEM_CD == '1001')
          tempListModel.menuName_1001 = temp.COUNT;
        else if (temp.ITEM_CD == '1003')
          tempListModel.menuName_1003 = temp.COUNT;
        else if (temp.ITEM_CD == '1004')
          tempListModel.menuName_1004 = temp.COUNT;
        else if (temp.ITEM_CD == '1005')
          tempListModel.menuName_1005 = temp.COUNT;
        else if (temp.ITEM_CD == '1006')
          tempListModel.menuName_1006 = temp.COUNT;
        else if (temp.ITEM_CD == '1007')
          tempListModel.menuName_1007 = temp.COUNT;
        else if (temp.ITEM_CD == '1008')
          tempListModel.menuName_1008 = temp.COUNT;
        else if (temp.ITEM_CD == '1024')
          tempListModel.menuName_1024 = temp.COUNT;
        else if (temp.ITEM_CD == '1025')
          tempListModel.menuName_1025 = temp.COUNT;
        else if (temp.ITEM_CD == '1026')
          tempListModel.menuName_1026 = temp.COUNT;
        else if (temp.ITEM_CD == '1000')
          tempListModel.menuName_1000 = temp.COUNT;
        else if (temp.ITEM_CD == '1027')
          tempListModel.menuName_1027 = temp.COUNT;
        else if (temp.ITEM_CD == '1028')
          tempListModel.menuName_1028 = temp.COUNT;
        else if (temp.ITEM_CD == '1029')
          tempListModel.menuName_1029 = temp.COUNT;
        else if (temp.ITEM_CD == '1030')
          tempListModel.menuName_1030 = temp.COUNT;
        else if (temp.ITEM_CD == '1031') tempListModel.menuName_1031 = temp.COUNT;

        index++;
        //}
      } else {
        BuinessTypeListModel tempListModel = tempDataList.elementAt(compareIndex);

        if (temp.ITEM_CD == null)
          tempListModel.total = temp.COUNT;
        else if (temp.ITEM_CD == '1013')
          tempListModel.menuName_1013 = temp.COUNT;
        else if (temp.ITEM_CD == '1014')
          tempListModel.menuName_1014 = temp.COUNT;
        else if (temp.ITEM_CD == '9000')
          tempListModel.menuName_9000 = temp.COUNT;
        else if (temp.ITEM_CD == '1001')
          tempListModel.menuName_1001 = temp.COUNT;
        else if (temp.ITEM_CD == '1003')
          tempListModel.menuName_1003 = temp.COUNT;
        else if (temp.ITEM_CD == '1004')
          tempListModel.menuName_1004 = temp.COUNT;
        else if (temp.ITEM_CD == '1005')
          tempListModel.menuName_1005 = temp.COUNT;
        else if (temp.ITEM_CD == '1006')
          tempListModel.menuName_1006 = temp.COUNT;
        else if (temp.ITEM_CD == '1007')
          tempListModel.menuName_1007 = temp.COUNT;
        else if (temp.ITEM_CD == '1008')
          tempListModel.menuName_1008 = temp.COUNT;
        else if (temp.ITEM_CD == '1024')
          tempListModel.menuName_1024 = temp.COUNT;
        else if (temp.ITEM_CD == '1025')
          tempListModel.menuName_1025 = temp.COUNT;
        else if (temp.ITEM_CD == '1026')
          tempListModel.menuName_1026 = temp.COUNT;
        else if (temp.ITEM_CD == '1000')
          tempListModel.menuName_1000 = temp.COUNT;
        else if (temp.ITEM_CD == '1027')
          tempListModel.menuName_1027 = temp.COUNT;
        else if (temp.ITEM_CD == '1028')
          tempListModel.menuName_1028 = temp.COUNT;
        else if (temp.ITEM_CD == '1029')
          tempListModel.menuName_1029 = temp.COUNT;
        else if (temp.ITEM_CD == '1030')
          tempListModel.menuName_1030 = temp.COUNT;
        else if (temp.ITEM_CD == '1031') tempListModel.menuName_1031 = temp.COUNT;
      }
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

    if (divList != null) {
      divList.clear();
      divList = null;
    }

    if (exportTotalList != null) {
      exportTotalList.clear();
      exportTotalList = null;
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
              //scrollDirection: Axis.horizontal,
              dataRowHeight: 30.0,
              rows: getDataRow(),
              columns: getDataColumn(),
            ),
          ),
          Divider(height: 20,),
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
      if (element.gungu == '합계') {
        fontWeight = FontWeight.bold;
        totalSelected = true;
      }

      if (element.isChild == true) fontSize = 12.0;

      tempData.add(DataRow(selected: totalSelected, cells: [
        DataCell(Container(
          width: 100,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (element.gungu == '합계' || element.isChild == true)
                  ? Container()
                  : IconButton(
                icon: Icon(element.isOpened == true ? Icons.remove_circle : Icons.add_circle, color: Colors.blue, size: 20),
                onPressed: () {
                  if (element.isOpened == true) {
                    element.isOpened = false;
                    removeDetailData(element.gungu);
                  } else {
                    element.isOpened = true;
                    addDetailData(element.gungu);
                  }
                },
              ),
              Align(
                  child: Text(
                    element.gungu.toString(),
                    style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
                  ),
                  alignment: element.isChild == true ? Alignment.centerRight : Alignment.center)
            ],
          ),
        )),
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.total.toString()),
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        //합계

        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.menuName_1013.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        //돈까스/일식[1013]
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.menuName_1014.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        //아시안/일식[1014]
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.menuName_9000.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        //기타[9000]
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.menuName_1001.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        //치킨/찜닭[1001]
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.menuName_1003.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        //피자[1003]
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.menuName_1004.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        //중식[1004]
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.menuName_1005.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        //분식[1005]
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.menuName_1006.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        //족발/보쌈[1006]
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.menuName_1007.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        //야식[1007]
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.menuName_1008.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        //한식[1008]
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.menuName_1024.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        //패스트푸드[1024]
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.menuName_1025.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        //도시락/죽[1025]
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.menuName_1026.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        //카페/디저트[1026]
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.menuName_1000.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.menuName_1031.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        //1인분[1000]
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.menuName_1027.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.menuName_1028.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.menuName_1029.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.menuName_1030.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight))
        //반찬[1027]
      ]));
    });

    return tempData;
  }

  List<DataColumn> getDataColumn() {
    List<DataColumn> tempData = [];

    //Header
    //tempData.add(DataColumn(label: Expanded(child: Text('', textAlign: TextAlign.center)),));
    tempData.add(DataColumn(
      label: Expanded(child: Text('군/구', textAlign: TextAlign.center)),
    ));
    tempData.add(DataColumn(
      label: Expanded(child: Text('합계', textAlign: TextAlign.right)),
    ));
    divList.forEach((element) {
      tempData.add(DataColumn(
        label: Expanded(child: Text(element.itemName, textAlign: TextAlign.right)),
      ));
    });

    return tempData;
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
        ..setAttribute('download', '가맹점누적집계현황[업종별]_' + formatDate(date, [yy, mm, dd]) + '.xlsx')
        ..click();
    });
  }

  Future<Excel> computeExcelExportData(Excel excel) async {
    List<BuinessTypeListModel> exportDataList = <BuinessTypeListModel>[];
    gunguName.forEach((gungu_element) async {
      Sheet sheetObject = excel[gungu_element];
      excel.setDefaultSheet(gungu_element);

      CellStyle cellStyle = CellStyle(fontFamily: '맑은 고딕', fontSize: 11, horizontalAlign: HorizontalAlign.Center);
      //
      var excelCellData = {
        "A1": "",
        "B1": "합계",
        "C1": "돈까스/일식",
        "D1": "아시안/일식",
        "E1": "기타",
        "F1": "치킨/찜닭",
        "G1": "피자",
        "H1": "중식",
        "I1": "분식",
        "J1": "족발/보쌈",
        "K1": "야식",
        "L1": "한식",
        "M1": "패스트푸드",
        "N1": "도시락/죽",
        "O1": "카페/디저트",
        "P1": "1인분",
        "Q1": "반찬",
        "R1": "찜/탕",
        "S1": "정육",
        "T1": "펫",
        "U1": "로컬푸드",
      };

      var cell = null;
      excelCellData.forEach((key, value) {
        cell = sheetObject.cell(CellIndex.indexByString(key));
        cell.value = value;
        cell.cellStyle = cellStyle;
      });

      await StatController.to.getShopTypeDetailData(gungu_element, _searchItems.startdate, _searchItems.enddate).then((List<dynamic> value) {
        exportDataList.addAll(getDetailData(gungu_element, value));
      });
    });

    await Future.delayed(Duration(milliseconds: 1000), () {
      CellStyle cellStyle = CellStyle(fontFamily: '맑은 고딕', fontSize: 11, horizontalAlign: HorizontalAlign.Center);

      if (exportDataList.length > 0) {
        int listTotalIdx = 2;
        exportTotalList.forEach((totalElement) {
          excel.updateCell('합계', CellIndex.indexByString('A$listTotalIdx'), totalElement.gungu, cellStyle: cellStyle);
          excel.updateCell('합계', CellIndex.indexByString('B$listTotalIdx'), totalElement.total, cellStyle: cellStyle);
          excel.updateCell('합계', CellIndex.indexByString('C$listTotalIdx'), totalElement.menuName_1013, cellStyle: cellStyle);
          excel.updateCell('합계', CellIndex.indexByString('D$listTotalIdx'), totalElement.menuName_1014, cellStyle: cellStyle);
          excel.updateCell('합계', CellIndex.indexByString('E$listTotalIdx'), totalElement.menuName_9000, cellStyle: cellStyle);
          excel.updateCell('합계', CellIndex.indexByString('F$listTotalIdx'), totalElement.menuName_1001, cellStyle: cellStyle);
          excel.updateCell('합계', CellIndex.indexByString('G$listTotalIdx'), totalElement.menuName_1003, cellStyle: cellStyle);
          excel.updateCell('합계', CellIndex.indexByString('H$listTotalIdx'), totalElement.menuName_1004, cellStyle: cellStyle);
          excel.updateCell('합계', CellIndex.indexByString('I$listTotalIdx'), totalElement.menuName_1005, cellStyle: cellStyle);
          excel.updateCell('합계', CellIndex.indexByString('J$listTotalIdx'), totalElement.menuName_1006, cellStyle: cellStyle);
          excel.updateCell('합계', CellIndex.indexByString('K$listTotalIdx'), totalElement.menuName_1007, cellStyle: cellStyle);
          excel.updateCell('합계', CellIndex.indexByString('L$listTotalIdx'), totalElement.menuName_1008, cellStyle: cellStyle);
          excel.updateCell('합계', CellIndex.indexByString('M$listTotalIdx'), totalElement.menuName_1024, cellStyle: cellStyle);
          excel.updateCell('합계', CellIndex.indexByString('N$listTotalIdx'), totalElement.menuName_1025, cellStyle: cellStyle);
          excel.updateCell('합계', CellIndex.indexByString('O$listTotalIdx'), totalElement.menuName_1026, cellStyle: cellStyle);
          excel.updateCell('합계', CellIndex.indexByString('P$listTotalIdx'), totalElement.menuName_1000, cellStyle: cellStyle);
          excel.updateCell('합계', CellIndex.indexByString('Q$listTotalIdx'), totalElement.menuName_1027, cellStyle: cellStyle);
          excel.updateCell('합계', CellIndex.indexByString('R$listTotalIdx'), totalElement.menuName_1028, cellStyle: cellStyle);
          excel.updateCell('합계', CellIndex.indexByString('S$listTotalIdx'), totalElement.menuName_1029, cellStyle: cellStyle);
          excel.updateCell('합계', CellIndex.indexByString('T$listTotalIdx'), totalElement.menuName_1030, cellStyle: cellStyle);
          excel.updateCell('합계', CellIndex.indexByString('U$listTotalIdx'), totalElement.menuName_1031, cellStyle: cellStyle);

          listTotalIdx++;
        });

        gunguName.forEach((gungu_element) {
          int listIdx = 2;
          exportDataList.forEach((listElement) {
            if (gungu_element == listElement.p_gungu) {
              excel.updateCell(listElement.p_gungu.toString(), CellIndex.indexByString('A$listIdx'), (listElement.gungu == 'null' || listElement.gungu == null) ? '합계' : listElement.gungu.toString(),
                  cellStyle: cellStyle);
              excel.updateCell(listElement.p_gungu.toString(), CellIndex.indexByString('B$listIdx'), listElement.total, cellStyle: cellStyle);
              excel.updateCell(listElement.p_gungu.toString(), CellIndex.indexByString('C$listIdx'), listElement.menuName_1013, cellStyle: cellStyle);
              excel.updateCell(listElement.p_gungu.toString(), CellIndex.indexByString('D$listIdx'), listElement.menuName_1014, cellStyle: cellStyle);
              excel.updateCell(listElement.p_gungu.toString(), CellIndex.indexByString('E$listIdx'), listElement.menuName_9000, cellStyle: cellStyle);
              excel.updateCell(listElement.p_gungu.toString(), CellIndex.indexByString('F$listIdx'), listElement.menuName_1001, cellStyle: cellStyle);
              excel.updateCell(listElement.p_gungu.toString(), CellIndex.indexByString('G$listIdx'), listElement.menuName_1003, cellStyle: cellStyle);
              excel.updateCell(listElement.p_gungu.toString(), CellIndex.indexByString('H$listIdx'), listElement.menuName_1004, cellStyle: cellStyle);
              excel.updateCell(listElement.p_gungu.toString(), CellIndex.indexByString('I$listIdx'), listElement.menuName_1005, cellStyle: cellStyle);
              excel.updateCell(listElement.p_gungu.toString(), CellIndex.indexByString('J$listIdx'), listElement.menuName_1006, cellStyle: cellStyle);
              excel.updateCell(listElement.p_gungu.toString(), CellIndex.indexByString('K$listIdx'), listElement.menuName_1007, cellStyle: cellStyle);
              excel.updateCell(listElement.p_gungu.toString(), CellIndex.indexByString('L$listIdx'), listElement.menuName_1008, cellStyle: cellStyle);
              excel.updateCell(listElement.p_gungu.toString(), CellIndex.indexByString('M$listIdx'), listElement.menuName_1024, cellStyle: cellStyle);
              excel.updateCell(listElement.p_gungu.toString(), CellIndex.indexByString('N$listIdx'), listElement.menuName_1025, cellStyle: cellStyle);
              excel.updateCell(listElement.p_gungu.toString(), CellIndex.indexByString('O$listIdx'), listElement.menuName_1026, cellStyle: cellStyle);
              excel.updateCell(listElement.p_gungu.toString(), CellIndex.indexByString('P$listIdx'), listElement.menuName_1000, cellStyle: cellStyle);
              excel.updateCell(listElement.p_gungu.toString(), CellIndex.indexByString('Q$listIdx'), listElement.menuName_1027, cellStyle: cellStyle);
              excel.updateCell(listElement.p_gungu.toString(), CellIndex.indexByString('R$listIdx'), listElement.menuName_1028, cellStyle: cellStyle);
              excel.updateCell(listElement.p_gungu.toString(), CellIndex.indexByString('S$listIdx'), listElement.menuName_1029, cellStyle: cellStyle);
              excel.updateCell(listElement.p_gungu.toString(), CellIndex.indexByString('T$listIdx'), listElement.menuName_1030, cellStyle: cellStyle);
              excel.updateCell(listElement.p_gungu.toString(), CellIndex.indexByString('U$listIdx'), listElement.menuName_1031, cellStyle: cellStyle);

              listIdx++;
            }
          });
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
