
import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/View/AgentManager/agentAccount_Controller.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

List items = List();
List CCenterListitems = List();

class UserInfoDialog extends StatefulWidget {
  const UserInfoDialog({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UserInfoDialogState();
  }
}

class UserInfoDialogState extends State<UserInfoDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<SelectOptionVO> selectBox_level = [
    new SelectOptionVO(value: '0', label: '시스템'),
    new SelectOptionVO(value: '1', label: '관리자'),
    new SelectOptionVO(value: '3', label: '접수자'),
    new SelectOptionVO(value: '5', label: '영업사원')
  ];
  List<SelectOptionVO> selectBox_working = [
    new SelectOptionVO(value: '1', label: '재직'),
    new SelectOptionVO(value: '3', label: '휴직'),
    new SelectOptionVO(value: '5', label: '퇴직'),
  ];

  @override
  void initState() {
    super.initState();

    Get.put(AgentController());
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
                child: ISInput(
                  value: GetStorage().read('logininfo')['name'],
                  readOnly: true,
                  label: '이름',
                  width: 200,
                ),
              ),
              Flexible(
                flex: 1,
                child: ISInput(
                  value: GetStorage().read('logininfo')['id'],
                  readOnly: true,
                  label: '아이디',
                  width: 200,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: ISSelect(
                  ignoring: true,
                  label: '접속권한',
                  width: 190,
                  value: GetStorage().read('logininfo')['level'],
                  dataList: selectBox_level,
                ),
              ),
              Flexible(
                flex: 1,
                child: ISSelect(
                  ignoring: true,
                  label: '업무상태',
                  width: 190,
                  value: GetStorage().read('logininfo')['working'],
                  dataList: selectBox_working,
                ),
              ),
            ],
          ),
          ISInput(
            readOnly: true,
            value: GetStorage().read('logininfo')['memo'],
            label: '메모',
            width: 400,
          ),
          Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Center(child: Text('[사용자 정보 수정은 시스템 권한자 에게 문의 바랍니다]', style: TextStyle(color: Colors.blue),)))
        ],
      ),
    );

    ButtonBar buttonBar = ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        ISButton(
          label: '닫기',
          iconData: Icons.cancel,
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );

    var result = Scaffold(
      appBar: AppBar(
        title: Text('사용자 정보'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: form
            ),
          ],
        ),
      ),
      bottomNavigationBar: buttonBar,
    );
    return SizedBox(
      width: 400,
      height: 300,
      child: result,
    );
  }
}
