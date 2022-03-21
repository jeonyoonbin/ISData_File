

import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_input.dart';
import 'package:daeguro_admin_app/Model/coupon/B2BUsercouponListModel.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/View/CouponManager/B2BUsercouponEdit.dart';
import 'package:daeguro_admin_app/View/CouponManager/B2BUsercouponRegist.dart';
import 'package:daeguro_admin_app/View/CouponManager/coupon_controller.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/constants/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class B2BUserCouponList extends StatefulWidget {
  const B2BUserCouponList({Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return B2BUserCouponListState();
  }
}

class B2BUserCouponListState extends State<B2BUserCouponList> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  SearchItems _searchItems = new SearchItems();

  List<B2BUsercouponListModel> dataList = <B2BUsercouponListModel>[];
  String _divKey = '1';
  String _keyword ='';

  List codeItems = List();

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
  }

  _regist() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: B2BUserCouponRegist(),
      ),
    ).then((v) async {
      if (v != null){
        loadData();
      }
    });
  }

  _detail(String userId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: B2BUserCouponEdit(userId: userId),
      ),
    ).then((v) async {
      if (v != null){
        loadData();
      }
    });
  }

  _query() {
    CouponController.to.divKey.value = _divKey;
    CouponController.to.keyword.value = _keyword;
    CouponController.to.page.value = _currentPage;
    CouponController.to.raw.value = _selectedpagerows;
    loadData();
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

    //print('codeList:${CouponController.to.qB2BDataItems.toString()}');

    //codeItems = CouponController.to.qB2BDataItems;
    // CouponController.to.qB2BDataItems.forEach((element) {
    //   selectBox_couponType.add(new DropdownMenuItem(value: element['code'], child: Text(element['codeName'])));
    // });


    setState(() {});
  }

  loadData() async {
    await ISProgressDialog(context).show(status: 'Loading...');

    dataList.clear();

    await CouponController.to.getB2BUserData(_divKey, _keyword).then((value) {
      if (this.mounted) {
        if (value == null) {
          ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
        }
        else{
          //dataList.clear();
          value.forEach((e) {
            B2BUsercouponListModel tempData = B2BUsercouponListModel.fromJson(e);

            if (tempData.REG_DATE == 'null' || tempData.REG_DATE == null)
              tempData.REG_DATE = '';
            else
              tempData.REG_DATE = tempData.REG_DATE.replaceAll('T', '  ');

            dataList.add(tempData);
          });

          _totalRowCnt = CouponController.to.totalRowCnt;
          _totalPages = (_totalRowCnt / _selectedpagerows).ceil();

          setState(() {

          });
        }
      }
    });

    await ISProgressDialog(context).dismiss();
  }

  @override
  void initState() {
    super.initState();

    Get.put(CouponController());

    WidgetsBinding.instance.addPostFrameCallback((c) {
      //print('---- init run');
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
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              children: [
                Text('총: ${Utils.getCashComma(CouponController.to.totalRowCnt.toString())}건', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ISSearchDropdown(
                  label: '검색조건',
                  width: 120,
                  value: _divKey,
                  onChange: (value) {
                    setState(() {
                      _divKey = value;
                      _currentPage = 1;

                      _query();
                    });
                  },
                  item: [
                    DropdownMenuItem(value: '1', child: Text('쿠폰타입'),),
                    DropdownMenuItem(value: '2', child: Text('아이디'),),
                    DropdownMenuItem(value: '3', child: Text('회원명'),),
                    DropdownMenuItem(value: '4', child: Text('연락처'),),
                  ].cast<DropdownMenuItem<String>>(),
                ),
                ISSearchInput(
                  label: '쿠폰타입, 아이디, 회원명, 연락처',
                  width: 200,
                  value: _keyword,
                  onChange: (v) {
                    _keyword = v;
                  },
                  onFieldSubmitted: (value) {
                    _currentPage = 1;
                    _query();
                  },
                ),

                ISSearchButton(
                    label: '조회',
                    iconData: Icons.search,
                    onPressed: () => {_currentPage = 1, _query()}),
                SizedBox(width: 8,),
                if (AuthUtil.isAuthCreateEnabled('28') == true)
                ISSearchButton(label: '등록', iconData: Icons.add, onPressed: () => _regist()),
              ],
            ),
          ],
        ),
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
            panelHeight: (MediaQuery.of(context).size.height-defaultContentsHeight),
            listWidth: Responsive.getResponsiveWidth(context, 720),
            rows: dataList.map((item) {
              return DataRow(cells: [
                DataCell(Center(child: SelectableText(item.USER_ID.toString() ?? '--', style: TextStyle(color: Colors.black), showCursor: true,))),
                DataCell(Center(child: SelectableText(item.NAME.toString() ?? '--', style: TextStyle(color: Colors.black),showCursor: true,))),
                DataCell(Center(child: SelectableText(item.LOGIN_ID.toString() ?? '--', style: TextStyle(color: Colors.black),showCursor: true,))),
                DataCell(Center(child: SelectableText(Utils.getPhoneNumFormat(item.MOBILE.toString(), true) ?? '--', style: TextStyle(color: Colors.black),showCursor: true,))),
                DataCell(Center(child: SelectableText(_getCouponType(item.COUPON_TYPE) +'(${item.COUPON_TYPE})', style: TextStyle(color: Colors.black),showCursor: true,))),
                DataCell(Center(child: SelectableText(item.USE_YN.toString() ?? '--', style: TextStyle(color: Colors.black),showCursor: true,))),
                DataCell(Center(child: SelectableText(item.REG_DATE.toString() ?? '--', style: TextStyle(color: Colors.black),showCursor: true,))),
                DataCell(
                  Center(
                    child: InkWell(
                        onTap: () {
                          _detail(item.USER_ID.toString());
                        },
                        child: Icon(Icons.edit)
                    ),
                  ),
                ),
              ]);
            }).toList(),
            columns: <DataColumn>[
              DataColumn(label: Expanded(child: Text('회원아이디', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('회원명', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('로그인아이디', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('연락처', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('쿠폰타입', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('사용구분', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('등록일자', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('상세', textAlign: TextAlign.center)),),
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

  String _getCouponType(String codeGrp){
    String temp = '--';

    if (codeItems == null)
      return '--';

    //DropdownMenuItem(value: element['code'], child: Text(element['codeName'])
    for(final element in codeItems){
      if (element['code'] == codeGrp) {
        temp = element['codeName'];
        break;
      }
    };

    return temp;
  }
}
