import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_image_upload.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/Model/user/userEditModel.dart';
import 'package:daeguro_admin_app/Model/user/user_info.dart';
import 'package:daeguro_admin_app/View/AgentManager/agentAccount_Controller.dart';
import 'package:daeguro_admin_app/View/UserManager/user_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

List CCenterListitems = List();

class UserInfoMine extends StatefulWidget {
  UserInfoMine();

  @override
  _UserInfoMineState createState() => _UserInfoMineState();
}

class _UserInfoMineState extends State<UserInfoMine> {
  UserInfo userInfo = UserInfo();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UserEditModel formData;

  @override
  void initState() {
    // UserInfoApi.getCurrentUserInfo().then((res) {
    //   this.userInfo = UserInfo.fromMap(res.data);
    //   this.setState(() {});
    // });
    super.initState();

    Get.put(AgentController());

    formData = new UserEditModel();

    //loadCallCenterListData();

    formData.uCode = GetStorage().read('logininfo')['uCode'];
    formData.id = GetStorage().read('logininfo')['id'];
    formData.name = GetStorage().read('logininfo')['name'];
    formData.ccCode = GetStorage().read('logininfo')['ccCode'];
    formData.working = GetStorage().read('logininfo')['working'];
    formData.level = GetStorage().read('logininfo')['level'];
    formData.memo = GetStorage().read('logininfo')['memo'];
    formData.insertDate = GetStorage().read('logininfo')['insertDate'];
    formData.modUCode = GetStorage().read('logininfo')['uCode'];
    formData.modName = GetStorage().read('logininfo')['name'];
  }

  // loadCallCenterListData() async {
  //   await AgentController.to.getDataCCenterItems();
  //
  //   CCenterListitems = AgentController.to.qDataCCenterItems;
  //
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    Widget avatar = SizedBox(
      child: ISImageUpload(
        updateAreaSize: 200,
        updateAreaDefault: Icon(Icons.person, size: 200),
        fileList: [this.userInfo?.avatarUrl],
        // onUpload: (imageBytes) {
        //   String filename = "test.png"; //todo
        //   String mimeType = mime(Path.basename(filename));
        //   var mediaType = MediaType.parse(mimeType);
        //   MultipartFile file = MultipartFile.fromBytes(imageBytes, contentType: mediaType, filename: filename);
        //   FormData formData = FormData.fromMap({"file": file});
        //   FileApi.upload(formData).then((res) {
        //     this.userInfo.avatarUrl = res.data;
        //     setState(() {});
        //   });
        // },
      ),
    );

    List<Widget> propList = <Widget>[
      // ISSearchDropdown(
      //   label: '콜센터코드',
      //   width: 180,
      //   value: formData.ccCode,
      //   onChange: (value) {
      //     setState(() {
      //       formData.ccCode = value;
      //       formKey.currentState.save();
      //     });
      //   },
      //   item: CCenterListitems.map((item) {
      //     return new DropdownMenuItem<String>(
      //         child: new Text(
      //           item['ccName'],
      //           style: TextStyle(fontSize: 13, color: Colors.black),
      //         ),
      //         value: item['ccCode']);
      //   }).toList(),
      // ),
      ISInput(
        label: 'ID',
        width: 200,
        value: formData.id,
        onSaved: (v) => {formData.id = v},
      ),
      ISInput(
        label: '이름',
        width: 200,
        value: formData.name,
        onSaved: (v) => {formData.name = v},
        //validator: (v) => v.isEmpty ? S.of(context).required : null,
      ),
      // ISInfoSelectDate(
      //   context,
      //   label: '생년월일',
      //   value: userInfo.birthday,
      //   onSaved: (v) => {userInfo.birthday = v},
      // ),
      ISSearchDropdown(
        label: 'level',
        width: 190,
        value: formData.level,
        onChange: (value) {
          setState(() {
            formData.level = value;
            formKey.currentState.save();
          });
        },
        item: [
          DropdownMenuItem(
            value: '0',
            child: Text('시스템'),
          ),
          DropdownMenuItem(
            value: '1',
            child: Text('관리자'),
          ),
          DropdownMenuItem(
            value: '3',
            child: Text('접수자'),
          ),
          DropdownMenuItem(
            value: '5',
            child: Text('영업사원'),
          ),
        ].cast<DropdownMenuItem<String>>(),
      ),
      ISSearchDropdown(
        label: 'working',
        width: 190,
        value: formData.working,
        onChange: (value) {
          setState(() {
            formData.working = value;
            formKey.currentState.save();
          });
        },
        item: [
          DropdownMenuItem(
            value: '1',
            child: Text('재직'),
          ),
          DropdownMenuItem(
            value: '3',
            child: Text('휴직'),
          ),
          DropdownMenuItem(
            value: '5',
            child: Text('퇴직'),
          ),
        ].cast<DropdownMenuItem<String>>(),
      ),
      ISInput(
        width: 100,
        value: formData.memo,
        label: 'Memo',
        onSaved: (v) {
          formData.memo = v;
        },
      ),
//       CryInput(label: '籍贯'),
    ];
    var form = _getForm(avatar, propList);
    var buttonBar = ButtonBar(
      alignment: MainAxisAlignment.start,
      children: <Widget>[
        ISButton(
          label: '저장',
          onPressed: () {
            FormState form = formKey.currentState;
            if (!form.validate()) {
              return;
            }
            form.save();

            UserController.to.putData(formData.toJson(), context);
          },
          iconData: Icons.save,
        ),
      ],
    );
    var result = Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10),
          buttonBar,
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10.0),
              children: <Widget>[form],
            ),
          ),
        ],
      ),
    );
    return result;
  }

  _getForm(Widget avatar, List<Widget> propList) {
    var form;
    // if (isDisplayDesktop(context)) {
    //   propList = propList.map((e) => e,).toList();
    //   form = Form(
    //     key: formKey,
    //     child: Row(
    //       children: [
    //         avatar,
    //         Expanded(
    //           child: Column(
    //             children: [
    //               Row(
    //                 children: [
    //                   propList[0],
    //                   propList[1],
    //                 ],
    //               ),
    //               Row(
    //                 children: [
    //                   propList[2],
    //                   propList[3],
    //                 ],
    //               ),
    //               Row(
    //                 children: [
    //                   propList[4],
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // }
    // else {
      form = Form(
        key: formKey,
        child: Column(children: [avatar] + propList),
      );
    //}
    return form;
  }
}
