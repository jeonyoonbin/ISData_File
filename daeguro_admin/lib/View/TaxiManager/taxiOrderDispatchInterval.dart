
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/Model/shop/shopbasic_info.dart';

import 'package:daeguro_admin_app/View/AgentManager/agentAccount_Controller.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/tax_controller.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopDetailNotifierData.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:get/get.dart';



class TaxiOrderDispatchInterval extends StatefulWidget {
  final Stream<ShopDetailNotifierData> stream;
  final List<SelectOptionVO> selectBox_operator;
  final List<SelectOptionVO> selectBox_salesman;
  final List<SelectOptionVO> selectBox_ccCode;
  final List<SelectOptionVO> selectBox_brandType;
  final Function callback;
  final double height;

  //final ShopBasicInfo sData;

  const TaxiOrderDispatchInterval(
      {Key key, this.stream, this.callback, this.selectBox_operator, this.selectBox_salesman, this.selectBox_ccCode, this.selectBox_brandType, this.height})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TaxiOrderDispatchIntervalState();
  }
}

enum RadioGbn { gbn1, gbn2 }

class TaxiOrderDispatchIntervalState extends State<TaxiOrderDispatchInterval> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ShopBasicInfoModel formData = ShopBasicInfoModel();

  RadioGbn _radioGbn;

  ScrollController _scrollController;

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
        _scrollController.jumpTo(0.0);
      });
    } else {
      formData = null;
      formData = ShopBasicInfoModel();

      isReceiveDataEnabled = false;

      setState(() {
        _scrollController.jumpTo(0.0);
      });
    }
  }

  loadData() async {
    formData = null;
    formData = ShopBasicInfoModel();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    Get.put(AgentController());
    Get.put(TaxController());

    _scrollController = ScrollController();

    //if (widget.streamIsInit == false){
    widget.stream.listen((element) {
      refreshWidget(element);
    });
    //}
  }

  @override
  void dispose() {
    _scrollController.dispose();
    detailData = null;

    formData = null;

    //selectBox_salesman.clear();
    //selectBox_operator.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0), //EdgeInsets.all(8.0),
        child: getInfoTabView(),
      ),
    );
  }

  Widget getInfoTabView() {
    return Scrollbar(
      isAlwaysShown: false,
      controller: _scrollController,
      child: ListView(
        controller: _scrollController,
        children: [
          Form(
            key: formKey,
            child: Wrap(
              children: <Widget>[
                Divider(),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: ISInput(
                        //autofocus: true,
                        value: '기사/010-****-1123',
                        context: context,
                        label: '기사정보',
                        onChange: (v) {
                          formData.shopName = v;
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: ISInput(
                        //autofocus: true,
                        value: '대구32바2724/그랜저/일반',
                        context: context,
                        label: '차량정보',
                        onChange: (v) {
                          formData.shopName = v;
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: ISInput(
                        //autofocus: true,
                        value: '2022-02-23 19:09:23',
                        context: context,
                        label: '탑승시간',
                        onChange: (v) {
                          formData.shopName = v;
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: ISInput(
                        //autofocus: true,
                        value: '2022-02-23 19:29:53',
                        context: context,
                        label: '도착시간',
                        onChange: (v) {
                          formData.shopName = v;
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: ISInput(
                        //autofocus: true,
                        value: '대구 서구 광역시 북비산로 369',
                        context: context,
                        label: '출발지 주소',
                        onChange: (v) {
                          formData.shopName = v;
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: ISInput(
                        //autofocus: true,
                        value: '대구 서구 광역시 북비산로 369',
                        context: context,
                        label: '도착지 주소',
                        onChange: (v) {
                          formData.shopName = v;
                        },
                      ),
                    ),
                  ],
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
