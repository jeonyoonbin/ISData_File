import 'dart:async';

import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_input.dart';
import 'package:daeguro_admin_app/Model/PayCancelModel.dart';
import 'package:daeguro_admin_app/Model/order/order.dart';
import 'package:daeguro_admin_app/Model/order/orderStatusEditModel.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/View/AgentManager/agentAccount_Controller.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/OrderManager/orderDetail.dart';
import 'package:daeguro_admin_app/View/OrderManager/orderManager_controller.dart';
import 'package:daeguro_admin_app/Util/utils.dart';


import 'package:date_format/date_format.dart';
import 'package:date_time_picker/date_time_picker.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class HistoryShopCancelDetail extends StatefulWidget {
  final String shopCd;
  final String shopName;
  final String startDate;
  final String endDate;

  final double popWidth;
  final double popHeight;

  // 날짜 다를 시 키워드 검색 필수 여부
  final String gbn;

  const HistoryShopCancelDetail({Key key, this.shopCd, this.shopName, this.startDate, this.endDate, this.gbn, this.popWidth, this.popHeight})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HistoryShopCancelDetailState();
  }
}

class HistoryShopCancelDetailState extends State<HistoryShopCancelDetail> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  OrderStatusEditModel saveStatusData;
  PayCancelModel payCancelData;

  final List<OrderAccount> dataList = <OrderAccount>[];
  List MCodeListitems = List();

  bool chkCancelPass = false;

  String _State = ' ';
  String _divKey = '1';
  String _keyWordLabel = '주문번호';
  //int rowsPerPage = 10;

  String _mCode = '2';
  var _selCancelCode = '';

  //OrderAccount formData = OrderAccount();

  int _totalRowCnt = 0;
  int _selectedpagerows = 15;

  int _currentPage = 1;
  int _totalPages = 0;

  Timer _timer;
  bool isAutoUpdate = false;
  int autoCnt = 3;

  SearchItems _searchItems = new SearchItems();

  String appbarInfoStr = '';

  String cancel_cust = '';
  String cancel_shop = '';
  String cancel_delay = '';

  int cancelViewMargin = 48;

  void _pageMove(int _page) {
    _query();
  }

  _reset() {
    //this.formData = OrderAccount();
    _searchItems = null;
    _searchItems = new SearchItems();

    _searchItems.startdate = formatDate(DateTime.now(), ['1900', '-', mm, '-', '01']);
    _searchItems.enddate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);

    //formKey.currentState.reset();
    //loadData();
  }

  _query() {
    //formKey.currentState.save();
    if (_searchItems.startdate != _searchItems.enddate && _searchItems.name == '' && widget.gbn != 'N') {
      ISAlert(context, '시작일, 종료일이 다를 경우\n검색 키워드를 입력 해야 합니다.');
      return;
    }

    OrderController.to.startdate.value = widget.startDate;
    OrderController.to.enddate.value = widget.endDate;
    _State = '50';

    appbarInfoStr = '주문취소 내역 [가맹점명: ${widget.shopName}]';

    _cancelRessons();

    OrderController.to.state.value = _State;
    OrderController.to.divKey.value = _divKey;
    OrderController.to.tel.value = _searchItems.tel;
    OrderController.to.name.value = _searchItems.name;
    OrderController.to.page.value = _currentPage.round().toString();
    OrderController.to.raw.value = _selectedpagerows.toString();

    loadData();
  }

  _detail({String orderNo}) async {
    //EasyLoading.show();
    await OrderController.to.getDetailData(orderNo.toString(), context);
    //EasyLoading.dismiss();

    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: OrderDetail(orderNo: orderNo),
      ),
    );

    // Navigator.push<void>(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => OrderDetail(
    //       shopName: shopName, orderNo: orderNo,
    //     ),
    //     fullscreenDialog: true,
    //   ),c
    // );//.then((value) => this._loadData());
  }

  _cancelRessons() async {
    await OrderController.to.getOrderCancelReasonsData(widget.shopCd, widget.startDate, widget.endDate).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        cancel_cust = ''+ value['CUST_CANCEL'].toString();
        cancel_shop = ''+ value['SHOP_CANCEL'].toString();
        cancel_delay = ''+ value['DELAY_CANCEL'].toString();

        //print('cancel_cust:${cancel_cust}, cancel_shop:${cancel_shop}, cancel_delay:${cancel_delay}');
      }
    });

    setState(() {});
  }

  loadMCodeListData() async {
    //MCodeListitems.clear();
    //MCodeListitems = await AgentController.to.getDataMCodeItems();
    MCodeListitems = Utils.getMCodeList();
  }

  loadData() async {
    // MCodeListitems.clear();
    // await AgentController.to.getDataMCodeItems();
    // MCodeListitems = AgentController.to.qDataMCodeItems;

    await OrderController.to.getOrderList(_mCode, '', widget.shopCd).then((value) {
      if (this.mounted) {
        if (value == null) {
          ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
        } else {
          setState(() {
            dataList.clear();

            value.forEach((e) {
              OrderAccount temp = OrderAccount.fromJson(e);
              if (temp.CANCEL_TYPE == null || temp.CANCEL_TYPE == 'null')
                temp.CANCEL_TYPE = '';

              String reDate = temp.ORDER_TIME.replaceAll('T', ' ');
              DateTime retValue = DateTime.parse(reDate);

              temp.ORDER_TIME = DateFormat('yyyy-MM-dd ahh:mm:ss', 'ko').format(retValue);

              if (temp.ORDER_TIME.contains('오전'))
                temp.ORDER_TIME = temp.ORDER_TIME.replaceAll(' 오전', '\n오전 ');
              else
                temp.ORDER_TIME = temp.ORDER_TIME.replaceAll(' 오후', '\n오후 ');

              String currentTodayTime = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
              if (temp.ORDER_TIME.contains(currentTodayTime) == true) temp.ORDER_TIME = temp.ORDER_TIME.replaceAll(currentTodayTime + '\n', '');

              dataList.add(temp);
            });

            _totalRowCnt = OrderController.to.totalRowCnt;
            _totalPages = (_totalRowCnt / _selectedpagerows).ceil();
          });
        }
      }
    });
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
    if (_timer != null)
      _timer.cancel();

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
          //testSearchBox(),
        ],
      ),
    );

    var cancelReasonsBar = Expanded(
      flex: 0,
      child: Column(
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    color: Colors.grey.shade200,
                    child: Text('고객본인취소 ${cancel_cust} / 가맹점취소 ${cancel_shop} / 시간지연 ${cancel_delay}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
                ),
              ),
            ],
          ),
        ],
      ),
    );

    var buttonBar = Expanded(
      flex: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
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
                  )
                ],
              )
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  ISSearchDropdown(
                    label: '검색조건',
                    width: 150,
                    value: _divKey,
                    onChange: (value) {
                      setState(() {
                        _divKey = value;
                        _currentPage = 1;

                        if (value == '1') {
                          _keyWordLabel = '주문번호';
                        } else if (value == '2') {
                          _keyWordLabel = '전화번호';
                        } else if (value == '3') {
                          _keyWordLabel = '상점명';
                        } else if (value == '4') {
                          _keyWordLabel = '사업자번호';
                        }
                        _query();
                      });
                    },
                    item: [
                      DropdownMenuItem(value: '1', child: Text('주문번호'),),
                      DropdownMenuItem(value: '2', child: Text('전화번호'),),
                      DropdownMenuItem(value: '3', child: Text('상점명'),),
                      DropdownMenuItem(value: '4', child: Text('사업자번호'),),
                    ].cast<DropdownMenuItem<String>>(),
                  ),
                  ISSearchDropdown(
                    label: '상태',
                    width: 150,
                    value: _State,
                    onChange: (value) {
                      setState(() {
                        _State = value;
                        _currentPage = 1;
                        _query();
                      });
                    },
                    item: [
                      DropdownMenuItem(value: ' ',  child: Text('전체'),),
                      DropdownMenuItem(value: '10', child: Text('접수'),),
                      DropdownMenuItem(value: '20', child: Text('대기'),),
                      DropdownMenuItem(value: '30', child: Text('가맹점 접수확인'),),
                      DropdownMenuItem(value: '35', child: Text('운행'),),
                      DropdownMenuItem(value: '40', child: Text('완료'),),
                      DropdownMenuItem(value: '50', child: Text('취소'),),
                      DropdownMenuItem(value: '80', child: Text('결제대기'),),
                    ].cast<DropdownMenuItem<String>>(),
                  ),
                ],
              ),
              SizedBox(height: 8,),
              Row(
                children: [
                  Container(
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        ISSearchInput(
                          label: _keyWordLabel,
                          width: 220,
                          value: _searchItems.name,
                          onChange: (v) {
                            _searchItems.name = v;
                          },
                          onFieldSubmitted: (v) {
                            _currentPage = 1;
                            _query();
                          },
                        ),
                      ],
                    ),
                  ),
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
        ],
      ),
    );

    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          form,
          cancelReasonsBar,
          Divider(),
          ISDatatable(
            controller: ScrollController(),
            panelHeight: (widget.popHeight-140)-cancelViewMargin,
            listWidth: widget.popWidth-20,//width: (isPoupEnabled() == true) ? (Responsive.isTablet(context) ? MediaQuery.of(context).size.width : contentListWidth) : widget.popWidth-20,
            rows: dataList.map((item) {
              return DataRow(cells: [
                DataCell(Center(child: SelectableText(item.ORDER_NO.toString() ?? '--', style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center( child: SelectableText(item.ORDER_TIME.toString() ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true))),
                DataCell(Center(child: Container(
                  padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                  decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.black45), borderRadius: BorderRadius.circular(5.0)),
                  child: SelectableText(' '+_getPackOrderGbn(item.PACK_ORDER_YN.toString()), style: TextStyle(color: Colors.black45), showCursor: true),
                ))
                ),
                //DataCell(Center(child: SelectableText(_getPayGbn(item.PAY_GBN.toString()), style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center(child: SelectableText(_getPayGbn(item.PAY_GBN.toString())+'(${_getAppPayGbn(item.APP_PAY_GBN.toString())})', style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Align(child: SelectableText(Utils.getCashComma(item.ORDER_AMOUNT.toString()) ?? '--', style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.centerRight)),
                DataCell(Container(width: 10,)),
                DataCell(
                  Align(child: SelectableText(_getStatus(item.STATUS.toString()) ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true), alignment: Alignment.centerLeft)
                  // DropdownButton(
                  //   style: TextStyle(fontSize: 14, fontFamily: 'NotoSansKR', color: Colors.black),
                  //   onChanged: (value) async {
                  //     if (item.STATUS == value) return;
                  //
                  //     // 취소 완료일때만 변경 가능하도록
                  //     if (value != '40' && value != '50') {
                  //       ISAlert(context, '취소, 완료 상태로만 변경 가능 합니다.');
                  //       return;
                  //     }
                  //
                  //     var headerData = {
                  //       "Access-Control-Allow-Origin": "*",
                  //       // Required for CORS support to work
                  //       "Access-Control-Allow-Headers": "*",
                  //       "Access-Control-Allow-Credentials": "true",
                  //       "Access-Control-Allow-Methods": "*",
                  //       "Authorization": "QzI1QTgyNEVFQkVEQ0U5RkM2NTUzODFCNTc3MUJENTc=",
                  //       "Method": "DELETE",
                  //       "Content-Type": "application/json",
                  //     };
                  //
                  //     var PosheaderData = {
                  //       "content-type": "application/json",
                  //       //"Accept": "application/json",
                  //     };
                  //
                  //     var PosbodyData = {'"order_no"': '"' + item.ORDER_NO.toString() + '"', '"order_status"': '"' + value + '"', '"shop_token"': '"' + item.API_COM_CODE + '"'};
                  //
                  //     if (value == '50') {
                  //       showDialog(
                  //         barrierDismissible: false,
                  //         context: context,
                  //         builder: (BuildContext context) => Dialog(
                  //           child: OrderCancelCode(),
                  //         ),
                  //       ).then((v) async {
                  //         if (v != null) {
                  //           saveStatusData.cancelCode = v[0];
                  //           saveStatusData.cancelReason = v[1];
                  //
                  //           saveStatusData.orderNo = item.ORDER_NO.toString();
                  //           saveStatusData.status = value;
                  //           saveStatusData.modCode = GetStorage().read('logininfo')['uCode']; //formData.modeUcode;
                  //           saveStatusData.modName = GetStorage().read('logininfo')['name'] + '[관리앱 취소]'; //formData.modeName;
                  //
                  //           payCancelData.order_no = item.ORDER_NO.toString();
                  //           payCancelData.trade_kcp_no = item.TUID;
                  //
                  //           // 카드결제 유무 판단
                  //           String _card_approval_gbn = await OrderController.to.getOrderCardApprovalGbn(item.ORDER_NO.toString());
                  //
                  //           // (카드결재, 행복페이) 취소 인경우 카드결제 취소 같이
                  //           if (((item.PAY_GBN == '2' || item.PAY_GBN == '7') && _card_approval_gbn != 'N')) {
                  //             if (item.TUID != '') {
                  //               if (item.CUST_ID_GBN == 'Z') {
                  //                 // 비회원
                  //                 await OrderController.to.postPayBasicCancel(headerData, payCancelData.toJson(), saveStatusData.toJson(), PosheaderData, PosbodyData, context);
                  //               } else {
                  //                 // 회원
                  //                 await OrderController.to.postPaySmartCancel(headerData, payCancelData.toJson(), saveStatusData.toJson(), PosheaderData, PosbodyData, context);
                  //               }
                  //             } else {
                  //               var result = await OrderController.to.putData(saveStatusData.toJson(), context);
                  //
                  //               if (result == '00') {
                  //                 // POS REQUEST 정보
                  //                 await RestApiProvider.to.postRestError('0', '/admin/Order : putData', '[POS 상태변경 요청] ' + PosbodyData.toString());
                  //
                  //                 await http
                  //                     .post(Uri.parse('https://pos.daeguro.co.kr:15409/api/Agent/B2B_OrderStatus_Change_Manage'), headers: PosheaderData, body: PosbodyData.toString())
                  //                     .then((http.Response response) async {
                  //                   if (response.statusCode == 200) {
                  //                     var decodeBody = jsonDecode(response.body);
                  //
                  //                     if (decodeBody['code'] != 0) {
                  //                       await RestApiProvider.to.postRestError('0', '/admin/Order : putData',
                  //                           '[POS 상태변경 실패] ' + PosbodyData.toString() + ' || return : [' + response.statusCode.toString() + ']' + decodeBody.toString());
                  //                     } else {
                  //                       await RestApiProvider.to.postRestError('0', '/admin/Order : putData',
                  //                           '[POS 상태변경 성공] ' + PosbodyData.toString() + ' || return : [' + response.statusCode.toString() + ']' + decodeBody.toString());
                  //                     }
                  //                   } else {
                  //                     var decodeBody = jsonDecode(response.body);
                  //                     await RestApiProvider.to.postRestError(
                  //                         '0', '/admin/Order : putData', '[POS 상태변경 통신 실패] ' + PosbodyData.toString() + ' || return : [' + response.statusCode.toString() + ']' + decodeBody.toString());
                  //                   }
                  //                 });
                  //               }
                  //             }
                  //           } else {
                  //             var result = await OrderController.to.putData(saveStatusData.toJson(), context);
                  //
                  //             if (result == '00') {
                  //               await RestApiProvider.to.postRestError('0', '/admin/Order : putData', '[POS 상태변경 요청] ' + PosbodyData.toString());
                  //               await http
                  //                   .post(Uri.parse('https://pos.daeguro.co.kr:15409/api/Agent/B2B_OrderStatus_Change_Manage'), headers: PosheaderData, body: PosbodyData.toString())
                  //                   .then((http.Response response) async {
                  //                 if (response.statusCode == 200) {
                  //                   var decodeBody = jsonDecode(response.body);
                  //
                  //                   if (decodeBody['code'] != 0) {
                  //                     await RestApiProvider.to.postRestError('0', '/admin/Order : putData',
                  //                         '[POS 상태변경 실패] ' + PosbodyData.toString() + ' || return : [' + response.statusCode.toString() + ']' + decodeBody.toString());
                  //                   } else {
                  //                     await RestApiProvider.to.postRestError('0', '/admin/Order : putData',
                  //                         '[POS 상태변경 성공] ' + PosbodyData.toString() + ' || return : [' + response.statusCode.toString() + ']' + decodeBody.toString());
                  //                   }
                  //                 } else {
                  //                   var decodeBody = jsonDecode(response.body);
                  //                   await RestApiProvider.to.postRestError(
                  //                       '0', '/admin/Order : putData', '[POS 상태변경 통신 실패] ' + PosbodyData.toString() + ' || return : [' + response.statusCode.toString() + ']' + decodeBody.toString());
                  //                 }
                  //               });
                  //             }
                  //           }
                  //
                  //           await Future.delayed(Duration(milliseconds: 1000), () {
                  //             _query();
                  //           });
                  //         }
                  //       });
                  //     } else {
                  //       ISConfirm(context, '상태 변경', '상태변경 하시겠습니까?', (context) async {
                  //         Navigator.of(context).pop();
                  //
                  //         saveStatusData.orderNo = item.ORDER_NO.toString();
                  //         saveStatusData.status = value;
                  //         //saveStatusData.cancelCode = '00';
                  //         saveStatusData.modCode = GetStorage().read('logininfo')['uCode']; //formData.modeUcode;
                  //         saveStatusData.modName = GetStorage().read('logininfo')['name']; //formData.modeName;
                  //
                  //         payCancelData.order_no = item.ORDER_NO.toString();
                  //         payCancelData.trade_kcp_no = item.TUID;
                  //         //payCancelData.cancel_reason = '00';
                  //
                  //         var result = await OrderController.to.putData(saveStatusData.toJson(), context);
                  //
                  //         if (value == '40' && result == '00') {
                  //           await RestApiProvider.to.postRestError('0', '/admin/Order : putData', '[POS 상태변경 요청] ' + PosbodyData.toString());
                  //
                  //           await http
                  //               .post(Uri.parse('https://pos.daeguro.co.kr:15409/api/Agent/B2B_OrderStatus_Change_Manage'), headers: PosheaderData, body: PosbodyData.toString())
                  //               .then((http.Response response) async {
                  //             if (response.statusCode == 200) {
                  //               var decodeBody = jsonDecode(response.body);
                  //
                  //               // pos 저장 실패시 로그 저장
                  //               if (decodeBody['code'] != 0) {
                  //                 await RestApiProvider.to.postRestError(
                  //                     '0', '/admin/Order : putData', '[POS 상태변경 실패] ' + PosbodyData.toString() + ' || return : [' + response.statusCode.toString() + ']' + decodeBody.toString());
                  //               } else {
                  //                 await RestApiProvider.to.postRestError(
                  //                     '0', '/admin/Order : putData', '[POS 상태변경 성공] ' + PosbodyData.toString() + ' || return : [' + response.statusCode.toString() + ']' + decodeBody.toString());
                  //               }
                  //             } else {
                  //               var decodeBody = jsonDecode(response.body);
                  //
                  //               await RestApiProvider.to.postRestError(
                  //                   '0', '/admin/Order : putData', '[POS 상태변경 통신 실패] ' + PosbodyData.toString() + ' || return : [' + response.statusCode.toString() + ']' + decodeBody.toString());
                  //             }
                  //           });
                  //         }
                  //
                  //         await Future.delayed(Duration(milliseconds: 1000), () {
                  //           _query();
                  //         });
                  //       });
                  //     }
                  //   },
                  //   value: item.STATUS,
                  //   items: [
                  //     DropdownMenuItem(
                  //       value: '10',
                  //       child: Text('접수'),
                  //     ),
                  //     DropdownMenuItem(
                  //       value: '20',
                  //       child: Text('대기'),
                  //     ),
                  //     DropdownMenuItem(
                  //       value: '30',
                  //       child: Text('가맹점 접수확인'),
                  //     ),
                  //     DropdownMenuItem(
                  //       value: '35',
                  //       child: Text('운행'),
                  //     ),
                  //     DropdownMenuItem(
                  //       value: '40',
                  //       child: Text('완료'),
                  //     ),
                  //     DropdownMenuItem(
                  //       value: '50',
                  //       child: Text('취소'),
                  //     ),
                  //     DropdownMenuItem(
                  //       value: '80',
                  //       child: Text('결제대기'),
                  //     ),
                  //   ].cast<DropdownMenuItem<String>>(),
                  // ),
                ),
                DataCell(Align(child: SelectableText(item.CANCEL_TYPE.toString() ?? '--' , style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.centerLeft)),
                DataCell(Center(
                  child: SelectableText(Utils.getPhoneNumFormat(item.CUSTOMER_TELNO, false).toString() ?? '--', style: TextStyle(color: Colors.black), showCursor: true),
                )
                ),
                // DataCell(
                //     Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: <Widget>[
                //         SelectableText(item.cardName.toString() ?? '--', style: TextStyle(color: Colors.black, fontSize: 13), showCursor: true),
                //         SelectableText(item.tuid.toString() ?? '--', style: TextStyle(color: Colors.black, fontSize: 11), showCursor: true)
                //       ],
                //     )
                // ),
                //DataCell(Align(child: SelectableText(Utils.getCashComma(item.cardAmount.toString()) ?? '--' ?? '--', style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.centerLeft)),
                DataCell(Center(child: item.DIRECT_PAY.toString() == 'Y' ? Icon(Icons.radio_button_unchecked, color: Colors.blue, size: 16) : Icon(Icons.clear, color: Colors.red, size: 16))),
                DataCell(
                  Center(
                    child: InkWell(
                        onTap: () {
                          _detail(orderNo: item.ORDER_NO.toString());
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
              DataColumn(label: Expanded(child: Text('결제수단', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('결제금액', textAlign: TextAlign.right)),),
              DataColumn(label: Container(width: 10,)),
              DataColumn(label: Expanded(child: Text('진행상태', textAlign: TextAlign.left)),),
              DataColumn(label: Expanded(child: Text('취소사유', textAlign: TextAlign.left)),),
              DataColumn(label: Expanded(child: Text('회원전화', textAlign: TextAlign.center)),),
              //DataColumn(label: Expanded(child: Text('카드승인정보', textAlign: TextAlign.left)),),
              //DataColumn(label: Expanded(child: Text('승인금액', textAlign: TextAlign.left)),),
              DataColumn(label: Expanded(child: Text('할인', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('상세', textAlign: TextAlign.center)),),
            ],
          ),
          Divider(),
          showPagerBar(),
        ],
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
            child: Container(),
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
                Text('페이지당 행 수', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),),
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

  // bool isMainShowEnabled(){
  //   return (widget.shopCd == null);
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

  String _getAppPayGbn(String value) {
    String retValue = '--';

    if (value.toString().compareTo('1') == 0)
      retValue = '현장';//'현장(현금)';
    else if (value.toString().compareTo('3') == 0)
      retValue = '앱';
    else if (value.toString().compareTo('5') == 0)
      retValue = '현장';//'현장(카드)';
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
