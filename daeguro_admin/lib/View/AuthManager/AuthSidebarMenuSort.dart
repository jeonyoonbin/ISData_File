
import 'dart:convert';

import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Model/menu.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/AuthManager/AuthMenuEdit.dart';
import 'package:daeguro_admin_app/View/AuthManager/auth_controller.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AuthSidebarMenuSort extends StatefulWidget {
  final String shopCode;
  final String menuCode;
  const AuthSidebarMenuSort({Key key, this.shopCode, this.menuCode}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AuthSidebarMenuSortState();
  }
}

class AuthSidebarMenuSortState extends State<AuthSidebarMenuSort> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  //final ScrollController _scrollController = ScrollController();
  final List<Menu> dataList = <Menu>[];
  final List<Menu> dataChildList = <Menu>[];

  String selectChildComment = '';
  //bool isSaveEnabled = false;

  _query() {
    //print('call _query() menuCode->'+widget.menuCode);
    //formKey.currentState.save();

    selectChildComment = '메뉴를 선택해주세요.';

    loadData();
  }

  loadData() async {
    dataList.clear();

    await AuthController.to.getMenuData('', '0').then((value) async {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        value.forEach((element) {
          Menu temp = Menu();//Menu.fromJson(e);
          temp.id = element['ID'].toString();
          temp.pid = element['PID'].toString();
          temp.name = element['NAME'].toString();
          temp.menuDepth = element['MENUDEPTH'].toString();
          temp.icon = element['ICON'].toString();
          temp.url = element['URL'].toString();

          temp.visible = element['VISIBLE'].toString() == 'Y' ? true : false;


          dataList.add(temp);
        });
      }
    });

    //if(this.mounted) {
    setState(() {
    });
    //}
  }

  loadChildData(String id) async {
    dataChildList.clear();

    await AuthController.to.getChildMenuData(id).then((value) async {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        value.forEach((element) {
          Menu temp = Menu();//Menu.fromJson(e);
          temp.id = element['ID'].toString();
          temp.pid = element['PID'].toString();
          temp.name = element['NAME'].toString();
          temp.menuDepth = element['MENUDEPTH'].toString();
          temp.icon = element['ICON'].toString();
          temp.url = element['URL'].toString();

          temp.visible = element['VISIBLE'].toString() == 'Y' ? true : false;


          dataChildList.add(temp);
        });
      }
    });

    if (dataChildList.length == 0)
      selectChildComment = '하위메뉴가 없습니다.';
    else
      selectChildComment = '';//'메뉴를 선택해주세요.';

    //if(this.mounted) {
    setState(() {
    });
    //}
  }

  _edit(String id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: AuthMenuEdit(id: id,),
      ),
    ).then((v) async {
      if (v != null) {
        await Future.delayed(Duration(milliseconds: 500), () {
          //loadAuthData(_selectedUcode);
        });
      }
    });
  }

  _editListSort(List<String> sortDataList) async {
    String jsonData = jsonEncode(sortDataList);

    //print('data set->'+jsonData);
    await AuthController.to.updateAdminMenuSort(jsonData).then((value) async {
      if (value != null){
        ISAlert(context, '정상처리가 되지 않았습니다. \n\n${value}');
      }
      else{
        await Future.delayed(Duration(milliseconds: 500), () {
          loadData();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    Get.put(AuthController());

    //formKey.currentState.reset();

    WidgetsBinding.instance.addPostFrameCallback((c) {
      //loadSidoData();
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
            padding: EdgeInsets.only(left: 30),
            child: Text('- 사이드바 메뉴 순서를 조정합니다.', style: TextStyle(fontSize: 12.0),),
          ),
        ],
      ),
    );

    // ButtonBar buttonBar = ButtonBar(
    //   alignment: MainAxisAlignment.end,
    //   children: <Widget>[
    //     Container(
    //       padding: const EdgeInsets.only(right: 15),
    //       child: ISButton(
    //           label: '옵션그룹 추가', iconData: Icons.add,
    //           onPressed: () => _addOptionGroup()),
    //     ),
    //   ],
    // );

    var result = Scaffold(
      appBar: AppBar(
        title: Text('사이드바 메뉴 순서'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          //buttonBar,
          form,
          //SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        child: Text('상위 메뉴', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),)
                    ),
                    SizedBox(height: 6,),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      width: 270,
                      height: 430,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.1), borderRadius: BorderRadius.circular(5), border: Border.all(width: 1, color: Colors.grey.withOpacity(.3))),
                      child: ReorderableListView(
                          scrollController: ScrollController(),
                          onReorder: _onParentMenuReorder,
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.only(bottom: 8.0),//padding: const EdgeInsets.only(bottom: 8.0, right: 10),
                          children: List.generate(
                              dataList.length,
                              (index) {
                                return Card(
                                  key: Key('$index'),
                                  color: dataList[index].selected == true ? Color.fromRGBO(165, 216, 252, 1.0) : Colors.white,
                                  margin: EdgeInsets.all(4),
                                  child: InkWell(
                                    splashColor: Color.fromRGBO(165, 216, 252, 1.0),
                                    onTap: () {
                                      dataList.forEach((element) {
                                        element.selected = false;
                                      });

                                      dataList[index].selected = true;

                                      loadChildData(dataList[index].id);

                                      setState(() {});
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(left: 10, right: 2.0, top: 10.0, bottom: 10.0),
                                          child: Icon(Utils.toIconData(dataList[index].icon), size: 21, color: Colors.black54),
                                        ),
                                        Flexible(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Container(
                                                padding: const EdgeInsets.only(left: 6, right: 0, top: 10),
                                                alignment: Alignment.topLeft,
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      alignment: Alignment.topLeft,
                                                      child: Text(dataList[index].name ?? '--', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(left: 6, right: 0, bottom: 10),
                                                alignment: Alignment.topLeft,
                                                child: Text(dataList[index].url ?? '--', style: TextStyle(color: Colors.black54, fontSize: 10),),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Padding(
                                        //   padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                                        //   child: InkWell(
                                        //     child: Icon(Icons.edit, size: 20,),
                                        //     onTap: (){
                                        //       _edit(dataList[index].id.toString());
                                        //     },
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                          )
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Icon(Icons.double_arrow, size: 21, color: Colors.black54),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        child: Text('하위 메뉴', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),)
                    ),
                    SizedBox(height: 6,),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      width: 270,
                      height: 430,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.1), borderRadius: BorderRadius.circular(5), border: Border.all(width: 1, color: Colors.grey.withOpacity(.3))),
                      child: dataChildList.length == 0
                          ? Container(
                              alignment: Alignment.center,
                              child: Text(selectChildComment, style: TextStyle(fontSize: 12),),
                            )
                          : ReorderableListView(
                          scrollController: ScrollController(),
                          onReorder: _onChildMenuReorder,
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.only(bottom: 8.0),
                          children: List.generate(
                              dataChildList.length,
                                  (index) {
                                return Card(
                                  key: Key('$index'),
                                  margin: EdgeInsets.all(4),
                                  color: Colors.white,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(left: 2.0, right: 2.0, top: 10.0, bottom: 10.0),
                                          child: Icon(Utils.toIconData(dataChildList[index].icon), size: 21, color: Colors.black54),
                                        ),
                                        Flexible(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Container(
                                                padding: const EdgeInsets.only(left: 2, right: 0, top: 10),
                                                alignment: Alignment.topLeft,
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      alignment: Alignment.topLeft,
                                                      child: Text(dataChildList[index].name ?? '--', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(left: 2, right: 0, bottom: 10),
                                                alignment: Alignment.topLeft,
                                                child: Text(dataChildList[index].url ?? '--', style: TextStyle(color: Colors.black54, fontSize: 10),),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Padding(
                                        //   padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                                        //   child: InkWell(
                                        //     child: Icon(Icons.edit, size: 20,),
                                        //     onTap: (){
                                        //       _edit(dataChildList[index].id.toString());
                                        //     },
                                        //   ),
                                        // ),
                                      ],
                                    )
                                  // child: ListTile(
                                  //   minLeadingWidth: 20,
                                  //   leading: Icon(Utils.toIconData(dataChildList[index].icon), size: 21, color: Colors.black54),
                                  //   title: Text(dataChildList[index].name ?? '--', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                                  //   subtitle: Text(dataChildList[index].url ?? '--', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),),
                                  // ),
                                );
                              }
                          )
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
      //bottomNavigationBar: buttonBar,
    );
    return SizedBox(
      width: 600,
      height: 580,//isDisplayDesktop(context) ? 580 : 1000,
      child: result,
    );
  }

  void _onParentMenuReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final Menu item = dataList.removeAt(oldIndex);
      dataList.insert(newIndex, item);

      List<String> sortDataList = [];
      dataList.forEach((element) {
        sortDataList.add(element.id);
      });
      _editListSort(sortDataList);
    });
  }

  void _onChildMenuReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final Menu item = dataChildList.removeAt(oldIndex);
      dataChildList.insert(newIndex, item);

      List<String> sortDataList = [];
      dataChildList.forEach((element) {
        sortDataList.add(element.id);
      });
      _editListSort(sortDataList);
    });
  }
}

