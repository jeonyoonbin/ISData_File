import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/Model/coupon/couponBrandAppListModel.dart';
import 'package:daeguro_admin_app/Model/coupon/couponBrandCodeList.dart';
import 'package:daeguro_admin_app/Model/coupon/couponTypeList.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/View/CouponManager/BrandcouponAppEdit.dart';
import 'package:daeguro_admin_app/View/CouponManager/BrandcouponAppRegist.dart';
import 'package:daeguro_admin_app/View/CouponManager/coupon_controller.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/constants/constant.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class BrandCouponApppManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BrandCouponApppManagerState();
  }
}

class BrandCouponApppManagerState extends State {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<SelectOptionVO> BrandNameItems = [];
  List<SelectOptionVO> BrandCouponTypeItems = [];
  List<String> shopList = [];

  List MCodeListitems = List();
  List codeItems = List();

  final List<couponBrandAppListModel> dataList = <couponBrandAppListModel>[];

  List<DropdownMenuItem> dropDownItem_UseMaxCount = [];

  //int rowsPerPage = 10;

  int _totalRowCnt = 0;
  int _selectedpagerows = 15;

  String _chainCode = ' ';
  String _couponType = ' ';

  //String _couponStatus = '10';
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

  updateData(String _shopCd, String _couponType, String _useYn, String _useMaxCount) async {
    await ISProgressDialog(context).show(status: 'Loading...');

    //print('_shopCd:${_shopCd}, _couponType:${_couponType}, _useYn:${_useYn}, _useMaxCount:${_useMaxCount}');

    shopList.clear();

    shopList.add(_shopCd);

    await CouponController.to.putBrandCouponShop(_couponType, _useYn, _useMaxCount, GetStorage().read('logininfo')['uCode'], GetStorage().read('logininfo')['name'], shopList, context);

    loadData();

    await ISProgressDialog(context).dismiss();
  }

  // loadMCodeListData() async {
  //   MCodeListitems.clear();
  //   MCodeListitems = await AgentController.to.getDataMCodeItems();
  //   //MCodeListitems = AgentController.to.qDataMCodeItems;
  //
  //   // if (this.mounted) {
  //   setState(() {});
  //   // }
  // }

  loadBrandListData() async {
    BrandNameItems.clear();

    await CouponController.to.getBrandListItems().then((value) {
      BrandNameItems.add(new SelectOptionVO(value: ' ', label: '전체', label2: '',));

      value.forEach((element) {
        CouponBrandCodeListModel tempData = CouponBrandCodeListModel.fromJson(element);

        //ChainListItems.add(new SelectOptionVO(value: tempData.CODE, label: '[' + tempData.CODE + '] ' + tempData.CODE_NM, label2: tempData.CODE_NM,));
        BrandNameItems.add(new SelectOptionVO(value: tempData.CODE, label: '[${tempData.CODE}] '+ tempData.CODE_NM, label2: '[${tempData.CODE}] '+ tempData.CODE_NM));
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
        BrandCouponTypeItems.add(new SelectOptionVO(value: tempData.CODE, label: '[${tempData.CODE}] '+ tempData.CODE_NM, label2: '[${tempData.CODE}] '+ tempData.CODE_NM));
      });

      setState(() {
      });
    });
  }

  loadData() async {
    await ISProgressDialog(context).show(status: 'Loading...');

    dataList.clear();

    await CouponController.to.getBrandCouponAppData(_chainCode, _couponType, _currentPage.round().toString(), _selectedpagerows.toString()).then((value) {
      //if (this.mounted) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        dataList.clear();

        if (value != null){
          value.forEach((e) {
            couponBrandAppListModel temp = couponBrandAppListModel.fromJson(e);

            dataList.add(temp);
          });
        }

        _totalRowCnt = CouponController.to.totalRowCnt;
        _totalPages = (_totalRowCnt / _selectedpagerows).ceil();
      }
      //}
    });

    setState(() {
    });

