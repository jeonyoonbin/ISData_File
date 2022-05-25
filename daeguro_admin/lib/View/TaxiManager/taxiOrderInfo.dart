import 'dart:convert';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
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
import 'package:daeguro_admin_app/constants/serverInfo.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:kopo/kopo.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class TaxiOrderInfo extends StatefulWidget {
  final Stream<ShopDetailNotifierData> stream;
  final List<SelectOptionVO> selectBox_operator;
  final List<SelectOptionVO> selectBox_salesman;
  final List<SelectOptionVO> selectBox_ccCode;
  final List<SelectOptionVO> selectBox_brandType;
  final Function callback;
  final double height;

  //final ShopBasicInfo sData;

  const TaxiOrderInfo(
      {Key key, this.stream, this.callback, this.selectBox_operator, this.selectBox_salesman, this.selectBox_ccCode, this.selectBox_brandType, this.height})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TaxiOrderInfoState();
  }
}

enum RadioGbn { gbn1, gbn2 }

class TaxiOrderInfoState extends State<TaxiOrderInfo> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ShopBasicInfoModel formData = ShopBasicInfoModel();

  RadioGbn _radioGbn;

  String _orderStatus;
  String _status;

  List<SelectOptionVO> selectBox_orderStatus = [
    new SelectOptionVO(value: '00', label: '문의'),
    new SelectOptionVO(value: '10', label: '대기'),
    new SelectOptionVO(value: '20', label: '호출'),
    new SelectOptionVO(value: '30', label: '배차'),
    new SelectOptionVO(value: '40', label: '운행'),
    new SelectOptionVO(value: '50', label: '완료'),
    new SelectOptionVO(value: '60', label: '배차취소'),
    new SelectOptionVO(value: '70', label: '호출취소'),
    new SelectOptionVO(value: '80', label: '호출실패')
  ];

  List<SelectOptionVO> selectBox_status = [
    new SelectOptionVO(value: '10', label: '대기'),
    new SelectOptionVO(value: '20', label: '휴식'),
    new SelectOptionVO(value: '30', label: '배차지시'),
    new SelectOptionVO(value: '37', label: '승차 전 결제 시도'),
    new SelectOptionVO(value: '38', label: '승차 전 결제 성공'),
    new SelectOptionVO(value: '39', label: '승차 전 결제 실패'),
    new SelectOptionVO(value: '40', label: '운행'),
    new SelectOptionVO(value: '50', label: '상차예정'),
    new SelectOptionVO(value: '52', label: '상차대기'),
    new SelectOptionVO(value: '55', label: '상차완료'),
    new SelectOptionVO(value: '77', label: '하차 전 결제 시도'),
    new SelectOptionVO(value: '78', label: '하차 전 결제 성공'),
    new SelectOptionVO(value: '79', label: '하차 전 결제 실패'),
    new SelectOptionVO(value: '80', label: '하차예정'),
    new SelectOptionVO(value: '82', label: '하차대기'),
    new SelectOptionVO(value: '75', label: '하차완료'),
  ];
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

    _orderStatus = '50';

    _status = '78';


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
    selectBox_orderStatus.clear();

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
                        value: 'test',
                        context: context,
                        label: '그룹 ID',
                        onChange: (v) {
                          formData.shopName = v;
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: ISInput(
                        //autofocus: true,
                        value: '대구로택시 주식회사',
                        context: context,
                        label: '회원사',
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
                        value: '회원1지점',
                        context: context,
                        label: '지점(콜센터) 명',
                        onChange: (v) {
                          formData.shopName = v;
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: ISInput(
                        //autofocus: true,
                        value: '20220218-19',
                        context: context,
                        label: '오더번호 일자-일번',
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
                        value: '일반',
                        context: context,
                        label: '오더구분',
                        onChange: (v) {
                          formData.shopName = v;
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: ISInput(
                        //autofocus: true,
                        value: 'Android',
                        context: context,
                        label: '입력장치',
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
                      child: ISSelect(
                          label: '오더상태',
                          ignoring: true,
                          value: _orderStatus,
                          dataList: selectBox_orderStatus,
                          onChange: (v) {
                            _orderStatus = v;
                          }),
                    ),
                    Flexible(
                      flex: 1,
                      child: Visibility(
                        visible: _orderStatus == '60' || _orderStatus == '70' || _orderStatus == '80' ? false : true,
                        child: ISButton(
                          height: 35,
                          //padding: EdgeInsets.fromLTRB(10, 20, 0, 10),
                          textStyle: TextStyle(fontSize: 12, color: Colors.white),
                          label: '취소',
                          onPressed: () {
                            if (detailData == null) return;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: ISSelect(
                          label: '배차상태',
                          ignoring: true,
                          value: _status,
                          dataList: selectBox_status,
                          onChange: (v) {
                            _status = v;
                          }),
                    ),
                    Flexible(
                      flex: 1,
                      child: Visibility(
                        visible: _status == '78' ? true : false,
                        child: ISButton(
                          height: 35,
                          //padding: EdgeInsets.fromLTRB(10, 20, 0, 10),
                          textStyle: TextStyle(fontSize: 12, color: Colors.white),
                          label: '하차완료',
                          onPressed: () {
                            if (detailData == null) return;
                          },
                        ),
                      ),
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
                        value: '홍*동',
                        context: context,
                        label: '고객명',
                        onChange: (v) {
                          formData.shopName = v;
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: ISInput(
                        //autofocus: true,
                        value: 'testID',
                        context: context,
                        label: '고객ID',
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
                        value: '본인탑승 / 010-****-1234',
                        context: context,
                        label: '본입탑승여부/고객 전화번호',
                        onChange: (v) {
                          formData.shopName = v;
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: ISInput(
                        //autofocus: true,
                        value: '010-1234-5678',
                        context: context,
                        label: '고객 안심 전화번호',
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
                        value: '차량 내부청소에 민감',
                        context: context,
                        label: '비고',
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
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Text('이용기록 표시', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          Radio(
                              value: RadioGbn.gbn1,
                              groupValue: _radioGbn,
                              onChanged: (v) async {
                                _radioGbn = v;

                                await ShopController.to.postSectorGeofenceData(detailData.selected_shopCode, 'N', context);

                                if (isReceiveDataEnabled == true) {
                                  loadData();

                                  setState(() {
                                    //_scrollController.jumpTo(0.0);
                                    isListSaveEnabled = true;
                                  });
                                  //Navigator.pop(context, true);

                                  widget.callback();
                                }
                              }),
                          Text('보임', style: TextStyle(fontSize: 12)),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Radio(
                                value: RadioGbn.gbn2,
                                groupValue: _radioGbn,
                                onChanged: (v) async {
                                  _radioGbn = v;

                                  await ShopController.to.postSectorGeofenceData(detailData.selected_shopCode, 'Y', context);

                                  if (isReceiveDataEnabled == true) {
                                    loadData();

                                    setState(() {
                                      //_scrollController.jumpTo(0.0);
                                      isListSaveEnabled = true;
                                    });
                                    //Navigator.pop(context, true);

                                    widget.callback();
                                  }
                                }),
                          ),
                          Text('숨김', style: TextStyle(fontSize: 12)),
                        ],
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
                        value: '2022-02-18 21:58:59',
                        context: context,
                        label: '등록일시',
                        onChange: (v) {
                          formData.shopName = v;
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: ISInput(
                        //autofocus: true,
                        value: 'admin/시스템관리자',
                        context: context,
                        label: '등록자',
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
                        value: '2022-02-23 20:15:54',
                        context: context,
                        label: '수정일시',
                        onChange: (v) {
                          formData.shopName = v;
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: ISInput(
                        //autofocus: true,
                        value: 'test/테스트',
                        context: context,
                        label: '수정자',
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
