import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_input.dart';
import 'package:daeguro_admin_app/Model/logTaxListModel.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/CalculateManager/calculate_controller.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/constants/constant.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogTaxListManager extends StatefulWidget {
  @override
  LogTaxListManagerState createState() => LogTaxListManagerState();
}

class LogTaxListManagerState extends State<LogTaxListManager> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  SearchItems _searchItems = new SearchItems();

  final List<logTaxListModel> dataList = <logTaxListModel>[];

  //페이지정보
  int _totalRowCnt = 0;
  int _selectedpagerows = 30;//15;

  int _currentPage = 1;
  int _totalPages = 0;

  String _divKey = '1';
  String _keyWordLabel = '사용자명';

  String _div = ' ';
  String _error_gbn = ' ';

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

    CalculateController.to.startDate.value = _searchItems.startdate.replaceAll('-', '');
    CalculateController.to.endDate.value = _searchItems.enddate.replaceAll('-', '');
    CalculateController.to.divKey.value = _divKey;
    CalculateController.to.keyword.value = _searchItems.memo;

    CalculateController.to.page.value = _currentPage.round().toString();
    CalculateController.to.rows.value = _selectedpagerows.round().toString();
    loadData();
  }

  // _detail({String seq}) async {
  //   await LogController.to.getDetailData(seq);
  //
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) => Dialog(
  //         child: LogErrorDetail(seq: seq),
  //       )
  //   );
  // }

  loadData() async {
    await ISProgressDialog(context).show(status: 'Loading...');

    dataList.clear();

    await CalculateController.to.getTaxLogData(_div, _error_gbn).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        value.forEach((e) {
          logTaxListModel temp = logTaxListModel.fromJson(e);
          if (temp.INS_TIME != null) temp.INS_TIME = temp.INS_TIME.replaceAll('T', '  ');
          dataList.add(temp);
        });

        _totalRowCnt = CalculateController.to.totalRowCnt;
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

    Get.put(CalculateController());

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
                Text('총: ${Utils.getCashComma(CalculateController.to.totalRowCnt.toString())}건', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
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
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ISSearchDropdown(
                          label: '작업구분',
                          width: 120,
                          value: _div,
                          onChange: (value) {
                            setState(() {
                              _div = value;
                              // _currentPage = 1;
                              //
                              // _query();
                            });
                          },
                          item: [
                            DropdownMenuItem(value: ' ', child: Text('전체'),),
                            DropdownMenuItem(value: 'C', child: Text('생성'),),
                            DropdownMenuItem(value: 'P', child: Text('발행'),
                            ),
                          ].cast<DropdownMenuItem<String>>(),
                        ),
                        ISSearchDropdown(
                          label: '에러구분',
                          width: 150,
                          value: _error_gbn,
                          onChange: (value) {
                            setState(() {
                              _error_gbn = value;
                              // _currentPage = 1;
                              //
                              // _query();
                            });
                          },
                          item: [
                            DropdownMenuItem(value: ' ', child: Text('전체'),),
                            DropdownMenuItem(value: 'S', child: Text('성공'),),
                            DropdownMenuItem(value: 'E', child: Text('실패'),
                            ),
                          ].cast<DropdownMenuItem<String>>(),
                        ),
                      ],
                    ),
                    SizedBox(height: 8,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ISSearchDropdown(
                          label: '검색조건',
                          width: 120,
                          value: _divKey,
                          onChange: (value) {
                            setState(() {
                              _divKey = value;
                              //_currentPage = 1;
                              if (value == '1') {
                                _keyWordLabel = '사용자명';
                              }
                              else if (value == '2') {
                                _keyWordLabel = '로그 메시지';
                              }
                              else if (value == '3') {
                                _keyWordLabel = '포지션';
                              }

                              //_query();
                            });
                          },
                          item: [
                            DropdownMenuItem(value: '1', child: Text('사용자명'),),
                            DropdownMenuItem(value: '2', child: Text('로그 메시지')),
                            DropdownMenuItem(value: '3', child: Text('포지션'),
                            ),
                          ].cast<DropdownMenuItem<String>>(),
                        ),
                        ISSearchInput(
                          label: _keyWordLabel,
                          width: 158,
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
                    )

                  ],
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
                DataCell(Center(child: SelectableText(item.INS_TIME ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true))),
                DataCell(Center(child: SelectableText(_getDiv(item.DIV) ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true,))),
                DataCell(Center(child: SelectableText(_getErrorgbn(item.ERROR_GBN) ?? '--', style: TextStyle(color: item.ERROR_GBN == 'E' ? Colors.red : Colors.blue, fontSize: 12, fontWeight: FontWeight.bold), showCursor: true,))),
                DataCell(Center(child: SelectableText('[${item.INS_UCODE}] ${item.USER_NAME}', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true))),
                DataCell(Align(child: SelectableText(item.POSITION ?? '--', style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: 'NotoSansKR'), showCursor: true), alignment: Alignment.centerLeft)),
                DataCell(Container(width:600, child: Text(item.ERROR_MSG ?? '--', style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: 'NotoSansKR'), maxLines: 1, textAlign: TextAlign.left, overflow: TextOverflow.fade, softWrap: false, /*showCursor: true*/), alignment: Alignment.centerLeft)),
                DataCell(Center(
                    child: (item.PARAMETER.toString() == '' || item.PARAMETER == null)
                        ? IconButton(icon: Icon(Icons.description, color: Colors.grey.shade400, size: 16))
                        : Tooltip(child: IconButton(icon: Icon(Icons.description, color: Colors.blue, size: 16),),
                      message: item.PARAMETER,
                      textStyle: TextStyle(fontSize: 12, color: Colors.white),
                      padding: EdgeInsets.all(5),
                    ))
                ),
              ]);
            }).toList(),
            columns: <DataColumn>[
              DataColumn(label: Expanded(child: Text('SEQ', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('작업시간', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('작업구분', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('에러구분', textAlign: TextAlign.center)),),

              DataColumn(label: Expanded(child: Text('작업자', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('프로그램명', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('결과', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('파라미터', textAlign: TextAlign.center)),),
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

  String _getErrorgbn(String value) {
    String retValue = '--';

    if (value.toString() == 'S')
      retValue = '성공';
    else if (value.toString() == 'E')
      retValue = '실패';
    else
      retValue = '--';

    return retValue;
  }

  String _getDiv(String value) {
    String retValue = '--';

    if (value.toString() == 'C')
      retValue = '생성';
    else if (value.toString() == 'P')
      retValue = '발행';
    else
      retValue = '--';

    return retValue;
  }
}
