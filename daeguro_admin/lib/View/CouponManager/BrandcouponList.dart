
import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_input.dart';
import 'package:daeguro_admin_app/Model/coupon/couponBrandCodeList.dart';
import 'package:daeguro_admin_app/Model/coupon/couponBrandListModel.dart';
import 'package:daeguro_admin_app/Model/coupon/couponTypeList.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/View/CouponManager/BrandcouponChange.dart';
import 'package:daeguro_admin_app/View/CouponManager/BrandcouponEdit.dart';
import 'package:daeguro_admin_app/View/CouponManager/BrandcouponRegist.dart';
import 'package:daeguro_admin_app/View/CouponManager/coupon_controller.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/OrderManager/orderDetail.dart';
import 'package:daeguro_admin_app/View/OrderManager/orderManager_controller.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccountList.dart';
import 'package:daeguro_admin_app/constants/constant.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class BrandCouponList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BrandCouponListState();
  }
}

class BrandCouponListState extends State {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List codeItems = List();
  final List<couponBrandListModel> dataList = <couponBrandListModel>[];

  List<SelectOptionVO> BrandNameItems = [];
  List<SelectOptionVO> BrandCouponTypeItems = [];

  //int rowsPerPage = 10;

  int _totalRowCnt = 0;
  int _selectedpagerows = 15;

