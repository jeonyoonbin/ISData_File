import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_input.dart';
import 'package:daeguro_admin_app/Model/mileageInOutModel.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/AgentManager/agentAccount_Controller.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/MileageManager/mileage_controller.dart';
import 'package:daeguro_admin_app/constants/constant.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class MileageInOut extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MileageInOutState();
  }
}

class MileageInOutState extends State {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final List<mileageInOutModel> dataList = <mileageInOutModel>[];

  final Map<String, dynamic> sumData = new Map<String, dynamic>();

  SearchItems _searchItems = new SearchItems();
  List MCodeListitems = List();

  List<SelectOptionVO> selectBox_Gungu = [];
  String current_Gungu;
  String _cust_gbn = '%';

  //int rowsPerPage = 10;

  int _totalRowCnt = 0;
  int _selectedpagerows = 15;

  int _currentPage = 1;
  int _totalPages = 0;

  String _mCode = '2';
  String _operator_code = ' ';

  String startDate = '';
  String endDate = '';

  void _pageMove(int _page) {
    _query();
  }

  _reset() {
    _searchItems = null;
    _searchItems = new SearchItems();

    _searchItems.pos_yn = ' ';
    current_Gungu = ' ';

    _searchItems.startdate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', '01']);
    _searchItems.enddate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
  }

  _query() {
    startDate = _searchItems.startdate.replaceAll('-', '');
    endDate = _searchItems.enddate.replaceAll('-', '');

    loadData();
  }

  loadMCodeListData() async {
    //MCodeListitems.clear();

    //await AgentController.to.getDataMCodeItems();
    MCodeListitems = Utils.getMCodeList();

    if (this.mounted) {
      setState(() {
        //MCodeListitems = AgentController.to.qDataMCodeItems;
      });
    }
  }

