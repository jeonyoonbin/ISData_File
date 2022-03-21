import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/Model/review/reviewDetailModel.dart';
import 'package:daeguro_admin_app/Model/review/reviewListModel.dart';
import 'package:daeguro_admin_app/Model/review/reviewReportListModel.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/CustomerManager/customerList.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/OrderManager/orderDetail.dart';
import 'package:daeguro_admin_app/View/OrderManager/orderManager_controller.dart';
import 'package:daeguro_admin_app/View/ReviewManager/reviewHistory.dart';
import 'package:daeguro_admin_app/View/ReviewManager/reviewImage.dart';
import 'package:daeguro_admin_app/View/ReviewManager/reviewManager_controller.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccountList.dart';
import 'package:daeguro_admin_app/constants/constant.dart';

import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_input.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';

import 'package:daeguro_admin_app/View/AgentManager/agentAccount_Controller.dart';
import 'package:date_format/date_format.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'dart:async';

class ReviewList extends StatefulWidget {
  const ReviewList({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ReviewListState();
  }
}

class ReviewListState extends State<ReviewList>  with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  SearchItems _searchItems = new SearchItems();

  final ScrollController _scrollController = ScrollController();

  final List<reviewListModel> dataList = <reviewListModel>[];

  final List<reviewReportListModel> dataReportList = <reviewReportListModel>[];

  final List<reviewDetailModel> dataDetail = <reviewDetailModel>[];

  List items = List();
  List CCenterListitems = List();
  List MCodeListitems = List();

  String _mCode = '2';

  String _codeNm = '';
  String _bliendReason = '';
  String _allocUname = '';
  String _blindEndDt = '';

  String _detailConten_text = ' ';
  String _detailAnswer_text = ' ';
  String _detailMemo_text = ' ';
  String _selSeq = '';
  String _visibleGbn = 'A';
  String _blindYn = null;
  String _tab = ' ';
  String _divKey = '1';

  //int rowsPerPage = 10;

  int _totalRowCnt = 0;
  int _selectedpagerows = 15;

  int _currentPage = 1;
  int _totalPages = 0;

  String nSelectedShopTitle = '';
  String nSelectedShopName = '';
  String nSelectedOrderTitle = '';
  String nSelectedOrderSeq = '';
  String nSelectedCustInfo = '';
  String nSelectedCustCode = '';

  void _pageMove(int _page) {
    _query();
  }

