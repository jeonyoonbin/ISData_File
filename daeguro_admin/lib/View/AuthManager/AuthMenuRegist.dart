import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/Model/menu.dart';
import 'package:daeguro_admin_app/View/AuthManager/auth_controller.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class AuthMenuRegist extends StatefulWidget {
  const AuthMenuRegist({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AuthMenuRegistState();
  }
}

class AuthMenuRegistState extends State<AuthMenuRegist> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<SelectOptionVO> selectBox_pid = List();
  List<SelectOptionVO> selectBox_menuDepth = List();
  List<SelectOptionVO> selectBox_visible = List();

  Menu formData;

  loadParentMenu() async {
    await AuthController.to.getMenuData('', '0').then((value) {
      if(value == null){
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else{
        value.forEach((element) {
          selectBox_pid.add(new SelectOptionVO(value: element['ID'].toString(), label: '[${element['ID'].toString()}] ${element['NAME']}'));
        });

      }
    });

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    Get.put(AuthController());

    selectBox_pid.clear();
    selectBox_menuDepth.clear();
    selectBox_visible.clear();

    selectBox_menuDepth.add(new SelectOptionVO(value: '0', label: '사이드바(parent)'));
    selectBox_menuDepth.add(new SelectOptionVO(value: '1', label: '사이드바(child)'));
    selectBox_menuDepth.add(new SelectOptionVO(value: '2', label: '서브메뉴'));

    selectBox_visible.add(new SelectOptionVO(value: 'Y', label: '활성화'));
    selectBox_visible.add(new SelectOptionVO(value: 'N', label: '비활성화'));

    formData = Menu();
    formData.visible = false;
    formData.menuDepth = '0';

    WidgetsBinding.instance.addPostFrameCallback((c) {
      loadParentMenu();
    });
  }

  @override
  void dispose() {
    selectBox_menuDepth.clear();
    selectBox_visible.clear();

    selectBox_menuDepth = null;
    selectBox_visible = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: new BoxDecoration(
                      color: formData.visible == true ? Colors.blue[200] : Colors.red[200],
                      borderRadius: new BorderRadius.circular(6)),
                  child: SwitchListTile(
                    dense: true,
                    value: formData.visible,
                    title: Text('사용여부', style: TextStyle(fontSize: 12, color: Colors.white),),
                    onChanged: (v) {
                      setState(() {
                        formData.visible = v;
                        formKey.currentState.save();
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
                child: ISSelect(
                    label: '메뉴계층',
                    value: formData.menuDepth,
                    dataList: selectBox_menuDepth,
                    onChange: (v) {
                      setState(() {
                        formData.menuDepth = v;
                        formKey.currentState.save();
                      });
                    }),
              ),
              Flexible(
                flex: 1,
                child: formData.menuDepth == '1' || formData.menuDepth == '2' ? ISSelect(
                    label: '상위메뉴',
                    value: formData.pid,
                    dataList: selectBox_pid,
                    onChange: (v) {
                      setState(() {
                        formData.pid = v;
                        formKey.currentState.save();
                      });
                    }) : Container(),
              ),
            ],
          ),
          ISInput(
            value: formData.name,
            autofocus: true,
            context: context,
            label: '프로그램명',
            // inputFormatters: <TextInputFormatter>[
            //   FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9ㄱ-ㅎ가-힣$@!%*#?~^<>,.&+=]'))
            // ],
            onChange: (v) {
              formData.name = v;
            },
          ),
          formData.menuDepth == '0' || formData.menuDepth == '1' ? ISInput(
            value: formData.icon,
            context: context,
            label: '아이콘',
            maxLines: 1,
            onChange: (v) {
              formData.icon = v;
            },
          ) : Container(),
          formData.menuDepth == '0' || formData.menuDepth == '1' ? ISInput(
            value: formData.url,
            context: context,
            label: '메뉴URL',
            maxLines: 1,
            onChange: (v) {
              formData.url = v;
            },
          ) : Container(),
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

            if (formData.name == '' || formData.name == null) {
              ISAlert(context, '프로그램명을 확인해주세요.');
              return;
            }

            form.save();

            String visibleStr =  formData.visible == true ? 'Y' : 'N';

            if (formData.menuDepth == 0) {
              formData.pid = '';
            }
            else if (formData.menuDepth == 2){
              formData.icon = '';
              formData.url = '';
            }

            if (formData.pid == null || formData.pid == 'null' || formData.pid == '') {
              if (formData.menuDepth == 1 || formData.menuDepth == 2){
                ISAlert(context, '상위메뉴를 선택해주세요.');
                return;
              }

              formData.pid = '';
            }

            //print('id:${formData.id}, pid:${formData.pid}, menuDepth:${formData.menuDepth}, name:${formData.name}, icon:${formData.icon}, url:${formData.url}, visibleStr:$visibleStr');

            AuthController.to.postMenuData(formData.pid, formData.menuDepth, formData.name, formData.icon, formData.url, visibleStr).then((value) {
              if (value != null){
                ISAlert(context, '정상처리가 되지 않았습니다. \n\n${value}');
              }
              else{
                Navigator.pop(context, true);
              }
            });

            // if (formData.password == _passwordChk) {
            //   UserController.to.postData(formData.toJson(), context);
            //   Navigator.pop(context, true);
            // }
            // else {
            //   ISAlert(context, '비밀번호를 확인해 주세요.');
            //   //await EasyLoading.showError('비밀번호를 확인 하여 주십시오.', maskType: EasyLoadingMaskType.black, duration: Duration(seconds: 3), dismissOnTap: true);
            // }
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
        title: Text('프로그램 등록'),
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
      height: 400,
      child: result,
    );
  }
}
