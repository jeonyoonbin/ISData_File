
import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/Model/coupon/couponBrandCodeList.dart';
import 'package:daeguro_admin_app/Model/coupon/couponHistoryModel.dart';
import 'package:daeguro_admin_app/Model/coupon/couponTypeList.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/View/CouponManager/coupon_controller.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/OrderManager/orderDetail.dart';
import 'package:daeguro_admin_app/View/OrderManager/orderManager_controller.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccountList.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/constants/constant.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class HistoryBrandCouponList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HistoryBrandCouponListState();
  }
}

class HistoryBrandCouponListState extends State {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final List<couponHistoryModel> dataList = <couponHistoryModel>[];

  List<SelectOptionVO> BrandNameItems = [];
  List<SelectOptionVO> BrandCouponTypeItems = [];

  SearchItems _searchItems = new SearchItems();

  //int rowsPerPage = 10;
  String _chainCode = ' ';
  String _couponType = ' ';

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

    _searchItems.startdate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    _searchItems.enddate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    //loadData();
  }

  _query() {
    CouponController.to.fromDate.value = _searchItems.startdate.replaceAll('-', '');
    CouponController.to.toDate.value = _searchItems.enddate.replaceAll('-', '');

    CouponController.to.page.value = _currentPage;
    CouponController.to.raw.value = _selectedpagerows;
    loadData();
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
        BrandCouponTypeItems.add(new SelectOptionVO(value: tempData.CODE, label: tempData.CODE_NM, label2: tempData.CODE_NM,));
      });

      setState(() {
      });
    });
  }

  loadData() async {
    await ISProgressDialog(context).show(status: 'Loading...');

    dataList.clear();

    await CouponController.to.getBrandHistoryData().then((value) {
      if (this.mounted) {
        if (value == null) {
          ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
        }
        else{
          setState(() {
            dataList.clear();
            value.forEach((e) {
              couponHistoryModel temp = couponHistoryModel.fromJson(e);
              dataList.add(temp);
            });

            _totalRowCnt = int.parse(CouponController.to.totalHistoryCnt.toString());
            _totalPages = (_totalRowCnt / _selectedpagerows).ceil();
          });
        }
      }
    });
    // dataList.clear();
    //
    // await NoticeController.to.getData(context);
    //
    // if (this.mounted) {
    //   setState(() {
    //     NoticeController.to.qData.forEach((e) {
    //       noticeListModel temp = noticeListModel.fromJson(e);
    //       dataList.add(temp);
    //     });
    //
    //     _totalRowCnt = NoticeController.to.totalRowCnt;
    //     _totalPages = (_totalRowCnt / _selectedpagerows).ceil();
    //   });
    // }

    await ISProgressDialog(context).dismiss();
  }

  @override
  void initState() {
    super.initState();

    Get.put(OrderController());
    Get.put(CouponController());

    WidgetsBinding.instance.addPostFrameCallback((c) {
      loadBrandListData();
      loadBrandCouponListData('');
      _reset();
      _query();
    });

    setState(() {
      _searchItems.startdate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
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
        children: [
          Row(
            children: [
              Text('총: ${Utils.getCashComma(CouponController.to.totalHistoryCnt.toString())}건', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  ISSearchDropdown(
                    label: '브랜드 구분',
                    value: _chainCode,
                    width: 200,
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
                  ISSearchSelectDate(
                    context,
                    label: '시작일',
                    width: 200,
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
                    label: '쿠폰 타입',
                    value: _couponType,
                    width: 200,
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
                  ISSearchSelectDate(
                    context,
                    label: '종료일',
                    width: 200,
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
              ISSearchButton(
                  label: '조회',
                  iconData: Icons.search,
                  onPressed: () => {_currentPage = 1, _query()}),
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
          ISDatatable(
            panelHeight: (MediaQuery.of(context).size.height-defaultContentsHeight)-48,
            listWidth: Responsive.getResponsiveWidth(context, 1000), // Responsive.isTablet(context) ? MediaQuery.of(context).size.width : contentListWidth,
            rows: dataList.map((item) {
              return DataRow(cells: [
                DataCell(Center(child: SelectableText(item.STATUS.toString() ?? '--', style: TextStyle(color: Colors.black), showCursor: true))),
                //DataCell(Align(child: SelectableText(item.SHOP_NAME.toString() ?? '--', style: TextStyle(color: Colors.black), showCursor: true),alignment: Alignment.centerLeft)),
                DataCell(Center(child: SelectableText(item.COUPON_NAME.toString() ?? '--', style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Align(child: SelectableText(item.COUPON_NO.toString() ?? '--', style: TextStyle(color: Colors.black), showCursor: true),alignment: Alignment.centerLeft)),
                DataCell(Center(child: SelectableText(Utils.getCashComma(item.COUPON_AMT.toString() ?? '0') , style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center( child: SelectableText(Utils.getYearMonthDayFormat(item.INS_DATE.toString()) ?? '--', style: TextStyle(color: Colors.black), showCursor: true),)),
                DataCell(Center(child: SelectableText((item.ST_DATE.toString() == null || item.ST_DATE.toString() == 'null') ? '' : Utils.getYearMonthDayFormat(item.ST_DATE.toString()), style: TextStyle(color: Colors.black), showCursor: true),)),
                DataCell(Center(child: SelectableText((item.ORDER_DATE.toString() == null || item.ORDER_DATE.toString() == 'null') ? '' : Utils.getYearMonthDayFormat(item.ORDER_DATE.toString()), style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center(child: SelectableText((item.EXP_DATE.toString() == null || item.EXP_DATE.toString() == 'null') ? '' : Utils.getYearMonthDayFormat(item.EXP_DATE.toString()), style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Align(child: (item.SHOP_NAME.toString() == null || item.SHOP_NAME.toString() == 'null') ? Container() : MaterialButton(
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
                DataCell(Center(child: (item.ORDER_NO.toString() == null || item.ORDER_NO.toString() == 'null') ? Container() : MaterialButton(
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
              DataColumn(label: Expanded(child: Text('상태', textAlign: TextAlign.center)), ),
              //DataColumn(label: Expanded(child: Text('가맹점명', textAlign: TextAlign.left)),),
              DataColumn(label: Expanded(child: Text('쿠폰명', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('쿠폰번호', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('쿠폰금액', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('발행일자', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('지급일자', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('사용일자', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('사용종료일', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('사용처', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('사용내역', textAlign: TextAlign.center)),),
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

  String _getNoticeGbn(String value) {
    String retValue = '--';

    if (value.toString().compareTo('1') == 0)
      retValue = '공지';
    else if (value.toString().compareTo('3') == 0) retValue = '이벤트';

    return retValue;
  }
}
