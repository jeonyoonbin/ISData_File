
import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_input.dart';
import 'package:daeguro_admin_app/Model/coupon/couponBrandCodeList.dart';
import 'package:daeguro_admin_app/Model/coupon/couponBrandListModel.dart';
import 'package:daeguro_admin_app/Model/coupon/couponTypeList.dart';
import 'package:daeguro_admin_app/Model/taxi/regi/taxiRegiListModel.dart';
import 'package:daeguro_admin_app/Model/voucher/VoucherTypeList.dart';
import 'package:daeguro_admin_app/Model/voucherListModel.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/View/CouponManager/BrandcouponChange.dart';
import 'package:daeguro_admin_app/View/CouponManager/BrandcouponEdit.dart';
import 'package:daeguro_admin_app/View/CouponManager/BrandcouponRegist.dart';
import 'package:daeguro_admin_app/View/CouponManager/coupon_controller.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/OrderManager/orderDetail.dart';
import 'package:daeguro_admin_app/View/OrderManager/orderManager_controller.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccountList.dart';
import 'package:daeguro_admin_app/View/TaxiManager/taxiRegiEdit.dart';
import 'package:daeguro_admin_app/View/TaxiManager/taxiRegiHistory.dart';
import 'package:daeguro_admin_app/View/TaxiManager/taxiRegiRegist.dart';
import 'package:daeguro_admin_app/View/VoucherManager/voucherHistory.dart';
import 'package:daeguro_admin_app/View/VoucherManager/voucherRegist.dart';
import 'package:daeguro_admin_app/View/VoucherManager/voucher_controller.dart';
import 'package:daeguro_admin_app/constants/constant.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class TempModel {
  // TempModel({String RNUM, String regNo, String bussAddr, String shopName, String bussTaxType, String bussOwner, String bussType, String shopCd});

  bool selected = false;
  String RNUM = '1';
  String shopName ='상호01'; //매장명
  String shopCd = 'shop01';
  String bussType = '법인'; //사업자유형
  String bussTaxType = '과세'; //사업자유형
  String bussOwner = '김대구';  //대표자명
  String bussAddr = '대구광역시 서구 북비산로 369'; // 주소
  String regNo = '000-555-5555' ;  // 사업자등록번호
}
class TaxiRegiList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TaxiRegiListState();
  }
}

class TaxiRegiListState extends State {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List codeItems = List();
  final List<TempModel> dataList = <TempModel>[];
  // final List<TaxiRegiListModel> dataList = <TaxiRegiListModel>[];

  String _selectValue = '1';
  String _keyword;
  int _totalRowCnt = 0;
  int _selectedpagerows = 15;

  int _currentPage = 1;
  int _totalPages = 0;


  void _pageMove(int _page) {
    _query();
  }

  _reset() {
    formKey.currentState.reset();

    // VoucherController.to.VoucherTypeItems.clear();
    //loadData();
  }

  _query() {
    formKey.currentState.save();

    // VoucherController.to.page.value = _currentPage;
    // VoucherController.to.rows.value = _selectedpagerows;

    loadData();
  }

