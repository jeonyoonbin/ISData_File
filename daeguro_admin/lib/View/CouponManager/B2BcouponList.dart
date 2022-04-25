
import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_input.dart';
import 'package:daeguro_admin_app/Model/coupon/couponList.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/View/CouponManager/B2BcouponChange.dart';
import 'package:daeguro_admin_app/View/CouponManager/B2BcouponEdit.dart';
import 'package:daeguro_admin_app/View/CouponManager/B2BcouponRegist.dart';
import 'package:daeguro_admin_app/View/CouponManager/coupon_controller.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/OrderManager/orderDetail.dart';
import 'package:daeguro_admin_app/View/OrderManager/orderManager_controller.dart';
import 'package:daeguro_admin_app/constants/constant.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class B2BCouponList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return B2BCouponListState();
  }
}

class B2BCouponListState extends State {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List codeItems = List();
  final List<couponList> dataList = <couponList>[];

  //int rowsPerPage = 10;

  int _totalRowCnt = 0;
  int _selectedpagerows = 15;

  String _couponType = 'B2B_C100';
  String _couponStatus = '10';
  int _currentPage = 1;
  int _totalPages = 0;

  void _pageMove(int _page) {
    _query();
  }

  _reset() {
    formKey.currentState.reset();
    //loadData();
  }

  _query() {
    formKey.currentState.save();

    //CouponController.to.couponType.value = _couponType;
    //CouponController.to.couponB2BStatus.value = _couponStatus;
    CouponController.to.page.value = _currentPage;
    CouponController.to.raw.value = _selectedpagerows;
    loadData();
  }

