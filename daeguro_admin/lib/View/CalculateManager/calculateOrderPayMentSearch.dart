import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_text_box.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_input.dart';
import 'package:daeguro_admin_app/Model/calc/calcuateOrderPayMentCountModel.dart';
import 'package:daeguro_admin_app/Model/calc/calculateOrderPayMentModel.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/AgentManager/agentAccount_Controller.dart';
import 'package:daeguro_admin_app/View/CalculateManager/calculate_controller.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/OrderManager/orderDetail.dart';
import 'package:daeguro_admin_app/View/OrderManager/orderManager_controller.dart';
import 'package:daeguro_admin_app/constants/constant.dart';

import 'package:date_format/date_format.dart';
import 'package:date_time_picker/date_time_picker.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';

class CalculateOrderPayMentSearch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CalculateOrderPayMentSearchState();
  }
}

class CalculateOrderPayMentSearchState extends State<CalculateOrderPayMentSearch> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final List<CalculateOrderPayMentModel> dataList = <CalculateOrderPayMentModel>[];
  final List<CalculateOrderPayMentCountModel> dataListCount = <CalculateOrderPayMentCountModel>[];

  bool excelEnable = true;

  List MCodeListitems = List();
  String _divKey = '0';
  String _keyWordLabel = '가맹점명';

  String _State = ' ';
  String _PayGbn = ' ';
  String _mCode = '2';

  //페이지정보
  int _totalRowCnt = 0;
  int _selectedpagerows = 15;

  int _currentPage = 1;
  int _totalPages = 0;

  SearchItems _searchItems = new SearchItems();

  final ScrollController _scrollController = ScrollController();

  //합계
  var weight;
  var mInSum = 0;
  var mOutSum = 0;
  var unpayed = 0;
  var balance = 0;

  void _pageMove(int _page) {
    _query();
  }

  _reset() {
    _searchItems = null;
    _searchItems = new SearchItems();

    _searchItems.startdate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);

    _searchItems.enddate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
  }

  _query() {
    CalculateController.to.startDate.value = _searchItems.startdate.replaceAll('-', '');
    CalculateController.to.endDate.value = _searchItems.enddate.replaceAll('-', '');
    CalculateController.to.state.value = _State;
    CalculateController.to.tel.value = _searchItems.tel;
    CalculateController.to.name.value = _searchItems.name;
    CalculateController.to.page.value = _currentPage.round().toString();
    CalculateController.to.rows.value = _selectedpagerows.toString();
    loadData();
  }

  _sum() async {
    await ISProgressDialog(context).show(status: 'Loading...');

    CalculateController.to.startDate.value = _searchItems.startdate.replaceAll('-', '');
    CalculateController.to.endDate.value = _searchItems.enddate.replaceAll('-', '');
    CalculateController.to.state.value = _State;
    CalculateController.to.tel.value = _searchItems.tel;
    CalculateController.to.name.value = _searchItems.name;

    await CalculateController.to
        .getOrderCalculateSum(
            _mCode, _State, _PayGbn, _searchItems.startdate.replaceAll('-', ''), _searchItems.enddate.replaceAll('-', ''), _divKey, _searchItems.name)
        .timeout(const Duration(seconds: 60), onTimeout: () {
          print('타임아웃 : 시간초과(60초)');
        }).then((value) async {
    setState(() {});
    });

    await ISProgressDialog(context).dismiss();
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
  }

  loadMCodeListData() async {
    //MCodeListitems.clear();
    //MCodeListitems = await AgentController.to.getDataMCodeItems();
    MCodeListitems = Utils.getMCodeList();

    //if (this.mounted) {
      setState(() {});
    //}
  }

  loadData() async {
    await ISProgressDialog(context).show(status: 'Loading...');

    dataList.clear();
    dataListCount.clear();

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

    setState(() {
      _totalRowCnt = CalculateController.to.totalRowCnt;
      _totalPages = (_totalRowCnt / _selectedpagerows).ceil();
    });

    await CalculateController.to
        .getOrderCalculateList(_mCode, _State, _PayGbn, _searchItems.startdate.replaceAll('-', ''), _searchItems.enddate.replaceAll('-', ''), _divKey,
            _searchItems.name, _currentPage.round().toString(), _selectedpagerows.toString())
        .timeout(const Duration(seconds: 15), onTimeout: () async {
      print('타임아웃 : 시간초과(15초)');
    }).then((value) async {
      //if (this.mounted) {
        if (value == null) {
          ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
        } else {
          value.forEach((e) {
            CalculateOrderPayMentModel temp = CalculateOrderPayMentModel.fromJson(e);

            temp.ORDER_DATE = DateFormat('yyyy-MM-dd').format(DateTime.parse(temp.ORDER_DATE));
            dataList.add(temp);
          });

          _totalRowCnt = CalculateController.to.totalRowCnt;
          _totalPages = (_totalRowCnt / _selectedpagerows).ceil();

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

    Get.put(OrderController());
    Get.put(CalculateController());
    Get.put(AgentController());

    WidgetsBinding.instance.addPostFrameCallback((c) {
      loadMCodeListData();
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
    dataList.clear();
    //MCodeListitems.clear();

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
                onChange: (value) {
                  if (EasyLoading.isShow == true) return;

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
                      if (EasyLoading.isShow == true) return;

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
                      if (EasyLoading.isShow == true) return;

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
              ISSearchDropdown(
                label: '상태',
                width: 150,
                value: _State,
                onChange: (value) {
                  if (EasyLoading.isShow == true) return;

                  setState(() {
                    _State = value;
                    _currentPage = 1;
                    _query();
                  });
                },
                item: [
                  DropdownMenuItem(value: ' ', child: Text('전체'),),
                  DropdownMenuItem(value: '10', child: Text('접수'),),
                  DropdownMenuItem(value: '20', child: Text('대기'),),
                  DropdownMenuItem(value: '30', child: Text('확인'),),
                  DropdownMenuItem(value: '35', child: Text('기사운행'),),
                  DropdownMenuItem(value: '40', child: Text('완료'),),
                  DropdownMenuItem(value: '50', child: Text('취소'),),
                  DropdownMenuItem(value: '70', child: Text('포장'),),
                  DropdownMenuItem(value: '80', child: Text('결제대기'),),
                  DropdownMenuItem(value: '90', child: Text('예약'),),
                ].cast<DropdownMenuItem<String>>(),
              ),
              SizedBox(height: 8,),
              ISSearchDropdown(
                label: '검색조건',
                width: 150,
                value: _divKey,
                onChange: (value) {
                  if (EasyLoading.isShow == true) return;

                  setState(() {
                    _divKey = value;
                    _currentPage = 1;

                    if (value == '0') {
                      _keyWordLabel = '가맹점명';
                    } else if (value == '1') {
                      _keyWordLabel = '전화번호';
                    }

                    _query();
                  });
                },
                item: [
                  DropdownMenuItem(value: '0', child: Text('가맹점명'),),
                  DropdownMenuItem(value: '1', child: Text('전화번호'),),
                ].cast<DropdownMenuItem<String>>(),
              ),
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  ISSearchDropdown(
                    label: '결제구분',
                    width: 156,
                    value: _PayGbn,
                    onChange: (value) {
                      if (EasyLoading.isShow == true) return;

                      setState(() {
                        _PayGbn = value;
                        _currentPage = 1;
                        _query();
                      });
                    },
                    item: [
                      DropdownMenuItem(value: ' ', child: Text('전체'),),
                      DropdownMenuItem(value: '1', child: Text('만나서 현금'),),
                      DropdownMenuItem(value: '3', child: Text('앱결제(PG)'),),
                      DropdownMenuItem(value: '5', child: Text('만나서 카드'),),
                    ].cast<DropdownMenuItem<String>>(),
                  ),
                  SizedBox(width: 4,),
                ],
              ),
              SizedBox(height: 8,),
              Container(
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    ISSearchInput(
                      label: _keyWordLabel,
                      width: 162,
                      value: _searchItems.name,
                      onChange: (v) {
                        if (EasyLoading.isShow == true) return;

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
          ISSearchButton(
              label: '조회',
              iconData: Icons.search,
              onPressed: () => {
                if (EasyLoading.isShow != true) {_currentPage = 1, _query()}
              }),
          ]
      ),
    );

    Container bar2 = Container(
      color: Colors.blue[50],
      width: 1540,
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
                    Container(width: 215, child: ISTextBox(label: '총 주문금액', value: CalculateController.to.sum_tot_amt.toString())),
                    Container(width: 215, child: ISTextBox(label: '쿠폰금액', value: CalculateController.to.sum_coupon_amt.toString())),
                    Container(width: 215, child: ISTextBox(label: '마일리지', value: CalculateController.to.sum_mileage_use_amt.toString())),
                    Container(width: 215, child: ISTextBox(label: '기타 할인', value: CalculateController.to.sum_etc_disc_amt.toString())),
                    Container(width: 215, child: ISTextBox(label: '할인 집계', value: CalculateController.to.sum_disc_amt.toString())),
                    Container(width: 215, child: ISTextBox(label: '결제 집계', value: CalculateController.to.sum_amount.toString())),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(width: 215, child: ISTextBox(label: 'PG 수수료  ', value: CalculateController.to.sum_pg_pgm_amt.toString())),
                    Container(width: 215, child: ISTextBox(label: '중개 수수료', value: CalculateController.to.sum_pgm_amt.toString())),
                    Container(width: 215, child: ISTextBox(label: '수수료 합계', value: CalculateController.to.sum_pgm_sum_amt.toString())),
                    Container(width: 215, child: ISTextBox(label: '완료주문 수', value: CalculateController.to.comp.toString())),
                    Container(width: 215, child: ISTextBox(label: '취소주문 수', value: CalculateController.to.canc.toString())),
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
              child: bar2
          ),
          Divider(),
          ISDatatable(
            controller: ScrollController(),
            panelHeight: (MediaQuery.of(context).size.height-defaultContentsHeight)-138,
            listWidth: 1540,//Responsive.getResponsiveWidth(context, 640),
            //subWidget: bar2,
            rows: dataList.map((item) {
              return DataRow(cells: [
                DataCell(Center(child: SelectableText(item.ORDER_NO.toString() ?? '', style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center(
                    child: SelectableText(item.ORDER_DATE + '\n' + item.ORDER_TIME ?? '', style: TextStyle(color: Colors.black, fontSize: 12), textAlign: TextAlign.center, showCursor: true))),
                //DataCell(Center(child: SelectableText(Utils.getPhoneNumFormat(item.TELNO, true) ?? '', style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center(child: SelectableText(item.STATUS ?? '', style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Align(child: SelectableText(item.SHOP_NAME ?? '', style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.centerLeft)),
                DataCell(Center(child: SelectableText(item.APP_PAY_GBN ?? '', style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Align(child: SelectableText(Utils.getCashComma(item.MENU_AMT.toString()) ?? '', style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.centerRight)),
                DataCell(Align(
                    child: SelectableText(Utils.getCashComma(item.DELI_TIP_AMT.toString()) ?? '', style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.centerRight)),
                DataCell(Align(child: SelectableText(Utils.getCashComma(item.TOT_AMT.toString()) ?? '', style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.centerRight)),
                DataCell(Align(child: SelectableText(Utils.getCashComma(item.COUPON_AMT.toString()) ?? '', style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.centerRight)),
                DataCell(Align(child: SelectableText(Utils.getCashComma(item.MILEAGE_USE_AMT.toString()) ?? '', style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.centerRight)),
                DataCell(Align(child: SelectableText(Utils.getCashComma(item.ETC_DISC_AMT.toString()) ?? '', style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.centerRight)),
                DataCell(Align(child: SelectableText(Utils.getCashComma(item.DISC_AMT.toString()) ?? '', style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.centerRight)),
                DataCell(Align(child: SelectableText(Utils.getCashComma(item.AMOUNT.toString()) ?? '', style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.centerRight)),
                DataCell(Align(child: SelectableText(Utils.getCashComma(item.PGM_AMT.toString()) ?? '', style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.centerRight)),
                DataCell(Align(child: SelectableText(Utils.getCashComma(item.PG_PGM_AMT.toString()) ?? '', style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.centerRight)),
                DataCell(Align(child: SelectableText(Utils.getCashComma(item.PGM_SUM_AMT.toString()) ?? '', style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.centerRight)),
                DataCell(
                  Center(
                      child: IconButton(
                        onPressed: () {
                          _detail(orderNo: item.ORDER_NO.toString());
                        },
                        icon: Icon(Icons.receipt_long),
                        tooltip: '주문상세',
                      )),
                ),
              ]);
            }).toList(),
            columns: <DataColumn>[
              DataColumn(label: Expanded(child: Text('주문번호', textAlign: TextAlign.center))),
              DataColumn(label: Expanded(child: Text('주문시간', textAlign: TextAlign.center))),
              //DataColumn(label: Expanded(child: Text('고객전화', textAlign: TextAlign.center))),
              DataColumn(label: Expanded(child: Text('상태', textAlign: TextAlign.center))),
              DataColumn(label: Expanded(child: Text('상점명', textAlign: TextAlign.center))),
              DataColumn(label: Expanded(child: Text('결제', textAlign: TextAlign.center))),
              DataColumn(label: Expanded(child: Text('메뉴금액', textAlign: TextAlign.right))),
              DataColumn(label: Expanded(child: Text('배달금액', textAlign: TextAlign.right))),
              DataColumn(label: Expanded(child: Text('총 주문\n금액', textAlign: TextAlign.right, style: TextStyle(fontSize: 12)))),
              DataColumn(label: Expanded(child: Text('쿠폰할인', textAlign: TextAlign.right))),
              DataColumn(label: Expanded(child: Text('마일리지', textAlign: TextAlign.right))),
              DataColumn(label: Expanded(child: Text('기타할인', textAlign: TextAlign.right))),
              DataColumn(label: Expanded(child: Text('할인집계', textAlign: TextAlign.right))),
              DataColumn(label: Expanded(child: Text('결제금액', textAlign: TextAlign.right))),
              DataColumn(label: Expanded(child: Text('중개\n수수료', textAlign: TextAlign.right, style: TextStyle(fontSize: 12)))),
              DataColumn(label: Expanded(child: Text('PG\n수수료', textAlign: TextAlign.right, style: TextStyle(fontSize: 12)))),
              DataColumn(label: Expanded(child: Text('수수료\n합계', textAlign: TextAlign.right, style: TextStyle(fontSize: 12)))),
              DataColumn(label: Expanded(child: Text('상세', textAlign: TextAlign.center))),
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
