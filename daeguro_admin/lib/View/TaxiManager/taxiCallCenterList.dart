import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/Model/ceoSiteModel.dart';
import 'package:daeguro_admin_app/Model/shopAccountModel.dart';
import 'package:daeguro_admin_app/Network/DioClient.dart';

import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccountMoveReview.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopDetailNotifierData.dart';
import 'package:daeguro_admin_app/View/TaxiManager/taxiCallCenterBannerInfo.dart';
import 'package:daeguro_admin_app/View/TaxiManager/taxiCallCenterBasicInfo.dart';
import 'package:daeguro_admin_app/View/TaxiManager/taxiCallCenterHistoryInfo.dart';
import 'package:daeguro_admin_app/View/TaxiManager/taxiCallCenterRegist.dart';
import 'package:daeguro_admin_app/View/TaxiManager/taxiCallCenterSavedMoneyInfo.dart';
import 'package:daeguro_admin_app/View/TaxiManager/taxiCallCenterTermsInfo.dart';
import 'package:daeguro_admin_app/constants/constant.dart';

import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_input.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';

import 'package:daeguro_admin_app/Model/user/user_code_name.dart';
import 'package:daeguro_admin_app/View/AgentManager/agentAccount_Controller.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopBasicInfo.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopCalcInfo.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopDeliTip.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopInfo.dart';
import 'package:daeguro_admin_app/View/ShopManager/Menu/shopMenu_main.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopNew.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopOperateInfo.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopSectorInfo.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/View/UserManager/user_controller.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';

import 'package:date_format/date_format.dart';
import 'package:encrypt/encrypt.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' show AnchorElement;

import 'package:encrypt/encrypt.dart' as EncryptPack;
import 'package:crypto/crypto.dart' as CryptoPack;
import 'dart:convert' as ConvertPack;

class TaxiCallCenterList extends StatefulWidget {
  final String shopName;
  final double popWidth;
  final double popHeight;

  const TaxiCallCenterList({key, this.shopName, this.popWidth, this.popHeight}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TaxiCallCenterListState();
  }
}

class TaxiCallCenterListState extends State<TaxiCallCenterList> with SingleTickerProviderStateMixin {
  get secureStorage => null;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool excelEnable = true;

  TabController _nestedTabController;

  //int current_tabIdx = 0;

  StreamController<ShopDetailNotifierData> streamControllerBasicInfo = StreamController<ShopDetailNotifierData>();
  StreamController<ShopDetailNotifierData> streamControllerTermsInfo = StreamController<ShopDetailNotifierData>();
  StreamController<ShopDetailNotifierData> streamControllerCalcInfo = StreamController<ShopDetailNotifierData>();
  StreamController<ShopDetailNotifierData> streamControllerInfo = StreamController<ShopDetailNotifierData>();
  StreamController<ShopDetailNotifierData> streamControllerSectorInfo = StreamController<ShopDetailNotifierData>();
  StreamController<ShopDetailNotifierData> streamControllerDeliTip = StreamController<ShopDetailNotifierData>();
  StreamController<ShopDetailNotifierData> streamControllerOperateInfo = StreamController<ShopDetailNotifierData>();

  final List<ShopAccountModel> dataList = <ShopAccountModel>[];

  final List<CeoSiteModel> _ceoSiteModel = <CeoSiteModel>[];

  List MCodeListitems = List();

  List<SelectOptionVO> selectBox_operator = [];
  List<SelectOptionVO> selectBox_operatorBasicInfo = [];
  List<SelectOptionVO> selectBox_salesmanBasicInfo = [];
  List<SelectOptionVO> selectBox_ccCodeBasicInfo = [];
  List<SelectOptionVO> selectBox_brandTypeBasicInfo = [];
  List<SelectOptionVO> selectBox_reserve_itemCd = [];
  List<SelectOptionVO> selectBox_reserve_subitemCd = [];

  List<DropdownMenuItem> selectBox_imageStatus = [
    DropdownMenuItem(
      value: '0',
      child: Text('대기'),
    ),
    DropdownMenuItem(
      value: '1',
      child: Text('요청'),
    ),
    DropdownMenuItem(
      value: '2',
      child: Text('배정'),
    ),
    DropdownMenuItem(
      value: '3',
      child: Text('완료'),
    ),
    DropdownMenuItem(
      value: '4',
      child: Text('승인'),
    ),
    DropdownMenuItem(
      value: '',
      child: Text('--'),
    ),
  ];

