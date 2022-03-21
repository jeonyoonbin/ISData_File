import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_select_date.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/Model/noticeDetailModel.dart';
import 'package:daeguro_admin_app/Model/noticeListModel.dart';
import 'package:daeguro_admin_app/Model/reserNoticeDetailModel.dart';
import 'package:daeguro_admin_app/Model/reserNoticeListModel.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/NoticeManager/Reser/reserNoticeEdit.dart';
import 'package:daeguro_admin_app/View/NoticeManager/Reser/reserNoticeRegist.dart';
import 'package:daeguro_admin_app/View/NoticeManager/Reser/reserNoticeUpdateSort.dart';
import 'package:daeguro_admin_app/View/NoticeManager/Reser/reserNotice_controller.dart';
import 'package:daeguro_admin_app/View/NoticeManager/noticeEdit.dart';
import 'package:daeguro_admin_app/View/NoticeManager/noticeRegist.dart';
import 'package:daeguro_admin_app/View/NoticeManager/noticeUpdateSort.dart';
import 'package:daeguro_admin_app/View/NoticeManager/notice_controller.dart';
import 'package:daeguro_admin_app/constants/constant.dart';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';

List items = List();

class ReserNoticeList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ReserNoticeListState();
  }
}



class ReserNoticeListState extends State {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  SearchItems _searchItems = new SearchItems();
  final List<ResernoticeListModel> dataList = <ResernoticeListModel>[];

  String _dispCbo = 'Y';
  String _noticeGbnCbo = '1';

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

