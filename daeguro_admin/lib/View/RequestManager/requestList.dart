import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_input.dart';
import 'package:daeguro_admin_app/Model/serviceRequestGbn.dart';
import 'package:daeguro_admin_app/Model/requestListModel.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Model/serviceRequestSetStatusModel.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/AgentManager/agentAccount_Controller.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/RequestManager/requestListDetail_100.dart';
import 'package:daeguro_admin_app/View/RequestManager/requestListDetail_200.dart';
import 'package:daeguro_admin_app/View/RequestManager/requestListDetail_201.dart';
import 'package:daeguro_admin_app/View/RequestManager/requestListDetail_300.dart';
import 'package:daeguro_admin_app/View/RequestManager/requestListDetail_301.dart';
import 'package:daeguro_admin_app/View/RequestManager/requestManager_controller.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccountList.dart';
import 'package:daeguro_admin_app/constants/constant.dart';

import 'package:date_format/date_format.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class RequestList extends StatefulWidget {
  const RequestList({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RequestListState();
  }
}

class RequestListState extends State<RequestList> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final List<RequestListModel> dataList = <RequestListModel>[];
  List MCodeListitems = List();
  List<SelectOptionVO> ServiceGbnItems = [];

  ServiceRequestSetStatusModel saveStatusData;

  String _divKey = '1';

  bool chkCancelPass = false;

  String _ServiceGbn = ' ';
  String _Status = ' ';
  String _CancelReqYn = ' ';

  //int rowsPerPage = 10;

  String _mCode = '2';

  int _totalRowCnt = 0;
  int _selectedpagerows = 15;

  int _currentPage = 1;
  int _totalPages = 0;

  bool isAutoUpdate = false;

  SearchItems _searchItems = new SearchItems();

  void _pageMove(int _page) {
    _query();
  }

  _reset() {
    _searchItems = null;
    _searchItems = new SearchItems();
    _searchItems.startdate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', '01']);
    _searchItems.enddate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    //formKey.currentState.reset();
    //loadData();
  }

  _query() {
    //formKey.currentState.save();
    // if (_searchItems.startdate != _searchItems.enddate && _searchItems.name == '') {
    //   ISAlert(context, '시작일, 종료일이 다를 경우\n검색 키워드를 입력 해야 합니다.');
    //   return;
    // }

    loadData();
  }

  _detail({String seq, String service_gbn_code}) async {
    Widget _showDialog;

    if (service_gbn_code == '100') {
      _showDialog = RestListDetail_100(seq: seq);
    }
    else if (service_gbn_code == '201') {
      _showDialog = RestListDetail_201(seq: seq);
    }
    else if (service_gbn_code == '200') {
      _showDialog = RestListDetail_200(seq: seq);
    }
    else if (service_gbn_code == '301') {
      _showDialog = RestListDetail_301(seq: seq);
    }
    else if (service_gbn_code == '300') {
      _showDialog = RestListDetail_300(seq: seq);
    }
    else {
      _showDialog = RestListDetail_100(seq: seq);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(child: _showDialog),
    ).then((v) async {
      await Future.delayed(Duration(milliseconds: 500), () {
        _query();
      });
    });
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

  loadServiceGbnListData() async {
    ServiceGbnItems.clear();

    await RequestController.to.getServiceGbnItems().then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        ServiceGbnItems.add(new SelectOptionVO(value: ' ', label: '전체', label2: ''));

        // 오퍼레이터 바인딩
        value.forEach((element) {
          ServiceRequestGbn tempData = ServiceRequestGbn.fromJson(element);

          ServiceGbnItems.add(new SelectOptionVO(
            value: tempData.CODE,
            label: tempData.CODE_NM,
            label2: tempData.CODE_NM,
          ));
        });
      }
    });

    if (this.mounted) {
      setState(() {});
    }
  }

  loadData() async {
    await RequestController.to
        .getData(_mCode, _ServiceGbn, _Status, '', _CancelReqYn, _currentPage.round().toString(), _selectedpagerows.toString(),
            _searchItems.startdate.replaceAll('-', '').toString(), _searchItems.enddate.replaceAll('-', '').toString())
        .then((value) {
      if (this.mounted) {
        if (value == null) {
          ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
        } else {
          setState(() {
            dataList.clear();

            value.forEach((e) {
              RequestListModel temp = RequestListModel.fromJson(e);

              temp.INSERT_DATE = temp.INSERT_DATE.replaceAll('T', ' ');
              dataList.add(temp);
            });

            _totalRowCnt = RequestController.to.totalRowCnt;
            _totalPages = (_totalRowCnt / _selectedpagerows).ceil();
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();

    Get.put(RequestController());
    Get.put(AgentController());

    WidgetsBinding.instance.addPostFrameCallback((c) {
      loadMCodeListData();
      loadServiceGbnListData();
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
    ServiceGbnItems.clear();

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
      child: Container(
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
                ISSearchDropdown(
                  label: '상태',
                  width: 150,
                  value: _Status,
                  onChange: (value) {
                    setState(() {
                      _Status = value;
                      _currentPage = 1;
                      _query();
                    });
                  },
                  item: [
                    DropdownMenuItem(
                      value: ' ',
                      child: Text('전체'),
                    ),
                    DropdownMenuItem(
                      value: '10',
                      child: Text('접수(요청)'),
                    ),
                    DropdownMenuItem(
                      value: '30',
                      child: Text('진행중(심사중)'),
                    ),
                    DropdownMenuItem(
                      value: '35',
                      child: Text('보완'),
                    ),
                    DropdownMenuItem(
                      value: '40',
                      child: Text('완료'),
                    ),
                    DropdownMenuItem(
                      value: '50',
                      child: Text('취소'),
                    ),
                  ].cast<DropdownMenuItem<String>>(),
                ),
                SizedBox(
                  height: 8,
                ),
                ISSearchDropdown(
                  label: '고객취소 요청 여부',
                  width: 150,
                  value: _CancelReqYn,
                  onChange: (value) {
                    setState(() {
                      _CancelReqYn = value;
                      _currentPage = 1;
                      _query();
                    });
                  },
                  item: [
                    DropdownMenuItem(
                      value: ' ',
                      child: Text('전체'),
                    ),
                    DropdownMenuItem(
                      value: 'Y',
                      child: Text('취소요청'),
                    ),
                    DropdownMenuItem(
                      value: 'N',
                      child: Text('취소 미 요청'),
                    ),
                  ].cast<DropdownMenuItem<String>>(),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.only(right: 8.0),
                  child: ISSearchDropdown(
                    label: '작업내용',
                    value: _ServiceGbn,
                    onChange: (value) {
                      setState(() {
                        _currentPage = 1;
                        _ServiceGbn = value;
                        _query();
                      });
                    },
                    width: 242,
                    item: ServiceGbnItems.map((item) {
                      return new DropdownMenuItem<String>(
                          child: new Text(
                            item.label,
                            style: TextStyle(fontSize: 13, color: Colors.black),
                          ),
                          value: item.value);
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      ISSearchInput(
                        //label: _keyWordLabel,
                        width: 250,
                        value: _searchItems.name,
                        onChange: (v) {
                          _searchItems.name = v;
                        },
                        onFieldSubmitted: (v) {
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
                      //       _searchItems.name = '';
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
                  _currentPage = 1,
                  _query(),
                }),
          ],
        ),
      ),
    );

    return Container(
      //padding: (isPoupEnabled() == true) ? EdgeInsets.only(left: 50, right: 50, bottom: 0) : EdgeInsets.only(left: 10, right: 10, bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  child: MaterialButton(
                    height: 30.0,
                    child: Text(item.SHOP_NAME.toString() == null ? '--' : item.SHOP_NAME.toString(), style: TextStyle(fontSize: 13),),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                    onPressed: () {
                      double poupWidth = 1040;
                      double poupHeight = 600;

                      showDialog(
                        context: context,
                        builder: (BuildContext context) => Dialog(
                          child: SizedBox(
                            width: poupWidth,
                            height: poupHeight,
                            child: Scaffold(
                              appBar: AppBar(
                                title: Text('요청 가맹점 [가맹점명: ${item.SHOP_NAME}]'),
                              ),
                              body: ShopAccountList(shopName: item.SHOP_NAME, popWidth: poupWidth, popHeight: poupHeight),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  alignment: Alignment.centerLeft,
                )),
                DataCell(Center(child: SelectableText(item.INSERT_DATE.toString() ?? '--', style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(
                  DropdownButton(
                    style: TextStyle(fontSize: 13, fontFamily: 'NotoSansKR', color: Colors.black),
                    onChanged: (value) async {
                      if (item.STATUS == value) return;

                      if (item.STATUS == '10') {
                        ISAlert(context, '접수상태일때는 상태변경 할 수 없습니다.');
                        return;
                      }

                      ISConfirm(context, '상태 변경', '상태변경 하시겠습니까?', (context) async {
                        Navigator.of(context).pop();

                        await RequestController.to.putServiceStatus(
                            item.SEQ.toString(), value, GetStorage().read('logininfo')['uCode'], GetStorage().read('logininfo')['name'], context);

                        await Future.delayed(Duration(milliseconds: 1000), () {
                          _query();
                        });
                      });
                    },
                    value: item.STATUS,
                    items: [
                      DropdownMenuItem(value: '10', child: Text('접수(요청)'),),
                      DropdownMenuItem(value: '30', child: Text('진행중(심사중)'),),
                      DropdownMenuItem(value: '35', child: Text('보완'),),
                      DropdownMenuItem(value: '40', child: Text('완료'),),
                      DropdownMenuItem(value: '50', child: Text('취소', style: TextStyle(color: Colors.black54),), enabled: false),
                    ].cast<DropdownMenuItem<String>>(),
                  ),
                ),
                DataCell(Align(child: SelectableText(item.SERVICE_GBN.toString() ?? '--', style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.centerLeft)),
                DataCell(Align(child: SelectableText(item.ALLOC_UNAME.toString() == 'null' ? '--' : item.ALLOC_UNAME.toString(), style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.centerLeft)),
                DataCell(Center(
                      child: ButtonBar(
                        alignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.receipt_long),
                            onPressed: () {
                              _detail(seq: item.SEQ.toString(), service_gbn_code: item.SERVICE_GBN_CODE);
                            },
                          ),
                        ],
                      )),
                ),
              ]);
            }).toList(),
            columns: <DataColumn>[
              DataColumn(label: Expanded(child: Text('상호명', textAlign: TextAlign.left)),),
              DataColumn(label: Expanded(child: Text('요청시간', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('상태', textAlign: TextAlign.left)),),
              DataColumn(label: Expanded(child: Text('작업내용', textAlign: TextAlign.left)),),
              DataColumn(label: Expanded(child: Text('작업자', textAlign: TextAlign.left)),),
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
