import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_input.dart';
import 'package:daeguro_admin_app/Model/logPrivacyListModel.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/LogManager/logErrorDetail.dart';
import 'package:daeguro_admin_app/View/LogManager/log_controller.dart';
import 'package:daeguro_admin_app/constants/constant.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogPrivacyListManager extends StatefulWidget {
  @override
  LogPrivacyListManagerState createState() => LogPrivacyListManagerState();
}

class LogPrivacyListManagerState extends State<LogPrivacyListManager> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  SearchItems _searchItems = new SearchItems();

  final List<logPrivacyListModel> dataList = <logPrivacyListModel>[];

  //페이지정보
  int _totalRowCnt = 0;
  int _selectedpagerows = 30;//15;

  int _currentPage = 1;
  int _totalPages = 0;

  String _divKey = '1';
  String _keyWordLabel = '사용자명';

  void _pageMove(int _page) {
    _query();
  }

  _reset() {
    _searchItems = null;
    _searchItems = new SearchItems();

    _searchItems.startdate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    _searchItems.enddate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    _searchItems.memo = '';
  }

  _query() {
    formKey.currentState.save();

    LogController.to.startDate.value = _searchItems.startdate.replaceAll('-', '');
    LogController.to.endDate.value = _searchItems.enddate.replaceAll('-', '');
    LogController.to.divKey.value = _divKey;
    LogController.to.keyword.value = _searchItems.memo;

    LogController.to.page.value = _currentPage;
    LogController.to.rows.value = _selectedpagerows;
    loadData();
  }

  _detail({String seq}) async {
    await LogController.to.getDetailData(seq);

    showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          child: LogErrorDetail(seq: seq),
        )
    );
  }

  loadData() async {
    await ISProgressDialog(context).show(status: 'Loading...');

    dataList.clear();

    await LogController.to.getPrivacyLogData().then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        value.forEach((e) {
          logPrivacyListModel temp = logPrivacyListModel.fromJson(e);
          if (temp.LOG_TIME != null) temp.LOG_TIME = temp.LOG_TIME.replaceAll('T', '  ');
          dataList.add(temp);
        });

        _totalRowCnt = LogController.to.totalRowCnt;
        _totalPages = (_totalRowCnt / _selectedpagerows).ceil();
      }
    });

    //if (this.mounted) {
    setState(() {

    });
    //}

    await ISProgressDialog(context).dismiss();
  }

  @override
  void initState() {
    super.initState();

    Get.put(LogController());

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
                Text('총: ${Utils.getCashComma(LogController.to.totalRowCnt.toString())}건', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
              ],
            ),
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
                ISSearchDropdown(
                  label: '로그구분',
                  width: 150,
                  value: _divKey,
                  onChange: (value) {
                    setState(() {
                      _divKey = value;
                      //_currentPage = 1;
                      if (value == '1') {
                        _keyWordLabel = '사용자명';
                      } else if (value == '2') {
                        _keyWordLabel = '프로그램명';
                      }

                      //_query();
                    });
                  },
                  item: [
                    DropdownMenuItem(value: '1', child: Text('사용자명'),),
                    DropdownMenuItem(value: '2', child: Text('프로그램명'),
                    ),
                  ].cast<DropdownMenuItem<String>>(),
                ),
                Container(
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      ISSearchInput(
                        label: _keyWordLabel,
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
                ISSearchButton(
                    label: '조회',
                    iconData: Icons.search,
                    onPressed: () => {
                      _currentPage = 1,
                      _query(),
                    }),
              ],
            )
          ],
        )
    );

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //SizedBox(height: 10),
          form,
          buttonBar,
          Divider(),
          ISDatatable(
            panelHeight: (MediaQuery.of(context).size.height-defaultContentsHeight),
            listWidth: Responsive.getResponsiveWidth(context, 720),
            dataRowHeight: 30,
            rows: dataList.map((item) {
              return DataRow(cells: [
                DataCell(Center(child: SelectableText(item.SEQ.toString() ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true))),
                DataCell(Center(child: SelectableText(_getStatus(item.LOG_GBN) ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true,))),
                DataCell(Center(child: SelectableText(item.LOG_TIME ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true))),
                DataCell(Center(child: SelectableText('[${item.UCODE}] ${item.USER_NAME}', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true))),
                //DataCell(Center(child: SelectableText(item.PID ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true))),
                DataCell(Center(child: SelectableText(item.PNAME ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true))),
                DataCell(Align(child: SelectableText(item.POSITION ?? '--', style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: 'NotoSansKR'), showCursor: true), alignment: Alignment.centerLeft)),
                DataCell(Align(child: SelectableText(item.CONTENT ?? '--', style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: 'NotoSansKR'), showCursor: true), alignment: Alignment.centerLeft)),
                // DataCell(
                //   Center(
                //     child: InkWell(
                //       child: Icon(Icons.receipt_long, size: 20, color: (item.SEQ.toString() == 'null' || item.SEQ.toString() == '0') ? Colors.grey : Colors.blue),
                //       onTap: () {
                //         //_detail(seq: item.SEQ.toString());
                //       },
                //     ),
                //   ),
                // ),
              ]);
            }).toList(),
            columns: <DataColumn>[
              DataColumn(label: Expanded(child: Text('SEQ', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('로그구분', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('시간', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('사용자', textAlign: TextAlign.center)),),
              //DataColumn(label: Expanded(child: Text('프로그램ID', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('프로그램명', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('프로그램 경로', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('내용', textAlign: TextAlign.center)),),
              //DataColumn(label: Expanded(child: Text('상세보기', textAlign: TextAlign.center)),),
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

  String _getStatus(String value) {
    String retValue = '--';

    if (value.toString() == '10')
      retValue = '조회';
    else if (value.toString() == '20')
      retValue = '개인정보해지';
    else if (value.toString() == '30')
      retValue = '회원탈퇴';
    else
      retValue = '--';

    return retValue;
  }
}
