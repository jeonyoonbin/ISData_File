import 'dart:convert';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/Model/shop/shop_history.dart';
import 'package:daeguro_admin_app/Model/shop/shopbasic_info.dart';
import 'package:daeguro_admin_app/Model/shop/shopposupdate.dart';
import 'package:daeguro_admin_app/Provider/RestApiProvider.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/View/AgentManager/agentAccount_Controller.dart';
import 'package:daeguro_admin_app/View/Common/tax_controller.dart';
import 'package:daeguro_admin_app/View/PostCode/postCodeRequest.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopDetailNotifierData.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopMemoHistory.dart';
import 'package:daeguro_admin_app/Util/multi_masked_formatter.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/Util/utils.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:kopo/kopo.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class ShopBasicInfo extends StatefulWidget {
  final Stream<ShopDetailNotifierData> stream;
  final List<SelectOptionVO> selectBox_operator;
  final List<SelectOptionVO> selectBox_salesman;
  final List<SelectOptionVO> selectBox_ccCode;
  final List<SelectOptionVO> selectBox_brandType;
  final Function callback;
  final double height;

  //final ShopBasicInfo sData;

  const ShopBasicInfo({Key key, this.stream, this.callback, this.selectBox_operator, this.selectBox_salesman, this.selectBox_ccCode, this.selectBox_brandType, this.height}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShopBasicInfoState();
  }
}

