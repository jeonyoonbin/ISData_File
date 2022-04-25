
import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/Model/PayCancelModel.dart';
import 'package:daeguro_admin_app/Model/order/orderCompleteToCancelModel.dart';
import 'package:daeguro_admin_app/Model/order/orderStatusEditModel.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/AgentManager/agentAccount_Controller.dart';
import 'package:daeguro_admin_app/View/CustomerManager/customerList.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/OrderManager/orderDetail.dart';
import 'package:daeguro_admin_app/View/OrderManager/orderManager_controller.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccountList.dart';
import 'package:daeguro_admin_app/constants/constant.dart';

import 'package:date_format/date_format.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class OrderCompleteToCancelManager extends StatefulWidget {
  const OrderCompleteToCancelManager({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OrderCompleteToCancelManagerState();
  }
}

class OrderCompleteToCancelManagerState extends State<OrderCompleteToCancelManager> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  OrderStatusEditModel saveStatusData;
  PayCancelModel payCancelData;

  final List<OrderCompleteToCancelModel> dataList = <OrderCompleteToCancelModel>[];
  List MCodeListitems = List();

  bool chkCancelPass = false;

  //int rowsPerPage = 10;

  String _mCode = '2';
  var _selCancelCode = '';

  //OrderAccount formData = OrderAccount();

  int _totalRowCnt = 0;
  int _selectedpagerows = 15;

  int _currentPage = 1;
  int _totalPages = 0;

  bool isAutoUpdate = false;

  SearchItems _searchItems = new SearchItems();

  String appbarInfoStr = '';

  String cancel_cust = '';
  String cancel_shop = '';
  String cancel_delay = '';

  void _pageMove(int _page) {
    _query();
  }

  _reset() {
    //this.formData = OrderAccount();
    _searchItems = null;
    _searchItems = new SearchItems();

    _searchItems.startdate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);

    _searchItems.enddate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
  }

  _query() {
    OrderController.to.startdate.value = _searchItems.startdate.replaceAll('-', '');
    OrderController.to.enddate.value = _searchItems.enddate.replaceAll('-', '');

    OrderController.to.tel.value = _searchItems.tel;
    OrderController.to.name.value = _searchItems.name;
    OrderController.to.page.value = _currentPage.round().toString();
    OrderController.to.raw.value = _selectedpagerows.toString();

    loadData();
  }

  // _edit({OrderAccount editData}) async {
  //   await OrderController.to.getDetailData(editData.orderNo, context);
  //
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) => Dialog(
  //       child: OrderStatusEdit(
  //         sData: editData,
  //       ),
  //     ),
  //   ).then((v) async {
  //     if (v != null) {
  //       await Future.delayed(Duration(milliseconds: 500), () {
  //         loadData();
  //       });
  //     }
  //   });
  // }

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

  loadMCodeListData() async {
    //MCodeListitems.clear();
    //MCodeListitems = await AgentController.to.getDataMCodeItems();
    MCodeListitems = Utils.getMCodeList();
  }

  loadData() async {
    await ISProgressDialog(context).show(status: 'Loading...');

    await OrderController.to.getOrderCompleteToCancel(_mCode, OrderController.to.startdate.value, OrderController.to.enddate.value).then((value) {
      if (this.mounted) {
        if (value == null) {
          ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
        } else {
          setState(() {
            dataList.clear();

            value.forEach((e) {
              OrderCompleteToCancelModel temp = OrderCompleteToCancelModel.fromJson(e);
              if (temp.orderTime.contains('오전'))
                temp.orderTime = temp.orderTime.replaceAll(' 오전 ', '\n오전');
              else
                temp.orderTime = temp.orderTime.replaceAll(' 오후 ', '\n오후');

              String currentTodayTime = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
              if (temp.orderTime.contains(currentTodayTime) == true) temp.orderTime = temp.orderTime.replaceAll(currentTodayTime + '\n', '');

              temp.shopTelNo = Utils.getPhoneNumFormat(temp.shopTelNo.toString(), true);

              dataList.add(temp);
            });

            _totalRowCnt = OrderController.to.totalRowCnt;
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

    Get.put(OrderController());
    Get.put(AgentController());



    payCancelData = PayCancelModel();
    saveStatusData = OrderStatusEditModel();
    saveStatusData.cancelCode = '00';
    saveStatusData.modCode = GetStorage().read('logininfo')['uCode']; //formData.modeUcode;
    saveStatusData.modName = GetStorage().read('logininfo')['name']; //fo

    WidgetsBinding.instance.addPostFrameCallback((c) {
      _reset();
      loadMCodeListData();
      _query();
    });

    setState(() {
      _searchItems.startdate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', '01']);
      _searchItems.enddate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    });
  }

  @override
  void dispose() {
    dataList.clear();
    //MCodeListitems.clear();

    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
          //_getSearchBox(),
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
              Text('총: ${Utils.getCashComma(OrderController.to.totalRowCnt.toString())}건', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  ISSearchDropdown(
                    label: '회원사명',
                    value: _mCode,
                    onChange: (value) {
                      setState(() {
                        _currentPage = 1;
                        _mCode = value;
                        _query();
                      });
                    },
                    width: 240,
                    item: MCodeListitems.map((item) {
                      return new DropdownMenuItem<String>(
                          child: new Text(
                            item['mName'],
                            style: TextStyle(fontSize: 13, color: Colors.black),
                          ),
                          value: item['mCode']);
                    }).toList(),
                  ),
                  SizedBox(height: 8,),
                  Row(
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
                    ],
                  )
                ],
              ),
              SizedBox(width: 8),
              ISSearchButton(
                  label: '조회',
                  iconData: Icons.search,
                  onPressed: () => {
                    _currentPage = 1,
                    _query(),
                  }),
            ],
          ),
        ],
      ),
    );

    return Container(
      //padding: EdgeInsets.only(left: 50, right: 50, bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          form,
          buttonBar,
          Divider(),
          ISDatatable(
            panelHeight: (MediaQuery.of(context).size.height-defaultContentsHeight)-48,
            listWidth: Responsive.getResponsiveWidth(context, 640),
            rows: dataList.map((item) {
              return DataRow(cells: [
                DataCell(Center(child: SelectableText(item.orderNo.toString() ?? '--', style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center(child: SelectableText(item.orderTime.toString() ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true))),

                DataCell(Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                      decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.black45), borderRadius: BorderRadius.circular(5.0)),
                      child: SelectableText(' ' + _getPackOrderGbn(item.packOrderYn.toString()), style: TextStyle(color: Colors.black45), showCursor: true),
                    ))),

                //DataCell(Align(child: Text(item.shopName.toString() == null ? '--' : '['+ item.shopCd.toString() +'] '+item.shopName.toString(),  style: TextStyle(color: Colors.black)), alignment: Alignment.centerLeft)),
                DataCell(Align(
                    child: MaterialButton(
                      child: Text(item.shopName.toString() == null ? '--' : '[' + item.shopCd.toString() + '] ' + item.shopName.toString(), style: TextStyle(color: Colors.black, fontSize: 13),),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                      onPressed: () {
                        double poupWidth = 1040;
                        double poupHeight = 600;
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => Dialog(
                            child: SizedBox(
                              width: poupWidth,
                              height: poupHeight,
                              child: Scaffold(
                                appBar: AppBar(
                                  title: Text('가맹점 - [${item.shopCd}] ${item.shopName}'),
                                ),
                                body: ShopAccountList(shopName: item.shopName, popWidth: poupWidth, popHeight: poupHeight),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    //child: Text(Utils.getPhoneNumFormat(item.shopTelNo.toString()) ?? '--', style: TextStyle(color: Colors.black)),
                    alignment: Alignment.centerLeft)),
                DataCell(Align(
                    child: SelectableText(item.shopTelNo.toString() ?? '--', style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.center)),
                DataCell(Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(child:item.posInstalled.toString() == 'Y'
                        ? Icon(Icons.radio_button_unchecked, color: Colors.blue, size: 16)
                        : Icon(Icons.clear, color: Colors.grey.shade400, size: 16)),
                    Text('/'),
                    Center(child:item.posLogined.toString() == 'Y'
                        ? Icon(Icons.radio_button_unchecked, color: Colors.blue, size: 16)
                        : Icon(Icons.clear, color: Colors.grey.shade400, size: 16))
                  ],
                )
                ),
                // DataCell(Center(child: item.isPosInstalled.toString() == 'Y' ? IconButton(icon: Icon(Icons.radio_button_unchecked, color: Colors.blue)) : IconButton(icon: Icon(Icons.clear, color: Colors.grey.shade400)))),
                // DataCell(Center(child: item.isPosLogined.toString() == 'Y' ? IconButton(icon: Icon(Icons.radio_button_unchecked, color: Colors.blue)) : IconButton(icon: Icon(Icons.clear, color: Colors.grey.shade400)))),
                //DataCell(Align(child: Text(Utils.getStoreRegNumberFormat(item.regNo.toString()) ?? '--', style: TextStyle(color: Colors.black)), alignment: Alignment.centerLeft)),
                DataCell(Center(child: SelectableText(_getPayGbn(item.payGbn.toString()), style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Align(
                    child: SelectableText(Utils.getCashComma(item.orderAmount.toString()) ?? '--', style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.centerLeft)),
                DataCell(Align(child: SelectableText(item.cancelType.toString() ?? '--', style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.centerLeft)),
                DataCell(Center(
                  child: MaterialButton(
                    //color: Colors.lightBlue,
                    minWidth: 40,
                    child: Text(Utils.getPhoneNumFormat(item.customerTelNo, true).toString() ?? '--', style: TextStyle(color: Colors.black, fontSize: 13)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                    onPressed: () {
                      double poupWidth = 700;
                      double poupHeight = 600;

                      showDialog(
                        context: context,
                        builder: (BuildContext context) => Dialog(
                          child: SizedBox(
                            width: poupWidth,
                            height: poupHeight,
                            child: Scaffold(
                              appBar: AppBar(
                                title: Text('회원 정보'),
                              ),
                              body: CustomerList(custCode: item.custCode, popWidth: poupWidth, popHeight: poupHeight),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )),
                DataCell(Center(
                    child: item.directPay.toString() == 'Y' ? Icon(Icons.radio_button_unchecked, color: Colors.blue, size: 16) : Icon(Icons.clear, color: Colors.red, size: 16))),
                DataCell(
                  Center(
                    child: InkWell(
                        onTap: () {
                          _detail(orderNo: item.orderNo);
                        },
                        child: Icon(Icons.receipt_long)
                    ),
                  ),
                ),
              ]);
            }).toList(),
            columns: <DataColumn>[
              DataColumn(label: Expanded(child: Text('주문번호', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('주문일자', textAlign: TextAlign.center)),),              
              DataColumn(label: Expanded(child: Text('구분', textAlign: TextAlign.center)),),

              DataColumn(label: Expanded(child: Text('상점명', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('상점전화', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('POS상태\n(설치/로그인)', textAlign: TextAlign.center, style: TextStyle(fontSize: 10), ))),
              DataColumn(label: Expanded(child: Text('결제수단', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('결제금액', textAlign: TextAlign.left)),),
              DataColumn(label: Expanded(child: Text('취소사유', textAlign: TextAlign.left)),),
              DataColumn(label: Expanded(child: Text('회원전화', textAlign: TextAlign.center)),),
              //DataColumn(label: Expanded(child: Text('카드승인정보', textAlign: TextAlign.left)),),
              //DataColumn(label: Expanded(child: Text('승인금액', textAlign: TextAlign.left)),),
              DataColumn(label: Expanded(child: Text('할인', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('상세', textAlign: TextAlign.center)),),
            ],
          ),
          Divider(),
          SizedBox(
            height: 0,
          ),
          showPagerBar(),
        ],
      ),
    );
  }

  Container showPagerBar() {
    return Container(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Row(
                  children: <Widget>[
                    //Text('row1'),
                  ],
                ),
              ),
              Expanded(
                flex: 6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                        onPressed: () {
                          _currentPage = 1;

                          _pageMove(_currentPage);
                        },
                        icon: Icon(Icons.first_page)),
                    IconButton(
                        onPressed: () {
                          if (_currentPage == 1) return;

                          _pageMove(_currentPage--);
                        },
                        icon: Icon(Icons.chevron_left)),
                    Container(
                      width: 70,
                      child: Text(
                          _currentPage.toInt().toString() +
                              ' / ' +
                              _totalPages.toString(),
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center),
                    ),
                    IconButton(
                        onPressed: () {
                          if (_currentPage >= _totalPages) return;

                          _pageMove(_currentPage++);
                        },
                        icon: Icon(Icons.chevron_right)),
                    IconButton(
                        onPressed: () {
                          _currentPage = _totalPages;
                          _pageMove(_currentPage);
                        },
                        icon: Icon(Icons.last_page))
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '페이지당 행 수 : ',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                    Container(
                      width: 70,
                      child: DropdownButton(
                          value: _selectedpagerows,
                          isExpanded: true,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontFamily: 'NotoSansKR'),
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
          )
        ],
      ),
    );
  }

  // bool isPoupEnabled() {
  //   return (widget.custCode == null && widget.shopCd == null);
  // }

  String _getStatus(String value) {
    String retValue = '--';

    if (value.toString().compareTo('10') == 0)
      retValue = '접수';
    else if (value.toString().compareTo('20') == 0)
      retValue = '대기';
    else if (value.toString().compareTo('30') == 0)
      retValue = '가맹점 접수확인';
    else if (value.toString().compareTo('35') == 0)
      retValue = '운행';
    else if (value.toString().compareTo('40') == 0)
      retValue = '완료';
    else if (value.toString().compareTo('50') == 0)
      retValue = '취소';
    else if (value.toString().compareTo('80') == 0)
      retValue = '결제대기';
    else
      retValue = '--';

    return retValue;
  }

  String _getPackOrderGbn(String value) {
    String retValue = '--';

    if (value.toString().compareTo('Y') == 0)
      retValue = '포장';
    else if (value.toString().compareTo('N') == 0)
      retValue = '배달';
    else
      retValue = '--';

    return retValue;
  }

  String _getPayGbn(String value) {
    String retValue = '--';

    if (value.toString().compareTo('1') == 0)
      retValue = '현금';
    else if (value.toString().compareTo('2') == 0)
      retValue = '카드';
    else if (value.toString().compareTo('3') == 0)
      retValue = '외상';
    else if (value.toString().compareTo('4') == 0)
      retValue = '쿠폰(가맹점 자체)';
    else if (value.toString().compareTo('5') == 0)
      retValue = '마일리지';
    else if (value.toString().compareTo('7') == 0)
      retValue = '행복페이';
    else if (value.toString().compareTo('8') == 0)
      retValue = '제로페이';
    else if (value.toString().compareTo('9') == 0)
      retValue = '선결제';
    else if (value.toString().compareTo('P') == 0)
      retValue = '휴대폰';
    else if (value.toString().compareTo('B') == 0)
      retValue = '계좌이체';
    else
      retValue = '--';

    return retValue;
  }
}
