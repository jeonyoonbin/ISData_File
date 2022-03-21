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

class AuthMenuEdit extends StatefulWidget {
  final String id;

  const AuthMenuEdit({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AuthMenuEditState();
  }
}

class AuthMenuEditState extends State<AuthMenuEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<SelectOptionVO> selectBox_pid = List();
  List<SelectOptionVO> selectBox_menuDepth = List();
  List<SelectOptionVO> selectBox_visible = List();

  Menu formData = Menu() ;

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

  loadData() async {
    await AuthController.to.getMenuData(widget.id, '').then((value) {
      if(value == null){
        ISAlert(context, '쿠폰정보를 가져오지 못했습니다. \n\n관리자에게 문의 바랍니다');
      }
      else{
        //formData = Menu.fromJson(value[0]);
        formData.id = value[0]['ID'].toString();
        formData.pid = value[0]['PID'].toString();
        formData.name = value[0]['NAME'].toString();
        formData.menuDepth = value[0]['MENUDEPTH'].toString();
        formData.icon = value[0]['ICON'].toString();
        formData.url = value[0]['URL'].toString();
        //formData.sideBarYn = value[0]['SIDEBAR_YN'].toString();

        formData.visible = value[0]['VISIBLE'].toString() == 'Y' ? true : false;
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
    selectBox_menuDepth.add(new SelectOptionVO(value: 'null', label: 'empty'));

    selectBox_visible.add(new SelectOptionVO(value: 'Y', label: '활성화'));
    selectBox_visible.add(new SelectOptionVO(value: 'N', label: '비활성화'));

    formData.visible = false;

    WidgetsBinding.instance.addPostFrameCallback((c) {
      loadParentMenu();
      loadData();
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
                        if (formData.menuDepth == '0' && v == '1' && formData.pid == 'null') {
                          formData.pid = '1';
                        }

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
          label: '삭제',
          iconData: Icons.remove_circle,
          onPressed: () {
            ISConfirm(context, '프로그램 삭제', '프로그램을 삭제 하시겠습니까?', (context) async {
              AuthController.to.deleteAuthData(formData.id.toString()).then((value) {
                if (value != null){
                  ISAlert(context, '정상처리가 되지 않았습니다. \n\n${value}');
                }
                else{
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                }
              });
            });
          },
        ),
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

            if (formData.menuDepth == 0 || formData.menuDepth == 2)
              formData.pid = '';

            if (formData.menuDepth == 2){
              formData.icon = '';
              formData.url = '';
            }

            if (formData.pid == 'null' || formData.pid == null)
              formData.pid = '';

            print('id:${formData.id}, pid:${formData.pid}, menuDepth:${formData.menuDepth}, name:${formData.name}, icon:${formData.icon}, url:${formData.url}, visibleStr:$visibleStr');

            AuthController.to.putMenuData(formData.id, formData.pid, formData.menuDepth, formData.name, formData.icon, formData.url, visibleStr).then((value) {
                if (value != null){
                  ISAlert(context, '정상처리가 되지 않았습니다. \n\n${value}');
                }
                else{
                  Navigator.pop(context, true);
                }
            });
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
        title: Text('프로그램 수정'),
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