  int _testOrderCnt = 0;

  SearchItems _searchItems = new SearchItems();

  bool _chkDate = false;
  bool isCheckAll = false;

  int _totalRowCnt = 0;
  int _selectedpagerows = 15;

  int _currentPage = 1;
  int _totalPages = 0;

  String _mCode = '2';

  String _operator_code = ' ';

  String _selectedViewSeq = '';

  String _selectedCcCode = '';

  ShopDetailNotifierData mDetailData = ShopDetailNotifierData();
  final ScrollController _scrollController = ScrollController();

  String nSelectedShopTitle = '';

  void _pageMove(int _page) {
    _query();
  }

  _reset() {
    dataList.clear();

    _searchItems = null;
    _searchItems = new SearchItems();

    if (widget.shopName != null)
      _searchItems.code = widget.shopName;
    else
      _searchItems.code = '';

    //_searchItems.imagestatus = ' ';
    _searchItems.app_order_yn = ' ';
    _searchItems.reg_no_yn = ' ';
    _searchItems.memo_yn = ' ';
    _searchItems.use_yn = ' ';
    _searchItems.img_yn = ' ';
    //formKey.currentState.reset();
    //loadData();
  }

  _query() {
    loadData();
  }

  _registCallCenter() {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: TaxiCallCenterRegist(selectBox_ccCode: selectBox_ccCodeBasicInfo,),
      ),
    ).then((v) async {
      await Future.delayed(Duration(milliseconds: 500), () {
        _query();
      });
    });
  }

  _editMoveReview({String shopCode}) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
              child: ShopMoveReview(mCode: _mCode, fromShopCode: shopCode),
            )).then((v) async {
      if (v != null) {
        await Future.delayed(Duration(milliseconds: 500), () {
          _query();
        });
      }
    });
  }

  _editMenuGroup({String ccCode, String shopCode, String menuComplete}) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: ShopMenuMain(mCode: _mCode, ccCode: ccCode, shopCode: shopCode, menuComplete: menuComplete),
      ),
    ).then((v) async {
      await Future.delayed(Duration(milliseconds: 500), () {
        _query();
      });
    });
  }

  loadCallCenterListData() async {
    selectBox_ccCodeBasicInfo.clear();

    await AgentController.to.getDataCCenterItems(_mCode).then((value) {
      if (value == null) {
        ISAlert(context, '콜센터정보를 가져오지 못했습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        value.forEach((element) {
          selectBox_ccCodeBasicInfo.add(new SelectOptionVO(value: element['ccCode'], label: element['ccName']));
        });

        //setState(() {        });
      }
    });
  }

  loadData() async {
    await ISProgressDialog(context).show(status: 'Loading...');

    dataList.clear();

    _testOrderCnt = 0;

    MCodeListitems = Utils.getMCodeList(); //AgentController.to.qDataMCodeItems;

    _scrollController.jumpTo(0.0);

    //if (this.mounted) {
    setState(() {});

    await ISProgressDialog(context).dismiss();
  }

  void setDetailViewNullData() {
    mDetailData = null;

    streamControllerBasicInfo.add(null);
    streamControllerCalcInfo.add(null);
    streamControllerInfo.add(null);
    streamControllerSectorInfo.add(null);
    streamControllerDeliTip.add(null);
    streamControllerOperateInfo.add(null);
  }

  void setDetailViewData(String shopCd, String mCode, String ccCode, String apiComCode, String shopStatus, String calcYn, String shopInfoYn, String deliYn,
      String tipYn, String saleYn, String franchiseCd) {
    //print('setDetailViewData -> ${shopCd}');

    mDetailData = null;
    mDetailData = ShopDetailNotifierData();
    mDetailData.selected_shopCode = shopCd;
    mDetailData.selected_mCode = mCode;
    mDetailData.selected_ccCode = ccCode;
    mDetailData.selected_apiComCode = apiComCode;
    mDetailData.selected_shopStatus = shopStatus;
    mDetailData.selected_calcYn = calcYn; //정산정보
    mDetailData.selected_shopInfoYn = shopInfoYn; //매장정보
    mDetailData.selected_deliYn = deliYn; //배송지관리
    mDetailData.selected_tipYn = tipYn; //배달팁정보
    mDetailData.selected_saleYn = saleYn; //운영정보
    //mDetailData.selected_franchiseCd = franchiseCd;   //운영정보

    callStreamBroadcast();
  }

  void callStreamBroadcast() {
    if (_nestedTabController.index == 0) {
      streamControllerBasicInfo.add(mDetailData);

      streamControllerCalcInfo.add(null);
      streamControllerInfo.add(null);
      streamControllerSectorInfo.add(null);
      streamControllerDeliTip.add(null);
      streamControllerOperateInfo.add(null);
    } else if (_nestedTabController.index == 1) {
      streamControllerBasicInfo.add(mDetailData);

      streamControllerCalcInfo.add(null);
      streamControllerInfo.add(null);
      streamControllerSectorInfo.add(null);
      streamControllerDeliTip.add(null);
      streamControllerOperateInfo.add(null);
    } else if (_nestedTabController.index == 2) {
      streamControllerInfo.add(mDetailData);

      streamControllerBasicInfo.add(null);
      streamControllerCalcInfo.add(null);
      streamControllerSectorInfo.add(null);
      streamControllerDeliTip.add(null);
      streamControllerOperateInfo.add(null);
    } else if (_nestedTabController.index == 3) {
      streamControllerSectorInfo.add(mDetailData);

      streamControllerBasicInfo.add(null);
      streamControllerCalcInfo.add(null);
      streamControllerInfo.add(null);
      streamControllerDeliTip.add(null);
      streamControllerOperateInfo.add(null);
    } else if (_nestedTabController.index == 4) {
      streamControllerDeliTip.add(mDetailData);

      streamControllerBasicInfo.add(null);
      streamControllerCalcInfo.add(null);
      streamControllerInfo.add(null);
      streamControllerSectorInfo.add(null);
      streamControllerOperateInfo.add(null);
    } else if (_nestedTabController.index == 5) {
      streamControllerOperateInfo.add(mDetailData);

      streamControllerBasicInfo.add(null);
      streamControllerCalcInfo.add(null);
      streamControllerInfo.add(null);
      streamControllerSectorInfo.add(null);
      streamControllerDeliTip.add(null);
    } else if (_nestedTabController.index == 6) {
      streamControllerOperateInfo.add(mDetailData);

      streamControllerBasicInfo.add(null);
      streamControllerCalcInfo.add(null);
      streamControllerInfo.add(null);
      streamControllerSectorInfo.add(null);
      streamControllerDeliTip.add(null);
    }
  }

  void detailCallback() {
    _query();
  }

  @override
  void initState() {
    super.initState();

    Get.put(AgentController());
    Get.put(ShopController());

    _nestedTabController = new TabController(length: 7, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((c) {
      _reset();
      loadCallCenterListData();
      _query();
    });
  }

  @override
  void dispose() {
    dataList.clear();
    //MCodeListitems.clear();

    _nestedTabController.dispose();
    _scrollController.dispose();

    streamControllerBasicInfo.close();
    streamControllerCalcInfo.close();
    streamControllerInfo.close();
    streamControllerSectorInfo.close();
    streamControllerDeliTip.close();
    streamControllerOperateInfo.close();

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
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
        Row(
          children: [
            Text(
              '총: ${Utils.getCashComma(ShopController.to.totalRowCnt.toString())}건',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ISSearchDropdown(
                  label: '그룹',
                  value: _mCode,
                  width: 200,
                  onChange: (value) {
                    _mCode = value;
                    _currentPage = 1;
                    loadCallCenterListData();
                    _query();
                    //setState(() {});
                  },
                  item: MCodeListitems.map((item) {
                    return new DropdownMenuItem<String>(
                        child: new Text(
                          item['mName'],
                          style: TextStyle(fontSize: 13, color: Colors.black),
                        ),
                        value: item['mCode']);
                  }).toList(),
                ),
                SizedBox(
                  height: 8,
                ),
                ISSearchDropdown(
                  label: '지점',
                  value: _mCode,
                  width: 200,
                  onChange: (value) {
                    _mCode = value;
                    _currentPage = 1;
                    loadCallCenterListData();
                    _query();
                    //setState(() {});
                  },
                  item: MCodeListitems.map((item) {
                    return new DropdownMenuItem<String>(
                        child: new Text(
                          item['mName'],
                          style: TextStyle(fontSize: 13, color: Colors.black),
                        ),
                        value: item['mCode']);
                  }).toList(),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ISSearchDropdown(
                  label: '회원사명',
                  value: _mCode,
                  width: 150,
                  onChange: (value) {
                    _mCode = value;
                    _currentPage = 1;
                  },
                  item: MCodeListitems.map((item) {
                    return new DropdownMenuItem<String>(
                        child: new Text(
                          item['mName'],
                          style: TextStyle(fontSize: 13, color: Colors.black),
                        ),
                        value: item['mCode']);
                  }).toList(),
                ),
                SizedBox(
                  height: 8,
                ),
                ISSearchDropdown(
                  label: '상태',
                  value: _mCode,
                  width: 150,
                  onChange: (value) {
                    _mCode = value;
                    _currentPage = 1;
                  },
                  item: MCodeListitems.map((item) {
                    return new DropdownMenuItem<String>(
                        child: new Text(
                          item['mName'],
                          style: TextStyle(fontSize: 13, color: Colors.black),
                        ),
                        value: item['mCode']);
                  }).toList(),
                ),
              ],
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ISSearchButton(label: '조회', width: 110, iconData: Icons.search, onPressed: () => {_currentPage = 1, _query()}),
                SizedBox(
                  height: 8,
                ),
                widget.shopName == null
                    ? ISSearchButton(enable: AuthUtil.isAuthCreateEnabled('5'), label: '등록', width: 110, iconData: Icons.add, onPressed: () => _registCallCenter())
                    : Container(),
              ],
            ),
          ],
        ),
      ]),
    );

    return Container(
      padding: (widget.shopName == null) ? null : EdgeInsets.only(left: 10, right: 10, bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          form,
          (widget.shopName == null) ? buttonBar : Container(),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: getListMainPanelWidth(),
                height: widget.shopName == null ? (MediaQuery.of(context).size.height - 190) : widget.popHeight - 80,
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
                      panelHeight: widget.shopName == null ? (MediaQuery.of(context).size.height - 255) : widget.popHeight - 120,
                      listWidth: widget.shopName == null ? 910 : widget.popWidth,
                      //showCheckboxColumn: (widget.shopName == null) ? true : false,
                      rows: dataList.map((item) {
                        return DataRow(
                            selected: item.viewSelected ?? false,
                            color: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
                              if (item.viewSelected == true) {
                                return Colors.grey.shade200;
                                //return Theme.of(context).colorScheme.primary.withOpacity(0.38);
                              }

                              return Theme.of(context).colorScheme.primary.withOpacity(0.00);
                            }),
                            onSelectChanged: (bool value) {
                              //_nestedTabController.index = 0;

                              _selectedCcCode = item.ccCode;
                              _selectedViewSeq = item.shopCd;

                              nSelectedShopTitle = '[${item.shopCd}] ${item.shopName}';

                              setDetailViewData(item.shopCd, _mCode, item.ccCode, item.apiComCode, '', item.calcYn, item.shopInfoYn, item.deliYn,
                                  item.tipYn, item.saleYn, item.franchiseCd);

                              dataList.forEach((element) {
                                element.viewSelected = false;
                              });

                              item.viewSelected = true;

                              _scrollController.jumpTo(0.0);

                              setState(() {});
                            },
                            cells: [
                              DataCell(Align(
                                child: SelectableText(item.shopName.toString() == null ? '--' : '[' + item.shopCd.toString() + '] ' + item.shopName.toString(),
                                    showCursor: true),
                                alignment: Alignment.centerLeft,
                              )),
                              DataCell(Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Align(
                                      child: Text(
                                        item.openDate.toString() ?? '--',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      alignment: Alignment.center))),
                              DataCell(Center(
                                  child: item.regNoYn.toString() == 'Y'
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.radio_button_unchecked,
                                            color: Colors.blue,
                                            size: 16,
                                          ),
                                          onPressed: () async {
                                            dataList.clear();

                                            _currentPage = 1;

                                            await ShopController.to
                                                .getData(_mCode, item.regNo, '', '', '', '', '', '', '', '', '', _currentPage.round().toString(),
                                                    _selectedpagerows.toString())
                                                .then((value) {
                                              if (this.mounted) {
                                                if (value == null) {
                                                  ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
                                                } else {
                                                  setState(() {
                                                    dataList.clear();
                                                    _testOrderCnt = 0;

                                                    MCodeListitems = Utils.getMCodeList(); //

                                                    value.forEach((e) {
                                                      ShopAccountModel temp = ShopAccountModel.fromJson(e);
                                                      temp.selected = false;
                                                      dataList.add(temp);
                                                    });

                                                    if (dataList != null && dataList.length > 0) {
                                                      int compareIdx = 0;

                                                      //print('-------------- _selectedViewSeq:${_selectedViewSeq}, compareIdx:${compareIdx}');

                                                      if (_selectedViewSeq != '') {
                                                        compareIdx = dataList.indexWhere((item) => item.shopCd == _selectedViewSeq);

                                                        if (compareIdx == -1) {
                                                          compareIdx = 0;
                                                          _selectedViewSeq = '';
                                                        }

                                                        nSelectedShopTitle = '[${dataList[compareIdx].shopCd}] ${dataList[compareIdx].shopName}';

                                                        dataList[compareIdx].viewSelected = true;
                                                        setDetailViewData(
                                                            dataList[compareIdx].shopCd,
                                                            _mCode,
                                                            dataList[compareIdx].ccCode,
                                                            dataList[compareIdx].apiComCode,
                                                           '',
                                                            dataList[compareIdx].calcYn,
                                                            dataList[compareIdx].shopInfoYn,
                                                            dataList[compareIdx].deliYn,
                                                            dataList[compareIdx].tipYn,
                                                            dataList[compareIdx].saleYn,
                                                            dataList[compareIdx].franchiseCd);
                                                      }
                                                    } else {
                                                      nSelectedShopTitle = '';

                                                      setDetailViewNullData();
                                                    }

                                                    _totalRowCnt = ShopController.to.totalRowCnt;
                                                    _totalPages = (_totalRowCnt / _selectedpagerows).ceil();

                                                    _scrollController.jumpTo(0.0);
                                                  });
                                                }
                                              }
                                            });
                                          },
                                        )
                                      : IconButton(
                                          icon: Icon(Icons.clear, color: Colors.grey.shade400, size: 16),
                                        ))),
                              DataCell(Center(
                                  child: item.appOrderYn.toString() == 'Y'
                                      ? Icon(Icons.radio_button_unchecked, color: Colors.blue, size: 16)
                                      : Icon(Icons.clear, color: Colors.grey.shade400, size: 16))),
                              DataCell(Center(
                                  child: item.useGbn.toString() == 'Y'
                                      ? Icon(Icons.radio_button_unchecked, color: Colors.blue, size: 16)
                                      : Icon(Icons.clear, color: Colors.grey.shade400, size: 16))),
                              DataCell(Center(
                                  child: item.absentYn.toString() == 'N'
                                      ? Icon(Icons.radio_button_unchecked, color: Colors.blue, size: 16)
                                      : Icon(Icons.clear, color: Colors.grey.shade400, size: 16))),
                              DataCell(
                                Center(
                                    child: InkWell(
                                  child: Icon(Icons.restaurant_menu, size: 20, color: item.menuYn == 'N' ? Colors.blue : Colors.grey.shade400),
                                  onTap: () {
                                    if (AuthUtil.isAuthReadEnabled('109') == false) {
                                      ISAlert(context, '조회 권한이 없습니다. \n\n관리자에게 문의 바랍니다');
                                      return;
                                    }

                                    _editMenuGroup(ccCode: item.ccCode, shopCode: item.shopCd, menuComplete: item.menuComplete);
                                  },
                                )),
                              ),
                              DataCell(
                                Center(
                                    child: item.menuComplete.toString() == 'Y'
                                        ? Icon(Icons.radio_button_unchecked, color: Colors.blue, size: 16)
                                        : Icon(Icons.clear, color: Colors.grey.shade400, size: 16)),
                              ),
                            ]);
                      }).toList(),
                      columns: <DataColumn>[
                        if (widget.shopName == null)
                          DataColumn(
                            label: Expanded(child: Text('번호', textAlign: TextAlign.center)),
                          ),
                        DataColumn(
                          label: Expanded(child: SelectableText('지점(콜센터)명', textAlign: TextAlign.center)),
                        ),
                        DataColumn(
                          label: Expanded(child: Text('지점구분', textAlign: TextAlign.center)),
                        ),
                        DataColumn(
                          label: Expanded(child: Text('운영여부', textAlign: TextAlign.center)),
                        ),
                        DataColumn(
                          label: Expanded(child: Text('전화번호', textAlign: TextAlign.center)),
                        ),
                        DataColumn(
                          label: Expanded(child: Text('주소', textAlign: TextAlign.center)),
                        ),
                        DataColumn(
                          label: Expanded(child: Text('보유적립금', textAlign: TextAlign.center)),
                        ),
                        DataColumn(
                            label: Expanded(
                                child: Text(
                          '등록일',
                          textAlign: TextAlign.center
                        ))),
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

  Widget getDetailData() {
    return Container(
      width: 700,
      height: (widget.shopName == null) ? (MediaQuery.of(context).size.height - 190) : widget.popHeight - 80,
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black26, offset: Offset(2.0, 2.0), blurRadius: 4.0),
        ],
      ),
      child: Container(
        //color: Colors.yellow,
        //padding: EdgeInsets.only(left: 50, right: 50, bottom: 20, top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (widget.shopName == null)
                ? Container(
                    child: Text(
                    nSelectedShopTitle,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ))
                : Container(),
            TabBar(
              controller: _nestedTabController,
              indicator:
                  UnderlineTabIndicator(borderSide: BorderSide(width: 4, color: Color(0xFF646464)), insets: EdgeInsets.only(left: 0, right: 8, bottom: 4)),
              isScrollable: true,
              labelPadding: EdgeInsets.only(left: 0, right: 0),
              // indicatorColor: Colors.blue,
              labelColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.label,
              // unselectedLabelColor: Colors.black54,
              //isScrollable: true,
              // indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Tab(text: '   기본정보   '),
                ),
                Padding(padding: const EdgeInsets.only(right: 8), child: Tab(text: '     약관/정책')),
                Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Row(
                      children: [
                        Tab(text: '     적립금'),
                        (mDetailData == null || mDetailData.selected_calcYn == 'N') ? Text('     ') : Icon(Icons.priority_high, size: 16, color: Colors.blue)
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Row(
                      children: [
                        Tab(text: '     마일리지'),
                        (mDetailData == null || mDetailData.selected_shopInfoYn == 'N')
                            ? Text('     ')
                            : Icon(Icons.priority_high, size: 16, color: Colors.blue)
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Row(
                      children: [
                        Tab(text: '     배너')
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Row(
                      children: [
                        Tab(text: '     지역맞춤지명'),
                        (mDetailData == null || mDetailData.selected_tipYn == 'N') ? Text('     ') : Icon(Icons.priority_high, size: 16, color: Colors.blue)
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Row(
                      children: [
                        Tab(text: '     변경 이력')
                      ],
                    )),
              ],
              onTap: (index) {
                // if (_selectedViewSeq == '') {
                //   _nestedTabController.index = 0;
                //   return;
                // }

                callStreamBroadcast();
              },
            ),
            Container(
              width: double.infinity,
              height: (widget.shopName == null) ? (MediaQuery.of(context).size.height - 271) : widget.popHeight - 156,
              child: TabBarView(physics: NeverScrollableScrollPhysics(), controller: _nestedTabController, children: <Widget>[
                AuthUtil.isAuthReadEnabled('95') == true
                    ? TaxiCallCenterBasicInfo(
                        stream: streamControllerBasicInfo.stream,
                        callback: detailCallback,
                        selectBox_operator: selectBox_operatorBasicInfo,
                        selectBox_salesman: selectBox_salesmanBasicInfo,
                        selectBox_ccCode: selectBox_ccCodeBasicInfo,
                        selectBox_brandType: selectBox_brandTypeBasicInfo,
                        height: widget.shopName == null ? (MediaQuery.of(context).size.height - 321) : widget.popHeight - 206)
                    : Container(
                        child: Text('조회 권한이 없습니다.', style: TextStyle(color: Colors.black45)),
                        alignment: Alignment.center,
                      ),
                AuthUtil.isAuthReadEnabled('95') == true
                    ? TaxiCallCenterTermsInfo(
                        stream: streamControllerTermsInfo.stream,
                        callback: detailCallback,
                        selectBox_ccCode: selectBox_ccCodeBasicInfo,
                        height: widget.shopName == null ? (MediaQuery.of(context).size.height - 321) : widget.popHeight - 206)
                    : Container(
                        child: Text('조회 권한이 없습니다.', style: TextStyle(color: Colors.black45)),
                        alignment: Alignment.center,
                      ),
                Container(
                  child: Text('보류', style: TextStyle(color: Colors.black45)),
                  alignment: Alignment.center,
                ),
                Container(
                  child: Text('보류', style: TextStyle(color: Colors.black45)),
                  alignment: Alignment.center,
                ),
                AuthUtil.isAuthReadEnabled('98') == true
                    ? TaxiCallCenterBannerInfo(
                        callback: detailCallback,
                        stream: streamControllerSectorInfo.stream,
                        height: widget.shopName == null ? (MediaQuery.of(context).size.height - 321) : widget.popHeight - 206)
                    : Container(
                        child: Text('조회 권한이 없습니다.', style: TextStyle(color: Colors.black45)),
                        alignment: Alignment.center,
                      ),
                Container(
                  child: Text('보류', style: TextStyle(color: Colors.black45)),
                  alignment: Alignment.center,
                ),
                AuthUtil.isAuthReadEnabled('100') == true
                    ? TaxiCallCenterHistoryInfo(
                        stream: streamControllerOperateInfo.stream,
                        callback: detailCallback,
                        height: widget.shopName == null ? (MediaQuery.of(context).size.height - 321) : widget.popHeight - 206)
                    : Container(
                        child: Text('조회 권한이 없습니다.', style: TextStyle(color: Colors.black45)),
                        alignment: Alignment.center,
                      ),
              ]),
            ),
          ],
        ),
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
                      //Text('조회 데이터 : ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),),
                      //Text(UserController.to.totalRowCnt.toString() + ' / ' + UserController.to.total_count.toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                      //SizedBox(width: 20,),
                      Text(
                        '페이지당 행 수',
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

  Future<void> _launchInBrowser(String shopCode) async {
    //ucode, name
    String uCode = GetStorage().read('logininfo')['uCode'];
    String uID = GetStorage().read('logininfo')['id'];
    String uName = GetStorage().read('logininfo')['name'];

    String url = ServerInfo.OWNERSITE_URL + '/$shopCode/$uCode/$uID/Store';

    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false, //true로 설정시, iO 인앱 브라우저를 통해픈
        forceWebView: false, //true로 설정시, Android 인앱 브라우저를 통해 오픈
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Web Request Fail $url';
    }
  }

  String _getStatus(String value) {
    String retValue = '--';

    if (value.toString().compareTo('0') == 0)
      retValue = '대기';
    else if (value.toString().compareTo('1') == 0)
      retValue = '요청';
    else if (value.toString().compareTo('2') == 0)
      retValue = '배정';
    else if (value.toString().compareTo('3') == 0)
      retValue = '완료';
    else if (value.toString().compareTo('4') == 0) retValue = '승인';

    return retValue;
  }

  double getListMainPanelWidth() {
    double nWidth = MediaQuery.of(context).size.width - 1000;
    if (widget.shopName == null) {
      if (Responsive.isTablet(context) == true)
        nWidth = nWidth + sidebarWidth;
      else if (Responsive.isMobile(context) == true) nWidth = MediaQuery.of(context).size.width;
    } else {
      nWidth = widget.popWidth - 530;
    }

    return nWidth;
  }

  void SaveExcelExport() async {
    String ucode = GetStorage().read('logininfo')['uCode'];

    await http.get(ServerInfo.REST_URL_EXCELEXPORT + '/?mcode=$_mCode&ucode=$ucode').then((http.Response response) {
      var bytes = response.bodyBytes;

      DateTime now = DateTime.now();
      DateTime date = DateTime(now.year, now.month, now.day);

      AnchorElement(href: 'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
        ..setAttribute('download', '가맹점리스트[' + getMcodeName(_mCode) + ']_' + formatDate(date, [yy, mm, dd]) + '.xlsx')
        ..click();
    }).then((value) => excelEnable = true);

    setState(() {});
  }

  String getMcodeName(String mCode) {
    String temp = '';
    for (final element in MCodeListitems) {
      if (element['mCode'] == mCode) {
        temp = element['mName'];
        break;
      }
    }
    return temp;
  }
}
