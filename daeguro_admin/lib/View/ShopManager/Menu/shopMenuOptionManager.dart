import 'dart:convert';

import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Model/shop/shopmenuoption.dart';
import 'package:daeguro_admin_app/Model/shop/shopmenuoption_edit.dart';
import 'package:daeguro_admin_app/Model/shop/shopmenuoptiongroup.dart';
import 'package:daeguro_admin_app/Model/shop/shopmenuoptiongroup_edit.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/View/ShopManager/Menu/shopMenuOptionEdit.dart';
import 'package:daeguro_admin_app/View/ShopManager/Menu/shopMenuOptionGroupEdit.dart';
import 'package:daeguro_admin_app/View/ShopManager/Menu/shopMenuOptionHistory.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/Util/utils.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ShopMenuOptionManager extends StatefulWidget {
  final String shopCode;
  final String ccCode;
  final Stream<bool> streamCallback;
  final String eventYn;

  const ShopMenuOptionManager({Key key, this.ccCode, this.shopCode, this.streamCallback, this.eventYn})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShopMenuOptionManagerState();
  }
}



class ShopMenuOptionManagerState extends State<ShopMenuOptionManager> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final List<ShopMenuOptionGroupModel> dataGroupList = <ShopMenuOptionGroupModel>[];
  final List<ShopMenuOptionModel> dataOptionList = <ShopMenuOptionModel>[];

  var _seq = 0;
  var _newindex = 0;

  String selectedGroupCode;
  String selectedGroupName = '';

  bool isOptionGroupSaveEnabled = false;
  bool isOptionSaveEnabled = false;

  _query() {
    //print('call _query()');
    //formKey.currentState.save();
    loadOptionGroupData();
  }

  bool _getNewOptionCd(List<ShopMenuOptionGroupModel> tempGroupList, String item){
    //print('_getCompareData in');
    bool temp = false;

    for (final element in tempGroupList){
      if (element.optionGroupCd == item) {
        temp = true;
        break;
      }
    }
    return temp;
  }

  reloadOptionGroupData() async {
    selectedGroupName = '';

    List<ShopMenuOptionGroupModel> tempGroupList = List.from(dataGroupList);

    dataGroupList.clear();
    dataOptionList.clear();

    await ShopController.to.getOptionGroupData(widget.shopCode, '').then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        value.forEach((e) async {
          ShopMenuOptionGroupModel child = ShopMenuOptionGroupModel.fromJson(e);

          if (_getNewOptionCd(tempGroupList, child.optionGroupCd) == false){
            child.boolselected = true;
          }
          else
            child.boolselected = false;

          dataGroupList.add(child);
        });

        // await Future.delayed(Duration(milliseconds: 500), () async {
        //   List<String> sortDataList = [];
        //   dataGroupList.forEach((element) {
        //     sortDataList.add(element.optionGroupCd);
        //   });
        //
        //   String jsonData = jsonEncode(sortDataList);
        //   await ShopController.to.updateMenuSort('2', jsonData, context);
        // });


      }
    });

    //if (this.mounted) {
      setState(() {
        if (dataGroupList.length > 0) {
          int index = dataGroupList.indexWhere((item) => item.boolselected == true);
          loadOptionListData(dataGroupList[index].optionGroupCd, optionGroupName: dataGroupList[index].optionGroupName);
        }
      });
    //}
  }

  reloadOptionListData(String optionGroupCd) async {
    selectedGroupCode = optionGroupCd;

    dataOptionList.clear();

    await ShopController.to.getOptionData(optionGroupCd).then((value) async{
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        value.forEach((e) async {
          ShopMenuOptionModel child = ShopMenuOptionModel.fromJson(e);
          dataOptionList.add(child);
        });

        await Future.delayed(Duration(milliseconds: 500), () async{
          List<String> sortDataList = [];
          dataOptionList.forEach((element) {
            sortDataList.add(element.optionCd);
          });

          String jsonData = jsonEncode(sortDataList);
          await ShopController.to.updateMenuSort('3', jsonData, context);
        });
      }
    });

    //if (this.mounted) {
      setState(() { });
    //}
  }

  loadOptionGroupData() async {
    selectedGroupName = '';
    dataGroupList.clear();
    dataOptionList.clear();

    await ShopController.to.getOptionGroupData(widget.shopCode, '').then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        value.forEach((e) async {
          ShopMenuOptionGroupModel child = ShopMenuOptionGroupModel.fromJson(e);
          //print('optionGroupCd: '+child.optionGroupCd);
          dataGroupList.add(child);
        });

        if (dataGroupList.length > 0) {
          if (_seq == 0) {
            dataGroupList[0].boolselected = true;
            loadOptionListData(dataGroupList[0].optionGroupCd, optionGroupName: dataGroupList[0].optionGroupName);
            _seq++;
          }
          else if (_seq == 1000) {
            dataGroupList[_newindex].boolselected = true;
            loadOptionListData(dataGroupList[_newindex].optionGroupCd, optionGroupName: dataGroupList[_newindex].optionGroupName);
            _seq++;
          } else {
            dataGroupList[dataGroupList.length - 1].boolselected = true;
            loadOptionListData(dataGroupList[dataGroupList.length - 1].optionGroupCd, optionGroupName: dataGroupList[dataGroupList.length - 1].optionGroupName);
          }
        }
      }
    });

    //if (this.mounted) {
      setState(() {

      });
    //}
  }

  loadOptionListData(String optionGroupCd, {String optionGroupName}) async {
    selectedGroupCode = optionGroupCd;
    if (optionGroupName != null)      selectedGroupName = ' - [' + optionGroupName + ']';

    dataOptionList.clear();

    await ShopController.to.getOptionData(optionGroupCd).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        value.forEach((e) async {
          ShopMenuOptionModel child = ShopMenuOptionModel.fromJson(e);
          // if (child.fileName == '')
          //   child.fileName = null;
          // else
          //   child.fileName = 'http://dgpub.282.co.kr:8426/admin/Image/thumb?div=P&cccode='+widget.ccCode+'&shop_cd='+widget.shopCode+'&file_name='+child.fileName+'&width=50&height=50';

          dataOptionList.add(child);
        });
      }
    });

    //if (this.mounted) {
      setState(() {

      });
    //}
  }

  _newOptionGroup() {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: ShopMenuOptionGroupEdit(shopCode: widget.shopCode),
      ),
    ).then((v) async {
      if (v != null) {
        await Future.delayed(Duration(milliseconds: 500), () {
          _query();
        });
      }
    });
  }

  _OptionHistory() {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: ShopMenuOptionHistory(shopCode: widget.shopCode),
      ),
    ).then((v) async {
      if (v != null) {
        await Future.delayed(Duration(milliseconds: 500), () {
          _query();
        });
      }
    });
  }


  _editOptionGroup(String optionGroupCd) async {
    ShopMenuOptionGroupEditModel editData = null;

    await ShopController.to.getOptionGroupDetailData(optionGroupCd).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        if (value != null) {
          editData = ShopMenuOptionGroupEditModel.fromJson(value);
        }
      }
    });



    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: ShopMenuOptionGroupEdit(sData: editData),
      ),
    ).then((v) async {
      if (v != null) {
        await Future.delayed(Duration(milliseconds: 500), () {
          loadOptionGroupData();
        });
      }
    });
  }

  _deleteOptionGroup(String optionGroupCode) {
    ISConfirm(context, '옵션그룹 삭제', '옵션그룹을 삭제합니다. \n\n계속 진행 하시겠습니까?', (context) async {
          await ShopController.to.deleteOptionGroupDetailData(optionGroupCode, context);

          Navigator.of(context).pop();

          _query();
        });
  }

  _newOption() {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: ShopMenuOptionEdit(shopCd: widget.shopCode, optionGroupCd: selectedGroupCode,),
      ),
    ).then((v) async {
      if (v != null) {
        await Future.delayed(Duration(milliseconds: 500), () {
          loadOptionListData(selectedGroupCode);
        });
      }
    });
  }

  _editOption(String optionCd) async {
    ShopMenuOptionEditModel editData = null;

    await ShopController.to.getOptionDetailData(optionCd).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        if (value != null) {
          //print('qDataMenuOptionDetail is Not NULL');

          editData = ShopMenuOptionEditModel.fromJson(value);

          //editData.shopCd = widget.shopCd;
          //editData.menuCd = widget.menuCd;
          //editData.optionGroupCd = widget.optionGroupCd;
        }
      }
    });

    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: ShopMenuOptionEdit(sData: editData, shopCd: widget.shopCode, optionGroupCd: selectedGroupCode,),
      ),
    ).then((v) async {
      if (v != null) {
        await Future.delayed(Duration(milliseconds: 500), () {
          loadOptionListData(selectedGroupCode);
        });
      }
    });
  }

  _deleteOption(String optionCd) {
    ISConfirm(context, '옵션 삭제', '옵션을 삭제합니다. \n\n계속 진행 하시겠습니까?', (context) async {
          await ShopController.to.deleteOptionDetailData(optionCd, context);

          Navigator.of(context).pop();

          await Future.delayed(Duration(milliseconds: 500), () {
            loadOptionListData(selectedGroupCode);
          });
    });
  }

  _editListSort(String div, List<String> sortDataList) async {
     String jsonData = jsonEncode(sortDataList);

     await ShopController.to.updateMenuSort(div, jsonData, context);

     await Future.delayed(Duration(milliseconds: 500), () {
       if (div == '2')         loadOptionGroupData();
       else if (div == '3') loadOptionListData(selectedGroupCode);
     });
   }

  @override
  void initState() {
    super.initState();

    widget.streamCallback.listen((event) {
      if (event == true)
        _query();
    });

    WidgetsBinding.instance.addPostFrameCallback((c) {
      _query();
    });
  }

  @override
  void dispose() {
    super.dispose();

    dataGroupList.clear();
    dataOptionList.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.yellow,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 360,
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.1),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 1, color: Colors.grey.withOpacity(.3))),
            child: Column(
              children: <Widget>[
                getOptionGroupTitleBar('옵션그룹'),
                _OptionGroupView(),
              ],
            ),
            //child: ,
          ),
          VerticalDivider(width: 20, color: Colors.grey,),
          Container(
            width: 600,
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.1),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 1, color: Colors.grey.withOpacity(.3))),
            child: Column(
              children: <Widget>[
                getOptionListTitleBar('옵션' + selectedGroupName),
                _OptionListView(),
              ],
            ),
            //child: _MenuListView(),
          ),
        ],
      ),
    );
  }

  void initOptionGroupMove() {
    dataOptionList.clear();

    setState(() {});
  }

  // void _onOptionGroupReorder(int oldIndex, int newIndex) {
  //   setState(() {
  //     if (newIndex > oldIndex) {
  //       newIndex -= 1;
  //     }
  //     final ShopOptionGroup item = dataGroupList.removeAt(oldIndex);
  //     dataGroupList.insert(newIndex, item);
  //
  //     List<String> sortDataList = [];
  //     dataGroupList.forEach((element) {
  //       sortDataList.add(element.optionGroupCd);
  //     });
  //     _editListSort('2', sortDataList);
  //   });
  // }
  //
  void _onOptionListReorder(int oldIndex, int newIndex) {
    // 라이브 이벤트 진행중일때 리턴
    if (widget.eventYn == 'Y') return;

    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final ShopMenuOptionModel item = dataOptionList.removeAt(oldIndex);
      dataOptionList.insert(newIndex, item);

      List<String> sortDataList = [];
      dataOptionList.forEach((element) {
        sortDataList.add(element.optionCd);
      });
      _editListSort('3', sortDataList);
    });
  }

  Widget _OptionGroupView() {
    return Expanded(
      child: ListView.builder(
        controller: ScrollController(),
        padding: EdgeInsets.only(bottom: 8),
        itemCount: dataGroupList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            key: Key('$index'),
            margin: EdgeInsets.all(4),
            color: dataGroupList[index].boolselected == true ? Color.fromRGBO(165, 216, 252, 1.0) : Colors.white,
            child: InkWell(
              splashColor: Color.fromRGBO(165, 216, 252, 1.0),
              onTap: () {
                dataGroupList.forEach((element) {
                  element.boolselected = false;
                });

                dataGroupList[index].boolselected = true;

                loadOptionListData(dataGroupList[index].optionGroupCd, optionGroupName: dataGroupList[index].optionGroupName);

                setState(() {});
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topLeft,
                          child: dataGroupList[index].useYn == 'Y'
                              ? Container(
                                margin: EdgeInsets.fromLTRB(10, 8, 0, 0),
                                width: 30,
                                height: 16,
                                alignment: Alignment.center,
                                color: Color.fromRGBO(87, 170, 58, 0.8431372549019608),
                                child: Center(child: Text('사용중', style: TextStyle(fontSize: 8, color: Colors.white),))
                              )
                              : Container(
                                margin: EdgeInsets.fromLTRB(10, 8, 0, 0),
                                width: 30,
                                height: 16,
                                alignment: Alignment.center,
                                color: Color.fromRGBO(253, 74, 95, 0.7843137254901961),
                                child: Text('미사용', style: TextStyle( fontSize: 8, color: Colors.white),)
                              ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10, right: 0, top: 8, bottom: 2),
                          alignment: Alignment.topLeft,
                          child: Text(dataGroupList[index].optionGroupName ?? '--', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 8),
                          alignment: Alignment.topLeft,
                          child: Text(dataGroupList[index].optionNames ?? '--', style: TextStyle(fontSize: 10)),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: (widget.eventYn == 'Y' || AuthUtil.isAuthEditEnabled('109') == false) ? Container() : IconButton(
                          onPressed: () async {
                            // 라이브 이벤트 진행중일때 리턴
                            if (widget.eventYn == 'Y') return;

                            await ShopController.to.postCopyOptionGroupData(widget.shopCode, dataGroupList[index].optionGroupCd, GetStorage().read('logininfo')['name'], context);

                            await Future.delayed(Duration(milliseconds: 500), () {
                              isOptionGroupSaveEnabled = true;

                              reloadOptionGroupData();
                            });
                          },
                          icon: Icon(Icons.copy, size: 20),
                          tooltip: '옵션그룹 복사',
                          color: Colors.blue,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: (widget.eventYn == 'Y' || AuthUtil.isAuthDeleteEnabled('109') == false) ? Container() : IconButton(
                          icon: Icon(Icons.delete, size: 20),
                          tooltip: '삭제',
                          color: Colors.blue,
                          onPressed: () {
                            // 라이브 이벤트 진행중일때 리턴
                            if (widget.eventYn == 'Y') return;

                            _deleteOptionGroup(dataGroupList[index].optionGroupCd);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: (widget.eventYn == 'Y' || AuthUtil.isAuthEditEnabled('109') == false) ? Container() : IconButton(
                          icon: Icon(Icons.edit, size: 20),
                          tooltip: '수정',
                          color: Colors.blue,
                          onPressed: () {
                            // 라이브 이벤트 진행중일때 리턴
                            if (widget.eventYn == 'Y') return;

                            _newindex = index;
                            _seq = 1000;
                            _editOptionGroup(dataGroupList[index].optionGroupCd);
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),

    );
  }

  Widget _OptionListView() {
    return Expanded(
        child: ReorderableListView(
          scrollController: ScrollController(),
          onReorder: _onOptionListReorder,
          buildDefaultDragHandles: widget.eventYn == 'Y' ? false : true,
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.only(bottom: 8.0),
          //const EdgeInsets.symmetric(vertical: 8.0),
          children: List.generate(
            dataOptionList.length,
            (index) {
              return Card(
                key: Key('$index'),
                margin: EdgeInsets.all(4),
                color: Colors.white,
                child: InkWell(
                  splashColor: Colors.blue,
                  onTap: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
                              alignment: Alignment.topLeft,
                              //child:
                              child: Row(
                                children: <Widget>[
                                  dataOptionList[index].useYn == 'Y' ? Container(
                                    width: 30,
                                    height: 16,
                                    alignment: Alignment.center,
                                    color: Color.fromRGBO(87, 170, 58, 0.8431372549019608),
                                    child: Center(child: Text('사용중', style: TextStyle(fontSize: 8, color: Colors.white),)),
                                  ) : Container(
                                      width: 30,
                                      height: 16,
                                      alignment: Alignment.center,
                                      color: Colors.black26,
                                      child: Text('미사용', style: TextStyle(fontSize: 8, color: Colors.white),)
                                  ),
                                  SizedBox(width: 2,),
                                  dataOptionList[index].noFlag == 'Y' ? Container(
                                    width: 21,
                                    height: 16,
                                    alignment: Alignment.center,
                                    color: Colors.redAccent.shade100,
                                    child: Center(child: Text('품절', style: TextStyle(fontSize: 8, color: Colors.white),)),
                                  ) : Container(),
                                  SizedBox(width: 2,),
                                  dataOptionList[index].adultOnly == 'Y' ? Container(
                                    width: 21,
                                    height: 16,
                                    alignment: Alignment.center,
                                    color: Colors.red,
                                    child: Center(child: Text('성인', style: TextStyle(fontSize: 8, color: Colors.white),)),
                                  ) : Container(),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 10, top: 5, bottom: 2),
                              alignment: Alignment.topLeft,
                              child: Text(dataOptionList[index].name ?? '--', style: TextStyle( fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 8),
                              alignment: Alignment.topLeft,
                              child: Text(Utils.getCashComma(dataOptionList[index].cost) + '원' ?? '--', style: TextStyle(fontSize: 10)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 1, 0),
                        child: (widget.eventYn == 'Y' || AuthUtil.isAuthEditEnabled('109') == false) ? Container() : IconButton(
                          onPressed: () async {
                            // 라이브 이벤트 진행중일때 리턴
                            if (widget.eventYn == 'Y') return;

                            ShopMenuOptionEditModel copyData = ShopMenuOptionEditModel();
                            copyData.shopCd = widget.shopCode;
                            copyData.optionGroupCd = selectedGroupCode;
                            copyData.optionName = dataOptionList[index].name +' - 복사본';
                            copyData.optionMemo = dataOptionList[index].memo;
                            copyData.cost = dataOptionList[index].cost;
                            copyData.useYn = dataOptionList[index].useYn;
                            copyData.noFlag = dataOptionList[index].noFlag;
                            copyData.adultOnly = dataOptionList[index].adultOnly;
                            copyData.insertName = GetStorage().read('logininfo')['name'];

                            await ShopController.to.postOptionDetailData(copyData.toJson(), context);

                            await Future.delayed(Duration(milliseconds: 500), () {
                              isOptionSaveEnabled = true;
                              reloadOptionListData(selectedGroupCode);
                            });
                          },
                          icon: Icon(Icons.copy, size: 20,),
                          tooltip: '옵션복사',
                          color: Colors.blue,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 1, 0),
                        child: (widget.eventYn == 'Y' || AuthUtil.isAuthDeleteEnabled('109') == false) ? Container() : IconButton(
                          onPressed: () {
                            // 라이브 이벤트 진행중일때 리턴
                            if (widget.eventYn == 'Y') return;

                            _deleteOption(dataOptionList[index].optionCd);
                          },
                          icon: Icon(Icons.delete, size: 20),
                          tooltip: '삭제',
                          color: Colors.blue,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                        child: (widget.eventYn == 'Y' || AuthUtil.isAuthEditEnabled('109') == false) ? Container() : IconButton(
                          onPressed: () {
                            // 라이브 이벤트 진행중일때 리턴
                            if (widget.eventYn == 'Y') return;

                            _editOption(dataOptionList[index].optionCd);
                          },
                          icon: Icon(Icons.edit, size: 20),
                          tooltip: '수정',
                          color: Colors.blue,
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                      //   child: Icon(Icons.reorder, color: Colors.grey, size: 24.0,),
                      // ),
                    ],
                  ),
                ),
              );
            },
          ),
      ),
       );
  }

  Widget getOptionGroupTitleBar(String titleStr) {
    // if (type == '0' && AuthUtil.isAuthReadEnabled('113') == true)           addBtnEnabled = true;
    // else if (type == '1' && AuthUtil.isAuthReadEnabled('110') == true)      addBtnEnabled = true;
    // else                                                                    addBtnEnabled = false;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              //color: Colors.red,
              padding: const EdgeInsets.only(left: 10),
              child: Text(titleStr, style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            SizedBox(width: 10,),
            AnimatedOpacity(
              opacity: isOptionGroupSaveEnabled ? 1.0 : 0.0,
              duration: Duration(milliseconds: 700),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.red, size: 18,),
                  Text('복사 완료', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                ],
              ),
              onEnd: (){
                setState(() {
                  isOptionGroupSaveEnabled = false;
                });
              },
            ),
          ],
        ),
        Container(
          //color: Colors.red,
          child: (widget.eventYn == 'Y' || AuthUtil.isAuthCreateEnabled('109') == false)
              ? Container(height: 40,) : IconButton(
            //padding: EdgeInsets.only(top: 20),
            onPressed: () {
              // 라이브 이벤트 진행중일때 리턴
              if (widget.eventYn == 'Y') return;

              _newOptionGroup();
            },
            icon: Icon(
              Icons.add_box,
              color: Colors.blue,
              size: 30,
            ),
            tooltip: '신규 등록',
          ),
        ),
      ],
    );
  }

  Widget getOptionListTitleBar(String titleStr) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              //color: Colors.red,
              padding: const EdgeInsets.only(left: 10),
              child: Text(titleStr, style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            SizedBox(width: 10,),
            AnimatedOpacity(
              opacity: isOptionSaveEnabled ? 1.0 : 0.0,
              duration: Duration(milliseconds: 700),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.red, size: 18,),
                  Text('복사 완료', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                ],
              ),
              onEnd: (){
                setState(() {
                  isOptionSaveEnabled = false;
                });
              },
            ),
          ],
        ),
        (dataGroupList.length == 0) ? Container(height: 40,) : Row(
          children: [
            Container(
              //color: Colors.red,
              child: IconButton(
                //padding: EdgeInsets.only(top: 20),
                onPressed: () {
                  _OptionHistory();
                },
                icon: Icon(Icons.history, color: Colors.blue, size: 30,),
                tooltip: '변경 이력',
              ),
            ),
            Container(
          //color: Colors.red,
          child: (widget.eventYn == 'Y' || AuthUtil.isAuthCreateEnabled('109') == false)
              ? Container() : IconButton(
            //padding: EdgeInsets.only(top: 20),
            onPressed: () {
              // 라이브 이벤트 진행중일때 리턴
              if (widget.eventYn == 'Y') return;

              _newOption();
            },
            icon: Icon(Icons.add_box, color: Colors.blue, size: 30,),
            tooltip: '신규 등록',
          ),
        ),
      ],
        ),
      ],
    );
  }
}