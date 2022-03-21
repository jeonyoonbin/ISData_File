
import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_text_box.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_input.dart';
import 'package:daeguro_admin_app/Model/calc/calculateCcMileageModel.dart';
import 'package:daeguro_admin_app/Model/callCenter_code_name.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/AgentManager/agentAccount_Controller.dart';
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


class CalculateCcMileage extends StatefulWidget {
  final String shopName;

  const CalculateCcMileage({Key key, this.shopName}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CalculateCcMileageState();
  }
}

class CalculateCcMileageState extends State<CalculateCcMileage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool excelEnable = true;

  List<CalculateCcMileageModel> dataList = <CalculateCcMileageModel>[];
  SearchItems _searchItems = new SearchItems();

  List MCodeListItems = [];
  List<SelectOptionVO> callCenterList = [];

  String _mCode = '3';
  String _ccCode = ' ';
  String _testYn = ' ';

  String _State = ' ';

  //페이지정보
  int _totalRowCnt = 0;
  int _selectedpagerows = 15;

  int _currentPage = 1;
  int _totalPages = 0;

  //잔액
  int _sumPreAmt = 0;

  //기간별 입,출,잔액
  int _sumInAmt = 0;
  int _sumOutAmt = 0;
  int _sumPreAmtIn = 0;

  var weight;

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
    CalculateController.to.name.value = _searchItems.name;
    CalculateController.to.memo.value = _searchItems.memo;
    CalculateController.to.testYn.value = _testYn;

    //if (this.mounted) {
      await CalculateController.to.getCcMileageDataSum(_mCode, _ccCode).then((v) => {
        setState(() {
          _sumPreAmt = CalculateController.to.sumPreAmt;
          _sumInAmt = CalculateController.to.sumInAmt;
          _sumOutAmt = CalculateController.to.sumOutAmt;
          _sumPreAmtIn = CalculateController.to.sumPreAmtIn;
        })
      });
    //}
    await ISProgressDialog(context).dismiss();
  }

  _query() {
    CalculateController.to.startDate.value = _searchItems.startdate.replaceAll('-', '');
    CalculateController.to.endDate.value = _searchItems.enddate.replaceAll('-', '');
    CalculateController.to.page.value = _currentPage.round().toString();
    CalculateController.to.rows.value = _selectedpagerows.toString();
    CalculateController.to.name.value = _searchItems.name;
    CalculateController.to.memo.value = _searchItems.memo;
    CalculateController.to.testYn.value = _testYn;

    loadData();
  }

  _detail({String orderNo}) async {
    await OrderController.to.getDetailData(orderNo.toString(), context);

    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: OrderDetail(orderNo: orderNo),
      ),
    );
  }

  loadCallCenterListData() async {
    callCenterList.clear();

    await AgentController.to.getDataCCenterItems(_mCode).then((value) {
      if(value == null){
        ISAlert(context, '콜센터정보를 가져오지 못했습니다. \n\n관리자에게 문의 바랍니다');
      }
      else{
        callCenterList.add(new SelectOptionVO(value: ' ', label: '전체', label2: ''));
        value.forEach((element) {
          CallCenterCodeName tempData = CallCenterCodeName.fromJson(element);
          callCenterList.add(new SelectOptionVO(value: tempData.ccCode, label: '[' + tempData.ccCode + ']' + tempData.ccName, label2: tempData.ccName));
        });

        setState(() {

        });
      }
    });

    // if (this.mounted) {
    //   setState(() {
    //
    //   });
    // }
  }

  loadData() async {
    await ISProgressDialog(context).show(status: 'Loading...');
    // MCodeListItems.clear();

    // await AgentController.to.getDataMCodeItems();
    // MCodeListItems = AgentController.to.qDataMCodeItems;

    await CalculateController.to.getCcMileageData(_mCode, _ccCode).then((value) {
      //if (this.mounted) {
        if (value == null) {
          ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
        } else {
          setState(() {
            dataList.clear();

            value.forEach((e) {
              CalculateCcMileageModel temp = CalculateCcMileageModel.fromJson(e);

              if (temp.chargeDate != null) temp.chargeDate = temp.chargeDate.replaceAll('T', '  ');

              dataList.add(temp);
            });
            _totalRowCnt = CalculateController.to.totalRowCnt;
            _totalPages = (_totalRowCnt / _selectedpagerows).ceil();
            _sumPreAmt = CalculateController.to.sumPreAmt;
            _sumInAmt = CalculateController.to.sumInAmt;
            _sumOutAmt = CalculateController.to.sumOutAmt;
            _sumPreAmtIn = CalculateController.to.sumPreAmtIn;
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
    Get.put(AgentController());
    Get.put(CalculateController());

    WidgetsBinding.instance.addPostFrameCallback((c) {
      _reset();
      loadCallCenterListData();
      _query();
    });

    setState(() {
      _searchItems.startdate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
      _searchItems.enddate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
      _ccCode = ' ';
    });
  }

  @override
  void dispose() {
    if (dataList != null) {
      dataList.clear();
      dataList = null;
    }
    //MCodeListItems.clear();
    // callCenterList.clear();

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
          Container(
            margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
            child: ISSearchDropdown(
              label: '테스트 여부',
              width: 150,
              value: _testYn,
              onChange: (value) {
                setState(() {
                  _testYn = value;
                });
              },
              item: [
                DropdownMenuItem(
                  value: ' ',
                  child: Text('전체'),
                ),
                DropdownMenuItem(
                  value: 'Y',
                  child: Text('테스트건 조회'),
                ),
                DropdownMenuItem(
                  value: 'N',
                  child: Text('테스트건 제외'),
                ),
              ].cast<DropdownMenuItem<String>>(),
            ),
          ),
          Column(
            children: [
              ISSearchDropdown(
                label: '콜센터명',
                value: _ccCode,
                width: 240,
                item: callCenterList.map((item) {
                  return new DropdownMenuItem<String>(
                      child: new Text(
                        item.label,
                        style: TextStyle(fontSize: 13, color: Colors.black),
                      ),
                      value: item.value);
                }).toList(),
                onChange: (v) {
                  if (EasyLoading.isShow == true) return;
                  callCenterList.forEach((element) {
                    if (v == element.value) {
                      _ccCode = element.value;
                    }
                  });

                  _currentPage = 1;
                  _query();
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
              Container(
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    ISSearchInput(
                      label: '메모',
                      width: 300,
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
              SizedBox(height: 8,),
              Row(
                children: [
                  Container(
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        ISSearchInput(
                          label: '주문번호',
                          width: 212,
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
                  SizedBox(width: 4,)
                ],
              )
            ],
          ),
        ]
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
                  Text('기간별 합계 ', style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.bold)),
                  SizedBox(width: 10),
                  Text('입금 ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  Text(Utils.getCashComma('$_sumInAmt'), style: TextStyle(color: Colors.black)),
                  SizedBox(width: 10),
                  Text('출금 ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  Text(Utils.getCashComma('$_sumOutAmt'), style: TextStyle(color: Colors.black)),
                  SizedBox(width: 10),
                  Text('잔액 ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  Text(Utils.getCashComma('$_sumPreAmtIn'), style: TextStyle(color: Colors.black)),
                ],
              ),
              // SizedBox(width: 20),
              Row(
                children: [
                  ISTextBox(label: '총 잔액', width: 160, value: _sumPreAmt.toString()),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.all(5),
                    child: ISButton(
                        label: '합계',
                        iconData: Icons.autorenew,
                        iconColor: Colors.white,
                        textStyle: TextStyle(color: Colors.white),
                        onPressed: () => {
                          if (EasyLoading.isShow != true) {_sum()}
                        }),
                  ),
                ],
              ),
            ],
          ),
        ));

    return Container(
      //padding: EdgeInsets.only(left: 50, right: 50, bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // SizedBox(height: 5),
          form,
          buttonBar,
          Divider(),
          bar2,
          Divider(),
          ISDatatable(
            panelHeight: (MediaQuery.of(context).size.height-defaultContentsHeight)-104,
            listWidth: Responsive.getResponsiveWidth(context, 640),
            rows: dataList.map((item) {
              if (item.ccCode != null) {
                weight = FontWeight.normal;
              } else {
                weight = FontWeight.normal;
              }
              return DataRow(cells: [
                DataCell(Center(
                    child:
                    SelectableText(item.orderNo.toString() == 'null' || item.orderNo.toString() == '0' ? '--' : item.orderNo.toString() ?? '--', style: TextStyle(color: Colors.black, fontWeight: weight), showCursor: true))),
                DataCell(Center(child: SelectableText(item.chargeDate ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), textAlign: TextAlign.center, showCursor: true))),
                DataCell(Center(child: SelectableText(item.chargeGbnNm ?? '--', style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Align(child: SelectableText(item.ccName ?? '--', style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.centerLeft)),
                DataCell(Align(
                    child: SelectableText(Utils.getCashComma(item.inAmt.toString()) ?? '--', style: TextStyle(color: Colors.black, fontWeight: weight), showCursor: true),
                    alignment: Alignment.centerRight)),
                DataCell(Align(
                    child: SelectableText(Utils.getCashComma(item.outAmt.toString()) ?? '--', style: TextStyle(color: Colors.black, fontWeight: weight), showCursor: true),
                    alignment: Alignment.centerRight)),
                DataCell(Align(
                    child: SelectableText(Utils.getCashComma(item.preAmt.toString()) ?? '--', style: TextStyle(color: Colors.black, fontWeight: weight), showCursor: true),
                    alignment: Alignment.centerRight)),
                DataCell(Center(child: SelectableText(item.chargeName ?? '--', style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Align(child: SelectableText(item.memo ?? '--', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true), alignment: Alignment.centerLeft)),
                DataCell(Center(
                    child: item.orderNo.toString() == 'null' || item.orderNo.toString() == '0'
                        ? IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.receipt_long,
                        color: Colors.grey,
                      ),
                      tooltip: '상세없음',
                    )
                        : IconButton(
                      onPressed: () {
                        _detail(orderNo: item.orderNo.toString());
                      },
                      icon: Icon(Icons.receipt_long),
                      tooltip: '상세',
                    ))),
              ]);
            }).toList(),
            columns: <DataColumn>[
              DataColumn(label: Expanded(child: Text('주문번호', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('적립일자', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('적립구분', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('콜센터명', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('적립금입금', textAlign: TextAlign.right)),),
              DataColumn(label: Expanded(child: Text('적립금출금', textAlign: TextAlign.right)),),
              DataColumn(label: Expanded(child: Text('적립잔액', textAlign: TextAlign.right)),),
              DataColumn(label: Expanded(child: Text('작업자', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('메모', textAlign: TextAlign.center)),),
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
