

import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_input.dart';
import 'package:daeguro_admin_app/Model/customer/customerListModel.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/View/CustomerManager/customerCoupon.dart';
import 'package:daeguro_admin_app/View/CustomerManager/customerInfo.dart';
import 'package:daeguro_admin_app/View/CustomerManager/customerMileage.dart';
import 'package:daeguro_admin_app/View/CustomerManager/customer_controller.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/OrderManager/orderList.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/constants/constant.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class CustomerList extends StatefulWidget {
  // final String custTelno;
  // final String custName;
  final String custCode;
  final double popWidth;
  final double popHeight;

  const CustomerList({Key key, this.custCode, this.popWidth, this.popHeight})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CustomerListState();
  }
}

class CustomerListState extends State<CustomerList> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  SearchItems _searchItems = new SearchItems();

  List<CustomerListModel> dataList = <CustomerListModel>[];
  String _divKey = '0';

  //int rowsPerPage = 10;

  int _totalRowCnt = 0;
  int _selectedpagerows = 15;

  int _currentPage = 1;
  int _totalPages = 0;

  void _pageMove(int _page) {
    _query();
  }

  _reset() {
    _searchItems = null;
    _searchItems = new SearchItems();

    if (isMainShowEnabled() == true)
      _searchItems.name = '';
    else {

      //_searchItems.name = widget.custCode;
      // if (widget.custTelno != null) {
      //   _searchItems.name = widget.custTelno;
      // }
    }

    _searchItems.startdate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', '01']);
    _searchItems.enddate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    //loadData();
  }

  _info(String custCode) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: CustomerInfo(custCode: custCode),
      ),
    ).then((v) async {
      if (v != null){
        loadData();
      }
    });
  }

  _order(String custCode, String custName) async {
    double poupWidth = 1200;
    double poupHeight = 600;

    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: SizedBox(
          width: poupWidth,
          height: poupHeight,
          child: Scaffold(
            appBar: AppBar(
              title: Text('회원 주문 내역   [회원명: ${custName}]'),
            ),
            body: OrderList(custCode: custCode, custName: custName, gbn: 'N', popWidth: poupWidth, popHeight: poupHeight,),
          ),
        ),
      ),
    ).then((v) async {
    });
  }

  _mileage(String custCode, String custName) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: CustomerMileage(custCode: custCode, custName: custName,),
      ),
    ).then((v) async {
    });
  }

  _coupon(String custCode, String custName) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: CustomerCoupon(custCode: custCode, custName: custName,),
      ),
    ).then((v) async {
    });
  }

  _query() {
    CustomerController.to.divKey.value = _divKey;
    CustomerController.to.name.value = _searchItems.name;

    if (isMainShowEnabled() == false)
      CustomerController.to.custCode.value = widget.custCode;

    CustomerController.to.page.value = _currentPage;
    CustomerController.to.raw.value = _selectedpagerows;
    loadData();
  }

  loadData() async {
    await ISProgressDialog(context).show(status: 'Loading...');

    dataList.clear();

    await CustomerController.to.getData().then((value) {
      if (this.mounted) {
        if (value == null) {
          ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
        }
        else{
          setState(() {
            dataList.clear();
            value.forEach((e) {
              CustomerListModel tempData = CustomerListModel.fromJson(e);
              if (tempData.INSERT_DATE != null)
                tempData.INSERT_DATE = tempData.INSERT_DATE.replaceAll('T', '  ');

              if (tempData.DEL_DATE != null)
                tempData.DEL_DATE = tempData.DEL_DATE.replaceAll('T', '  ');

              if(tempData.ORDER_COUNT == null)
                tempData.ORDER_COUNT = 0;

              if(tempData.ORDER_AMT == null)
                tempData.ORDER_AMT = 0;

              if(tempData.MILEAGE_AMT == null)
                tempData.MILEAGE_AMT = 0;

              tempData.CUST_NAME = Utils.getNameFormat(tempData.CUST_NAME.toString(), true);
              tempData.TELNO = Utils.getPhoneNumFormat(tempData.TELNO.toString(), true);

              dataList.add(tempData);
            });

            _totalRowCnt = CustomerController.to.totalRowCnt;
            _totalPages = (_totalRowCnt / _selectedpagerows).ceil();
          });
        }
      }
    });

    await ISProgressDialog(context).dismiss();
  }

  @override
  void initState() {
    super.initState();

    Get.put(CustomerController());

    CustomerController.to.name.value = '';
    CustomerController.to.custCode.value = '';
    CustomerController.to.divKey.value = '';

    WidgetsBinding.instance.addPostFrameCallback((c) {
      //print('---- init run');
      _reset();
      _query();
    });

    setState(() {
      _searchItems.startdate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', '01']);
      _searchItems.enddate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    });
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
          //testSearchBox(),
        ],
      ),
    );

    var buttonBar = Expanded(
      flex: 0,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            // Row(
            //   children: <Widget>[
            //     Text('총회원수: ${Utils.getCashComma(CustomerController.to.Maincustomer)}', style: TextStyle(color: Colors.black),),
            //     SizedBox(width: 16),
            //     Text('마일리지총액: ${Utils.getCashComma(CustomerController.to.Mainmileage)}', style: TextStyle(color: Colors.black),),
            //     SizedBox(width: 16),
            //     Text('쿠폰발행총액: ${Utils.getCashComma(CustomerController.to.Maincoupon)}', style: TextStyle(color: Colors.black),),
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ISSearchDropdown(
                  label: '상태',
                  width: 150,
                  value: _divKey,
                  onChange: (value) {
                    setState(() {
                      _divKey = value;
                      _currentPage = 1;

                      _query();
                    });
                  },
                  item: [
                    DropdownMenuItem(value: '0', child: Text('전체'),),
                    DropdownMenuItem(value: '1', child: Text('사용중'),),
                    DropdownMenuItem(value: '2', child: Text('탈퇴'),),
                  ].cast<DropdownMenuItem<String>>(),
                ),
                ISSearchInput(
                  label: '회원명, 전화번호, 메모',
                  width: 250,
                  value: _searchItems.name,
                  onChange: (v) {
                    _searchItems.name = v;
                  },
                  onFieldSubmitted: (value) {
                    _currentPage = 1;
                    _query();
                  },
                ),
                SizedBox(height: 8,),
                ISSearchButton(
                    label: '조회',
                    iconData: Icons.search,
                    onPressed: () => {_currentPage = 1, _query()}),
              ],
            ),
          ],
        ),
      ),
    );

    var bar2 = Expanded(
        flex: 0,
        child: Container(
          // padding: EdgeInsets.only(bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('회원 총계 ', style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.bold)),
                  SizedBox(width: 10),
                  Text('총회원수 ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  Text(Utils.getCashComma('${CustomerController.to.Maincustomer}'), style: TextStyle(color: Colors.black)),
                  SizedBox(width: 10),
                  Text('마일리지총액 ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  Text(Utils.getCashComma('${CustomerController.to.Mainmileage}'), style: TextStyle(color: Colors.black)),
                  SizedBox(width: 10),
                  Text('쿠폰발행총액 ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  Text(Utils.getCashComma('${CustomerController.to.Maincoupon}'), style: TextStyle(color: Colors.black)),
                ],
              ),
            ],
          ),
        ));

    return Container(
      padding: (isMainShowEnabled() == true) ? null : EdgeInsets.only(left: 10, right: 10, bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          form,
          (isMainShowEnabled() == true) ? buttonBar : Container(),
          Divider(),
          bar2,
          Divider(),
          ISDatatable(
            panelHeight: (isMainShowEnabled() == true) ? (MediaQuery.of(context).size.height-defaultContentsHeight)-54 : widget.popHeight-140,
            listWidth: (isMainShowEnabled() == true) ? Responsive.getResponsiveWidth(context, 720) : widget.popWidth-20,
            rows: dataList.map((item) {
              return DataRow(cells: [
                DataCell(Center(child: SelectableText(item.CUST_CODE.toString() ?? '--', style: TextStyle(color: Colors.black), showCursor: true,))),
                DataCell(Center(child: SelectableText(item.CUST_NAME.toString() ?? '--', style: TextStyle(color: Colors.black),showCursor: true,))),
                DataCell(Center(child: SelectableText(item.TELNO.toString() ?? '--', style: TextStyle(color: Colors.black),showCursor: true,))),
                DataCell(Center(child: (isMainShowEnabled() == true)
                    ? MaterialButton(
                  height: 30.0,
                  color: (item.ORDER_COUNT.toString() == '0' &&  item.ORDER_AMT.toString() == '0') ?  Colors.grey.shade300 : Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  child: Text('${Utils.getCashComma(item.ORDER_COUNT.toString())}건 / ${Utils.getCashComma(item.ORDER_AMT.toString())}원',
                      style: TextStyle(fontSize: 13, color: Colors.white,)),
                  onPressed: () => _order(item.CUST_CODE.toString(), item.CUST_NAME),
                ) : SelectableText('${Utils.getCashComma(item.ORDER_COUNT.toString())}건 / ${Utils.getCashComma(item.ORDER_AMT.toString())}원',
                    style: TextStyle(fontSize: 13, color: Colors.black,), showCursor: true)),
                ),
                DataCell(Center(child: MaterialButton(
                  height: 30.0,
                  color: (item.MILEAGE_AMT.toString() == '0') ?  Colors.grey.shade300 : Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  child: Text('총액: ${Utils.getCashComma(item.MILEAGE_AMT.toString())}', style: TextStyle(fontSize: 13, color: Colors.white)),
                  onPressed: () => _mileage(item.CUST_CODE.toString(), item.CUST_NAME),
                )),
                ),
                DataCell(Center(
                    child: InkWell(
                      child: Icon(Icons.money, color: Colors.blue, size: 22),
                      onTap: () {
                        _coupon(item.CUST_CODE.toString(), item.CUST_NAME);
                      })
                    )
                ),
                DataCell(Center(
                    child: (item.MEMO.toString() == '' || item.MEMO == null)
                        ? IconButton(icon: Icon(Icons.clear, color: Colors.grey.shade400, size: 21))
                        : Tooltip(
                      child: IconButton(
                        icon: Icon(Icons.radio_button_unchecked, color: Colors.blue, size: 21),
                      ),
                      message: item.MEMO,
                      textStyle: TextStyle(fontSize: 12, color: Colors.white),
                      padding: EdgeInsets.all(5),
                    ))
                ),
                DataCell(Center(
                    child: InkWell(
                      child: (item.CUST_ID_GBN == 'Z' || item.CUST_ID_GBN == null || item.CUST_ID_GBN == 'null' || item.CUST_ID_GBN == '')
                          ? Icon(Icons.perm_device_info, color: Colors.blue, size: 21,)
                          : Image.asset(getIconURL(item.CUST_ID_GBN), width: 21, height: 21,),
                      onTap: () {
                        _info(item.CUST_CODE.toString());
                      },
                    ),
                  ),
                ),

                if (isMainShowEnabled() == true)
                  DataCell(Center(child: SelectableText(item.INSERT_DATE.toString() == 'null' ? '--' : item.INSERT_DATE.toString(), style: TextStyle(color: Colors.black), showCursor: true))),
                if (isMainShowEnabled() == true)
                  DataCell(Center(child: SelectableText(item.DEL_DATE.toString() == 'null' ? '--' : item.DEL_DATE.toString(), style: TextStyle(color: Colors.black), showCursor: true))),
              ]);
            }).toList(),
            columns: <DataColumn>[
              DataColumn(label: Expanded(child: Text('회원번호', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('회원명', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('연락처', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('주문완료(건수/총액)', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('마일리지', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('쿠폰내역', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('메모', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('가입내역', textAlign: TextAlign.center)),),
              if (isMainShowEnabled() == true)
                DataColumn(label: Expanded(child: Text('가입일', textAlign: TextAlign.center)),),
              if (isMainShowEnabled() == true)
                DataColumn(label: Expanded(child: Text('탈퇴일', textAlign: TextAlign.center)),),
            ],
          ),
          Divider(),
          (isMainShowEnabled() == true) ? showPagerBar() : Container(),
        ],
      ),
    );
  }

  bool isMainShowEnabled(){
    return (widget.custCode == null/* && widget.custName == null*/);
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
                Text('페이지당 행 수 : ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),),
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

  String getIconURL(String cust_id_gbn){
    String retImageURL;

    if (cust_id_gbn == 'A')            retImageURL = 'assets/daeguro_icon_32.png';
    else if (cust_id_gbn == 'G')       retImageURL = 'assets/google_icon_32.png';
    else if (cust_id_gbn == 'K')       retImageURL = 'assets/kakao_icon_32.png';
    else  if (cust_id_gbn == 'N')      retImageURL = 'assets/naver_icon_32.png';
    else    if (cust_id_gbn == 'I')    retImageURL = 'assets/apple_icon_32.png';
    //else      if (cust_id_gbn = 'Z')

    return retImageURL;
  }
}