  _regist() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: TaxiRegiRegist(),
      ),
    ).then((v) async {
      if (v == true) {
        loadData();
      }
    });
  }

  _change() async {
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) => Dialog(
    //     child: BrandCouponChange(),
    //   ),
    // ).then((v) async {
    //   if (v == null) {
    //     loadData();
    //   }
    //   else{
    //     print('value:${v.toString()}');
    //     ISAlert(context, '쿠폰 변경 실패 \n\n' + v.toString());
    //   }
    // });
  }

  _edit(String shopCd) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: TaxiRegiEdit(shopCd: shopCd),
      ),
    ).then((v) async {
      if (v != null) {
        loadData();
      }
    });
  }

  _history(String shopCd) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: TaxiRegiHistory(shopCd: shopCd),
      ),
    ).then((v) async {
      if (v != null) {
        loadData();
      }
    });
  }

  loadData() async {
    await ISProgressDialog(context).show(status: 'Loading...');
    dataList.clear();

    /*테스트용 임시 데이터*/

    TempModel tempModel = new TempModel();
    dataList.add(tempModel);
    _totalRowCnt = 1;
    _totalPages = 1;

    // await VoucherController.to.getData(_testYn,_voucherType,_voucherStatus,_keyword.trim()).then((value){
    //   if(value==null){
    //     ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    //   }else{
    //     value.forEach((e) {
    //       voucherListModel temp = voucherListModel.fromJson(e);
    //       dataList.add(temp);
    //     });
    //     _totalRowCnt = VoucherController.to.totalRowCnt;
    //     _totalPages = (_totalRowCnt / _selectedpagerows).ceil();
    //   }
    // });

    setState(() {
    });
    await ISProgressDialog(context).dismiss();
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((c) {
      _reset();
      _query();
    });
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
        ],
      ),
    );

    var buttonBar = Expanded(
      flex: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            children: [
              // Text('총: ${Utils.getCashComma(VoucherController.to.totalRowCnt.toString())}건', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
               Text('총: 1건', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
            // SizedBox(height: 8,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ISSearchDropdown(
                  label: '검색조건',
                  width: 140,
                  value: _selectValue,
                  onChange: (value) {
                    setState(() {
                      _selectValue = value;
                      _currentPage = 1;
                      // _query();
                    });
                  },
                  item: [
                    DropdownMenuItem(value: '1', child: Text('상호'),),
                    DropdownMenuItem(value: '2', child: Text('사업자등록번호'),),
                    DropdownMenuItem(value: '3', child: Text('대표자명'),),
                  ].cast<DropdownMenuItem<String>>(),
                ),
                SizedBox(height: 8,),
                ISSearchInput(
                  // label: '검색 내용',
                  width: 240,
                  value: _keyword,
                  // value: CouponController.to.keyword.value,
                  onChange: (v) {
                    _keyword = v;
                  },
                  onFieldSubmitted: (value) {
                    _currentPage = 1;
                    _query();
                  },
                ),
                ISSearchButton(
                    width: 120,
                    label: '조회',
                    iconData: Icons.search,
                    onPressed: () => {_currentPage = 1, _query()}),
                SizedBox(width: 8,),
                ISSearchButton(
                    width: 120,
                    label: '등록',
                    iconData: Icons.add,
                    onPressed: () => {_regist()}),
              ],
            ),
          ],)
        ],
      ),
    );

    return Container(
      //padding: EdgeInsets.only(left: 140, right: 140, bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          form,
          buttonBar,
          Divider(),
          ISDatatable(
            panelHeight: (MediaQuery.of(context).size.height-defaultContentsHeight)-48,
            listWidth: Responsive.getResponsiveWidth(context, 1000), // Responsive.isTablet(context) ? MediaQuery.of(context).size.width : contentListWidth,
            rows: dataList.map((item) {
              return DataRow(cells: [
                DataCell(Align(child: SelectableText(item.RNUM.toString() ?? '--', style: TextStyle(color: Colors.black), showCursor: true,), alignment: Alignment.center)),
                DataCell(Align(child: SelectableText(item.shopName. toString() ?? '--', style: TextStyle(color: Colors.black), showCursor: true,), alignment: Alignment.center)),
                DataCell(Align(child: SelectableText(item.regNo.toString() ?? '--', style: TextStyle(color: Colors.black), showCursor: true,), alignment: Alignment.center)),
                DataCell(Align(child: SelectableText(item.bussOwner.toString() ?? '--', style: TextStyle(color: Colors.black), showCursor: true,), alignment: Alignment.center)),
                DataCell(Align(child: SelectableText(item.bussTaxType.toString() ?? '--', style: TextStyle(color: Colors.black), showCursor: true,), alignment: Alignment.center)),
                DataCell(Align(child: SelectableText(item.bussType.toString() ?? '--', style: TextStyle(color: Colors.black), showCursor: true,), alignment: Alignment.center)),
                DataCell(Align(child: SelectableText(item.bussAddr.toString() ?? '--', style: TextStyle(color: Colors.black), showCursor: true,), alignment: Alignment.center)),
                DataCell(
                  Center(
                    child: InkWell(
                        onTap: () {
                          _edit(item.shopCd);
                        },
                        child: Icon(Icons.edit)
                    ),
                  ),
                ),
                DataCell(
                  Center(
                      child: Container(
                        //color: Colors.red,
                        child: IconButton(
                          //padding: EdgeInsets.only(top: 20),
                          onPressed: () {
                            _history(item.shopCd);
                          },
                          icon: Icon(Icons.history, color: Colors.blue, size: 20,),
                          tooltip: '변경 이력',
                        ),
                      )),
                ),
              ]);
            }).toList(),
            columns: <DataColumn>[
              DataColumn(label: Expanded(child: Text('번호', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('상호', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('사업자등록번호', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('대표자명', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('과세구분', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('사업자유형', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('주소', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('상세', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('변경이력', textAlign: TextAlign.center)),),
            ],
          ),
          Divider(),
          SizedBox(height: 0,),
          showPagerBar(),
        ],
      ),
    );
  }

  _detail({String orderNo}) async {
    //EasyLoading.show();
    await OrderController.to.getDetailData(orderNo.toString());
    //EasyLoading.dismiss();
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: OrderDetail(orderNo: orderNo),
      ),
    );
  }

  Container showPagerBar() {
    return Container(
      //padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Row(
              children: <Widget>[
                //Text('row1'),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                    onTap: () {
                      _currentPage = 1;

                      _pageMove(_currentPage);
                    },
                    child: Icon(Icons.first_page)),
                InkWell(
                    onTap: () {
                      if (_currentPage == 1) return;

                      _pageMove(_currentPage--);
                    },
                    child: Icon(Icons.chevron_left)),
                Container(
                  //width: 70,
                  child: Text(_currentPage.toInt().toString() + ' / ' + _totalPages.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ),
                InkWell(
                    onTap: () {
                      if (_currentPage >= _totalPages) return;

                      _pageMove(_currentPage++);
                    },
                    child: Icon(Icons.chevron_right)),
                InkWell(
                    onTap: () {
                      _currentPage = _totalPages;
                      _pageMove(_currentPage);
                    },
                    child: Icon(Icons.last_page))
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Responsive.isMobile(context) ? Container(height: 48) : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text('페이지당 행 수 : ', style: TextStyle( fontSize: 12, fontWeight: FontWeight.normal),),
                Container(
                  width: 70,
                  child: DropdownButton(
                      value: _selectedpagerows,
                      isExpanded: true,
                      style: TextStyle(fontSize: 12, color: Colors.black, fontFamily: 'NotoSansKR'),
                      items: Utils.getPageRowList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedpagerows = value;
                          _currentPage = 1;
                          _query();
                        });
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}