  String _chainCode = ' ';
  String _couponType = ' ';
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
        child: BrandCouponRegist(),
      ),
    ).then((v) async {
      if (v == true) {
        loadData();
      }
    });
  }

  _change() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: BrandCouponChange(),
      ),
    ).then((v) async {
      if (v == null) {
        loadData();
      }
      else{
        print('value:${v.toString()}');
        ISAlert(context, '쿠폰 변경 실패 \n\n' + v.toString());
      }
    });
  }

  _edit(String couponNo) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: BrandCouponEdit(couponNo: couponNo),
      ),
    ).then((v) async {
      if (v != null) {
        loadData();
      }
    });
  }

  loadBrandListData() async {
    BrandNameItems.clear();

    await CouponController.to.getBrandListItems().then((value) {
      BrandNameItems.add(new SelectOptionVO(value: ' ', label: '전체', label2: '',));

      value.forEach((element) {
        CouponBrandCodeListModel tempData = CouponBrandCodeListModel.fromJson(element);

        //ChainListItems.add(new SelectOptionVO(value: tempData.CODE, label: '[' + tempData.CODE + '] ' + tempData.CODE_NM, label2: tempData.CODE_NM,));
        BrandNameItems.add(new SelectOptionVO(value: tempData.CODE, label: tempData.CODE_NM, label2: tempData.CODE_NM,));
      });

      setState(() {
      });
    });
  }

  loadBrandCouponListData(String _chainCode) async {
    BrandCouponTypeItems.clear();

    await CouponController.to.getBrandCouponListItems(_chainCode).then((value) {
      BrandCouponTypeItems.add(new SelectOptionVO(value: ' ', label: '전체', label2: '',));

      value.forEach((element) {
        CouponTypeListModel tempData = CouponTypeListModel.fromJson(element);

        //ChainCouponListItems.add(new SelectOptionVO(value: tempData.CODE, label: '[' + tempData.CODE + '] ' + tempData.CODE_NM, label2: tempData.CODE_NM,));
        //BrandCouponTypeItems.add(new SelectOptionVO(value: tempData.CODE, label: tempData.CODE_NM, label2: tempData.CODE_NM,));
        BrandCouponTypeItems.add(new SelectOptionVO(value: tempData.CODE, label: '[${tempData.CODE}] '+ tempData.CODE_NM, label2: '[${tempData.CODE}] '+ tempData.CODE_NM));
      });

      setState(() {
      });
    });
  }

  loadData() async {
    await ISProgressDialog(context).show(status: 'Loading...');
    dataList.clear();

    await CouponController.to.getBrandData(_chainCode, _couponType, _couponStatus).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else{
        if(this.mounted) {
          setState(() {
            value.forEach((e) {
              couponBrandListModel tempData = couponBrandListModel.fromJson(e);

              if (tempData.CONF_DATE != null)
                tempData.CONF_DATE = tempData.CONF_DATE.replaceAll('T', '  ');

              dataList.add(tempData);
            });

            _totalRowCnt = CouponController.to.totalRowCnt;
            _totalPages = (_totalRowCnt / _selectedpagerows).ceil();
          });
        }
      }
    });

    await ISProgressDialog(context).dismiss();
  }

  // setDropDown() async {
  //   await CouponController.to.getDataB2BCodeItems(context);
  //
  //   //print('codeList:${CouponController.to.qB2BDataItems.toString()}');
  //
  //   codeItems = CouponController.to.qB2BDataItems;
  //
  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();

    Get.put(CouponController());
    Get.put(OrderController());

    WidgetsBinding.instance.addPostFrameCallback((c) {
      loadBrandListData();
      loadBrandCouponListData('');

      _reset();
      //setDropDown();
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
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ISSearchDropdown(
                    label: '브랜드 구분',
                    value: _chainCode,
                    width: 170,
                    item: BrandNameItems.map((item) {
                      return new DropdownMenuItem<String>(
                          child: new Text(item.label, style: TextStyle(fontSize: 13, color: Colors.black),),
                          value: item.value);
                    }).toList(),
                    onChange: (v) {
                      BrandNameItems.forEach((element) {
                        if (v == element.value) {
                          _chainCode = element.value;
                        }
                      });

                      _couponType = ' ';

                      loadBrandCouponListData(v);
                      _currentPage = 1;
                      _query();
                    },
                  ),
                  SizedBox(height: 8,),
                  ISSearchDropdown(
                    label: '상태',
                    width: 170,
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
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ISSearchDropdown(
                    label: '쿠폰 타입',
                    value: _couponType,
                    width: 232,
                    item: BrandCouponTypeItems.map((item) {
                      return new DropdownMenuItem<String>(
                          child: new Text(item.label, style: TextStyle(fontSize: 13, color: Colors.black),),
                          value: item.value);
                    }).toList(),
                    onChange: (v) {
                      BrandCouponTypeItems.forEach((element) {
                        if (v == element.value) {
                          _couponType = element.value;
                        }
                      });

                      _currentPage = 1;
                      _query();
                    },
                  ),
                  SizedBox(height: 8,),
                  ISSearchInput(
                    label: '쿠폰번호',
                    width: 240,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AuthUtil.isAuthCreateEnabled('27') == true ? ISSearchButton(width: 80, label: '생성', iconData: Icons.add, onPressed: () => _regist()) : Container(width: 80,),
                      SizedBox(width: 8),
                      AuthUtil.isAuthEditEnabled('27') == true ? ISSearchButton(width: 104, label: '쿠폰변경', iconData: Icons.post_add_outlined, onPressed: () => _change()) : Container(width: 104,),
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
                DataCell(Align(child: SelectableText(item.COUPON_NAME.toString() ?? '--', style: TextStyle(color: Colors.black), showCursor: true,), alignment: Alignment.center)),
                //DataCell(Align(child: SelectableText(item.COUPON_NO.toString() ?? '--', style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.centerLeft)),
                DataCell(Align(
                    child: MaterialButton(
                      height: Responsive.isDesktop(context) == true ? 40.0 : 30.0,
                      child: Text(item.COUPON_NO.toString() ?? '--', style: TextStyle(color: Colors.black, fontSize: 13)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                      onPressed: ()  {
                        _edit(item.COUPON_NO);
                      },
                    ), alignment: Alignment.centerLeft
                )
                ),
                DataCell(Center(child: SelectableText(_getStatus(item.STATUS.toString()) ?? '--', style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center(
                    child: item.STATUS.toString() == '99'
                        ? MaterialButton(
                      color: Colors.grey.shade400,
                      minWidth: 40,
                      child: Text('폐기완료', style: TextStyle(color: Colors.grey, fontSize: 14),),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                    )
                        : item.STATUS.toString() == '30'
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
                        if (AuthUtil.isAuthEditEnabled('27') == false){
                          ISAlert(context, '권한이 없습니다. \n\n관리자에게 문의 바랍니다');
                          return;
                        }

                        BuildContext curContext = context;

                        ISConfirm(context, '쿠폰 폐기', '쿠폰을 폐기 하시겠습니까?', (context) async {
                          Navigator.of(context).pop();

                          await CouponController.to.putBrandsetCouponAppCustomer(item.APP_CUST_CODE, item.COUPON_TYPE, item.COUPON_NO, '99').then((value) {
                            if (value == null) {
                              loadData();
                            }
                            else{
                              ISAlert(curContext, '쿠폰 상태변경 실패 \n\n' + value.toString());
                            }
                          });
                        });
                      },
                    ))
                ),
                DataCell(Center(child: SelectableText(Utils.getCashComma(item.COUPON_AMT.toString()) + '원' ?? '--', style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center(child: SelectableText(item.INS_DATE.toString() == ' ' ? '--' : DateFormat("yyyy-MM-dd").format(DateTime.parse(item.INS_DATE.toString())).toString(), style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center(child: SelectableText(item.ST_DATE.toString() == ' ' ? '--' : DateFormat("yyyy-MM-dd").format(DateTime.parse(item.ST_DATE.toString())).toString(), style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center(child: SelectableText(item.USE_DATE.toString() == ' ' ? '--' : DateFormat("yyyy-MM-dd").format(DateTime.parse(item.USE_DATE.toString())).toString(), style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center(child: SelectableText(item.EXP_DATE.toString() == ' ' ? '--' : DateFormat("yyyy-MM-dd").format(DateTime.parse(item.EXP_DATE.toString())).toString(), style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center(child: SelectableText(item.USE_CUST_NAME.toString() == ' ' ? '--' : item.USE_CUST_NAME.toString(), style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center(child: SelectableText(item.USE_TELNO.toString() == ' ' ? '--' : Utils.getPhoneNumFormat(item.USE_TELNO.toString(), true), style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center(child: SelectableText(item.INS_NAME.toString() == ' ' ? '--' : item.INS_NAME.toString(), style: TextStyle(color: Colors.black), showCursor: true))),
                // DataCell(
                //   Center(
                //     child: InkWell(
                //         onTap: () {
                //           _edit(item.COUPON_NO);
                //         },
                //         child: Icon(Icons.edit)
                //     ),
                //   ),
                // ),
                DataCell(Align(child: (item.SHOP_NAME.toString() == null || item.SHOP_NAME.toString() == 'null' || item.SHOP_NAME.toString() == ' ') ? Container() : MaterialButton(
                  height: 30.0,
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  child: Text(item.SHOP_NAME.toString(), style: TextStyle(fontSize: 13, color: Colors.white)),
                  onPressed: () {
                    double poupWidth = 1040;
                    double poupHeight = 600;

                    showDialog(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                        //child: ShopAccountList(shopName: item.SHOP_NAME.toString()),
                        child: SizedBox(
                          width: poupWidth,
                          height: poupHeight,
                          child: Scaffold(
                            appBar: AppBar(
                              title: Text('사용 가맹점 - ${item.SHOP_NAME}'),
                            ),
                            body: ShopAccountList(shopName: item.SHOP_NAME, popWidth: poupWidth, popHeight: poupHeight),
                          ),
                        ),
                      ),
                    );
                  },
                ), alignment: Alignment.centerLeft),
                ),
                DataCell(Center(child: (item.ORDER_NO.toString() == null || item.ORDER_NO.toString() == 'null' || item.ORDER_NO.toString() == ' ') ? Container() : MaterialButton(
                  height: 30.0,
                  color: Color.fromRGBO(192, 108, 132, 1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  child: Text('주문번호: ${item.ORDER_NO.toString()}', style: TextStyle(fontSize: 13, color: Colors.white)),
                  onPressed: () async {
                    await OrderController.to.getDetailData(item.ORDER_NO.toString(), context);

                    showDialog(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                        child: OrderDetail(orderNo: item.ORDER_NO.toString()),
                      ),
                    );
                  },
                )),
                ),

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
              DataColumn(label: Expanded(child: Text('사용기한', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('회원명', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('회원전화', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('등록자', textAlign: TextAlign.center)),),
              //DataColumn(label: Expanded(child: Text('상세', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('사용처', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('사용내역', textAlign: TextAlign.center)),
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
    await OrderController.to.getDetailData(orderNo.toString(), context);
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
