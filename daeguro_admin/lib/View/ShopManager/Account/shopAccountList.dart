import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/Model/ceoSiteModel.dart';
import 'package:daeguro_admin_app/Model/shopAccountModel.dart';
import 'package:daeguro_admin_app/Provider/RestApiProvider.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccountMoveReview.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopDetailNotifierData.dart';
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

class ShopAccountList extends StatefulWidget {
  final String shopName;
  final double popWidth;
  final double popHeight;

  const ShopAccountList({key, this.shopName, this.popWidth, this.popHeight}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShopAccountListState();
  }
}

class ShopAccountListState extends State<ShopAccountList> with SingleTickerProviderStateMixin {
  get secureStorage => null;

  // 암호화
  String encrypterPayload(String payload) {
    var _key = 'jKi1E8Y1VDGMvezfLgIOuA4mnRA4FQCoxC71FSn5pPk='.toString().substring(0, 32);
    //var _key = CryptoPack.sha256.convert(ConvertPack.utf8.encode('jKi1E8Y1VDGMvezfLgIOuA4mnRA4FQCoxC71FSn5pPk=')).toString().substring(0, 32);

    String firstBase64Encoding = base64.encode(utf8.encode(payload));

    final key = EncryptPack.Key.fromUtf8(_key);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(EncryptPack.AES(key, mode: EncryptPack.AESMode.cbc));

    final encrypted = encrypter.encrypt(payload, iv: iv);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);

