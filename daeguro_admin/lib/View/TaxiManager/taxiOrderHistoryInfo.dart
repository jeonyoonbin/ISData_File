import 'dart:convert';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/Model/shop/shopImageHistory.dart';
import 'package:daeguro_admin_app/Model/shop/shop_history.dart';
import 'package:daeguro_admin_app/Model/shop/shopbasic_info.dart';
import 'package:daeguro_admin_app/Model/shop/shopposupdate.dart';
import 'package:daeguro_admin_app/Network/DioClient.dart';

import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/View/AgentManager/agentAccount_Controller.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/tax_controller.dart';
import 'package:daeguro_admin_app/View/PostCode/postCodeRequest.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopDetailNotifierData.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopMemoHistory.dart';
import 'package:daeguro_admin_app/Util/multi_masked_formatter.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
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

class historyData {
  historyData({this.no, this.date, this.insName, this.field, this.memo, this.gbn});

  int no;
  String date;
  String insName;
  String field;
  String memo;
  String gbn;
}

class TaxiOrderHistoryInfo extends StatefulWidget {
  final Stream<ShopDetailNotifierData> stream;
  final List<SelectOptionVO> selectBox_ccCode;
  final Function callback;
  final double height;

  //final ShopBasicInfo sData;

  const TaxiOrderHistoryInfo({Key key, this.stream, this.callback, this.selectBox_ccCode, this.height}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TaxiOrderHistoryInfoState();
  }
}

enum RadioGbn { gbn1, gbn2 }

class TaxiOrderHistoryInfoState extends State<TaxiOrderHistoryInfo> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ShopBasicInfoModel formData = ShopBasicInfoModel();
  ShopPosUpdateModel shopPosUpdate = ShopPosUpdateModel();
  List<historyData> termsDataList = [];

  RadioGbn _radioGbn;

  //List<SelectOptionVO> selectBox_salesman = [];
  //List<SelectOptionVO> selectBox_operator = [];

  TabController _nestedTabController;

  ScrollController _scrollController;

  List<ShopHistoryModel> dataHistoryList = <ShopHistoryModel>[];

  ShopDetailNotifierData detailData;

  bool isReceiveDataEnabled = false;
  bool isListSaveEnabled = false;

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

    termsDataList.add(new historyData(no: 1, date: '2022-02-24 11:38:35', insName: '테스트', field: 'NM_COMP', memo: '테스트 -> 테스트법인택시 으(로) 변경', gbn: 'PC'));
    termsDataList.add(new historyData(no: 2, date: '2022-02-25 11:38:35', insName: '테스트', field: 'NM_COMP2', memo: '테스트 -> 테스트법인택시 으(로) 변경22', gbn: 'MOBILE'));
    termsDataList.add(new historyData(no: 3, date: '2022-02-28 11:38:35', insName: '테스트', field: 'NM_COMP3', memo: '테스트 -> 테스트법인택시 으(로) 변경33', gbn: 'PC'));

    _nestedTabController = new TabController(length: 2, vsync: this);
    _scrollController = ScrollController();

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
    return ListView.builder(
      controller: ScrollController(),
      //padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      itemCount: termsDataList.length,
      itemBuilder: (BuildContext context, int index) {
        return termsDataList != null
            ? GestureDetector(
          child: Card(
            elevation: 2.0,
            child: ListTile(
              //leading: Text(termsDataList[index].value.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              minLeadingWidth: 10,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: SelectableText(
                        termsDataList[index].insName.toString() + ' [' + termsDataList[index].field.toString() + '] - ' + termsDataList[index].gbn.toString() ?? '--',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                        showCursor: true,
                      )),
                  Container(
                      margin: EdgeInsets.only(top: 5),
                      child: SelectableText(
                        termsDataList[index].memo.toString() ?? '--',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        showCursor: true,
                      )),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      child: Text(termsDataList[index].date ?? '--', style: TextStyle(fontSize: 12), textAlign: TextAlign.left))
                ],
              ),
            ),
          ),
        )
            : Text('Data is Empty');
      },
    );
  }

  Widget buttonBar() {
    return Container(
      padding: EdgeInsets.only(right: 8),
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '총: 3건',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
