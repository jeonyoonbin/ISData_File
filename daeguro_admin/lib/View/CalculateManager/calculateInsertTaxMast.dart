
import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_input.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Model/shop/calculateUngeneratedTaxModel.dart';
import 'package:daeguro_admin_app/Model/shop/shopnew.dart';
import 'package:daeguro_admin_app/Network/BackendService.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/CalculateManager/calculateSearchShopTax.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/constants/constant.dart';

import 'package:date_format/date_format.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import 'calculate_controller.dart';

class CalculateInsertTaxMast extends StatefulWidget {
  final String shopName;

  const CalculateInsertTaxMast({Key key, this.shopName}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CalculateInsertTaxMastState();
  }
}

class CalculateInsertTaxMastState extends State<CalculateInsertTaxMast> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();

  List<ShopNewModel> shopNewData = [
    new ShopNewModel(tabName: '세금계산서 생성', isSaved: false),
    new ShopNewModel(tabName: '세금계산서 처리', isSaved: false),
  ];

  final ScrollController _scrollController = ScrollController();

  bool isCreateEnabled = false;
  bool isSearching = false;
  String searchKeyword = '';

  bool _shopGbn = false;
  String _div = 'I';
  String _jobGbn2 = 'P';

  List<CalculateUngeneratedTaxModel> dataListUngeneratedTax = <CalculateUngeneratedTaxModel>[];

  List<String> shopList = [];

  List<Map<String, String>> selShop = new List<Map<String, String>>();
  SearchItems _searchItems = new SearchItems();

  String _divKey = '1';

  String _ungenerated = '';
  String _generated = '';
  String _unpublished = '';
  String _published = '';

  _query() {
    CalculateController.to.startDate.value = _searchItems.startdate.replaceAll('-', '');
    CalculateController.to.name.value = _searchItems.name;
    CalculateController.to.divKey.value = _divKey;
    //loadData();
  }

  // 미 생성 가맹점 조회
  // loadData() async {
  //   print('date: ${_searchItems.startdate.replaceAll('-', '')}');
  //
  //   await CalculateController.to.getUngeneratedTaxData(_searchItems.startdate.replaceAll('-', ''), _jobGbn).timeout(const Duration(seconds: 10), onTimeout: () {
  //     print('타임아웃 : 시간초과(10초)');
  //   }).then((value) async {
  //     _scrollController.jumpTo(0.0);
  //
  //     // if (this.mounted) {
  //     //
  //     // }
  //
  //     if (value == null) {
  //       ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
  //     }
  //     else {
  //       setState(() {
  //         dataListUngeneratedTax.clear();
  //
  //         value.forEach((e) {
  //           CalculateUngeneratedTaxModel temp = CalculateUngeneratedTaxModel.fromJson(e);
  //
  //           dataListUngeneratedTax.add(temp);
  //         });
  //       });
  //     }
  //   });
  // }

  loadCountData() async {
    await ISProgressDialog(context).show(status: 'Loading...');

    await CalculateController.to.getCount(_searchItems.startdate.replaceAll('-', ''), _jobGbn2).then((value) async {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        //print('loadCountDate -> ${value.toString()}');

        _ungenerated = value.data['ungenerated'];
        _generated = value.data['generated'];
        _unpublished = value.data['unpublished'];
        _published = value.data['published'];

        //print('loadCountDate -> _ungenerated:${_ungenerated}, _generated:${_generated}, _unpublished:${_unpublished}, _published:${_published}');

        setState(() {
          //_scrollController.jumpTo(0.0);
          // dataListUngeneratedTax.clear();
          //
          // value.forEach((e) {
          //   CalculateUngeneratedTaxModel temp = CalculateUngeneratedTaxModel.fromJson(e);
          //
          //   dataListUngeneratedTax.add(temp);
          // });
        });
      }
    });

    await ISProgressDialog(context).dismiss();
  }

  loadCreateTaxData() async {
    await ISProgressDialog(context).show(status: 'Loading...');

    shopList.clear();

    if (selShop.length == 0){
      shopList.add('1');
    }
    else{
      selShop.forEach((element) {
        shopList.add(element['shopCd']);
      });
    }

    String uCode = GetStorage().read('logininfo')['uCode'];
    String uName = GetStorage().read('logininfo')['name'];

    //print('_div:${_div}, _jobGbn2:${_jobGbn2}, feeYm :${_searchItems.startdate.replaceAll('-', '')}, memo:${_searchItems.memo}, uCode:${uCode}, uName:${uName}, shopList.length:${shopList.length.toString()}');

    await CalculateController.to.postInsertTaxMastData(_div, _jobGbn2, _searchItems.startdate.replaceAll('-', ''), _searchItems.memo, uCode, uName, shopList).timeout(const Duration(seconds: 15),
        onTimeout: () {
          print('타임아웃 : 시간초과(15초)');
        }).then((value) async {
            loadCountData();
        });

    await ISProgressDialog(context).dismiss();
  }

  loadPublishTaxBillData() async {
    await ISProgressDialog(context).show(status: 'Loading...');

    shopList.clear();
    if (selShop.length == 0){
      shopList.add('1');
    }
    else {
      selShop.forEach((element) {
        shopList.add(element['shopCd']);
      });
    }

    String uCode = GetStorage().read('logininfo')['uCode'];
    String uName = GetStorage().read('logininfo')['name'];

    String _jobGbn = '1';//1 발행요청 / 2 발행취소 / 3 국세청 전송 / 4 세금계산서 삭제

    await CalculateController.to.putTaxBillData(_jobGbn, _jobGbn2, _div, _searchItems.startdate.replaceAll('-', ''), 'N', uCode, uName, shopList).timeout(const Duration(seconds: 15),
        onTimeout: () {
          print('타임아웃 : 시간초과(15초)');
        }).then((value) {
            loadCountData();
        });

    await ISProgressDialog(context).dismiss();
  }

  @override
  void initState() {
    super.initState();

    Get.put(ShopController());
    Get.put(CalculateController());

    //setState(() {
      var date = new DateTime.now();
    _searchItems.startdate = formatDate(DateTime(date.year, date.month - 1, date.day), [yyyy, '-', mm]);

    //});

    WidgetsBinding.instance.addPostFrameCallback((c) {
      loadCountData();
    });
  }

  @override
  void dispose() {
    if (dataListUngeneratedTax != null) {
      dataListUngeneratedTax.clear();
      dataListUngeneratedTax = null;
    }

    if (_scrollController != null)
      _scrollController.dispose();

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

    return Container(
      //padding: EdgeInsets.only(left: 50, right: 50, bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 10),
          form,
          //buttonBar,
          //Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 500,
                height: (MediaQuery.of(context).size.height-80),
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: Colors.black26, offset: Offset(2.0, 2.0), blurRadius: 4.0),
                  ],
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              ISSearchDropdown(
                                label: '가맹점 구분',
                                width: 200,
                                value: _div,
                                onChange: (value) {
                                  setState(() {
                                    if (EasyLoading.isShow == true) return;
                                    _div = value;
                                  });
                                },
                                item: [
                                  DropdownMenuItem(value: 'I', child: Text('선택 가맹점만'),),
                                  DropdownMenuItem(value: 'O', child: Text('선택 가맹점제외'),),
                                ].cast<DropdownMenuItem<String>>(),
                              ),
                              SizedBox(height: 10,),
                              ISSearchDropdown(
                                label: '수수료 구분',
                                width: 200,
                                value: _jobGbn2,
                                onChange: (value) {
                                  setState(() {
                                    if (EasyLoading.isShow == true) return;
                                      _jobGbn2 = value;
                                  });

                                  loadCountData();
                                },
                                item: [
                                  DropdownMenuItem(value: 'P', child: Text('중계 수수료'),),
                                  DropdownMenuItem(value: 'K', child: Text('카드 수수료'),),
                                ].cast<DropdownMenuItem<String>>(),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                padding: EdgeInsets.only(left: 8.0),
                                child: ISSearchInput(
                                  label: '정산월',
                                  width: 208,
                                  readOnly: true,
                                  value: Utils.getYearMonthFormat(_searchItems.startdate),
                                  onChange: (v) {
                                    _searchItems.startdate = v;
                                  },
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.calendar_today),
                                    iconSize: 17,
                                    splashRadius: 20,
                                    color: Colors.blue,
                                    onPressed: () {
                                      showMonthPicker(
                                        context: context,
                                        firstDate: DateTime(DateTime.now().year - 10, 5),
                                        lastDate: DateTime(DateTime.now().year + 10, 9),
                                        initialDate: DateTime.now(),
                                      ).then((date) {
                                        if (date != null) {
                                          _searchItems.startdate = formatDate(date, [yyyy, '-', mm]);//formatDate(date, [yyyy, mm]);

                                          loadCountData();
                                        }
                                      });
                                    },
                                  ),
                                  onFieldSubmitted: (v) {},
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 8.0),
                          child: ISInput(
                            label: '메모',
                            width: 260,
                            value: _searchItems.memo,
                            maxLines: 8,
                            height: 140,
                            keyboardType: TextInputType.multiline,
                            prefixIcon: Icon(Icons.event_note, color: Colors.grey),
                            textStyle: TextStyle(fontSize: 12),
                            onChange: (v) {
                              _searchItems.memo = v;
                            },
                            onFieldSubmitted: (v) {
                              _query();
                            },
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 30,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 500,
                          padding: EdgeInsets.only(right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                width: 360,
                                height: 40,
                                padding: EdgeInsets.only(left: 10),
                                child: TypeAheadFormField(
                                  textFieldConfiguration: TextFieldConfiguration(
                                    //focusNode: searchBoxFocusNode,
                                    cursorColor: Colors.black,
                                    style: TextStyle(color: Colors.black, fontSize: 13.0),
                                    decoration: InputDecoration(
                                        fillColor: Colors.grey[100],
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: const BorderRadius.all(Radius.circular(6)),
                                        ),
                                        hintText: '가맹점 검색...',
                                        hintStyle: TextStyle(color: Colors.black38),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
                                        suffixIcon: InkWell(
                                          child: Icon(Icons.cancel, size: 16, color: Colors.grey,),
                                          onTap: () {
                                            if (_typeAheadController == null /* || _typeAheadController.text.isEmpty*/) {
                                              return;
                                            }
                                            disableSearching(); //clearSearchKeyword();
                                          },
                                        )
                                    ),
                                    controller: this._typeAheadController,
                                  ),
                                  suggestionsCallback: (pattern) async {
                                    return await BackendService.getCopyMenuShopSuggestions('2', pattern);
                                  },
                                  itemBuilder: (context, Map<String, String> suggestion) {
                                    return ListTile(
                                      title: Text('[' + suggestion['shopCd'] + '] ' + suggestion['shopName'], style: TextStyle(fontSize: 14),),
                                      //subtitle: Text('\$${suggestion['shopCd']}'),
                                    );
                                  },
                                  transitionBuilder: (context, suggstionsBox, controller) {
                                    return suggstionsBox;
                                  },
                                  onSuggestionSelected: (Map<String, String> suggestion) async {
                                    //updateSearchKeyword(suggestion['shopName'].toString());
                                    clearSearchKeyword();

                                    _shopGbn = false;

                                    // 가맹점 중복 선택 안되도록
                                    for (var e in selShop) {
                                      if (e['shopCd'] == suggestion['shopCd']) {
                                        _shopGbn = true;
                                        break;
                                      }
                                    }

                                    if (_shopGbn == false) {
                                      selShop.add(suggestion);
                                    }
                                  },
                                ),
                              ),
                              SizedBox(width: 10,),
                              Container(
                                child: ISSearchButton(
                                    label: '초기화',
                                    textStyle: TextStyle(color: Colors.white),
                                    iconData: Icons.refresh,
                                    onPressed: () => {selShop.clear(), setState(() {})}),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),//all(10.0),
                          height: (MediaQuery.of(context).size.height-395),
                          //color: Colors.yellow,
                          child: ISDatatable(
                            listWidth: 500,
                            // showCheckboxColumn: true,
                            dataRowHeight: 36,
                            rows: selShop.map((item) {
                              return DataRow(cells: [
                                DataCell(Center(child: SelectableText(item['shopCd'] ?? '--', style: TextStyle(color: Colors.black), showCursor: true))),
                                DataCell(Align(child: SelectableText(item['shopName'] ?? '--', style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.centerLeft)),
                                DataCell(Center(
                                  child: IconButton(
                                    onPressed: () {
                                      selShop.removeWhere((element) => element['shopCd'] == item['shopCd']);

                                      setState(() {
                                        isCreateEnabled = true;
                                      });
                                    },
                                    icon: Icon(Icons.cancel),
                                    tooltip: '삭제',
                                  ),
                                )),
                              ]);
                            }).toList(),
                            columns: <DataColumn>[
                              DataColumn(label: Expanded(child: Text('가맹점번호', textAlign: TextAlign.center)),),
                              DataColumn(label: Expanded(child: Text('가맹점명', textAlign: TextAlign.left)),),
                              DataColumn(label: Expanded(child: Text('삭제', textAlign: TextAlign.center)),),
                            ],
                          ),
                        )
                      ],
                    ),
                    // Divider(height: 30,),
                    // Container(
                    //   alignment: Alignment.center,
                    //   child: ISSearchButton(
                    //       label: '일괄 생성',
                    //       iconData: Icons.create,
                    //       onPressed: () => {
                    //         ISConfirm(context, '일괄 생성', '일괄 생성 하시겠습니까?', (context) async {
                    //           Navigator.of(context).pop();
                    //
                    //           shopList.clear();
                    //
                    //           selShop.forEach((element) {
                    //             shopList.add(element['shopCd']);
                    //           });
                    //
                    //           await EasyLoading.show(status: 'Loading...');
                    //
                    //           String uCode = GetStorage().read('logininfo')['uCode'];
                    //           String uName = GetStorage().read('logininfo')['name'];
                    //
                    //           print('_div:${_div}, _jobGbn:${_jobGbn}, startDate:${_searchItems.startdate.replaceAll('-', '')}, memo:${_searchItems.memo}, uCode:${uCode}, uName:${uName}, shopList.length:${shopList.length.toString()}');
                    //
                    //           await CalculateController.to.postInsertTaxMastData(_div, _jobGbn, _searchItems.startdate.replaceAll('-', ''), _searchItems.memo, uCode, uName, shopList.length.toString(), shopList, context).timeout(const Duration(seconds: 15),
                    //               onTimeout: () {
                    //                 print('타임아웃 : 시간초과(15초)');
                    //               }).then((value) {
                    //             // _listGbn = '1';
                    //             loadData();
                    //           });
                    //
                    //           await EasyLoading.dismiss();
                    //         })
                    //       }),
                    // )
                  ],
                ),
              ),
              Container(
                width: getListMainPanelWidth(),
                height: (MediaQuery.of(context).size.height-80),
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, offset: Offset(2.0, 2.0), blurRadius: 4.0),
                  ],
                ),
                child: Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 4.0, bottom: 4.0),//all(10.0),
                  height: (MediaQuery.of(context).size.height-375),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${_searchItems.startdate.replaceAll('-', '.')}월분 '+ (_jobGbn2 == 'P' ? '중계수수료' : '카드수수료') + '건', style: TextStyle(fontSize: 20)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('생성건수: ', style: TextStyle(fontSize: 20)),
                          MaterialButton(
                             height: 30.0,
                             color: (_generated.toString() == '0') ?  Colors.grey.shade300 : Colors.green,
                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                             child: Text('${Utils.getCashComma(_generated)}', style: TextStyle(fontSize: 20, color: Colors.white,)),
                             onPressed: () {
                               double poupWidth = 1100;
                               double poupHeight = 600;

                               showDialog(
                                 context: context,
                                 builder: (BuildContext context) => Dialog(
                                   child: SizedBox(
                                     width: poupWidth,
                                     height: poupHeight,
                                     child: Scaffold(
                                       appBar: AppBar(
                                         title: Text('${_searchItems.startdate.replaceAll('-', '.')}월분 생성정보'),
                                       ),
                                       body: CalculateSearchShopTax(feeYm: _searchItems.startdate.replaceAll('-', ''), chargeGbn: _jobGbn2, gbn: 'P', prtYn: '%', popWidth: poupWidth, popHeight: poupHeight),
                                     ),
                                   ),
                                 ),
                               );
                             },
                          ),
                          Text(' / 미생성건수: ', style: TextStyle(fontSize: 20)),
                          MaterialButton(
                            height: 30.0,
                            color: (_ungenerated.toString() == '0') ?  Colors.grey.shade300 : Colors.blue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                            child: Text('${Utils.getCashComma(_ungenerated)}', style: TextStyle(fontSize: 20, color: Colors.white,)),
                            onPressed: () {
                              double poupWidth = 1100;
                              double poupHeight = 600;

                              showDialog(
                                context: context,
                                builder: (BuildContext context) => Dialog(
                                  child: SizedBox(
                                    width: poupWidth,
                                    height: poupHeight,
                                    child: Scaffold(
                                      appBar: AppBar(
                                        title: Text('${_searchItems.startdate.replaceAll('-', '.')}월분 미생성정보'),
                                      ),
                                      body: CalculateSearchShopTax(feeYm: _searchItems.startdate.replaceAll('-', ''), chargeGbn: _jobGbn2, gbn: 'C', prtYn: '%', popWidth: poupWidth, popHeight: poupHeight),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      //Text('${_searchItems.startdate.replaceAll('-', '.')}월분 기존) 생성건수: ${Utils.getCashComma(_generated)} / 미생성건수: ${Utils.getCashComma(_ungenerated)}', style: TextStyle(fontSize: 20),),

                      if (AuthUtil.isAuthEditEnabled('23') == true)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MaterialButton(
                            color: Colors.blue,
                            minWidth: 500,
                            height: 100,
                            child: Text('일괄 생성', style: TextStyle(color: Colors.white, fontSize: 18),),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                            onPressed: () async {
                              ISConfirm(context, '일괄 생성', '일괄 생성 하시겠습니까?', (context) async {
                                Navigator.of(context).pop();

                                loadCreateTaxData();
                              });
                            },
                          ),
                        ],
                      ),
                      Divider(),
                      Text('${_searchItems.startdate.replaceAll('-', '.')}월분 '+ (_jobGbn2 == 'P' ? '중계수수료' : '카드수수료') + '건', style: TextStyle(fontSize: 20)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('발행건수: ', style: TextStyle(fontSize: 20)),
                          MaterialButton(
                            height: 30.0,
                            color: (_published.toString() == '0') ?  Colors.grey.shade300 : Colors.green,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                            child: Text('${Utils.getCashComma(_published)}', style: TextStyle(fontSize: 20, color: Colors.white,)),
                            onPressed: () {
                              double poupWidth = 1100;
                              double poupHeight = 600;

                              showDialog(
                                context: context,
                                builder: (BuildContext context) => Dialog(
                                  child: SizedBox(
                                    width: poupWidth,
                                    height: poupHeight,
                                    child: Scaffold(
                                      appBar: AppBar(
                                        title: Text('${_searchItems.startdate.replaceAll('-', '.')}월분 발행정보'),
                                      ),
                                      body: CalculateSearchShopTax(feeYm: _searchItems.startdate.replaceAll('-', ''), chargeGbn: _jobGbn2, gbn: 'R', prtYn: 'Y', popWidth: poupWidth, popHeight: poupHeight),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          Text(' / 미발행건수: ', style: TextStyle(fontSize: 20)),
                          MaterialButton(
                            height: 30.0,
                            color: (_unpublished.toString() == '0') ?  Colors.grey.shade300 : Colors.blue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                            child: Text('${Utils.getCashComma(_unpublished)}', style: TextStyle(fontSize: 20, color: Colors.white,)),
                            onPressed: () {
                              double poupWidth = 1100;
                              double poupHeight = 600;

                              showDialog(
                                context: context,
                                builder: (BuildContext context) => Dialog(
                                  child: SizedBox(
                                    width: poupWidth,
                                    height: poupHeight,
                                    child: Scaffold(
                                      appBar: AppBar(
                                        title: Text('${_searchItems.startdate.replaceAll('-', '.')}월분 미발행정보'),
                                      ),
                                      body: CalculateSearchShopTax(feeYm: _searchItems.startdate.replaceAll('-', ''), chargeGbn: _jobGbn2, gbn: 'R', prtYn: 'N', popWidth: poupWidth, popHeight: poupHeight),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      //Text('${_searchItems.startdate.replaceAll('-', '.')}월분 기존) 발행건수: ${Utils.getCashComma(_published)} / 미발행건수: ${Utils.getCashComma(_unpublished)}', style: TextStyle(fontSize: 20),),
                      if (AuthUtil.isAuthEditEnabled('23') == true)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MaterialButton(
                            color: Colors.blue,
                            minWidth: 500,
                            height: 100,
                            child: Text('일괄 발행', style: TextStyle(color: Colors.white, fontSize: 18),),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                            onPressed: () async {
                              ISConfirm(context, '일괄 발행', '일괄 발행 하시겠습니까?', (context) async {
                                Navigator.of(context).pop();

                                loadPublishTaxBillData();
                              });
                            },
                          ),
                          // SizedBox(height: 20),
                          // Column(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Text('실행 결과)', style: TextStyle(color: Colors.black, fontSize: 16),),
                          //     Text('발행 가맹점 수: ', style: TextStyle(color: Colors.blue, fontSize: 16),),
                          //     Text('미발행 가맹점 수: ', style: TextStyle(color: Colors.red, fontSize: 16),),
                          //   ],
                          // )
                        ],
                      ),
                    ],
                  )
                  // child: Column(
                  //   children: [
                  //     Container(
                  //       child: isCreateEnabled == false ? Text('- 미 생성 가맹점 목록', style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),) : MaterialButton(
                  //         height: 30.0,
                  //         color: Colors.blue,
                  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  //         child: Text('- 미 생성 가맹점 목록', style: TextStyle(fontSize: 14, color: Colors.white),),
                  //         onPressed: () async {
                  //           //_listGbn = '1';
                  //           loadData();
                  //         },
                  //       ),
                  //       //child: ,
                  //       alignment: Alignment.centerLeft,
                  //       margin: EdgeInsets.all(5),
                  //     ),
                  //     ISDatatable(
                  //       controller: _scrollController,
                  //       // showCheckboxColumn: true,
                  //       panelHeight: (MediaQuery.of(context).size.height)-140,
                  //       listWidth: getListMainPanelWidth(),
                  //       rows: dataListUngeneratedTax.map((item) {
                  //         return DataRow(cells: [
                  //           DataCell(Align(child: SelectableText(item.shopName.toString() == null ? '--' : '['+ item.shopCd.toString() +'] '+item.shopName.toString(), style: TextStyle(color: Colors.black), showCursor: true,), alignment: Alignment.centerLeft)),
                  //           DataCell(Center(child: SelectableText(Utils.getStoreRegNumberFormat(item.regNo) ?? '--', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true))),
                  //           DataCell(Center(child: SelectableText(Utils.getYearMonthFormat(item.chargeYm) ?? '--', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true))),
                  //           DataCell(Center(child: SelectableText(Utils.getYearMonthDayFormat(item.issymd) ?? '--', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true))),
                  //           DataCell(Align(child: SelectableText(Utils.getCashComma(item.chargeAmt) ?? '--', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true), alignment: Alignment.centerRight)),
                  //         ]);
                  //       }).toList(),
                  //       columns: <DataColumn>[
                  //         DataColumn(label: Expanded(child: Text('가맹점명', textAlign: TextAlign.center)),),
                  //         DataColumn(label: Expanded(child: Text('사업자번호', textAlign: TextAlign.center)),),
                  //         DataColumn(label: Expanded(child: Text('정산월', textAlign: TextAlign.center)),),
                  //         DataColumn(label: Expanded(child: Text('처리일', textAlign: TextAlign.center)),),
                  //         DataColumn(label: Expanded(child: Text('정산금액', textAlign: TextAlign.center)),),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  double getListMainPanelWidth(){
    double nWidth = MediaQuery.of(context).size.width-800;
    if (Responsive.isTablet(context) == true)           nWidth = nWidth + sidebarWidth;
    else if (Responsive.isMobile(context) == true)      nWidth = MediaQuery.of(context).size.width;

    return nWidth;
  }

  void disableSearching() {
    clearSearchKeyword();

    setState(() {
      isSearching = false;
    });
  }

  void clearSearchKeyword() {
    setState(() {
      _typeAheadController.clear();
      updateSearchKeyword('');
    });
  }

  void updateSearchKeyword(String newKeyword) {
    setState(() {
      searchKeyword = newKeyword;
      _typeAheadController.text = searchKeyword;
    });
  }
}
