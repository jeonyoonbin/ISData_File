
import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_input.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Model/shop/shop_ReserListModel.dart';
import 'package:daeguro_admin_app/Network/BackendService.dart';
import 'package:daeguro_admin_app/Util/utils.dart';

import 'package:daeguro_admin_app/View/AgentManager/agentAccount_Controller.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/View/ShopManager/Reservation/shopReservationDetail.dart';
import 'package:daeguro_admin_app/constants/constant.dart';
import 'package:date_format/date_format.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:get/get.dart';

class ShopReservationList extends StatefulWidget {
  const ShopReservationList({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShopReservationListState();
  }
}

class ShopReservationListState extends State<ShopReservationList> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final List<ShopReserListModel> dataList = <ShopReserListModel>[];
  final TextEditingController _typeAheadController = TextEditingController();

  bool isSearching = false;
  String searchKeyword = '';

  SearchItems _searchItems = new SearchItems();
  String _status = 'ALL';

  String _searchGbn = '1';
  List MCodeListitems = List();
  String _shopCd = '';
  String _shopName = '';

  String _mCode = '2';
  Color _color1 = Colors.blueAccent;
  Color _color2 = Colors.black;
  Color _color3 = Colors.black;
  Color _color4 = Colors.black;
  Color _color5 = Colors.black;
  Color _color6 = Colors.black;

  //int rowsPerPage = 10;

  int _totalRowCnt = 0;
  int _selectedpagerows = 15;

  int _currentPage = 1;
  int _totalPages = 0;

  void _pageMove(int _page) {
    _query();
  }

  _reset() {
    dataList.clear();

    _searchItems = null;
    _searchItems = new SearchItems();

    _searchItems.startdate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', '01']);
    _searchItems.enddate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);

