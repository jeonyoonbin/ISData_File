import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_input.dart';
import 'package:daeguro_admin_app/Model/logAuthListModel.dart';
import 'package:daeguro_admin_app/Model/logErrorListModel.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/LogManager/logErrorDetail.dart';
import 'package:daeguro_admin_app/View/LogManager/log_controller.dart';
import 'package:daeguro_admin_app/constants/constant.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogAuthListManager extends StatefulWidget {
  @override
  LogAuthListManagerState createState() => LogAuthListManagerState();
}

class LogAuthListManagerState extends State<LogAuthListManager> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final List<logAuthListModel> dataList = <logAuthListModel>[];
  SearchItems _searchItems = new SearchItems();

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
    dataList.clear();

    _searchItems = null;
    _searchItems = new SearchItems();

    _searchItems.startdate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    _searchItems.enddate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    _searchItems.memo = '';

  }

  _query() {
    formKey.currentState.save();

    /* 로그컨트롤러에 접근해서 데이터 저장*/
    LogController.to.startDate.value = _searchItems.startdate.replaceAll('-', '');
    LogController.to.endDate.value = _searchItems.enddate.replaceAll('-', '');
    LogController.to.divKey.value = _divKey;
    LogController.to.keyword.value = _searchItems.memo;

    LogController.to.page.value = _currentPage;
    LogController.to.rows.value = _selectedpagerows;

    /* loadData */
    loadData();
  }

  _detail() async {

  }

  loadData() async {
    await ISProgressDialog(context).show(status: 'Loading...');

    dataList.clear();

    await LogController.to.getRoleHistLogData().then((value){
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        value.forEach((e) {
          logAuthListModel temp = logAuthListModel.fromJson(e);
          if (temp.HIST_DATE != null) temp.HIST_DATE = temp.HIST_DATE.replaceAll('T', '  ');
          dataList.add(temp);
        });
        _totalRowCnt = LogController.to.totalRowCnt;
        _totalPages = (_totalRowCnt / _selectedpagerows).ceil();
      }
    });
    // if (this.mounted) {
    setState(() {
    });
    // }

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
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[],
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
                Text(
                  '총: ${Utils.getCashComma(LogController.to.totalRowCnt.toString())}건',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
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
                        _keyWordLabel = '대상자명';
                      } else if (value == '2') {
                        _keyWordLabel = '프로그램명';
                      } else if (value == '3') {
                        _keyWordLabel = '수정자명';
                      }
                      //_query();
                    });
                  },
                  item: [
                    DropdownMenuItem(value: '1', child: Text('대상자명')),
                    DropdownMenuItem(value: '2', child: Text('수정자명'),),
                    DropdownMenuItem(value: '3', child: Text('프로그램명'),),
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
          ]

        ),
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
                DataCell(Center(child: SelectableText(item.NO.toString() ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true))),
                DataCell(Center(child: SelectableText(item.USER_NAME.toString()  ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true,))),
                DataCell(Center(child: SelectableText(item.ID.toString()  ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true))),
                DataCell(Center(child: SelectableText(item.NAME.toString() ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true))),
                DataCell(Center(child: SelectableText(item.MEMO.toString()?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true))),
                DataCell(Align(child: SelectableText(item.HIST_DATE.toString()  ?? '--', style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: 'NotoSansKR'), showCursor: true), alignment: Alignment.center)),
                DataCell(Align(child: SelectableText(item.MOD_UCODE.toString() == 'null' ? '--' : '[${item.MOD_UCODE.toString()}]' + item.MOD_NAME.toString(), style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: 'NotoSansKR'), showCursor: true), alignment: Alignment.center)),
              ]);
            }).toList(),
            columns: <DataColumn>[
              DataColumn(label: Expanded(child: Text('No', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('대상자', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('PG ID', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('프로그램명', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('변경사항', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('변경일자', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('수정자', textAlign: TextAlign.center)),),
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
}