    _searchItems.startdate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', '01']);
    _searchItems.enddate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    //loadData();
  }

  _edit({String noticeSeq}) async {
    ReserNoticeDetailModel editData = null;

    await ReserNoticeController.to.getDetailData(noticeSeq.toString(), context);

    if (ReserNoticeController.to.qDataDetail != null) {
      editData = ReserNoticeDetailModel.fromJson(ReserNoticeController.to.qDataDetail);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: ReserNoticeEdit(sData: editData),
      ),
    ).then((v) async {
      if (v != null) {
        await Future.delayed(Duration(milliseconds: 500), (){
          _query();
        });
      }
    });
  }

  _regist() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: ReserNoticeRegist(),
      ),
    ).then((v) async {
      if (v != null) {
        await Future.delayed(Duration(milliseconds: 500), () {
          loadData();
        });
      }
    });
  }

  _updateSort() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: ReserNoticeUpdateSort(),
      ),
    ).then((v) async {
      if (v != null) {
        await Future.delayed(Duration(milliseconds: 500), () {
          loadData();
        });
      }
    });
  }

  _query() {
    formKey.currentState.save();

    ReserNoticeController.to.fromDate.value = _searchItems.startdate.replaceAll('-', '');
    ReserNoticeController.to.toDate.value = _searchItems.enddate.replaceAll('-', '');
    ReserNoticeController.to.dispGbn.value = _dispCbo;
    ReserNoticeController.to.noticeGbn.value = _noticeGbnCbo;

    ReserNoticeController.to.page.value = _currentPage;
    ReserNoticeController.to.raw.value = _selectedpagerows;
    loadData();
  }

  loadData() async {
    dataList.clear();

    await ReserNoticeController.to.getData(context);

    if (this.mounted) {
      setState(() {
        ReserNoticeController.to.qData.forEach((e) {
          ResernoticeListModel temp = ResernoticeListModel.fromJson(e);
          dataList.add(temp);
        });

        _totalRowCnt = ReserNoticeController.to.totalRowCnt;
        _totalPages = (_totalRowCnt / _selectedpagerows).ceil();
      });
    }
  }

  @override
  void initState() {
    super.initState();

    Get.put(ReserNoticeController());

    WidgetsBinding.instance.addPostFrameCallback((c) {
      _reset();
      _query();
    });

    setState(() {
      _searchItems.startdate =
          formatDate(DateTime.now(), [yyyy, '-', mm, '-', '01']);
      _searchItems.enddate =
          formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Text('총: ${Utils.getCashComma(ReserNoticeController.to.totalRowCnt.toString())}건', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
            ],
          ),
          Row(
            children: [
              Column(
                children: [
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
                  SizedBox(height: 8,),
                  Row(
                    children: [
                      ISSearchDropdown(
                        label: '게시유무',
                        width: 100,
                        value: _dispCbo,
                        onChange: (value) {
                          setState(() {
                            _dispCbo = value;
                            _currentPage = 1;
                            _query();
                          });
                        },
                        item: [
                          DropdownMenuItem(value: 'Y', child: Text('게시'),),
                          DropdownMenuItem(value: 'N', child: Text('미 게시'),),
                        ].cast<DropdownMenuItem<String>>(),
                      ),
                      ISSearchDropdown(
                        label: '구분',
                        width: 140,
                        value: _noticeGbnCbo,
                        onChange: (value) {
                          setState(() {
                            _noticeGbnCbo = value;
                            _currentPage = 1;
                            _query();
                          });
                        },
                        item: [
                          DropdownMenuItem(value: '1', child: Text('공지'),),
                          DropdownMenuItem(value: '2', child: Text('공지(사장님)'),),
                          DropdownMenuItem(value: '3', child: Text('이벤트'),),
                          DropdownMenuItem(value: '4', child: Text('이벤트(사장님)'),),
                          DropdownMenuItem(value: '5', child: Text('메인팝업'),),
                          DropdownMenuItem(value: '6', child: Text('메인팝업(사장님)'),),
                          DropdownMenuItem(value: '7', child: Text('시정홍보'),),
                        ].cast<DropdownMenuItem<String>>(),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(width: 8,),
              Column(
                children: [
                  if (AuthUtil.isAuthEditEnabled('82') == true)
                  ISSearchButton(
                      width: 168,
                      label: '노출 순서', iconData: Icons.autorenew, onPressed: () => _updateSort()),
                  SizedBox(height: 8,),
                  Row(
                    children: [
                      ISSearchButton(
                          width: 80,
                          label: '조회',
                          iconData: Icons.search,
                          onPressed: () => {_currentPage = 1, _query()}),
                      SizedBox(width: 8,),
                      if (AuthUtil.isAuthCreateEnabled('82') == true)
                      ISSearchButton(
                          width: 80,
                          label: '등록', iconData: Icons.add, onPressed: () => _regist()),
                    ],
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );

    return Container(
      //padding: EdgeInsets.only(left: 140, right: 140, bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          form,
          buttonBar,
          Divider(),
          ISDatatable(
            panelHeight: (MediaQuery.of(context).size.height-defaultContentsHeight)-48,
            listWidth: Responsive.getResponsiveWidth(context, 640), // Responsive.isTablet(context) ? MediaQuery.of(context).size.width : contentListWidth,
            rows: dataList.map((item) {
              return DataRow(cells: [
                DataCell(Center(
                    child: Text(
                      item.noticeSeq.toString() ?? '--',
                      style: TextStyle(color: Colors.black),
                    ))),
                DataCell(Align(
                    child: Text(
                      item.title.toString() ?? '--',
                      style: TextStyle(color: Colors.black),
                    ),alignment: Alignment.centerLeft)),
                DataCell(Center(
                    child: item.dispGbn.toString() == 'Y'
                        ? Icon(Icons.radio_button_unchecked, color: Colors.blue, size: 16)
                        : Icon(Icons.clear, color: Colors.red, size: 16))),
                DataCell(Center(
                    child: Text(
                        _getNoticeGbn(item.noticeGbn.toString()) ?? '--',
                        style: TextStyle(color: Colors.black)))),
                DataCell(Center(
                    child: Text(
                      item.frDate.toString() ?? '--',
                      style: TextStyle(color: Colors.black),
                    ))),
                DataCell(Center(
                    child: Text(
                      item.toDate.toString() ?? '--',
                      style: TextStyle(color: Colors.black),
                    ))),
                DataCell(
                  Center(
                    child: InkWell(
                        onTap: () {
                          _edit(noticeSeq: item.noticeSeq.toString());
                        },
                        child: Icon(Icons.edit)
                    ),
                  ),
                ),
              ]);
            }).toList(),
            columns: <DataColumn>[
              DataColumn(label: Expanded(child: Text('순번', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('게시제목', textAlign: TextAlign.left)),),
              DataColumn(label: Expanded(child: Text('게시유무', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('구분', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('게시시작일', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('게시종료일', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('관리', textAlign: TextAlign.center)),),
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
                Text('페이지당 행 수 : ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),),
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
      ),
    );
  }

  String _getNoticeGbn(String value) {
    String retValue = '--';

    if (value.toString().compareTo('1') == 0)      retValue = '공지';
    else if (value.toString().compareTo('2') == 0) retValue = '공지(사장님)';
    else if (value.toString().compareTo('3') == 0) retValue = '이벤트';
    else if (value.toString().compareTo('4') == 0) retValue = '이벤트(사장님)';
    else if (value.toString().compareTo('5') == 0) retValue = '메인팝업';
    else if (value.toString().compareTo('6') == 0) retValue = '메인팝업(사장님)';
    else if (value.toString().compareTo('7') == 0) retValue = '시정홍보';


    return retValue;
  }
}