  loadData() async {
    await ISProgressDialog(context).show(status: 'Loading...');

    dataList.clear();

    await MileageController.to
        .getMileageInOutList(startDate, endDate, _mCode, _cust_gbn, _searchItems.code, _currentPage.round().toString(), _selectedpagerows.toString(), context)
        .then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        setState(() {
          value.forEach((e) {
            mileageInOutModel temp = mileageInOutModel.fromJson(e);
            dataList.add(temp);
          });

          _totalRowCnt = MileageController.to.totalRowCnt;
          _totalPages = (_totalRowCnt / _selectedpagerows).ceil();
        });

        // 합계 추가 ( 리스트 있을시만 합계 표시 )
        if(dataList.length != 0 )
        {
          sumData['RNUM'] = '';
          sumData['MCODE'] = 2;
          sumData['MNAME'] = '';
          sumData['CUST_GBN'] = '';
          sumData['CUST_GBN_NM'] = '합계';
          sumData['CUST_CODE'] = null;
          sumData['CUST_NAME'] = '';
          sumData['CUST_MILEAGE'] = MileageController.to.sumData[0]['SUM_CUST_MILEAGE'];
          sumData['LOG_CUST_MILEAGE'] = MileageController.to.sumData[0]['SUM_LOG_CUST_MILEAGE'];
          sumData['IN_CNT'] = MileageController.to.sumData[0]['SUM_IN_CNT'];
          sumData['IN_AMT'] = MileageController.to.sumData[0]['SUM_IN_AMT'];
          sumData['ORDER_IN_CNT'] = MileageController.to.sumData[0]['SUM_ORDER_IN_CNT'];
          sumData['ORDER_IN_AMT'] = MileageController.to.sumData[0]['SUM_ORDER_IN_AMT'];
          sumData['SALE_IN_CNT'] = MileageController.to.sumData[0]['SUM_SALE_IN_CNT'];
          sumData['SALE_IN_AMT'] = MileageController.to.sumData[0]['SUM_SALE_IN_AMT'];
          sumData['ORDER_OUT_AMT'] = MileageController.to.sumData[0]['SUM_ORDER_OUT_AMT'];
          sumData['SALE_OUT_AMT'] = MileageController.to.sumData[0]['SUM_SALE_OUT_AMT'];
          sumData['OUT_AMT'] = MileageController.to.sumData[0]['SUM_OUT_AMT'];
          sumData['TERMINATE_AMT'] = MileageController.to.sumData[0]['SUM_TERMINATE_AMT'];

          dataList.add(mileageInOutModel.fromJson(sumData));
        }
      }
    });

    await ISProgressDialog(context).dismiss();
  }

  @override
  void initState() {
    super.initState();

    Get.put(MileageController());
    Get.put(AgentController());

    setState(() {
      _searchItems.startdate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', '01']);
      _searchItems.enddate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    });

    WidgetsBinding.instance.addPostFrameCallback((c) {
      _reset();
      loadMCodeListData();

      _query();
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Column(
            children: [
              ISSearchDropdown(
                label: '회원사',
                value: _mCode,
                onChange: (value) {
                  setState(() {
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ISSearchDropdown(
                label: '가입 구분',
                width: 160,
                value: _cust_gbn,
                onChange: (value) {
                  setState(() {
                    _cust_gbn = value;
                  });
                },
                item: [
                  DropdownMenuItem(value: '%', child: Text('전체'),),
                  DropdownMenuItem(value: '1', child: Text('가입'),),
                  DropdownMenuItem(value: '3', child: Text('해지'),),
                ].cast<DropdownMenuItem<String>>(),
              ),
              SizedBox(
                height: 8,
              ),
              ISSearchInput(
                label: '고객코드',
                width: 170,
                value: _searchItems.code,
                onChange: (v) {
                  _searchItems.code = v;
                },
                onFieldSubmitted: (v) {
                  _currentPage = 1;
                  _query();
                },
              ),
            ],
          ),
          SizedBox(width: 5),
          ISSearchButton(label: '조회', iconData: Icons.search, onPressed: () => {_currentPage = 1, _query()}),
        ],
      ),
    );

    TextStyle _sumTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black);

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
            panelHeight: (MediaQuery.of(context).size.height - defaultContentsHeight) - 48,
            listWidth: Responsive.getResponsiveWidth(context, 640),
            rows: dataList.map((item) {
              return DataRow(cells: [
                // DataCell(Align(
                //   child: SelectableText(item.shopName.toString() == null ? '--' : '[' + item.shopCd.toString() + '] ' + item.shopName.toString(), showCursor: true),
                //   alignment: Alignment.centerLeft,
                // )),
                // DataCell(Align(
                //     child: MaterialButton(
                //       height: 30.0,
                //       child: item.MNAME.toString() == '합계'
                //           ? Text('합계', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold))
                //           : Text(item.MNAME.toString(), style: TextStyle(color: Colors.black, fontSize: 13)),
                //     ),
                //     alignment: Alignment.center)),
                DataCell(Align(
                    child: item.CUST_GBN_NM.toString() == '합계'
                        ? Text('전체 합계', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold))
                        : Text(item.CUST_GBN_NM.toString() == '' ? '--' : item.CUST_GBN_NM.toString(), style: TextStyle(color: Colors.black),
                    ),
                    alignment: Alignment.center)),
                DataCell(Align(
                    child: Text(item.CUST_CODE.toString() == 'null' ? '--' : item.CUST_CODE.toString(),
                      style: TextStyle(color: Colors.black),
                    ),
                    alignment: Alignment.center)),
                DataCell(Align(
                    child: Text(item.CUST_NAME.toString() == '' ? '--' : item.CUST_NAME.toString(),
                      style: TextStyle(color: Colors.black),
                    ),
                    alignment: Alignment.center)),
                DataCell(Align(
                    child: Text(Utils.getCashComma(item.CUST_MILEAGE.toString()) ?? '--',
                      style: item.CUST_GBN_NM == '합계' ? _sumTextStyle : TextStyle(color: Colors.black),
                    ),
                    alignment: Alignment.centerRight)),
                DataCell(Align(
                    child: Text(Utils.getCashComma(item.LOG_CUST_MILEAGE.toString()) ?? '--',
                      style: item.CUST_GBN_NM == '합계' ? _sumTextStyle : TextStyle(color: Colors.black),
                    ),
                    alignment: Alignment.centerRight)),
                DataCell(Align(
                    child: Text(Utils.getCashComma(item.IN_CNT.toString()) ?? '--',
                      style: item.CUST_GBN_NM == '합계' ? _sumTextStyle : TextStyle(color: Colors.black),
                    ),
                    alignment: Alignment.centerRight)),
                DataCell(Align(
                    child: Text(Utils.getCashComma(item.IN_AMT.toString()) ?? '--',
                      style: item.CUST_GBN_NM == '합계' ? _sumTextStyle : TextStyle(color: Colors.black),
                    ),
                    alignment: Alignment.centerRight)),
                DataCell(Align(
                    child: Text(Utils.getCashComma(item.ORDER_IN_CNT.toString()) ?? '--',
                      style: item.CUST_GBN_NM == '합계' ? _sumTextStyle : TextStyle(color: Colors.black),
                    ),
                    alignment: Alignment.centerRight)),
                DataCell(Align(
                    child: Text(Utils.getCashComma(item.ORDER_IN_AMT.toString()) ?? '--',
                      style: item.CUST_GBN_NM == '합계' ? _sumTextStyle : TextStyle(color: Colors.black),
                    ),
                    alignment: Alignment.centerRight)),
                DataCell(Align(
                    child: Text(Utils.getCashComma(item.SALE_IN_AMT.toString()) ?? '--',
                      style: item.CUST_GBN_NM == '합계' ? _sumTextStyle : TextStyle(color: Colors.black),
                    ),
                    alignment: Alignment.centerRight)),
                DataCell(Align(
                    child: Text(Utils.getCashComma(item.ORDER_OUT_AMT.toString()) ?? '--',
                      style: item.CUST_GBN_NM == '합계' ? _sumTextStyle : TextStyle(color: Colors.black),
                    ),
                    alignment: Alignment.centerRight)),
                DataCell(Align(
                    child: Text(Utils.getCashComma(item.SALE_IN_CNT.toString()) ?? '--',
                      style: item.CUST_GBN_NM == '합계' ? _sumTextStyle : TextStyle(color: Colors.black),
                    ),
                    alignment: Alignment.centerRight)),
                DataCell(Align(
                    child: Text(Utils.getCashComma(item.SALE_OUT_AMT.toString()) ?? '--',
                      style: item.CUST_GBN_NM == '합계' ? _sumTextStyle : TextStyle(color: Colors.black),
                    ),
                    alignment: Alignment.centerRight)),
                DataCell(Align(
                    child: Text(Utils.getCashComma(item.OUT_AMT.toString()) ?? '--',
                      style: item.CUST_GBN_NM == '합계' ? _sumTextStyle : TextStyle(color: Colors.black),
                    ),
                    alignment: Alignment.centerRight)),
                DataCell(Align(
                    child: Text(Utils.getCashComma(item.TERMINATE_AMT.toString()) ?? '--',
                      style: item.CUST_GBN_NM == '합계' ? _sumTextStyle : TextStyle(color: Colors.black),
                    ),
                    alignment: Alignment.centerRight)),
              ]);
            }).toList(),
            columns: <DataColumn>[
              //DataColumn(label: Expanded(child: Text('회원사명', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('가입구분', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('고객코드', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('고객명', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('마일리지\n잔액', style: TextStyle(fontSize: 12), textAlign: TextAlign.right)),),
              DataColumn(label: Expanded(child: Text('대장 잔액', textAlign: TextAlign.right)),),
              DataColumn(label: Expanded(child: Text('충전 건수', textAlign: TextAlign.right)),),
              DataColumn(label: Expanded(child: Text('충전 합계', textAlign: TextAlign.right)),),
              DataColumn(label: Expanded(child: Text('주문 충전\n건수', style: TextStyle(fontSize: 12), textAlign: TextAlign.right)),),
              DataColumn(label: Expanded(child: Text('주문 충전', textAlign: TextAlign.right)),),
              DataColumn(label: Expanded(child: Text('판매 충전', textAlign: TextAlign.right)),),
              DataColumn(label: Expanded(child: Text('주문 차감', textAlign: TextAlign.right)),),
              DataColumn(label: Expanded(child: Text('판매 건수', textAlign: TextAlign.right)),),
              DataColumn(label: Expanded(child: Text('판매 차감', textAlign: TextAlign.right)),),
              DataColumn(label: Expanded(child: Text('차감 합계', textAlign: TextAlign.right)),),
              DataColumn(label: Expanded(child: Text('탈퇴\n마일리지', style: TextStyle(fontSize: 12), textAlign: TextAlign.right)),),
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
                      child: Text(_currentPage.toInt().toString() + ' / ' + _totalPages.toString(),
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
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
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                    ),
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
          )
        ],
      ),
    );
  }
}