import 'dart:convert';

import 'package:daeguro_admin_app/Model/shop/shopposupdate.dart';
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

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:kopo/kopo.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class TaxiCallCenterRegist extends StatefulWidget {
  final List<SelectOptionVO> selectBox_ccCode;

  const TaxiCallCenterRegist({Key key, this.selectBox_ccCode}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TaxiCallCenterRegistState();
  }
}

enum RadioGbn { gbn1, gbn2 }

class TaxiCallCenterRegistState extends State<TaxiCallCenterRegist> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ShopBasicInfoModel formData_BasicInfo;
  ShopCalcInfoModel formData_CalcInfo;
  ShopInfoModel formData_ShopInfo;

  ScrollController _scrollController;

  ShopBasicInfoModel formData = ShopBasicInfoModel();

  RadioGbn _radioGbn;

  bool isReceiveDataEnabled = false;
  bool isListSaveEnabled = false;


  List<SelectOptionVO> selectBox_type = [
    new SelectOptionVO(value: '1', label: '일반'),
    new SelectOptionVO(value: '3', label: '간이'),
    new SelectOptionVO(value: '5', label: '법인'),
    new SelectOptionVO(value: '7', label: '면세')
  ];

  List<ShopNewModel> shopNewData = [
    new ShopNewModel(tabName: '지점정보', isSaved: false),
    new ShopNewModel(tabName: '부가정보', isSaved: false),
  ];
  int _currentStep = 0;

  List<SelectOptionVO> selectBox_BankCode = [];
  List<SelectOptionVO> selectBox_DivCode = [];

  List<SelectOptionVO> selectBox_mCode = List();
  List<SelectOptionVO> selectBox_ccCode = List();

  String _mCode = '2';

  loadMCodeListData() async {
    selectBox_mCode.clear();

    //await AgentController.to.getDataMCodeItems();

    List MCodeListitems = Utils.getMCodeList();

    MCodeListitems.forEach((element) {
      selectBox_mCode.add(new SelectOptionVO(value: element['mCode'], label: element['mName']));
    });

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    Get.put(AgentController());
    Get.put(TaxController());

    loadMCodeListData();

    //formData = ShopAccountD();
    //formData.shopCd = '0';

    formData_BasicInfo = ShopBasicInfoModel();
    formData_BasicInfo.mCode = '2';
    formData_BasicInfo.shopCd = '';
    formData_CalcInfo = ShopCalcInfoModel();
    formData_ShopInfo = ShopInfoModel();
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
          physics: ClampingScrollPhysics(),//NeverScrollableScrollPhysics(),
          //ScrollPhysics(),
          currentStep: _currentStep,
          onStepTapped: (step) => tapped(step),
          // onStepContinue: continued,
          // onStepCancel: cancel,
          steps: [
            _getStep0(),
            _getStep1(),
          ],
          controlsBuilder: (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) =>
              Container(
                //padding: const EdgeInsets.only(top: 20.0),
                child: ButtonBar(
                  alignment: MainAxisAlignment.start,
                  children: <Widget>[
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

                            }
                          }
                          //정산정보 저장
                          else if (_currentStep == 1) {
                            if (shopNewData[_currentStep].isSaved == false) {

                            }
                          }

                          _currentStep < shopNewData.length ? setState(() => _currentStep += 1) : null;
                        }
                    ),
                  ],
                ),
              ),
        ),
      ),
    );

    var result = Scaffold(
      appBar: AppBar(title: Text('지점(콜센터) 신규 등록'),),
      body: form,
      //bottomNavigationBar: buttonBar,
    );
    return SizedBox(
      width: 720,
      height: 900,//750,
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
      title: Text(shopNewData[0].tabName, style: TextStyle(fontWeight: FontWeight.bold),),
      subtitle: Text('새로운 지점을 생성합니다.'),
      content: Container(
        child:
        Wrap(
          children: <Widget>[
            Row(
              children: [
                Flexible(
                  flex: 2,
                  child: ISInput(
                    //autofocus: true,
                    value: formData.shopName ?? '',
                    context: context,
                    label: '지점(콜센터) 명',
                    //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                    prefixIcon: Icon(
                      Icons.store,
                      color: Colors.grey,
                    ),
                    onChange: (v) {
                      formData.shopName = v;
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Text('지점 레벨', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      Radio(
                          value: RadioGbn.gbn1,
                          groupValue: _radioGbn,
                          onChanged: (v) async {
                            _radioGbn = v;

                            if (isReceiveDataEnabled == true) {

                              setState(() {
                                //_scrollController.jumpTo(0.0);
                                isListSaveEnabled = true;
                              });
                            }
                          }),
                      Text('본사', style: TextStyle(fontSize: 12)),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Radio(
                            value: RadioGbn.gbn2,
                            groupValue: _radioGbn,
                            onChanged: (v) async {
                              _radioGbn = v;

                              if (isReceiveDataEnabled == true) {

                                setState(() {
                                  //_scrollController.jumpTo(0.0);
                                  isListSaveEnabled = true;
                                });
                              }
                            }),
                      ),
                      Text('지사', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: ISSelect(
                      label: '콜센터명',
                      ignoring: true,
                      value: formData.ccCode,
                      dataList: widget.selectBox_ccCode,
                      onChange: (v) {
                        formData.ccCode = v;
                      }),
                ),
                Flexible(
                  child: ISSelect(
                      label: '회원사',
                      ignoring: true,
                      value: formData.ccCode,
                      dataList: widget.selectBox_ccCode,
                      onChange: (v) {
                        formData.ccCode = v;
                      }),
                ),
                Flexible(
                  child: ISSelect(
                      label: '지점구분',
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
              children: <Widget>[
                Flexible(
                  flex: 1,
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
                  flex: 1,
                  child: ISInput(
                    value: Utils.getPhoneNumFormat(formData.mobile, false) ?? '',
                    context: context,
                    label: '휴대폰',
                    //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                    prefixIcon: Icon(
                      Icons.phone_android,
                      color: Colors.grey,
                    ),
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
                    flex: 1,
                    child: ISInput(
                      //autofocus: true,
                      //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                      value: formData.email ?? '',
                      context: context,
                      label: '팩스번호',
                      prefixIcon: Icon(
                        Icons.phone_android,
                        color: Colors.grey,
                      ),
                      onChange: (v) {
                        formData.email = v;
                      },
                    )),
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
            Divider(),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Text('위탁세금계산서\n발행 동의', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      Radio(
                          value: RadioGbn.gbn1,
                          groupValue: _radioGbn,
                          onChanged: (v) async {
                            _radioGbn = v;

                            if (isReceiveDataEnabled == true) {

                              setState(() {
                                //_scrollController.jumpTo(0.0);
                                isListSaveEnabled = true;
                              });
                            }
                          }),
                      Text('동의', style: TextStyle(fontSize: 12)),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Radio(
                            value: RadioGbn.gbn2,
                            groupValue: _radioGbn,
                            onChanged: (v) async {
                              _radioGbn = v;

                              if (isReceiveDataEnabled == true) {

                                setState(() {
                                  //_scrollController.jumpTo(0.0);
                                  isListSaveEnabled = true;
                                });
                              }
                            }),
                      ),
                      Text('비동의', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Text('상태', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      Radio(
                          value: RadioGbn.gbn1,
                          groupValue: _radioGbn,
                          onChanged: (v) async {
                            _radioGbn = v;

                            if (isReceiveDataEnabled == true) {

                              setState(() {
                                //_scrollController.jumpTo(0.0);
                                isListSaveEnabled = true;
                              });
                            }
                          }),
                      Text('운영', style: TextStyle(fontSize: 12)),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Radio(
                            value: RadioGbn.gbn2,
                            groupValue: _radioGbn,
                            onChanged: (v) async {
                              _radioGbn = v;

                              if (isReceiveDataEnabled == true) {

                                setState(() {
                                  //_scrollController.jumpTo(0.0);
                                  isListSaveEnabled = true;
                                });
                              }
                            }),
                      ),
                      Text('비운영', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Text('부가세부과방법', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      Radio(
                          value: RadioGbn.gbn1,
                          groupValue: _radioGbn,
                          onChanged: (v) async {
                            _radioGbn = v;

                            if (isReceiveDataEnabled == true) {
                              setState(() {
                                //_scrollController.jumpTo(0.0);
                                isListSaveEnabled = true;
                              });
                            }
                          }),
                      Text('포함', style: TextStyle(fontSize: 12)),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Radio(
                            value: RadioGbn.gbn2,
                            groupValue: _radioGbn,
                            onChanged: (v) async {
                              _radioGbn = v;

                              if (isReceiveDataEnabled == true) {

                                setState(() {
                                  //_scrollController.jumpTo(0.0);
                                  isListSaveEnabled = true;
                                });
                              }
                            }),
                      ),
                      Text('별도', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: ISSelect(
                      label: '세금계산서 분류',
                      ignoring: true,
                      value: formData.ccCode,
                      dataList: widget.selectBox_ccCode,
                      onChange: (v) {
                        formData.ccCode = v;
                      }),
                ),
                Flexible(
                  flex: 1,
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
                      child: Text(
                        '국세청조회',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
                      onPressed: () {
                        TaxController.to.getTaxData(formData.regNo).then((value) {
                          if (value == null) {
                            ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
                          } else {
                            List<String> retValue = value.split('|');
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
                Flexible(
                  flex: 1,
                  child: ISInput(
                    //autofocus: true,
                    value: formData.shopName ?? '',
                    context: context,
                    label: '등록일',
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
                  child: ISSelect(
                      label: '은행명',
                      ignoring: true,
                      value: formData.ccCode,
                      dataList: widget.selectBox_ccCode,
                      onChange: (v) {
                        formData.ccCode = v;
                      }),
                ),
                Flexible(
                  flex: 1,
                  child: ISInput(
                    //autofocus: true,
                    value: formData.shopName ?? '',
                    context: context,
                    label: '계좌번호',
                    onChange: (v) {
                      formData.shopName = v;
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: ISInput(
                    //autofocus: true,
                    value: formData.shopName ?? '',
                    context: context,
                    label: '예금주명',
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
                    value: formData.shopName ?? '',
                    context: context,
                    label: '세금계산서 분류',
                    onChange: (v) {
                      formData.shopName = v;
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: ISInput(
                    //autofocus: true,
                    value: formData.shopName ?? '',
                    context: context,
                    label: '계산서수신 이메일',
                    onChange: (v) {
                      formData.shopName = v;
                    },
                  ),
                ),
              ],
            ),
            ISInput(
              value: formData.memo ?? '',
              context: context,
              label: '적요(계산서, 명세서에 표시)',
              //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
              maxLines: 8,
              height: 80,
              keyboardType: TextInputType.multiline,
              prefixIcon: Icon(Icons.event_note, color: Colors.grey),
              textStyle: TextStyle(fontSize: 12),
              onChange: (v) {
                formData.memo = v;
              },
            ),
            ISInput(
              value: formData.memo ?? '',
              context: context,
              label: '비고',
              //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
              maxLines: 8,
              height: 80,
              keyboardType: TextInputType.multiline,
              prefixIcon: Icon(Icons.event_note, color: Colors.grey),
              textStyle: TextStyle(fontSize: 12),
              onChange: (v) {
                formData.memo = v;
              },
            ),
            Divider(height: 20,),
          ],
        ),
      ),
      isActive: _currentStep >= 0 ? true : false,
      state: _getStepperType(0),
    );
  }

  Step _getStep1() {
    return Step(
      title: Text(shopNewData[1].tabName, style: TextStyle(fontWeight: FontWeight.bold),),
      content: Container(
        child: Wrap(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(left: 8),
                child: Text('적립금', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),)
            ),
            Row(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: ISInput(
                    value: formData.owner ?? '',
                    context: context,
                    label: '적립금 입출금 횟수(일 기준)',
                    //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                    //prefixIcon: Icon(Icons.person, color: Colors.grey,),
                    textStyle: TextStyle(fontSize: 12),
                    onChange: (v) {
                      formData.owner = v;
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: ISInput(
                    value: formData.owner ?? '',
                    context: context,
                    label: '적립금 출금 금액(일 기준)',
                    //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                    //prefixIcon: Icon(Icons.person, color: Colors.grey,),
                    textStyle: TextStyle(fontSize: 12),
                    onChange: (v) {
                      formData.owner = v;
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: ISInput(
                    value: formData.owner ?? '',
                    context: context,
                    label: '적립금 입출금 횟수(월 기준)',
                    //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                    //prefixIcon: Icon(Icons.person, color: Colors.grey,),
                    textStyle: TextStyle(fontSize: 12),
                    onChange: (v) {
                      formData.owner = v;
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: ISInput(
                    value: formData.owner ?? '',
                    context: context,
                    label: '적립금 출금 금액(월 기준)',
                    //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                    //prefixIcon: Icon(Icons.person, color: Colors.grey,),
                    textStyle: TextStyle(fontSize: 12),
                    onChange: (v) {
                      formData.owner = v;
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: ISInput(
                    value: formData.owner ?? '',
                    context: context,
                    label: '적립금 최소 보유 금액',
                    //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                    //prefixIcon: Icon(Icons.person, color: Colors.grey,),
                    textStyle: TextStyle(fontSize: 12),
                    onChange: (v) {
                      formData.owner = v;
                    },
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Text('마일리지 사용 여부', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      Radio(
                          value: RadioGbn.gbn1,
                          groupValue: _radioGbn,
                          onChanged: (v) async {
                            _radioGbn = v;

                            if (isReceiveDataEnabled == true) {
                              setState(() {
                                //_scrollController.jumpTo(0.0);
                                isListSaveEnabled = true;
                              });
                            }
                          }),
                      Text('사용', style: TextStyle(fontSize: 12)),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Radio(
                            value: RadioGbn.gbn2,
                            groupValue: _radioGbn,
                            onChanged: (v) async {
                              _radioGbn = v;

                              if (isReceiveDataEnabled == true) {
                                setState(() {
                                  //_scrollController.jumpTo(0.0);
                                  isListSaveEnabled = true;
                                });
                              }
                            }),
                      ),
                      Text('미사용', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Text('마일리지 재지급 여부', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      Radio(
                          value: RadioGbn.gbn1,
                          groupValue: _radioGbn,
                          onChanged: (v) async {
                            _radioGbn = v;

                            if (isReceiveDataEnabled == true) {
                              setState(() {
                                //_scrollController.jumpTo(0.0);
                                isListSaveEnabled = true;
                              });
                            }
                          }),
                      Text('지급', style: TextStyle(fontSize: 12)),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Radio(
                            value: RadioGbn.gbn2,
                            groupValue: _radioGbn,
                            onChanged: (v) async {
                              _radioGbn = v;

                              if (isReceiveDataEnabled == true) {
                                setState(() {
                                  //_scrollController.jumpTo(0.0);
                                  isListSaveEnabled = true;
                                });
                              }
                            }),
                      ),
                      Text('미지급', style: TextStyle(fontSize: 12)),
                    ],
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
                      Text('마일리지 적립 기준', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      Radio(
                          value: RadioGbn.gbn1,
                          groupValue: _radioGbn,
                          onChanged: (v) async {
                            _radioGbn = v;

                            if (isReceiveDataEnabled == true) {
                              setState(() {
                                //_scrollController.jumpTo(0.0);
                                isListSaveEnabled = true;
                              });
                            }
                          }),
                      Text('주문금액', style: TextStyle(fontSize: 12)),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Radio(
                            value: RadioGbn.gbn2,
                            groupValue: _radioGbn,
                            onChanged: (v) async {
                              _radioGbn = v;

                              if (isReceiveDataEnabled == true) {

                                setState(() {
                                  //_scrollController.jumpTo(0.0);
                                  isListSaveEnabled = true;
                                });
                              }
                            }),
                      ),
                      Text('최종결제금액', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Text('마일리지 단위', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      Radio(
                          value: RadioGbn.gbn1,
                          groupValue: _radioGbn,
                          onChanged: (v) async {
                            _radioGbn = v;

                            if (isReceiveDataEnabled == true) {
                              setState(() {
                                //_scrollController.jumpTo(0.0);
                                isListSaveEnabled = true;
                              });
                            }
                          }),
                      Text('원', style: TextStyle(fontSize: 12)),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Radio(
                            value: RadioGbn.gbn2,
                            groupValue: _radioGbn,
                            onChanged: (v) async {
                              _radioGbn = v;

                              if (isReceiveDataEnabled == true) {

                                setState(() {
                                  //_scrollController.jumpTo(0.0);
                                  isListSaveEnabled = true;
                                });
                              }
                            }),
                      ),
                      Text('%', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: ISInput(
                    value: formData.owner ?? '',
                    context: context,
                    label: '마일리지 적립 최소 결제 금액',
                    //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                    //prefixIcon: Icon(Icons.person, color: Colors.grey,),
                    textStyle: TextStyle(fontSize: 12),
                    onChange: (v) {
                      formData.owner = v;
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: ISInput(
                    value: formData.owner ?? '',
                    context: context,
                    label: '마일리지 유효일수',
                    //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                    //prefixIcon: Icon(Icons.person, color: Colors.grey,),
                    textStyle: TextStyle(fontSize: 12),
                    onChange: (v) {
                      formData.owner = v;
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: ISInput(
                    value: formData.owner ?? '',
                    context: context,
                    label: '마일리지 적용치',
                    //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                    //prefixIcon: Icon(Icons.person, color: Colors.grey,),
                    textStyle: TextStyle(fontSize: 12),
                    onChange: (v) {
                      formData.owner = v;
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
                    value: formData.owner ?? '',
                    context: context,
                    label: '마일리지 최소 주문금액',
                    //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                    //prefixIcon: Icon(Icons.person, color: Colors.grey,),
                    textStyle: TextStyle(fontSize: 12),
                    onChange: (v) {
                      formData.owner = v;
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: ISInput(
                    value: formData.owner ?? '',
                    context: context,
                    label: '사용가능한 최소 마일리지',
                    //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                    //prefixIcon: Icon(Icons.person, color: Colors.grey,),
                    textStyle: TextStyle(fontSize: 12),
                    onChange: (v) {
                      formData.owner = v;
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: ISInput(
                    value: formData.owner ?? '',
                    context: context,
                    label: '사용가능한 최소 보유 마일리지',
                    //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                    //prefixIcon: Icon(Icons.person, color: Colors.grey,),
                    textStyle: TextStyle(fontSize: 12),
                    onChange: (v) {
                      formData.owner = v;
                    },
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Text('쿠폰 마일리지 중복 사용가능 여부', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      Radio(
                          value: RadioGbn.gbn1,
                          groupValue: _radioGbn,
                          onChanged: (v) async {
                            _radioGbn = v;

                            if (isReceiveDataEnabled == true) {
                              setState(() {
                                //_scrollController.jumpTo(0.0);
                                isListSaveEnabled = true;
                              });
                            }
                          }),
                      Text('가능', style: TextStyle(fontSize: 12)),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Radio(
                            value: RadioGbn.gbn2,
                            groupValue: _radioGbn,
                            onChanged: (v) async {
                              _radioGbn = v;

                              if (isReceiveDataEnabled == true) {

                                setState(() {
                                  //_scrollController.jumpTo(0.0);
                                  isListSaveEnabled = true;
                                });
                              }
                            }),
                      ),
                      Text('불가능', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: ISInput(
                    value: formData.owner ?? '',
                    context: context,
                    label: '쿠폰 사용 최소주문금액',
                    //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                    //prefixIcon: Icon(Icons.person, color: Colors.grey,),
                    textStyle: TextStyle(fontSize: 12),
                    onChange: (v) {
                      formData.owner = v;
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Text('행복페이 할인 기준', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      Radio(
                          value: RadioGbn.gbn1,
                          groupValue: _radioGbn,
                          onChanged: (v) async {
                            _radioGbn = v;

                            if (isReceiveDataEnabled == true) {
                              setState(() {
                                //_scrollController.jumpTo(0.0);
                                isListSaveEnabled = true;
                              });
                            }
                          }),
                      Text('주문 금액', style: TextStyle(fontSize: 12)),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Radio(
                            value: RadioGbn.gbn2,
                            groupValue: _radioGbn,
                            onChanged: (v) async {
                              _radioGbn = v;

                              if (isReceiveDataEnabled == true) {                                setState(() {
                                  //_scrollController.jumpTo(0.0);
                                  isListSaveEnabled = true;
                                });
                              }
                            }),
                      ),
                      Text('최종결제금액', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Text('행복페이 단위', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      Radio(
                          value: RadioGbn.gbn1,
                          groupValue: _radioGbn,
                          onChanged: (v) async {
                            _radioGbn = v;

                            if (isReceiveDataEnabled == true) {

                              setState(() {
                                //_scrollController.jumpTo(0.0);
                                isListSaveEnabled = true;
                              });
                            }
                          }),
                      Text('원', style: TextStyle(fontSize: 12)),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Radio(
                            value: RadioGbn.gbn2,
                            groupValue: _radioGbn,
                            onChanged: (v) async {
                              _radioGbn = v;

                              if (isReceiveDataEnabled == true) {
                                setState(() {
                                  //_scrollController.jumpTo(0.0);
                                  isListSaveEnabled = true;
                                });
                              }
                            }),
                      ),
                      Text('%', style: TextStyle(fontSize: 12)),
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
                    value: formData.owner ?? '',
                    context: context,
                    label: '행복페이 적용치',
                    //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                    //prefixIcon: Icon(Icons.person, color: Colors.grey,),
                    textStyle: TextStyle(fontSize: 12),
                    onChange: (v) {
                      formData.owner = v;
                    },
                  ),
                ),
                Flexible(
                  child: ISSelect(
                      label: '결제금액 절사기준',
                      ignoring: true,
                      value: formData.ccCode,
                      dataList: widget.selectBox_ccCode,
                      onChange: (v) {
                        formData.ccCode = v;
                      }),
                ),
              ],
            ),
            Flexible(
              flex: 1,
              child: ISInput(
                value: formData.owner ?? '',
                context: context,
                label: '원격지원 url',
                //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                //prefixIcon: Icon(Icons.person, color: Colors.grey,),
                textStyle: TextStyle(fontSize: 12),
                onChange: (v) {
                  formData.owner = v;
                },
              ),
            ),
            Row(
              children: [
                Flexible(
                  flex: 2,
                  child: ISSelect(
                      label: '가상계좌 은행명',
                      ignoring: true,
                      value: formData.ccCode,
                      dataList: widget.selectBox_ccCode,
                      onChange: (v) {
                        formData.ccCode = v;
                      }),
                ),
                Flexible(
                  flex: 2,
                  child: ISInput(
                    value: formData.owner ?? '',
                    context: context,
                    label: '가상계좌 번호',
                    //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                    //prefixIcon: Icon(Icons.person, color: Colors.grey,),
                    textStyle: TextStyle(fontSize: 12),
                    onChange: (v) {
                      formData.owner = v;
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: ISButton(
                    height: 35,
                    //padding: EdgeInsets.fromLTRB(10, 20, 0, 10),
                    textStyle: TextStyle(fontSize: 12, color: Colors.white),
                    label: '할당',
                    onPressed: () {
                    },
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  flex: 1,
                  child: ISButton(
                    height: 35,
                    //padding: EdgeInsets.fromLTRB(10, 20, 0, 10),
                    textStyle: TextStyle(fontSize: 12, color: Colors.white),
                    label: '해지',
                    onPressed: () {
                      //if (formData.useGbn == 'Y')
                      _searchPost();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isActive: _currentStep >= 1 ? true : false,
      state: _getStepperType(1),
    );
  }
}