  _ImageDetail({String shop_cd, int seq, String service_gbn}) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: ReviewImage(shop_cd: shop_cd, seq: seq),
      ),
    );
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

  _ShopMemoHitory() {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: ReviewHistory(seq: _selSeq),
      ),
    ).then((v) async {});
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

  loadData() async {
    await ISProgressDialog(context).show(status: 'Loading...');

    await ReviewController.to.getData(_mCode, '', _tab, _divKey, _searchItems.name, _searchItems.startdate.replaceAll('-', '').toString(),
        _searchItems.enddate.replaceAll('-', '').toString(), _currentPage.round().toString(), _selectedpagerows.toString())
        .then((value) {
      if (this.mounted) {
        if (value == null) {
          ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
        } else {
          setState(() {
            dataList.clear();
            dataReportList.clear();
            dataDetail.clear();

            _blindYn = null;
            _selSeq = '';
            _visibleGbn = 'A';
            _detailConten_text = '';
            _detailAnswer_text = '';
            _detailMemo_text = '';

            value.forEach((e) {
              reviewListModel temp = reviewListModel.fromJson(e);

              temp.INSERT_DATE = temp.INSERT_DATE.replaceAll('T', ' ');
              dataList.add(temp);
            });

            nSelectedShopTitle = '';
            nSelectedShopName = '';
            nSelectedOrderTitle = '';
            nSelectedOrderSeq = '';
            nSelectedCustInfo = '';
            nSelectedCustCode = '';
            // dataList[0].selected = true;
            // nSelectedShopTitle = '[${dataList[0].SHOP_CD}] ${dataList[0].SHOP_NAME}';

            _totalRowCnt = ReviewController.to.totalRowCnt;
            _totalPages = (_totalRowCnt / _selectedpagerows).ceil();
          });
        }
      }
    });

    await ISProgressDialog(context).dismiss();
  }

  loadReportList(String seq) async {
    await ReviewController.to.getReportList(seq, context).then((value) {
      if (this.mounted) {
        if (value == null) {
          ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
        } else {
          setState(() {
            dataReportList.clear();

            value.forEach((e) {
              reviewReportListModel temp = reviewReportListModel.fromJson(e);

              temp.INSERT_DATE = temp.INSERT_DATE.replaceAll('T', ' ');
              dataReportList.add(temp);
            });
          });
        }
      }
    });
  }

  loadDetail(String seq) async {
    await ReviewController.to.getDetail(seq, context).then((value) {
      if (this.mounted) {
        if (value == null) {
          ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
        } else {
          setState(() {
            dataDetail.clear();

            _codeNm = value['CODE_NM'];
            _bliendReason = value['BLIEND_REASON'];
            _allocUname = value['ALLOC_UNAME'];
            _blindEndDt = value['BLIND_END_DT'];
            _detailConten_text = value['CONTENT_TEXT'];
            _detailAnswer_text = value['ANSWER_TEXT'];
            _detailMemo_text = value['MEMO'];
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();

    Get.put(ReviewController());
    Get.put(AgentController());
    Get.put(OrderController());

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

    _scrollController.dispose();

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
              Text(
                '총: ${Utils.getCashComma(ReviewController.to.totalRowCnt.toString())}건',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
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
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ISSearchDropdown(
                        label: '공개구분',
                        width: 200,
                        value: _tab,
                        onChange: (value) {
                          setState(() {
                            _tab = value;
                            _currentPage = 1;
                            _query();
                          });
                        },
                        item: [
                          DropdownMenuItem(value: ' ', child: Text('전체 (신고많은순 정렬)'),),
                          DropdownMenuItem(value: '1', child: Text('블라인드 요청'),),
                        ].cast<DropdownMenuItem<String>>(),
                      ),
                      ISSearchDropdown(
                        label: '검색조건',
                        width: 100,
                        value: _divKey,
                        onChange: (value) {
                          setState(() {
                            _divKey = value;
                            _currentPage = 1;
                            _query();
                          });
                        },
                        item: [
                          DropdownMenuItem(value: '1', child: Text('리뷰내용'),),
                          DropdownMenuItem(value: '2', child: Text('전화번호'),),
                          DropdownMenuItem(value: '3', child: Text('가맹점명'),),
                          DropdownMenuItem(value: '4', child: Text('주문번호'),),
                        ].cast<DropdownMenuItem<String>>(),
                      ),
                    ],
                  ),
                  SizedBox(height: 8,),
                  ISSearchInput(
                    //label: _keyWordLabel,
                    width: 308,
                    value: _searchItems.name,
                    onChange: (v) {
                      _searchItems.name = v;
                    },
                    onFieldSubmitted: (v) {
                      _currentPage = 1;
                      _query();
                    },
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
          ),
        ],
      ),
    );

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          form,
          buttonBar,
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: getListMainPanelWidth(),
                height: (MediaQuery.of(context).size.height-190),
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: Colors.black26, offset: Offset(2.0, 2.0), blurRadius: 4.0),
                  ],
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    ISDatatable(
                      controller: _scrollController,
                      panelHeight: (MediaQuery.of(context).size.height-255),
                      listWidth: 1200,//Responsive.getResponsiveWidth(context, 640),
                      //showCheckboxColumn: (widget.shopName == null) ? true : false,
                      rows: dataList.map((item) {
                        return DataRow(
                            selected: item.selected ?? false,
                            color: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
                              if (item.selected == true) {
                                return Colors.grey.shade200;
                                //return Theme.of(context).colorScheme.primary.withOpacity(0.38);
                              }

                              return Theme.of(context).colorScheme.primary.withOpacity(0.00);
                            }),
                            onSelectChanged: (bool value){
                              dataList.forEach((element) {
                                element.selected = false;
                              });

                              item.selected = true;

                              loadReportList(item.ORDER_SEQNO.toString());
                              loadDetail(item.ORDER_SEQNO.toString());

                              _selSeq = item.ORDER_SEQNO.toString();
                              _visibleGbn = item.VISBLE_GBN;

                              _blindYn = item.BLIND_REQ_DT;

                              nSelectedShopTitle = '[${item.SHOP_CD}] ${item.SHOP_NAME}';

                              nSelectedShopName = '${item.SHOP_NAME}';

                              nSelectedOrderTitle = '주문:${item.ORDER_SEQNO}';
                              nSelectedOrderSeq = '${item.ORDER_SEQNO.toString()}';
                              nSelectedCustInfo = '회원:[' + item.CUST_NAME.toString() + '] ' + Utils.getPhoneNumFormat(item.TELNO, false);
                              nSelectedCustCode = item.CUST_CODE.toString();


                              setState(() {});
                            },
                            cells: [
                              DataCell(Center(child: SelectableText(item.ORDER_SEQNO.toString() ?? '--', style: TextStyle(color: Colors.black), showCursor: true))),
                              // DataCell(Align(
                              //   child: MaterialButton(
                              //     child: Text(item.ORDER_SEQNO.toString() ?? '--', style: TextStyle(color: Colors.black, fontSize: 13)),
                              //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                              //     onPressed: () async {
                              //       await OrderController.to.getDetailData(item.ORDER_SEQNO.toString(), context);
                              //       //EasyLoading.dismiss();
                              //
                              //       showDialog(
                              //         context: context,
                              //         builder: (BuildContext context) => Dialog(
                              //           child: OrderDetail(orderNo: item.ORDER_SEQNO.toString()),
                              //         ),
                              //       );
                              //     },
                              //   ),
                              //   alignment: Alignment.center,
                              // )),
                              DataCell(Align(
                                child: SelectableText(item.SHOP_NAME.toString() == null ? '--' : '[' + item.SHOP_CD.toString() + '] ' + item.SHOP_NAME.toString(),
                                    style: TextStyle(color: Colors.black, fontSize: 13), showCursor: true),
                                alignment: Alignment.centerLeft,
                              )),
                              // DataCell(Align(
                              //   child: MaterialButton(
                              //     child: Text(item.SHOP_NAME.toString() == null ? '--' : '[' + item.SHOP_CD.toString() + '] ' + item.SHOP_NAME.toString(),
                              //         style: TextStyle(color: Colors.black, fontSize: 13)),
                              //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                              //     onPressed: () {
                              //       double poupWidth = 1040;
                              //       double poupHeight = 600;
                              //
                              //       showDialog(
                              //         context: context,
                              //         builder: (BuildContext context) => Dialog(
                              //           child: SizedBox(
                              //             width: poupWidth,
                              //             height: poupHeight,
                              //             child: Scaffold(
                              //               appBar: AppBar(
                              //                 title: Text('리뷰 가맹점 - [${item.SHOP_CD}] ${item.SHOP_NAME}'),
                              //               ),
                              //               body: ShopAccountList(shopName: item.SHOP_NAME, popWidth: poupWidth, popHeight: poupHeight),
                              //             ),
                              //           ),
                              //         ),
                              //       );
                              //     },
                              //   ),
                              //   alignment: Alignment.centerLeft,
                              // )),
                              DataCell(Align(
                                child: Text(item.BLIND_REQ_DT.toString() == 'null' ? '--' : '블라인드 요청\n[' + item.BLIND_REQ_DT.toString().replaceAll('T', ' ') + ']',
                                    style: TextStyle(color: Colors.black, fontSize: 12), textAlign: TextAlign.center),
                                alignment: Alignment.center,
                              )),
                              DataCell(Align(
                                child: Text(item.STATUS.toString() == 'null' ? '--' : item.STATUS.toString(),
                                    style: TextStyle(color: Colors.black, fontSize: 12), textAlign: TextAlign.center),
                                alignment: Alignment.center,
                              )),
                              DataCell(
                                DropdownButton(
                                  isExpanded: true,
                                  style: TextStyle(fontSize: 13, fontFamily: 'NotoSansKR', color: Colors.black),
                                  onChanged: (value) async {
                                    if (AuthUtil.isAuthEditEnabled('35') == false){
                                      ISAlert(context, '변경 권한이 없습니다. \n\n관리자에게 문의 바랍니다');
                                      return;
                                    }

                                    ISConfirm(context, '공개 구분 변경', '공개 구분 변경 하시겠습니까?', (context) async {
                                      Navigator.of(context).pop();

                                      await EasyLoading.show(status: '공개 구분 변경 중..');

                                      await ReviewController.to.putSetVisible(item.ORDER_SEQNO.toString(), value, GetStorage().read('logininfo')['uCode'],
                                          GetStorage().read('logininfo')['name'], context);

                                      await Future.delayed(Duration(milliseconds: 1000), () {
                                        _query();
                                      });

                                      await EasyLoading.dismiss();
                                    });
                                  },
                                  value: item.VISBLE_GBN,
                                  //(item.STATUS == '80' || item.STATUS == '20' || item.STATUS == '35'  || item.STATUS == '50')
                                  items: [
                                    DropdownMenuItem(value: 'A', child: Text('전체 공개'),),
                                    DropdownMenuItem(value: 'B', child: Text('블라인드 처리'),),
                                    DropdownMenuItem(value: 'R', child: Text('블라인드 요청중'),),
                                  ].cast<DropdownMenuItem<String>>(),
                                ),
                              ),
                              DataCell(Align(
                                child: Text(
                                    item.BLIEND_TYPE.toString() == 'null'
                                        ? '--'
                                        : item.BLIEND_TYPE.toString() == 'R'
                                            ? '임시 블라인드'
                                            : item.BLIEND_TYPE.toString() == 'S'
                                                ? '블라인드 처리\n[상점]'
                                                : '블라인드 처리\n[어드민]',
                                    style: TextStyle(color: Colors.black, fontSize: 13),
                                    textAlign: TextAlign.center),
                                alignment: Alignment.center,
                              )),
                              DataCell(Align(
                                child: Text(
                                    item.BLIEND_AGREE_GBN.toString() == 'null' ? '--' : item.BLIEND_AGREE_GBN.toString() == 'Y' ? '동의' : '미동의',
                                    style: TextStyle(color: Colors.black, fontSize: 13),
                                    textAlign: TextAlign.center),
                                alignment: Alignment.center,
                              )),
                              DataCell(Align(child: starRating(item.STAR_RATING), alignment: Alignment.center)),
                              //DataCell(Align(child: Text(item.CONTENT.toString() ?? '--', style: TextStyle(color: Colors.black, fontSize: 13)), alignment: Alignment.centerLeft)),
                              DataCell(Align(child: SelectableText('[' + item.CUST_NAME.toString() + '] ' + Utils.getPhoneNumFormat(item.TELNO, true) ?? '--', style: TextStyle(color: Colors.black, fontSize: 13), showCursor: true), alignment: Alignment.centerLeft)),
                              DataCell(Center(child: SelectableText(item.INSERT_DATE.toString() ?? '--', style: TextStyle(color: Colors.black, fontSize: 13), showCursor: true))),
                              DataCell(Center(
                                  child: IconButton(icon: Icon(Icons.image, color: item.IMAGE_YN == 'N' ? Colors.grey.shade400 : Colors.blueAccent), onPressed: (){
                                    if(item.IMAGE_YN == 'N')
                                      return;

                                    _ImageDetail(shop_cd: item.SHOP_CD, seq: item.ORDER_SEQNO);
                                  })
                                )
                              ),
                            ]);
                      }).toList(),
                      columns: <DataColumn>[
                        DataColumn(label: Expanded(child: Text('주문번호', textAlign: TextAlign.center)),),
                        DataColumn(label: Expanded(child: Text('상호명', textAlign: TextAlign.center)),),
                        DataColumn(label: Expanded(child: Text('사장님\n블라인드 요청', style: TextStyle(fontSize: 12), textAlign: TextAlign.center)),),
                        DataColumn(label: Expanded(child: Text('상태', style: TextStyle(fontSize: 12), textAlign: TextAlign.center)),),
                        DataColumn(label: Expanded(child: Text('공개 구분', textAlign: TextAlign.center)),),
                        DataColumn(label: Expanded(child: Text('블라인드\n타입', style: TextStyle(fontSize: 12), textAlign: TextAlign.center)),),
                        DataColumn(label: Expanded(child: Text('고객\n동의 여부', style: TextStyle(fontSize: 12), textAlign: TextAlign.center)),
                        ),
                        DataColumn(label: Expanded(child: Text('별점', textAlign: TextAlign.center)),),
                        //DataColumn(label: Expanded(child: Text('리뷰내용', textAlign: TextAlign.center)),),
                        DataColumn(label: Expanded(child: Text('회원정보', textAlign: TextAlign.center)),),
                        DataColumn(label: Expanded(child: Text('등록일자', textAlign: TextAlign.center)),),
                        DataColumn(label: Expanded(child: Text('첨부\n이미지', style: TextStyle(fontSize: 12), textAlign: TextAlign.center)),),
                      ],
                    ),
                    showPagerBar(),
                  ],
                ),
              ),
              //Divider(height: 1000,),
              getDetailData(),
            ],
          ),
        ],
      ),
    );
  }

  Widget getDetailData(){
    return Container(
      width: 600,
      height: (MediaQuery.of(context).size.height-190),
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black26, offset: Offset(2.0, 2.0), blurRadius: 4.0),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Container(
                //     alignment: Alignment.centerLeft,
                //     child: Text(nSelectedShopTitle, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),)
                // ),
                MaterialButton(
                  child: Text(nSelectedShopTitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
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
                              title: Text('리뷰 가맹점 - ${nSelectedShopTitle}'),
                            ),
                            body: ShopAccountList(shopName: nSelectedShopName, popWidth: poupWidth, popHeight: poupHeight),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Row(
                  children: [
                    MaterialButton(
                      child: Text(nSelectedOrderTitle ?? '--', style: TextStyle(color: Colors.black, fontSize: 12)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                      onPressed: () async {
                        await OrderController.to.getDetailData(nSelectedOrderSeq, context);
                        //EasyLoading.dismiss();

                        showDialog(
                          context: context,
                          builder: (BuildContext context) => Dialog(
                            child: OrderDetail(orderNo: nSelectedOrderSeq),
                          ),
                        );
                      },
                    ),
                    MaterialButton(
                      height: Responsive.isDesktop(context) == true ? 40.0 : 30.0,
                      //color: Colors.lightBlue,
                      minWidth: 40,
                      child: Text(nSelectedCustInfo, style: TextStyle(color: Colors.black, fontSize: 12)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                      onPressed: ()  {
                        double poupWidth = 700;
                        double poupHeight = 600;

                        //print('회원조회:${item.CUST_CODE.toString()}');

                        showDialog(
                          context: context,
                          builder: (BuildContext context) => Dialog(
                            child: SizedBox(
                              width: poupWidth,
                              height: poupHeight,
                              child: Scaffold(
                                appBar: AppBar(
                                  title: Text('리뷰 회원 정보'),
                                ),
                                body: CustomerList(custCode: nSelectedCustCode, popWidth: poupWidth, popHeight: poupHeight),
                              ),
                            ),
                            //child: CustomerList(custTelno: item.customerTelNo),//CustomerOrder(custCode: custCode, custName: custName,),
                          ),
                        );
                      },
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: IconButton(
                        onPressed: () {
                          if(_selSeq == '')
                            return ;

                          _ShopMemoHitory();
                        },
                        icon: Icon(
                          Icons.history,
                          color: _selSeq == '' ? Colors.grey : Colors.blue,
                          size: 30,
                        ),
                        tooltip: '변경 이력',
                      ),
                    ),
                  ],
                )
              ],
            ),
            Divider(),
            // SizedBox(
            //   height: _blindYn == null ? 0 : 8,
            // ),
            Visibility(
              visible: _blindYn == null ? false : true,
              child: Container(
                decoration:
                    BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), border: Border.all(width: 1, color: Colors.grey.withOpacity(.3))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ISInput(
                      label: '신고종류',
                      readOnly: true,
                      value: _codeNm,
                    ),
                    ISInput(
                      label: '사장님 신고 내용',
                      value: _bliendReason,
                      readOnly: true,
                      maxLines: 5,
                      height: 80,
                      textStyle: TextStyle(color: Colors.black, fontSize: 13),
                      keyboardType: TextInputType.multiline,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ISInput(
                            label: '임시 블라인드기간',
                            readOnly: true,
                            value: _blindEndDt == null ? '' : _blindEndDt.replaceAll('T', '  ').toString(),
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: ISInput(
                            label: '처리 담당자',
                            readOnly: true,
                            value: _allocUname,
                          ),
                          flex: 1,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8,),
            SizedBox(height: 8,),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), border: Border.all(width: 1, color: Colors.grey.withOpacity(.3))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ISInput(
                    label: '리뷰내용',
                    value: _detailConten_text,
                    readOnly: true,
                    maxLines: 8,
                    height: 150,
                    textStyle: TextStyle(color: Colors.black, fontSize: 13),
                    keyboardType: TextInputType.multiline,
                  ),
                  ISInput(
                    label: '담당자 답변',
                    readOnly: _blindYn == null ? true : false,
                    value: _detailAnswer_text,
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    height: 100,
                    suffixIcon: AuthUtil.isAuthEditEnabled('35') == true ? MaterialButton(
                      color: _blindYn == null ? Colors.black12 : Colors.blue,
                      minWidth: 40,
                      child: Text('답변 저장', style: TextStyle(color: Colors.white, fontSize: 13),),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
                      onPressed: () async {
                        if (_detailAnswer_text == null) _detailAnswer_text = '';

                        await EasyLoading.show(status: '답변 저장 중..');

                        FormState form = formKey.currentState;
                        if (!form.validate()) {
                          return;
                        }

                        await ReviewController.to.putAnswer(_selSeq, _detailAnswer_text, _detailMemo_text, GetStorage().read('logininfo')['uCode'], GetStorage().read('logininfo')['name'], context);

                        form.save();

                        await EasyLoading.dismiss();
                      },
                    ) : Container(),
                    onChange: (v) {
                      _detailAnswer_text = v;
                    },
                  ),
                  ISInput(
                    label: '메모',
                    value: _detailMemo_text,
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    height: 70,
                    suffixIcon: AuthUtil.isAuthEditEnabled('35') == true ? MaterialButton(
                      color:Colors.blue,
                      minWidth: 40,
                      child: Text('메모 저장', style: TextStyle(color: Colors.white, fontSize: 13),),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
                      onPressed: () async {
                        if (_detailAnswer_text == null) _detailAnswer_text = '';

                        await EasyLoading.show(status: '메모 저장 중..');

                        FormState form = formKey.currentState;
                        if (!form.validate()) {
                          return;
                        }

                        await ReviewController.to.putAnswer(_selSeq, _detailAnswer_text, _detailMemo_text, GetStorage().read('logininfo')['uCode'], GetStorage().read('logininfo')['name'], context);

                        form.save();

                        await EasyLoading.dismiss();
                      },
                    ) : Container(),
                    onChange: (v) {
                      _detailMemo_text = v;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 8,),
            Container(
                alignment: Alignment.centerLeft,
                child: Text('  - 신고 목록[${dataReportList.length}건]', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
            ),
            // Container(
            //     color: Colors.yellow,
            //     height: MediaQuery.of(context).size.height - 590,
            //     child: getHistoryTabView()
            // ),
            // Container(height: _blindYn == null ? (MediaQuery.of(context).size.height - 590) : (MediaQuery.of(context).size.height - 810),
            //   color: Colors.yellow,
            //   child: getHistoryTabView(),
            // )
            Container(
                height: (MediaQuery.of(context).size.height - 590),//_blindYn == null ? (MediaQuery.of(context).size.height - 590) : (MediaQuery.of(context).size.height - 810),
                child: getHistoryTabView()
            ),
          ],
        ),
      ),
    );
  }

  Widget getHistoryTabView() {
    return ListView.builder(
      //physics: NeverScrollableScrollPhysics(),
      itemCount: dataReportList.length,
      itemBuilder: (BuildContext context, int index) {
        return dataReportList != null
            ? GestureDetector(
          // onTap: (){
          //   Navigator.pushNamed(context, '/editor', arguments: UserController.to.userData[index]);
          // },
          child: Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              //leading: Text(dataList[index].siguName),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Text('No.' + dataHistoryList[index].NO.toString() ?? '--', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          padding: EdgeInsets.only(top: 5),
                          child: SelectableText('신고자 : [' + dataReportList[index].CUST_CODE.toString() + '] ' + dataReportList[index].CUST_NAME, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), showCursor: true,)
                      ),
                      Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(top: 5),
                          child: SelectableText(dataReportList[index].INSERT_DATE.replaceAll('T', ' '), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), showCursor: true,)
                      ),
                    ],
                  ),
                  Divider(thickness: 2),
                  Container(
                      padding: EdgeInsets.only(top: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SelectableText(dataReportList[index].REPORT_REASON, style: TextStyle(fontSize: 13), showCursor: true,),
                        ],
                      )
                  ),
                  SizedBox(height: 5)
                ],
              ),
            ),
          ),
        )
            : Text('Data is Empty');
      },
    );
  }

  Widget starRating(int cnt) {
    if (cnt == 0) {
      return Container(
        child: Row(children: <Widget>[
          Icon(Icons.star_border, size: 16,),
          Icon(Icons.star_border, size: 16),
          Icon(Icons.star_border, size: 16),
          Icon(Icons.star_border, size: 16),
          Icon(Icons.star_border, size: 16),
        ], mainAxisAlignment: MainAxisAlignment.center),
      );
    } else if (cnt == 1) {
      return Container(
        child: Row(children: <Widget>[
          Icon(Icons.star, size: 16),
          Icon(Icons.star_border, size: 16),
          Icon(Icons.star_border, size: 16),
          Icon(Icons.star_border, size: 16),
          Icon(Icons.star_border, size: 16),
        ], mainAxisAlignment: MainAxisAlignment.center),
      );
    } else if (cnt == 2) {
      return Container(
        child: Row(children: <Widget>[
          Icon(Icons.star, size: 16),
          Icon(Icons.star, size: 16),
          Icon(Icons.star_border, size: 16),
          Icon(Icons.star_border, size: 16),
          Icon(Icons.star_border, size: 16),
        ], mainAxisAlignment: MainAxisAlignment.center),
      );
    } else if (cnt == 3) {
      return Container(
        child: Row(children: <Widget>[
          Icon(Icons.star, size: 16),
          Icon(Icons.star, size: 16),
          Icon(Icons.star, size: 16),
          Icon(Icons.star_border, size: 16),
          Icon(Icons.star_border, size: 16),
        ], mainAxisAlignment: MainAxisAlignment.center),
      );
    } else if (cnt == 4) {
      return Container(
        child: Row(children: <Widget>[
          Icon(Icons.star, size: 16),
          Icon(Icons.star, size: 16),
          Icon(Icons.star, size: 16),
          Icon(Icons.star, size: 16),
          Icon(Icons.star_border, size: 16),
        ], mainAxisAlignment: MainAxisAlignment.center),
      );
    } else if (cnt == 5) {
      return Container(
        child: Row(children: <Widget>[
          Icon(Icons.star, size: 16),
          Icon(Icons.star, size: 16),
          Icon(Icons.star, size: 16),
          Icon(Icons.star, size: 16),
          Icon(Icons.star, size: 16),
        ], mainAxisAlignment: MainAxisAlignment.center),
      );
    } else {
      return null;
    }
  }

  Widget showPagerBar() {
    return Expanded(
        flex: 0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(),
                      // Visibility(
                      //   visible: false,
                      //   child: Text(
                      //     '[Excel 다운로드 중입니다. 잠시만 기다려 주십시오]',
                      //     style: TextStyle(color: Colors.blue),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Container(
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
                Container(
                  height: 48,
                  child: Responsive.isMobile(context) ? Container(height: 48) :  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      // Text('조회 데이터 : ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),),
                      // Text(ShopController.to.totalRowCnt.toString() + ' / ' + ShopController.to.total_count.toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                      // SizedBox(width: 20,),
                      Text('페이지당 행 수 : ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
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
              ]
          ),
        )
    );
  }

  double getListMainPanelWidth(){
    double nWidth = MediaQuery.of(context).size.width-900;

    if (Responsive.isTablet(context) == true)           nWidth = nWidth + sidebarWidth;
    else if (Responsive.isMobile(context) == true)      nWidth = MediaQuery.of(context).size.width;

    return nWidth;
  }
}

