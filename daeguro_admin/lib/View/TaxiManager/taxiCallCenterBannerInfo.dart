import 'dart:convert';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_input.dart';
import 'package:daeguro_admin_app/Model/shop/shopImageHistory.dart';
import 'package:daeguro_admin_app/Model/shop/shop_history.dart';
import 'package:daeguro_admin_app/Model/shop/shopbasic_info.dart';
import 'package:daeguro_admin_app/Model/shop/shopposupdate.dart';
import 'package:daeguro_admin_app/Model/user/userListModel.dart';
import 'package:daeguro_admin_app/Network/DioClient.dart';

import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/View/AgentManager/agentAccount_Controller.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/tax_controller.dart';
import 'package:daeguro_admin_app/View/PostCode/postCodeRequest.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopDetailNotifierData.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopMemoHistory.dart';
import 'package:daeguro_admin_app/Util/multi_masked_formatter.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/TaxiManager/taxiCallCenterBannerEdit.dart';
import 'package:daeguro_admin_app/View/TaxiManager/taxiCallCenterBannerRegist.dart';
import 'package:daeguro_admin_app/View/TaxiManager/taxiCallCenterTermsEdit.dart';
import 'package:daeguro_admin_app/View/TaxiManager/taxiCallCenterTermsRegist.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:kopo/kopo.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class TempModel {
  String RNUM = '1';
  String a = '오픈 기념 이벤트'; //매장명
  String b = '2022-01-01';
  String c = '2022-04-01'; //사업자유형
  String d = 'O'; //사업자유형
  String e = 'https://admin.daeguro.co.kr'; //대표자명
  String f = '37'; // 주소
  String g = '000-555-5555'; // 사업자등록번호
}

class TaxiCallCenterBannerInfo extends StatefulWidget {
  final Stream<ShopDetailNotifierData> stream;
  final List<SelectOptionVO> selectBox_ccCode;
  final Function callback;
  final double height;

  //final ShopBasicInfo sData;

  const TaxiCallCenterBannerInfo({Key key, this.stream, this.callback, this.selectBox_ccCode, this.height}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TaxiCallCenterBannerInfoState();
  }
}