    print('payload -> ' + payload);
    print('encode payload -> ' + firstBase64Encoding);
    print('key -> ' + key.base64);
    print('iv -> ' + iv.base64);
    print('encrypte(base64) -> ' + encrypted.base64 );
    print('encrypte(base16) -> ' + encrypted.base16 );
    print('decrypted -> '+ decrypted );
  }

  // 복호화
  String extractPayload(String payload) {
    String strPwd = 'SuperSecretKey';
    String strIv = 'SuperSecretBLOCK';

    print('11111');

    var iv = CryptoPack.sha256.convert(ConvertPack.utf8.encode(strIv)).toString().substring(0, 16); // Consider the first 16 bytes of all 64 bytes
    var key = CryptoPack.sha256.convert(ConvertPack.utf8.encode(strPwd)).toString().substring(0, 32); // Consider the first 32 bytes of all 64 bytes

    print('2222');
    EncryptPack.IV ivObj = EncryptPack.IV.fromUtf8(iv);
    EncryptPack.Key keyObj = EncryptPack.Key.fromUtf8(key);
    final encrypter = EncryptPack.Encrypter(EncryptPack.AES(keyObj, mode: EncryptPack.AESMode.cbc)); // Apply CBC mode
    String firstBase64Decoding = new String.fromCharCodes(ConvertPack.base64.decode(payload)); // First Base64 decoding
    final decrypted = encrypter.decrypt(EncryptPack.Encrypted.fromBase64(firstBase64Decoding), iv: ivObj); // Second Base64 decoding (during decryption)
    return decrypted;
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool excelEnable = true;

  TabController _nestedTabController;
  //int current_tabIdx = 0;

  StreamController<ShopDetailNotifierData> streamControllerBasicInfo = StreamController<ShopDetailNotifierData>();
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
    DropdownMenuItem(value: '0', child: Text('대기'),),
    DropdownMenuItem(value: '1', child: Text('요청'),),
    DropdownMenuItem(value: '2', child: Text('배정'),),
    DropdownMenuItem(value: '3', child: Text('완료'),),
    DropdownMenuItem(value: '4', child: Text('승인'),),
    DropdownMenuItem(value: '',  child: Text('--'),),
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

    _searchItems.status = ' ';
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

  _newShop() {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: ShopNew(),
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

  loadBaseData() async {
    selectBox_operator.clear();
    selectBox_operatorBasicInfo.clear();
    selectBox_ccCodeBasicInfo.clear();
    selectBox_brandTypeBasicInfo.clear();
    selectBox_reserve_itemCd.clear();
    selectBox_reserve_subitemCd.clear();

    await ShopController.to.getReserItems('0001').then((value) {
      if (value == null) {
        ISAlert(context, '업소 조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        selectBox_reserve_itemCd.add(new SelectOptionVO(value: '', label: '--', label2: ''));

        value.forEach((element) {
          //ReserItemModel tempData = ReserItemModel.fromJson(element);

          selectBox_reserve_itemCd.add(new SelectOptionVO(value: element['code'], label: '[' + element['code'] + '] ' + element['nameMain'], label2: element['nameMain']));
        });
      }
    });

    await ShopController.to.getReserItems('0003').then((value) {
      if (value == null) {
        ISAlert(context, '테마 카테고리 조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        selectBox_reserve_subitemCd.add(new SelectOptionVO(value: '', label: '--', label2: ''));

        value.forEach((element) {
          //ReserItemModel tempData = ReserItemModel.fromJson(element);

          selectBox_reserve_subitemCd.add(new SelectOptionVO(value: element['code'], label: '[' + element['code'] + '] ' + element['nameMain'], label2: element['nameMain']));
        });
      }
    });


    await UserController.to.getUserCodeNameSaleseman('2', '5').then((value) {
      if (value == null) {
        ISAlert(context, '영업자정보 정상조회 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else{
        // 영업사원 바인딩
        selectBox_salesmanBasicInfo.add(new SelectOptionVO(value: '', label: '--', label2: ''));

        // 영업사원 바인딩
        value.forEach((element) {
          UserCodeName tempData = UserCodeName.fromJson(element);

          selectBox_salesmanBasicInfo.add(new SelectOptionVO(value: tempData.code, label: '[' + tempData.code + '] ' + tempData.name, label2: tempData.name));
        });
      }
    });

    await UserController.to.getUserCodeNameOperator('2', '6').then((value) {
      if (value == null) {
        ISAlert(context, '사용자ID 또는 비밀번호를 확인하십시오.');
      }
      else {
        selectBox_operator.add(new SelectOptionVO(value: ' ', label: '전체', label2: '',));

        selectBox_operatorBasicInfo.add(new SelectOptionVO(value: '', label: '--', label2: ''));

        // 오퍼레이터 바인딩
        value.forEach((element) {
          UserCodeName tempData = UserCodeName.fromJson(element);

          selectBox_operator.add(new SelectOptionVO(value: tempData.code, label: '[' + tempData.code + '] ' + tempData.name, label2: tempData.name,));
          selectBox_operatorBasicInfo.add(new SelectOptionVO(value: tempData.code, label: '[' + tempData.code + '] ' + tempData.name, label2: tempData.name));
        });

        //setState(() {});
      }
    });

    await ShopController.to.getFranchiseListData().then((value) {
      if (value == null) {
        ISAlert(context, '프랜차이즈 정보가 정상조회 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else{
        selectBox_brandTypeBasicInfo.add(new SelectOptionVO(value: '', label: '사용안함'));

        value.forEach((element) {
          selectBox_brandTypeBasicInfo.add(new SelectOptionVO(value: element['CODE'], label: element['CODE_NM']));
        });

        //setState(() {        });
      }
    });
  }

  loadCallCenterListData() async {
    selectBox_ccCodeBasicInfo.clear();

    await AgentController.to.getDataCCenterItems(_mCode).then((value) {
      if(value == null){
        ISAlert(context, '콜센터정보를 가져오지 못했습니다. \n\n관리자에게 문의 바랍니다');
      }
      else{
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

    MCodeListitems = Utils.getMCodeList();//AgentController.to.qDataMCodeItems;

    await ShopController.to.getData(_mCode, _searchItems.code, _operator_code, _searchItems.status, _searchItems.reg_no_yn, _searchItems.use_yn, _searchItems.app_order_yn, _searchItems.memo_yn, _searchItems.img_yn, _searchItems.reserve_yn, _searchItems.startdate, _currentPage.round().toString(), _selectedpagerows.toString()).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else{
        value.forEach((e) {
          ShopAccountModel temp = ShopAccountModel.fromJson(e);
          temp.selected = false;
          dataList.add(temp);
        });

        if (dataList != null && dataList.length > 0){
          int compareIdx = 0;

          //print('-------------- _selectedViewSeq:${_selectedViewSeq}, compareIdx:${compareIdx}');

          if (_selectedViewSeq != ''){
            compareIdx = dataList.indexWhere((item) => item.shopCd == _selectedViewSeq);

            if (compareIdx == -1) {
              compareIdx = 0;
              _selectedViewSeq = '';
            }

            nSelectedShopTitle = '[${dataList[compareIdx].shopCd}] ${dataList[compareIdx].shopName}';

            dataList[compareIdx].viewSelected = true;
            setDetailViewData(dataList[compareIdx].shopCd, _mCode, dataList[compareIdx].ccCode, dataList[compareIdx].apiComCode, dataList[compareIdx].imageStatus,
                dataList[compareIdx].calcYn, dataList[compareIdx].shopInfoYn, dataList[compareIdx].deliYn, dataList[compareIdx].tipYn, dataList[compareIdx].saleYn, dataList[compareIdx].franchiseCd);

          }
        }
        else{
          nSelectedShopTitle = '';

          setDetailViewNullData();
        }

        _totalRowCnt = ShopController.to.totalRowCnt;
        _totalPages = (_totalRowCnt / _selectedpagerows).ceil();
      }
    });

    _scrollController.jumpTo(0.0);

    //if (this.mounted) {
      setState(() {
      });
    //}

    await ISProgressDialog(context).dismiss();
  }

  void setDetailViewNullData(){
    mDetailData = null;

    streamControllerBasicInfo.add(null);
    streamControllerCalcInfo.add(null);
    streamControllerInfo.add(null);
    streamControllerSectorInfo.add(null);
    streamControllerDeliTip.add(null);
    streamControllerOperateInfo.add(null);
  }

  void setDetailViewData(String shopCd, String mCode, String ccCode, String apiComCode, String imageStatus, String calcYn, String shopInfoYn, String deliYn, String tipYn, String saleYn, String franchiseCd){
    //print('setDetailViewData -> ${shopCd}');

    mDetailData = null;
    mDetailData = ShopDetailNotifierData();
    mDetailData.selected_shopCode = shopCd;
    mDetailData.selected_mCode = mCode;
    mDetailData.selected_ccCode = ccCode;
    mDetailData.selected_apiComCode = apiComCode;
    mDetailData.selected_imageStatus = imageStatus;
    mDetailData.selected_calcYn  = calcYn;            //정산정보
    mDetailData.selected_shopInfoYn = shopInfoYn;     //매장정보
    mDetailData.selected_deliYn = deliYn;             //배송지관리
    mDetailData.selected_tipYn = tipYn;               //배달팁정보
    mDetailData.selected_saleYn = saleYn;             //운영정보
    //mDetailData.selected_franchiseCd = franchiseCd;   //운영정보

    callStreamBroadcast();
  }

  void callStreamBroadcast(){
    if (_nestedTabController.index == 0)  {
      streamControllerBasicInfo.add(mDetailData);

      streamControllerCalcInfo.add(null);
      streamControllerInfo.add(null);
      streamControllerSectorInfo.add(null);
      streamControllerDeliTip.add(null);
      streamControllerOperateInfo.add(null);
    }
    else if (_nestedTabController.index == 1)  {
      streamControllerCalcInfo.add(mDetailData);

      streamControllerBasicInfo.add(null);
      streamControllerInfo.add(null);
      streamControllerSectorInfo.add(null);
      streamControllerDeliTip.add(null);
      streamControllerOperateInfo.add(null);
    }
    else if (_nestedTabController.index == 2)   {
      streamControllerInfo.add(mDetailData);

      streamControllerBasicInfo.add(null);
      streamControllerCalcInfo.add(null);
      streamControllerSectorInfo.add(null);
      streamControllerDeliTip.add(null);
      streamControllerOperateInfo.add(null);
    }
    else if (_nestedTabController.index == 3)   {
      streamControllerSectorInfo.add(mDetailData);

      streamControllerBasicInfo.add(null);
      streamControllerCalcInfo.add(null);
      streamControllerInfo.add(null);
      streamControllerDeliTip.add(null);
      streamControllerOperateInfo.add(null);
    }
    else if (_nestedTabController.index == 4)   {
      streamControllerDeliTip.add(mDetailData);

      streamControllerBasicInfo.add(null);
      streamControllerCalcInfo.add(null);
      streamControllerInfo.add(null);
      streamControllerSectorInfo.add(null);
      streamControllerOperateInfo.add(null);
    }
    else if (_nestedTabController.index == 5)    {
      streamControllerOperateInfo.add(mDetailData);

      streamControllerBasicInfo.add(null);
      streamControllerCalcInfo.add(null);
      streamControllerInfo.add(null);
      streamControllerSectorInfo.add(null);
      streamControllerDeliTip.add(null);
    }
  }

  void detailCallback(){
    _query();
  }


  @override
  void initState() {
    super.initState();

    Get.put(AgentController());
    Get.put(ShopController());

    _nestedTabController = new TabController(length: 6, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((c) {
      _reset();
      loadCallCenterListData();
      loadBaseData();
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

    // if (dataList != null)      dataList.clear();
    //
    // if (_ceoSiteModel != null)    _ceoSiteModel.clear();
    //
    // if (MCodeListitems != null)    MCodeListitems.clear();
    //
    // if (selectBox_operator != null)             selectBox_operator.clear();
    // if (selectBox_operatorBasicInfo != null)    selectBox_operatorBasicInfo.clear();
    // if (selectBox_salesmanBasicInfo != null)    selectBox_salesmanBasicInfo.clear();
    // if (selectBox_ccCodeBasicInfo != null)        selectBox_ccCodeBasicInfo.clear();
    // if (selectBox_brandTypeBasicInfo != null)    selectBox_brandTypeBasicInfo.clear();
    // if (selectBox_reserve_itemCd != null)       selectBox_reserve_itemCd.clear();
    // if (selectBox_reserve_subitemCd != null)    selectBox_reserve_subitemCd.clear();
    // if (selectBox_imageStatus != null)          selectBox_imageStatus.clear();

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
                Text('총: ${Utils.getCashComma(ShopController.to.totalRowCnt.toString())}건', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
               Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ISSearchDropdown(
                      label: '예약 사용 여부',
                      width: 100,
                      value: _searchItems.reserve_yn,
                      onChange: (value) {
                        _searchItems.reserve_yn = value;
                        _currentPage = 1;
                        _query();
                      },
                      item: [
                        DropdownMenuItem(value: ' ', child: Text('전체'), ),
                        DropdownMenuItem(value: 'Y', child: Text('사용'),),
                        DropdownMenuItem(value: 'N', child: Text('미사용'),),
                      ].cast<DropdownMenuItem<String>>(),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ISSearchDropdown(
                      label: '회원사명',
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
                            child: new Text(item['mName'], style: TextStyle(fontSize: 13, color: Colors.black),),
                            value: item['mCode']);
                      }).toList(),
                    ),
                    SizedBox(height: 8,),
                    ISSearchDropdown(
                      label: '오퍼레이터',
                      value: _operator_code,
                      width: 200,
                      item: selectBox_operator.map((item) {
                        return new DropdownMenuItem<String>(
                            child: new Text(item.label, style: TextStyle(fontSize: 13, color: Colors.black),),
                            value: item.value);
                      }).toList(),
                      onChange: (v) {
                        selectBox_operator.forEach((element) {
                          if (v == element.value) {
                            _operator_code = element.value;
                          }
                        });

                        _currentPage = 1;
                        _query();
                      },
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ISSearchDropdown(
                      label: '상태',
                      width: 120,
                      value: _searchItems.status,
                      onChange: (value) {
                        _searchItems.status = value;
                        _currentPage = 1;
                        _query();
                      },
                      item: [
                        DropdownMenuItem(value: ' ', child: Text('전체'),),
                        DropdownMenuItem(value: '0', child: Text('대기'),),
                        DropdownMenuItem(value: '1', child: Text('요청'),),
                        DropdownMenuItem(value: '2', child: Text('배정'),),
                        DropdownMenuItem(value: '3', child: Text('완료'),),
                        DropdownMenuItem(value: '4', child: Text('승인'),),
                      ].cast<DropdownMenuItem<String>>(),
                    ),
                    SizedBox(height: 8,),
                    Row(
                      children: [
                        ISSearchSelectDate(
                          context,
                          //padding: 0,
                          label: '등록일',
                          width: 120,
                          value: _searchItems.startdate.toString(),
                          onTap: () async {
                            DateTime valueDt = DateTime.now();

                            final DateTime picked = await showDatePicker(
                              context: context,
                              initialDate: valueDt,
                              firstDate: DateTime(1900, 1),
                              lastDate: DateTime(2031, 12),
                            );

                            if (picked != null) {
                              _searchItems.startdate = formatDate(picked, [yyyy, '-', mm, '-', dd]);
                              _chkDate = true;
                              _currentPage = 1;
                              _query();
                            }
                          },
                        ),
                        Container(
                          //margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          //color: Colors.yellow,
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: <Widget>[

                              Container(
                                child: Visibility(
                                  visible: _chkDate == true ? true : false,
                                  child: IconButton(
                                    padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10.0, ),
                                    alignment: Alignment.bottomCenter,
                                    splashRadius: 15,
                                    icon: Icon(Icons.close),
                                    color: Colors.black54,
                                    iconSize: 16,
                                    onPressed: () {
                                      _searchItems.startdate = '';
                                      _chkDate = false;
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          ISSearchDropdown(
                            label: '사용 여부',
                            width: 100,
                            value: _searchItems.use_yn,
                            onChange: (value) {
                              _searchItems.use_yn = value;
                              _currentPage = 1;
                              _query();
                            },
                            item: [
                              DropdownMenuItem(value: ' ', child: Text('전체'),),
                              DropdownMenuItem(value: 'Y', child: Text('사용'),),
                              DropdownMenuItem(value: 'N', child: Text('미사용'),),
                            ].cast<DropdownMenuItem<String>>(),
                          ),
                          ISSearchDropdown(
                            label: '메모 사용 여부',
                            width: 100,
                            value: _searchItems.memo_yn,
                            onChange: (value) {
                              _searchItems.memo_yn = value;
                              _currentPage = 1;
                              _query();
                            },
                            item: [
                              DropdownMenuItem(value: ' ', child: Text('전체'), ),
                              DropdownMenuItem(value: 'Y', child: Text('사용'),),
                              DropdownMenuItem(value: 'N', child: Text('미사용'),),
                            ].cast<DropdownMenuItem<String>>(),
                          ),
                          ISSearchDropdown(
                            label: '앱승인',
                            width: 100,
                            value: _searchItems.app_order_yn,
                            onChange: (value) {
                              _searchItems.app_order_yn = value;
                              _currentPage = 1;
                              _query();
                            },
                            item: [
                              DropdownMenuItem(value: ' ', child: Text('전체'), ),
                              DropdownMenuItem(value: 'Y', child: Text('승인'),),
                              DropdownMenuItem(value: 'N', child: Text('미승인'),),
                            ].cast<DropdownMenuItem<String>>(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8,),
                    ISSearchInput(
                      label: '영업, 오퍼, 가맹점명, 대표자명, 사업자번호',
                      width: 308,
                      value: _searchItems.code,
                      onChange: (v) {
                        _searchItems.code = v;
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
                  //crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 8),
                      child: ISSearchDropdown(
                        label: '사업자 번호 중복',
                        width: 110,
                        padding: EdgeInsets.all(0),
                        value: _searchItems.reg_no_yn,
                        onChange: (value) {
                          _searchItems.reg_no_yn = value;
                          _currentPage = 1;
                          _query();
                        },
                        item: [
                          DropdownMenuItem(value: ' ', child: Text('전체'),),
                          DropdownMenuItem(value: 'Y', child: Text('중복'),),
                          DropdownMenuItem(value: 'N', child: Text('미중복'),),
                        ].cast<DropdownMenuItem<String>>(),
                      ),
                    ),
                    SizedBox(height: 8,),
                    ISSearchButton(
                        label: '조회',
                        width: 110,
                        iconData: Icons.search,
                        onPressed: () => {
                          _currentPage = 1, _query()
                        }
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 8),
                      child: ISSearchDropdown(
                        label: '대표 이미지 등록 여부',
                        width: 110,
                        padding: EdgeInsets.all(0),
                        value: _searchItems.img_yn,
                        onChange: (value) {
                          _searchItems.img_yn = value;
                          _currentPage = 1;
                          _query();
                        },
                        item: [
                          DropdownMenuItem(value: ' ', child: Text('전체'), ),
                          DropdownMenuItem(value: 'Y', child: Text('등록'),),
                          DropdownMenuItem(value: 'N', child: Text('미등록'),
                          ),
                        ].cast<DropdownMenuItem<String>>(),
                      ),
                    ),
                    SizedBox(height: 8,),
                    widget.shopName == null
                        ? ISSearchButton(
                              enable: AuthUtil.isAuthCreateEnabled('5'),
                              label: '등록', width: 110, iconData: Icons.add, onPressed: () => _newShop()
                          )
                        : Container(),
                  ],
                ),
              ],
            ),
          ]
      ),
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
                height: widget.shopName == null ? (MediaQuery.of(context).size.height-190) : widget.popHeight-80,
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
                      panelHeight: widget.shopName == null ? (MediaQuery.of(context).size.height-255) : widget.popHeight-120,
                      listWidth: widget.shopName == null ? 1140 : widget.popWidth,
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
                            onSelectChanged: (bool value){
                              //_nestedTabController.index = 0;

                              _selectedCcCode = item.ccCode;
                              _selectedViewSeq = item.shopCd;

                              nSelectedShopTitle = '[${item.shopCd}] ${item.shopName}';

                              setDetailViewData(item.shopCd, _mCode, item.ccCode, item.apiComCode, item.imageStatus, item.calcYn, item.shopInfoYn, item.deliYn, item.tipYn, item.saleYn, item.franchiseCd);

                              dataList.forEach((element) {
                                element.viewSelected = false;
                              });

                              item.viewSelected = true;

                              _scrollController.jumpTo(0.0);

                              setState(() {
                              });
                            },
                            cells: [
                              if (widget.shopName == null)
                                DataCell(Center(
                                      child: Checkbox(
                                          value: item.selected,//this.checkAll,
                                          onChanged: (value) {
                                            if (widget.shopName != null)
                                              return;

                                            if (value == true) {
                                              _testOrderCnt++;
                                            } else {
                                              _testOrderCnt--;

                                              isCheckAll = false;
                                            }

                                            item.selected == false ? item.selected = true : item.selected = false;

                                            setState(() {});
                                          }
                                      ),
                                    )
                                ),
                              DataCell(Center(
                                  child: InkWell(
                                    child: SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: item.shopImageYn == 'Y'
                                            ? Image.network(
                                          ServerInfo.REST_IMG_BASEURL + '/images/' + item.ccCode + '/' + item.shopCd + '/shop.jpg?tm=${Utils.getTimeStamp()}',
                                          //ServerInfo.REST_IMG_BASEURL + '/api/Image/thumb?div=P&cccode=' + item.ccCode +'&shop_cd=' + item.shopCd+ '&file_name=shop.jpg',
                                          gaplessPlayback: true,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Image.asset('assets/empty_menu.png');
                                          },
                                        )
                                            : Image.asset('assets/empty_menu.png')),
                                  ))),
                              DataCell(Align(child: SelectableText(item.shopName.toString() == null ? '--' : '[' + item.shopCd.toString() + '] ' + item.shopName.toString(), showCursor: true), alignment: Alignment.centerLeft,)),
                              DataCell(Container(padding: EdgeInsets.symmetric(horizontal: 10), child: Align(child: Text(item.openDate.toString() ?? '--', style: TextStyle(color: Colors.black),), alignment: Alignment.center))),
                              DataCell(Center(child: item.regNoYn.toString() == 'Y'
                                      ? IconButton(icon: Icon(Icons.radio_button_unchecked, color: Colors.blue, size: 16,),
                                    onPressed: () async {
                                      dataList.clear();

                                      _currentPage = 1;

                                            await ShopController.to.getData(_mCode, item.regNo, '', '', '', '', '', '', '', '', '', _currentPage.round().toString(), _selectedpagerows.toString()).then((value) {
                                        if (this.mounted) {
                                          if (value == null) {
                                            ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
                                          }
                                          else{
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
                                                      dataList[compareIdx].imageStatus,
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
                                  ) : IconButton(icon: Icon(Icons.clear, color: Colors.grey.shade400, size: 16),)
                              )
                              ),

                              DataCell(Center(child: item.appOrderYn.toString() == 'Y' ? Icon(Icons.radio_button_unchecked, color: Colors.blue, size: 16) : Icon(Icons.clear, color: Colors.grey.shade400, size: 16))),
                              DataCell(Center(child: item.useGbn.toString() == 'Y' ? Icon(Icons.radio_button_unchecked, color: Colors.blue, size: 16) : Icon(Icons.clear, color: Colors.grey.shade400, size: 16))),
                              // DataCell(Center(child: item.memo.toString() == '' ? IconButton(icon: Icon(Icons.clear, color: Colors.grey.shade400, size: 16))
                              //     : Tooltip(child: IconButton(icon: Icon(Icons.radio_button_unchecked, color: Colors.blue, size: 16),),
                              //   message: item.memo,
                              //   textStyle: TextStyle(fontSize: 12, color: Colors.white),
                              //   padding: EdgeInsets.all(5),
                              // )
                              // )),
                              DataCell(Center(child: item.absentYn.toString() == 'N' ? Icon(Icons.radio_button_unchecked, color: Colors.blue, size: 16) : Icon(Icons.clear, color: Colors.grey.shade400, size: 16))),
                              DataCell(Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Center(child: item.isPosInstalled.toString() == 'Y' ? Icon(Icons.radio_button_unchecked, color: Colors.blue, size: 16) : Icon(Icons.clear, color: Colors.grey.shade400, size: 16)),
                                  Text('/', style: TextStyle(color: Colors.grey.shade400),),
                                  Center(child: item.isPosLogined.toString() == 'Y' ? Center( child: item.loginTime.toString() == ''
                                      ? Icon(Icons.radio_button_unchecked, color: Colors.blue, size: 16)
                                      : Tooltip(child: Icon(Icons.radio_button_unchecked, color: Colors.blue, size: 16),
                                    message: item.loginTime,
                                    textStyle: TextStyle(fontSize: 12, color: Colors.white),
                                    padding: EdgeInsets.all(5),
                                  ))
                                      : Icon(Icons.clear, color: Colors.grey.shade400, size: 16)
                                  )
                                ],
                              ),
                              ),
                              DataCell(Center(child: InkWell(child: Icon(Icons.restaurant_menu, size: 20, color: item.menuYn == 'N' ? Colors.blue : Colors.grey.shade400),
                                onTap: () {
                                  if (AuthUtil.isAuthReadEnabled('109') == false){
                                    ISAlert(context, '조회 권한이 없습니다. \n\n관리자에게 문의 바랍니다');
                                    return;
                                  }

                                  _editMenuGroup(ccCode: item.ccCode, shopCode: item.shopCd, menuComplete: item.menuComplete);
                                },
                              )),
                              ),
                              DataCell(Center(child: item.menuComplete.toString() == 'Y' ? Icon(Icons.radio_button_unchecked, color: Colors.blue, size: 16) : Icon(Icons.clear, color: Colors.grey.shade400, size: 16)),),
                              DataCell(Center(child: InkWell(child: Icon(Icons.airplay, size: 20),
                                onTap: () async {
                                  await EasyLoading.showInfo('사장님사이트로 이동합니다.', maskType: EasyLoadingMaskType.clear, duration: Duration(seconds: 2), dismissOnTap: true);
                                  await EasyLoading.dismiss();
                                  _launchInBrowser(item.shopCd);
                                },

                              )),
                              ),
                              DataCell(Align(
                                    child: Container(
                                      padding: EdgeInsets.only(left: 10.0),
                                      height: 30,
                                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(5.0)),
                                      child: DropdownButton(
                                        style: TextStyle(fontSize: 12, fontFamily: 'NotoSansKR', color: Colors.black),
                                        onChanged: (value) async {
                                          if (AuthUtil.isAuthEditEnabled('102') == false){
                                            ISAlert(context, '처리 권한이 없습니다. \n\n관리자에게 문의 바랍니다');
                                            return;
                                          }

                                          await ShopController.to.putUpdateImageStatus(item.shopCd, value, context);

                                          await Future.delayed(Duration(milliseconds: 500), () {
                                            _query();
                                          });
                                        },
                                        value: item.imageStatus,
                                        items: selectBox_imageStatus,
                                      ),
                                    ),
                                    alignment: Alignment.centerLeft
                                )
                              ),
                              DataCell(Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.salesmanCode.toString() == '' ? '영업: ' : '영업: [' + item.salesmanCode.toString() + '] ' + item.salesmanName.toString(), style: TextStyle(color: Colors.black, fontSize: 10),),
                                    Text(item.operatorCode.toString() == '' ? '오퍼: ' : '오퍼: [' + item.operatorCode.toString() + '] ' + item.operatorName.toString(), style: TextStyle(color: Colors.black, fontSize: 10),),
                                  ],
                                ),
                              ),
                              ),
                              DataCell(Center(
                                child: item.isCharged.toString() == 'Y'
                                    ? MaterialButton(
                                  height: Responsive.isDesktop(context) == true ? 40.0 : 30.0,
                                  color: Colors.grey.shade400,
                                  minWidth: 40,
                                  child: Text('완료', style: TextStyle(color: Colors.grey, fontSize: 14),),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                )
                                    : MaterialButton(
                                  height: Responsive.isDesktop(context) == true ? 40.0 : 30.0,
                                  color: Colors.blue,
                                  minWidth: 40,
                                  child: Text('지급', style: TextStyle(color: Colors.white, fontSize: 14),),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                  onPressed: () async {
                                    if (AuthUtil.isAuthEditEnabled('101') == false){
                                      ISAlert(context, '처리 권한이 없습니다. \n\n관리자에게 문의 바랍니다');
                                      return;
                                    }

                                    ISConfirm(context, '입점지원금 지급', '입점지원금을 지급 하시겠습니까?', (context) async {
                                      await ShopController.to.postChargeJoin(item.shopCd, GetStorage().read('logininfo')['uCode'], context).then((value) {
                                        _query();
                                        Navigator.of(context).pop();
                                      });
                                    });
                                  },
                                ),
                              )),
                              DataCell(
                                Center(
                                    child: InkWell(
                                      child: Icon(Icons.rate_review, size: 22),
                                      onTap: () async {
                                        if (AuthUtil.isAuthReadEnabled('103') == false){
                                          ISAlert(context, '처리 권한이 없습니다. \n\n관리자에게 문의 바랍니다');
                                          return;
                                        }

                                        _editMoveReview(shopCode: item.shopCd);
                                      },
                                    )),
                              ),

                            ]);
                      }).toList(),
                      columns: <DataColumn>[
                        if (widget.shopName == null)
                          DataColumn(label: Expanded(
                            child: Checkbox(
                                value: isCheckAll,//this.checkAll,
                                onChanged: (v) {
                                  isCheckAll = v;
                                  isCheckAll == false ? _testOrderCnt = 0 : _testOrderCnt = dataList.length;

                                  dataList.forEach((element) {
                                    element.selected = v;
                                  });

                                  setState(() {});
                                }
                            ),
                          )
                          ),

                        DataColumn(label: Expanded(child: Text('대표\n이미지', textAlign: TextAlign.center, style: TextStyle(fontSize: 12))),),
                        DataColumn(label: Expanded(child: SelectableText('코드/가맹점명', textAlign: TextAlign.center)),),
                        DataColumn(label: Expanded(child: Text('등록일', textAlign: TextAlign.center)),),
                        DataColumn(label: Expanded(child: Text('중복', textAlign: TextAlign.center)),),

                        DataColumn(label: Expanded(child: Text('승인', textAlign: TextAlign.center)),),
                        DataColumn(label: Expanded(child: Text('사용', textAlign: TextAlign.center)),),
                        //DataColumn(label: Expanded(child: Text('메모', textAlign: TextAlign.center)),),
                        DataColumn(label: Expanded(child: Text('휴점', textAlign: TextAlign.center)),),
                        DataColumn(label: Expanded(child: Text('POS상태\n(설치/로그인)', textAlign: TextAlign.center, style: TextStyle(fontSize: 12),))),
                        DataColumn(label: Expanded(child: Text('메뉴', textAlign: TextAlign.center)),),
                        DataColumn(label: Expanded(child: Text('메뉴완료', textAlign: TextAlign.center)),),
                        DataColumn(label: Expanded(child: Text('사장님\n사이트', textAlign: TextAlign.center, style: TextStyle(fontSize: 12))),),
                        DataColumn(label: Expanded(child: Text('상태', textAlign: TextAlign.center)),),
                        DataColumn(label: Expanded(child: Text('영업/오퍼', textAlign: TextAlign.center)),),
                        DataColumn(label: Expanded(child: Text('입점지원금', textAlign: TextAlign.center)),),
                        DataColumn(label: Expanded(child: Text('리뷰이관', textAlign: TextAlign.center)),),
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
      width: 500,
      height: (widget.shopName == null) ? (MediaQuery.of(context).size.height-190) : widget.popHeight-80,
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
            (widget.shopName == null) ? Container(child: Text(nSelectedShopTitle, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),)) : Container(),
            TabBar(
              controller: _nestedTabController,
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 4, color: Color(0xFF646464)),
                  insets: EdgeInsets.only(left: 0, right: 8, bottom: 4)
              ),
              isScrollable: true,
              labelPadding: EdgeInsets.only(left: 0, right: 0),
              // indicatorColor: Colors.blue,
              labelColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.label,
              // unselectedLabelColor: Colors.black54,
              //isScrollable: true,
              // indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Padding(padding: const EdgeInsets.only(right: 8), child: Tab(text: '   기본정보   '),),
                Padding(padding: const EdgeInsets.only(right: 8), child: Row(
                  children: [
                    Tab(text: '     정산'),
                    (mDetailData == null || mDetailData.selected_calcYn == 'N') ? Text('     ') : Icon(Icons.priority_high, size: 16, color: Colors.blue)
                  ],
                )),
                Padding(padding: const EdgeInsets.only(right: 8), child: Row(
                  children: [
                    Tab(text: '     매장'),
                    (mDetailData == null || mDetailData.selected_shopInfoYn == 'N') ? Text('     ') : Icon(Icons.priority_high, size: 16, color: Colors.blue)
                  ],
                )),
                Padding(padding: const EdgeInsets.only(right: 8), child: Row(
                  children: [
                    Tab(text: '     배달지'),
                    (mDetailData == null || mDetailData.selected_deliYn == 'N') ? Text('     ') : Icon(Icons.priority_high, size: 16, color: Colors.blue)
                  ],
                )),
                Padding(padding: const EdgeInsets.only(right: 8), child: Row(
                  children: [
                    Tab(text: '     배달팁'),
                    (mDetailData == null || mDetailData.selected_tipYn == 'N') ? Text('     ') : Icon(Icons.priority_high, size: 16, color: Colors.blue)
                  ],
                )),
                Padding(padding: const EdgeInsets.only(right: 8), child: Row(
                  children: [
                    Tab(text: '     운영'),
                    (mDetailData == null || mDetailData.selected_saleYn == 'N') ? Text('     ') : Icon(Icons.priority_high, size: 16, color: Colors.blue)
                  ],
                )),
              ],
              onTap: (index) {
                if (_selectedViewSeq == '') {
                  _nestedTabController.index = 0;
                  return;
                }

                callStreamBroadcast();
              },
            ),
            Container(
              width: double.infinity,
              height: (widget.shopName == null) ? (MediaQuery.of(context).size.height-271) : widget.popHeight-156,
              child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _nestedTabController,
                  children: <Widget>[
                      AuthUtil.isAuthReadEnabled('95') == true ? ShopBasicInfo(stream: streamControllerBasicInfo.stream, callback: detailCallback, selectBox_operator: selectBox_operatorBasicInfo, selectBox_salesman: selectBox_salesmanBasicInfo,
                        selectBox_ccCode: selectBox_ccCodeBasicInfo, selectBox_brandType: selectBox_brandTypeBasicInfo,
                        height: widget.shopName == null ? (MediaQuery.of(context).size.height-321) : widget.popHeight-206)
                      : Container(child: Text('조회 권한이 없습니다.', style: TextStyle(color: Colors.black45)), alignment: Alignment.center,),

                    AuthUtil.isAuthReadEnabled('96') == true ? ShopCalcInfo(stream: streamControllerCalcInfo.stream, callback: detailCallback)
                        : Container(child: Text('조회 권한이 없습니다.', style: TextStyle(color: Colors.black45)), alignment: Alignment.center,),

                    AuthUtil.isAuthReadEnabled('97') == true ? ShopInfo(stream: streamControllerInfo.stream, callback: detailCallback, height: widget.shopName == null ? (MediaQuery.of(context).size.height-321) : widget.popHeight-236)
                        : Container(child: Text('조회 권한이 없습니다.', style: TextStyle(color: Colors.black45)), alignment: Alignment.center,),

                    AuthUtil.isAuthReadEnabled('98') == true ? ShopSectorInfo(callback: detailCallback, stream: streamControllerSectorInfo.stream, height: widget.shopName == null ? (MediaQuery.of(context).size.height - 321) : widget.popHeight - 206)
                        : Container(child: Text('조회 권한이 없습니다.', style: TextStyle(color: Colors.black45)), alignment: Alignment.center,),

                    AuthUtil.isAuthReadEnabled('99') == true ? ShopDeliTip(stream: streamControllerDeliTip.stream, height: widget.shopName == null ? (MediaQuery.of(context).size.height-321) : widget.popHeight-206)
                        : Container(child: Text('조회 권한이 없습니다.', style: TextStyle(color: Colors.black45)), alignment: Alignment.center,),

                    AuthUtil.isAuthReadEnabled('100') == true ? ShopOperateInfo(ccCode: _selectedCcCode, stream: streamControllerOperateInfo.stream, callback: detailCallback,
                        selectBox_itemCd: selectBox_reserve_itemCd, selectBox_subitemCd: selectBox_reserve_subitemCd, height: widget.shopName == null ? (MediaQuery.of(context).size.height-321) : widget.popHeight-206)
                        : Container(child: Text('조회 권한이 없습니다.', style: TextStyle(color: Colors.black45)), alignment: Alignment.center,),
                  ]
              ),
            ),
          ],
        ),
      ),
    );
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
              child: widget.shopName == null ? Row(
                children: <Widget>[
                      widget.shopName == null ? Visibility(
                        visible: AuthUtil.isAuthDownloadEnabled('5')
                            ? true : false,
                        child: ISButton(
                          label: 'Excel저장',
                                  enable: excelEnable == true ? true : false,
                                  iconColor: Colors.white,
                                  iconData: Icons.reply,
                                  textStyle: TextStyle(color: Colors.white),
                                  onPressed: () {
                                    excelEnable = false;
                                    setState(() {});
                                    SaveExcelExport();
                                  }
                        ),
                      ) : Container(),
                      Visibility(
                        visible: excelEnable == false ? true : false,
                        child: Text(
                          '[Excel 다운로드 중입니다. 잠시만 기다려 주십시오]',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ISButton(
                          label: '테스트 오더 발송',
                          enable: _testOrderCnt == 0 ? false : true,
                          iconColor: Colors.white,
                          iconData: Icons.send_to_mobile,
                          textStyle: TextStyle(color: Colors.white),
                          onPressed: () async {
                            var headerData = {
                              "content-type": "application/json",
                              "Access-Control-Allow-Origin": "*", // Required for CORS support to work
                              "Access-Control-Allow-Headers": "X-API-KEY, Origin, X-Requested-With, Content-Type, Accept, Access-Control-Request-Method,Access-Control-Request-Headers, Authorization",
                              "Access-Control-Allow-Credentials": "true",
                              "Access-Control-Allow-Methods": "HEAD, GET, POST, PUT, PATCH, DELETE, OPTIONS",
                              //"Accept": "application/json",
                            };

                            var bodyData = {
                              '"packOrderYn": "N",  "shopDeliMemo": "테스트 주문입니다. 배차 잡지 말아주세요!","riderDeliMemo": "테스트 주문입니다. 배차 잡지 말아주세요!",' + '"' + "customer" + '"':
                              '{"' + 'tel" : "01000000000"}'
                            };

                            dataList.forEach((item) async {
                              if (item.selected == true) {
                                String _shop_cd = item.shopCd;

                                String uCode = GetStorage().read('logininfo')['uCode'];
                                String uName = GetStorage().read('logininfo')['name'];

                                await RestApiProvider.to.postRestError('0', '/admin/Order : testOrder', '[테스트 오더 발송] shopCd : $_shop_cd, ucode : $uCode , name : $uName');
                                await http.post(Uri.parse('https://app.daeguro.co.kr/shops/$_shop_cd/orders-test'), headers: headerData, body: bodyData.toString()).then((http.Response response) {
                                  if (response.statusCode == 200) {
                                    var decodeBody = jsonDecode(response.body);

                                    print(decodeBody['code']);

                                    if(decodeBody['code'] != '00')
                                    {
                                      ISAlert(context, '테스트 오더 생성 실패했습니다.\n\n' + decodeBody['msg']);
                                    }
                                  } else {
                                    ISAlert(context, '테스트 오더 생성 실패했습니다.');
                                  }

                                  // 선택된 가맹점들 초기화
                                  item.selected = false;
                                  _testOrderCnt = 0;

                                  setState(() {});
                                });
                              }
                            });
                          }
                          ),

                ],
              ) : Container(),
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
            widget.shopName == null ? Container(
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
            ) : Container(),
          ]
        ),
      )
    );
  }

  Future<void> _launchInBrowser(String shopCode) async {
    //ucode, name
    String uCode = GetStorage().read('logininfo')['uCode'];
    String uID = GetStorage().read('logininfo')['id'];
    String uName = GetStorage().read('logininfo')['name'];

    // var _test = {
    //   "uCode": "$uCode",
    //   "uName": "$uName",
    //   "jobName": "Store",
    //   "shopCd": "$shopCode",
    // };
    //
    // print('정보->');
    // print(_test.toString());
    //
    // print('암호화');
    // encrypterPayload(_test.toString());

    String url = ServerInfo.OWNERSITE_URL + '/$shopCode/$uCode/$uID/Store';
    // print('launch web : ' + url);

    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false, //true로 설정시, iOS 인앱 브라우저를 통해픈
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

  double getListMainPanelWidth(){
    double nWidth = MediaQuery.of(context).size.width-800;
    if (widget.shopName == null){
      if (Responsive.isTablet(context) == true)           nWidth = nWidth + sidebarWidth;
      else if (Responsive.isMobile(context) == true)      nWidth = MediaQuery.of(context).size.width;
    }
    else{
      nWidth = widget.popWidth - 530;
    }

    return nWidth;
  }

  void SaveExcelExport() async {
    await http.get(ServerInfo.REST_URL_EXCELEXPORT + '/?mcode=$_mCode').then((http.Response response) {
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


