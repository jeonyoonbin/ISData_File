import 'dart:convert';

import 'package:daeguro_admin_app/Model/shop/shop_delitip.dart';
import 'package:daeguro_admin_app/Model/shop/shopposupdate.dart';
import 'package:daeguro_admin_app/Network/DioClient.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/tax_controller.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/Model/shop/shop_bankcode.dart';
import 'package:daeguro_admin_app/Model/shop/shop_divcode.dart';
import 'package:daeguro_admin_app/Model/shop/shop_info.dart';
import 'package:daeguro_admin_app/Model/shop/shopbasic_info.dart';
import 'package:daeguro_admin_app/Model/shop/shopcalc_info.dart';
import 'package:daeguro_admin_app/Model/shop/shopnew.dart';
import 'package:daeguro_admin_app/View/AgentManager/agentAccount_Controller.dart';
import 'package:daeguro_admin_app/View/PostCode/postCodeRequest.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';

import 'package:daeguro_admin_app/Util/multi_masked_formatter.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/Util/utils.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:kopo/kopo.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class ShopNew extends StatefulWidget {
  const ShopNew({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShopNewState();
  }
}

class ShopNewState extends State<ShopNew> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ShopBasicInfoModel formData_BasicInfo;
  ShopCalcInfoModel formData_CalcInfo;
  ShopInfoModel formData_ShopInfo;

  ScrollController _scrollController;

  List<SelectOptionVO> selectBox_reserve_itemCd = [];
  List<SelectOptionVO> selectBox_brandType = [];

  bool _shopTypeGbn3 = false;
  bool _shopTypeGbn5 = false;
  bool _shopTypeGbn7 = false;
  bool _shopTypeGbn9 = false;

  //ShopAccountD formData;

  List<SelectOptionVO> selectBox_type = [
    new SelectOptionVO(value: '1', label: '일반'),
    new SelectOptionVO(value: '3', label: '간이'),
    new SelectOptionVO(value: '5', label: '법인'),
    new SelectOptionVO(value: '7', label: '면세')
  ];

  List<ShopNewModel> shopNewData = [
    new ShopNewModel(tabName: '기본정보', isSaved: false),
    new ShopNewModel(tabName: '정산정보', isSaved: false),
    new ShopNewModel(tabName: '매장정보', isSaved: false),
    new ShopNewModel(tabName: '예약정보', isSaved: false),
  ];
  int _currentStep = 0;

  List<Object> shopRepresentImageList = List<Object>();
  List<Object> menuMultiImageList = List<Object>();
  List<Object> menuBoardImageList = List<Object>();

  List<SelectOptionVO> selectBox_BankCode = [];
  List<SelectOptionVO> selectBox_DivCode = [];

  List<SelectOptionVO> selectBox_mCode = List();
  List<SelectOptionVO> selectBox_ccCode = List();
  List<SelectOptionVO> selectBox_subitemCd = [];

  String _mCode = '2';

  String createShopCd = '';
  String posApiComCode = '';

  String editShopType = '';

  String _introduce = ' ';

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
  String _tema_1_sub = '';

  String _reserveYn = 'N';
  String _reveiwUseGbn = 'N';

  loadMCodeListData() async {
    selectBox_mCode.clear();

    //await AgentController.to.getDataMCodeItems();

    List MCodeListitems = Utils.getMCodeList();

    MCodeListitems.forEach((element) {
      selectBox_mCode.add(new SelectOptionVO(value: element['mCode'], label: element['mName']));
    });

    setState(() {});
  }

  loadCallCenterListData() async {
    selectBox_ccCode.clear();

    await AgentController.to.getDataCCenterItems(_mCode).then((value) {
      if (value == null) {
        ISAlert(context, '콜센터정보를 가져오지 못했습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        value.forEach((element) {
          selectBox_ccCode.add(new SelectOptionVO(value: element['ccCode'], label: element['ccName']));
        });

        setState(() {});
      }
    });
  }

  loadDivListData() async {
    selectBox_brandType.clear();

    await ShopController.to.getDataDivItems().then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        value.forEach((element) {
          ShopDivCodeModel tempData = ShopDivCodeModel.fromJson(element);
          selectBox_DivCode.add(new SelectOptionVO(value: tempData.itemCd, label: tempData.itemName));
        });
      }
    });

    await ShopController.to.getFranchiseListData().then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        selectBox_brandType.add(new SelectOptionVO(value: '', label: '사용안함'));

        value.forEach((element) {
          selectBox_brandType.add(new SelectOptionVO(value: element['CODE'], label: element['CODE_NM']));
        });
      }
    });

    setState(() {});
  }

  loadBankListData() async {
    await ShopController.to.getDataBankItems().then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        value.forEach((element) {
          ShopBankCodeModel tempData = ShopBankCodeModel.fromJson(element);

          selectBox_BankCode.add(new SelectOptionVO(value: tempData.bankCode, label: tempData.bankName));
        });
      }
    });

    setState(() {});
  }

  loadReserItems() async {
    await ShopController.to.getReserItems('0001').then((value) {
      if (value == null) {
        ISAlert(context, '업소 조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        selectBox_reserve_itemCd.add(new SelectOptionVO(value: '', label: '--', label2: ''));

        value.forEach((element) {
          //ReserItemModel tempData = ReserItemModel.fromJson(element);

          selectBox_reserve_itemCd
              .add(new SelectOptionVO(value: element['code'], label: '[' + element['code'] + '] ' + element['nameMain'], label2: element['nameMain']));
        });
      }
    });

    await ShopController.to.getReserItems('0003').then((value) {
      if (value == null) {
        ISAlert(context, '테마 카테고리 조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        selectBox_subitemCd.add(new SelectOptionVO(value: '', label: '--', label2: ''));

        value.forEach((element) {
          //ReserItemModel tempData = ReserItemModel.fromJson(element);

          selectBox_subitemCd
              .add(new SelectOptionVO(value: element['code'], label: '${int.parse(element['code'])}. ' + element['nameMain'], label2: element['nameMain']));
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    Get.put(AgentController());
    Get.put(TaxController());

    loadMCodeListData();
    loadCallCenterListData();
    loadDivListData();
    loadBankListData();

    shopRepresentImageList.add('Add Image');
    //shopRepresentImageList.add('Add Image');

    menuBoardImageList.add('Add Image');

    menuMultiImageList.add('Add Image');
    menuMultiImageList.add('Add Image');
    menuMultiImageList.add('Add Image');
    menuMultiImageList.add('Add Image');
    menuMultiImageList.add('Add Image');
    menuMultiImageList.add('Add Image');

    //formData = ShopAccountD();
    //formData.shopCd = '0';

    formData_BasicInfo = ShopBasicInfoModel();
    formData_BasicInfo.mCode = '2';
    formData_BasicInfo.shopCd = '';
    formData_CalcInfo = ShopCalcInfoModel();
    formData_ShopInfo = ShopInfoModel();

    //print('formData.ccCode: '+formData.ccCode.toString()+', formData_BasicInfo.ccCode:'+formData_BasicInfo.ccCode.toString());

    // WidgetsBinding.instance.addPostFrameCallback((c) {
    //   _query();
    // });

    //loadReserItems();
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

            formData_BasicInfo.zipCode = v[0];
            formData_BasicInfo.addr1 = v[1];
            formData_BasicInfo.addr2 = v[2];

            formData_BasicInfo.sidoName = v[3];
            formData_BasicInfo.gunguName = v[4];

            if (v[5] == '') {
              formData_BasicInfo.roadDestDong = v[6];
              formData_BasicInfo.dongName = v[8];
            } else {
              formData_BasicInfo.roadDestDong = v[5] + ' ' + v[6];
              formData_BasicInfo.dongName = v[5] + ' ' + v[8];
            }

            formData_BasicInfo.roadDestDong = v[6];

            List<String> addr1 = [];
            List<String> addr2 = [];

            addr1 = formData_BasicInfo.addr1.split(" ");
            addr2 = formData_BasicInfo.addr2.split(" ");

            formData_BasicInfo.destJibun = addr1.last;
            formData_BasicInfo.roadDestAddr = addr2.last;
          });
        }
      });
    } else {
      var v = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => Kopo()));

      if (v != null) {
        setState(() async {
          if (v.userSelectedType == 'R') {
            formData_BasicInfo.zipCode = v.zoncode;
            formData_BasicInfo.addr1 = v.roadAddress;
          } else {
            formData_BasicInfo.zipCode = v.zoncode;
            formData_BasicInfo.addr1 = v.jibunAddress;
          }

          formData_BasicInfo.zipCode = v.zoncode;
          formData_BasicInfo.addr1 = v.jibunAddress;
          formData_BasicInfo.addr2 = v.roadAddress;

          await ShopController.to.getNaverData(formData_BasicInfo.addr1, formData_BasicInfo.addr1);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Container(
        //child: _tabStep(),
        //height: 800,
        child: Stepper(
          type: StepperType.horizontal,
          physics: ClampingScrollPhysics(),
          //NeverScrollableScrollPhysics(),
          //ScrollPhysics(),
          currentStep: _currentStep,
          onStepTapped: (step) => tapped(step),
          // onStepContinue: continued,
          // onStepCancel: cancel,
          steps: [
            _getStep0(),
            _getStep1(),
            _getStep2(),
            //_getStep3(),
          ],
          controlsBuilder: (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) => Container(
            //padding: const EdgeInsets.only(top: 20.0),
            child: ButtonBar(
              alignment: MainAxisAlignment.start,
              children: <Widget>[
                // ISButton(
                //     label: '이전',
                //     iconData: Icons.skip_previous,
                //     enable: _currentStep == 0 ? false : true,
                //     onPressed: () {
                //       //_currentStep > 0 ? setState(() => _currentStep -=1) : null;
                //       if (_currentStep > 0){
                //         setState(() {
                //           _currentStep -=1;
                //         });
                //       }
                //       else{
                //         null;
                //       }
                //     }
                // ),
                ISButton(
                    label: _currentStep == shopNewData.length - 1 ? '완료' : '다음',
                    iconData: _currentStep == shopNewData.length - 1 ? Icons.collections_bookmark : Icons.skip_next,
                    //enable: _currentStep == shopNewData.length ? false : true,
                    onPressed: () async {
                      FormState form = formKey.currentState;
                      if (!form.validate()) {
                        return;
                      }
                      form.save();

                      //print('shopNewData['+_currentStep.toString()+'].isSaved-> '+shopNewData[_currentStep].isSaved.toString());

                      //기본정보 저장
                      if (_currentStep == 0) {
                        if (shopNewData[_currentStep].isSaved == false) {
                          if (formData_BasicInfo.ccCode == null || formData_BasicInfo.ccCode == '') {
                            ISAlert(context, '선택된 콜센터가 없습니다. \n\n소속 콜센터 선택 후, 다시 시도해주세요.');
                            return;
                          }

                          if (formData_BasicInfo.shopName == null || formData_BasicInfo.shopName == '') {
                            ISAlert(context, '매장명을 입력해주세요.');
                            return;
                          }

                          String resultCode = '';
                          String resultStr = '';

                          await TaxController.to.getTaxData(formData_BasicInfo.regNo).then((value) async {
                            List<String> retValue = value.split('|');
                            resultCode = retValue[0];
                            resultStr = retValue[1];

                            if (resultCode == '0') {
                              _currentStep = -1;
                              ISAlert(context, resultStr);
                              return;
                            } else {
                              await ShopController.to.getNaverData(formData_BasicInfo.addr1, formData_BasicInfo.addr2);

                              formData_BasicInfo.modUCode = GetStorage().read('logininfo')['uCode'];
                              formData_BasicInfo.modName = GetStorage().read('logininfo')['name'];

                              //print('formData_BasicInfo--> '+formData_BasicInfo.toJson().toString());

                              if (ShopController.to.x == null) {
                                _currentStep = -1;
                                ISAlert(context, '주소를 정확히 입력 해야 합니다.');
                                return;
                              }

                              formData_BasicInfo.lon = ShopController.to.x;
                              formData_BasicInfo.lat = ShopController.to.y;

                              formData_BasicInfo.salesmanCode = null;
                              formData_BasicInfo.salesmanName = null;
                              formData_BasicInfo.operatorCode = null;
                              formData_BasicInfo.operatorName = null;

                              await ShopController.to.postBasicData(_mCode, formData_BasicInfo.toJson(), context).then((value) {
                                if (value['code'] != '00') {
                                  _currentStep = -1;
                                  ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
                                  return;
                                } else {
                                  // 가맹점 생성시 POS 가맹점 ID 바인딩(예약 정보 저장에 필요)
                                  createShopCd = value['shopCd'].toString();
                                  posApiComCode = value['shopId'].toString();

                                  shopNewData[0].isSaved = true;
                                  shopNewData[0].ccCode = formData_BasicInfo.ccCode;
                                  shopNewData[0].shopCode = createShopCd;

                                  shopNewData[1].ccCode = shopNewData[0].ccCode;
                                  shopNewData[1].shopCode = shopNewData[0].shopCode;

                                  shopNewData[2].ccCode = shopNewData[0].ccCode;
                                  shopNewData[2].shopCode = shopNewData[0].shopCode;
                                }
                              });
                            }
                          });
                        }
                      }
                      //정산정보 저장
                      else if (_currentStep == 1) {
                        if (shopNewData[_currentStep].isSaved == false) {
                          if (formData_CalcInfo.bankCode == null || formData_CalcInfo.bankCode == '') {
                            ISAlert(context, '선택된 은행이 없습니다. \n\n은행 선택 후, 다시 시도해주세요.');
                            return;
                          }
                          formData_CalcInfo.shopCd = shopNewData[0].shopCode;
                          formData_CalcInfo.modUCode = GetStorage().read('logininfo')['uCode'];
                          formData_CalcInfo.modName = GetStorage().read('logininfo')['name'];

                          //print('formData_CalcInfo--> '+formData_CalcInfo.toJson().toString());

                          await ShopController.to.putCalcData(formData_CalcInfo.toJson(), context);

                          var headerData = {
                            "content-type": "application/json",
                            //"Accept": "application/json",
                          };

                          // 버전2 (2021-09-15)
                          //var bodyData = {'"bankCd"': '"' + formData_CalcInfo.bankCode + '"', '"accountNo"': '"' + formData_CalcInfo.accountNo + '"', '"accountNm"': '"' + formData_CalcInfo.accOwner + '"'};

                          var bodyData = {
                            '"bankCode"': '"' + formData_CalcInfo.bankCode + '"',
                            '"accountNo"': '"' + formData_CalcInfo.accountNo + '"',
                            '"accOwner"': '"' + formData_CalcInfo.accOwner + '"',
                            '"modUCode"': '"' + GetStorage().read('logininfo')['uCode'] + '"',
                            '"modName"': '"' + GetStorage().read('logininfo')['name'] + '"'
                          };

                          await http
                              .post(Uri.parse(ServerInfo.REST_URL_SHOPCALC_CONFIRM), headers: headerData, body: bodyData.toString())
                              .then((http.Response response) {
                            if (response.statusCode == 200) {
                              var decodeBody = jsonDecode(response.body);

                              print(decodeBody);

                              if (decodeBody['code'] == '0000') {
                                ShopController.to.putCalcData(formData_CalcInfo.toJson(), context).then((value) {
                                  if (value == '00') {
                                    ShopController.to.postSetBankConfirm(formData_CalcInfo.shopCd, 'Y', context);

                                    shopNewData[1].isSaved = true;
                                  } else
                                    ShopController.to.postSetBankConfirm(formData_CalcInfo.shopCd, 'N', context);
                                  return;
                                });
                              } else {
                                ISAlert(context, '계좌 인증 오류 - [' + decodeBody['respCd'].toString() + ']\n\n' + decodeBody['ret_msg'].toString() + ' 입니다.');

                                ShopController.to.postSetBankConfirm(formData_CalcInfo.shopCd, 'N', context);
                                return;
                              }
                            } else {
                              ISAlert(context, '계좌 인증 통신 오류 \n\n관리자에게 문의 바랍니다');
                              return;
                            }
                          });
                        }
                      }
                      //매장정보 저장
                      else if (_currentStep == 2) {
                        List<String> _shopTypeParam = [];
                        if (_shopTypeGbn3 == true) _shopTypeParam.add('3');
                        if (_shopTypeGbn5 == true) _shopTypeParam.add('5');
                        if (_shopTypeGbn7 == true) _shopTypeParam.add('7');
                        if (_shopTypeGbn9 == true) _shopTypeParam.add('9');

                        editShopType = _shopTypeParam.join(',');

                        formData_ShopInfo.shopType = editShopType;

                        if (shopNewData[_currentStep].isSaved == false) {
                          if (formData_ShopInfo.itemCd1 == null || formData_ShopInfo.itemCd1 == '') {
                            ISAlert(context, '선택된 업종1 이 없습니다. \n\n업종1 선택 후, 다시 시도해주세요.');
                            return;
                          }
                          formData_ShopInfo.shopCd = shopNewData[0].shopCode;

                          formData_ShopInfo.modUCode = GetStorage().read('logininfo')['uCode'];
                          formData_ShopInfo.modName = GetStorage().read('logininfo')['name'];

                          formData_ShopInfo.appMinAmt = '0';
                          formData_ShopInfo.useGbn = 'N';

                          ShopController.to.putInfoData(0, '0', formData_ShopInfo.toJson(), context);

                          //예약정보탭 추가시, 삭제
                          shopNewData[2].isSaved = true;
                          Navigator.pop(context);

                          return;
                        }
                      }
                      // //예약 정보 저장
                      // else if (_currentStep == 3){
                      //   ShopDeliTipModel sendData = ShopDeliTipModel();
                      //
                      //   sendData.shopCd = shopNewData[0].shopCode;
                      //
                      //   sendData.reserveYn = _reserveYn;
                      //
                      //   sendData.tipGbn = '100';
                      //   sendData.modUCode = GetStorage().read('logininfo')['uCode'];
                      //   sendData.modName = GetStorage().read('logininfo')['name'];
                      //
                      //   //print('formData--> '+sendData.toJson().toString());
                      //
                      //   if (shopNewData[_currentStep].isSaved == false) {
                      //     ShopController.to.postSaleTimeData(sendData.toJson()).then((value) async {
                      //       if (value != null){
                      //         ISAlert(context, '[예약정보] 정상적으로 저장되지 않았습니다. \n\n${value}');
                      //         return;
                      //       }
                      //       else{
                      //         //print('save _tema_1_sub:${_tema_1_sub}');
                      //         var bodyData = {
                      //           '"shopCd"': '"${shopNewData[0].shopCode}"',
                      //           '"ccCode"': '"${shopNewData[0].ccCode}"',
                      //           '"itemCd"': '"$_itemCd"',
                      //           '"introduce"': '"$_introduce"',
                      //           '"itemCd1"': '"$_itemCd1"',
                      //           '"reveiwUseGbn"': '"$_reveiwUseGbn"',
                      //           '"tema_1"': '"$_theme1"',
                      //           '"tema_2"': '"$_theme2"',
                      //           '"tema_3"': '"$_theme3"',
                      //           '"tema_4"': '"$_theme4"',
                      //           '"facilities_1"': '"$_conv1"',
                      //           '"facilities_2"': '"$_conv2"',
                      //           '"facilities_3"': '"$_conv3"',
                      //           '"facilities_4"': '"$_conv4"',
                      //           '"facilities_5"': '"$_conv5"',
                      //           '"facilities_6"': '"$_conv6"',
                      //           '"facilities_7"': '"$_conv7"',
                      //           '"facilities_8"': '"$_conv8"',
                      //           '"facilities_9"': '"$_conv9"',
                      //           '"facilities_10"': '"$_conv10"',
                      //           '"tema_1_sub"': '"$_tema_1_sub"',
                      //           '"userId"': '"${GetStorage().read('logininfo')['uCode']}"',
                      //         };
                      //
                      //         await ShopController.to.setReserveShopInfoadmin(bodyData).then((value) async {
                      //           if (value != null){
                      //             ISAlert(context, '[예약설정] 정상적으로 저장되지 않았습니다. \n\n${value}');
                      //             return;
                      //           }
                      //           else{
                      //             ShopPosUpdateModel shopPosUpdate = ShopPosUpdateModel();
                      //
                      //             shopPosUpdate.job_gbn = 'STOREUSE_UPDATE';
                      //             shopPosUpdate.shop_token = posApiComCode;
                      //             shopPosUpdate.use_gbn = sendData.useGbn;
                      //             shopPosUpdate.mod_ucode = GetStorage().read('logininfo')['uCode'];
                      //
                      //             String posAppOrderYn = '1';
                      //             String posReserveYn = '0';
                      //
                      //             // 매장 유형이 배달(5) or 포장(7) 포함 된 경우
                      //             if (editShopType.contains('5') || editShopType.contains('7')) {
                      //               posAppOrderYn = '1';
                      //             } else {
                      //               posAppOrderYn = '0';
                      //             }
                      //
                      //             if (_reserveYn == 'Y') {
                      //               posReserveYn = '1';
                      //               if (editShopType.contains('9')) {
                      //                 posReserveYn = '1';
                      //               }
                      //               else
                      //                 posReserveYn = '0';
                      //             }
                      //             else {
                      //               posReserveYn = '0';
                      //             }
                      //
                      //             var bodyPosData = {'"app_name"': '"대구로 어드민"', '"app_type"': '"admin-daeguroApp"',
                      //               '"shop_info"': '{"job_gbn" :"STOREUSE_UPDATE", "use_gbn" : "' + sendData.useGbn +
                      //                   '", "shop_token" : "' + posApiComCode +
                      //                   '", "is_fooddelivery" : "' + posAppOrderYn +
                      //                   '", "is_reserve" : "' + posReserveYn +
                      //                   '", "mod_ucode" : "' + GetStorage().read('logininfo')['uCode'] + '"}'
                      //             };
                      //
                      //             await DioClient().postRestLog('0', '/admin/shopOperate : postSaleTimeData', '[POS 가맹점 정보 저장] ' + bodyPosData.toString() + '|| ucode : ' + GetStorage().read('logininfo')['uCode'].toString() + ', name : ' + GetStorage().read('logininfo')['name'].toString());
                      //
                      //             await ShopController.to.postPosShopUpdate(ServerInfo.REST_URL_POS_APPPROCESS, bodyPosData.toString()).then((response) async {
                      //               if (response.statusCode == 200) {
                      //                 //var decodeBody = jsonDecode(response.body);
                      //                 //print('pos [200]:${decodeBody.toString()}');
                      //               } else {
                      //                 //var decodeBody = jsonDecode(response.body);
                      //                 //print('pos [other]:${decodeBody.toString()}');
                      //
                      //                 ISAlert(context, '[POS설정] 정상적으로 저장되지 않았습니다. \n\n${response.data.toString()}');
                      //               }
                      //             });
                      //           }
                      //         });
                      //       }
                      //     });
                      //
                      //     shopNewData[3].isSaved = true;
                      //
                      //     Navigator.pop(context);
                      //
                      //     return;
                      //   }
                      // }

                      //formKey.currentState.initState();

                      _currentStep < shopNewData.length ? setState(() => _currentStep += 1) : null;
                    }),
              ],
            ),
          ),
        ),
      ),
    );

    var result = Scaffold(
      appBar: AppBar(
        title: Text('가맹점 신규 등록'),
      ),
      body: form,
      //bottomNavigationBar: buttonBar,
    );
    return SizedBox(
      width: 550,
      height: 680, //750,
      child: result,
    );
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  StepState _getStepperType(int idx) {
    StepState currentType = StepState.disabled;
    //state: _currentStep >= 0 ? StepState.complete : StepState.disabled,
    if (idx == _currentStep) {
      currentType = StepState.editing;
    } else {
      if (idx > _currentStep)
        currentType = StepState.disabled;
      else if (idx < _currentStep) currentType = StepState.complete;
    }

    return currentType;
  }

  Step _getStep0() {
    return Step(
      title: Text(
        shopNewData[0].tabName,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('새로운 가맹점을 생성합니다.'),
      content: Container(
        child: Wrap(
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: ISSelect(
                      label: '회원사명',
                      value: _mCode,
                      dataList: selectBox_mCode,
                      onChange: (v) {
                        setState(() {
                          _mCode = v;
                          formData_BasicInfo.mCode = v;
                          formData_BasicInfo.ccCode = '';
                          loadCallCenterListData();
                        });
                      }),
                ),
                Flexible(
                  flex: 1,
                  child: ISSelect(
                      label: '콜센터명',
                      value: formData_BasicInfo.ccCode,
                      dataList: selectBox_ccCode,
                      onChange: (v) {
                        formData_BasicInfo.ccCode = v;
                      }),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                    flex: 1,
                    child: ISInput(
                      autofocus: true,
                      value: formData_BasicInfo.shopName ?? '',
                      context: context,
                      label: '매장명',
                      prefixIcon: Icon(
                        Icons.store,
                        color: Colors.grey,
                      ),
                      onChange: (v) {
                        formData_BasicInfo.shopName = v;
                      },
                    )),
                Flexible(
                  flex: 1,
                  child: ISSelect(
                    label: '브랜드 소속',
                    value: formData_BasicInfo.franchiseCd,
                    dataList: selectBox_brandType,
                    onChange: (v) {
                      setState(() {
                        formData_BasicInfo.franchiseCd = v;

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
                  flex: 1,
                  child: ISInput(
                    value: formData_BasicInfo.owner ?? '',
                    context: context,
                    label: '대표자명',
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                    textStyle: TextStyle(fontSize: 12),
                    onChange: (v) {
                      formData_BasicInfo.owner = v;
                    },
                    // validator: (v) {
                    //   return v.isEmpty ? '[필수] 대표자명': null;
                    // },
                  ),
                ),
                Flexible(
                    flex: 1,
                    child: ISInput(
                      autofocus: true,
                      value: formData_BasicInfo.email ?? '',
                      context: context,
                      label: '이메일',
                      prefixIcon: Icon(
                        Icons.mail,
                        color: Colors.grey,
                      ),
                      onChange: (v) {
                        formData_BasicInfo.email = v;
                      },
                    )),
                Flexible(
                  flex: 1,
                  child: ISInput(
                    value: formData_BasicInfo.mobile ?? '',
                    context: context,
                    label: '휴대폰',
                    prefixIcon: Icon(
                      Icons.phone_android,
                      color: Colors.grey,
                    ),
                    textStyle: TextStyle(fontSize: 12),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      MultiMaskedTextInputFormatter(masks: ['xxx-xxxx-xxxx', 'xxx-xxx-xxx', 'xxxx-xxxx'], separator: '-')
                    ],
                    onChange: (v) {
                      formData_BasicInfo.mobile = v.toString().replaceAll('-', '');
                    },
                    // validator: (v) {
                    //   return v.isEmpty ? '[필수] 휴대폰': null;
                    // },
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: ISInput(
                    value: formData_BasicInfo.bussOwner ?? '',
                    context: context,
                    label: '사업자 대표자명',
                    //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                    textStyle: TextStyle(fontSize: 12),
                    onChange: (v) {
                      formData_BasicInfo.bussOwner = v;
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: ISInput(
                    autofocus: true,
                    value: Utils.getStoreRegNumberFormat(formData_BasicInfo.regNo, false) ?? '',
                    context: context,
                    label: '사업자등록번호',
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      MultiMaskedTextInputFormatter(masks: ['xxx-xx-xxxxx'], separator: '-')
                    ],
                    prefixIcon: Icon(
                      Icons.confirmation_number,
                      color: Colors.grey,
                    ),
                    textStyle: TextStyle(fontSize: 12),
                    onChange: (v) {
                      formData_BasicInfo.regNo = v.toString().replaceAll('-', '');
                    },
                    // validator: (v) {
                    //   return v.isEmpty ? '[필수] 사업자등록번호': null;
                    // },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: ISSelect(
                    label: '사업자 유형',
                    value: formData_BasicInfo.bussTaxType,
                    dataList: selectBox_type,
                    onChange: (v) {
                      setState(() {
                        formData_BasicInfo.bussTaxType = v;

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
                  flex: 1,
                  child: ISInput(
                    value: formData_BasicInfo.bussCon ?? '',
                    context: context,
                    label: '업태',
                    prefixIcon: Icon(
                      Icons.assignment,
                      color: Colors.grey,
                    ),
                    textStyle: TextStyle(fontSize: 12),
                    onChange: (v) {
                      formData_BasicInfo.bussCon = v;
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: ISInput(
                    value: formData_BasicInfo.bussType ?? '',
                    context: context,
                    label: '업종',
                    prefixIcon: Icon(
                      Icons.sticky_note_2,
                      color: Colors.grey,
                    ),
                    textStyle: TextStyle(fontSize: 12),
                    onChange: (v) {
                      formData_BasicInfo.bussType = v;
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Flexible(
                  flex: 4,
                  child: ISInput(
                    readOnly: true,
                    value: formData_BasicInfo.addr1 ?? '',
                    context: context,
                    label: '구 주소(지번)',
                    prefixIcon: Icon(
                      Icons.home,
                      color: Colors.grey,
                    ),
                    textStyle: TextStyle(fontSize: 12),
                    onChange: (v) {
                      formData_BasicInfo.addr1 = v;
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    child: ISButton(
                      height: 40,
                      //padding: EdgeInsets.fromLTRB(10, 20, 0, 20),
                      textStyle: TextStyle(fontSize: 12, color: Colors.white),
                      label: '주소검색',
                      onPressed: () {
                        _searchPost();
                      },
                    ),
                  ),
                ),
              ],
            ),
            ISInput(
              readOnly: true,
              value: formData_BasicInfo.addr2 ?? '',
              context: context,
              label: '신 주소(도로명)',
              prefixIcon: Icon(
                Icons.home,
                color: Colors.grey,
              ),
              textStyle: TextStyle(fontSize: 12),
              onChange: (v) {
                formData_BasicInfo.addr2 = v;
              },
              // validator: (v) {
              //   return v.isEmpty ? '[필수] 상세주소': null;
              // },
            ),
            ISInput(
              value: formData_BasicInfo.loc ?? '',
              context: context,
              label: '상세주소',
              prefixIcon: Icon(
                Icons.home,
                color: Colors.grey,
              ),
              textStyle: TextStyle(fontSize: 12),
              onChange: (v) {
                formData_BasicInfo.loc = v;
              },
              // validator: (v) {
              //   return v.isEmpty ? '[필수] 상세주소': null;
              // },
            ),
            Divider(
              height: 20,
            ),
          ],
        ),
      ),
      isActive: _currentStep >= 0 ? true : false,
      state: _getStepperType(0),
    );
  }

  Step _getStep1() {
    return Step(
      title: Text(
        shopNewData[1].tabName,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Container(
        child: Wrap(
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: ISSelect(
                    label: '은행명',
                    value: formData_CalcInfo.bankCode,
                    dataList: selectBox_BankCode,
                    onChange: (v) {
                      formData_CalcInfo.bankCode = v;
                    },
                    onSaved: (v) {
                      //formData.cLevel = v;
                    },
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: ISInput(
                    autofocus: true,
                    value: formData_CalcInfo.accountNo ?? '',
                    context: context,
                    label: '계좌번호',
                    prefixIcon: Icon(
                      Icons.account_balance_wallet,
                      color: Colors.grey,
                    ),
                    textStyle: TextStyle(fontSize: 12),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                    onChange: (v) {
                      formData_CalcInfo.accountNo = v;
                    },
                  ),
                ),
              ],
            ),
            ISInput(
              value: formData_CalcInfo.accOwner ?? '',
              context: context,
              label: '예금주명',
              prefixIcon: Icon(
                Icons.account_box,
                color: Colors.grey,
              ),
              textStyle: TextStyle(fontSize: 12),
              onChange: (v) {
                formData_CalcInfo.accOwner = v;
              },
            ),
            Divider(
              height: 40,
            ),
          ],
        ),
      ),
      isActive: _currentStep >= 1 ? true : false,
      state: _getStepperType(1),
    );
  }

  Step _getStep2() {
    return Step(
      title: Text(
        shopNewData[2].tabName,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Container(
        child: Wrap(
          children: <Widget>[
            Row(
              children: [
                Flexible(
                  child: ISInput(
                    value: formData_ShopInfo.telNo ?? '',
                    context: context,
                    label: '매장전화번호',
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      MultiMaskedTextInputFormatter(masks: ['xxx-xxxx-xxxx', 'xxxx-xxxx-xxxx', 'xxx-xxx-xxx', 'xxxx-xxxx'], separator: '-')
                    ],
                    onChange: (v) {
                      setState(() {
                        formData_ShopInfo.telNo = v.toString().replaceAll('-', '');
                      });
                    },
                  ),
                ),
                Flexible(
                  child: Row(
                    children: [
                      Container(
                          child: Text(
                            '매장 유형',
                            style: TextStyle(fontSize: 10, color: Colors.black54),
                          ),
                          margin: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 10) //.all(5),
                          ),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: _shopTypeGbn7,
                            onChanged: (v) {
                              setState(() {
                                _shopTypeGbn7 = v;
                              });
                            },
                          ),
                          Text('포장', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: _shopTypeGbn5,
                            onChanged: (v) {
                              setState(() {
                                _shopTypeGbn5 = v;
                              });
                            },
                          ),
                          Text('배달', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: _shopTypeGbn9,
                            onChanged: (v) {
                              setState(() {
                                _shopTypeGbn9 = v;
                              });
                            },
                          ),
                          Text('예약', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: ISSelect(
                    label: '업종1',
                    value: formData_ShopInfo.itemCd1,
                    dataList: selectBox_DivCode,
                    onChange: (v) {
                      formData_ShopInfo.itemCd1 = v;
                      //loadGunguData(v);
                    },
                    onSaved: (v) {
                      //formData.cLevel = v;
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: ISSelect(
                    label: '업종2',
                    value: formData_ShopInfo.itemCd2,
                    dataList: selectBox_DivCode,
                    onChange: (v) {
                      formData_ShopInfo.itemCd2 = v;
                      //loadGunguData(v);
                    },
                    onSaved: (v) {
                      //formData.cLevel = v;
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: ISSelect(
                    label: '업종3',
                    value: formData_ShopInfo.itemCd3,
                    dataList: selectBox_DivCode,
                    onChange: (v) {
                      formData_ShopInfo.itemCd3 = v;
                      //loadGunguData(v);
                    },
                    onSaved: (v) {
                      //formData.cLevel = v;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(width: 200),
            Divider(
              height: 40,
            ),
          ],
        ),
      ),
      isActive: _currentStep >= 2 ? true : false,
      state: _getStepperType(2),
    );
  }

  Step _getStep3() {
    return Step(
      title: Text(
        shopNewData[3].tabName,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Container(
        child: Column(
          children: [
            Container(
              height: 40,
              decoration:
                  new BoxDecoration(color: _reserveYn == 'Y' ? Colors.blue[200] : Colors.red[200], borderRadius: new BorderRadius.all(Radius.circular(15))),
              child: SwitchListTile(
                dense: true,
                value: _reserveYn == 'Y' ? true : false,
                title: Text(
                  '예약 노출',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
                onChanged: (v) {
                  _reserveYn = (v == true ? 'Y' : 'N');
                  //print('formSaleTimeData.reserveYn:${formSaleTimeData.reserveYn}');
                  //formKey.currentState.save();

                  setState(() {});
                },
              ),
            ),
            Container(
              child: _reserveYn == 'Y'
                  ? Column(
                      children: [
                        Divider(),
                        ISInput(
                          value: _introduce ?? '',
                          context: context,
                          label: '한줄소개',
                          //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                          prefixIcon: Icon(Icons.home, color: Colors.grey),
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
                                  dataList: selectBox_reserve_itemCd,
                                  onChange: (v) {
                                    setState(() {
                                      _itemCd = v;
                                    });
                                  },
                                  onSaved: (v) {
                                    //formData.cLevel = v;
                                  },
                                )),
                            Flexible(
                                flex: 1,
                                child: ISSelect(
                                  label: '업종2',
                                  value: _itemCd1,
                                  dataList: selectBox_reserve_itemCd,
                                  onChange: (v) {
                                    setState(() {
                                      _itemCd1 = v;
                                    });
                                  },
                                  onSaved: (v) {
                                    //formData.cLevel = v;
                                  },
                                ))
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
                                    borderRadius: new BorderRadius.only(
                                        topRight: Radius.circular(15.0),
                                        bottomRight: Radius.circular(15.0),
                                        topLeft: Radius.circular(15.0),
                                        bottomLeft: Radius.circular(15.0))),
                                child: SwitchListTile(
                                  dense: true,
                                  value: _reveiwUseGbn == 'Y' ? true : false,
                                  title: Text(
                                    '리뷰 사용',
                                    style: TextStyle(fontSize: 12, color: Colors.white),
                                  ),
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
                                title: Text(
                                  '특화거리 다 대구로',
                                  style: TextStyle(fontSize: 12),
                                ),
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
                                title: Text(
                                  '손닙접대 하기 좋은 곳',
                                  style: TextStyle(fontSize: 12),
                                ),
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
                                title: Text(
                                  '가족 모임 하기 좋은 곳',
                                  style: TextStyle(fontSize: 12),
                                ),
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
                                title: Text(
                                  '대구 맛집 일보 다 대구로',
                                  style: TextStyle(fontSize: 12),
                                ),
                                onChanged: (v) {
                                  setState(() {
                                    _theme4 = v ? '1' : '0';
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        (selectBox_subitemCd.length != 0 && _theme1 == '1')
                            ? ISSelect(
                                label: '특화거리 카테고리 설정',
                                value: _tema_1_sub,
                                dataList: selectBox_subitemCd,
                                onChange: (v) {
                                  setState(() {
                                    _tema_1_sub = v;
                                    //print('_tema_1_sub:${_tema_1_sub}');
                                  });
                                },
                                onSaved: (v) {
                                  //formData.cLevel = v;
                                },
                              )
                            : Container(),
                        Divider(),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: [
                                  Text(
                                    '- [예약] 편의 시설',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
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
                                Checkbox(
                                  value: _conv1 == 'Y' ? true : false,
                                  onChanged: (v) {
                                    setState(() {
                                      _conv1 = v ? 'Y' : 'N';
                                    });
                                  },
                                ),
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Image.asset('assets/Convenience_2.png'),
                                Text('발렛가능', style: TextStyle(fontSize: 12)),
                                Checkbox(
                                  value: _conv2 == 'Y' ? true : false,
                                  onChanged: (v) {
                                    setState(() {
                                      _conv2 = v ? 'Y' : 'N';
                                    });
                                  },
                                ),
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Image.asset('assets/Convenience_3.png'),
                                Text('단체석', style: TextStyle(fontSize: 12)),
                                Checkbox(
                                  value: _conv3 == 'Y' ? true : false,
                                  onChanged: (v) {
                                    setState(() {
                                      _conv3 = v ? 'Y' : 'N';
                                    });
                                  },
                                ),
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Image.asset('assets/Convenience_4.png'),
                                Text('프라이빗룸', style: TextStyle(fontSize: 12)),
                                Checkbox(
                                  value: _conv4 == 'Y' ? true : false,
                                  onChanged: (v) {
                                    setState(() {
                                      _conv4 = v ? 'Y' : 'N';
                                    });
                                  },
                                ),
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Image.asset('assets/Convenience_5.png'),
                                Text('테라스', style: TextStyle(fontSize: 12)),
                                Checkbox(
                                  value: _conv5 == 'Y' ? true : false,
                                  onChanged: (v) {
                                    setState(() {
                                      _conv5 = v ? 'Y' : 'N';
                                    });
                                  },
                                ),
                              ],
                            ))
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
                                Checkbox(
                                  value: _conv6 == 'Y' ? true : false,
                                  onChanged: (v) {
                                    setState(() {
                                      _conv6 = v ? 'Y' : 'N';
                                    });
                                  },
                                ),
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Image.asset('assets/Convenience_7.png'),
                                Text('아기의자', style: TextStyle(fontSize: 12)),
                                Checkbox(
                                  value: _conv7 == 'Y' ? true : false,
                                  onChanged: (v) {
                                    setState(() {
                                      _conv7 = v ? 'Y' : 'N';
                                    });
                                  },
                                ),
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Image.asset('assets/Convenience_8.png'),
                                Text('놀이방', style: TextStyle(fontSize: 12)),
                                Checkbox(
                                  value: _conv8 == 'Y' ? true : false,
                                  onChanged: (v) {
                                    setState(() {
                                      _conv8 = v ? 'Y' : 'N';
                                    });
                                  },
                                ),
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Image.asset('assets/Convenience_9.png'),
                                Text('노키즈존', style: TextStyle(fontSize: 12)),
                                Checkbox(
                                  value: _conv9 == 'Y' ? true : false,
                                  onChanged: (v) {
                                    setState(() {
                                      _conv9 = v ? 'Y' : 'N';
                                    });
                                  },
                                ),
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Image.asset('assets/Convenience_10.png'),
                                Text('반려동물', style: TextStyle(fontSize: 12)),
                                Checkbox(
                                  value: _conv10 == 'Y' ? true : false,
                                  onChanged: (v) {
                                    setState(() {
                                      _conv10 = v ? 'Y' : 'N';
                                    });
                                  },
                                ),
                              ],
                            ))
                          ],
                        ),
                        Divider(),
                      ],
                    )
                  : Container(),
            ),
          ],
        ),
      ),
      isActive: _currentStep >= 3 ? true : false,
      state: _getStepperType(3),
    );
  }
}
