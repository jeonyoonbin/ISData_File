import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/Model/user/userRegistModel.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/AgentManager/agentAccount_Controller.dart';
import 'package:daeguro_admin_app/View/UserManager/user_controller.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserRegist extends StatefulWidget {
  const UserRegist({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UserRegistState();
  }
}

class UserRegistState extends State<UserRegist> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


//List CCenterListitems = List();

  List<SelectOptionVO> selectBox_mCode = List();
  List<SelectOptionVO> selectBox_ccCode = List();
  List<SelectOptionVO> selectBox_level = List();
  List<SelectOptionVO> selectBox_working = List();

  userRegistModel formData;
  String _couponCnt;
  String _passwordChk;
  bool idchk_gbn = false;
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

  loadCallCenterListData() async {
    selectBox_ccCode.clear();

    await AgentController.to.getDataCCenterItems(_mCode).then((value) {
      if(value == null){
        ISAlert(context, '콜센터정보를 가져오지 못했습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        value.forEach((element) {
          selectBox_ccCode.add(new SelectOptionVO(
              value: element['ccCode'], label: element['ccName']));
        });

        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();

    Get.put(UserController());
    Get.put(AgentController());

    selectBox_level.clear();
    selectBox_working.clear();

    selectBox_level.add(new SelectOptionVO(value: '0', label: '시스템'));
    selectBox_level.add(new SelectOptionVO(value: '1', label: '관리자'));
    selectBox_level.add(new SelectOptionVO(value: '5', label: '영업사원'));
    selectBox_level.add(new SelectOptionVO(value: '6', label: '오퍼레이터'));

    selectBox_working.add(new SelectOptionVO(value: '1', label: '재직'));
    selectBox_working.add(new SelectOptionVO(value: '3', label: '휴직'));
    selectBox_working.add(new SelectOptionVO(value: '5', label: '퇴직'));

    loadMCodeListData();
    loadCallCenterListData();

    formData = userRegistModel();

    formData.level = '1';
    formData.working = '1';
    formData.modName = GetStorage().read('logininfo')['name'];  // 03.28 등록자명 추가
  }

  @override
  void dispose() {
    selectBox_mCode.clear();
    selectBox_ccCode.clear();
    selectBox_level.clear();
    selectBox_working.clear();

    selectBox_mCode = null;
    selectBox_ccCode = null;
    selectBox_level = null;
    selectBox_working = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
          ISSelect(
              label: '*회원사명',
              value: _mCode,
              dataList: selectBox_mCode,
              onChange: (v) {
                setState(() {
                  _mCode = v;
                  formData.ccCode = '';
                  loadCallCenterListData();
                  formKey.currentState.save();
                });
              }),
          ISSelect(
              // validator: (v) {
              //   return v == null ? '[필수] 콜센터명' : null;
              // },
              label: '콜센터명',
              value: formData.ccCode,
              dataList: selectBox_ccCode,
              onChange: (v) {
                setState(() {
                  formData.ccCode = v;
                  formKey.currentState.save();
                });
              }),
          Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: ISSelect(
                  label: '접속권한',
                  value: formData.level,
                  dataList: selectBox_level,
                  onChange: (value) {
                    setState(() {
                      formData.level = value;
                      formKey.currentState.save();
                    });
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: ISSelect(
                  label: '업무상태',
                  value: formData.working,
                  dataList: selectBox_working,
                  onChange: (value) {
                    setState(() {
                      formData.working = value;
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
                  value: formData.name,
                  autofocus: true,
                  context: context,
                  label: '이름',
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9ㄱ-ㅎ가-힣$@!%*#?~^<>,.&+=]'))
                  ],
                  onChange: (v) {
                    formData.name = v;
                  },
                  // validator: (v) {
                  //   return v.isEmpty ? '[필수] 이름' : null;
                  // },
                ),
              ),
              Flexible(
                flex: 1,
                child: ISInput(
                  value: Utils.getPhoneNumFormat(formData.mobile, false),
                  context: context,
                  label: '휴대전화',
                  onChange: (v) {
                    formData.mobile = v;
                  },
                ),
              ),
            ],
          ),
          ISInput(
            value: formData.id,
            context: context,
            label: '아이디',
            maxLines: 1,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9ㄱ-ㅎ가-힣$@!%*#?~^<>,.&+=]'))
            ],
            suffixIcon: MaterialButton(
              color: Colors.blue,
              minWidth: 40,
              child: Text('ID 중복체크', style: TextStyle(color: Colors.white, fontSize: 12),),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
              onPressed: () async {
                FormState form = formKey.currentState;
                form.save();

                if (formData.id == '') {
                  ISAlert(context, 'ID를 입력 해 주십시오');
                  setState(() {
                    idchk_gbn = false;
                  });
                }
                else {
                  await UserController.to.getIdCheck(formData.id, context).then((value) {
                    if (value != null){
                      if (value == 'Y') {
                        ISAlert(context, '이미 사용중인 ID 입니다.');
                        setState(() {
                          idchk_gbn = false;
                        });
                      } else {
                        ISAlert(context, '사용 가능한 ID 입니다.');
                        setState(() {
                          idchk_gbn = true;
                        });
                      }
                    }
                  });
                }
              },
            ),
            onChange: (v) {
              formData.id = v;
            },
            // validator: (v) {
            //   return v.isEmpty ? '[필수] 아이디' : null;
            // },
          ),
          Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Container(
                  height: 40,
                  margin: EdgeInsets.all(8.0),
                  child: TextFormField(
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9ㄱ-ㅎ가-힣$@!%*#?~^<>,.&+=]'))
                    ],
                    decoration: InputDecoration(
                      isDense: false,
                      filled: true,
                      labelText: '비밀번호', labelStyle: TextStyle(fontSize: 13),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: const BorderRadius.all(Radius.circular(6)),
                      ),
                      //hintText: label,
                      contentPadding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
                    ),
                    onChanged: (v) {
                      formData.password = v;
                    },
                    // validator: (v) {
                    //   if (v.isEmpty) {
                    //     return '비밀번호를 입력해 주세요.';
                    //   }
                    //   return null;
                    // },
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  height: 40,
                  margin: EdgeInsets.all(8.0),
                  child: TextFormField(
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9ㄱ-ㅎ가-힣$@!%*#?~^<>,.&+=]'))
                    ],
                    decoration: InputDecoration(
                      isDense: false,
                      filled: true,
                      labelText: '비밀번호 확인', labelStyle: TextStyle(fontSize: 13),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: const BorderRadius.all(Radius.circular(6)),
                      ),
                      //hintText: label,
                      contentPadding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
                    ),
                    onChanged: (v) {
                      _passwordChk = v;
                    },
                    // validator: (v) {
                    //   if (v.isEmpty) {
                    //     return '비밀번호를 입력해 주세요.';
                    //   }
                    //   return null;
                    // },
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),

          ISInput(
            value: formData.memo,
            context: context,
            label: '메모',
            maxLines: 8,
            height: 100,
            keyboardType: TextInputType.multiline,
            onChange: (v) {
              formData.memo = v;
            },
          ),
          // Row(
          //   children: <Widget>[
          //     SizedBox(width: 230),
          //     Container(
          //         margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
          //         child: IconButton(icon: Icon(Icons.check, color: idchk_gbn == false ? Colors.transparent : Colors.green))),
          //     ISButton(
          //       label: 'ID 중복체크',
          //       textStyle: TextStyle(fontSize: 15, color: Colors.white),
          //       onPressed: () async {
          //
          //       },
          //     ),
          //   ],
          // ),
        ],
      ),
    );

    ButtonBar buttonBar = ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        ISButton(
          label: '저장',
          iconData: Icons.save,
          onPressed: () {
            FormState form = formKey.currentState;
            if (!form.validate()) {
              return;
            }

            if (formData.ccCode == '' || formData.ccCode == null) {
              ISAlert(context, '콜센터명을 확인해주세요.');
              return;
            }

            if (formData.name == '' || formData.name == null) {
              ISAlert(context, '이름을 확인해주세요.');
              return;
            }

            if (formData.id == '' || formData.id == null) {
              ISAlert(context, '아이디를 확인해주세요.');
              return;
            }

            if (formData.password == '' || formData.password == null) {
              ISAlert(context, '패스워드를 확인해주세요.');
              return;
            }

            if (idchk_gbn == false) {
              ISAlert(context, '아이디 중복체크를 확인해주세요.');
              return;
            }

            String validatePass = Utils.validatePassword(formData.password);
            if (validatePass != null){
              ISAlert(context, '${validatePass}');
              return;
            }

            form.save();

            if (formData.password == _passwordChk) {
              UserController.to.postData(formData.toJson(), context);
              Navigator.pop(context, true);
            } else {
              ISAlert(context, '비밀번호를 확인해 주세요.');
              //await EasyLoading.showError('비밀번호를 확인 하여 주십시오.', maskType: EasyLoadingMaskType.black, duration: Duration(seconds: 3), dismissOnTap: true);
            }
          },
        ),
        ISButton(
          label: '취소',
          iconData: Icons.cancel,
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );

    var result = Scaffold(
      appBar: AppBar(
        title: Text('사용자 등록'),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: form
          ),
        ],
      ),
      bottomNavigationBar: buttonBar,
    );
    return SizedBox(
      width: 400,
      height: 566,
      child: result,
    );
  }
}