    await ISProgressDialog(context).dismiss();
  }

  _regist() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: BrandCouponAppRegist(),
      ),
    ).then((v) async {
      if (v != null){
        await Future.delayed(Duration(milliseconds: 500), (){
          loadData();
        });
      }
    });
  }

  _detail(String couponType) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: BrandCouponAppEdit(couponType: couponType),
      ),
    ).then((v) async {
      if (v != null){
        await Future.delayed(Duration(milliseconds: 500), (){
          loadData();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    Get.put(CouponController());

    for(int i = 0; i< 101; i++){
      if (i == 0){
        dropDownItem_UseMaxCount.add(new DropdownMenuItem(value: '${i}', child: Center(child: Text('무제한'))));
      }
      else{
        dropDownItem_UseMaxCount.add(new DropdownMenuItem(value: '${i}', child: Center(child: Text('${i}'))));
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((c) {
      loadBrandListData();
      loadBrandCouponListData('');
      //loadMCodeListData();
      _reset();
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
                    width: 220,
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
                    label: '쿠폰 타입',
                    value: _couponType,
                    width: 220,
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
                ],
              ),
              SizedBox(width: 8,),
              Column(
                children: [
                  if (AuthUtil.isAuthCreateEnabled('29') == true)
                  ISSearchButton(
                      label: '추가',
                      iconData: Icons.add,
                      width: 92,
                      onPressed: () => _regist()
                  ),
                  SizedBox(height: 8,),
                  ISSearchButton(
                      label: '조회',
                      iconData: Icons.search,
                      width: 92,
                      onPressed: () => {_currentPage = 1, _query()}
                  ),
                ],
              ),
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
            panelHeight: (MediaQuery.of(context).size.height - defaultContentsHeight) - 48,
            listWidth: Responsive.getResponsiveWidth(context, 1000), // Responsive.isTablet(context) ? MediaQuery.of(context).size.width : contentListWidth,
            rows: dataList.map((item) {
              return DataRow(cells: [
                DataCell(Align(child: SelectableText(item.CHAIN_NAME.toString() == null ? '--' : '['+ item.CHAIN_CODE.toString() +'] '+item.CHAIN_NAME.toString(),
                    style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.centerLeft)),
                // DataCell(Align(child: SelectableText(item.COUPON_NAME.toString() == null ? '--' : item.COUPON_NAME.toString(),
                //     style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.centerLeft)),
                // DataCell(Align(child: SelectableText(item.COUPON_TYPE.toString() == null ? '--' : item.COUPON_TYPE.toString(),
                //     style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.center)),
                DataCell(Align(child: SelectableText(item.COUPON_NAME.toString() == null ? '--' : '['+ item.COUPON_TYPE.toString() +'] '+item.COUPON_NAME.toString(),
                    style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.centerLeft)),
                DataCell(Align(child: SelectableText(Utils.getCashComma(item.ORDER_MIN_AMT.toString() ?? '0'),
                    style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.centerRight)),
                DataCell(Align(child: SelectableText(Utils.getCashComma(item.PAY_MIN_AMT.toString() ?? '0'),
                    style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.centerRight)),
                DataCell(Center(child: item.DELIVERY_YN.toString() == 'Y' ? Icon(Icons.radio_button_unchecked, color: Colors.blue, size: 16) : Icon(Icons.clear, color: Colors.red, size: 16))),
                DataCell(Center(child: item.PACK_YN.toString() == 'Y' ? Icon(Icons.radio_button_unchecked, color: Colors.blue, size: 16) : Icon(Icons.clear, color: Colors.red, size: 16))),
                DataCell(Align(child: SelectableText(item.DISPLAY_ST_DATE.toString() == ' ' ? '--' : DateFormat("yyyy-MM-dd").format(DateTime.parse(item.DISPLAY_ST_DATE.toString())).toString(),
                    style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.center)),
                DataCell(Align(child: SelectableText(item.DISPLAY_EXP_DATE.toString() == ' ' ? '--' : DateFormat("yyyy-MM-dd").format(DateTime.parse(item.DISPLAY_EXP_DATE.toString())).toString(),
                    style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.center)),
                DataCell(Center(child: item.USE_YN.toString() == 'Y' ? Icon(Icons.radio_button_unchecked, color: Colors.blue, size: 16) : Icon(Icons.clear, color: Colors.red, size: 16))),
                DataCell(
                  Center(
                    child: InkWell(
                        onTap: () {
                          _detail(item.COUPON_TYPE.toString());
                        },
                        child: Icon(Icons.edit)
                    ),
                  ),
                ),

              ]);
            }).toList(),
            columns: <DataColumn>[
              DataColumn(label: Expanded(child: Text('브랜드명', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('쿠폰명', textAlign: TextAlign.center)),),
              //DataColumn(label: Expanded(child: Text('쿠폰타입', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('최소\n주문금액(할인전)', textAlign: TextAlign.right, style: TextStyle(fontSize: 12))),),
              DataColumn(label: Expanded(child: Text('최소\n결제금액', textAlign: TextAlign.right, style: TextStyle(fontSize: 12))),),
              DataColumn(label: Expanded(child: Text('배달주문\n사용가능', textAlign: TextAlign.center, style: TextStyle(fontSize: 12))),),
              DataColumn(label: Expanded(child: Text('포장주문\n사용가능', textAlign: TextAlign.center, style: TextStyle(fontSize: 12))),),
              DataColumn(label: Expanded(child: Text('쿠폰발급가능\n시작일', textAlign: TextAlign.center, style: TextStyle(fontSize: 12))),),
              DataColumn(label: Expanded(child: Text('쿠폰발급가능\n종료일', textAlign: TextAlign.center, style: TextStyle(fontSize: 12))),),
              DataColumn(label: Expanded(child: Text('사용여부', textAlign: TextAlign.center)),),
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
                Text('조회 데이터 : ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),),
                Text(CouponController.to.totalRowCnt.toString() + ' 건', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                SizedBox(width: 20,),
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
}
