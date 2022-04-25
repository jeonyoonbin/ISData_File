import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:daeguro_admin_app/ISWidget/is_checkbox.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Model/menu.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/AgentManager/agentAccount_Controller.dart';
import 'package:daeguro_admin_app/View/AuthManager/auth_controller.dart';
import 'package:daeguro_admin_app/View/Layout/layout_controller.dart';
import 'package:daeguro_admin_app/View/UserManager/user_controller.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;
import 'package:js/js.dart';
import 'package:intl/intl.dart';

@JS('getip')
external void showConfirm();

@JS('setIpToDart')
external set _setIpToDart(void Function() f);

class LoginSMS extends StatefulWidget {
  @override
  LoginSMSState createState() => LoginSMSState();
}

class AppState {
  bool loading;
  String user;

  AppState(this.loading, this.user);
}

class LoginSMSState extends State<LoginSMS> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String _ip;

  String _loginId = '';
  String _loginPw = '';

  //String _loginOtpConfirm = '';

  FocusNode focusNode_IDInput;
  FocusNode focusNode_PassInput;
  FocusNode focusNode_LoginBtn;

  //FocusNode focusNode_OTPInput;
  //FocusNode focusNode_OTPRequestBtn;

  bool isRemberID = false;

  //bool isOTPConfirm = false;
  String rememberIDStr = '';

  int i = 0;

  final app = AppState(true, '');

  Timer _timer;

  //int confirmTimeMax = 90;
  //int confirmTimeCount = 0;

  //bool isOtpSendTextEnabled = false;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  _delay() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        loadRememberID();
        app.loading = false;
      });
    });
  }

  loadRememberID() async {
    _prefs.then((value) {
      rememberIDStr = value.getString('rememberID');

      if (rememberIDStr == null || rememberIDStr == '') {
        _loginId = '';
        rememberIDStr = '';
        isRemberID = false;
      } else {
        _loginId = rememberIDStr;
        isRemberID = true;
      }

      setState(() {
        app.loading = false;
      });
    });

    //rememberIDStr = await prefs.getString('rememberID');//GetStorage().read('rememberID');
  }

  @override
  void initState() {
    super.initState();
    Get.put(UserController());
    Get.put(AgentController());
    Get.put(AuthController());

    //_delay();
    WidgetsBinding.instance.addPostFrameCallback((c) {
      loadRememberID();

      focusNode_IDInput = FocusNode();
      focusNode_PassInput = FocusNode();
      focusNode_LoginBtn = FocusNode();
      //focusNode_OTPInput = FocusNode();
      //focusNode_OTPRequestBtn = FocusNode();

      // IP 정보 가져오기(내부망에서는 안됨 - 주석처리 필요)
      _setIpToDart = allowInterop(_setIpDartFunction);
      showConfirm();

      //_tempLogin();
    });
  }

  void _setIpDartFunction() {
    _ip = html.querySelector('#Getip').innerText;
    setState(() {});
  }

  @override
  void dispose() {
    //print('Login dispose()');
    //timerReset();

    if (focusNode_IDInput != null) focusNode_IDInput.dispose();
    if (focusNode_PassInput != null) focusNode_PassInput.dispose();
    if (focusNode_LoginBtn != null) focusNode_LoginBtn.dispose();

    //if (focusNode_OTPInput != null)           focusNode_OTPInput.dispose();
    //if (focusNode_OTPRequestBtn != null)      focusNode_OTPRequestBtn.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (app.loading) return _loading();
    if (app.user.isEmpty) return _loginbuildContent();
  }

  Widget _loading() {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  Widget _loginbuildContent() {
    //TextEditingController _textEditingController = TextEditingController(text: _loginOtpConfirm);
    // if (_loginOtpConfirm != null){
    //   _textEditingController.value = _textEditingController.value.copyWith(
    //     selection: TextSelection.fromPosition(TextPosition(offset: _loginOtpConfirm.length)),
    //   );
    // }

    return Container(
      //16CBFC
      color: Colors.blue.shade200, //Color.fromARGB(255, 0, 202, 255),//Colors.blue.shade200,//.fromARGB(160, 001, 201, 255),//Colors.cyan.shade100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Image(
          //   width: double.infinity,
          //   height: double.infinity,
          //   image: AssetImage('assets/loginback.jpg'),
          //   fit: BoxFit.cover,
          // ),
          Container(
            //decoration: new BoxDecoration(color: Colors.white, borderRadius: new BorderRadius.circular(50)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(color: Colors.black26, offset: Offset(2.0, 2.0), blurRadius: 4.0),
              ],
            ),
            width: 500,
            height: 650,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10),
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      SizedBox(height: 200, width: 200, child: Image.asset('assets/BI_6.png')),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Text('관리앱 ${ServerInfo.APP_VERSION}'),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  width: 300,
                  child: Column(
                    children: [
                      // TextField(
                      //   focusNode: focusNode_IDInput,
                      //   controller: TextEditingController(text: rememberIDStr.toString()),
                      //   autofocus: isRemberID == true ? false : true,
                      //   obscureText: false,
                      //   onEditingComplete: () => FocusScope.of(context).nextFocus(),
                      //   // keyboardType: TextInputType.emailAddress,
                      //   decoration: InputDecoration(
                      //       fillColor: Color(0xffdefcfc),
                      //       filled: true,
                      //       border: new OutlineInputBorder(
                      //           borderSide: BorderSide(width: 0, style: BorderStyle.none), borderRadius: const BorderRadius.all(const Radius.circular(10))),
                      //       labelText: 'id',
                      //       labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blue)),
                      //   onChanged: (text) {
                      //     _loginId = (text);
                      //     rememberIDStr = (text);
                      //   },
                      //   style: TextStyle(
                      //     fontSize: 15,
                      //     color: Colors.black,
                      //   ),
                      // ),
                      // Container(
                      //   margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      //   child: TextField(
                      //     focusNode: focusNode_PassInput,
                      //     autofocus: isRemberID == true ? true : false,
                      //     controller: TextEditingController(text: _loginPw.toString()),
                      //     onEditingComplete: () => FocusScope.of(context).requestFocus(focusNode_LoginBtn),
                      //     //FocusScope.of(context).nextFocus(),
                      //     decoration: InputDecoration(
                      //         fillColor: Color(0xffdefcfc),
                      //         filled: true,
                      //         border: new OutlineInputBorder(
                      //             borderSide: BorderSide(width: 0, style: BorderStyle.none), borderRadius: const BorderRadius.all(const Radius.circular(10))),
                      //         labelText: 'password',
                      //         labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blue)),
                      //     onChanged: (text) {
                      //       _loginPw = (text);
                      //     },
                      //     onSubmitted: (v) {
                      //       //_login();
                      //     },
                      //     obscureText: true,
                      //     enableSuggestions: false,
                      //     autocorrect: false,
                      //     style: TextStyle(fontSize: 15, color: Colors.black),
                      //   ),
                      // ),
                      RawKeyboardListener(
                        focusNode: focusNode_IDInput,
                        onKey: (event) {
                          if (event.logicalKey == LogicalKeyboardKey.tab) {
                            //print('tabkey');
                          }
                        },
                        child: TextField(
                          controller: TextEditingController(text: rememberIDStr.toString()),
                          autofocus: isRemberID == true ? false : true,
                          obscureText: false,
                          onEditingComplete: () => FocusScope.of(context).nextFocus(),
                          // keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              fillColor: Color(0xffdefcfc),
                              filled: true,
                              border: new OutlineInputBorder(
                                  borderSide: BorderSide(width: 0, style: BorderStyle.none), borderRadius: const BorderRadius.all(const Radius.circular(10))),
                              labelText: 'id',
                              labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blue)),
                          onChanged: (text) {
                            _loginId = (text);
                            rememberIDStr = (text);
                          },
                          onSubmitted: (v) {
                            FocusScope.of(context).nextFocus();
                          },
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      RawKeyboardListener(
                        focusNode: focusNode_PassInput,
                        onKey: (event) {
                          if (event.logicalKey == LogicalKeyboardKey.tab) {
                            //print('tabkey');
                          }
                        },
                        child: TextField(
                          controller: TextEditingController(text: _loginPw.toString()),
                          autofocus: isRemberID == true ? true : false,
                          // keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              fillColor: Color(0xffdefcfc),
                              filled: true,
                              border: new OutlineInputBorder(
                                  borderSide: BorderSide(width: 0, style: BorderStyle.none), borderRadius: const BorderRadius.all(const Radius.circular(10))),
                              labelText: 'password',
                              labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blue)),
                          onChanged: (text) {
                            _loginPw = (text);
                          },
                          onSubmitted: (v) {
                            _login();
                          },
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ),
                      // Visibility(
                      //   visible: isOTPConfirm,
                      //   child: Container(
                      //     margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      //     child: TextField(
                      //       focusNode: focusNode_OTPInput,
                      //       autofocus: isOTPConfirm,
                      //       controller: _textEditingController,//TextEditingController(text: _loginOtpConfirm),
                      //       decoration: InputDecoration(fillColor: Color(0xffdefcfc), filled: true, border: new OutlineInputBorder(borderSide: BorderSide(width: 0, style: BorderStyle.none), borderRadius: const BorderRadius.all(const Radius.circular(10))), labelText: '인증번호', labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blue)),
                      //       onChanged: (text) {
                      //         _loginOtpConfirm = (text);
                      //       },
                      //       onSubmitted: (v) {
                      //         if (_loginOtpConfirm == '' || _loginOtpConfirm == null) {
                      //           ISAlert(context, '인증번호요청 후에 로그인하여 주세요.');
                      //           FocusScope.of(context).requestFocus(focusNode_OTPInput);
                      //           return;
                      //         }
                      //
                      //         _otpConfirm();
                      //       },
                      //       enableSuggestions: false,
                      //       autocorrect: false,
                      //       style: TextStyle(fontSize: 15, color: Colors.black),
                      //     ),
                      //   ),
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end, //.spaceBetween,
                        children: [
                          // RaisedButton.icon(
                          //   focusNode: focusNode_OTPRequestBtn,
                          //   elevation: 0,
                          //   highlightElevation: 0,
                          //   color: Colors.grey,
                          //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                          //   icon: Icon(Icons.phone_android, size: 16, color: Colors.white),
                          //   label: Text(confirmTimeCount == 0 ? '인증번호요청' : '인증번호요청 [${confirmTimeCount}초]', style: TextStyle(fontSize: 12, color: Colors.white)),
                          //   onPressed: () {
                          //     if (_loginId == '' || _loginId == null) {
                          //       ISAlert(context, '아이디를 입력하여 주세요.');
                          //       FocusScope.of(context).requestFocus(focusNode_IDInput);
                          //       return;
                          //     }
                          //
                          //     if (_loginPw == '' || _loginPw == null) {
                          //       ISAlert(context, '패스워드를 입력하여 주세요.');
                          //       FocusScope.of(context).requestFocus(focusNode_PassInput);
                          //       return;
                          //     }
                          //
                          //     _login();
                          //
                          //     //return;
                          //   },
                          // ),
                          ISCheckbox(
                              label: 'ID 저장',
                              value: isRemberID,
                              onChanged: (v) async {
                                setState(() {});
                                //SharedPreferences prefs = await SharedPreferences.getInstance();
                                if (isRemberID == true) {
                                  //await prefs.clear();
                                  isRemberID = false;
                                } else {
                                  //await prefs.setString('rememberID', rememberIDStr.toString());
                                  isRemberID = true;
                                }
                              }),
                        ],
                      ),
                      // Container(
                      //   alignment: Alignment.center,
                      //   child: AnimatedOpacity(
                      //     opacity: isOtpSendTextEnabled ? 1.0 : 0.0,
                      //     duration: Duration(microseconds: 800),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         Icon(Icons.info_outline, color: Colors.red, size: 14,),
                      //         Text('인증번호가 발송되었습니다.', style: TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.bold),),
                      //       ],
                      //     ),
                      //     onEnd: () async {
                      //       setState(() {
                      //         FocusScope.of(context).requestFocus(focusNode_OTPInput);
                      //       });
                      //
                      //       await Future.delayed(Duration(seconds: 10), (){
                      //         setState(() {
                      //           isOtpSendTextEnabled = false;
                      //         });
                      //       });
                      //     },
                      //   ),
                      // )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                          margin: EdgeInsets.all(10),
                          width: 250,
                          height: 40,
                          child: ElevatedButton(
                            focusNode: focusNode_LoginBtn,
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))),
                            child: Text('로그인'),
                            onPressed: () {
                              // if (_loginId == '' || _loginId == null) {
                              //   ISAlert(context, '아이디를 입력하여 주세요.');
                              //   FocusScope.of(context).requestFocus(focusNode_IDInput);
                              //   return;
                              // }
                              //
                              // if (_loginPw == '' || _loginPw == null) {
                              //   ISAlert(context, '패스워드를 입력하여 주세요.');
                              //   FocusScope.of(context).requestFocus(focusNode_PassInput);
                              //   return;
                              // }

                              // if (_loginId == '' || _loginId == null || _loginPw == '' || _loginPw == null || isOTPConfirm == false){
                              //   ISAlert(context, '인증번호요청 후에 로그인하여 주세요.');
                              //   return;
                              // }

                              // if (isOTPConfirm == false) {
                              //   ISAlert(context, '인증번호요청 후에 로그인하여 주세요.');
                              //   return;
                              // }

                              // if (_loginOtpConfirm == '' || _loginOtpConfirm == null) {
                              //   ISAlert(context, '인증번호를 입력하여 주세요.');
                              //   return;
                              // }

                              //_otpConfirm();
                              _login();
                            },
                          )),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '* 인성데이타 대구 공공 배달앱 관리자 사이트 입니다.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Text(
                  '* 아이디 및 비밀번호 분실 시, 시스템 관리자에게 문의해주시기 바랍니다.',
                  style: TextStyle(fontSize: 14),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _tempLogin() async {
    var value = {
      'uCode': '48',
      'ccCode': null,
      'name': '이성훈',
      'id': 'sbjd98',
      'password': null,
      'level': '0',
      'mobile': null,
      'working': '1',
      'memo': '',
      'modUCode': null,
      'modName': null,
      'insertDate': '2021-05-06 오후 7:08:02',
      'retireDate': ''
    };

    DateFormat currentTimeFormat = new DateFormat('yyyy-MM-dd HH:mm:ss');

    GetStorage().write('logininfo', value);
    GetStorage().write('logininfoDateTime', currentTimeFormat.format(DateTime.now()));

    Utils.setLoginState(true);

    LayoutController layoutController = Get.find();
    layoutController.init();

    // if (focusNode_IDInput != null)            focusNode_IDInput.dispose();
    // if (focusNode_PassInput != null)          focusNode_PassInput.dispose();
    // if (focusNode_OTPInput != null)           focusNode_OTPInput.dispose();
    // if (focusNode_OTPRequestBtn != null)      focusNode_OTPRequestBtn.dispose();

    Navigator.popAndPushNamed(context, '/');
  }

  loadAuthData() async {
    //print('loadAuthData id:${pid}');
    String ucode = GetStorage().read('logininfo')['uCode'];
    await AuthController.to.getAuthData(ucode, '', '').then((value) {
      if (value == null) {
        ISAlert(context, '권한정보가 정상조회 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        if (value.length != 0) {
          AuthUtil.MenuAuthItem.clear();
          AuthUtil.MenuAuthItem = value;

          // AuthUtil.MenuAuthItem.forEach((element) {
          //   print('MenuAuthItem e:${element.toString()}');
          // });
        } else {
          //_selectedComment = '하위메뉴가 없습니다.';
        }
      }
    });
  }

  _login() async {
    if (_loginId == '' || _loginId == null) {
      ISAlert(context, '아이디를 입력하여 주세요.');
      FocusScope.of(context).requestFocus(focusNode_IDInput);
      return;
    }

    if (_loginPw == '' || _loginPw == null) {
      ISAlert(context, '패스워드를 입력하여 주세요.');
      FocusScope.of(context).requestFocus(focusNode_PassInput);
      return;
    }

    var bytes = utf8.encode(_loginPw);
    var digiest = sha256.convert(bytes);

    //print('digiest:${digiest.toString()}');

    await UserController.to.getLoginData(_loginId, digiest.toString(), context).then((value) async {
      if (value != null) {
        // timerReset();
        //
        // confirmTimeCount = confirmTimeMax;
        //
        // _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
        //   if (confirmTimeCount == 0) {
        //     ISAlert(context, '인증시간이 초과되었습니다.');
        //     timerReset();
        //   }
        //   else {
        //     setState(() {
        //       confirmTimeCount--;
        //     });
        //   }
        // });
        //
        // if (value['uCode'] != null) {
        //   DateFormat currentTimeFormat = new DateFormat('yyyy-MM-dd HH:mm:ss');
        //
        //   GetStorage().write('logininfo', value);
        //   GetStorage().write('logininfoDateTime', currentTimeFormat.format(DateTime.now()));
        //
        //
        //   isOTPConfirm = true;
        //   isOtpSendTextEnabled = true;
        // }
        // else {
        //   Utils.setLoginState(false);
        // }

        //timerReset();

        DateFormat currentTimeFormat = new DateFormat('yyyy-MM-dd HH:mm:ss');

        //print('value:${value.toString()}');

        GetStorage().write('logininfo', value);
        GetStorage().write('logininfoDateTime', currentTimeFormat.format(DateTime.now()));

        await AuthController.to.getSideBarData(GetStorage().read('logininfo')['uCode']).then((value) {
          if (value == null) {
            ISAlert(context, '메뉴 정보를 가져오지 못했습니다. \n\n관리자에게 문의 바랍니다');
          } else {
            //parent Menu loading...
            value.forEach((element) {
              if (element['MENUDEPTH'].toString() == '0' &&
                  element['READ_YN'].toString() == 'Y') //(element['VISIBLE'].toString() == 'Y' || element['READ_YN'].toString() == 'Y'))
                AuthUtil.SideBarMenu.add(Menu(
                    id: element['ID'].toString(),
                    name: element['NAME'].toString(),
                    menuDepth: element['MENUDEPTH'].toString(),
                    icon: element['ICON'].toString(),
                    pid: null,
                    url: element['URL'].toString(),
                    visible: element['VISIBLE'].toString() == 'Y' ? true : false));
            });

            //child Menu loading...
            value.forEach((element) {
              if (element['MENUDEPTH'].toString() == '1' &&
                  element['READ_YN'].toString() == 'Y') //(element['VISIBLE'].toString() == 'Y' || element['READ_YN'].toString() == 'Y'))
                AuthUtil.SideBarMenu.add(Menu(
                    id: element['ID'].toString(),
                    name: element['NAME'].toString(),
                    menuDepth: element['MENUDEPTH'].toString(),
                    icon: element['ICON'].toString(),
                    pid: element['PID'].toString(),
                    url: element['URL'].toString(),
                    visible: element['VISIBLE'].toString() == 'Y' ? true : false));
            });

            // int checkIdx = Utils.sideBarMenu.indexWhere((item) => item.id.toString() == '50');
            // if (GetStorage().read('logininfo')['uCode'].toString() != '48' || GetStorage().read('logininfo')['uCode'].toString() != '35')
            //   Utils.sideBarMenu.removeAt(checkIdx);
            //
            // int checkIdx2 = Utils.sideBarMenu.indexWhere((item) => item.id.toString() == '82');
            // if (GetStorage().read('logininfo')['uCode'].toString() != '48' || GetStorage().read('logininfo')['uCode'].toString() != '35')
            //   Utils.sideBarMenu.removeAt(checkIdx2);
          }
        });

        loadAuthData();

        await AgentController.to.getDataMCodeItems().then((value) {
          if (value == null) {
            ISAlert(context, '회원사정보를 가져오지 못했습니다. \n\n관리자에게 문의 바랍니다');
          } else {
            GetStorage().write('MCodeListinfo', value);
          }
        });

        //MCodeListitems = AgentController.to.qDataMCodeItems;

        SharedPreferences prefs = await SharedPreferences.getInstance();

        if (isRemberID == false) {
          await prefs.clear();
        } else {
          await prefs.setString('rememberID', rememberIDStr.toString());
        }

        Utils.setLoginState(true);

        UserController.to.postAddLoginLog(GetStorage().read('logininfo')['uCode'], '0', _ip, context);

        LayoutController layoutController = Get.find();
        layoutController.init();

        Navigator.popAndPushNamed(context, '/');

        List MCodeListitems = Utils.getMCodeList();
        //print('----- MCodeListitems:${MCodeListitems.toString()}');

        setState(() {});
      } else {
        Utils.setLoginState(false);

        _loginPw = '';

        FocusScope.of(context).requestFocus(focusNode_PassInput);

        setState(() {});
      }
    });
  }

// _otpConfirm() async {
//   await UserController.to.getOtpConfirmData(GetStorage().read('logininfo')['uCode'], _loginOtpConfirm, context).then((value) async {
//     if (value == true) {
//       timerReset();
//
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//
//       if (isRemberID == false) {
//         await prefs.clear();
//       }
//       else {
//         await prefs.setString('rememberID', rememberIDStr.toString());
//       }
//
//       Utils.setLoginState(true);
//
//       UserController.to.postAddLoginLog(GetStorage().read('logininfo')['uCode'], '0', _ip, context);
//
//       LayoutController layoutController = Get.find();
//       layoutController.init();
//
//       Navigator.popAndPushNamed(context, '/');
//     }
//     else {
//       timerReset();
//
//       FocusScope.of(context).requestFocus(focusNode_OTPInput);
//     }
//   });
// }
//
// timerReset() {
//   if (_timer != null && _timer.isActive == true) {
//     _timer.cancel();
//     _loginOtpConfirm = '';
//     confirmTimeCount = 0;
//
//     setState(() {
//     });
//   }
// }
}