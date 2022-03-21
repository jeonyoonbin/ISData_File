
import 'dart:convert';

import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Model/shop/shopmenuoptionsetting.dart';
import 'package:daeguro_admin_app/View/ShopManager/Menu/shopMenuOptionSettingAdd.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ShopMenuOptionSetting extends StatefulWidget {
  final String shopCode;
  final String menuCode;
  const ShopMenuOptionSetting({Key key, this.shopCode, this.menuCode}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShopMenuOptionSettingState();
  }
}

class ShopMenuOptionSettingState extends State<ShopMenuOptionSetting> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  //final ScrollController _scrollController = ScrollController();
  final List<ShopMenuOptionSettingModel> dataList = <ShopMenuOptionSettingModel>[];

  bool isSaveEnabled = false;

  _query() {
    //print('call _query() menuCode->'+widget.menuCode);
    //formKey.currentState.save();

    loadData();
  }

  loadData() async {
    dataList.clear();

    await ShopController.to.getMenuOptionGroupData(widget.menuCode).then((value) async {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        value.forEach((e) {
          ShopMenuOptionSettingModel temp = ShopMenuOptionSettingModel.fromJson(e);
          dataList.add(temp);
        });


        if (isSaveEnabled == true){
          await Future.delayed(Duration(milliseconds: 500), () async {
            List<String> sortDataList = [];
            dataList.forEach((element) {
              sortDataList.add(element.menuOptionGroupCd);
            });

            if (sortDataList.length != 0) {
              String jsonData = jsonEncode(sortDataList);
              await ShopController.to.updateMenuSort('2', jsonData, context);
            }

            isSaveEnabled = false;
          });
        }
      }
    });

    //if(this.mounted) {
      setState(() {
      });
    //}
  }

  _addOptionGroup() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: ShopMenuOptionSettingAdd(shopCode: widget.shopCode, menuCode: widget.menuCode,),
      ),
    ).then((v) async {
      if (v != null) {
        isSaveEnabled = true;
        _query();

      }
    });
  }

  _deleteMenuOptionGroup(String menuOptionGroupCd){
    ISConfirm(context, '메뉴옵션그룹 삭제', '메뉴옵션그룹을 삭제합니다. \n\n계속 진행 하시겠습니까?', (context) async {
      //print('등록 Success!!!');

      await ShopController.to.deleteMenuOptionGroupData(menuOptionGroupCd, context);

      //EasyLoading.showSuccess('삭제 성공', maskType: EasyLoadingMaskType.clear);

      Navigator.of(context).pop();

      await Future.delayed(Duration(milliseconds: 500), (){
        isSaveEnabled = true;
        loadData();
      });
    });
  }

  _editListSort(String div, List<String> sortDataList) async {
    String jsonData = jsonEncode(sortDataList);

    //print('data set->'+jsonData);
    await ShopController.to.updateMenuSort(div, jsonData, context);

    await Future.delayed(Duration(milliseconds: 500), () {
      loadData();
    });
  }

  @override
  void initState() {
    super.initState();

    //Get.put(AgentController());

    //formKey.currentState.reset();

    WidgetsBinding.instance.addPostFrameCallback((c) {
      //loadSidoData();
      isSaveEnabled = true;
      _query();
    });
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Text('옵션 상세 설정은 [옵션 편집]에서 할수 있습니다.', style: TextStyle(fontSize: 12.0),),
          ),
        ],
      ),
    );

    ButtonBar buttonBar = ButtonBar(
      alignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(right: 15),
          child: ISButton(
              label: '옵션그룹 추가', iconData: Icons.add,
              onPressed: () => _addOptionGroup()),
        ),
      ],
    );

    var result = Scaffold(
      appBar: AppBar(
        title: Text('옵션 설정'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          buttonBar,
          form,
          SizedBox(height: 10),
          Expanded(
            child: dataList == null ? Text('Data is Empty') : ReorderableListView(
              onReorder: _onMenuOptionReorder,
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.only(bottom: 8.0),
              children: List.generate(
                  dataList.length,
                (index) {
                  return GestureDetector(
                    // onTap: (){
                    //   Navigator.pushNamed(context, '/editor', arguments: UserController.to.userData[index]);
                    // },
                    key: Key('$index'),
                    child: Card(
                      color: Colors.white,
                      elevation: 2.0,
                      child: ListTile(
                        //leading: Text(dataList[index].siguName),
                        title: Text(dataList[index].optionGroupName ?? '--', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                        subtitle: Text(dataList[index].optionNames ?? '--', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),),
                        trailing: Container(
                          padding: EdgeInsets.only(right: 30),
                          child: OutlineButton(
                            child: Text('해제', style: TextStyle(color: Colors.red),),
                            borderSide: BorderSide(color: Colors.red),
                            onPressed: (){
                              _deleteMenuOptionGroup(dataList[index].menuOptionGroupCd);
                            },
                          ),
                        ),
                      ),
                    ),
                  ) ;
                }
              )
            ),
          ),
          // Expanded(
          //   child: ListView.builder(
          //     padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
          //     itemCount: dataList.length,
          //     itemBuilder: (BuildContext context, int index) {
          //       return dataList != null ? GestureDetector(
          //         // onTap: (){
          //         //   Navigator.pushNamed(context, '/editor', arguments: UserController.to.userData[index]);
          //         // },
          //         child: Card(
          //           color: Colors.white,
          //           elevation: 2.0,
          //           child: ListTile(
          //             //leading: Text(dataList[index].siguName),
          //             title: Text(dataList[index].optionGroupName ?? '--', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
          //             subtitle: Text(dataList[index].optionNames ?? '--', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
          //             trailing: OutlineButton(
          //               child: Text('해제', style: TextStyle(color: Colors.red),),
          //               borderSide: BorderSide(color: Colors.red),
          //               onPressed: (){
          //                 _deleteMenuOptionGroup(dataList[index].menuOptionGroupCd);
          //               },
          //             ),
          //           ),
          //         ),
          //       ) : Text('Data is Empty');
          //     },
          //   ),
          // ),
        ],
      ),
      //bottomNavigationBar: buttonBar,
    );
    return SizedBox(
      width: 420,
      height: 580,//isDisplayDesktop(context) ? 580 : 1000,
      child: result,
    );
  }

  void _onMenuOptionReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final ShopMenuOptionSettingModel item = dataList.removeAt(oldIndex);
      dataList.insert(newIndex, item);

      List<String> sortDataList = [];
      dataList.forEach((element) {
        sortDataList.add(element.menuOptionGroupCd);
      });
      _editListSort('2', sortDataList);
    });
  }
}

