
import 'dart:convert';

import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Model/shop/shopmenuoptiongroup.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ShopMenuOptionSettingAdd extends StatefulWidget {
  final String shopCode;
  final String menuCode;
  const ShopMenuOptionSettingAdd({Key key, this.shopCode, this.menuCode}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShopMenuOptionSettingAddState();
  }
}

class ShopMenuOptionSettingAddState extends State<ShopMenuOptionSettingAdd> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<String> selectedOptionGroup = [];

  final List<ShopMenuOptionGroupModel> dataGroupList = <ShopMenuOptionGroupModel>[];

  loadOptionGroupData() async {
    //print('------------ loadOptionGroupData widget.shopCode:'+widget.shopCode+', widget.menuCode:'+widget.menuCode);
    dataGroupList.clear();

    await ShopController.to.getOptionGroupData(widget.shopCode, widget.menuCode).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        value.forEach((e) async {
          ShopMenuOptionGroupModel child = ShopMenuOptionGroupModel.fromJson(e);
          if (child.selected == '' || child.selected == 'N')
            child.isFlag = false;
          else
            child.isFlag = true;

          dataGroupList.add(child);
        });
        //print('dataList.length:'+dataGroupList.length.toString());
      }
    });

    //if(this.mounted) {
      setState(() {

      });
    //}
  }

  @override
  void initState() {
    super.initState();


    WidgetsBinding.instance.addPostFrameCallback((c) {
      loadOptionGroupData();
    });
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Text('새로운 옵션그룹이 필요하신 경우 [새 옵션그룹]을 추가해주세요.', style: TextStyle(fontSize: 12.0),),
          ),
        ],
      ),
    );

    ButtonBar buttonBar = ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        ISButton(
          label: '저장',
          iconData: Icons.save,
          onPressed: () async {
            FormState form = formKey.currentState;
            if (!form.validate()) {
              return;
            }

            form.save();

            dataGroupList.forEach((element) {
              if (element.isFlag == true)
                selectedOptionGroup.add(element.optionGroupCd);
            });

            String jsonData = jsonEncode(selectedOptionGroup);

            // //print('formData--> '+formData.toJson().toString());



            await ShopController.to.postMenuOptionGroupData(widget.menuCode, jsonData, context);

            //EasyLoading.showSuccess('등록 성공', maskType: EasyLoadingMaskType.clear);

            Navigator.pop(context, true);
          },
        ),
        ISButton(
          label: '닫기',
          iconData: Icons.close,
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );

    var result = Scaffold(
      appBar: AppBar(
        title: Text('옵션 그룹 추가'),
      ),
      body : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          form,
          SizedBox(height: 10),
          Divider(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
              itemCount: dataGroupList.length,
              itemBuilder: (BuildContext context, int index) {
                return dataGroupList != null ? GestureDetector(
                  // onTap: (){
                  //   Navigator.pushNamed(context, '/editor', arguments: UserController.to.userData[index]);
                  // },
                  child: Card(
                    color: Colors.white,
                    elevation: 2.0,
                    child: CheckboxListTile(
                      activeColor: Colors.blue,
                      controlAffinity: ListTileControlAffinity.leading,
                      value: dataGroupList[index].isFlag,
                      title: Text(dataGroupList[index].optionGroupName ?? '--', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                      subtitle: Text(dataGroupList[index].optionNames ?? '--', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                      onChanged: (bool val){
                        setState(() {
                          dataGroupList[index].isFlag = val;
                        });
                      },
                    ),
                  ),
                ) : Text('Data is Empty');
              },
            ),
          ),
          Divider(),
        ],
      ),
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       SizedBox(height: 20),
      //       form,
      //     ],
      //   ),
      // ),
      bottomNavigationBar: buttonBar,
    );
    return SizedBox(
      width: 380,
      height: 540,//isDisplayDesktop(context) ? 540 : 1000,
      child: result,
    );
  }
}