class ShopBasicInfoState extends State<ShopBasicInfo> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ShopBasicInfoModel formData = ShopBasicInfoModel();
  ShopPosUpdateModel shopPosUpdate = ShopPosUpdateModel();

  //List<SelectOptionVO> selectBox_salesman = [];
  //List<SelectOptionVO> selectBox_operator = [];

  List<SelectOptionVO> selectBox_type = [
    new SelectOptionVO(value: '1', label: '일반'),
    new SelectOptionVO(value: '3', label: '간이'),
    new SelectOptionVO(value: '5', label: '법인'),
    new SelectOptionVO(value: '7', label: '면세')];

  TabController _nestedTabController;

  ScrollController _scrollController;

  List<ShopHistoryModel> dataHistoryList = <ShopHistoryModel>[];

  ShopDetailNotifierData detailData;

  bool isReceiveDataEnabled = false;
  bool isListSaveEnabled = false;

  void refreshWidget(ShopDetailNotifierData element){
    detailData = element;

    if (detailData != null) {
      //print('shopBasic refreshWidget() is not NULL -> [${element.selected_shopCode}]');

      loadData();

      isReceiveDataEnabled = true;

      setState(() {
        _nestedTabController.index = 0;
        _scrollController.jumpTo(0.0);
      });
    }
    else{
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

  // loadCallCenterListData() async {
  //   selectBox_ccCode.clear();
  //
  //   await AgentController.to.getDataCCenterItems(_mCode);
  //
  //   AgentController.to.qDataCCenterItems.forEach((element) {
  //     selectBox_ccCode.add(new SelectOptionVO(
  //         value: element['ccCode'], label: element['ccName']));
  //   });
  //
  //   setState(() {});
  // }

  loadData() async {
    _nestedTabController.index = 0;

    formData = null;
    shopPosUpdate = null;
    formData = ShopBasicInfoModel();
    shopPosUpdate = ShopPosUpdateModel();

    shopPosUpdate.hdong = '';
    shopPosUpdate.ri = '';

    //selectBox_salesman.clear();
    //selectBox_operator.clear();
    //selectBox_brandType.clear();

    dataHistoryList.clear();

    await ShopController.to.getBasicData(detailData.selected_shopCode.toString()).then((value) {
      if (value == null) {
        ISAlert(context, '매장 기본정보가 정상조회 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else{
        formData = ShopBasicInfoModel.fromJson(ShopController.to.qDataBasicInfo);

        setState(() {        });
      }
    });

    await ShopController.to.getHistoryData(detailData.selected_shopCode, '1', '10000').then((value) {
      if (value == null) {
        ISAlert(context, '변경이력이 정상조회 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else{
        value.forEach((element) {
          ShopHistoryModel tempData = ShopHistoryModel.fromJson(element);
          dataHistoryList.add(tempData);
        });
      }
    });

    // await UserController.to.getUserCodeNameSaleseman('2', '5').then((value) {
    //   if (value == null) {
    //     ISAlert(context, '영업자정보 정상조회 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    //   }
    //   else{
    //     // 영업사원 바인딩
    //     selectBox_salesman.add(new SelectOptionVO(value: '', label: '--', label2: ''));
    //
    //     // 영업사원 바인딩
    //     value.forEach((element) {
    //       UserCodeName tempData = UserCodeName.fromJson(element);
    //
    //       selectBox_salesman.add(new SelectOptionVO(value: tempData.code, label: '[' + tempData.code + '] ' + tempData.name, label2: tempData.name));
    //     });
    //   }
    // });

    // await UserController.to.getUserCodeNameOperator('2', '6').then((value) {
    //   if (value == null) {
    //     ISAlert(context, '운영자정보가 정상조회 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    //   }
    //   else{
    //     // 오퍼레이터 바인딩
    //     selectBox_operator.add(new SelectOptionVO(value: '', label: '--', label2: ''));
    //
    //     // 오퍼레이터 바인딩
    //     value.forEach((element) {
    //       UserCodeName tempData = UserCodeName.fromJson(element);
    //
    //       selectBox_operator.add(new SelectOptionVO(value: tempData.code, label: '[' + tempData.code + '] ' + tempData.name, label2: tempData.name));
    //     });
    //   }
    // });

    if (matchingCheck_Saleman() == false)
      formData.salesmanCode = '';

    if (matchingCheck_Operator() == false)
      formData.operatorCode = '';

    //if (this.mounted) {
    setState(() {

    });
    //}
  }

  bool matchingCheck_Saleman(){
    bool temp = false;

    for (final element in widget.selectBox_salesman){
      if (element.value == formData.salesmanCode) {
        temp = true;
        break;
      }
    }
    return temp;
  }

  bool matchingCheck_Operator(){
    bool temp = false;

    for (final element in widget.selectBox_operator){
      if (element.value == formData.operatorCode) {
        temp = true;
        break;
      }
    }
    return temp;
  }

  @override
  void initState() {
    super.initState();

    Get.put(AgentController());
    Get.put(TaxController());

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
    selectBox_type.clear();

    dataHistoryList.clear();

    super.dispose();
  }

  _ShopMemoHitory() {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: ShopMemoHistory(shopCode: formData.shopCd),
      ),
    ).then((v) async {});
  }

  _searchPost() async {
    if (kIsWeb) {
      showDialog(
          context: context,
          builder: (BuildContext context) => Dialog(
            child: Container(width: 0, height: 0, child: PostCodeRequest()),
          )).then((v) {
        if (v != null) {
          setState(() {
            formKey.currentState.save();

            formData.zipCode = v[0];
            formData.addr1 = v[1];
            formData.addr2 = v[2];

            formData.sidoName = v[3];
            formData.gunguName = v[4];

            // POS 가맹점 저장 용
            shopPosUpdate.zone_code = v[0];
            shopPosUpdate.sido = v[3];
            shopPosUpdate.sigungu = v[4];
            shopPosUpdate.road = v[6];
            shopPosUpdate.hdong = v[7];

            if (v[5] == '') {
              formData.roadDestDong = v[6];
              formData.dongName = v[8];
              shopPosUpdate.bdong = v[8];
            } else {
              formData.roadDestDong = v[5] + ' ' + v[6];
              formData.dongName = v[5] + ' ' + v[8];
              shopPosUpdate.bdong = v[5];
              shopPosUpdate.ri = v[8];
            }

            List<String> addr1 = [];
            List<String> addr2 = [];

            addr1 = formData.addr1.split(" ");
            addr2 = formData.addr2.split(" ");

            formData.destJibun = addr1.last;
            formData.roadDestAddr = addr2.last;
          });
        }
      });
    } else {
      var v = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => Kopo()));

      if (v != null) {
        setState(() async {
          if (v.userSelectedType == 'R') {
            formData.zipCode = v.zoncode;
            formData.addr1 = v.roadAddress;
          } else {
            formData.zipCode = v.zoncode;
            formData.addr1 = v.jibunAddress;
          }

          formData.zipCode = v.zoncode;
          formData.addr1 = v.jibunAddress;
          formData.addr2 = v.roadAddress;

          await ShopController.to.getNaverData(formData.addr1, formData.addr2);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  labelStyle: TextStyle(fontSize: 12, fontFamily: 'NotoSansKR'),
                  unselectedLabelColor: Colors.black45,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BubbleTabIndicator(
                    indicatorRadius: 5.0,
                    indicatorHeight: 25.0,
                    indicatorColor: Colors.blue,
                    tabBarIndicatorSize: TabBarIndicatorSize.tab,
                  ),
                  tabs: [
                    Tab(text: '기본정보',),
                    Tab(text: '변경이력',)
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
                      padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),//EdgeInsets.all(8.0),
                      child: getInfoTabView(),
                  ),
                  Container(
                      padding: EdgeInsets.all(8.0),
                      child: getHistoryTabView2()
                  ),
                ],
              ),
            )
          ]
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
          buttonBar(),
          Form(
            key: formKey,
            child: Wrap(
              children: <Widget>[
                // 콜센터 수정 필요시, 추후 삽입예정
                // ISSelect(
                //   label: '콜센터명',
                //   value: formData.ccCode,
                //   LabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                //   DropdownStyle: TextStyle(fontSize: 14),
                //   dataList: selectBox_CCenterCode,
                //   onChange: (v){
                //     formData.ccCode = v;
                //     //loadGunguData(v);
                //   },
                //   onSaved: (v) {
                //     //formData.cLevel = v;
                //   },
                // ),
                Divider(),
                Container(
                    padding: EdgeInsets.only(left: 8),
                    child: Text('소속 콜센터', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),)
                ),
                ISSelect(
                    label: '콜센터명',
                    ignoring: true,
                    value: formData.ccCode,
                    dataList: widget.selectBox_ccCode,
                    onChange: (v) {
                      formData.ccCode = v;
                    }
                ),
                Divider(),
                Container(
                    padding: EdgeInsets.only(left: 8),
                    child: Text('매장 정보', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),)
                ),
                Row(
                  children: [
                    Flexible(
                        flex: 3,
                        child: ISInput(
                          //autofocus: true,
                          value: formData.shopName ?? '',
                          context: context,
                          label: '매장명',
                          //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                          prefixIcon: Icon(Icons.store, color: Colors.grey,),
                          onChange: (v) {
                            formData.shopName = v;
                          },
                        )
                    ),
                    Flexible(
                      flex: 2,
                      child: ISSelect(
                        label: '브랜드 소속',
                        value: formData.franchiseCd,
                        dataList: widget.selectBox_brandType,
                        onChange: (v) {
                          setState(() {
                            formData.franchiseCd = v;

                            formKey.currentState.save();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      flex: 2,
                      child: ISInput(
                        value: formData.owner ?? '',
                        context: context,
                        label: '대표자명',
                        //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                        //prefixIcon: Icon(Icons.person, color: Colors.grey,),
                        textStyle: TextStyle(fontSize: 12),
                        onChange: (v) {
                          formData.owner = v;
                        },
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: ISInput(
                        value: Utils.getPhoneNumFormat(formData.mobile, false) ?? '',
                        context: context,
                        label: '휴대폰',
                        //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                        prefixIcon: Icon(Icons.phone_android, color: Colors.grey,),
                        textStyle: TextStyle(fontSize: 12),
                        onChange: (v) {
                          setState(() {
                            formData.mobile = v.toString().replaceAll('-', '');
                          });
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          MultiMaskedTextInputFormatter(masks: ['xxx-xxxx-xxxx', 'xxxx-xxxx-xxxx', 'xxx-xxx-xxxx', 'xxxx-xxxx'], separator: '-')
                        ],
                      ),
                    ),
                    Flexible(
                        flex: 3,
                        child: ISInput(
                          //autofocus: true,
                          //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                          value: formData.email ?? '',
                          context: context,
                          label: '이메일',
                          prefixIcon: Icon(
                            Icons.mail,
                            color: Colors.grey,
                          ),
                          onChange: (v) {
                            formData.email = v;
                          },
                        )
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      flex: 4,
                      child: ISInput(
                        readOnly: true,
                        value: formData.addr1 ?? '',
                        context: context,
                        label: '구 주소(지번)',
                        prefixIcon: Icon(
                          Icons.home,
                          color: Colors.grey,
                        ),
                        textStyle: TextStyle(fontSize: 12),
                        onSaved: (v) {
                          formData.addr1 = v;
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: ISButton(
                        height: 40,
                        //padding: EdgeInsets.fromLTRB(10, 20, 0, 10),
                        textStyle: TextStyle(fontSize: 12, color: Colors.white),
                        label: '주소검색',
                        onPressed: () {
                          if (detailData == null)
                            return;

                          //if (formData.useGbn == 'Y')
                          _searchPost();
                        },
                      ),
                    ),
                  ],
                ),
                ISInput(
                  readOnly: true,
                  value: formData.addr2 ?? '',
                  context: context,
                  label: '신주소(도로명)',
                  prefixIcon: Icon(Icons.home, color: Colors.grey),
                  textStyle: TextStyle(fontSize: 12),
                  onSaved: (v) {
                    formData.addr2 = v;
                  },
                  // validator: (v) {
                  //   return v.isEmpty ? '[필수] 상세주소': null;
                  // },
                ),
                ISInput(
                  value: formData.loc ?? '',
                  context: context,
                  label: '상세주소',
                  //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                  prefixIcon: Icon(Icons.home, color: Colors.grey),
                  textStyle: TextStyle(fontSize: 12),
                  onChange: (v) {
                    formData.loc = v;
                  },
                  // validator: (v) {
                  //   return v.isEmpty ? '[필수] 상세주소': null;
                  // },
                ),
                ISInput(
                  value: formData.memo ?? '',
                  context: context,
                  label: '메모',
                  //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                  maxLines: 8,
                  height: 100,
                  keyboardType: TextInputType.multiline,
                  prefixIcon: Icon(Icons.event_note, color: Colors.grey),
                  textStyle: TextStyle(fontSize: 12),
                  onChange: (v) {
                    formData.memo = v;
                  },
                  // suffixIcon: Container(
                  //   width: 20,
                  //   height: 100,
                  //   alignment: Alignment.topRight,
                  //   child: IconButton(
                  //     onPressed: () {
                  //       _ShopMemoHitory();
                  //     },
                  //     icon: Icon(
                  //       Icons.history,
                  //       color: Colors.blue,
                  //       size: 30,
                  //     ),
                  //     tooltip: '메모 변경 이력',
                  //   ),
                  // ),
                ),
                Divider(),
                Container(
                    padding: EdgeInsets.only(left: 8),
                    child: Text('사업자 정보', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),)
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      flex: 2,
                      child: ISSelect(
                        label: '사업자 유형',
                        value: formData.bussTaxType,
                        dataList: selectBox_type,
                        onChange: (v) {
                          setState(() {
                            formData.bussTaxType = v;

                            formKey.currentState.save();
                          });
                        },
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: ISInput(
                        value: formData.bussOwner ?? '',
                        context: context,
                        label: '사업자 대표자명',
                        //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                        //prefixIcon: Icon(Icons.person, color: Colors.grey,),
                        textStyle: TextStyle(fontSize: 12),
                        onChange: (v) {
                          formData.bussOwner = v;
                        },
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: ISInput(
                        value: Utils.getStoreRegNumberFormat(formData.regNo, false) ?? '',
                        context: context,
                        label: '사업자등록번호',
                        //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                        //prefixIcon: Icon(Icons.confirmation_number, color: Colors.grey,),
                        textStyle: TextStyle(fontSize: 12),
                        onChange: (v) {
                          formData.regNo = v.toString().replaceAll('-', '');
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          MultiMaskedTextInputFormatter(masks: ['xxx-xx-xxxxx'], separator: '-')
                        ],
                        suffixIcon: MaterialButton(
                          color: Colors.blue,
                          minWidth: 40,
                          child: Text('국세청조회', style: TextStyle(color: Colors.white, fontSize: 10),),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
                          onPressed: (){
                            if (detailData == null)
                              return;

                            TaxController.to.getTaxData(formData.regNo).then((value) {
                              if (value == null){
                                ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
                              }
                              else{
                                List<String> retValue  = value.split('|');
                                ISAlert(context, '- [국세청] 조회 결과\n\n${retValue[1]}');
                                // String retResult = '등록';
                                // List<String> retValue  = value.split('|');
                                // if (retValue[0] == '00')
                                //   retResult = '등록';
                                // else
                                //   retResult = '미등록';
                                //
                                // ISAlert(context, '- 조회 결과 [${retResult}]\n\n    ${retValue[1]}');
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: ISInput(
                        value: formData.bussCon ?? '',
                        context: context,
                        label: '업태',
                        //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                        prefixIcon: Icon(Icons.assignment, color: Colors.grey,),
                        textStyle: TextStyle(fontSize: 12),
                        onChange: (v) {
                          formData.bussCon = v;
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: ISInput(
                        value: formData.bussType ?? '',
                        context: context,
                        label: '업종',
                        //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                        prefixIcon: Icon(Icons.sticky_note_2, color: Colors.grey,),
                        textStyle: TextStyle(fontSize: 12),
                        onChange: (v) {
                          formData.bussType = v;
                        },
                      ),
                    ),
                  ],
                ),
                ISInput(
                  value: formData.bussAddr ?? '',
                  context: context,
                  label: '사업자 주소',
                  //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                  prefixIcon: Icon(Icons.home, color: Colors.grey),
                  textStyle: TextStyle(fontSize: 12),
                  onChange: (v) {
                    formData.bussAddr = v;
                  },
                ),
                Divider(),
                Container(
                    padding: EdgeInsets.only(left: 8),
                    child: Text('담당자', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),)
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                        flex: 1,
                        child: ISSelect(
                          label: '영업사원',
                          value: formData.salesmanCode,
                          dataList: widget.selectBox_salesman,
                          onChange: (v) {
                            widget.selectBox_salesman.forEach((element) {
                              if (v == element.value) {
                                formData.salesmanCode = element.value;
                                formData.salesmanName = element.label2;
                              }
                            });
                          },
                          onSaved: (v) {
                            //formData.cLevel = v;
                          },
                        )
                      // child: (formData.useGbn == 'N' || formData.useGbn == '')
                      //     ? ISInput(
                      //   label: '영업사원',
                      //   textStyle: TextStyle(fontSize: 12),
                      //   value: (formData.salesmanCode == '' && formData.salesmanName == '') ? '': '[' + formData.salesmanCode + '] ' + formData.salesmanName,
                      //   readOnly: true,
                      // ) : ISSelect(
                      //   label: '영업사원',
                      //   value: formData.salesmanCode,
                      //   dataList: selectBox_salesman,
                      //   onChange: (v) {
                      //     selectBox_salesman.forEach((element) {
                      //       if (v == element.value) {
                      //         formData.salesmanCode = element.value;
                      //         formData.salesmanName = element.label2;
                      //       }
                      //     });
                      //   },
                      //   onSaved: (v) {
                      //     //formData.cLevel = v;
                      //   },
                      // ),
                    ),
                    Flexible(
                        flex: 1,
                        child: ISSelect(
                          label: '오퍼레이터',
                          value: formData.operatorCode,
                          dataList: widget.selectBox_operator,
                          onChange: (v) {
                            widget.selectBox_operator.forEach((element) {
                              if (v == element.value) {
                                formData.operatorCode = element.value;
                                formData.operatorName = element.label2;
                              }
                            });
                          },
                          onSaved: (v) {
                            //formData.cLevel = v;
                          },
                        )
                      // child: (formData.useGbn == 'N' || formData.useGbn == '')
                      //     ? ISInput(
                      //   label: '오퍼레이터',
                      //   textStyle: TextStyle(fontSize: 12),
                      //   value: (formData.operatorCode == '' && formData.operatorCode == '') ? '': '[' + formData.operatorCode + '] ' + formData.operatorCode,
                      //   readOnly: true,
                      // ) : ISSelect(
                      //   label: '오퍼레이터',
                      //   value: formData.operatorCode,
                      //   dataList: selectBox_operator,
                      //   onChange: (v) {
                      //     selectBox_operator.forEach((element) {
                      //       if (v == element.value) {
                      //         formData.operatorCode = element.value;
                      //         formData.operatorName = element.label2;
                      //       }
                      //     });
                      //   },
                      //   onSaved: (v) {
                      //     //formData.cLevel = v;
                      //   },
                      // ),
                    ),
                  ],
                ),
                Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getHistoryTabView2() {
    return ListView.builder(
      controller: _scrollController,
      //padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      itemCount: dataHistoryList.length,
      itemBuilder: (BuildContext context, int index) {
        return dataHistoryList != null ? GestureDetector(
          child: Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: Row(
                children: [
                  //Text('No.' + imageHistoryList[index].no.toString() ?? '--', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Container(
                      padding: EdgeInsets.only(top: 5),
                      child: SelectableText(
                        dataHistoryList[index].memo ?? '--',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                        showCursor: true,
                      )),
                ],
              ),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      alignment: Alignment.centerRight,
                      child: Text(dataHistoryList[index].insertDate ?? '--', style: TextStyle(fontSize: 12), textAlign: TextAlign.right))
                ],
              ),
            ),
          ),
        ) : Text('Data is Empty');
      },
    );
  }

  Widget buttonBar() {
    return Container(
      padding: EdgeInsets.only(right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // formData.useGbn == '' ? Container()
              //     : Container(
              //         padding: EdgeInsets.only(left: 16),
              //         child: formData.useGbn == 'Y' ? MaterialButton(
              //           color: Colors.red[300],
              //           child: Text('해지처리', style: TextStyle(color: Colors.white, fontSize: 14),),
              //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              //           onPressed: () async {
              //             showDialog(
              //               context: context,
              //               builder: (BuildContext context) => Dialog(
              //                 child: ShopContractEnd(shopCode: formData.shopCd, shopName: formData.shopName),
              //               ),
              //             ).then((v) async {
              //               print('------------ return basic call[${v}]');
              //               if (v == true) {
              //                 widget.callback();
              //               }
              //             });
              //           },
              //         ) : MaterialButton(
              //           color: Colors.blue[300],
              //           child: Text(formData.contractEndDt, style: TextStyle(color: Colors.white, fontSize: 14),),
              //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              //         ),
              // )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
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
                iconData: Icons.refresh,
                iconColor: Colors.white,
                tip: '갱신',
                onPressed: (){
                  if (detailData == null)
                    return;

                  if (isReceiveDataEnabled == true){
                    loadData();

                    setState(() {
                      _nestedTabController.index = 0;
                      _scrollController.jumpTo(0.0);
                    });
                  }
                },
              ),
              SizedBox(width: 10,),
              if (AuthUtil.isAuthEditEnabled('95') == true)
                ISButton(
                  label: '저장',
                  iconColor: Colors.white,
                  textStyle: TextStyle(color: Colors.white),
                  iconData: Icons.save,
                  onPressed: () async {
                    if (detailData == null)
                      return;

                    FormState form = formKey.currentState;
                    if (!form.validate()) {
                      return;
                    }

                    form.save();
                    await ShopController.to.getNaverData(formData.addr1, formData.addr2);

                    formData.ccCode = detailData.selected_ccCode; //필수

                    if (ShopController.to.x == null) {
                      ISAlert(context, '구 주소, 신 주소 중 하나는 정확히 입력 해야 합니다.');
                      return;
                    }

                    formData.mCode = detailData.selected_mCode;

                    formData.lon = ShopController.to.x;
                    formData.lat = ShopController.to.y;
                    formData.modUCode = GetStorage().read('logininfo')['uCode'];
                    formData.modName = GetStorage().read('logininfo')['name'];

                    var result = await ShopController.to.putBasicData(detailData.selected_mCode, formData.toJson(), context);

                    List<String> _resultList = [];

                    _resultList = result['msg'].split("|");

                    if (result['code'] == '-1') {
                      ISAlert(context, '[' + _resultList[0] + '] 가맹점에서 이미 사용중인 사업자 번호입니다. \n확인 후, 다시 입력해주세요.');
                      return;
                    } else if (result['code'] != '00') {
                      ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
                      return;
                    }

                    // POS 가맹점 정보 업데이트 처리
                    shopPosUpdate.job_gbn = 'UPDATE';

                    // if (widget.mCode == '1') // 테스트
                    // {
                    //   shopPosUpdate.mcode = '1';
                    //   shopPosUpdate.cccode = '1';
                    // } else if (widget.mCode == '2') // 운영
                    // {
                    //   shopPosUpdate.mcode = '2';
                    //   shopPosUpdate.cccode = '2';
                    // }

                    shopPosUpdate.mcode = detailData.selected_mCode;
                    shopPosUpdate.cccode = detailData.selected_ccCode;

                    shopPosUpdate.shop_cd = formData.shopCd;
                    shopPosUpdate.use_gbn = formData.useGbn;
                    shopPosUpdate.login_id = formData.shopId;
                    shopPosUpdate.login_pw = 'admin';
                    shopPosUpdate.shop_name = formData.shopName;
                    shopPosUpdate.address = formData.addr1;
                    shopPosUpdate.address_detail = formData.loc;

                    if (formData.sidoName.contains('광역시')) {
                      shopPosUpdate.sido = formData.sidoName;
                    } else {
                      shopPosUpdate.sido = formData.sidoName + '광역시';
                    }

                    shopPosUpdate.sigungu = formData.gunguName;
                    shopPosUpdate.bdong = formData.dongName;

                    // 읍,면 들어가있을시 POS 에는 빼고 저장
                    if (formData.roadDestDong.split(' ').length == 2) {
                      shopPosUpdate.road = formData.roadDestDong.split(' ').last;
                    } else {
                      shopPosUpdate.road = formData.roadDestDong;
                    }

                    shopPosUpdate.lon = double.parse(formData.lon);
                    shopPosUpdate.lat = double.parse(formData.lat);
                    shopPosUpdate.telno = formData.telNo;
                    shopPosUpdate.mobile = formData.mobile;
                    shopPosUpdate.reg_no = formData.regNo;
                    shopPosUpdate.owner = formData.owner;
                    shopPosUpdate.zone_code = formData.zipCode;
                    shopPosUpdate.shop_token = formData.apiComCode;
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

                    var bodyData = {'"app_name"': '"대구로 어드민"', '"app_type"': '"admin-daeguroApp"', '"shop_info"': shopPosUpdate.toJson()};

                    await RestApiProvider.to.postRestError('0', '/admin/ShopBasic : putBasicData', '[POS 가맹점 정보 저장] ' + bodyData.toString() + '|| ucode : ' + GetStorage().read('logininfo')['uCode'].toString() + ', name : ' + GetStorage().read('logininfo')['name'].toString());

                    await http.post(Uri.parse('https://pos.daeguro.co.kr:15412/posApi/POSData/DaeguroApp_Process'), headers: headerData, body: bodyData.toString()).then((http.Response response) async {
                      if (response.statusCode == 200) {
                        var decodeBody = jsonDecode(response.body);
                      } else {
                        var decodeBody = jsonDecode(response.body);
                      }
                    });

                    // 오퍼레이터 입력 시 담당배정으로 변경
                    // 이미지 상태가(0:대기, 1:요청) 이거나 빈값일때 2:담당배정 으로 변경
                    if (formData.operatorCode != '') {
                      if (detailData.selected_imageStatus == '') {
                        await ShopController.to.putImageStatus(detailData.selected_shopCode, '2', context);
                      } else {
                        if (int.parse(detailData.selected_imageStatus) < 2) {
                          await ShopController.to.putImageStatus(detailData.selected_shopCode, '2', context);
                        }
                      }
                    }

                    setState(()  {
                      isListSaveEnabled = true;
                    });
                    //Navigator.pop(context, true);

                    widget.callback();
                  },
                ),
            ],
          )
        ],
      ),
    );
  }

  String _getBussTaxTypeName(String value) {
    int index = selectBox_type.indexWhere((item) => item.value == value);

    if (index < 0)
      return '';

    return selectBox_type.elementAt(index).label;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}