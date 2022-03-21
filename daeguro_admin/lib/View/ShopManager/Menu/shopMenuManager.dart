import 'dart:convert';

import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Model/shop/shopmenugroup_edit.dart';
import 'package:daeguro_admin_app/Model/shop/shopmenugroup_info.dart';
import 'package:daeguro_admin_app/Model/shop/shopmenulist_edit.dart';
import 'package:daeguro_admin_app/Model/shop/shopmenulist_info.dart';
import 'package:daeguro_admin_app/View/ShopManager/Menu/shopMenuGroupEdit.dart';
import 'package:daeguro_admin_app/View/ShopManager/Menu/shopMenuListEdit.dart';
import 'package:daeguro_admin_app/View/ShopManager/Menu/shopMenuOptionSetting.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';

import 'package:daeguro_admin_app/Provider/FileUpLoader.dart';
import 'package:daeguro_admin_app/Util/utils.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class ShopMenuManager extends StatefulWidget {
  final ShopMenuGroupInfoModel sData;
  final String ccCode;
  final String shopCode;
  final Stream<bool> streamCallback;
  final String eventYn;

  const ShopMenuManager({Key key, this.sData, this.ccCode, this.shopCode, this.streamCallback, this.eventYn}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShopMenuManagerState();
  }
}

