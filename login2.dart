import 'dart:async';
import 'dart:convert';

import 'package:daeguro_ceo_app/common/constant.dart';
import 'package:daeguro_ceo_app/common/serverInfo.dart';
import 'package:daeguro_ceo_app/config/auth_service.dart';
import 'package:daeguro_ceo_app/iswidgets/is_alertdialog.dart';
import 'package:daeguro_ceo_app/iswidgets/is_dialog.dart';
import 'package:daeguro_ceo_app/iswidgets/is_progressDialog.dart';
import 'package:daeguro_ceo_app/iswidgets/isd_input.dart';
import 'package:daeguro_ceo_app/layout/responsive.dart';
import 'package:daeguro_ceo_app/models/shopChangePassModel.dart';
import 'package:daeguro_ceo_app/network/DioClient.dart';
import 'package:daeguro_ceo_app/screen/LogInManager/loginController.dart';
import 'package:daeguro_ceo_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    FocusNode focusID = FocusNode();
    FocusNode focusPW = FocusNode();
    // FocusNode focusOTP = FocusNode();

    final appTheme = context.watch<AppTheme>();

    Get.put(LoginController());

    //https://jh-industry.tistory.com/123  로그인 처리작업 필요

    return Scaffold(
      // resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          controller: LoginController.to.scrollController,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            constraints: const BoxConstraints(minHeight: 660),
            child: SafeArea(
              child: GetBuilder<LoginController>(
                builder: (controller) {
                  return Column(
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        color: Colors.white,
                        height: 70,
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 23, right: 20),
                                  child: SizedBox(
                                    width: double.infinity,
                                    //child: Text('version ${ServerInfo.APP_VERSION}', textAlign: TextAlign.right, style: TextStyle(fontFamily: 'NotoSansKR', fontSize: 12, color: const Color(0xffFFFFFF).withOpacity(0.5),),),
                                    child: Text('version ${ServerInfo.APP_VERSION}', textAlign: TextAlign.right, style: TextStyle(fontFamily: FONT_FAMILY, fontSize: 12, color: const Color(0xff000000).withOpacity(0.5),),),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topRight,
                                  margin: const EdgeInsets.only(top: 0, right: 15),
                                  padding: const EdgeInsets.all(0),
                                  width: double.infinity,
                                  child: TextButton(
                                    style: const ButtonStyle(padding: MaterialStatePropertyAll(EdgeInsets.zero)),
                                    onPressed: () {
                                      Get.offAllNamed('/');
                                    },
                                    child: Text('업데이트', style: TextStyle(fontFamily: FONT_FAMILY,fontSize: 12, color: const Color(0xff000000).withOpacity(0.5),),),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 70,),
                      Container(
                        width: Responsive.isMobile(context) ? double.infinity : 460,
                        height: 520,
                        //color: Colors.yellow,
                        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            border: Responsive.isMobile(context) ? const Border.symmetric(vertical: BorderSide.none, horizontal: BorderSide.none) : Border.all(color: Colors.grey.shade300, width: 1.0,) //BorderSide()
                        ),
                        child:  Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Image(image: AssetImage('images/img_header_logo.png')),
                            const Padding(
                              padding: EdgeInsets.only(top: 41, left: 20),
                              child: SizedBox(
                                width: double.infinity,
                                child: Text('사장님 아이디', textAlign: TextAlign.left, style: TextStyle(fontFamily: FONT_FAMILY, fontSize: 13, color: Color(0xff000000),),),
                              ),
                            ),
                            const SizedBox(height: 4,),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: SizedBox(
                                height: 45,
                                width: double.infinity,
                                child: RawKeyboardListener(
                                  focusNode: focusID,
                                  onKey: (event) {
                                    if (event.logicalKey == LogicalKeyboardKey.tab) {
                                      FocusScope.of(context).nextFocus();
                                    }
                                  },
                                  child: TextField(
                                      controller: controller.idTextController,
                                      style: const TextStyle(fontSize: 16, fontWeight: FONT_NORMAL, fontFamily: FONT_FAMILY),
                                      onTap: () {
                                        controller.keyboardVisible();
                                      },
                                      textInputAction: TextInputAction.next,
                                      onSubmitted: (_) => {
                                        FocusScope.of(context).nextFocus(),
                                      },
                                      decoration: InputDecoration(
                                          isDense: true,
                                          enabledBorder: OutlineInputBorder(
                                            //borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),//(color: Colors.black12, width: 1.0),
                                          ),
                                          focusedBorder: const OutlineInputBorder(
                                            //borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                                          ),
                                          hintText: '사장님 아이디 입력',
                                          hintStyle: const TextStyle(fontSize: 16, color: Color(0xff999999), fontFamily: FONT_FAMILY),
                                          errorBorder: controller.submitError1 ? const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffBA292F))) : null
                                      ),
                                      onChanged: (String value) => {
                                        controller.submitError1 = false,
                                        controller.update(),
                                        controller.loginID = (value),
                                      },
                                      onEditingComplete: () => {
                                        FocusScope.of(context).nextFocus(),
                                      }
                                  ),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 20, left: 20),
                              child: SizedBox(
                                width: double.infinity,
                                child: Text('사장님 비밀번호', textAlign: TextAlign.left, style: TextStyle(fontFamily: FONT_FAMILY, fontSize: 13, color: Color(0xff000000),),),
                              ),
                            ),
                            const SizedBox(height: 4,),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: SizedBox(
                                height: 45,
                                width: double.infinity,
                                child: RawKeyboardListener(
                                  focusNode: focusPW,
                                  child: TextField(
                                      obscureText: true,
                                      style: const TextStyle(fontSize: 16, fontWeight: FONT_NORMAL, fontFamily: FONT_FAMILY),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        enabledBorder: OutlineInputBorder(
                                          //borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),//(color: Colors.black12, width: 1.0),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          //borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                                        ),
                                        hintText: '사장님 비밀번호 입력',
                                        hintStyle: const TextStyle(fontSize: 16, color: Color(0xff999999), fontFamily: FONT_FAMILY),
                                      ),
                                      onChanged: (String value) => {
                                        controller.submitError1 = false,
                                        controller.update(),
                                        controller.loginPW = (value),
                                      },
                                      onEditingComplete: () {
                                        if (controller.loginID == '' || controller.loginPW == '') {
                                          ISAlert(context, content: '아이디와 비밀번호를 입력해 주세요.');
                                          return;
                                        }
                                        setLogin(context, appTheme, controller);
                                      }
                                    // FocusScope.of(context).nextFocus(),
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 10, left: 10),
                              child: Row(
                                children: [
                                  Checkbox(
                                    // tristate: !controller.saveID,
                                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    checkColor: Colors.white,
                                    // fillColor: MaterialStateProperty.resolveWith(getColor),
                                    activeColor: const Color(0xff01CAFF),
                                    materialTapTargetSize: MaterialTapTargetSize.padded,
                                    side: const BorderSide(width: 1),//, color: Color(0xff01CAFF)),
                                    value: controller.isIdSaved,
                                    onChanged: (value) {
                                      controller.isIdSaved = value!;
                                      controller.update();
                                    },
                                  ),
                                  const SizedBox(
                                    // width: double.infinity,
                                    height: 24,
                                    child: Text('아이디 저장', textAlign: TextAlign.left, style: TextStyle(fontFamily: FONT_FAMILY, fontSize: 16, color: Color(0xff000000),),),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                              child: SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: TextButton(style: TextButton.styleFrom(backgroundColor: const Color(0xff01CAFF)),
                                  child: const Text("로그인", style: TextStyle(fontFamily: FONT_FAMILY, fontWeight: FONT_BOLD, fontSize: 24, color: Color(0xffFFFFFF)),),
                                  onPressed: () async {

                                    if (controller.loginID == '' || controller.loginPW == '') {
                                      ISAlert(context, content: '아이디와 비밀번호를 입력해 주세요.');
                                      return;
                                    }
                                    setLogin(context, appTheme, controller);

                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ),
    );
  }

  setLogin(BuildContext context, AppTheme appTheme, LoginController controller) async {
    String password = '';
    String passwordConfirm = '';

    await showDialog(context: context, barrierColor: Colors.transparent,builder: (context) => FutureProgressDialog(LoginController.to.connectedlogIn())
    ).then((value) {
      if (value == '') {
        ISAlert(context, content: '정상 조회가 되지 않았습니다. \n\n다시 시도해 주세요.');
        //Navigator.of(context).pop;
      }
      else{
        String code = value.split('|').first;
        String msg = value.split('|').last;

        if (code == '00') {
          appTheme.currentShopStatusGbn = AuthService.ShopStatus;

          if (AuthService.SHOPPASSWORD != 'eornfh') {
            context.go('/');
          } else {
            showDialog(
              barrierDismissible: false,
                context: context,
                builder: (context) {
                  return ContentDialog(
                    constraints: const BoxConstraints(maxWidth: 460.0, maxHeight: 250),
                    contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                    title: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [Icon(Icons.warning_rounded, color: Colors.redAccent, size: 25), SizedBox(width: 5), Text('초기 비밀번호 설정', style: TextStyle(fontSize: 15, fontWeight: FONT_BOLD))],
                    ),
                    content: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('※ 초기 비밀번호 변경 후 사용가능합니다.', style: TextStyle(fontFamily: FONT_FAMILY, fontWeight: FONT_NORMAL, color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                            const SizedBox(height: 6.0),
                            Row(
                              children: [
                                const Text('변경 비밀번호', style: TextStyle(fontFamily: FONT_FAMILY, fontWeight: FONT_NORMAL)),
                                const SizedBox(width: 10.0),
                                Expanded(
                                  child: Material(
                                    child: ISInput(
                                      obscureText: true,
                                      label: '비밀번호를 입력해주세요.',
                                      value: password,
                                      onChange: (v) {
                                        password = v;
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                const Text('비밀번호 확인', style: TextStyle(fontFamily: FONT_FAMILY, fontWeight: FONT_NORMAL)),
                                const SizedBox(width: 10.0),
                                Expanded(
                                  child: Material(
                                    child: ISInput(
                                      obscureText: true,
                                      label: '비밀번호를 다시 입력해주세요.',
                                      value: passwordConfirm,
                                      onChange: (v) {
                                        passwordConfirm = v;
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      SizedBox(
                        width: double.infinity / 2,
                        child: FilledButton(
                          style: ButtonStyle(
                            backgroundColor: const MaterialStatePropertyAll(Colors.blueAccent),
                            shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))),
                          ),
                          onPressed: () async {
                            if (password != passwordConfirm) {
                              ISAlert(context, content: '변경 비밀번호를 확인 바랍니다.');
                              return;
                            } else if (password == 'eornfh' || passwordConfirm == 'eornfh') {
                              ISAlert(context, content: '초기 비밀번호는 사용할 수 없습니다.\n다른 비밀번호를 입력해 주세요');
                              return;
                            }
                            ShopChangePassModel shopChangePass = ShopChangePassModel();
                            shopChangePass.id = AuthService.SHOPID;
                            shopChangePass.shopCd = AuthService.SHOPCD;
                            shopChangePass.mCode = AuthService.mCode;
                            shopChangePass.current = 'eornfh';
                            shopChangePass.password = password;
                            shopChangePass.password_confirm = passwordConfirm;
                            shopChangePass.mallYn = AuthService.MallUseGbn;
                            shopChangePass.uCode = AuthService.uCode;
                            shopChangePass.uName = AuthService.uName;

                            await DioClient().post(ServerInfo.RESTURL_MYPASS_UPDATE, data: shopChangePass.toJson()).then((value) {
                              AuthService.SHOPPASSWORD = '';

                              if (value.data['code'] == '00') {
                                ISAlert(context, content: '비밀번호가 변경되었습니다. \n잠시 후 메인페이지로 이동합니다.');
                                Timer(const Duration(seconds: 1), () {
                                  context.go('/');
                                });
                              } else {
                                ISAlert(context, content: '비밀번호 변경에 실패하였습니다. \n(${value.data['msg']})');
                              }
                            });
                          },
                          child: const Text('비밀번호 변경'),
                        ),
                      ),
                    ],
                  );
                });
          }
        } else {
          controller.submitError1 = false;
          controller.update();

          ISAlert(context, content: '로그인 실패.\n→ ${msg} ');
        }
      }
    });
  }
}
