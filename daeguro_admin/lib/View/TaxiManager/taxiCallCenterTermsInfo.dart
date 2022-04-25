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

class TaxiCallCenterTermsInfo extends StatefulWidget {
  final Stream<ShopDetailNotifierData> stream;
  final List<SelectOptionVO> selectBox_ccCode;
  final Function callback;
  final double height;

  //final ShopBasicInfo sData;

  const TaxiCallCenterTermsInfo({Key key, this.stream, this.callback, this.selectBox_ccCode, this.height}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TaxiCallCenterTermsInfoState();
  }
}

enum RadioGbn { gbn1, gbn2 }

class TaxiCallCenterTermsInfoState extends State<TaxiCallCenterTermsInfo> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ShopBasicInfoModel formData = ShopBasicInfoModel();
  ShopPosUpdateModel shopPosUpdate = ShopPosUpdateModel();
  List<SelectOptionVO> termsDataList = [];

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

    termsDataList.add(new SelectOptionVO(value: '1', label: '타이틀11111', label2: '2022-04-01'));
    termsDataList.add(new SelectOptionVO(value: '2', label: '타이틀22222', label2: '2022-04-03'));
    termsDataList.add(new SelectOptionVO(value: '3', label: '타이틀33333', label2: '2022-04-07'));

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
                    leading: Text(termsDataList[index].value.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    minLeadingWidth: 10,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            padding: EdgeInsets.only(top: 5),
                            child: SelectableText(
                              termsDataList[index].label.toString() ?? '--',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                              showCursor: true,
                            )),
                      ],
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => Dialog(
                            child: taxiCallCenterTermsEdit(name: '콜센터11111',  memo: termsDataList[index].label, title: '10')
                          ),
                        ).then((v) async {
                          if (v != null) {
                            loadData();
                          }
                        });
                      },
                      icon: Icon(Icons.edit, size: 20, color: Colors.blue[300]),
                      splashRadius: 20,
                      tooltip: '수정',
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text(termsDataList[index].label2 ?? '--', style: TextStyle(fontSize: 12), textAlign: TextAlign.left))
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '총: 3건',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          ISButton(
            label: '등록',
            iconColor: Colors.white,
            textStyle: TextStyle(color: Colors.white),
            iconData: Icons.save,
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) => Dialog(
                    child: taxiCallCenterTermsRegist(name: '콜센터11111')
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
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
