import 'dart:async';

import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_text_box.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_input.dart';
import 'package:daeguro_admin_app/Model/calc/calculateShopMileageModel.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/AgentManager/agentAccount_Controller.dart';
import 'package:daeguro_admin_app/View/CalculateManager/calculateShopPurchase.dart';
import 'package:daeguro_admin_app/View/CalculateManager/calculate_controller.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/OrderManager/orderDetail.dart';
import 'package:daeguro_admin_app/View/OrderManager/orderManager_controller.dart';
import 'package:daeguro_admin_app/constants/constant.dart';

import 'package:date_format/date_format.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';


class CalculateShopMileage extends StatefulWidget {
  final String shopName;

  const CalculateShopMileage({Key key, this.shopName}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CalculateShopMileageState();
  }
}

class CalculateShopMileageState extends State<CalculateShopMileage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool excelEnable = true;

  List<calculateShopMileageModel> dataList = <calculateShopMileageModel>[];

  SearchItems _searchItems = new SearchItems();

  var weight;
  String _divKey = '1';
  String _keyWordLabel = '가맹점명';

  //페이지정보
  int _totalRowCnt = 0;
  int _selectedpagerows = 15;

  int _currentPage = 1;
  int _totalPages = 0;

  List MCodeListItems = [];

  String _mCode = '2';

  //잔액
  int _sumPreAmt = 0;

  //기간별 입,출,잔액
  int _sumInAmt = 0;
  int _sumOutAmt = 0;
  int _sumPreAmtIn = 0;

  final ScrollController _scrollController = ScrollController();

  void _pageMove(int _page) {
    _query();
  }

  _reset() {
    _searchItems = null;
    _searchItems = new SearchItems();

    _searchItems.startdate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    _searchItems.enddate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    _searchItems.memo = '';
    _searchItems.name = '';
  }

  _sum() async {
    await ISProgressDialog(context).show(status: 'Loading...');

    CalculateController.to.startDate.value = _searchItems.startdate.replaceAll('-', '');
    CalculateController.to.endDate.value = _searchItems.enddate.replaceAll('-', '');
    CalculateController.to.divKey.value = _divKey;
    CalculateController.to.name.value = _searchItems.name;
    CalculateController.to.memo.value = _searchItems.memo;

    //if (this.mounted) {

      await CalculateController.to.getShopCalculateSum(_mCode).timeout(const Duration(seconds: 30),
          onTimeout: () {
            print('타임아웃 : 시간초과(30초)');
          }).then((value) async {

        _sumPreAmt = CalculateController.to.sumPreAmt;
        _sumInAmt = CalculateController.to.sumInAmt;
        _sumOutAmt = CalculateController.to.sumOutAmt;
        _sumPreAmtIn = CalculateController.to.sumPreAmtIn;

        setState(() {

        });
      });
    //}

    await ISProgressDialog(context).dismiss();
  }

  _query() {
    CalculateController.to.startDate.value = _searchItems.startdate.replaceAll('-', '');
    CalculateController.to.endDate.value = _searchItems.enddate.replaceAll('-', '');
    CalculateController.to.page.value = _currentPage.round().toString();
    CalculateController.to.rows.value = _selectedpagerows.toString();
    CalculateController.to.divKey.value = _divKey;
    CalculateController.to.name.value = _searchItems.name;
    CalculateController.to.memo.value = _searchItems.memo;
    loadData();
  }

  _detail({String orderNo}) async {
    await OrderController.to.getDetailData(orderNo.toString());
    // print(orderNo);

    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: OrderDetail(orderNo: orderNo),
      ),
    );
  }

  loadData() async {
    await ISProgressDialog(context).show(status: 'Loading...');

    //MCodeListItems.clear();
    dataList.clear();

    CalculateController.to.all_amt = 0.obs;
    CalculateController.to.take_amt = 0.obs;
    CalculateController.to.remain_amt = 0.obs;

    CalculateController.to.all_amt_sum = 0.obs;
    CalculateController.to.p_amt_sum = 0.obs;
    CalculateController.to.k_amt_sum = 0.obs;
    CalculateController.to.take_count_sum = 0.obs;
    CalculateController.to.take_amt_sum = 0.obs;
    CalculateController.to.remain_amt_sum = 0.obs;

    // await AgentController.to.getDataMCodeItems();
    // MCodeListItems = AgentController.to.qDataMCodeItems;

    MCodeListItems = Utils.getMCodeList();

    await CalculateController.to.getData(_mCode).then((value) {
      //if (this.mounted) {
        if (value == null) {
          ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
        } else {
          dataList.clear();

          value.forEach((e) {
            calculateShopMileageModel temp = calculateShopMileageModel.fromJson(e);

            //if (temp.chargeDate != null) temp.chargeDate = temp.chargeDate.replaceAll('T', '  ');

            dataList.add(temp);
          });

          _totalRowCnt = CalculateController.to.totalRowCnt;
          _totalPages = (_totalRowCnt / _selectedpagerows).ceil();
          _sumPreAmt = CalculateController.to.sumPreAmt;
          _sumInAmt = CalculateController.to.sumInAmt;
          _sumOutAmt = CalculateController.to.sumOutAmt;
          _sumPreAmtIn = CalculateController.to.sumPreAmtIn;

          setState(() {

          });
        }
      //}
    });
    await ISProgressDialog(context).dismiss();
  }

  @override
  void initState() {
    super.initState();

    Get.put(AgentController());
    Get.put(CalculateController());
    Get.put(OrderController());

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
    //MCodeListItems.clear();

    if (_scrollController != null)
      _scrollController.dispose();

    // 가맹점 적립금 관리 합계(신규)
    CalculateController.to.all_amt = 0.obs;
    CalculateController.to.take_amt = 0.obs;
    CalculateController.to.remain_amt = 0.obs;
    CalculateController.to.all_amt_sum = 0.obs;
    CalculateController.to.in_amt_sum = 0.obs;
    CalculateController.to.p_amt_sum = 0.obs;
    CalculateController.to.k_amt_sum = 0.obs;
    CalculateController.to.take_count_sum = 0.obs;
    CalculateController.to.take_amt_sum = 0.obs;
    CalculateController.to.remain_amt_sum = 0.obs;

    // 주문번호별 정산금액 조회 SUM_COUNT
    CalculateController.to.count = 0.obs;
    CalculateController.to.comp = 0.obs;
    CalculateController.to.canc = 0.obs;
    CalculateController.to.sum_menu_amt = 0.obs;
    CalculateController.to.sum_deli_tip_amt = 0.obs;
    CalculateController.to.sum_tot_amt = 0.obs;
    CalculateController.to.sum_coupon_amt = 0.obs;
    CalculateController.to.sum_mileage_use_amt = 0.obs;
    CalculateController.to.sum_etc_disc_amt = 0.obs;
    CalculateController.to.sum_disc_amt = 0.obs;
    CalculateController.to.sum_amount = 0.obs;
    CalculateController.to.sum_pgm_amt = 0.obs;
    CalculateController.to.sum_pg_pgm_amt = 0.obs;
    CalculateController.to.sum_pgm_sum_amt = 0.obs;

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
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            children: [
              ISSearchDropdown(
                label: '회원사명',
                value: _mCode,
                width: 240,
                item: MCodeListItems.map((item) {
                  return new DropdownMenuItem<String>(
                      child: new Text(
                        item['mName'],
                        style: TextStyle(fontSize: 13, color: Colors.black),
                      ),
                      value: item['mCode']);
                }).toList(),
                onChange: (value) {
                  if (EasyLoading.isShow == true) return;
                  _mCode = value;
                  _currentPage = 1;
                  _query();

                  // setState(() {});
                },
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
          Column(
            children: [
              Row(
                children: [
                  ISSearchDropdown(
                    label: '검색조건',
                    width: 120,
                    value: _divKey,
                    onChange: (value) {
                      setState(() {
                        _divKey = value;
                        _currentPage = 1;
                        if (value == '1') {
                          _keyWordLabel = '가맹점명';
                        }
                        else if (value == '2') {
                          _keyWordLabel = '사업자번호';
                        }
                        // else if (value == '0') {
                        //   _keyWordLabel = '주문번호';
                        // }
                        _query();
                      });
                    },
                    item: [
                      DropdownMenuItem(value: '1', child: Text('가맹점명'),),
                      DropdownMenuItem(value: '2', child: Text('사업자번호'),),
                      //DropdownMenuItem(value: '0', child: Text('주문번호'),),
                    ].cast<DropdownMenuItem<String>>(),
                  ),
                  Container(
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        ISSearchInput(
                          label: _keyWordLabel,
                          width: 180,
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
                          label: '메모',
                          width: 212,
                          value: _searchItems.memo,
                          onChange: (v) {
                            _searchItems.memo = v;
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
                      width: 80,
                      label: '조회',
                      iconData: Icons.search,
                      onPressed: () => {
                        _currentPage = 1,
                        _query(),
                      }
                      ),
                  SizedBox(width: 4,)
                ],
              )
            ],
          ),
        ]
      ),
    );

    Container bar = Container(
      color: Colors.blue[50],
      width: 1640,
      height: 74,
      child: ListView(
        controller: _scrollController,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.all(5),
            child: ISButton(
                label: '합 계\n조 회',
                height: 56,
                iconData: Icons.autorenew,
                iconColor: Colors.white,
                textStyle: TextStyle(color: Colors.white),
                onPressed: () => {
                  if (EasyLoading.isShow != true) {_currentPage = 1, _sum()}
                }),
          ),
          Container(
            //color: Colors.blue[50],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: <Widget>[
                    Container(padding: EdgeInsets.only(left: 10),  child: Text('전체기간 합계', style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.bold))),
                    Container(width: 245, child: ISTextBox(label: '총 적립금', width: 140, value: CalculateController.to.all_amt.toString())),
                    Container(width: 245, child: ISTextBox(label: '총 출금액', width: 140, value: CalculateController.to.take_amt.toString())),
                    Container(width: 260, child: ISTextBox(label: '적립금               ', width: 140, value: CalculateController.to.remain_amt_sum.toString())),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(padding: EdgeInsets.only(left: 10), child: Text('검색기준 합계', style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.bold))),
                    Container(width: 245, child: ISTextBox(label: '총 적립금', width: 140, value: CalculateController.to.all_amt_sum.toString())),
                    Container(width: 245, child: ISTextBox(label: '중개수수료', width: 140, value: CalculateController.to.p_amt_sum.toString())),
                    Container(width: 260, child: ISTextBox(label: 'PG수수료 합계', width: 140, value: CalculateController.to.k_amt_sum.toString())),
                    Container(width: 245, child: ISTextBox(label: '출금횟수', width: 140, value: CalculateController.to.take_count_sum.toString())),
                    Container(width: 245, child: ISTextBox(label: '출금액', width: 140, value: CalculateController.to.take_amt_sum.toString())),
                    //Container(width: 245, child: ISTextBox(label: '적립금', width: 140, value: CalculateController.to.remain_amt_sum.toString())),
                  ],
                ),
              ],
            ),
          )
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
          Scrollbar(
              isAlwaysShown: true,
              controller: _scrollController,
              child: bar
          ),
          // bar2,
          // bar3,
          Divider(),
          ISDatatable(
            panelHeight: (MediaQuery.of(context).size.height-defaultContentsHeight)-138,
            listWidth: Responsive.getResponsiveWidth(context, 640),
            rows: dataList.map((item) {
              if (item.SHOP_CD != null) {
                weight = FontWeight.normal;
              } else {
                weight = FontWeight.normal;
              }
              return DataRow(cells: [
                //DataCell(Center(child: SelectableText(item.shopCd ?? '--', style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Align(child: SelectableText(item.SHOP_NAME.toString() == null ? '--' : '[' + item.SHOP_CD.toString() + '] ' + item.SHOP_NAME.toString(), showCursor: true), alignment: Alignment.centerLeft,)),
                DataCell(Align(child: SelectableText(Utils.getCashComma(item.ALL_AMT.toString()) ?? '--', style: TextStyle(color: Colors.black, fontWeight: weight), showCursor: true), alignment: Alignment.centerRight)),
                DataCell(Align(child: SelectableText(Utils.getCashComma(item.TAKE_COUNT.toString()) ?? '--', style: TextStyle(color: Colors.black, fontWeight: weight), showCursor: true), alignment: Alignment.centerRight)),
                DataCell(Align(child: SelectableText(Utils.getCashComma(item.IN_AMT.toString()) ?? '--', style: TextStyle(color: Colors.black, fontWeight: weight), showCursor: true), alignment: Alignment.centerRight)),
                DataCell(Align(child: SelectableText(Utils.getCashComma(item.P_AMT.toString()) ?? '--', style: TextStyle(color: Colors.black, fontWeight: weight), showCursor: true), alignment: Alignment.centerRight)),
                DataCell(Align(child: SelectableText(Utils.getCashComma(item.K_AMT.toString()) ?? '--', style: TextStyle(color: Colors.black, fontWeight: weight), showCursor: true), alignment: Alignment.centerRight)),
                DataCell(Align(child: SelectableText(Utils.getCashComma(item.TAKE_AMT.toString()) ?? '--', style: TextStyle(color: Colors.black, fontWeight: weight), showCursor: true), alignment: Alignment.centerRight)),
                DataCell(Align(child: SelectableText(Utils.getCashComma(item.REMAIN_AMT.toString()) ?? '--', style: TextStyle(color: Colors.black, fontWeight: weight), showCursor: true), alignment: Alignment.centerRight)),
                if (AuthUtil.isAuthEditEnabled('18') == true)
                DataCell(Center(child: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                        child: CalculateShopPurchase(sData: item),
                      ),
                    ).then((v) async {
                      if (v != null) {
                        await Future.delayed(Duration(milliseconds: 500), () {
                          loadData();
                        });
                      }
                    });
                  },
                  icon: Icon(Icons.monetization_on),
                  tooltip: '사입처리',
                )),

                ),
              ]);
            }).toList(),
            columns: <DataColumn>[
              //DataColumn(label: Expanded(child: Text('상점번호', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('코드/상점명', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('총 적립금', textAlign: TextAlign.right)),),
              DataColumn(label: Expanded(child: Text('출금횟수', textAlign: TextAlign.right)),),
              // DataColumn(label: Expanded(child: Text('적립잔액', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('적립급\n입금총액', textAlign: TextAlign.right, style: TextStyle(fontSize: 12))),),
              DataColumn(label: Expanded(child: Text('중개수수료\n총액', textAlign: TextAlign.right, style: TextStyle(fontSize: 12))),),
              DataColumn(label: Expanded(child: Text('PG수수료\n총액', textAlign: TextAlign.right, style: TextStyle(fontSize: 12))),),
              DataColumn(label: Expanded(child: Text('계좌출금\n총액', textAlign: TextAlign.right, style: TextStyle(fontSize: 12))),),
              DataColumn(label: Expanded(child: Text('현재 적립금', textAlign: TextAlign.right)),),
              if (AuthUtil.isAuthEditEnabled('18') == true)
              DataColumn(label: Expanded(child: Text('사입', textAlign: TextAlign.center)),),
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
                Text('조회 데이터 : ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),),
                Text(CalculateController.to.totalRowCnt.toString() + ' 건', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                SizedBox(width: 20,),
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
}
