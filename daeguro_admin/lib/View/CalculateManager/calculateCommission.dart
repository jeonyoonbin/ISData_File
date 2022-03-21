
import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_input.dart';
import 'package:daeguro_admin_app/Model/calc/calculateCommissionModel.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/AgentManager/agentAccount_Controller.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/constants/constant.dart';

import 'package:date_format/date_format.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';


import 'calculate_controller.dart';

class CalculateCommission extends StatefulWidget {
  final String shopName;

  const CalculateCommission({Key key, this.shopName}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CalculateCommissionState();
  }
}

class CalculateCommissionState extends State<CalculateCommission> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool excelEnable = true;
  String _mCode = '2';

  List<CalculateCommissionModel> dataList = <CalculateCommissionModel>[];
  //List MCodeListItems = [];

  SearchItems _searchItems = new SearchItems();

  String _divKey = '1';
  String _keyWordLabel = '가맹점명';

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

    _searchItems.startdate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    _searchItems.enddate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    _searchItems.name = ' ';
  }

  _query() {
    CalculateController.to.startDate.value = _searchItems.startdate.replaceAll('-', '');
    CalculateController.to.endDate.value = _searchItems.enddate.replaceAll('-', '');
    CalculateController.to.name.value = _searchItems.name;
    CalculateController.to.page.value = _currentPage.round().toString();
    CalculateController.to.rows.value = _selectedpagerows.toString();
    CalculateController.to.divKey.value = _divKey;
    CalculateController.to.chargeGbn.value = _searchItems.chargeGbn;
    loadData();
  }

  loadData() async {
    await ISProgressDialog(context).show(status: 'Loading...');
    //MCodeListItems.clear();

    // await AgentController.to.getDataMCodeItems();
    // MCodeListItems = AgentController.to.qDataMCodeItems;
    //MCodeListItems = Utils.getMCodeList();

    await CalculateController.to.getCommissionData(_mCode).then((value) {
      //if(this.mounted) {
        if(value == null){
          ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
        } else {
          dataList.clear();

          value.forEach((e) {
            CalculateCommissionModel temp = CalculateCommissionModel.fromJson(e);

            dataList.add(temp);
          });

          _totalRowCnt = CalculateController.to.totalRowCnt;
          _totalPages = (_totalRowCnt/_selectedpagerows).ceil();

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

    WidgetsBinding.instance.addPostFrameCallback((c) {
      _reset();
      _query();
    });

    setState(() {
      _searchItems.startdate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
      _searchItems.enddate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
      _searchItems.chargeGbn = ' ';
    });
  }

  @override
  void dispose() {
    if(dataList != null) {
      dataList.clear();
      dataList = null;
    }
    //MCodeListItems.clear();

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
              Row(
                children: [
                  ISSearchDropdown(
                    label: '수수료구분',
                    width: 120,
                    value: _searchItems.chargeGbn,
                    onChange: (value) {
                      setState(() {
                        if (EasyLoading.isShow == true) return;
                        _searchItems.chargeGbn = value;
                        _currentPage = 1;
                        _query();
                      });
                    },
                    item: [
                      DropdownMenuItem(value: ' ', child: Text('전체'),),
                      DropdownMenuItem(value: 'P', child: Text('중개수수료'),),
                      DropdownMenuItem(value: 'K', child: Text('카드수수료'),),
                    ].cast<DropdownMenuItem<String>>(),
                  ),
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
                        } else if (value == '2') {
                          _keyWordLabel = '사업자번호';
                        } else if (value == '0') {
                          _keyWordLabel = '연락처';
                        }
                        _query();
                      });
                    },
                    item: [
                      DropdownMenuItem(value: '1', child: Text('가맹점명'),),
                      DropdownMenuItem(value: '2', child: Text('사업자번호'),),
                      DropdownMenuItem(value: '0', child: Text('연락처'),),
                    ].cast<DropdownMenuItem<String>>(),
                  ),
                ],
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
                      DateTime valueDt = isBlank
                          ? DateTime.now()
                          : DateTime.parse(_searchItems.startdate);
                      final DateTime picked = await showDatePicker(
                        context: context,
                        initialDate: valueDt,
                        firstDate: DateTime(1900, 1),
                        lastDate: DateTime(2031, 12),
                      );

                      setState(() {
                        if (picked != null) {
                          _searchItems.startdate =
                              formatDate(picked, [yyyy, '-', mm, '-', dd]);
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
                      DateTime valueDt = isBlank
                          ? DateTime.now()
                          : DateTime.parse(_searchItems.enddate);
                      final DateTime picked = await showDatePicker(
                        context: context,
                        initialDate: valueDt,
                        firstDate: DateTime(1900, 1),
                        lastDate: DateTime(2031, 12),
                      );

                      setState(() {
                        if (picked != null) {
                          _searchItems.enddate =
                              formatDate(picked, [yyyy, '-', mm, '-', dd]);
                        }
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              Container(
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    ISSearchInput(
                      label: _keyWordLabel,
                      width: 160,
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
              SizedBox(height: 8,),
              ISSearchButton(
                width: 144,
                  label: '조회',
                  iconData: Icons.search,
                  onPressed: () => {
                    _currentPage = 1,
                    _query(),
                  }),

            ],
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
          // SizedBox(height: 5),
          form,
          buttonBar,
          Divider(),
          ISDatatable(
            panelHeight: (MediaQuery.of(context).size.height-defaultContentsHeight)-48,
            listWidth: Responsive.getResponsiveWidth(context, 640),
            // showCheckboxColumn: true,
            rows: dataList.map((item) {
              return DataRow(cells: [
                DataCell(Center(child: SelectableText(item.shopCd ?? '--', style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center(child: SelectableText(item.yymm ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), textAlign: TextAlign.center, showCursor: true))),
                DataCell(Center(child: SelectableText(Utils.getPhoneNumFormat(item.telNo.toString(), true) ?? '--', style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center( child: SelectableText(Utils.getStoreRegNumberFormat(item.regNo.toString(), false) ?? '--', style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Align( child: SelectableText(item.shopName ?? '--', style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.centerLeft)),
                DataCell(Align( child: SelectableText(Utils.getCashComma(item.pgmInAmt.toString()) ?? '--', style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.centerRight)),
                DataCell(Align( child: SelectableText(Utils.getCashComma(item.pgmOutAmt.toString()) ?? '--', style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.centerRight)),
                DataCell(Align( child: SelectableText(Utils.getCashComma(item.pgmAmt.toString()) ?? '--', style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.centerRight)),
                DataCell(Center( child: SelectableText(item.prtYn ?? '--', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true))),
                DataCell(Center( child: SelectableText(item.compCnt.toString() == 'null' ? '--' : item.compCnt.toString()+'건' ?? '--', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true))),
                DataCell(Center( child: SelectableText(item.cancelCnt.toString() == 'null' ? '--' : item.cancelCnt.toString()+'건' ?? '--', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true))),
              ]);
            }).toList(),
            columns: <DataColumn>[
              DataColumn(label: Expanded(child: Text('가맹점번호', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('월', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('연락처', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('사업자번호', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('상점명', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('수수료입금', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('수수료출금', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('합계', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('계산서발행', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('완료건수', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('취소건수', textAlign: TextAlign.center)),),
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

