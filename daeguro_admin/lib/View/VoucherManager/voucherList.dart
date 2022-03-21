
import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_input.dart';
import 'package:daeguro_admin_app/Model/coupon/couponBrandCodeList.dart';
import 'package:daeguro_admin_app/Model/coupon/couponBrandListModel.dart';
import 'package:daeguro_admin_app/Model/coupon/couponTypeList.dart';
import 'package:daeguro_admin_app/Model/voucher/VoucherTypeList.dart';
import 'package:daeguro_admin_app/Model/voucherListModel.dart';
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
import 'package:daeguro_admin_app/View/VoucherManager/voucherRegist.dart';
import 'package:daeguro_admin_app/View/VoucherManager/voucher_controller.dart';
import 'package:daeguro_admin_app/constants/constant.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class VoucherList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return VoucherListState();
  }
}

class VoucherListState extends State {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List codeItems = List();
  final List<voucherListModel> dataList = <voucherListModel>[];

  List<SelectOptionVO> BrandNameItems = [];
  List<SelectOptionVO> VoucherTypeItems = [];

  //int rowsPerPage = 10;

  int _totalRowCnt = 0;
  int _selectedpagerows = 15;

  String _chainCode = ' ';
  String _voucherType = ' ';
  String _voucherStatus = ' ';
  String _testYn = 'N';
  String _keyword = ' ';

  int _currentPage = 1;
  int _totalPages = 0;

  String _disYn = ' ';
  String _extensionYn = ' ';

  void _pageMove(int _page) {
    _query();
  }

  _reset() {
    formKey.currentState.reset();
    VoucherTypeItems.clear();

    _voucherType = ' ';
    _voucherStatus = ' ';
    _testYn = 'N';
    _keyword = ' ';
    VoucherController.to.VoucherTypeItems.clear();
    //loadData();
  }

  _query() {
    formKey.currentState.save();

    //CouponController.to.couponType.value = _couponType;
    //CouponController.to.couponB2BStatus.value = _couponStatus;

    VoucherController.to.page.value = _currentPage;
    VoucherController.to.rows.value = _selectedpagerows;

    loadVoucherTypeItemsListData();
    loadData();
  }