class ShopMenuManagerState extends State<ShopMenuManager> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var _seq = 0;
  var _newindex = 0;

  int _cnt = 0;
  int _mainCount = 0;
  int _sumMainCount = 0;
  String _menuGroupCd;

  final List<ShopMenuGroupInfoModel> dataGroupList = <ShopMenuGroupInfoModel>[];
  final List<ShopMenuListInfoModel> dataMenuList = <ShopMenuListInfoModel>[];

  //ShopMenuGroupInfo formData;

  //bool isMenuList = false;
  String selectedGroupCode;
  String selectedGroupName = '';

  bool isMenuSaveEnabled = false;

  //bool isGroupSelected = false;

  _query() {
    //print('call _query()');
    //formKey.currentState.save();
    loadMenuGroupData();
  }

  setMainCount() async {
    _sumMainCount = 0;

    await ShopController.to.getMenuGroupData(widget.shopCode).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        value.forEach((e) {
          ShopMenuGroupInfoModel temp = ShopMenuGroupInfoModel.fromJson(e);

          if(_menuGroupCd == temp.menuGroupCd)
          {
            ShopController.to.MainCount.value = int.parse(temp.mainCount);
          }

          _sumMainCount = _sumMainCount + int.parse(temp.mainCount);
        });

        ShopController.to.SumMainCount.value = _sumMainCount;
      }

    });

    //if (this.mounted) {
      setState(() {

      });
    //}
  }

  loadMenuGroupData() async {
    _sumMainCount = 0;
    selectedGroupName = '';
    dataGroupList.clear();
    dataMenuList.clear();

    await ShopController.to.getMenuGroupData(widget.shopCode).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        value.forEach((e) {
          ShopMenuGroupInfoModel temp = ShopMenuGroupInfoModel.fromJson(e);

          if (_cnt == 0) {
            ShopController.to.MainCount.value = int.parse(temp.mainCount);
            _menuGroupCd = temp.menuGroupCd;
            _cnt++;
          }

          _sumMainCount = _sumMainCount + int.parse(temp.mainCount);

          dataGroupList.add(temp);
        });

        ShopController.to.SumMainCount.value = _sumMainCount;

        if (dataGroupList.length > 0) {
          if (_seq == 0) {
            dataGroupList[0].selected = true;
            loadMenuListData(dataGroupList[0].menuGroupCd, menuGroupName: dataGroupList[0].menuGroupName);
            _seq++;
          } else if (_seq == 1000) {
            dataGroupList[_newindex].selected = true;
            loadMenuListData(dataGroupList[_newindex].menuGroupCd, menuGroupName: dataGroupList[_newindex].menuGroupName);
            _seq++;
          } else {
            dataGroupList[dataGroupList.length - 1].selected = true;
            loadMenuListData(dataGroupList[dataGroupList.length - 1].menuGroupCd, menuGroupName: dataGroupList[dataGroupList.length - 1].menuGroupName);
          }
        }
      }
    });

    //if (this.mounted) {
      setState(() {

      });
    //}
  }

  loadMenuListData(String menuGroupCd, {String menuGroupName}) async {
    selectedGroupCode = menuGroupCd;
    if (menuGroupName != null) selectedGroupName = ' - [' + menuGroupName + ']';

    //print(menuGroupCd);
    dataMenuList.clear();

    await ShopController.to.getMenuListData(menuGroupCd).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        value.forEach((e) async {
          ShopMenuListInfoModel child = ShopMenuListInfoModel.fromJson(e);
          if (child.fileName == '') {
            child.fileName = null;
          } else {
            // child.fileName = ServerInfo.REST_IMG_BASEURL +
            //     '/api/Image/thumb?div=P&cccode=' +
            //     widget.ccCode +
            //     '&shop_cd=' +
            //     widget.shopCode +
            //     '&file_name=' +
            //     child.fileName +
            //     '&width=50&height=50';

            // child.fileName = ServerInfo.REST_IMG_BASEURL +
            //     '/api/Image/thumb?div=O&cccode=' + widget.ccCode+ '&shop_cd=' + widget.shopCode +'&file_name=' +
            //     child.fileName;

            child.fileName = ServerInfo.REST_IMG_BASEURL + '/images/' + widget.ccCode + '/' + widget.shopCode + '/' + child.fileName;

            //child.fileName = '/origin-images/1/783/59.jpg';
          }

          //print(child.fileName);

          dataMenuList.add(child);

          //if (child.name !=null && child.fileName != null)
          //  print('menuList: '+ child.name + ' - ' + child.fileName);
        });
      }
    });

    //if (this.mounted) {
      setState(() {

      });
    //}
  }

  reloadMenuListData(String menuGroupCd) async {
    selectedGroupCode = menuGroupCd;

    dataMenuList.clear();

    await ShopController.to.getMenuListData(menuGroupCd).then((value) async {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        value.forEach((e) async {
          ShopMenuListInfoModel child = ShopMenuListInfoModel.fromJson(e);
          if (child.fileName == '') {
            child.fileName = null;
          } else {
            child.fileName = ServerInfo.REST_IMG_BASEURL + '/images/' + widget.ccCode + '/' + widget.shopCode + '/' + child.fileName;
          }

          dataMenuList.add(child);
        });

        await Future.delayed(Duration(milliseconds: 500), () async {
          List<String> sortDataList = [];
          dataMenuList.forEach((element) {
            sortDataList.add(element.menuCd);
          });

          String jsonData = jsonEncode(sortDataList);
          await ShopController.to.updateMenuSort('1', jsonData, context);
        });
      }
    });

    if (this.mounted) {


      setState(() {});
    }
  }

  _editMenuGroup(String menuGroupCd) async {
    ShopMenuGroupEditModel editData = null;

    await ShopController.to.getMenuGoupDetailData(menuGroupCd).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        if (value != null) {
          editData = ShopMenuGroupEditModel.fromJson(value);
        }
      }
    });


    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: ShopMenuGroupEdit(
          sData: editData,
          sShopCode: widget.shopCode,
        ),
      ),
    ).then((v) async {
      if (v != null) {
        await Future.delayed(Duration(milliseconds: 500), () {
          _query();
        });
      }
    });
  }

  _editMenuList(String menuCd) async {
    ShopMenuListEditModel editData = null;

    await ShopController.to.getMenuDetailData(menuCd).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        if (ShopController.to.qDataMenuDetail != null) {
          editData = ShopMenuListEditModel.fromJson(ShopController.to.qDataMenuDetail);
        }
      }
    });

    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: ShopMenuListEdit(sData: editData),
      ),
    ).then((v) async {
      if (v != null) {
        await Future.delayed(Duration(milliseconds: 500), () {
          loadMenuListData(selectedGroupCode);
          setMainCount();
        });
      }
    });
  }

  _newMenuGroup() {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: ShopMenuGroupEdit(
          sShopCode: widget.shopCode,
        ),
      ),
    ).then((v) async {
      if (v != null) {
        await Future.delayed(Duration(milliseconds: 500), () {
          _query();
        });
      }
    });
  }

  _newMenu(int mainCnt) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: ShopMenuListEdit(shopCode: widget.shopCode, groupCode: selectedGroupCode),
      ),
    ).then((v) async {
      if (v != null) {
        await Future.delayed(Duration(milliseconds: 500), () {
          loadMenuListData(selectedGroupCode);
          setMainCount();
        });
      }
    });
  }

  _editListSort(String div, List<String> sortDataList) async {
    String jsonData = jsonEncode(sortDataList);

    //print('data set->'+jsonData);
    await ShopController.to.updateMenuSort(div, jsonData, context);

    await Future.delayed(Duration(milliseconds: 500), () {
      if (div == '0')
        loadMenuGroupData();
      else if (div == '1') loadMenuListData(selectedGroupCode);
    });
  }

  @override
  void initState() {
    super.initState();

    widget.streamCallback.listen((event) {
      if (event == true) _query();
    });

    WidgetsBinding.instance.addPostFrameCallback((c) {
      ShopController.to.MainCount.value = 0;
      ShopController.to.SumMainCount.value == 0;

      _query();
    });
  }

  @override
  void dispose() {
    super.dispose();

    dataGroupList.clear();
    dataMenuList.clear();

    PaintingBinding.instance.imageCache.clearLiveImages();
    PaintingBinding.instance.imageCache.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 360,
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.1), borderRadius: BorderRadius.circular(5), border: Border.all(width: 1, color: Colors.grey.withOpacity(.3))),
            child: Column(
              children: <Widget>[
                getTitleBarSet(
                    ShopController.to.SumMainCount.value == 0 ? '메뉴그룹' : '메뉴그룹  [총 대표메뉴 : ' + ShopController.to.SumMainCount.value.toString() + ' 개]', '0'),
                _MenuGroupView(),
              ],
            ),
          ),
          VerticalDivider(
            width: 20,
            color: Colors.grey,
          ),
          Container(
            width: 600,
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.1), borderRadius: BorderRadius.circular(5), border: Border.all(width: 1, color: Colors.grey.withOpacity(.3))),
            child: Column(
              children: <Widget>[
                getTitleBarSet(
                    ShopController.to.MainCount.value == 0
                        ? '메뉴' + selectedGroupName
                        : '메뉴' + selectedGroupName + ' [대표메뉴 : ' + ShopController.to.MainCount.value.toString() + ' 개]',
                    '1'),
                _MenuListView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void initMenuGroupMove() {
    //isMenuList = false;
    dataMenuList.clear();

    setState(() {});
  }

  void _onMenuGroupReorder(int oldIndex, int newIndex) {
    // 라이브 이벤트 진행중일때 리턴
    if (widget.eventYn == 'Y') return;

    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final ShopMenuGroupInfoModel item = dataGroupList.removeAt(oldIndex);
      dataGroupList.insert(newIndex, item);

      List<String> sortDataList = [];
      dataGroupList.forEach((element) {
        sortDataList.add(element.menuGroupCd);
      });

      _seq = 1000;
      _newindex = newIndex;

      _editListSort('0', sortDataList);
    });
  }

  void _onMenuListReorder(int oldIndex, int newIndex) {
    // 라이브 이벤트 진행중일때 리턴
    if (widget.eventYn == 'Y') return;

    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final ShopMenuListInfoModel item = dataMenuList.removeAt(oldIndex);
      dataMenuList.insert(newIndex, item);

      List<String> sortDataList = [];
      dataMenuList.forEach((element) {
        sortDataList.add(element.menuCd);
      });
      _editListSort('1', sortDataList);
    });
  }

  Widget _MenuGroupView() {
    return Expanded(
      child: ReorderableListView(
        scrollController: ScrollController(),
        onReorder: _onMenuGroupReorder,
        buildDefaultDragHandles: widget.eventYn == 'Y' ? false : true,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.only(bottom: 8.0),
        //const EdgeInsets.symmetric(vertical: 8.0),
        children: List.generate(
          dataGroupList.length,
          (index) {
            return Card(
              key: Key('$index'),
              margin: EdgeInsets.all(4),
              color: dataGroupList[index].selected == true ? Color.fromRGBO(165, 216, 252, 1.0) : Colors.white,
              child: InkWell(
                splashColor: Color.fromRGBO(165, 216, 252, 1.0),
                onTap: () {
                  dataGroupList.forEach((element) {
                    element.selected = false;
                  });

                  _menuGroupCd = dataGroupList[index].menuGroupCd;

                  ShopController.to.MainCount.value = int.parse(dataGroupList[index].mainCount);

                  dataGroupList[index].selected = true;

                  loadMenuListData(dataGroupList[index].menuGroupCd, menuGroupName: dataGroupList[index].menuGroupName);
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
                                    child: Text(
                                      '사용중',
                                      style: TextStyle(fontSize: 8, color: Colors.white),
                                    ))
                                : Container(
                                    margin: EdgeInsets.fromLTRB(10, 8, 0, 0),
                                    width: 30,
                                    height: 16,
                                    alignment: Alignment.center,
                                    color: Color.fromRGBO(253, 74, 95, 0.7843137254901961),
                                    child: Text(
                                      '미사용',
                                      style: TextStyle(fontSize: 8, color: Colors.white),
                                    )),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                            alignment: Alignment.topLeft,
                            child: Text(
                              dataGroupList[index].menuGroupName ?? '--',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 8),
                            alignment: Alignment.topLeft,
                            child: Text(dataGroupList[index].menuNames ?? '--', style: TextStyle(fontSize: 10)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                      child: (widget.eventYn == 'Y' || AuthUtil.isAuthEditEnabled('109') == false)
                          ? Container()
                          : IconButton(
                              onPressed: () {
                                // 라이브 이벤트 진행중일때 리턴
                                if (widget.eventYn == 'Y') return;

                                _seq = 1000;
                                _newindex = index;
                                _editMenuGroup(dataGroupList[index].menuGroupCd);
                              },
                              icon: Icon(Icons.edit, size: 20),
                              color: Colors.blue,
                              tooltip: '수정',
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

  Widget _MenuListView() {
    return Expanded(
      child: ReorderableListView(
        scrollController: ScrollController(),
        onReorder: _onMenuListReorder,
        buildDefaultDragHandles: widget.eventYn == 'Y' ? false : true,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.only(bottom: 8.0),
        //const EdgeInsets.symmetric(vertical: 8.0),
        children: List.generate(
          dataMenuList.length,
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
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 2.0, top: 10.0, bottom: 10.0),
                      child: InkWell(
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: dataMenuList[index].fileName == null
                              ? Image.asset('assets/empty_menu.png')
                              : Image.network(
                                  dataMenuList[index].fileName,
                                  fit: BoxFit.fitWidth,
                                  gaplessPlayback: true,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset('assets/empty_menu.png');
                                  },
                                ),
                        ),
                        onTap: () {
                          // 라이브 이벤트 진행중일때 리턴
                          if (widget.eventYn == 'Y') return;

                          ImagePicker imagePicker = ImagePicker();
                          Future<PickedFile> _imageFile =
                              imagePicker.getImage(source: ImageSource.gallery); //imagePicker.pickImage(source: ImageSource.gallery);
                          _imageFile.then((file) async {
                            dataMenuList[index].fileName = file.path;
                            //dataMenuList[index].fileSrc = file;

                            FileUpLoadProvider provider = FileUpLoadProvider();
                            provider.setResource('image', file);
                            provider.makeShopMenuPutResourceRequest(widget.ccCode, widget.shopCode, dataMenuList[index].menuCd, context);

                            await Future.delayed(Duration(milliseconds: 500), () {
                              setState(() {
                                _deleteImageFromCache();
                              });
                            });
                          }).then((v) async {
                            loadMenuListData(selectedGroupCode);
                          });
                        },
                      ),
                    ),
                    Container(
                      child: InkWell(
                        child: Visibility(
                          visible: dataMenuList[index].fileName == null ? false : true,
                          child: Icon(
                            Icons.delete_forever,
                            size: 18,
                            color: Colors.redAccent,
                          ),
                        ),
                        onTap: () {
                          // 라이브 이벤트 진행중일때 리턴
                          if (widget.eventYn == 'Y') return;

                          ISConfirm(context, '메뉴이미지 삭제', '메뉴 이미지를 삭제합니다. \n\n계속 진행 하시겠습니까?', (context) async {
                            //print('ImageRemove reauest: menuCd['+dataMenuList[index].menuCd+'], ccCode['+widget.ccCode+'], shopCode['+widget.shopCode+']');

                            await ShopController.to.putMenuImageRemove(context, dataMenuList[index].menuCd, widget.ccCode, widget.shopCode);

                            Navigator.of(context).pop();

                            await Future.delayed(Duration(milliseconds: 500), () {
                              loadMenuListData(selectedGroupCode);
                            });
                          });
                        },
                      ),
                    ),
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(left: 4, right: 0, top: 8, bottom: 2),
                            alignment: Alignment.topLeft,
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: [
                                    dataMenuList[index].useGbn == 'Y'
                                        ? Container(
                                            width: 32,
                                            height: 16,
                                            alignment: Alignment.center,
                                            color: Color.fromRGBO(87, 170, 58, 0.8431372549019608),
                                            child: Center(
                                                child: Text(
                                              '사용중',
                                              style: TextStyle(fontSize: 8, color: Colors.white),
                                            )))
                                        : Container(
                                            width: 32,
                                            height: 16,
                                            alignment: Alignment.center,
                                            color: Colors.black26,
                                            child: Text(
                                              '미사용',
                                              style: TextStyle(fontSize: 8, color: Colors.white),
                                            )),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    dataMenuList[index].aloneOrderYn == 'Y'
                                        ? Container(
                                            width: 20,
                                            height: 16,
                                            alignment: Alignment.center,
                                            color: Colors.blueAccent.shade100,
                                            child: Center(
                                                child: Text(
                                              '1인',
                                              style: TextStyle(fontSize: 8, color: Colors.white),
                                            )),
                                          )
                                        : Container(),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    dataMenuList[index].mainMenuYn == 'Y'
                                        ? Container(
                                            width: 20,
                                            height: 16,
                                            alignment: Alignment.center,
                                            color: Color.fromRGBO(141, 65, 217, 1.0),
                                            child: Center(
                                                child: Text(
                                              '대표',
                                              style: TextStyle(fontSize: 8, color: Colors.white),
                                            )))
                                        : Container(),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    dataMenuList[index].menuEventYn == 'Y'
                                        ? Container(
                                            width: 32,
                                            height: 16,
                                            alignment: Alignment.center,
                                            color: Color.fromRGBO(219, 203, 58, 1.0),
                                            child: Center(
                                                child: Text(
                                              '라이브',
                                              style: TextStyle(fontSize: 8, color: Colors.white),
                                            )))
                                        : Container(),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    dataMenuList[index].noFlag == 'Y'
                                        ? Container(
                                            width: 20,
                                            height: 16,
                                            alignment: Alignment.center,
                                            color: Colors.redAccent.shade100,
                                            child: Center(
                                                child: Text(
                                              '품절',
                                              style: TextStyle(fontSize: 8, color: Colors.white),
                                            )))
                                        : Container(),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    dataMenuList[index].adultOnly == 'Y'
                                        ? Container(
                                            width: 20,
                                            height: 16,
                                            alignment: Alignment.center,
                                            color: Colors.red,
                                            child: Center(
                                                child: Text(
                                              '성인',
                                              style: TextStyle(fontSize: 8, color: Colors.white),
                                            )),
                                          )
                                        : Container(),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    dataMenuList[index].name ?? '--',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 8),
                            alignment: Alignment.topLeft,
                            child: Text(Utils.getCashComma(dataMenuList[index].cost) + '원' ?? '--', style: TextStyle(fontSize: 10)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 1, 0),
                      child: (widget.eventYn == 'Y' || AuthUtil.isAuthEditEnabled('109') == false)
                          ? Container()
                          : IconButton(
                              onPressed: () async {
                                // 라이브 이벤트 진행중일때 리턴
                                if (widget.eventYn == 'Y') return;

                                await ShopController.to.putMenuCopyData(dataMenuList[index].menuCd, GetStorage().read('logininfo')['name'], null, context);

                                await Future.delayed(Duration(milliseconds: 500), () {
                                  isMenuSaveEnabled = true;

                                  reloadMenuListData(selectedGroupCode);
                                });
                              },
                              icon: Icon(
                                Icons.copy,
                                size: 20,
                              ),
                              tooltip: '메뉴복사',
                              color: Colors.blue,
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 1, 0),
                      child: (widget.eventYn == 'Y' || AuthUtil.isAuthEditEnabled('109') == false)
                          ? Container()
                          : IconButton(
                              onPressed: () {
                                // 라이브 이벤트 진행중일때 리턴
                                if (widget.eventYn == 'Y') return;

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => Dialog(
                                    child: ShopMenuOptionSetting(
                                      shopCode: widget.shopCode,
                                      menuCode: dataMenuList[index].menuCd,
                                    ),
                                  ),
                                ).then((v) {
                                  if (v != null) {
                                    //print('--------------refresh');
                                    _query();
                                  }
                                });
                              },
                              icon: Icon(
                                Icons.menu_open,
                                size: 20,
                              ),
                              tooltip: '옵션설정',
                              color: Colors.blue,
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                      child: (widget.eventYn == 'Y' || AuthUtil.isAuthEditEnabled('109') == false)
                          ? Container()
                          : IconButton(
                              onPressed: () {
                                // 라이브 이벤트 진행중일때 리턴
                                if (widget.eventYn == 'Y') return;

                                _editMenuList(dataMenuList[index].menuCd);
                              },
                              icon: Icon(
                                Icons.edit,
                                size: 20,
                              ),
                              tooltip: '메뉴수정',
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

  Widget getTitleBarSet(String titleStr, String type) {
    bool addBtnEnabled = true;
    if (AuthUtil.isAuthCreateEnabled('109') == true)           addBtnEnabled = true;
    else                                                     addBtnEnabled = false;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          children: [
            Container(
              //color: Colors.red,
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                children: [
                  Text(
                    titleStr,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            (type == '1')
                ? AnimatedOpacity(
                    opacity: isMenuSaveEnabled ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 700),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.red,
                          size: 18,
                        ),
                        Text(
                          '복사 완료',
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    onEnd: () {
                      setState(() {
                        isMenuSaveEnabled = false;
                      });
                    },
                  )
                : Container(
                    height: 40,
                  ),
          ],
        ),
        (dataGroupList.length == 0 && type == '1')
            ? Container(
                height: 40,
              )
            : Container(
                //color: Colors.red,
                child: (widget.eventYn == 'Y' || addBtnEnabled == false)
                    ? Container(height: 40,)
                    : IconButton(
                        //padding: EdgeInsets.only(top: 20),
                        onPressed: () {
                          // 라이브 이벤트 진행중일때 리턴
                          if (widget.eventYn == 'Y') return;

                          if (type == '0')
                            _newMenuGroup();
                          else if (type == '1') _newMenu(_mainCount);
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

  Future _deleteImageFromCache() async {
    //await CachedNetworkImage.evictFromCache(url);

    PaintingBinding.instance.imageCache.clearLiveImages();
    PaintingBinding.instance.imageCache.clear();

    //await DefaultCacheManager().removeFile(key);
    //await DefaultCacheManager().emptyCache();
    setState(() {});
  }
}
