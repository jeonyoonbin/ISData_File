import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_input.dart';
import 'package:daeguro_admin_app/Model/calc/calculateSearchShopTaxModel.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/CalculateManager/calculateSearchShopTax_Detail.dart';
import 'package:daeguro_admin_app/View/CalculateManager/calculate_controller.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';

import 'package:daeguro_admin_app/constants/constant.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class CalculateSearchShopTax extends StatefulWidget {
  final String chargeGbn;
  final String feeYm;
  final String gbn;
  final String prtYn;
  final double popWidth;
  final double popHeight;

  const CalculateSearchShopTax({Key key, this.chargeGbn, this.feeYm, this.gbn, this.prtYn, this.popWidth, this.popHeight})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CalculateSearchShopTaxState();
  }
}

class CalculateSearchShopTaxState extends State<CalculateSearchShopTax> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  SearchItems _searchItems = new SearchItems();

  final ScrollController _scrollController = ScrollController();

  List<CalculateSearchShopTaxModel> dataList = <CalculateSearchShopTaxModel>[];

  int rowsPerPage = 15;

  int _totalRowCnt = 0;
  int _selectedpagerows = 15;

  int _currentPage = 1;
  int _totalPages = 0;

  bool isCheckAll = false;
  int _checkItemCnt = 0;

  String _chargeGbn = 'P';
  String _statusGbn = 'P';
  String _prtYn = '%';
  String _sendTypeGbn = 'N';

  bool isMainShowEnabled(){
    return (widget.feeYm == null && widget.gbn == null && widget.chargeGbn == null && widget.prtYn == null);
  }

  void _pageMove(int _page) {
    _query();
  }

  _reset() {
    formKey.currentState.reset();

    if (isMainShowEnabled() == false){
      _searchItems.startdate = widget.feeYm;
      _statusGbn = widget.gbn;
      _chargeGbn = widget.chargeGbn;
      _prtYn = widget.prtYn;
    }
    //loadData();
  }

  _query() {
    formKey.currentState.save();

    loadData();
  }

  _detail({Map<String, dynamic> item}) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: CalculateSearchShopTax_Detail(items: item),
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

    _checkItemCnt = 0;
    isCheckAll = false;

    dataList.clear();

    //print('loadData feeYm:${_searchItems.startdate.replaceAll('-', '')}, _chargeGbn:${_chargeGbn}, _statusGbn:${_statusGbn}, memo:${_searchItems.name}, page:${_currentPage.toString()}, row:${_selectedpagerows.toString()}' );

    await CalculateController.to.getSearchShopTaxData(_searchItems.startdate.replaceAll('-', ''), '2', _chargeGbn, _statusGbn, _prtYn,
        _searchItems.name, _currentPage.toString(), _selectedpagerows.toString()).timeout(const Duration(seconds: 20), onTimeout: () {
          print('타임아웃 : get 시간초과(20초)');
          return;
        }).then((value) async {
          if(value == null){
            ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
          }
          else {
            value.forEach((e) {
              CalculateSearchShopTaxModel temp = CalculateSearchShopTaxModel.fromJson(e);
              temp.selected = false;

              //print('status:${temp.status}');

              if (temp.taxGbn == '1') {
                temp.taxGbn = '세금계산서';
              } else if (temp.taxGbn == '2') {
                temp.taxGbn = '계산서';
              }

              if (temp.saleGbn == 'S') {
                temp.saleGbn = '매출';
              } else if (temp.saleGbn == 'P') {
                temp.saleGbn = '매입';
              }

              if (temp.prtGbn == '1') {
                temp.prtGbn = '청구';
              } else if (temp.prtGbn == '2') {
                temp.prtGbn = '영수';
              }

              if (temp.taxAcc == 'P') {
                temp.taxAcc = '중계 수수료';
              } else if (temp.taxAcc == 'G') {
                temp.taxAcc = 'PG 결제금액';
              } else if (temp.taxAcc == 'K') {
                temp.taxAcc = 'PG 결제 수수료';
              }

              dataList.add(temp);
            });

            _totalRowCnt = CalculateController.to.totalRowCnt;
            _totalPages = (_totalRowCnt / _selectedpagerows).ceil();
          }


        //if (this.mounted) {
        setState(() {

        });
        //}
    });

    await ISProgressDialog(context).dismiss();
  }

  loadTaxBillData(String jobGbn, String shopCd, bool isAllRequest) async {
    String jobGbn2 = _chargeGbn;
    List<String> selected_ShopList = [];

    await ISProgressDialog(context).show(status: 'Loading...');

    if (isAllRequest == true){
      jobGbn2 = '%';

      selected_ShopList.add('1');
    }
    else{
      jobGbn2 = _chargeGbn;

      selected_ShopList.add(shopCd);

      // dataList.forEach((element) {
      //   if (element.selected == true)
      //     selected_ShopList.add(element.shopCd);
      // });
    }

    //await EasyLoading.show(status: 'Loading...');

    String uCode = GetStorage().read('logininfo')['uCode'];
    String uName = GetStorage().read('logininfo')['name'];

    // selected_ShopList.forEach((element) {
    //   print('_selected_ShopList: ${element}');
    // });

    // String _jobGbn = '1';//1 발행요청 / 2 발행취소 / 3 국세청 전송 / 4 세금계산서 삭제
    //
    await CalculateController.to.putTaxBillData(jobGbn, jobGbn2, 'I', _searchItems.startdate.replaceAll('-', ''),  _sendTypeGbn, uCode, uName, selected_ShopList).timeout(const Duration(seconds: 15),
        onTimeout: () {
          print('타임아웃 : put 시간초과(15초)');
        }).then((value) {
          _currentPage = 1;
          loadData();
        }
    );

    await ISProgressDialog(context).dismiss();//await EasyLoading.dismiss();
  }

  @override
  void initState() {
    super.initState();

    Get.put(CalculateController());

    var date = new DateTime.now();
    _searchItems.startdate = formatDate(DateTime(date.year, date.month - 1, date.day), [yyyy, '-', mm]);

    WidgetsBinding.instance.addPostFrameCallback((c) {
      _reset();
      _query();
    });
  }

  @override
  void dispose() {
    if (dataList != null) {
      dataList.clear();
      dataList = null;
    }

    if (_scrollController != null)
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
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            children: [
              Container(
                child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 8),
                        child: ISSearchDropdown(
                          label: '수수료 구분',
                          width: 132,
                          value: _chargeGbn,
                          onChange: (value) {
                            _chargeGbn = value;
                            setState(() {
                            });
                            // _currentPage = 1;
                            // _query();
                          },
                          item: [
                            DropdownMenuItem(value: 'P', child: Text('중개수수료'),),
                            DropdownMenuItem(value: 'K', child: Text('카드수수료'),),
                          ].cast<DropdownMenuItem<String>>(),
                        ),
                      ),
                      SizedBox(height: 8,),
                      ISSearchInput(
                        label: '정산월',
                        width: 140,
                        readOnly: true,
                        value: Utils.getYearMonthFormat(_searchItems.startdate),
                        onChange: (v) {
                          _searchItems.startdate = v;
                        },
                        onFieldSubmitted: (v) {},
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          iconSize: 17,
                          splashRadius: 20,
                          color: Colors.blue,
                          onPressed: () {
                            showMonthPicker(context: context, firstDate: DateTime(DateTime.now().year - 10, 5), lastDate: DateTime(DateTime.now().year + 10, 9), initialDate: DateTime.now(),).then((date) {
                              if (date != null) {
                                _searchItems.startdate = formatDate(date, [yyyy, '-', mm]);//
                                loadData();
                              }
                            });
                          },
                        ),
                      ),
                    ]
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        ISSearchDropdown(
                          label: '구분',
                          width: 100,
                          value: _statusGbn,
                          onChange: (value) {
                            _statusGbn = value;
                            _prtYn = '%';

                            setState(() {
                            });

                            // _currentPage = 1;
                            // _query();
                          },
                          item: [
                            DropdownMenuItem(value: '%', child: Text('전체'),),
                            DropdownMenuItem(value: 'C', child: Text('미생성'),),
                            DropdownMenuItem(value: 'P', child: Text('생성'),),
                            DropdownMenuItem(value: 'R', child: Text('발행'),),
                          ].cast<DropdownMenuItem<String>>(),
                        ),
                        ISSearchDropdown(
                          ignoring: _statusGbn == 'R' ? false : true,
                          label: '발행 처리 결과',
                          width: 100,
                          value: _prtYn,
                          onChange: (value) {
                            _prtYn = value;

                            setState(() {
                            });
                            // _currentPage = 1;
                            // _query();
                          },
                          item: [
                            DropdownMenuItem(value: '%', child: Text('전체'),),
                            DropdownMenuItem(value: 'Y', child: Text('성공'),),
                            DropdownMenuItem(value: 'N', child: Text('실패'),),
                          ].cast<DropdownMenuItem<String>>(),
                        ),
                      ],
                    ),
                    SizedBox(height: 8,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ISSearchInput(
                          label: '상점명',
                          width: 208,
                          value: _searchItems.name,
                          onChange: (v) {
                            _searchItems.name = v;
                          },
                          onFieldSubmitted: (v) {
                            _query();
                          },
                        ),

                      ],
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //SizedBox(height: 48,),
                    Container(
                      padding: EdgeInsets.only(right: 8),
                      child: ISSearchDropdown(
                        padding: EdgeInsets.all(0.0),
                        label: '전송구분',
                        width: 100,
                        value: _sendTypeGbn,
                        onChange: (value) {
                          _sendTypeGbn = value;

                          // _currentPage = 1;
                          // _query();
                        },
                        item: [
                          DropdownMenuItem(value: 'Y', child: Text('테스트'),),
                          DropdownMenuItem(value: 'N', child: Text('운영'),),

                        ].cast<DropdownMenuItem<String>>(),
                      ),
                    ),
                    SizedBox(height: 8,),
                    ISSearchButton(label: '조회', width: 100, iconData: Icons.search, onPressed: () => {_currentPage = 1, _query()}),
                  ]
                )
              ),
            ],
          )
        ],
      ),
    );

    var execBar = Expanded(
      flex: 0,
      child: Column(
        children: [
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('${_searchItems.startdate.replaceAll('-', '.')}월분  '),
              if (AuthUtil.isAuthEditEnabled('22') == true)
              Row(
                children: <Widget>[
                  ISButton(label: '일괄 생성삭제', textStyle: TextStyle(color: Colors.white, fontSize: 12), onPressed: (){
                    ISConfirm(context, '일괄 생성삭제', '생성분을 일괄 삭제 하시겠습니까?', (context) async {
                      Navigator.of(context).pop();

                      loadTaxBillData('4', '1', true); //1 발행요청 / 2 발행취소 / 3 국세청 전송 / 4 세금계산서 삭제
                    });

                  }),
                  SizedBox(width: 8),
                  ISButton(label: '일괄 발행', textStyle: TextStyle(color: Colors.white, fontSize: 12), onPressed: (){
                    ISConfirm(context, '일괄 발행', '생성분을 일괄 발행 하시겠습니까?', (context) async {
                      Navigator.of(context).pop();

                      loadTaxBillData('1', '1', true); //1 발행요청 / 2 발행취소 / 3 국세청 전송 / 4 세금계산서 삭제
                    });
                  }),
                  SizedBox(width: 8),
                  ISButton(label: '일괄 발행취소', textStyle: TextStyle(color: Colors.white, fontSize: 12), onPressed: (){
                    ISConfirm(context, '일괄 발행취소', '발행분을 일괄 발행취소 하시겠습니까?', (context) async {
                      Navigator.of(context).pop();

                      loadTaxBillData('2', '1', true); //1 발행요청 / 2 발행취소 / 3 국세청 전송 / 4 세금계산서 삭제
                    });
                  }),
                  SizedBox(width: 8),
                  ISButton(label: '일괄 국세청 즉시전송', textStyle: TextStyle(color: Colors.white, fontSize: 12), onPressed: (){
                    ISConfirm(context, '일괄 국세청 즉시전송', '발행분을 일괄 국세청 즉시전송 하시겠습니까?', (context) async {
                      Navigator.of(context).pop();

                      loadTaxBillData('3', '1', true); //1 발행요청 / 2 발행취소 / 3 국세청 전송 / 4 세금계산서 삭제
                    });
                  }),
                ],
              ),
              // _checkItemCnt == 0 ? Container() : Row(
              //   children: [
              //     ISButton(label: '생성삭제', textStyle: TextStyle(color: Colors.white, fontSize: 12), onPressed: (){
              //       ISConfirm(context, '생성삭제', '선택된 항목을 생성삭제 하시겠습니까?', (context) async {
              //         Navigator.of(context).pop();
              //
              //         loadTaxBillData('4', false); //1 발행요청 / 2 발행취소 / 3 국세청 전송 / 4 세금계산서 삭제
              //       });
              //     }),
              //     SizedBox(width: 8),
              //     ISButton(label: '발행', textStyle: TextStyle(color: Colors.white, fontSize: 12), onPressed: (){
              //       ISConfirm(context, '발행', '선택된 항목을 발행 하시겠습니까?', (context) async {
              //         Navigator.of(context).pop();
              //
              //         loadTaxBillData('1', false); //1 발행요청 / 2 발행취소 / 3 국세청 전송 / 4 세금계산서 삭제
              //       });
              //     }),
              //     SizedBox(width: 8),
              //     ISButton(label: '발행취소', textStyle: TextStyle(color: Colors.white, fontSize: 12), onPressed: (){
              //       ISConfirm(context, '발행취소', '선택된 항목을 발행취소 하시겠습니까?', (context) async {
              //         Navigator.of(context).pop();
              //
              //         loadTaxBillData('2', false); //1 발행요청 / 2 발행취소 / 3 국세청 전송 / 4 세금계산서 삭제
              //       });
              //     }),
              //     SizedBox(width: 8),
              //     ISButton(label: '국세청 즉시전송', textStyle: TextStyle(color: Colors.white, fontSize: 12), onPressed: (){
              //       ISConfirm(context, '국세청 즉시전송', '선택된 항목을 국세청 즉시전송 하시겠습니까?', (context) async {
              //         Navigator.of(context).pop();
              //
              //         loadTaxBillData('3', false); //1 발행요청 / 2 발행취소 / 3 국세청 전송 / 4 세금계산서 삭제
              //       });
              //     }),
              //   ],
              // )
            ],
          ),
        ],
      ),
    );

    return Container(
      padding: (isMainShowEnabled() == true) ? null : EdgeInsets.only(left: 10, right: 10, bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          form,
          isMainShowEnabled() == true ? buttonBar : Container(),
          isMainShowEnabled() == true ? execBar : Container(),
          Divider(),
          ISDatatable(
            panelHeight: isMainShowEnabled() == true ? (MediaQuery.of(context).size.height-defaultContentsHeight-94) : widget.popHeight-140,
            listWidth: isMainShowEnabled() == true ? Responsive.getResponsiveWidth(context, 1640) : widget.popWidth-20,
            controller: _scrollController,

            rows: dataList.map((item) {
              return DataRow(cells: [
                // DataCell(
                //   Center(
                //     child: isMainShowEnabled() == true ? Checkbox(
                //       value: item.selected,//this.checkAll,
                //       onChanged: (value) {
                //         if (value == true) {
                //           _checkItemCnt++;
                //         }
                //         else {
                //           _checkItemCnt--;
                //
                //           isCheckAll = false;
                //         }
                //
                //         item.selected == false ? item.selected = true : item.selected = false;
                //
                //         setState(() {});
                //       }
                //     ) : Container(),
                //   )
                // ),
                DataCell(Center(child: SelectableText(item.mainCcname ?? '--', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true))),
                DataCell(Align(child: SelectableText(item.shopName.toString() == null ? '--' : '['+ item.shopCd.toString() +'] '+item.shopName.toString(), style: TextStyle(color: Colors.black), showCursor: true,), alignment: Alignment.centerLeft)),
                DataCell(Center(child: SelectableText(Utils.getYearMonthDayFormat(item.issymd) ?? '--', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true))),
                DataCell(Center(child: SelectableText(item.taxNo ?? '--', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true))),
                DataCell(Center(child: SelectableText(_getStatus(item.status) ?? '--', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true))),
                DataCell(Center(child: SelectableText(item.taxGbn ?? '--', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true))),
                DataCell(Center(child: SelectableText(item.taxAcc ?? '--', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true),)),
                DataCell(Center(child: SelectableText(item.saleGbn ?? '--', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true),)),
                DataCell(Align(child: SelectableText(Utils.getCashComma(item.supamt) ?? '--', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true), alignment: Alignment.centerRight)),
                DataCell(Align(child: SelectableText(Utils.getCashComma(item.vatamt) ?? '--', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true), alignment: Alignment.centerRight)),
                DataCell(Align(child: SelectableText(Utils.getCashComma(item.amt) ?? '--', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true), alignment: Alignment.centerRight)),
                DataCell(Center(child: SelectableText(item.memo ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), textAlign: TextAlign.center, showCursor: true),)),
                if(isMainShowEnabled() == true && AuthUtil.isAuthEditEnabled('22') == true)
                DataCell(Center(
                  child: isTaxCreateDelEnabled(item.taxNo, item.status) == true ? MaterialButton(
                    height: 30.0,
                    color: Colors.blue,
                    minWidth: 40,
                    child: Text('생성삭제', style: TextStyle(color: Colors.white, fontSize: 11),),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                    onPressed: () async {
                      ISConfirm(context, '생성삭제', '생성분을 삭제 하시겠습니까?', (context) async {
                        Navigator.of(context).pop();

                        loadTaxBillData('4', item.shopCd,  false);
                      });
                    },
                  ) : Container(),
                )),
                if(isMainShowEnabled() == true && AuthUtil.isAuthEditEnabled('22') == true)
                DataCell(Center(
                  child: isTaxCreateDelEnabled(item.taxNo, item.status) == true ? MaterialButton(
                    height: 30.0,
                    color: Colors.blue,
                    minWidth: 40,
                    child: Text('발행', style: TextStyle(color: Colors.white, fontSize: 11),),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                    onPressed: () async {
                      ISConfirm(context, '발행', '생성분을 발행 하시겠습니까?', (context) async {
                        Navigator.of(context).pop();

                        loadTaxBillData('1', item.shopCd, false);
                      });

                    },
                  ) : Container(),
                )),
                if(isMainShowEnabled() == true && AuthUtil.isAuthEditEnabled('22') == true)
                DataCell(Center(
                  child: isTaxCancelEnabled(item.status) == true ? MaterialButton(
                    height: 30.0,
                    color: Colors.blue,
                    minWidth: 40,
                    child: Text('발행취소', style: TextStyle(color: Colors.white, fontSize: 11),),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                    onPressed: () async {
                      ISConfirm(context, '발행취소', '발행분을 발행취소 하시겠습니까?', (context) async {
                        Navigator.of(context).pop();

                        loadTaxBillData('2', item.shopCd, false);
                      });
                    },
                  ) : Container(),
                )),
                if(isMainShowEnabled() == true && AuthUtil.isAuthEditEnabled('22') == true)
                DataCell(Center(
                  child: isTaxSendEnabled(item.taxNo) ? MaterialButton(
                    height: 30.0,
                    color: Colors.blue,
                    minWidth: 40,
                    child: Text('국세청 즉시전송', style: TextStyle(color: Colors.white, fontSize: 11),),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                    onPressed: () async {
                      ISConfirm(context, '국세청 즉시전송', '발행분을 국세청 즉시전송 하시겠습니까?', (context) async {
                        Navigator.of(context).pop();

                        loadTaxBillData('3', item.shopCd, false);
                      });
                    },
                  ) : Container(),
                )),
                DataCell(Center(
                    child: IconButton(
                      onPressed: () {
                        _detail(item: item.toJson());
                      },
                      icon: Icon(Icons.receipt_long),
                      tooltip: '상세',
                    ))),
              ]);
            }).toList(),
            columns: <DataColumn>[
              // DataColumn(label: Expanded(
              //         child: isMainShowEnabled() == true ? Checkbox(
              //         value: isCheckAll,//this.checkAll,
              //         onChanged: (v) {
              //           isCheckAll = v;
              //           isCheckAll == false ? _checkItemCnt = 0 : _checkItemCnt = dataList.length;
              //
              //           dataList.forEach((element) {
              //             element.selected = v;
              //           });
              //
              //           setState(() {});
              //         }
              //     ) : Container(),
              //   )
              // ),
              DataColumn(label: Expanded(child: Text('콜센터명', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('가맹점명', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('처리일', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('일련번호', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('상태', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('계산서\n구분', style: TextStyle(fontSize: 12), textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('매입/매출\n구분', style: TextStyle(fontSize: 12), textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('매출계정', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('공급가\n합계', style: TextStyle(fontSize: 12), textAlign: TextAlign.right)),),
              DataColumn(label: Expanded(child: Text('부가세\n합계', style: TextStyle(fontSize: 12), textAlign: TextAlign.right)),),
              DataColumn(label: Expanded(child: Text('금액 합계', textAlign: TextAlign.right)),),
              DataColumn(label: Expanded(child: Text('메모', textAlign: TextAlign.center)),),
              if(isMainShowEnabled() == true && AuthUtil.isAuthEditEnabled('22') == true)
                DataColumn(label: Expanded(child: Text('생성삭제', textAlign: TextAlign.center)),),
              if(isMainShowEnabled() == true && AuthUtil.isAuthEditEnabled('22') == true)
                DataColumn(label: Expanded(child: Text('발행', textAlign: TextAlign.center)),),
              if(isMainShowEnabled() == true && AuthUtil.isAuthEditEnabled('22') == true)
                DataColumn(label: Expanded(child: Text('발행취소', textAlign: TextAlign.center)),),
              if(isMainShowEnabled() == true && AuthUtil.isAuthEditEnabled('22') == true)
                DataColumn(label: Expanded(child: Text('국세청 즉시전송', textAlign: TextAlign.center)),),

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

  String _getStatus(String value) {
    String retValue = '--';

    if (value.toString().compareTo('RDY') == 0)             retValue = '세금계산서 발행 요청';
    else if (value.toString().compareTo('RD1') == 0)        retValue = '세금계산서 발행 처리 중';
    else if (value.toString().compareTo('SND') == 0)        retValue = '세금계산서 발행';
    else if (value.toString().compareTo('RCV') == 0)        retValue = '세금계산서 수신';
    else if (value.toString().compareTo('ACK') == 0)        retValue = '세금계산서 승인';
    else if (value.toString().compareTo('CAN') == 0)        retValue = '세금계산서 반려';
    else if (value.toString().compareTo('NLR') == 0)        retValue = '국세청 전송';
    else if (value.toString().compareTo('NLW') == 0)        retValue = '국세청 응답대기';
    else if (value.toString().compareTo('NLE') == 0)        retValue = '국세청 응답에러';
    else if (value.toString().compareTo('NLF') == 0)        retValue = '국세청 제출완료';
    else if (value.toString().compareTo('ERR') == 0)        retValue = '세금계산서 에러';
    else if (value.toString().compareTo('CCR') == 0)        retValue = '세금계산서 삭제요청';
    else if (value.toString().compareTo('DEL') == 0)        retValue = '세금계산서 삭제';
    else
      retValue = '--';

    return retValue;
  }

  bool isTaxCreateDelEnabled(String taxNo, String status){
    //print('isTaxCreateDelEnabled taxNo:${taxNo}, status:${status}');
    if (taxNo.toString() != '' && (status.toString() == '' || status.toString() == 'DEL')) {
      return true;
    }
    else{
      return false;
    }
  }

  bool isTaxCancelEnabled(String status){
    if (status.toString() == 'SND')
      return true;
    else
      return false;
  }

  bool isTaxSendEnabled(String taxNo){
    if (taxNo.toString() != '')
      return true;
    else
      return false;
  }
}