    formKey.currentState.reset();
    //loadData();
  }

  _query() {
    loadData();
  }

  loadMCodeListData() async {
    //MCodeListitems.clear();
    //MCodeListitems = await AgentController.to.getDataMCodeItems();
    //MCodeListitems = AgentController.to.qDataMCodeItems;

    MCodeListitems = Utils.getMCodeList();

    if (this.mounted) {
      setState(() {});
    }
  }

  setStatusColor(String gbn) {
    if (gbn == 'ALL') {
      _color1 = Colors.blueAccent;
      _color2 = Colors.black;
      _color3 = Colors.black;
      _color4 = Colors.black;
      _color5 = Colors.black;
      _color6 = Colors.black;
    } else if (gbn == '10') {
      _color1 = Colors.black;
      _color2 = Colors.blueAccent;
      _color3 = Colors.black;
      _color4 = Colors.black;
      _color5 = Colors.black;
      _color6 = Colors.black;
    } else if (gbn == '12') {
      _color1 = Colors.black;
      _color2 = Colors.black;
      _color3 = Colors.blueAccent;
      _color4 = Colors.black;
      _color5 = Colors.black;
      _color6 = Colors.black;
    } else if (gbn == '30') {
      _color1 = Colors.black;
      _color2 = Colors.black;
      _color3 = Colors.black;
      _color4 = Colors.blueAccent;
      _color5 = Colors.black;
      _color6 = Colors.black;
    } else if (gbn == '90') {
      _color1 = Colors.black;
      _color2 = Colors.black;
      _color3 = Colors.black;
      _color4 = Colors.black;
      _color5 = Colors.blueAccent;
      _color6 = Colors.black;
    } else if (gbn == '40') {
      _color1 = Colors.black;
      _color2 = Colors.black;
      _color3 = Colors.black;
      _color4 = Colors.black;
      _color5 = Colors.black;
      _color6 = Colors.blueAccent;
    }

    _currentPage = 1;
    _status = gbn;
    loadData();
    setState(() {});
  }

  _detail({Map data}) async {
    //await LogController.to.getDetailData(seq);

    showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          child: ShopReservationDetail(data: data, shopName: _shopName),
            ));
  }

  loadData() async {
    if (_shopCd == '') {
      ISAlert(context, '가맹점을 선택 해주십시오.');
      return;
    }

    await ISProgressDialog(context).show(status: 'Loading...');

    dataList.clear();

    await ShopController.to
        .getReserListData(_shopCd, _searchItems.startdate.replaceAll('-', '').toString(), _searchItems.enddate.replaceAll('-', '').toString(), _status,
            _searchGbn, _searchItems.code, _currentPage.toString(), _selectedpagerows.toString())
        .then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        value.forEach((e) {
          ShopReserListModel temp = ShopReserListModel.fromJson(e);

          // 신청일시
          if (temp.isrtDate == '') {
            temp.isrtDate = '--';
          } else if (int.parse(temp.isrtDate.substring(8, 12)) < 1200) {
            temp.isrtDate = Utils.getYearMonthDayFormat(temp.isrtDate.substring(0, 8)) + '\n오전 ' + Utils.getTimeFormat(temp.isrtDate.substring(8, 12));
          } else if (int.parse(temp.isrtDate.substring(8, 12)) < 1300) {
            temp.isrtDate = Utils.getYearMonthDayFormat(temp.isrtDate.substring(0, 8)) + '\n오후 ' + Utils.getTimeFormat(temp.isrtDate.substring(8, 12));
          } else {
            temp.isrtDate = Utils.getYearMonthDayFormat(temp.isrtDate.substring(0, 8)) +
                '\n오후 ' +
                Utils.getTimeFormat((int.parse(temp.isrtDate.substring(8, 12)) - 1200).toString());
          }

          // 예약확정시간
          if (temp.allocDate == '') {
            temp.allocDate = '--';
          } else if (int.parse(temp.allocDate.substring(8, 12)) < 1200) {
            temp.allocDate = Utils.getYearMonthDayFormat(temp.allocDate.substring(0, 8)) + '\n오전 ' + Utils.getTimeFormat(temp.allocDate.substring(8, 12));
          } else if (int.parse(temp.allocDate.substring(8, 12)) < 1300) {
            temp.allocDate = Utils.getYearMonthDayFormat(temp.allocDate.substring(0, 8)) + '\n오후 ' + Utils.getTimeFormat(temp.allocDate.substring(8, 12));
          } else {
            temp.allocDate = Utils.getYearMonthDayFormat(temp.allocDate.substring(0, 8)) +
                '\n오후 ' +
                Utils.getTimeFormat((int.parse(temp.allocDate.substring(8, 12)) - 1200).toString());
          }

          // 취소시간
          if (temp.cancelDate == '') {
            temp.cancelDate = '--';
          } else if (int.parse(temp.cancelDate.substring(8, 12)) < 1200) {
            temp.cancelDate = Utils.getYearMonthDayFormat(temp.cancelDate.substring(0, 8)) + '\n오전 ' + Utils.getTimeFormat(temp.cancelDate.substring(8, 12));
          } else if (int.parse(temp.cancelDate.substring(8, 12)) < 1300) {
            temp.cancelDate = Utils.getYearMonthDayFormat(temp.cancelDate.substring(0, 8)) + '\n오후 ' + Utils.getTimeFormat(temp.cancelDate.substring(8, 12));
          } else {
            temp.cancelDate = Utils.getYearMonthDayFormat(temp.cancelDate.substring(0, 8)) +
                '\n오후 ' +
                Utils.getTimeFormat((int.parse(temp.cancelDate.substring(8, 12)) - 1200).toString());
          }

          // 방문완료시간
          if (temp.compDate == '') {
            temp.compDate = '--';
          } else if (int.parse(temp.compDate.substring(8, 12)) < 1200) {
            temp.compDate = Utils.getYearMonthDayFormat(temp.compDate.substring(0, 8)) + '\n오전 ' + Utils.getTimeFormat(temp.compDate.substring(8, 12));
          } else if (int.parse(temp.compDate.substring(8, 12)) < 1300) {
            temp.compDate = Utils.getYearMonthDayFormat(temp.compDate.substring(0, 8)) + '\n오후 ' + Utils.getTimeFormat(temp.compDate.substring(8, 12));
          } else {
            temp.compDate = Utils.getYearMonthDayFormat(temp.compDate.substring(0, 8)) +
                '\n오후 ' +
                Utils.getTimeFormat((int.parse(temp.compDate.substring(8, 12)) - 1200).toString());
          }

          // 예약시간
          if (temp.reserTime == '') {
            temp.reserTime = '--';
          } else if (int.parse(temp.reserTime) < 1200) {
            temp.reserTime = '오전 ' + Utils.getTimeFormat(temp.reserTime);
          } else if (int.parse(temp.reserTime) < 1300) {
            temp.reserTime = '오후 ' + Utils.getTimeFormat(temp.reserTime);
          } else {
            temp.reserTime = '오후 ' + Utils.getTimeFormat((int.parse(temp.reserTime) - 1200).toString());
          }

          dataList.add(temp);
        });

        _totalRowCnt = ShopController.to.totalRowCnt;
        _totalPages = (_totalRowCnt / _selectedpagerows).ceil();
      }
    });

    if (this.mounted) {
      setState(() {});
    }

    await ISProgressDialog(context).dismiss();
  }

  @override
  void initState() {
    super.initState();

    Get.put(AgentController());
    Get.put(ShopController());

    WidgetsBinding.instance.addPostFrameCallback((c) {
      loadMCodeListData();
      _reset();
      //_query();
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
    super.dispose();
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
        children: <Widget>[
          Row(
            children: [
              InkWell(
                  child: Text('전체: ${Utils.getCashComma(ShopController.to.reserTotalCnt.toString())}건',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _color1)),
                  onTap: () {
                    setStatusColor('ALL');
                  }),
              Text(' || '),
              InkWell(
                  child: Text('확정대기: ${Utils.getCashComma(ShopController.to.reserStatus10.toString())}건',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _color2)),
                  onTap: () {
                    setStatusColor('10');
                  }),
              Text(' || '),
              InkWell(
                  child: Text('예약확정: ${Utils.getCashComma(ShopController.to.reserStatus12.toString())}건',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _color3)),
                  onTap: () {
                    setStatusColor('12');
                  }),
              Text(' || '),
              InkWell(
                  child: Text('방문완료: ${Utils.getCashComma(ShopController.to.reserStatus30.toString())}건',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _color4)),
                  onTap: () {
                    setStatusColor('30');
                  }),
              Text(' || '),
              InkWell(
                  child: Text('미방문: ${Utils.getCashComma(ShopController.to.reserStatus90.toString())}건',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _color5)),
                  onTap: () {
                    setStatusColor('90');
                  }),
              Text(' || '),
              InkWell(
                  child: Text('취소: ${Utils.getCashComma(ShopController.to.reserStatus40.toString())}건',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _color6)),
                  onTap: () {
                    setStatusColor('40');
                  }),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  ISSearchDropdown(
                    label: '회원사명',
                    value: _mCode,
                    onChange: (value) {
                      setState(() {
                        _currentPage = 1;
                        _mCode = value;
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
                  SizedBox(
                    height: 8,
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
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  Container(
                    width: 350,
                    height: 40,
                    padding: EdgeInsets.only(left: 5),
                    child: TypeAheadFormField(
                      textFieldConfiguration: TextFieldConfiguration(
                        //focusNode: searchBoxFocusNode,
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.black, fontSize: 13.0),
                        decoration: InputDecoration(
                            fillColor: Colors.grey[200],
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: const BorderRadius.all(Radius.circular(6)),
                            ),
                            hintText: '가맹점 검색...',
                            hintStyle: TextStyle(color: Colors.black54),
                            contentPadding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
                            suffixIcon: InkWell(
                              child: Icon(
                                Icons.cancel,
                                size: 16,
                                color: Colors.grey,
                              ),
                              onTap: () {
                                if (_typeAheadController == null /* || _typeAheadController.text.isEmpty*/) {
                                  return;
                                }
                                disableSearching(); //clearSearchKeyword();
                              },
                            )),
                        controller: this._typeAheadController,
                      ),
                      suggestionsCallback: (pattern) async {
                        return await BackendService.getCopyMenuShopSuggestions(_mCode, pattern);
                      },
                      itemBuilder: (context, Map<String, String> suggestion) {
                        return ListTile(
                          title: Text(
                            '[' + suggestion['shopCd'] + '] ' + suggestion['shopName'],
                            style: TextStyle(fontSize: 14),
                          ),
                          //subtitle: Text('\$${suggestion['shopCd']}'),
                        );
                      },
                      transitionBuilder: (context, suggstionsBox, controller) {
                        return suggstionsBox;
                      },
                      onSuggestionSelected: (Map<String, String> suggestion) async {
                        clearSearchKeyword();
                        _shopCd = suggestion['shopCd'].toString();
                        _shopName = suggestion['shopName'].toString();
                        updateSearchKeyword(suggestion['shopName'].toString());
                        //clearSearchKeyword();
                      },
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 8.0),
                        child: ISSearchDropdown(
                          label: '조회 조건',
                          width: 150,
                          value: _searchGbn,
                          onChange: (value) {
                            setState(() {
                              _searchGbn = value;
                              _currentPage = 1;
                            });
                          },
                          item: [
                            DropdownMenuItem(
                              value: '1',
                              child: Text('전체'),
                            ),
                            DropdownMenuItem(
                              value: '3',
                              child: Text('예약번호'),
                            ),
                            DropdownMenuItem(
                              value: '5',
                              child: Text('이름/전화번호'),
                            ),
                          ].cast<DropdownMenuItem<String>>(),
                        ),
                      ),
                      Container(
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            ISSearchInput(
                              width: 200,
                              value: _searchItems.code,
                              onChange: (v) {
                                _searchItems.code = v;
                              },
                              onFieldSubmitted: (value) {
                                _currentPage = 1;
                                _query();
                              },
                            ),
                            // Container(
                            //   margin: EdgeInsets.fromLTRB(0, 15, 15, 0),
                            //   child: IconButton(
                            //     splashRadius: 15,
                            //     icon: Icon(Icons.close),
                            //     color: Colors.black54,
                            //     iconSize: 20,
                            //     onPressed: () {
                            //       _searchItems.code = '';
                            //       setState(() {});
                            //     },
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ISSearchButton(
                  label: '조회',
                  iconData: Icons.search,
                  onPressed: () => {
                        if (EasyLoading.isShow != true) {_currentPage = 1, _query()}
                      }),
            ],
          ),
        ],
      ),
    );

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          form,
          buttonBar,
          Divider(),
          ISDatatable(
            panelHeight: (MediaQuery.of(context).size.height - defaultContentsHeight) - 48,
            listWidth: Responsive.getResponsiveWidth(context, 720),
            rows: dataList.map((item) {
              return DataRow(cells: [
                DataCell(Align(
                  child: SelectableText(item.orderNo.toString(), showCursor: true),
                  alignment: Alignment.center,
                )),
                DataCell(Align(
                  child: SelectableText(item.isrtDate, showCursor: true, style: TextStyle(fontSize: 12)),
                  alignment: Alignment.center,
                )),
                DataCell(Align(
                  child: SelectableText(Utils.getYearMonthDayFormat(item.reserDate) + '\n' + item.reserTime, showCursor: true, style: TextStyle(fontSize: 12)),
                  alignment: Alignment.center,
                )),
                DataCell(Align(
                  child: SelectableText(item.allocDate, showCursor: true, style: TextStyle(fontSize: 12)),
                  alignment: Alignment.center,
                )),
                DataCell(Align(
                  child: SelectableText(item.compDate, showCursor: true, style: TextStyle(fontSize: 12)),
                  alignment: Alignment.center,
                )),
                DataCell(Align(
                  child: SelectableText(item.cancelDate, showCursor: true, style: TextStyle(fontSize: 12)),
                  alignment: Alignment.center,
                )),
                DataCell(Align(
                  child: SelectableText(_setStatus(item.status.toString()), showCursor: true),
                  alignment: Alignment.center,
                )),
                DataCell(Align(
                  child: SelectableText('[' + Utils.getNameAbsoluteFormat(item.custName.toString(), true) + '] ' + Utils.getPhoneNumFormat(item.custTelno, true), showCursor: true),
                  alignment: Alignment.centerLeft,
                )),
                DataCell(Align(
                  child: SelectableText(item.memo ?? '--', showCursor: true),
                  alignment: Alignment.centerLeft,
                )),
                DataCell(Align(
                  child: SelectableText(item.location.toString(), showCursor: true),
                  alignment: Alignment.centerLeft,
                )),
                DataCell(
                  Center(
                    child: InkWell(
                        onTap: () {
                          _detail(data: item.toJson());
                        },
                        child: Icon(Icons.receipt_long)),
                  ),
                ),
              ]);
            }).toList(),
            columns: <DataColumn>[
              DataColumn(label: Expanded(child: SelectableText('예약번호', textAlign: TextAlign.center))),
              DataColumn(label: Expanded(child: SelectableText('신청 일시', textAlign: TextAlign.center))),
              DataColumn(label: Expanded(child: SelectableText('예약 일시', textAlign: TextAlign.center))),
              DataColumn(label: Expanded(child: SelectableText('예약확정 시간', textAlign: TextAlign.center))),
              DataColumn(label: Expanded(child: SelectableText('방문완료 시간', textAlign: TextAlign.center))),
              DataColumn(label: Expanded(child: SelectableText('취소 시간', textAlign: TextAlign.center))),
              DataColumn(label: Expanded(child: SelectableText('상태', textAlign: TextAlign.center))),
              DataColumn(label: Expanded(child: SelectableText('예약자 정보', textAlign: TextAlign.left))),
              DataColumn(label: Expanded(child: SelectableText('예약 정보', textAlign: TextAlign.left))),
              DataColumn(label: Expanded(child: SelectableText('요청 사항', textAlign: TextAlign.left))),
              DataColumn(label: Expanded(child: SelectableText('상세', textAlign: TextAlign.center))),
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
                  child: Text(_currentPage.toInt().toString() + ' / ' + _totalPages.toString(),
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
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
            child: Responsive.isMobile(context)
                ? Container(height: 48)
                : Row(
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
      ),
    );
  }

  void disableSearching() {
    clearSearchKeyword();

    setState(() {
      isSearching = false;
    });
  }

  void clearSearchKeyword() {
    setState(() {
      _typeAheadController.clear();
      updateSearchKeyword('');
    });
  }

  void updateSearchKeyword(String newKeyword) {
    setState(() {
      searchKeyword = newKeyword;
      _typeAheadController.text = searchKeyword;
    });
  }

  String _setStatus(String value) {
    String retValue = '--';

    if (value.toString().compareTo('10') == 0)
      retValue = '확정대기';
    else if (value.toString().compareTo('12') == 0)
      retValue = '예약확정';
    else if (value.toString().compareTo('30') == 0)
      retValue = '방문완료';
    else if (value.toString().compareTo('40') == 0)
      retValue = '취소';
    else if (value.toString().compareTo('90') == 0)
      retValue = '미방문';
    else
      retValue = '--';

    return retValue;
  }
}
