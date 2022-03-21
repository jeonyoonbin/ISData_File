import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Model/shop/shopsector_address.dart';
import 'package:daeguro_admin_app/Model/stat/statShopTotalOrderModel.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/View/StatManager/stat_controller.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class StatShopTotalOrderList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StatShopTotalOrderListState();
  }
}

class StatShopTotalOrderListState extends State with AutomaticKeepAliveClientMixin{
  List<StatShopTotalOrderModel> dataList = <StatShopTotalOrderModel>[];

  SearchItems _searchItems = new SearchItems();

  String gunGuName = '전체';

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

  loadGunguData() async {
    selectBox_Gungu.clear();

    await ShopController.to.getGunguData('대구광역시').then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        selectBox_Gungu.add(new SelectOptionVO(value: '전체', label: '전체'));
        value.forEach((e) async {
          ShopSectorAddressModel tempData = ShopSectorAddressModel.fromJson(e);

          selectBox_Gungu.add(new SelectOptionVO(value: tempData.gunGuName, label: tempData.gunGuName));
        });
      }
    });
  }

  loadData() async {
    await ISProgressDialog(context).show(status: 'Loading...');

    String searchStr = gunGuName;
    if (searchStr == '전체')
      searchStr = '';

    await StatController.to.getShopTotalOrderData(searchStr).then((value) {
      if (this.mounted) {
        setState(() {
          dataList.clear();

          value.forEach((element) {
            StatShopTotalOrderModel temp = StatShopTotalOrderModel.fromJson(element);
            dataList.add(temp);
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
      loadGunguData();
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
          ISSearchDropdown(
            label: '군/구',
            value: gunGuName,
            width: 110,
            item: selectBox_Gungu.map((item) {
              return new DropdownMenuItem<String>(
                  child: new Text(item.label, style: TextStyle(fontSize: 13, color: Colors.black),),
                  value: item.value);
            }).toList(),
            onChange: (v) {
              gunGuName = v;

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
              // panelHeight: MediaQuery.of(context).size.height-280,
              listWidth: Responsive.getResponsiveWidth(context, 720),

              dataRowHeight: 30.0,
              rows: getDataRow(),
              columns: getDataColumn(),
            ),
          ),
          Divider(height: 16,),
          //SizedBox(height: 30,)
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
        DataCell(Align(child: Text(element.ORDER_DATE.toString().substring(0,4) + '-' + element.ORDER_DATE.toString().substring(4,6) +'-' + element.ORDER_DATE.toString().substring(6,8), style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),), alignment: Alignment.center)),
        DataCell(Align(child: Text(Utils.getCashComma(element.CNT.toString()), style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),), alignment: Alignment.centerRight)),
        DataCell(Align(child: Text(Utils.getCashComma(element.AMT.toString()), style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),), alignment: Alignment.centerRight)),
        DataCell(Align(child: Text(Utils.getCashComma(element.OK_CNT.toString()), style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),), alignment: Alignment.centerRight)),
        DataCell(Align(child: Text(Utils.getCashComma(element.OK_AMT.toString()), style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),), alignment: Alignment.centerRight)),
        DataCell(Align(child: Text(Utils.getCashComma(element.CANCEL_CNT.toString()), style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),), alignment: Alignment.centerRight)),
        DataCell(Align(child: Text(Utils.getCashComma(element.CANCEL_AMT.toString()), style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),), alignment: Alignment.centerRight)),
        DataCell(Align(child: Text(Utils.getCashComma(element.SHOP_CONFIRM.toString()), style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),), alignment: Alignment.centerRight)),
        DataCell(Align(child: Text('${element.COMP_PER.toString()}%', style: TextStyle(color: Colors.black, fontWeight: fontWeight, fontSize: fontSize),), alignment: Alignment.centerRight)),
      ]));
    });

    return tempData;
  }

  List<DataColumn> getDataColumn() {
    List<DataColumn> tempData = [];

    tempData.add(DataColumn(label: Expanded(child: Text('영업일', textAlign: TextAlign.center)),));
    tempData.add(DataColumn(label: Expanded(child: Text('총주문', textAlign: TextAlign.right)),));
    tempData.add(DataColumn(label: Expanded(child: Text('총주문 금액', textAlign: TextAlign.right)),));
    tempData.add(DataColumn(label: Expanded(child: Text('완료주문', textAlign: TextAlign.right)),));
    tempData.add(DataColumn(label: Expanded(child: Text('완료주문 금액', textAlign: TextAlign.right)),));
    tempData.add(DataColumn(label: Expanded(child: Text('취소주문', textAlign: TextAlign.right)),));
    tempData.add(DataColumn(label: Expanded(child: Text('취소주문 금액', textAlign: TextAlign.right)),));
    tempData.add(DataColumn(label: Expanded(child: Text('가맹점확인', textAlign: TextAlign.right)),));
    tempData.add(DataColumn(label: Expanded(child: Text('완료율', textAlign: TextAlign.right)),));


    return tempData;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