  _regist() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: B2BCouponRegist(couponTypeItems: codeItems, selectedCouponType: _couponType),
      ),
    ).then((v) async {
      if (v == true) {
        await Future.delayed(Duration(milliseconds: 500), () {
        loadData();
        });
      }
    });
  }

  _change() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: B2BCouponChange(couponTypeItems: codeItems, selectedCouponType: _couponType),
      ),
    ).then((v) async {
      if (v == true) {
        await Future.delayed(Duration(milliseconds: 500), () {
        loadData();
        });
      }
    });
  }

  _edit(String couponNo) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: B2BCouponEdit(couponNo: couponNo),
      ),
    ).then((v) async {
      if (v != null) {
        loadData();
      }
    });
  }

  loadData() async {
    await ISProgressDialog(context).show(status: 'Loading...');
    dataList.clear();

    await CouponController.to.getB2BData(context, _couponType, _couponStatus).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else{
        if(this.mounted) {
          setState(() {
            value.forEach((e) {
              couponList temp = couponList.fromJson(e);
              dataList.add(temp);
            });

            _totalRowCnt = CouponController.to.totalRowCnt;
            _totalPages = (_totalRowCnt / _selectedpagerows).ceil();
          });
        }
      }
    });

    await ISProgressDialog(context).dismiss();
  }

  setDropDown() async {
    await CouponController.to.getDataB2BCodeItems(context).then((value) {
      if(value == null){
        ISAlert(context, '쿠폰정보를 가져오지 못했습니다. \n\n관리자에게 문의 바랍니다');
      }
      else{
        codeItems = value;
      }
    });

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    Get.put(CouponController());
    Get.put(OrderController());

    WidgetsBinding.instance.addPostFrameCallback((c) {
      _reset();
      setDropDown();
      _query();
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
              Text('총: ${Utils.getCashComma(CouponController.to.totalRowCnt.toString())}건', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
              SizedBox(width: 10),
              Text('발행: ${Utils.getCashComma(CouponController.to.pub.toString())}건', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
              SizedBox(width: 10),
              Text('고객발급: ${Utils.getCashComma(CouponController.to.giv.toString())}건', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
              SizedBox(width: 10),
              Text('사용: ${Utils.getCashComma(CouponController.to.use.toString())}건', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
              SizedBox(width: 10),
              Text('만료: ${Utils.getCashComma(CouponController.to.exp.toString())}건', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
              SizedBox(width: 10),
              Text('폐기: ${Utils.getCashComma(CouponController.to.del.toString())}건', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      ISSearchDropdown(
                        label: '쿠폰종류',
                        width: 150,
                        value: _couponType,
                        onChange: (value) {
                          setState(() {
                            _currentPage = 1;
                            _couponType = value;
                            _query();
                          });
                        },
                        item: codeItems.map((item) {
                          return new DropdownMenuItem<String>(
                              child: new Text(item['codeName'], style: TextStyle(fontSize: 13, color: Colors.black),),
                              value: item['code']);
                        }).toList(),
                      ),
                      ISSearchDropdown(
                        label: '상태',
                        width: 120,
                        value: _couponStatus,
                        onChange: (value) {
                          setState(() {
                            _currentPage = 1;
                            _couponStatus = value;
                            _query();
                          });
                        },
                        item: [
                          DropdownMenuItem(value: '00', child: Text('대기')),
                          DropdownMenuItem(value: '10', child: Text('승인')),
                          DropdownMenuItem(value: '20', child: Text('발행(회원)')),
                          DropdownMenuItem(value: '30', child: Text('사용(회원)')),
                          DropdownMenuItem(value: '40', child: Text('만료')),
                          DropdownMenuItem(value: '99', child: Text('폐기')),
                        ].cast<DropdownMenuItem<String>>(),
                      ),
                      SizedBox(width: 8,)
                    ],
                  ),
                  SizedBox(height: 8,),
                  ISSearchInput(
                    label: '쿠폰번호',
                    width: 280,
                    value: CouponController.to.keyword.value,
                    onChange: (v) {
                      CouponController.to.keyword.value = v;
                    },
                    onFieldSubmitted: (value) {
                      _currentPage = 1;
                      _query();
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      AuthUtil.isAuthCreateEnabled('26') == true ? ISSearchButton(width: 80, label: '생성', iconData: Icons.add, onPressed: () => _regist()) : Container(width: 80,),
                      SizedBox(width: 8),
                      AuthUtil.isAuthEditEnabled('26') == true ? ISSearchButton(width: 104, label: '쿠폰변경', iconData: Icons.post_add_outlined, onPressed: () => _change()) : Container(width: 104,),
                    ],
                  ),
                  SizedBox(height: 8,),
                  ISSearchButton(
                      width: 192,
                      label: '조회',
                      iconData: Icons.search,
                      onPressed: () => {_currentPage = 1, _query()}),
                ],
              )
            ],
          ),
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
            listWidth: Responsive.getResponsiveWidth(context, 1000), // Responsive.isTablet(context) ? MediaQuery.of(context).size.width : contentListWidth,
            rows: dataList.map((item) {
              return DataRow(cells: [
                DataCell(Align(child: SelectableText(item.couponName.toString() ?? '--', style: TextStyle(color: Colors.black), showCursor: true,), alignment: Alignment.center)),
                //DataCell(Align(child: SelectableText(item.couponNo.toString() ?? '--', style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.centerLeft)),
                DataCell(Align(
                    child: MaterialButton(
                      height: Responsive.isDesktop(context) == true ? 40.0 : 30.0,
                      child: Text(item.couponNo.toString() ?? '--', style: TextStyle(color: Colors.black, fontSize: 13)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                      onPressed: ()  {
                        _edit(item.couponNo);
                      },
                    ), alignment: Alignment.centerLeft
                )
                ),
                DataCell(Center(child: SelectableText(_getStatus(item.status.toString()) ?? '--', style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center(
                    child: item.status.toString() == '99'
                        ? MaterialButton(
                      color: Colors.grey.shade400,
                      minWidth: 40,
                      child: Text('폐기완료', style: TextStyle(color: Colors.grey, fontSize: 14),),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                    )
                        : item.status.toString() == '30'
                        ? MaterialButton(
                      color: Colors.grey.shade400,
                      minWidth: 40,
                      child: Text('폐기불가', style: TextStyle(color: Colors.grey, fontSize: 14),),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                    )
                        : MaterialButton(
                      color: Colors.blue,
                      minWidth: 40,
                      child: Text('폐기', style: TextStyle(color: Colors.white, fontSize: 14),),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                      onPressed: () async {
                        if (AuthUtil.isAuthEditEnabled('26') == false){
                          ISAlert(context, '권한이 없습니다. \n\n관리자에게 문의 바랍니다');
                          return;
                        }

                        ISConfirm(context, '쿠폰 폐기', '쿠폰을 폐기 하시겠습니까?', (context) async {
                          Navigator.of(context).pop();

                          await CouponController.to.putB2BsetCouponAppCustomer(item.appCustCode, item.couponType, item.couponNo, '99', context).then((value) {
                            loadData();
                          });
                        });
                      },
                    ))
                ),
                DataCell(Center(child: SelectableText(Utils.getCashComma(item.couponAmt.toString()) + '원' ?? '--', style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center(child: SelectableText(item.insDate.toString() == '' ? '--' : DateFormat("yyyy-MM-dd").format(DateTime.parse(item.insDate.toString())).toString(), style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center(child: SelectableText(item.stDate.toString() == '' ? '--' : DateFormat("yyyy-MM-dd").format(DateTime.parse(item.stDate.toString())).toString(), style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center(child: SelectableText(item.useDate.toString() == '' ? '--' : DateFormat("yyyy-MM-dd").format(DateTime.parse(item.useDate.toString())).toString(), style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center(child: SelectableText(item.expDate.toString() == '' ? '--' : DateFormat("yyyy-MM-dd").format(DateTime.parse(item.expDate.toString())).toString(), style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center(child: SelectableText(item.useCustName.toString() == '' ? '--' : item.useCustName.toString(), style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center(child: SelectableText(item.useTelNo.toString() == '' ? '--' : Utils.getPhoneNumFormat(item.useTelNo.toString(), true), style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center(child: SelectableText(item.insName.toString() == '' ? '--' : item.insName.toString(), style: TextStyle(color: Colors.black), showCursor: true))),
                // DataCell(
                //   Center(
                //     child: InkWell(
                //         onTap: () {
                //           _edit(item.couponNo);
                //         },
                //         child: Icon(Icons.edit)
                //     ),
                //   ),
                // ),
              ]);
            }).toList(),
            columns: <DataColumn>[
                DataColumn(label: Expanded(child: Text('쿠폰명', textAlign: TextAlign.center)),),
                DataColumn(label: Expanded(child: Text('쿠폰번호', textAlign: TextAlign.left)),),
                DataColumn(label: Expanded(child: Text('상태', textAlign: TextAlign.center)),),
                DataColumn(label: Expanded(child: Text('쿠폰폐기', textAlign: TextAlign.center)),),
                DataColumn(label: Expanded(child: Text('쿠폰금액', textAlign: TextAlign.center)),),
                DataColumn(label: Expanded(child: Text('발행일자', textAlign: TextAlign.center)),),
                DataColumn(label: Expanded(child: Text('지급일자', textAlign: TextAlign.center)),),
                DataColumn(label: Expanded(child: Text('사용일자', textAlign: TextAlign.center)),),
                DataColumn(label: Expanded(child: Text('사용종료일', textAlign: TextAlign.center)),),
                DataColumn(label: Expanded(child: Text('회원명', textAlign: TextAlign.center)),),
                DataColumn(label: Expanded(child: Text('회원전화', textAlign: TextAlign.center)),),
                DataColumn(label: Expanded(child: Text('등록자', textAlign: TextAlign.center)),
                //DataColumn(label: Expanded(child: Text('상세', textAlign: TextAlign.center)),
              ),
            ],
          ),
          Divider(),
          SizedBox(height: 0,),
          showPagerBar(),
        ],
      ),
    );
  }

  _detail({String orderNo}) async {
    //EasyLoading.show();
    await OrderController.to.getDetailData(orderNo.toString());
    //EasyLoading.dismiss();

    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: OrderDetail(orderNo: orderNo),
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
                Text('페이지당 행 수 : ', style: TextStyle( fontSize: 12, fontWeight: FontWeight.normal),),
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

    if (value.toString().compareTo('00') == 0)
      retValue = '대기';
    else if (value.toString().compareTo('10') == 0)
      retValue = '승인';
    else if (value.toString().compareTo('20') == 0)
      retValue = '발행(회원)';
    else if (value.toString().compareTo('30') == 0)
      retValue = '사용(회원)';
    else if (value.toString().compareTo('99') == 0) retValue = '폐기';

    return retValue;
  }
}
