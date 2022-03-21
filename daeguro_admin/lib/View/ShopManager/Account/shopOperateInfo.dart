import 'dart:convert';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/Model/shop/shop_delitip.dart';
import 'package:daeguro_admin_app/Model/shop/shop_saleDaytime.dart';
import 'package:daeguro_admin_app/Model/shop/shop_saletime.dart';
import 'package:daeguro_admin_app/Model/shop/shopposupdate.dart';
import 'package:daeguro_admin_app/Provider/RestApiProvider.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/View/CodeManager/code_controller.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopDetailNotifierData.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/Util/multi_masked_formatter.dart';
import 'package:daeguro_admin_app/Util/utils.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ShopOperateInfo extends StatefulWidget {
  final Stream<ShopDetailNotifierData> stream;
  final Function callback;
  final double height;
  final String ccCode;
  final List<SelectOptionVO> selectBox_itemCd;
  final List<SelectOptionVO> selectBox_subitemCd;

  //final List<SelectOptionVO> selectBox_brandType;

  const ShopOperateInfo({Key key, this.stream, this.callback, this.height, this.ccCode, this.selectBox_itemCd, this.selectBox_subitemCd}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShopOperateInfoState();
  }
}

class ShopOperateInfoState extends State<ShopOperateInfo> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TabController _nestedTabController;

  ShopPosUpdateModel shopPosUpdate = ShopPosUpdateModel();
  List<ShopSaleDayTimeModel> dataSaleDayTimeList = <ShopSaleDayTimeModel>[];
  ShopDetailNotifierData detailData;



  ShopSaleTimeModel formSaleTimeData = ShopSaleTimeModel();
  ShopSaleTimeModel editData = ShopSaleTimeModel();

  bool chkappOrderYn = false;
  bool isInfoSaveEnabled = false;
  //bool isReserveSaveEnabled = false;
  bool isListSaveEnabled = false;
  bool chkTimeGbn = false;

  String _introduce = '';

  String _theme1 = '0';
  String _theme2 = '0';
  String _theme3 = '0';
  String _theme4 = '0';

  String _conv1 = 'N';
  String _conv2 = 'N';
  String _conv3 = 'N';
  String _conv4 = 'N';
  String _conv5 = 'N';
  String _conv6 = 'N';
  String _conv7 = 'N';
  String _conv8 = 'N';
  String _conv9 = 'N';
  String _conv10 = 'N';

  String _itemCd = '';
  String _itemCd1 = '';
  String _tema_1_itemCd = '';

  String _reveiwUseGbn = 'N';

  ScrollController _scrollController;

  bool isReceiveDataEnabled = false;

  void refreshWidget(ShopDetailNotifierData element) {
    detailData = element;
    if (detailData != null) {
      //loadFoodSafetyData();
      //loadReserCategoryData();
      loadReserShopInfo();
      loadSaleDayTimeData();

      isReceiveDataEnabled = true;

      setState(() {
        //_nestedTabController.index = 0;
        _scrollController.jumpTo(0.0);
      });
    } else {
      //print('shopOperate refreshWidget() is NULL');

      formSaleTimeData = null;
      formSaleTimeData = ShopSaleTimeModel();

      shopPosUpdate = null;
      shopPosUpdate = ShopPosUpdateModel();

      dataSaleDayTimeList = null;
      dataSaleDayTimeList = <ShopSaleDayTimeModel>[];

      chkappOrderYn = false;
      isReceiveDataEnabled = false;

      setState(() {
        //_nestedTabController.index = 0;
        _scrollController.jumpTo(0.0);
      });
    }
  }

  // loadFoodSafetyData() async {
  //   if (detailData != null && detailData.selected_franchiseCd != ''){
  //     await CodeController.to.getFoodSafetyData(detailData.selected_franchiseCd).then((value) {
  //       if (value != null){
  //         _FoodSafetyData = value['NUTRITION'];
  //         _AllergyData = value['ALLERGY'];
  //       }
  //     });
  //   }
  // }

  loadReserShopInfo() async {
    _introduce = '';

    _theme1 = '0';
    _theme2 = '0';
    _theme3 = '0';
    _theme4 = '0';

    _conv1 = 'N';
    _conv2 = 'N';
    _conv3 = 'N';
    _conv4 = 'N';
    _conv5 = 'N';
    _conv6 = 'N';
    _conv7 = 'N';
    _conv8 = 'N';
    _conv9 = 'N';
    _conv10 = 'N';

    _reveiwUseGbn = 'N';

    _itemCd = '';
    _itemCd1 = '';
    _tema_1_itemCd = '';

    await ShopController.to.getReserShopInfo(detailData.selected_shopCode.toString()).then((value) {
      if (value == null) {
        ISAlert(context, '예약정보가 정상조회 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else if (value.toString() == '[]') {
        return;
      } else {
        if (value != null) {
          _introduce = value[0]['introduce'].toString();
          _theme1 = value[0]['tema_1'].toString();
          _theme2 = value[0]['tema_2'].toString();
          _theme3 = value[0]['tema_3'].toString();
          _theme4 = value[0]['tema_4'].toString();

          _conv1 = value[0]['facilities_1'].toString();
          _conv2 = value[0]['facilities_2'].toString();
          _conv3 = value[0]['facilities_3'].toString();
          _conv4 = value[0]['facilities_4'].toString();
          _conv5 = value[0]['facilities_5'].toString();
          _conv6 = value[0]['facilities_6'].toString();
          _conv7 = value[0]['facilities_7'].toString();
          _conv8 = value[0]['facilities_8'].toString();
          _conv9 = value[0]['facilities_9'].toString();
          _conv10 = value[0]['facilities_10'].toString();

          _reveiwUseGbn = value[0]['reveiwUseGbn'].toString();

          _itemCd = value[0]['itemCd'].toString();
          _itemCd1 = value[0]['itemCd1'].toString();
          _tema_1_itemCd = value[0]['tema_1_itemCd'].toString();

          if (_tema_1_itemCd == null || _tema_1_itemCd == 'null')
            _tema_1_itemCd = '';
          print('_tema_1_itemCd:${_tema_1_itemCd}');

        }
      }
    });

    setState(() {});
  }

  loadSaleDayTimeData() async {
    await ShopController.to.getSaleTimeData(detailData.selected_shopCode.toString()).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        if (value != null) {
          editData = ShopSaleTimeModel.fromJson(value);

          if (editData != null) {
            if (editData.appOrderYn == 'Y') {
              chkappOrderYn = true;
            } else {
              chkappOrderYn = false;
            }
            formSaleTimeData = editData;
          } else {
            formSaleTimeData = ShopSaleTimeModel();
            formSaleTimeData.useGbn = 'Y';
          }
        }
      }
    });

    dataSaleDayTimeList.clear();

    dataSaleDayTimeList.add(new ShopSaleDayTimeModel(tipdayName: '일요일', tipDay: '1'));
    dataSaleDayTimeList.add(new ShopSaleDayTimeModel(tipdayName: '월요일', tipDay: '2'));
    dataSaleDayTimeList.add(new ShopSaleDayTimeModel(tipdayName: '화요일', tipDay: '3'));
    dataSaleDayTimeList.add(new ShopSaleDayTimeModel(tipdayName: '수요일', tipDay: '4'));
    dataSaleDayTimeList.add(new ShopSaleDayTimeModel(tipdayName: '목요일', tipDay: '5'));
    dataSaleDayTimeList.add(new ShopSaleDayTimeModel(tipdayName: '금요일', tipDay: '6'));
    dataSaleDayTimeList.add(new ShopSaleDayTimeModel(tipdayName: '토요일', tipDay: '7'));

    await ShopController.to.getSaleDayTimeData(detailData.selected_shopCode, '100').then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        value.forEach((element) {
          ShopDeliTipModel tempData = ShopDeliTipModel.fromJson(element);
          setSaleDayTimeData(tempData);
        });
      }
    });

    setState(() {});
  }

  void setSaleDayTimeData(ShopDeliTipModel data) {
    dataSaleDayTimeList.forEach((element) {
      if (element.tipDay == data.tipDay) {
        element.tipFrStand = data.tipFromStand;
        element.tipToStand = data.tipToStand;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nestedTabController.dispose();

    dataSaleDayTimeList.clear();
    super.dispose();
  }

  // loadReserCategoryData() async {
  //   selectBox_reserve_itemCd.clear();
  //   selectBox_reserve_itemCd1.clear();
  //
  //   await ShopController.to.getReserItems().then((value) {
  //     if (value == null) {
  //       ISAlert(context, '업소 조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
  //     } else {
  //       selectBox_reserve_itemCd.add(new SelectOptionVO(value: '', label: '--', label2: ''));
  //       selectBox_reserve_itemCd1.add(new SelectOptionVO(value: '', label: '--', label2: ''));
  //
  //       // 영업사원 바인딩
  //       value.forEach((element) {
  //         ReserItemModel tempData = ReserItemModel.fromJson(element);
  //
  //         selectBox_reserve_itemCd.add(new SelectOptionVO(value: tempData.itemCd, label: '[' + tempData.itemCd + '] ' + tempData.itemName, label2: tempData.itemName));
  //         selectBox_reserve_itemCd1.add(new SelectOptionVO(value: tempData.itemCd, label: '[' + tempData.itemCd + '] ' + tempData.itemName, label2: tempData.itemName));
  //       });
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();

    //selectBox_reserve_itemCd.clear();
    //selectBox_reserve_itemCd1.clear();

    Get.put(CodeController());

    _scrollController = ScrollController();
    _nestedTabController = new TabController(length: 2, vsync: this);

    // WidgetsBinding.instance.addPostFrameCallback((c) {
    //   loadSaleDayTimeData();
    // });

    //if (widget.streamIsInit == false){
      widget.stream.listen((element) {
        refreshWidget(element);
        //loadReserShopInfo();
      });
    //}
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
          // getOperateInfoTabView(),
          // Divider(
          //   height: 40,
          // ),
          // getWeeklyTimeTableTabView(),
        ],
      ),
    );

    return Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
              child: Container(
                height: 30.0,
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200, width: 2.0), borderRadius: BorderRadius.circular(5), color: Colors.grey.shade200,),
                child: TabBar(
                  controller: _nestedTabController,
                  unselectedLabelColor: Colors.black45,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: TextStyle(fontSize: 12, fontFamily: 'NotoSansKR'),
                  indicator: BubbleTabIndicator(
                    indicatorRadius: 5.0,
                    indicatorHeight: 25.0,
                    indicatorColor: Colors.blue,
                    tabBarIndicatorSize: TabBarIndicatorSize.tab,
                  ),
                  tabs: [
                    Tab(text: '운영정보',),
                    //Tab(text: '예약서비스',),
                    Tab(text: '요일별 영업시간',)
                  ],
                ),
              ),
            ),
            //_nestedTabController.index == 0 ? buttonBar() : Container(height: 32,),
            Container(
              width: double.infinity,
              height: widget.height,
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _nestedTabController,
                children: [
                  Container(
                    //padding: EdgeInsets.all(8.0),
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: getOperateInfoTabView()
                  ),
                  // Container(
                  //   //padding: EdgeInsets.all(8.0),
                  //     padding: EdgeInsets.symmetric(horizontal: 16.0),
                  //     child: getReserveInfoTabView()
                  // ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: getWeeklyTimeTableTabView()
                  ),
                ],
              ),
            )
          ]),
    );

    // return Scrollbar(
    //   isAlwaysShown: false,
    //   controller: _scrollController,
    //   child: ListView(
    //     controller: _scrollController,
    //     children: <Widget>[
    //     ],
    //   ),
    // );
  }

  Widget getOperateInfoTabView(){
    return Scrollbar(
        isAlwaysShown: false,
        controller: _scrollController,
        child: ListView(
          controller: _scrollController,
          children: <Widget>[
            Form(
              key: formKey,
              child: Wrap(
                children: <Widget>[
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            //padding: const EdgeInsets.only(left: 10),
                            child: Text(' ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                          ),
                          if (AuthUtil.isAuthEditEnabled('100') == true)
                          Row(
                            children: [
                              AnimatedOpacity(
                                opacity: isInfoSaveEnabled ? 1.0 : 0.0,
                                duration: Duration(milliseconds: 700),
                                child: Row(
                                  children: [
                                    Icon(Icons.info_outline, color: Colors.red, size: 18,),
                                    Text('저장 완료', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                                  ],
                                ),
                                onEnd: (){
                                  setState(() {
                                    isInfoSaveEnabled = false;
                                  });
                                },
                              ),
                              SizedBox(width: 10,),
                              ISButton(
                                iconData: Icons.refresh,
                                iconColor: Colors.white,
                                tip: '갱신',
                                onPressed: (){
                                  if (isReceiveDataEnabled == true){
                                    //loadFoodSafetyData();
                                    loadReserShopInfo();
                                    loadSaleDayTimeData();

                                    setState(() {
                                      _nestedTabController.index = 0;
                                      _scrollController.jumpTo(0.0);
                                    });
                                  }
                                },
                              ),
                              SizedBox(width: 10,),
                              ISButton(
                                label: '저장',
                                iconData: Icons.save,
                                iconColor: Colors.white,
                                textStyle: TextStyle(color: Colors.white),
                                onPressed: () async {
                                  FormState form = formKey.currentState;
                                  if (!form.validate()) {
                                    return;
                                  }

                                  form.save();

                                  ShopDeliTipModel sendData = ShopDeliTipModel();
                                  sendData.shopCd = detailData.selected_shopCode;
                                  sendData.tipFromStand = formSaleTimeData.saleFromTime;
                                  sendData.tipToStand = formSaleTimeData.saleToTime;
                                  sendData.useGbn = formSaleTimeData.useGbn;
                                  sendData.happyPayUseGbn = formSaleTimeData.happyPayUseGbn;
                                  sendData.closedLogin = formSaleTimeData.closedLogin;
                                  sendData.supportFund = formSaleTimeData.supportFund;
                                  sendData.reserveYn = formSaleTimeData.reserveYn;

                                  if (chkappOrderYn == true) {
                                    sendData.appOrderyn = 'Y';
                                  } else {
                                    sendData.appOrderyn = 'N';
                                  }

                                  sendData.tipGbn = '100';
                                  sendData.modUCode = GetStorage().read('logininfo')['uCode'];
                                  sendData.modName = GetStorage().read('logininfo')['name'];

                                  //print('formData--> '+sendData.toJson().toString());

                                  ShopController.to.postSaleTimeData(sendData.toJson()).then((value) async {
                                    if (value != null){
                                      ISAlert(context, '[운영정보] 정상적으로 저장되지 않았습니다. \n\n${value}');
                                      return;
                                    }
                                    else{
                                      var bodyData = {
                                        '"shopCd"': '"${detailData.selected_shopCode}"',
                                        '"ccCode"': '"${widget.ccCode}"',
                                        '"itemCd"': '"$_itemCd"',
                                        '"introduce"': '"$_introduce"',
                                        '"itemCd1"': '"$_itemCd1"',
                                        '"reveiwUseGbn"': '"$_reveiwUseGbn"',
                                        '"tema_1"': '"$_theme1"',
                                        '"tema_2"': '"$_theme2"',
                                        '"tema_3"': '"$_theme3"',
                                        '"tema_4"': '"$_theme4"',
                                        '"facilities_1"': '"$_conv1"',
                                        '"facilities_2"': '"$_conv2"',
                                        '"facilities_3"': '"$_conv3"',
                                        '"facilities_4"': '"$_conv4"',
                                        '"facilities_5"': '"$_conv5"',
                                        '"facilities_6"': '"$_conv6"',
                                        '"facilities_7"': '"$_conv7"',
                                        '"facilities_8"': '"$_conv8"',
                                        '"facilities_9"': '"$_conv9"',
                                        '"facilities_10"': '"$_conv10"',
                                        '"tema_1_itemCd"': '"$_tema_1_itemCd"',
                                        '"userId"': '"${GetStorage().read('logininfo')['uCode']}"',
                                      };

                                      await ShopController.to.setReserveShopInfoadmin(bodyData).then((value) async {
                                        if (value != null){
                                          ISAlert(context, '[예약설정] 정상적으로 저장되지 않았습니다. \n\n${value}');
                                          return;
                                        }
                                        else{
                                          shopPosUpdate.job_gbn = 'STOREUSE_UPDATE';
                                          shopPosUpdate.shop_token = detailData.selected_apiComCode;
                                          shopPosUpdate.use_gbn = sendData.useGbn;
                                          shopPosUpdate.mod_ucode = GetStorage().read('logininfo')['uCode'];

                                          var headerData = {
                                            "Access-Control-Allow-Origin": "*",
                                            // Required for CORS support to work
                                            "Access-Control-Allow-Headers": "*",
                                            "Access-Control-Allow-Credentials": "true",
                                            "Access-Control-Allow-Methods": "*",
                                            "Content-Type": "application/json",
                                            "Authorization":
                                            "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6Im9yZGVyX2NvbXAiLCJhcHBfdHlwZSI6Im9yZGVyIiwiYXBwX25hbWUiOiJkYWd1cm9hcHAiLCJuYmYiOjE2NDExODcwMDAsImV4cCI6MTY3NTIwNjAwMCwiaWF0IjoxNjQxMTg3MDAwLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDoxNTQwOSIsImF1ZCI6Ikluc3VuZ1BPUyJ9.hVaYELqN7i9IQ3o00LRcF--sCv6up7slUq1i94WDw78",
                                            //"Accept": "application/json",
                                          };

                                          String posAppOrderYn = '1';
                                          String posReserveYn = '1';

                                          if (chkappOrderYn == true) {
                                            posAppOrderYn = '1';
                                          } else {
                                            posAppOrderYn = '0';
                                          }

                                          if (formSaleTimeData.reserveYn == 'Y') {
                                            posReserveYn = '1';
                                            if (formSaleTimeData.shopType == '7' || formSaleTimeData.shopType == '5' || formSaleTimeData.shopType == '5,7' || formSaleTimeData.shopType == '7,5') {
                                              posReserveYn = '1';
                                            }
                                            else
                                              posReserveYn = '0';
                                          }
                                          else {
                                            posReserveYn = '0';
                                          }

                                          var bodyPosData = {'"app_name"': '"대구로 어드민"', '"app_type"': '"admin-daeguroApp"',
                                            '"shop_info"': '{"job_gbn" :"STOREUSE_UPDATE", "use_gbn" : "' + sendData.useGbn +
                                                '", "shop_token" : "' + detailData.selected_apiComCode +
                                                '", "is_fooddelivery" : "' + posAppOrderYn +
                                                '", "is_reserve" : "' + posReserveYn +
                                                '", "mod_ucode" : "' + GetStorage().read('logininfo')['uCode'] + '"}'
                                          };

                                          await RestApiProvider.to.postRestError('0', '/admin/shopOperate : postSaleTimeData', '[POS 가맹점 정보 저장] ' + bodyPosData.toString() + '|| ucode : ' + GetStorage().read('logininfo')['uCode'].toString() + ', name : ' + GetStorage().read('logininfo')['name'].toString());

                                          await http.post(Uri.parse('https://pos.daeguro.co.kr:15412/posApi/POSData/DaeguroApp_Process'), headers: headerData, body: bodyPosData.toString()).then((http.Response response) {
                                            if (response.statusCode == 200) {
                                              var decodeBody = jsonDecode(response.body);
                                              //print('pos [200]:${decodeBody.toString()}');
                                            } else {
                                              var decodeBody = jsonDecode(response.body);
                                              //print('pos [other]:${decodeBody.toString()}');

                                              ISAlert(context, '[POS설정] 정상적으로 저장되지 않았습니다. \n\n${decodeBody.toString()}');
                                            }
                                          });

                                          setState(() {
                                            isInfoSaveEnabled = true;
                                          });


                                          widget.callback();
                                        }
                                      });
                                    }
                                  });

                                  //ISAlert(context, '운영 상태가 정상 업데이트되었습니다.');
                                },
                              )
                            ],
                          )
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            children: [
                              Text('POS약관 동의', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Container(
                        //padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: [
                                Container(
                                  width: 150,
                                  height: 40,
                                  decoration: new BoxDecoration(
                                      color: formSaleTimeData.confirmYn == 'Y' ? Colors.blue[200] : Colors.red[200],
                                      borderRadius: new BorderRadius.only(topRight: Radius.circular(15.0), bottomRight: Radius.circular(15.0), topLeft: Radius.circular(15.0), bottomLeft: Radius.circular(15.0))),
                                  child: SwitchListTile(
                                    dense: true,
                                    value: formSaleTimeData.confirmYn == 'Y' ? true : false,
                                    title: Text('동의 여부', style: TextStyle(fontSize: 12, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10),
                            Row(
                              children: [
                                Icon(Icons.timer_outlined, color: Colors.blue, size: 18,),
                                SizedBox(width: 5),
                                Container(
                                  width: 240,
                                  child: Text(
                                    formSaleTimeData.confirmDate == null ? '동의일시 : --' : '동의일시 : '  + formSaleTimeData.confirmDate.toString(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            children: [
                              Text('운영 상태', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                //width: 150,
                                height: 40,
                                // decoration: new BoxDecoration(
                                //     color: formSaleTimeData.useGbn == 'Y' ? Colors.blue[200] : Colors.red[200], borderRadius: new BorderRadius.circular(0)),
                                decoration: new BoxDecoration(
                                    color: formSaleTimeData.useGbn == 'Y' ? Colors.blue[200] : Colors.red[200],
                                    borderRadius: new BorderRadius.only(topLeft: Radius.circular(15.0), bottomLeft: Radius.circular(15.0))),
                                child: SwitchListTile(
                                  dense: true,
                                  value: formSaleTimeData.useGbn == 'Y' ? true : false,
                                  title: Text('사용여부', style: TextStyle(fontSize: 12, color: Colors.white),
                                  ),
                                  onChanged: (v) {
                                    setState(() {
                                      formSaleTimeData.useGbn = v ? 'Y' : 'N';
                                      formKey.currentState.save();
                                    });
                                  },
                                ),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                //width: 150,
                                height: 40,
                                decoration: new BoxDecoration(
                                    color: formSaleTimeData.closedLogin == 'Y' ? Colors.blue[200] : Colors.red[200],
                                    borderRadius: new BorderRadius.only(topRight: Radius.circular(15.0), bottomRight: Radius.circular(15.0))),
                                child: SwitchListTile(
                                  dense: true,
                                  value: formSaleTimeData.closedLogin == 'Y' ? true : false,
                                  title: Text('해지후 로그인 가능', style: TextStyle(fontSize: 12, color: Colors.white),
                                  ),
                                  onChanged: (v) {
                                    setState(() {
                                      formSaleTimeData.closedLogin = v ? 'Y' : 'N';
                                      formKey.currentState.save();
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                //width: 150,
                                height: 40,
                                decoration: new BoxDecoration(
                                    color: formSaleTimeData.happyPayUseGbn == 'Y' ? Colors.blue[200] : Colors.red[200],
                                    borderRadius: new BorderRadius.only(topLeft: Radius.circular(15.0), bottomLeft: Radius.circular(15.0))),

                                child: SwitchListTile(
                                  dense: true,
                                  value: formSaleTimeData.happyPayUseGbn == 'Y' ? true : false,
                                  title: Text('행복페이', style: TextStyle(fontSize: 12, color: Colors.white),
                                  ),
                                  onChanged: (v) {
                                    setState(() {
                                      formSaleTimeData.happyPayUseGbn = v ? 'Y' : 'N';
                                      formKey.currentState.save();
                                    });
                                  },
                                ),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                //width: 150,
                                height: 40,
                                decoration: new BoxDecoration(
                                    color: formSaleTimeData.supportFund == 'Y' ? Colors.blue[200] : Colors.red[200],
                                    borderRadius: new BorderRadius.only(topRight: Radius.circular(15.0), bottomRight: Radius.circular(15.0))),
                                child: SwitchListTile(
                                  dense: true,
                                  value: formSaleTimeData.supportFund == 'Y' ? true : false,
                                  title: Text('입점지원금 출금', style: TextStyle(fontSize: 12, color: Colors.white),
                                  ),
                                  onChanged: (v) {
                                    setState(() {
                                      formSaleTimeData.supportFund = v ? 'Y' : 'N';
                                      formKey.currentState.save();
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            children: [
                              Text('앱노출 설정', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                //width: 150,
                                height: 40,
                                decoration: new BoxDecoration(
                                    color: chkappOrderYn == true ? Colors.blue[200] : Colors.red[200],
                                    borderRadius: new BorderRadius.only(topLeft: Radius.circular(15.0), bottomLeft: Radius.circular(15.0))),
                                child: SwitchListTile(
                                  dense: true,
                                  value: chkappOrderYn,
                                  title: Text('주문 노출(앱승인)', style: TextStyle(fontSize: 12, color: Colors.white),
                                  ),
                                  onChanged: (v) {
                                    setState(() {
                                      chkappOrderYn = v;
                                      formKey.currentState.save();
                                    });
                                  },
                                ),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                height: 40,
                                decoration: new BoxDecoration(
                                    color: formSaleTimeData.reserveYn == 'Y' ? Colors.blue[200] : Colors.red[200],
                                    borderRadius: new BorderRadius.only(topRight: Radius.circular(15.0), bottomRight: Radius.circular(15.0))),
                                child: SwitchListTile(
                                  dense: true,
                                  value: formSaleTimeData.reserveYn == 'Y' ? true : false,
                                  title: Text('예약 노출', style: TextStyle(fontSize: 12, color: Colors.white),),
                                  onChanged: (v) {

                                    formSaleTimeData.reserveYn = (v == true ? 'Y' : 'N');

                                    //print('formSaleTimeData.reserveYn:${formSaleTimeData.reserveYn}');
                                    //formKey.currentState.save();

                                    setState(() {});
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider(),
                      formSaleTimeData.reserveYn == 'Y' ? Container(
                        child: Column(
                          children: [
                            Container(
                              child: Text('- [예약] 한줄소개', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              alignment: Alignment.centerLeft,
                            ),
                            ISInput(
                              value: _introduce ?? '',
                              context: context,
                              label: '소개내용',
                              //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                              //123prefixIcon: Icon(Icons.home, color: Colors.grey),
                              textStyle: TextStyle(fontSize: 12),
                              onChange: (v) {
                                _introduce = v;
                              },
                              // validator: (v) {
                              //   return v.isEmpty ? '[필수] 상세주소': null;
                              // },
                            ),
                            Container(
                              child: Text('- [예약] 업종 카테고리', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              alignment: Alignment.centerLeft,
                            ),
                            Row(
                              children: [
                                Flexible(
                                    flex: 1,
                                    child: ISSelect(
                                      label: '업종1',
                                      value: _itemCd,
                                      dataList: widget.selectBox_itemCd,
                                      onChange: (v) {
                                        setState(() {
                                          _itemCd = v;
                                        });
                                      },
                                      onSaved: (v) {
                                        //formData.cLevel = v;
                                      },
                                    )
                                ),
                                Flexible(
                                    flex: 1,
                                    child: ISSelect(
                                      label: '업종2',
                                      value: _itemCd1,
                                      dataList: widget.selectBox_itemCd,
                                      onChange: (v) {
                                        setState(() {
                                          _itemCd1 = v;
                                        });
                                      },
                                      onSaved: (v) {
                                        //formData.cLevel = v;
                                      },
                                    )
                                )
                              ],
                            ),
                            Divider(),
                            Container(
                              child: Text('- [예약] 리뷰', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              alignment: Alignment.centerLeft,
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Flexible(
                                  child: Container(
                                    height: 40,
                                    decoration: new BoxDecoration(
                                        color: _reveiwUseGbn == 'Y' ? Colors.blue[200] : Colors.red[200],
                                        borderRadius: new BorderRadius.only(topRight: Radius.circular(15.0), bottomRight: Radius.circular(15.0), topLeft: Radius.circular(15.0), bottomLeft: Radius.circular(15.0))),
                                    child: SwitchListTile(
                                      dense: true,
                                      value: _reveiwUseGbn == 'Y' ? true : false,
                                      title: Text('리뷰 사용', style: TextStyle(fontSize: 12, color: Colors.white),),
                                      onChanged: (v) {
                                        setState(() {
                                          _reveiwUseGbn = v ? 'Y' : 'N';
                                        });
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Divider(),
                            Container(
                              child: Text('- [예약] 테마', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              alignment: Alignment.centerLeft,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SwitchListTile(
                                    dense: true,
                                    value: _theme1 == '1' ? true : false,
                                    title: Text('특화거리 다 대구로', style: TextStyle(fontSize: 12),),
                                    onChanged: (v) {
                                      setState(() {
                                        _theme1 = v ? '1' : '0';
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: SwitchListTile(
                                    dense: true,
                                    value: _theme2 == '1' ? true : false,
                                    title: Text('손닙접대 하기 좋은 곳', style: TextStyle(fontSize: 12),),
                                    onChanged: (v) {
                                      setState(() {
                                        _theme2 = v ? '1' : '0';
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SwitchListTile(
                                    dense: true,
                                    value: _theme3 == '1' ? true : false,
                                    title: Text('가족 모임 하기 좋은 곳', style: TextStyle(fontSize: 12),),
                                    onChanged: (v) {
                                      setState(() {
                                        _theme3 = v ? '1' : '0';
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: SwitchListTile(
                                    dense: true,
                                    value: _theme4 == '1' ? true : false,
                                    title: Text('대구 맛집 일보 다 대구로', style: TextStyle(fontSize: 12),),
                                    onChanged: (v) {
                                      setState(() {
                                        _theme4 = v ? '1' : '0';
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            (widget.selectBox_subitemCd.length != 0 && _theme1 == '1') ? ISSelect(
                              label: '특화거리 카테고리 설정',
                              value: _tema_1_itemCd,
                              dataList: widget.selectBox_subitemCd,
                              onChange: (v) {
                                setState(() {
                                  _tema_1_itemCd = v;
                                });
                              },
                              onSaved: (v) {
                                //formData.cLevel = v;
                              },
                            ) : Container(),
                            Divider(),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Text('- [예약] 편의 시설', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Image.asset('assets/Convenience_1.png'),
                                        Text('주차가능', style: TextStyle(fontSize: 12)),
                                        Checkbox(value: _conv1 == 'Y' ? true : false,
                                          onChanged: (v) {
                                            setState(() {
                                              _conv1 = v ? 'Y' : 'N';
                                            });
                                          },
                                        ),
                                      ],
                                    )
                                ),
                                Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Image.asset('assets/Convenience_2.png'),
                                        Text('발렛가능', style: TextStyle(fontSize: 12)),
                                        Checkbox(value: _conv2 == 'Y' ? true : false,
                                          onChanged: (v) {
                                            setState(() {
                                              _conv2 = v ? 'Y' : 'N';
                                            });
                                          },
                                        ),
                                      ],
                                    )
                                ),
                                Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Image.asset('assets/Convenience_3.png'),
                                        Text('단체석', style: TextStyle(fontSize: 12)),
                                        Checkbox(value: _conv3 == 'Y' ? true : false,
                                          onChanged: (v) {
                                            setState(() {
                                              _conv3 = v ? 'Y' : 'N';
                                            });
                                          },
                                        ),
                                      ],
                                    )
                                ),
                                Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Image.asset('assets/Convenience_4.png'),
                                        Text('프라이빗룸', style: TextStyle(fontSize: 12)),
                                        Checkbox(value: _conv4 == 'Y' ? true : false,
                                          onChanged: (v) {
                                            setState(() {
                                              _conv4 = v ? 'Y' : 'N';
                                            });
                                          },
                                        ),
                                      ],
                                    )
                                ),
                                Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Image.asset('assets/Convenience_5.png'),
                                        Text('테라스', style: TextStyle(fontSize: 12)),
                                        Checkbox(value: _conv5 == 'Y' ? true : false,
                                          onChanged: (v) {
                                            setState(() {
                                              _conv5 = v ? 'Y' : 'N';
                                            });
                                          },
                                        ),
                                      ],
                                    )
                                )
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Image.asset('assets/Convenience_6.png'),
                                        Text('콜키지', style: TextStyle(fontSize: 12)),
                                        Checkbox(value: _conv6 == 'Y' ? true : false,
                                          onChanged: (v) {
                                            setState(() {
                                              _conv6 = v ? 'Y' : 'N';
                                            });
                                          },
                                        ),
                                      ],
                                    )
                                ),
                                Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Image.asset('assets/Convenience_7.png'),
                                        Text('아기의자', style: TextStyle(fontSize: 12)),
                                        Checkbox(value: _conv7 == 'Y' ? true : false,
                                          onChanged: (v) {
                                            setState(() {
                                              _conv7 = v ? 'Y' : 'N';
                                            });
                                          },
                                        ),
                                      ],
                                    )
                                ),
                                Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Image.asset('assets/Convenience_8.png'),
                                        Text('놀이방', style: TextStyle(fontSize: 12)),
                                        Checkbox(value: _conv8 == 'Y' ? true : false,
                                          onChanged: (v) {
                                            setState(() {
                                              _conv8 = v ? 'Y' : 'N';
                                            });
                                          },
                                        ),
                                      ],
                                    )
                                ),
                                Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Image.asset('assets/Convenience_9.png'),
                                        Text('노키즈존', style: TextStyle(fontSize: 12)),
                                        Checkbox(value: _conv9 == 'Y' ? true : false,
                                          onChanged: (v) {
                                            setState(() {
                                              _conv9 = v ? 'Y' : 'N';
                                            });
                                          },
                                        ),
                                      ],
                                    )
                                ),
                                Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Image.asset('assets/Convenience_10.png'),
                                        Text('반려동물', style: TextStyle(fontSize: 12)),
                                        Checkbox(value: _conv10 == 'Y' ? true : false,
                                          onChanged: (v) {
                                            setState(() {
                                              _conv10 = v ? 'Y' : 'N';
                                            });
                                          },
                                        ),
                                      ],
                                    )
                                )
                              ],
                            ),
                            Divider(),
                          ],
                        ),
                      ) : Container(),
                    ],
                  )
                ]),
            ),
          ],
        ),
      );
  }

  // Widget getReserveInfoTabView(){
  //   return Scrollbar(
  //     isAlwaysShown: false,
  //     controller: _scrollController,
  //     child: ListView(
  //       controller: _scrollController,
  //       children: <Widget>[
  //         Wrap(
  //             children: <Widget>[
  //               Column(
  //                 children: [
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: <Widget>[
  //                       Container(
  //                         //padding: const EdgeInsets.only(left: 10),
  //                         child: Text(' '),
  //                       ),
  //                       Row(
  //                         children: [
  //                           AnimatedOpacity(
  //                             opacity: isReserveSaveEnabled ? 1.0 : 0.0,
  //                             duration: Duration(milliseconds: 700),
  //                             child: Row(
  //                               children: [
  //                                 Icon(Icons.info_outline, color: Colors.red, size: 18,),
  //                                 Text('저장 완료', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
  //                               ],
  //                             ),
  //                             onEnd: (){
  //                               setState(() {
  //                                 isReserveSaveEnabled = false;
  //                               });
  //                             },
  //                           ),
  //                           SizedBox(width: 10,),
  //                           ISButton(
  //                             iconData: Icons.refresh,
  //                             iconColor: Colors.white,
  //                             tip: '갱신',
  //                             onPressed: (){
  //                               if (isReceiveDataEnabled == true){
  //                                 //loadFoodSafetyData();
  //                                 loadSaleDayTimeData();
  //
  //                                 setState(() {
  //                                   _nestedTabController.index = 0;
  //                                   _scrollController.jumpTo(0.0);
  //                                 });
  //                               }
  //                             },
  //                           ),
  //                           SizedBox(width: 10,),
  //                           ISButton(
  //                             label: '저장',
  //                             iconData: Icons.save,
  //                             iconColor: Colors.white,
  //                             textStyle: TextStyle(color: Colors.white),
  //                             onPressed: () async {
  //                               print('예약 저장');
  //
  //                               // await ShopController.to.setReserve(detailData.selected_shopCode, formSaleTimeData.reserveYn, context);
  //                               //     setState(() {
  //                               //       isReserveSaveEnabled = true;
  //                               //     });
  //                               //
  //                               //     widget.callback();
  //                             },
  //                           )
  //                         ],
  //                       )
  //                     ],
  //                   ),
  //                   Divider(),
  //                   Container(
  //                       child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           children: <Widget>[
  //                             Flexible(
  //                               child: Container(
  //                                 height: 40,
  //                                 decoration: new BoxDecoration(
  //                                     color: formSaleTimeData.reserveYn == 'Y' ? Colors.blue[200] : Colors.red[200],
  //                                     borderRadius: new BorderRadius.only(topRight: Radius.circular(15.0), bottomRight: Radius.circular(15.0), topLeft: Radius.circular(15.0), bottomLeft: Radius.circular(15.0))),
  //                                 child: SwitchListTile(
  //                                   dense: true,
  //                                   value: formSaleTimeData.reserveYn == 'Y' ? true : false,
  //                                   title: Text('예약서비스 사용', style: TextStyle(fontSize: 12, color: Colors.white),),
  //                                   onChanged: (v) {
  //
  //                                     formSaleTimeData.reserveYn = (v == true ? 'Y' : 'N');
  //
  //                                     print('formSaleTimeData.reserveYn:${formSaleTimeData.reserveYn}');
  //                                     //formKey.currentState.save();
  //
  //                                     setState(() {});
  //                                   },
  //                                 ),
  //                               ),
  //                             )
  //                           ]
  //                       )
  //                   ),
  //                   Divider(),
  //
  //                   SizedBox(height: 10,),
  //                 ],
  //               )
  //             ]),
  //       ],
  //     ),
  //   );
  // }

  Widget getWeeklyTimeTableTabView(){
    return ListView(
      controller: _scrollController,
      children: <Widget>[
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Text(' ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
                if (AuthUtil.isAuthEditEnabled('100') == true)
                Row(
                  children: [
                    AnimatedOpacity(
                      opacity: isListSaveEnabled ? 1.0 : 0.0,
                      duration: Duration(seconds: 1),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.red, size: 18,),
                          Text('저장 완료', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                        ],
                      ),
                      onEnd: (){
                        setState(() {
                          isListSaveEnabled = false;
                        });
                      },
                    ),
                    SizedBox(width: 10,),
                    ISButton(
                        label: '일괄 입력',
                        textStyle: TextStyle(color: Colors.white, fontSize: 13),
                        onPressed: () {
                          setState(() {
                            int idx = 0;
                            String tempFrStand, tempToStand;
                            dataSaleDayTimeList.forEach((element) {
                              if (idx == 0) {
                                if (element.tipFrStand == null || element.tipFrStand == '' || element.tipToStand == null || element.tipToStand == '') {
                                  tempFrStand = '0900';
                                  tempToStand = '2359';
                                } else {
                                  tempFrStand = element.tipFrStand;
                                  tempToStand = element.tipToStand;
                                }
                              }

                              element.tipFrStand = tempFrStand;
                              element.tipToStand = tempToStand;

                              idx++;
                            });
                          });
                        }
                    ),
                    SizedBox(width: 10,),
                    ISButton(
                      label: '저장',
                      iconData: Icons.save,
                      iconColor: Colors.white,
                      textStyle: TextStyle(color: Colors.white),
                      onPressed: () async {
                        List<ShopSaleDayTimeModel> saveListdata = <ShopSaleDayTimeModel>[];

                        chkTimeGbn = false;

                        dataSaleDayTimeList.forEach((element) {
                          if (element.tipFrStand != '') {
                            if (chkTimeGbn == true) return;

                            if (element.tipFrStand.length != 4) {
                              ISAlert(context, '[오픈시간] 잘못된 시간형식 입니다.');
                              chkTimeGbn = true;
                              return;
                            }

                            if (int.parse(element.tipFrStand) > 2359) {
                              ISAlert(context, '오픈 시간은 최대 23:59 입니다.');
                              chkTimeGbn = true;
                              return;
                            }

                            if (int.parse(element.tipFrStand.substring(2, 4)) > 59) {
                              ISAlert(context, '[오픈시간] 잘못된 시간형식 입니다.');
                              chkTimeGbn = true;
                              return;
                            }
                          }

                          if (element.tipToStand != '') {
                            if (element.tipToStand.length != 4) {
                              ISAlert(context, '[마감시간] 잘못된 시간형식 입니다.');
                              chkTimeGbn = true;
                              return;
                            }

                            if (int.parse(element.tipToStand) > 2359) {
                              ISAlert(context, '마감시간은 최대 23:59 입니다.');
                              chkTimeGbn = true;
                              return;
                            }

                            if (int.parse(element.tipToStand.substring(2, 4)) > 59) {
                              ISAlert(context, '[마감시간] 잘못된 시간형식 입니다.');
                              chkTimeGbn = true;
                              return;
                            }
                          }

                          if (element.tipFrStand == null || element.tipFrStand == '' || element.tipToStand == null || element.tipToStand == '') {
                          } else {
                            if (int.parse(element.tipFrStand) >= int.parse(element.tipToStand)) {
                              element.tipNextDay = 'Y';
                            } else {
                              element.tipNextDay = 'N';
                            }

                            saveListdata.add(element);
                          }
                        });

                        if (saveListdata.length == 0) return;

                        String jsonData = jsonEncode(saveListdata);
                        //print('data set->'+jsonData);

                        await ShopController.to.putDayTimeData(detailData.selected_shopCode, jsonData, context);

                        setState(()  {
                          isListSaveEnabled = true;
                        });
                        //ISAlert(context, '요일별 영업시간이 정상 업데이트되었습니다.');

                        widget.callback();
                      },
                    ),
                  ],
                ),
              ],
            ),
            Divider(),
            //SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: [
                    Text('요일별 영업시간', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10,),
            Container(
                height: 360,
                child: ListView(
                  //physics: NeverScrollableScrollPhysics(),
                  //padding: const EdgeInsets.only(left: 16, right: 16),
                  children: <Widget>[
                    DataTable(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black26, offset: Offset(2.0, 2.0), blurRadius: 4.0),
                        ],
                      ),
                      headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blue[50]),
                      headingTextStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', color: Colors.black54, fontSize: 12),
                      headingRowHeight: 30,
                      dataRowHeight: 40,
                      dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white),
                      dataTextStyle: TextStyle(fontWeight: FontWeight.normal, fontFamily: 'NotoSansKR', fontSize: 14),
                      columnSpacing: 0,
                      columns: <DataColumn>[
                        DataColumn(label: Expanded(child: Text('요일', textAlign: TextAlign.center)),),
                        DataColumn(label: Expanded(child: Text('영업시작시간', textAlign: TextAlign.center)),),
                        DataColumn(label: Expanded(child: Text('영업종료시간', textAlign: TextAlign.center)),),
                      ],
                      //source: listDS,
                      rows: dataSaleDayTimeList.map((item) {
                        return DataRow(cells: [
                          DataCell(Center(child: Text(Utils.getDay(item.tipDay) ?? '--', style: TextStyle(color: Colors.black)))),
                          DataCell(Center(
                              child: Container(
                                width: 80,
                                height: 30,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.normal, fontFamily: 'NotoSansKR', fontSize: 14),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    MultiMaskedTextInputFormatter(masks: ['x:xx', 'xx:xx'], separator: ':')
                                  ],
                                  expands: false,
                                  maxLines: 1,
                                  controller: TextEditingController(text: Utils.getTimeFormat(item.tipFrStand) ?? '--'),//Utils.getTimeSet(value)),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: Colors.white, width: 1)),
                                    contentPadding: EdgeInsets.all(5),
                                    counterText: '',
                                  ),
                                  onChanged: (v){
                                    //item.tipFrStand = v;
                                    item.tipFrStand = v.toString().replaceAll(':', '');
                                  },
                                ),
                              )
                          )),
                          DataCell(Center(
                            //child: getTimesetData(item.tipToStand)
                            child: Container(
                              width: 80,
                              height: 30,
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.normal, fontFamily: 'NotoSansKR', fontSize: 14),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  MultiMaskedTextInputFormatter(masks: ['x:xx', 'xx:xx'], separator: ':')
                                ],
                                expands: false,
                                maxLines: 1,
                                controller: TextEditingController(text: Utils.getTimeFormat(item.tipToStand) ?? '--'),//Utils.getTimeSet(value)),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: Colors.white, width: 1)),
                                  contentPadding: EdgeInsets.all(5),
                                  counterText: '',
                                ),
                                onChanged: (v){
                                  //item.tipToStand = v;
                                  item.tipToStand = v.toString().replaceAll(':', '');
                                },
                              ),
                            ),
                          )),
                        ]);
                      }).toList(),
                    ),
                  ],
                )
            ),
          ],
        )
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