  _regist() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        //child: VoucherRegist(),
        // child: BrandCouponRegist(),
      ),
    ).then((v) async {
      if (v == true) {
        loadData();
      }
    });
  }

  _change() async {
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) => Dialog(
    //     child: BrandCouponChange(),
    //   ),
    // ).then((v) async {
    //   if (v == null) {
    //     loadData();
    //   }
    //   else{
    //     print('value:${v.toString()}');
    //     ISAlert(context, '쿠폰 변경 실패 \n\n' + v.toString());
    //   }
    // });
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

  // loadBrandListData() async {
  //   BrandNameItems.clear();
  //
  //   await CouponController.to.getBrandListItems().then((value) {
  //     BrandNameItems.add(new SelectOptionVO(value: ' ', label: '전체', label2: '',));
  //
  //     value.forEach((element) {
  //       CouponBrandCodeListModel tempData = CouponBrandCodeListModel.fromJson(element);
  //
  //       //ChainListItems.add(new SelectOptionVO(value: tempData.CODE, label: '[' + tempData.CODE + '] ' + tempData.CODE_NM, label2: tempData.CODE_NM,));
  //       BrandNameItems.add(new SelectOptionVO(value: tempData.CODE, label: tempData.CODE_NM, label2: tempData.CODE_NM,));
  //     });
  //
  //     setState(() {
  //     });
  //   });
  // }
  //
  loadVoucherTypeItemsListData() async {
    VoucherTypeItems.clear();
    String _div = _testYn=='Y' ? '1': '' ; //1이면 테스트 상품권, 그 외엔 상용
    await VoucherController.to.getVoucherControllerListItems(_div).then((value) {
      VoucherTypeItems.add(new SelectOptionVO(value: ' ', label: '전체', label2: '',));
      value.forEach((element) {
        VoucherTypeListModel tempData = VoucherTypeListModel.fromJson(element);
        //ChainCouponListItems.add(new SelectOptionVO(value: tempData.CODE, label: '[' + tempData.CODE + '] ' + tempData.CODE_NM, label2: tempData.CODE_NM,));
        //BrandCouponTypeItems.add(new SelectOptionVO(value: tempData.CODE, label: tempData.CODE_NM, label2: tempData.CODE_NM,));
        VoucherTypeItems.add(new SelectOptionVO(value: tempData.CODE, label: '[${tempData.CODE}] '+ tempData.CODE_NM, label2: '[${tempData.CODE}] '+ tempData.CODE_NM));
      });
      VoucherController.to.VoucherTypeItems.value = VoucherTypeItems;

      setState(() {
      });
    });
  }

  loadData() async {
    await ISProgressDialog(context).show(status: 'Loading...');
    dataList.clear();

    await VoucherController.to.getData(_testYn,_extensionYn,_voucherType,_voucherStatus,_keyword.trim()).then((value){
      if(value==null){
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }else{
        value.forEach((e) {
          voucherListModel temp = voucherListModel.fromJson(e);
          dataList.add(temp);
        });
        _totalRowCnt = VoucherController.to.totalRowCnt;
        _totalPages = (_totalRowCnt / _selectedpagerows).ceil();
      }
    });


    // await CouponController.to.getBrandData(_chainCode, _couponType, _couponStatus).then((value) {
    //   if (value == null) {
    //     ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    //   }
    //   else{
    //     if(this.mounted) {
    //       setState(() {
    //         value.forEach((e) {
    //           couponBrandListModel tempData = couponBrandListModel.fromJson(e);
    //
    //           if (tempData.CONF_DATE != null)
    //             tempData.CONF_DATE = tempData.CONF_DATE.replaceAll('T', '  ');
    //
    //           dataList.add(tempData);
    //         });
    //
    //         _totalRowCnt = CouponController.to.totalRowCnt;
    //         _totalPages = (_totalRowCnt / _selectedpagerows).ceil();
    //       });
    //     }
    //   }
    // });
    setState(() {
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
    Get.put(VoucherController());

    WidgetsBinding.instance.addPostFrameCallback((c) {
      // loadBrandListData();
      // loadBrandCouponListData('');

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
              Text('총: ${Utils.getCashComma(VoucherController.to.totalRowCnt.toString())}건', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
              SizedBox(width: 10),
              Text('미사용: ${Utils.getCashComma(VoucherController.to.notUse.toString())}건', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
              SizedBox(width: 10),
              Text('사용중: ${Utils.getCashComma(VoucherController.to.use.toString())}건', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
              SizedBox(width: 10),
              Text('사용완료: ${Utils.getCashComma(VoucherController.to.clear.toString())}건', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
              SizedBox(width: 10),
              Text('기간만료: ${Utils.getCashComma(VoucherController.to.exp.toString())}건', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ISSearchDropdown(
                  //   label: '상품권 타입',
                  //   value: _chainCode,
                  //   width: 170,
                  //   item: BrandNameItems.map((item) {
                  //     return new DropdownMenuItem<String>(
                  //         child: new Text(item.label, style: TextStyle(fontSize: 13, color: Colors.black),),
                  //         value: item.value);
                  //   }).toList(),
                  //   onChange: (v) {
                  //     // BrandNameItems.forEach((element) {
                  //     //   if (v == element.value) {
                  //     //     _chainCode = element.value;
                  //     //   }
                  //     // });
                  //     //
                  //     // _couponType = ' ';
                  //     //
                  //     // loadBrandCouponListData(v);
                  //     // _currentPage = 1;
                  //     // _query();
                  //   },
                  // ),

                  SizedBox(height: 8,),
                  ISSearchDropdown(
                    label: '상태',
                    width: 170,
                    value: _voucherStatus,
                    onChange: (value) {
                      setState(() {
                        _currentPage = 1;
                        _voucherStatus = value;
                        _query();
                      });
                    },
                    item: [
                      DropdownMenuItem(value: ' ', child: Text('전체')),
                      DropdownMenuItem(value: 'N', child: Text('미사용')),
                      DropdownMenuItem(value: 'U', child: Text('사용중')),
                      DropdownMenuItem(value: 'C', child: Text('사용완료')),
                      DropdownMenuItem(value: 'E', child: Text('기간만료')),
                    ].cast<DropdownMenuItem<String>>(),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ISSearchDropdown(
                    label: '구분',
                    width: 170,
                    value: _testYn,
                    onChange: (value) {
                      setState(() {
                        _currentPage = 1;
                        _testYn = value;
                        _query();
                      });
                    },
                    item: [
                      DropdownMenuItem(value: 'N', child: Text('상용')),
                      DropdownMenuItem(value: 'Y', child: Text('테스트')),
                    ].cast<DropdownMenuItem<String>>(),
                  ),
                  SizedBox(height: 8,),
                  ISSearchDropdown(
                    label: '유효기간 연장유무',
                    width: 170,
                    value: _extensionYn,
                    onChange: (value) {
                      setState(() {
                        _currentPage = 1;
                        _extensionYn = value;
                        _query();
                      });
                    },
                    item: [
                      DropdownMenuItem(value: ' ', child: Text('전체')),
                      DropdownMenuItem(value: 'Y', child: Text('연장')),
                      DropdownMenuItem(value: 'N', child: Text('미연장')),
                    ].cast<DropdownMenuItem<String>>(),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ISSearchDropdown(
                    label: '상품권 타입',
                    value: _voucherType,
                    width: 232,
                    item: VoucherController.to.VoucherTypeItems.value.map((item) {
                      return new DropdownMenuItem<String>(
                          child: new Text(item.label, style: TextStyle(fontSize: 13, color: Colors.black),),
                          value: item.value);
                    }).toList(),
                    onChange: (v) {
                      VoucherController.to.VoucherTypeItems.value.forEach((element) {
                        if (v == element.value) {
                          _voucherType = element.value;
                        }
                      });

                      _currentPage = 1;
                      _query();
                    },
                  ),
                  SizedBox(height: 8,),
                  ISSearchInput(
                    label: '상품권 번호',
                    width: 240,
                    value: _keyword,
                    // value: CouponController.to.keyword.value,
                    onChange: (v) {
                      _keyword = v;
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
                  Visibility(
                    visible: GetStorage().read('logininfo')['uCode'] == '35' // 전윤빈 대리
                        || GetStorage().read('logininfo')['uCode'] == '28' // 이나연 대리
                        || GetStorage().read('logininfo')['uCode'] == '183' // 이나연 대리
                        || GetStorage().read('logininfo')['uCode'] == '48' //r 이성훈 과장
                        || GetStorage().read('logininfo')['uCode'] == '3' // 이성훈 과장
                        || GetStorage().read('logininfo')['uCode'] == '321' // 최반야 사원
                        || GetStorage().read('logininfo')['uCode'] == '233' // 박소연 사원
                        || GetStorage().read('logininfo')['uCode'] == '3' // 이인찬 부장
                        || GetStorage().read('logininfo')['uCode'] == '7' // 김성근 이사
                        ? true : true, // 0316 - kjr true :false > true :true 로 변경
                    child: Row(
                      children: [
                        ISSearchButton(
                            width: 104,
                            label: '단일발송',
                            iconData: Icons.add,
                            onPressed: () => _regist()),
                        SizedBox(width: 8),
                        ISSearchButton(
                            width: 104,
                            label: '대량발송',
                            iconData: Icons.post_add_outlined,
                            onPressed: () => _change()),
                      ],
                    ),
                  ),
                  SizedBox(height: 8,),
                  ISSearchButton(
                      width: 216,
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
                DataCell(Align(child: SelectableText(item.VOUCHER_TYPE.toString() ?? '--', style: TextStyle(color: Colors.black), showCursor: true,), alignment: Alignment.center)),
                DataCell(Align(child: SelectableText(item.VOUCHER_NAME. toString() ?? '--', style: TextStyle(color: Colors.black), showCursor: true,), alignment: Alignment.center)),
                DataCell(Align(child: SelectableText(item.VOUCHER_NO.toString() ?? '--', style: TextStyle(color: Colors.black), showCursor: true,), alignment: Alignment.center)),
                DataCell(Center(child: SelectableText(Utils.getCashComma(item.VOUCHER_AMT.toString()) + '원' ?? '--', style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center(child: SelectableText(Utils.getCashComma(item.VOUCHER_REMAIN_AMT.toString()) + '원' ?? '--', style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center(child: SelectableText(item.STATUS.toString() ?? '--', style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center(child: SelectableText(item.REG_DATE.toString() == ' ' ? '--' : DateFormat("yyyy-MM-dd").format(DateTime.parse(item.REG_DATE.toString())).toString(), style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center(child: SelectableText(item.REG_EXP_DATE.toString() == ' ' ? '--' : DateFormat("yyyy-MM-dd").format(DateTime.parse(item.REG_EXP_DATE.toString())).toString(), style: TextStyle(color: Colors.black), showCursor: true))),
                // DataCell(Center(child: SelectableText('--'))),
                // DataCell(Center(child: SelectableText(item.USE_EXP_DATE.toString() == ' ' ? '--' : DateFormat("yyyy-MM-dd").format(DateTime.parse(item.USE_EXP_DATE.toString())).toString(), style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center(child: SelectableText(item.INS_DATE.toString() == ' ' ? '--' : DateFormat("yyyy-MM-dd").format(DateTime.parse(item.INS_DATE.toString())).toString(), style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center(child: SelectableText(item.INS_NAME.toString() == ' ' ? '--' : '[${item.INS_UCODE}]'+item.INS_NAME.toString(), style: TextStyle(color: Colors.black), showCursor: true))),
                //DataCell(Center(child: SelectableText(item.DIS_USE_DATE.toString() == ' ' ? '--' : DateFormat("yyyy-MM-dd").format(DateTime.parse(item.DIS_USE_DATE.toString())).toString(), style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center(child: SelectableText(item.CUST_NAME.toString() == ' ' ? '--' : '[${item.CUST_CODE}]'+item.CUST_NAME.toString(), style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Center(child: SelectableText(item.CUST_TELNO.toString() == ' ' ? '--' : Utils.getPhoneNumFormat(item.CUST_TELNO.toString(), true), style: TextStyle(color: Colors.black), showCursor: true))),
                DataCell(Align(child: SelectableText(item.EXTENSION_YN.toString() ?? '--', style: TextStyle(color: Colors.black), showCursor: true,), alignment: Alignment.center)),
                DataCell(Center(child: MaterialButton(
                  height: 36.0,
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  child: Text('환불처리', style: TextStyle(fontSize: 13, color: Colors.white)),
                  onPressed: () {
                  },
                ), ),
                ),
                DataCell(Center(child: MaterialButton(
                  height: 36.0,
                  color: Color.fromRGBO(192, 108, 132, 1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  child: Text('변경이력', style: TextStyle(fontSize: 13, color: Colors.white)),
                  onPressed: () async {
                  },
                )),
                ),
              ]);
            }).toList(),
            columns: <DataColumn>[
              DataColumn(label: Expanded(child: Text('상품권종류', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('상품권명', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('상품권번호', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('상품권액수', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('상품권잔액', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('상태', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('등록일자', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('등록유효기한', textAlign: TextAlign.center)),),
              // DataColumn(label: Expanded(child: Text('사용유효기한', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('발송날짜', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('발송담당자', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('회원명', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('회원전화', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('유효기간연장', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('환불처리', textAlign: TextAlign.center))),
              DataColumn(label: Expanded(child: Text('변경이력', textAlign: TextAlign.center)),
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

  // String _getStatus(String value) {
  //   String retValue = '--';
  //
  //   if (value.toString().compareTo('N') == 0)
  //     retValue = '미사용';
  //   else if (value.toString().compareTo('U') == 0)
  //     retValue = '사용중';
  //   else if (value.toString().compareTo('C') == 0)
  //     retValue = '사용완료';
  //   else if (value.toString().compareTo('E') == 0)
  //     retValue = '기간만료';
  //   return retValue;
  // }
}
