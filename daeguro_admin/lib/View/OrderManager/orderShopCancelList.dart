import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Model/shop/shop_ordercancelList.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/HistoryManager/historyShopCancelDetail.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccountList.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/constants/constant.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class OrderShopCancelList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OrderShopCancelListState();
  }
}

class OrderShopCancelListState extends State {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final List<ShopOrderCancelListModel> dataList = <ShopOrderCancelListModel>[];

  SearchItems _searchItems = new SearchItems();

  List<SelectOptionVO> selectBox_Gungu = [];
  String current_Gungu;

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

    _searchItems.startdate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    _searchItems.enddate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
  }

  _query() {
    startDate = _searchItems.startdate.replaceAll('-', '');
    endDate = _searchItems.enddate.replaceAll('-', '');

    loadData();
  }

  loadGunguData(String sido) async {

    selectBox_Gungu.clear();

    await ShopController.to.getGunguData(sido).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        selectBox_Gungu.add(new SelectOptionVO(value: ' ', label: '전체'));

        int idx = 0;
        value.forEach((e) async {
          //ShopSectorAddress tempData = ShopSectorAddress.fromJson(e);

          selectBox_Gungu.add(new SelectOptionVO(value: e['gunGuName'], label: e['gunGuName']));

          // if (idx == 0) {
          //   current_Gungu = e['gunGuName'].toString();
          // }

          idx++;
        });
      }
    });

    setState(() {});
  }

  loadData() async {
    await ISProgressDialog(context).show(status: 'Loading...');

    dataList.clear();

    await ShopController.to.getShopOrderCancelListData(_searchItems.pos_yn, current_Gungu,  startDate, endDate, _currentPage.round().toString(), _selectedpagerows.toString()).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        setState(() {
          value.forEach((e) {
            ShopOrderCancelListModel temp = ShopOrderCancelListModel.fromJson(e);
            temp.selected = false;
            temp.telNo = Utils.getPhoneNumFormat(temp.telNo.toString(), true);

            dataList.add(temp);
          });

          _totalRowCnt = ShopController.to.totalRowCnt;
          _totalPages = (_totalRowCnt / _selectedpagerows).ceil();
        });
      }
    });

    await ISProgressDialog(context).dismiss();
  }

  @override
  void initState() {
    super.initState();

    Get.put(ShopController());

    WidgetsBinding.instance.addPostFrameCallback((c) {
      _reset();
      loadGunguData('대구광역시');
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
                    label: 'POS상태',
                    width: 120,
                    value: _searchItems.pos_yn,
                    onChange: (value) {
                      setState(() {
                        _searchItems.pos_yn = value;
                      });
                    },
                    item: [
                      DropdownMenuItem(
                        value: ' ',
                        child: Text('전체'),
                      ),
                      DropdownMenuItem(
                        value: 'Y',
                        child: Text('설치'),
                      ),
                      DropdownMenuItem(
                        value: 'N',
                        child: Text('미설치'),
                      ),
                    ].cast<DropdownMenuItem<String>>(),
                  ),
                  SizedBox(height: 8,),
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
                ],
              ),
              Column(
                children: [
                  ISSearchDropdown(
                    label: '군구별',
                    width: 120,
                    value: current_Gungu ?? '',
                    onChange: (value) {
                      setState(() {
                        current_Gungu = value;
                      });
                    },
                    item: selectBox_Gungu.map((item) {
                      return new DropdownMenuItem<String>(
                          child: new Text(item.label, style: TextStyle(fontSize: 13, color: Colors.black),),
                          value: item.value);
                    }).toList(),
                  ),
                  SizedBox(height: 8,),
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
              SizedBox(width: 8),
              Column(
                children: [
                  ISSearchButton(
                      label: '조회',
                      iconData: Icons.search,
                      onPressed: () => {_currentPage = 1, _query()}),
                ],
              )
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
          form,
          buttonBar,
          Divider(),
          ISDatatable(
            panelHeight: (MediaQuery.of(context).size.height-defaultContentsHeight)-48,
            listWidth: Responsive.getResponsiveWidth(context, 640),
            rows: dataList.map((item) {
              return DataRow(cells: [
                // DataCell(Align(
                //   child: SelectableText(item.shopName.toString() == null ? '--' : '[' + item.shopCd.toString() + '] ' + item.shopName.toString(), showCursor: true),
                //   alignment: Alignment.centerLeft,
                // )),
                DataCell(Align(
                    child: MaterialButton(
                      height: 30.0,
                      child: Text(item.shopName.toString() == null ? '--' : '['+ item.shopCd.toString() +'] '+item.shopName.toString(), style: TextStyle(color: Colors.black, fontSize: 13)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                      onPressed: ()  {
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
                                  title: Text('주문취소 가맹점 - [${item.shopCd}] ${item.shopName}'),
                                ),
                                body: ShopAccountList(shopName: item.shopName, popWidth: poupWidth, popHeight: poupHeight),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                    , alignment: Alignment.centerLeft
                )
                ),
                DataCell(Align(child: Text(item.telNo.toString() ?? '--', style: TextStyle(color: Colors.black),), alignment: Alignment.center)),
                DataCell(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
                          child: item.posInstall.toString() == 'Y'
                              ? Icon(Icons.radio_button_unchecked, color: Colors.blue, size: 16)
                              : Icon(Icons.clear, color: Colors.grey.shade400, size: 16)),
                      Text('/'),
                      Center(
                          child: item.posLogin.toString() == 'Y'
                              ? Center(
                              child: item.loginTime.toString() == ''
                                  ? Icon(Icons.radio_button_unchecked, color: Colors.blue, size: 16)
                                  : Tooltip(
                                child: Icon(Icons.radio_button_unchecked, color: Colors.blue, size: 16),
                                message: item.loginTime,
                                textStyle: TextStyle(fontSize: 12, color: Colors.white),
                                padding: EdgeInsets.all(5),
                              )
                          ) : Icon(Icons.clear, color: Colors.grey.shade400, size: 16))
                    ],
                  ),
                ),
                DataCell(Align(child: Text(item.lastCancelTime.toString() ?? '--', style: TextStyle(color: Colors.black),), alignment: Alignment.center)),
                //DataCell(Align(child: Text('10' ?? '--', style: TextStyle(color: Colors.black),), alignment: Alignment.center)),
                DataCell(Align(child: (item.cancelCnt.toString() == null || item.cancelCnt.toString() == 'null') ? Container() : MaterialButton(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  child: Text(item.cancelCnt.toString(), style: TextStyle(fontSize: 13, color: Colors.white)),
                  onPressed: () {
                    double poupWidth = 800;
                    double poupHeight = 600;
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                        child: SizedBox(
                          width: poupWidth,
                          height: poupHeight,
                          child: Scaffold(
                              appBar: AppBar(
                                title: Text('주문취소 내역 - [${item.shopCd}] ${item.shopName}'),
                              ),
                              body: HistoryShopCancelDetail(shopCd: item.shopCd, shopName: item.shopName, startDate: startDate, endDate: endDate, gbn: 'N', popWidth: poupWidth, popHeight: poupHeight)
                          ),
                        ),
                      ),
                    ).then((v) async {
                    });
                  },
                ), alignment: Alignment.center),
                ),
                DataCell(Center(
                    child: item.absentYn.toString() == 'N'
                        ? Icon(Icons.radio_button_unchecked, color: Colors.blue, size: 16)
                        : Icon(Icons.clear, color: Colors.grey.shade400, size: 16))),
                DataCell(Align(child: Text(item.totalCnt.toString() ?? '--', style: TextStyle(color: Colors.black),), alignment: Alignment.center)),

              ]);
            }).toList(),
            columns: <DataColumn>[
              DataColumn(label: Expanded(child: Text('가맹점명', textAlign: TextAlign.center)), ),
              DataColumn(label: Expanded(child: Text('상점전화', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('POS상태\n(설치/로그인)', textAlign: TextAlign.center, style: TextStyle(fontSize: 12))),),
              DataColumn(label: Expanded(child: Text('최종 취소 시간', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('취소건수', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('휴점', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('총 주문건수', textAlign: TextAlign.center)),),
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
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
                      child: Text(
                          _currentPage.toInt().toString() +
                              ' / ' +
                              _totalPages.toString(),
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center),
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
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
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
          )
        ],
      ),
    );
  }
}
