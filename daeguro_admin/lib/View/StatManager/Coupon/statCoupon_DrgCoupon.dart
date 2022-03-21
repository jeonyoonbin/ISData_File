import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_input.dart';
import 'package:daeguro_admin_app/Model/drgCouponModel.dart';
import 'package:daeguro_admin_app/Model/drgCouponStaticModel.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/View/StatManager/stat_controller.dart';
import 'package:daeguro_admin_app/Util/utils.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class StatCoupon_DrgCoupon extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StatCoupon_DrgCouponState();
  }
}

class StatCoupon_DrgCouponState extends State with AutomaticKeepAliveClientMixin {
  List<DrgCouponModel> dataList = <DrgCouponModel>[];

  SearchItems _searchItems = new SearchItems();

  List<String> monthGbn = [];

  _reset() {
    _searchItems = null;
    _searchItems = new SearchItems();
  }

  _query() {
    loadData();
  }

  loadData() async {
    await ISProgressDialog(context).show(status: 'Loading...');

    var result = await StatController.to.getDrgCouponData(_searchItems.name);

    result.forEach((element) {
      monthGbn.assign(element['MON']);
    });

    if (this.mounted) {
      setState(() {
        dataList.clear();

        result.forEach((element) {
          dataList.add(new DrgCouponModel(
              isChild: false,
              MON: element['MON'],
              DIS_USE_AMT: element['DIS_USE_AMT'],
              DIS_USE_CNT: element['DIS_USE_CNT'],
              EXP_AMT: element['EXP_AMT'],
              EXP_CNT: element['EXP_CNT'],
              INS_AMT: element['INS_AMT'],
              INS_CNT: element['INS_CNT'],
              USE_AMT: element['USE_AMT'],
              USE_CNT: element['USE_CNT']));
        });
      });
    }

    await ISProgressDialog(context).dismiss();
  }

  addDetailData(String mon) async {
    List<DrgCouponModel> tempDataList = [];
    await StatController.to.getDrgCouponDetailData(mon, _searchItems.name).then((List<dynamic> value) {
      tempDataList = List.from(getDetailData(mon, _searchItems.name, value));
    });

    setState(() {
      int selectindex = dataList.indexWhere((item) => item.MON == mon);
      tempDataList.forEach((element) {
        //print('-----');
        dataList.insert(selectindex + 1, element);
      });
    });
  }

  removeDetailData(String Mon) {
    setState(() {
      dataList.removeWhere((item) => (item.MON == Mon && item.isChild == true));
    });
  }

  List<DrgCouponModel> getDetailData(String mon, String couponName, List<dynamic> targetList) {
    List<DrgCouponModel> tempDataList = <DrgCouponModel>[];

    int index = 0;
    targetList.forEach((e) {
      DrgCouponStaticModel temp = DrgCouponStaticModel.fromJson(e);

      int compareIndex = tempDataList.indexWhere((item) => item.MON == mon);

      //print(compareIndex);

      tempDataList.add(DrgCouponModel(
          isChild: true,
          MON: temp.MON,
          COUPON_AMT: temp.COUPON_AMT,
          DIS_USE_AMT: temp.DIS_USE_AMT,
          DIS_USE_CNT: temp.DIS_USE_CNT,
          EXP_AMT: temp.EXP_AMT,
          EXP_CNT: temp.EXP_CNT,
          INS_AMT: temp.INS_AMT,
          INS_CNT: temp.INS_CNT,
          USE_AMT: temp.USE_AMT,
          USE_CNT: temp.USE_CNT));

      DrgCouponModel tempListModel = tempDataList.elementAt(index);

      if (temp.MON == null) tempListModel.MON = temp.MON;

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

    setState(() {});
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
          ISSearchInput(
            label: '쿠폰명',
            width: 250,
            value: _searchItems.name,
            onChange: (v) {
              _searchItems.name = v;
            },
            onFieldSubmitted: (value) {
              _query();
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
            child: dataList.length == 0
                ? Container()
                : ISDatatable(
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
      if (element.MON == null) {
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
              (element.MON == null || element.isChild == true)
                  ? Container()
                  : IconButton(
                      icon: Icon(element.isOpened == true ? Icons.remove_circle : Icons.add_circle, color: Colors.blue, size: 20),
                      onPressed: () {
                        if (element.isOpened == true) {
                          element.isOpened = false;
                          removeDetailData(element.MON);
                        } else {
                          element.isOpened = true;
                          addDetailData(element.MON);
                        }
                      },
                    ),
              Align(
                  child: Text(
                    element.MON.toString() == 'null'
                        ? '합계'
                        : element.isChild == false
                            ? Utils.getYearMonthFormat(element.MON.toString())
                            : Utils.getCashComma(element.COUPON_AMT.toString()) + ' 원',
                    style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
                  ),
                  alignment: element.isChild == true ? Alignment.centerRight : Alignment.center),
            ],
          ),
        )),
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.INS_CNT.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.INS_AMT.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.USE_CNT.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.USE_AMT.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.DIS_USE_CNT.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.DIS_USE_AMT.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.EXP_CNT.toString()),
              style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),
            ),
            alignment: Alignment.centerRight)),
        DataCell(Align(
            child: Text(
              Utils.getCashComma(element.EXP_AMT.toString()),
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
      label: Expanded(child: Text('발행 수', textAlign: TextAlign.right)),
    ));
    tempData.add(DataColumn(
      label: Expanded(child: Text('발행 금액', textAlign: TextAlign.right)),
    ));
    tempData.add(DataColumn(
      label: Expanded(child: Text('사용 수', textAlign: TextAlign.right)),
    ));
    tempData.add(DataColumn(
      label: Expanded(child: Text('사용 금액', textAlign: TextAlign.right)),
    ));
    tempData.add(DataColumn(
      label: Expanded(child: Text('폐기 수', textAlign: TextAlign.right)),
    ));
    tempData.add(DataColumn(
      label: Expanded(child: Text('폐기 금액', textAlign: TextAlign.right)),
    ));
    tempData.add(DataColumn(
      label: Expanded(child: Text('만료 수', textAlign: TextAlign.right)),
    ));
    tempData.add(DataColumn(
      label: Expanded(child: Text('만료 금액', textAlign: TextAlign.right)),
    ));

    return tempData;
  }

  Container showPagerBar() {
    return Container(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Container(height: 32,),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
