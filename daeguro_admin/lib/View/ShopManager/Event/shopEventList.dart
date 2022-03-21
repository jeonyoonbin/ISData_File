import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_input.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Model/shop/shop_eventListModel.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/Util/utils.dart';

import 'package:daeguro_admin_app/View/AgentManager/agentAccount_Controller.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/ShopManager/Event/shopEventMenu.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/View/ShopManager/Event/shopEventHistory.dart';
import 'package:daeguro_admin_app/constants/constant.dart';
import 'package:date_format/date_format.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';


class ShopEventList extends StatefulWidget {
  const ShopEventList({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShopEventListState();
  }
}

class ShopEventListState extends State<ShopEventList> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final List<ShopEventListModel> dataList = <ShopEventListModel>[];

  SearchItems _searchItems = new SearchItems();
  String _State = ' ';
  List MCodeListitems = List();

  String _mCode = '2';

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

    //formKey.currentState.reset();
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

  _EventMenuList(String shopcode) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: ShopEventMenu(shopCode: shopcode),
      ),
    ).then((v) async {
      if (v != null) {
        await Future.delayed(Duration(milliseconds: 500), () {
          _query();
        });
      }
    });
  }

  _History(String shopcode) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: ShopEventHistory(shopCode: shopcode),
      ),
    ).then((v) async {
      if (v != null) {
        await Future.delayed(Duration(milliseconds: 500), () {
          _query();
        });
      }
    });
  }

  loadData() async {
    await ISProgressDialog(context).show(status: 'Loading...');

    dataList.clear();

    await ShopController.to.getshopeventlist(_mCode, _searchItems.code, _State, _searchItems.startdate.toString(), _searchItems.enddate.toString(), _currentPage.round().toString(), _selectedpagerows.toString()).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        value.forEach((e) {
          ShopEventListModel temp = ShopEventListModel.fromJson(e);
          temp.selected = false;

          temp.FROM_TIME = temp.FROM_TIME.toString().substring(0, 4) +
              '-' + temp.FROM_TIME.toString().substring(4, 6) +
              '-' + temp.FROM_TIME.toString().substring(6, 8) +
              ' ' + temp.FROM_TIME.toString().substring(8, 10) +
              ':' + temp.FROM_TIME.toString().substring(10, 12);

          temp.TO_TIME = temp.TO_TIME.toString().substring(0, 4) +
              '-' + temp.TO_TIME.toString().substring(4, 6) +
              '-' + temp.TO_TIME.toString().substring(6, 8) +
              ' ' + temp.TO_TIME.toString().substring(8, 10) +
              ':' + temp.TO_TIME.toString().substring(10, 12);

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
              Text('총: ${Utils.getCashComma(ShopController.to.totalRowCnt.toString())}건', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
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
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 8.0),
                    child: ISSearchDropdown(
                      label: '상태',
                      width: 192,
                      value: _State,
                      onChange: (value) {
                        setState(() {
                          _State = value;
                          _currentPage = 1;
                          _query();
                        });
                      },
                      item: [
                        DropdownMenuItem(value: ' ', child: Text('전체'),),
                        DropdownMenuItem(value: '1', child: Text('예정'),),
                        DropdownMenuItem(value: '2', child: Text('진행'),),
                        DropdownMenuItem(value: '3', child: Text('종료'),),
                      ].cast<DropdownMenuItem<String>>(),
                    ),
                  ),
                  SizedBox(height: 8,),
                  Container(
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        ISSearchInput(
                          label: '가맹점명',
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
            panelHeight: (MediaQuery.of(context).size.height-defaultContentsHeight) - 48,
            listWidth: Responsive.getResponsiveWidth(context, 640),
            rows: dataList.map((item) {
              return DataRow(cells: [
                DataCell(Align(child: SelectableText(item.SHOP_NAME.toString() == null ? '--' : '[' + item.SHOP_CD.toString() + '] ' + item.SHOP_NAME.toString(), showCursor: true), alignment: Alignment.centerLeft,)),
                DataCell(Align(child: SelectableText(item.INS_DATE.toString().replaceAll('T', ' '), showCursor: true), alignment: Alignment.center,)),
                DataCell(Align(child: SelectableText(item.FROM_TIME.toString(), showCursor: true), alignment: Alignment.center,)),
                DataCell(Align(child: SelectableText(item.TO_TIME.toString(), showCursor: true), alignment: Alignment.center,)),
                DataCell(Align(child: SelectableText(item.STATE.toString(), showCursor: true), alignment: Alignment.center,)),
                DataCell(Align(child: SelectableText(item.EVENT_TITLE_M.toString(), showCursor: true), alignment: Alignment.centerLeft,)),

                if (AuthUtil.isAuthReadEnabled('118') == true)
                DataCell(
                  Center(
                      child: Container(
                        //color: Colors.red,
                        child: IconButton(
                          //padding: EdgeInsets.only(top: 20),
                          onPressed: () {
                            _EventMenuList(item.SHOP_CD);
                          },
                          icon: Icon(Icons.restaurant_menu, color: Colors.blue, size: 20,),
                          tooltip: '이벤트 메뉴',
                        ),
                      )),
                ),

                if (AuthUtil.isAuthReadEnabled('119') == true)
                DataCell(
                  Center(
                      child: Container(
                        //color: Colors.red,
                        child: IconButton(
                          //padding: EdgeInsets.only(top: 20),
                          onPressed: () {
                            _History(item.SHOP_CD);
                          },
                          icon: Icon(Icons.history, color: Colors.blue, size: 20,),
                          tooltip: '변경 이력',
                        ),
                      )),
                ),
              ]);
            }).toList(),
            columns: <DataColumn>[
              DataColumn(label: Expanded(child: SelectableText('가맹점명', textAlign: TextAlign.center))),
              DataColumn(label: Expanded(child: SelectableText('등록시간', textAlign: TextAlign.center))),
              DataColumn(label: Expanded(child: SelectableText('시작시간', textAlign: TextAlign.center))),
              DataColumn(label: Expanded(child: SelectableText('종료시간', textAlign: TextAlign.center))),
              DataColumn(label: Expanded(child: SelectableText('진행상태', textAlign: TextAlign.center))),
              DataColumn(label: Expanded(child: SelectableText('이벤트 제목', textAlign: TextAlign.left))),
              if (AuthUtil.isAuthReadEnabled('118') == true)
              DataColumn(label: Expanded(child: SelectableText('이벤트 메뉴', textAlign: TextAlign.center))),
              if (AuthUtil.isAuthReadEnabled('119') == true)
              DataColumn(label: Expanded(child: SelectableText('변경이력', textAlign: TextAlign.center))),
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
}
