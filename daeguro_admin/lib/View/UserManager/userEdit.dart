
import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/Model/user/userEditModel.dart';
import 'package:daeguro_admin_app/Model/user/userListDetailModel.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/AgentManager/agentAccount_Controller.dart';
import 'package:daeguro_admin_app/View/UserManager/user_controller.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';



class UserEdit extends StatefulWidget {
  final UserListDetail sData;
  final String mCode;

  const UserEdit({Key key, this.sData, this.mCode}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UserEditState();
  }
}

class UserEditState extends State<UserEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UserListDetail formData;
  UserEditModel editData;
  bool idchk_gbn = false;
  String beforeId;
  String _passwordChk;

  List<SelectOptionVO> selectBox_ccCode = List();
  List<SelectOptionVO> selectBox_level = List();
  List<SelectOptionVO> selectBox_working = List();

  loadCallCenterListData() async {
    await AgentController.to.getDataCCenterItems(widget.mCode).then((value) {
      if(value == null){
        ISAlert(context, '콜센터정보를 가져오지 못했습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        value.forEach((element) {
          selectBox_ccCode.add(new SelectOptionVO(value: element['ccCode'], label: element['ccName']));
        });

        if (widget.sData != null) {
          int compareIndex = selectBox_ccCode.indexWhere((item) => item.value == formData.ccCode);
          if (compareIndex == -1){
            selectBox_ccCode.add(new SelectOptionVO(value: formData.ccCode, label: '[${formData.ccCode}] 존재하지않는 콜센터'));
          }
        }

        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();

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

    if (widget.sData != null) {
      formData = widget.sData;
      editData = new UserEditModel();

      editData.uCode = formData.uCode;
      editData.id = formData.id;
      editData.name = formData.name;
      editData.ccCode = formData.ccCode;
      editData.memo = formData.memo;
      editData.level = formData.level;
      editData.working = formData.working;
      editData.mobile = formData.mobile;
      editData.modUCode = GetStorage().read('logininfo')['uCode'];
      editData.modName = GetStorage().read('logininfo')['name'];

      beforeId = formData.id;

      int compareIndex = selectBox_working.indexWhere((item) => item.value == formData.working);
      if (compareIndex == -1){
        selectBox_working.add(new SelectOptionVO(value: formData.working, label: '[${formData.working}] 알수없음'));
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((c) {
      loadCallCenterListData();
    });
  }

  @override
  void dispose() {
    selectBox_ccCode.clear();
    selectBox_level.clear();
    selectBox_working.clear();

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
            label: '콜센터명',
            ignoring: true,
            value: formData.ccCode,
            dataList: selectBox_ccCode,
            onChange: (value) {
              setState(() {
                editData.ccCode = value;
                formData.ccCode = value;
                formKey.currentState.save();
              });
            },
          ),
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
                        editData.level = value;
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
                        editData.working = value;
                        formData.working = value;
                        formKey.currentState.save();
                      });
                    },
                  ),
                ),
              ]
          ),
          Row(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: ISInput(
                    value: formData.name,
                    context: context,
                    label: '이름',
                    onChange: (v) {
                      editData.name = v;
                      formData.name = v;
                    },
                    validator: (v) {
                      return v.isEmpty ? '[필수] 이름' : null;
                    },
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
                      editData.mobile = v;
                    },
                  ),
                ),
              ]
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
                } else {
                  await UserController.to.getIdCheck(formData.id, context);

                  if (this.mounted) {
                    if (UserController.to.IdCheck != 'Y' || beforeId == editData.id) {
                      ISAlert(context, '사용 가능한 ID 입니다.');
                      setState(() {
                        idchk_gbn = true;
                      });
                    } else {
                      ISAlert(context, '이미 사용중인 ID 입니다.');
                      setState(() {
                        idchk_gbn = false;
                      });
                    }
                  }
                }
              },
            ),
            onChange: (v) {
              editData.id = v;
              formData.id = v;
            },
            validator: (v) {
              return v.isEmpty ? '[필수] 아이디' : null;
            },
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
                        editData.password = v;
                      },
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
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ),
              ]
          ),
          Container(
              child: Center(
                  child: Text('[비밀번호는 표시 되지 않습니다. 수정시에만 입력하십시오.]', style: TextStyle(color: Colors.blue, fontSize: 12),)
              )
          ),
          ISInput(
            value: formData.memo,
            context: context,
            label: '메모',
            maxLines: 10,
            height: 100,
            keyboardType: TextInputType.multiline,
            onChange: (v) {
              editData.memo = v;
              formData.memo = v;
            },
          ),
          Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Center(
                  child: Text('[사용자 정보 수정은 시스템 권한자만 가능합니다]', style: TextStyle(color: Colors.blue, fontSize: 12),)
              )
          )
        ],
      ),
    );

    ButtonBar buttonBar = ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        Visibility(
          visible: AuthUtil.isAuthEditEnabled('2') == true ? true : false,
          child: ISButton(
            label: '수정',
            iconData: Icons.save,
            onPressed: () {
              FormState form = formKey.currentState;
              if (!form.validate()) {
                return;
              }

              if (idchk_gbn == false) {
                ISAlert(context, '아이디 중복체크를 확인 바랍니다.');
                return;
              }

              if(editData.password != null){
                String validatePass = Utils.validatePassword(editData.password);
                if (validatePass != null){
                  ISAlert(context, '${validatePass}');
                  return;
                }
              }


              form.save();

              if (editData.password == _passwordChk) {
                UserController.to.putData(editData.toJson(), context);

                Navigator.pop(context, true);
              } else {
                ISAlert(context, '비밀번호를 확인해 주세요.');
                //await EasyLoading.showError('비밀번호를 확인 하여 주십시오.', maskType: EasyLoadingMaskType.black, duration: Duration(seconds: 3), dismissOnTap: true);
              }
            },
          ),
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
        title: Text('사용자 정보 수정'),
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