class TaxiCallCenterBannerInfoState extends State<TaxiCallCenterBannerInfo> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ShopBasicInfoModel formData = ShopBasicInfoModel();
  ShopPosUpdateModel shopPosUpdate = ShopPosUpdateModel();
  List<SelectOptionVO> termsDataList = [];

  final List<TempModel> dataList = <TempModel>[];

  //List<SelectOptionVO> selectBox_salesman = [];
  //List<SelectOptionVO> selectBox_operator = [];

  TabController _nestedTabController;

  ScrollController _scrollController;

  List<ShopHistoryModel> dataHistoryList = <ShopHistoryModel>[];

  ShopDetailNotifierData detailData;

  bool isReceiveDataEnabled = false;
  bool isListSaveEnabled = false;

  String setTitle;

  List<SelectOptionVO> selectBox_title = [
    new SelectOptionVO(value: '00', label: '제목'),
    new SelectOptionVO(value: '10', label: '링크주소'),
  ];

  void refreshWidget(ShopDetailNotifierData element) {
    detailData = element;

    if (detailData != null) {
      //print('shopBasic refreshWidget() is not NULL -> [${element.selected_shopCode}]');

      loadData();

      isReceiveDataEnabled = true;

      setState(() {
        _nestedTabController.index = 0;
        _scrollController.jumpTo(0.0);
      });
    } else {
      //print('shopBasic refreshWidget() is NULL');

      formData = null;
      formData = ShopBasicInfoModel();

      dataHistoryList.clear();
      //selectBox_salesman.clear();
      //selectBox_operator.clear();

      shopPosUpdate = null;
      shopPosUpdate = ShopPosUpdateModel();

      isReceiveDataEnabled = false;

      setState(() {
        _nestedTabController.index = 0;
        _scrollController.jumpTo(0.0);
      });
    }
  }

  loadData() async {
    _nestedTabController.index = 0;

    formData = null;
    shopPosUpdate = null;
    formData = ShopBasicInfoModel();
    shopPosUpdate = ShopPosUpdateModel();

    shopPosUpdate.hdong = '';
    shopPosUpdate.ri = '';

    dataHistoryList.clear();

    //if (this.mounted) {
    setState(() {});
    //}
  }

  @override
  void initState() {
    super.initState();

    Get.put(AgentController());
    Get.put(TaxController());

    _nestedTabController = new TabController(length: 2, vsync: this);
    _scrollController = ScrollController();

    setTitle = '00';

    TempModel tempModel = new TempModel();
    dataList.add(tempModel);

    //if (widget.streamIsInit == false){
    widget.stream.listen((element) {
      refreshWidget(element);
    });
    //}
  }

  @override
  void dispose() {
    _nestedTabController.dispose();
    _scrollController.dispose();
    detailData = null;

    formData = null;
    shopPosUpdate = null;

    //selectBox_salesman.clear();
    //selectBox_operator.clear();

    dataHistoryList.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0), //EdgeInsets.all(8.0),
        child: getInfoView(),
      ),
    );
  }

  Widget getInfoView() {
    return Scrollbar(
      isAlwaysShown: false,
      controller: _scrollController,
      child: Column(
        children: [
          buttonBar(),
          Divider(),
          Expanded(
            child: getTermsView(),
          )
        ],
      ),
    );
  }

  Widget getTermsView() {
    return ISDatatable(
      listWidth: 680,
      rows: dataList.map((item) {
        return DataRow(cells: [
          DataCell(Center(
              child: Text(
            item.a.toString() ?? '--',
            style: TextStyle(color: Colors.black),
          ))),
          DataCell(Center(
              child: Text(
            item.b.toString() ?? '--',
            style: TextStyle(color: Colors.black),
          ))),
          DataCell(Center(
              child: Text(
            item.c.toString() ?? '--',
            style: TextStyle(color: Colors.black),
          ))),
          DataCell(Center(
              child: Text(
            item.d.toString() ?? '--',
            style: TextStyle(color: Colors.black),
          ))),
          DataCell(Center(
              child: Text(
            item.e.toString() ?? '--',
            style: TextStyle(color: Colors.black),
          ))),
          DataCell(Center(
              child: Text(
            item.f.toString() ?? '--',
            style: TextStyle(color: Colors.black),
          ))),
          DataCell(Center(child: InkWell(child: SizedBox(width: 30, height: 30, child: Image.asset('assets/daeguro_icon_32.png'))))),
          DataCell(
            Center(
                child: Container(
              //color: Colors.red,
              child: IconButton(
                //padding: EdgeInsets.only(top: 20),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => Dialog(
                        child: taxiCallCenterBannerEdit(name: '콜센터11111')
                    ),
                  ).then((v) async {
                    if (v != null) {
                      loadData();
                    }
                  });
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.blue,
                  size: 20,
                ),
                tooltip: '수정',
              ),
            )),
          ),
        ]);
      }).toList(),
      columns: <DataColumn>[
        DataColumn(
          label: Expanded(child: Text('제목', textAlign: TextAlign.center)),
        ),
        DataColumn(
          label: Expanded(child: Text('게시\n시작일', textAlign: TextAlign.center)),
        ),
        DataColumn(
          label: Expanded(child: Text('게시\n종료일', textAlign: TextAlign.center)),
        ),
        DataColumn(
          label: Expanded(child: Text('공개', textAlign: TextAlign.center)),
        ),
        DataColumn(
          label: Expanded(child: Text('링크주소', textAlign: TextAlign.center)),
        ),
        DataColumn(
          label: Expanded(child: Text('클릭수', textAlign: TextAlign.center)),
        ),
        DataColumn(
          label: Expanded(child: Text('이미지', textAlign: TextAlign.center)),
        ),
        DataColumn(
          label: Expanded(child: Text('수정', textAlign: TextAlign.center)),
        ),
      ],
    );
  }

  Widget buttonBar() {
    return Container(
      padding: EdgeInsets.only(right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '총: 1건',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Container(
            height: 50,
            child: Row(
              children: [
                ISSearchDropdown(
                  label: '조회구분',
                  width: 120,
                  value: '00',
                  onChange: (value) {
                    setState(() {
                      formKey.currentState.save();
                    });
                  },
                  item: [
                    DropdownMenuItem(
                      value: '00',
                      child: Text('제목'),
                    ),
                    DropdownMenuItem(
                      value: '10',
                      child: Text('링크주소'),
                    ),
                  ].cast<DropdownMenuItem<String>>(),
                ),
                ISSearchInput(
                  width: 200,
                  value: '',
                  onChange: (v) {},
                  onFieldSubmitted: (value) {},
                ),
                ISButton(
                  label: '검색',
                  iconColor: Colors.white,
                  textStyle: TextStyle(color: Colors.white),
                  iconData: Icons.search,
                  onPressed: () async {},
                ),
                SizedBox(width: 8),
                ISButton(
                  label: '등록',
                  iconColor: Colors.white,
                  textStyle: TextStyle(color: Colors.white),
                  iconData: Icons.save,
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                          child: taxiCallCenterBannerRegist()
                      ),
                    ).then((v) async {
                      if (v != null) {
                        loadData();
                      }
                    });

                    widget.callback();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
