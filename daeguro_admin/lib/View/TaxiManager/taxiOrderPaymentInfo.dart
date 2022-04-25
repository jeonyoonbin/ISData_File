
import 'package:daeguro_admin_app/ISWidget/is_button.dart';
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



class TaxiOrderPayMentInfo extends StatefulWidget {
  final Stream<ShopDetailNotifierData> stream;
  final List<SelectOptionVO> selectBox_operator;
  final List<SelectOptionVO> selectBox_salesman;
  final List<SelectOptionVO> selectBox_ccCode;
  final List<SelectOptionVO> selectBox_brandType;
  final Function callback;
  final double height;

  //final ShopBasicInfo sData;

  const TaxiOrderPayMentInfo(
      {Key key, this.stream, this.callback, this.selectBox_operator, this.selectBox_salesman, this.selectBox_ccCode, this.selectBox_brandType, this.height})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TaxiOrderPayMentInfoState();
  }
}

enum RadioGbn { gbn1, gbn2 }

class TaxiOrderPayMentInfoState extends State<TaxiOrderPayMentInfo> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
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
                        value: '자동',
                        readOnly: true,
                        context: context,
                        label: '결제구분',
                        onChange: (v) {
                          formData.shopName = v;
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: ISInput(
                        //autofocus: true,
                        value: 'KCP',
                        readOnly: true,
                        context: context,
                        label: 'PG사',
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
                        value: '2,000원',
                        readOnly: true,
                        context: context,
                        label: '예상최종 운임',
                        onChange: (v) {
                          formData.shopName = v;
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: ISInput(
                        //autofocus: true,
                        value: '3,000원',
                        context: context,
                        label: '추가금액',
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
                        value: '0원',
                        readOnly: true,
                        context: context,
                        label: '적립마일리지(고객)',
                        onChange: (v) {
                          formData.shopName = v;
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: ISInput(
                        //autofocus: true,
                        value: '0원',
                        readOnly: true,
                        context: context,
                        label: '사용마일리지',
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
                        value: '0원',
                        readOnly: true,
                        context: context,
                        label: '적립마일리지(지점)',
                        onChange: (v) {
                          formData.shopName = v;
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: ISInput(
                        //autofocus: true,
                        value: 'abcdef / 0원',
                        readOnly: true,
                        context: context,
                        label: '쿠폰정보',
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
                        value: '0원',
                        readOnly: true,
                        context: context,
                        label: '행복페이 할인금액',
                        onChange: (v) {
                          formData.shopName = v;
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: ISInput(
                        //autofocus: true,
                        value: '2,300원',
                        readOnly: true,
                        context: context,
                        label: '결제할 금액',
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
                        value: '2,300원',
                        readOnly: true,
                        context: context,
                        label: '결제한 금액',
                        onChange: (v) {
                          formData.shopName = v;
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: ISSelect(
                          label: '결제 상태',
                          ignoring: true,
                          value: formData.ccCode,
                          dataList: widget.selectBox_ccCode,
                          onChange: (v) {
                            formData.ccCode = v;
                          }),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: ISInput(
                        //autofocus: true,
                        value: '0원',
                        readOnly: true,
                        context: context,
                        label: '환불할 금액',
                        onChange: (v) {
                          formData.shopName = v;
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container()
                    ),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: ISInput(
                        //autofocus: true,
                        value: 'BC카드 / 신용 / 946031******12345',
                        readOnly: true,
                        context: context,
                        label: '결제내역',
                        onChange: (v) {
                          formData.shopName = v;
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 5),
                    Text('전표 보기', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(Icons.payment),
                      color: Colors.blue,
                      iconSize: 23,
                      tooltip: '전표 1',
                      splashRadius: 15,
                      onPressed: (){
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.payment),
                      color: Colors.blue,
                      iconSize: 23,
                      tooltip: '전표 2',
                      splashRadius: 15,
                      onPressed: (){
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.payment),
                      color: Colors.blue,
                      iconSize: 23,
                      tooltip: '전표 3',
                      splashRadius: 15,
                      onPressed: (){
                      },
                    ),
                  ],
                ),
                SizedBox(height: 45),
                Row(
                  children: [
                    SizedBox(width: 5),
                    ISButton(
                      height: 35,
                      //padding: EdgeInsets.fromLTRB(10, 20, 0, 10),
                      textStyle: TextStyle(fontSize: 12, color: Colors.white),
                      label: '카드결제',
                      onPressed: () {
                        if (detailData == null) return;
                      },
                    ),
                    SizedBox(width: 10),
                    ISButton(
                      height: 35,
                      //padding: EdgeInsets.fromLTRB(10, 20, 0, 10),
                      textStyle: TextStyle(fontSize: 12, color: Colors.white),
                      label: '카드결제 취소',
                      onPressed: () {
                        if (detailData == null) return;
                      },
                    ),
                    SizedBox(width: 10),
                    ISButton(
                      height: 35,
                      //padding: EdgeInsets.fromLTRB(10, 20, 0, 10),
                      textStyle: TextStyle(fontSize: 12, color: Colors.white),
                      label: '직접카드로 결제',
                      onPressed: () {
                        if (detailData == null) return;
                      },
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
