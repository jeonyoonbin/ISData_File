

import 'dart:convert';

import 'package:daeguro_ceo_app/common/constant.dart';
import 'package:daeguro_ceo_app/common/serverInfo.dart';
import 'package:daeguro_ceo_app/config/auth_service.dart';
import 'package:daeguro_ceo_app/iswidgets/is_alertdialog.dart';
import 'package:daeguro_ceo_app/iswidgets/is_progressDialog.dart';
import 'package:daeguro_ceo_app/iswidgets/isd_button.dart';
import 'package:daeguro_ceo_app/iswidgets/isd_input.dart';
import 'package:daeguro_ceo_app/layout/responsive.dart';
import 'package:daeguro_ceo_app/models/MenuManager/menuListModel.dart';
import 'package:daeguro_ceo_app/models/MenuManager/menuGroupListModel.dart';
import 'package:daeguro_ceo_app/models/RequestManager/requestShopInfoEditModel.dart';
import 'package:daeguro_ceo_app/routes/routes.dart';
import 'package:daeguro_ceo_app/screen/Common/CommonImageHorizontalPreviewMain.dart';
import 'package:daeguro_ceo_app/screen/Common/commonImageVerticalPreview_main.dart';
import 'package:daeguro_ceo_app/screen/Common/commonNoFlagEdit.dart';
import 'package:daeguro_ceo_app/screen/MenuManager/menuGroupEdit.dart';
import 'package:daeguro_ceo_app/screen/MenuManager/menuListEdit.dart';
import 'package:daeguro_ceo_app/screen/MenuManager/menuManagerController.dart';
import 'package:daeguro_ceo_app/screen/MenuManager/optionLink.dart';
import 'package:daeguro_ceo_app/screen/RequestManager/requestImageInfoEdit.dart';
import 'package:daeguro_ceo_app/screen/RequestManager/requestManagerController.dart';
import 'package:daeguro_ceo_app/theme.dart';
import 'package:daeguro_ceo_app/util/utils.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluentUI;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:easy_rich_text/easy_rich_text.dart';

class MenuInfoMain extends StatefulWidget {
  final double? tabviewHeight;
  const MenuInfoMain({Key? key, this.tabviewHeight}) : super(key: key);

  @override
  State<MenuInfoMain> createState() => _MenuInfoMainState();
}

class _MenuInfoMainState extends State<MenuInfoMain> {

  static const int MODE_GROUPVIEW = 1000;
  static const int MODE_ITEMVIEW = 1001;

  int currentMode = MODE_GROUPVIEW;

  final List<MenuGroupListModel> dataGroupList = <MenuGroupListModel>[];
  final List<MenuListModel> dataItemList = <MenuListModel>[];

  String? menuGroupKeyword = '';
  String? menuKeyword = '';

  String liveEventYn = '';

  String? selectedItemName;
  String? selectedGroupCd;

  requestAPI_GroupData() async {

    var value = await showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (context) => FutureProgressDialog(MenuInfoController.to.getGroupList())
    );

    if (value == null) {
      ISAlert(context, content: '정상 조회가 되지 않았습니다. \n\n다시 시도해 주세요.');
      //Navigator.of(context).pop;
    }
    else {
      dataGroupList.clear();

      value.forEach((element) {
        MenuGroupListModel temp = MenuGroupListModel();
        List<String>? tempMenuNames = element['menuNames'].cast<String>();

        temp.menuGroupCd = element['menuGroupCd'] as String;
        temp.menuGroupName = element['menuGroupName'] as String;
        temp.menuGroupMemo = element['menuGroupMemo'] as String;
        temp.useYn = element['useYn'] as String;
        temp.mainCount = element['mainCount'] as String;

        tempMenuNames?.forEach((value) { // menuNames를 String 형태로 변경
          temp.menuNames = tempMenuNames.last == value ? '${temp.menuNames ?? ''}$value' : '${temp.menuNames ?? ''}$value, ';
        });

        dataGroupList.add(temp);
      });

      liveEventYn = MenuInfoController.to.eventYn;
    }

    setState(() {});
  }

  requestAPI_MenuData(String menuGroupCd) async {

    var value = await showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (context) => FutureProgressDialog(MenuInfoController.to.getMenuList(menuGroupCd))
    );

    if (value == null) {
      ISAlert(context, content: '정상 조회가 되지 않았습니다. \n\n다시 시도해 주세요.');
      //Navigator.of(context).pop;
    }
    else {
      dataItemList.clear();

      value.forEach((element) {
        MenuListModel temp = MenuListModel();

        temp.menuCd = element['menuCd'] as String;
        temp.menuName = element['menuName'] as String;
        temp.menuCost = element['menuCost'] as String;
        temp.menuDesc = element['menuDesc'] as String;
        temp.fileName = element['fileName'] as String;
        temp.mAloneOrder = element['mAloneOrder'] as String;
        temp.mMainYn = element['mMainYn'] as String;
        temp.useGbn = element['useGbn'] as String;
        temp.noFlag = element['noFlag'] as String;
        temp.adultOnly = element['adultOnly'] as String;
        temp.menuEventYn = element['menuEventYn'] as String;
        temp.orderLimitYn = element['orderLimitYn'] as String;
        temp.orderLimitQnt = element['orderLimitQnt'] as String;
        temp.singleOrderYn = element['singleOrderYn'] as String;

        if(ServerInfo.jobMode == 'real')
          temp.fileName = temp.fileName.toString().replaceAll('https://image.daeguro.co.kr:40443/', '/');

        dataItemList.add(temp);
      });

      selectedGroupCd = menuGroupCd;
      liveEventYn = MenuInfoController.to.eventYn;
    }

    setState(() {});
  }


  @override
  void initState() {
    super.initState();

    Get.put(MenuInfoController());
    Get.put(RequestController());

    WidgetsBinding.instance.addPostFrameCallback((c) {
      requestAPI_GroupData();
    });
  }

  @override
  void dispose() {
    super.dispose();
    dataGroupList.clear();
    dataItemList.clear();
  }

  void refresh(final _appTheme) async {
    if (mounted) {
      if (_appTheme.ShopRefresh == true ) {
        _appTheme.ShopRefresh = false;

        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (AuthService.ShopServiceGbn != AuthService.SHOPGBN_FLOWER){
            currentMode = MODE_GROUPVIEW;
            requestAPI_GroupData();
          }
          else{
            router.go('/');
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(fluentUI.debugCheckHasFluentTheme(context));

    final appTheme = context.watch<AppTheme>();

    Future.microtask(() => refresh(appTheme));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 1,
          shape: appTheme.cardShapStyle,
          child: Container(
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: currentMode == MODE_GROUPVIEW
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.feed_outlined, size: 20),
                            const SizedBox(width: 8,),
                            Text('메뉴 그룹 (${dataGroupList.length}개)', style: const TextStyle(fontSize: 14, fontWeight: FONT_BOLD, fontFamily: FONT_FAMILY),)
                          ],
                        ),

                        Row(
                          children: [
                            Responsive.isMobile(context)
                                ?
                            const SizedBox.shrink()
                                :
                            ISInput(
                              width: 300,
                              value: menuGroupKeyword,
                              label: '메뉴명으로 검색해 보세요.',
                              prefixIcon: const Icon(Icons.search, color: Colors.black87,),
                              onChange: (v) {
                                setState(() {
                                  menuGroupKeyword = v;
                                });
                              },
                            ),
                            const SizedBox(width: 8,),
                            ISButton(
                              child: const Text('그룹 추가'),
                              onPressed: () {
                                liveEventYn== 'Y'
                                    ?
                                ISAlert(context, content: '라이브 이벤트 중에는 수정이 불가능합니다.')
                                    :
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (context) => const MenuGroupEdit(),
                                ).then((value) async {
                                  if (value == true){
                                    await Future.delayed(const Duration(milliseconds: 500), () {
                                      requestAPI_GroupData();
                                    });
                                  }
                                });
                              },
                            ),
                          ],
                        )
                      ],
                    )
                  : SingleChildScrollView(
                    scrollDirection: Responsive.isMobile(context) ? Axis.horizontal : Axis.vertical,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.feed_outlined, size: 20),
                              TextButton(
                                style: ButtonStyle(
                                  animationDuration: const Duration(microseconds: 100),
                                  overlayColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) => Colors.transparent),
                                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                        if (states.contains(MaterialState.hovered)) {
                                          return const Color(0xff01CAFF);
                                        }

                                        return Colors.grey;
                                      }),
                                ),
                                onPressed: () {
                                  currentMode = MODE_GROUPVIEW;
                                  menuKeyword = '';

                                  setState(() {});
                                },
                                child: const Text('메뉴 그룹', style: TextStyle(fontSize: 14, fontWeight: FONT_BOLD, fontFamily: FONT_FAMILY)),
                              ),
                              const Text('>', style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FONT_BOLD, fontFamily: FONT_FAMILY)),
                              Text('  ${selectedItemName!}', style: const TextStyle(fontSize: 14, fontWeight: FONT_BOLD, fontFamily: FONT_FAMILY)),
                            ],
                          ),
                          Responsive.isMobile(context) ? const SizedBox(width: 18,) : Container(),
                          Row(
                            children: [
                              ISInput(
                                width: 300,
                                value: menuKeyword,
                                label: '메뉴명으로 검색해 보세요.',
                                prefixIcon: const Icon(Icons.search, color: Colors.black87,),
                                onChange: (v) {
                                  setState(() {
                                    menuKeyword = v;
                                  });
                                },
                              ),
                              const SizedBox(width: 8,),
                              ISButton(
                                child: const Text('메뉴 추가'),
                                onPressed: () {
                                  liveEventYn== 'Y'
                                      ?
                                  ISAlert(context, content: '라이브 이벤트 중에는 수정이 불가능합니다.')
                                      :
                                  showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) => MenuListEdit(menuGroupCd: selectedGroupCd),
                                  ).then((value) async {
                                    if (value == true){
                                      await Future.delayed(const Duration(milliseconds: 500), () {
                                        requestAPI_MenuData(selectedGroupCd!);
                                      });
                                    }
                                  });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                  ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        //const Divider(color: Colors.black,),//fluentUI.Divider(style: fluentUI.DividerThemeData(horizontalMargin: EdgeInsets.zero)),
        currentMode == MODE_GROUPVIEW ? Expanded(child: groupListView()) : Expanded(child: itemListView()),

        const Divider(height: 1)
      ],
    );
  }

  void _onGroupListReorder(int oldIndex, int newIndex) {
    // 라이브 이벤트 진행중일때 리턴
    //if (widget.eventYn == 'Y') return;

    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final MenuGroupListModel item = dataGroupList.removeAt(oldIndex);
      dataGroupList.insert(newIndex, item);

      List<String> sortDataList = [];
      dataGroupList.forEach((element) {
        sortDataList.add(element.menuGroupCd!);
      });

      _editListSort('5', sortDataList);
    });
  }

  _editListSort(String div, List<String> sortDataList) async {
    String jsonData = jsonEncode(sortDataList);

    await MenuInfoController.to.updateListSort(div, jsonData);

    await Future.delayed(const Duration(milliseconds: 500), () {
      if (div == '5')
        requestAPI_GroupData();
      else if (div == '4')
        requestAPI_MenuData(selectedGroupCd!);
    });
  }

  void _onItemListReorder(int oldIndex, int newIndex) {
    // 라이브 이벤트 진행중일때 리턴
    //if (widget.eventYn == 'Y') return;

    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final MenuListModel item = dataItemList.removeAt(oldIndex);
      dataItemList.insert(newIndex, item);

      List<String> sortDataList = [];
      dataItemList.forEach((element) {
        sortDataList.add(element.menuCd!);
      });

      _editListSort('4', sortDataList);
    });
  }

  Widget groupListView() {
    final appTheme = context.watch<AppTheme>();//context.watch<AppTheme>();

    return SizedBox(
      height: widget.tabviewHeight! - 91,
      child: dataGroupList.length != 0
          ?
      menuGroupKeyword == '' ?
      ReorderableListView( // 검색 안한 경우 (순서 변경 가능)
        buildDefaultDragHandles: false,
        scrollController: ScrollController(),
        onReorder: _onGroupListReorder,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.only(bottom: 8.0),

        children: List.generate(dataGroupList.length, (index) {
          return menuGroupCard(appTheme, index);
        },
        ),
      )
          :
      CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return (dataGroupList[index].menuNames != null && dataGroupList[index].menuNames!.contains(menuGroupKeyword!))
                      ? menuGroupCard(appTheme, index)
                      : const SizedBox.shrink();
                },
                childCount: dataGroupList.length,
              )
          )
        ],
      )
          :
      const Center(child: Text('조회 결과 없음', style: TextStyle(fontSize: 25, fontFamily: FONT_FAMILY, fontWeight: FONT_NORMAL)))
    );
  }

  Widget menuGroupCard(appTheme,index){

    // dataGroupList[index].tempMenuNames?.forEach((element) {
    //   element == menuGroupKeyword ?
    // });
    //
    // Expanded(child: Text(dataGroupList[index].menuNames ?? '', style: const TextStyle(color: Colors.black54, fontSize: 12, fontFamily: FONT_FAMILY))),
    // EasyRichText()
    //
    // // temp.tempMenuNames?.forEach((value) { // menuNames를 String 형태로 변경
    // //   temp.menuNames = temp.tempMenuNames!.last == value ? '${temp.menuNames ?? ''}$value' : '${temp.menuNames ?? ''}$value, ';
    // // });

    return Card(
      key: Key('$index'),
      elevation: 1,
      shape: appTheme.cardShapStyle,
      margin: const EdgeInsets.all(4),
      //color: dataGroupList[index].selected == true ? const Color.fromRGBO(165, 216, 252, 1.0) : Colors.white,
      child: InkWell(
        //splashColor: const Color.fromRGBO(165, 216, 252, 1.0),
        onTap: () {
          for (var element in dataGroupList) {
            element.selected = false;
          }

          dataGroupList[index].selected = true;
          selectedItemName = dataGroupList[index].menuGroupName;
          currentMode = MODE_ITEMVIEW;

          requestAPI_MenuData(dataGroupList[index].menuGroupCd!);

          //setState(() {});
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: ReorderableDragStartListener(
                    index: index,
                    child: Icon(Icons.reorder, color: Colors.grey, size: 24.0,)
                ),
              ),
              const SizedBox(width: 8,),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      child: Container(
                          margin: const EdgeInsets.fromLTRB(10, 8, 0, 0),
                          width: 36,
                          height: 18,
                          alignment: Alignment.center,
                          decoration: AppTheme.getListBadgeDecoration(dataGroupList[index].useYn == 'Y' ? const Color.fromRGBO(87, 170, 58, 0.8431372549019608) : const Color.fromRGBO(253, 74, 95, 0.7843137254901961)),
                          child: Text(dataGroupList[index].useYn == 'Y' ? '사용중' : '미사용', style: const TextStyle(fontSize: 10, color: Colors.white),)),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                      alignment: Alignment.topLeft,
                      child: Text(dataGroupList[index].menuGroupName ?? '--', style: const TextStyle(fontSize: 16, fontWeight: FONT_BOLD, fontFamily: FONT_FAMILY ),),
                    ),

                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 8),
                      alignment: Alignment.topLeft,
                      //child: Text('메뉴: ${dataGroupList[index].menuNames ?? '--'}', style: const TextStyle(color: Colors.black54, fontSize: 12, fontFamily: FONT_FAMILY)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: 26,
                              height: 18,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black45, width: 1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text('메뉴', style: TextStyle(fontSize: 10, fontWeight: FONT_NORMAL, fontFamily: FONT_FAMILY, color: Colors.black54),)
                          ),
                          const SizedBox(width: 8,),
                          menuGroupKeyword == ''
                              ?
                          Expanded(child: Text(dataGroupList[index].menuNames ?? '', style: const TextStyle(color: Colors.black54, fontSize: 12, fontFamily: FONT_FAMILY)))
                              :
                          Expanded(child: EasyRichText(
                            dataGroupList[index].menuNames ?? '' ,
                            defaultStyle: const TextStyle(color: Colors.black54, fontSize: 12, fontFamily: FONT_FAMILY),
                            patternList: [
                              EasyRichTextPattern(
                                targetString: menuGroupKeyword,
                                style: const TextStyle(color: Colors.black87, fontSize: 12, fontFamily: FONT_FAMILY, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, Responsive.isMobile(context) ? 10 :  30 , 0),
                  child: IconButton(
                    icon: const Icon(Icons.more_horiz, size: 20),
                    color: Colors.black,
                    tooltip: '수정',
                    onPressed: () {
                      menuGroupSetting(index);
                    },
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

  menuGroupSetting(index){
    List<String> values = ['메뉴 그룹 수정'/*, '메뉴 그룹 삭제'*/];

    return liveEventYn== 'Y'
        ?
    ISAlert(context, content: '라이브 이벤트 중에는 수정이 불가능합니다.')
        :
    ISOptionDialog(context, const BoxConstraints(maxWidth: 360.0, maxHeight: /*174*/116), dataGroupList[index].menuGroupName!, values, (context, selectIdx) async {
      Navigator.of(context).pop();
      if (selectIdx == 0){
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => MenuGroupEdit(sData: dataGroupList.elementAt(index)),
        ).then((value) async {
          if (value == true){
            await Future.delayed(const Duration(milliseconds: 500), () {
              requestAPI_GroupData();
            });
          }
        });

      }
    });

  }

  Widget itemListView() {
    final appTheme = context.watch<AppTheme>();
    
    return SizedBox(
      height: widget.tabviewHeight! - 91,
      child: dataItemList.length != 0 ?
          menuKeyword == ''
              ?
          ReorderableListView(
            buildDefaultDragHandles: false,
            scrollController: ScrollController(),
            onReorder: _onItemListReorder,
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.only(bottom: 8.0),

            children: List.generate(dataItemList.length, (index) {
              return menuCard(appTheme, index);
            },
            ),
          )
              :
          ListView(
            children: List.generate(dataItemList.length, (index) {
              return (dataItemList[index].menuName != null && dataItemList[index].menuName!.contains(menuKeyword!))
                  ? menuCard(appTheme, index)
                  : const SizedBox.shrink();
            }
            ),
          )
              :
          const Center(child: Text('조회 결과 없음', style: TextStyle(fontSize: 25, fontFamily: FONT_FAMILY, fontWeight: FONT_NORMAL)))
    );
  }


  Widget menuCard(appTheme, index){
    return Card(
      key: Key('$index'),
      elevation: 1,
      shape: appTheme.cardShapStyle,
      margin: const EdgeInsets.all(4),
      //color: dataMenuList[index].selected == true ? const Color.fromRGBO(165, 216, 252, 1.0) : Colors.white,
      child: InkWell(
        //splashColor: const Color.fromRGBO(165, 216, 252, 1.0),
        onTap: () {
          liveEventYn== 'Y'
              ?
          ISAlert(context, content: '라이브 이벤트 중에는 수정이 불가능합니다.')
              :
          showMenuSelectList(index);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: ReorderableDragStartListener(
                    index: index,
                    child: Icon(Icons.reorder, color: Colors.grey, size: 24.0,)
                ),
              ),
              const SizedBox(width: 8,),
              Card(
                color: Colors.grey.shade200,
                clipBehavior: Clip.antiAlias,
                borderOnForeground: false,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0),),
                //elevation: 4.0, //그림자 깊이
                //margin: const EdgeInsets.all(4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      child: SizedBox(
                        width: 102,
                        height: 80,
                        child: dataItemList[index].fileName == null
                            ? const Image(image: AssetImage('images/thumbnail-empty.png'), fit: BoxFit.cover)
                            : Image.network('${dataItemList[index].fileName!}?tm=${Utils.getTimeStamp()}', fit: BoxFit.cover, gaplessPlayback: true,
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Image(image: AssetImage('images/thumbnail-empty.png'), fit: BoxFit.cover);
                          },
                        ),
                      ),
                      onTap: () {
                        MenuInfoController.to.getMultiImageList(dataItemList[index].menuCd!, 'M').then((value) {
                          if (value == null){
                          }
                          else{
                            List<String> imageList = [];
                            value.forEach((element) {
                              imageList.add(element['fileName'] as String);
                            });

                            if (imageList.length > 0){
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) => CommonImageHorizontalPreviewMain(title: '메뉴 이미지', imageList: imageList),
                              );
                            }
                            else{
                              ISAlert(context, content: '메뉴 이미지가 없습니다.');
                            }
                          }
                        });
                      },
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 20,
                          child: FilledButton(
                            style: appTheme.imageButtonStyleLeft,
                            onPressed: () {
                              BuildContext dialogContext = context;

                              liveEventYn== 'Y'
                                  ?
                              ISAlert(context, content: '라이브 이벤트 중에는 수정이 불가능합니다.')
                                  :
                              ISConfirm(context, '메뉴 이미지 삭제 요청', '현재 등록되어 있는 메뉴 이미지를 삭제하시겠습니까?\n이미지를 변경하시려면 취소 후, [변경]버튼을 클릭해 주세요.', constraints: const BoxConstraints(maxWidth: 440.0, maxHeight: 280), (context, isOK) async {
                                Navigator.of(context).pop();

                                if (isOK){
                                  if (dataItemList[index].fileName == null || dataItemList[index].fileName == ''){
                                    ISAlert(context, title: '메뉴 이미지 삭제 요청', content: '삭제할 이미지가 존재하지 않습니다.');
                                    return;
                                  }
                                  RequestShopInfoEditModel sendData = RequestShopInfoEditModel();
                                  sendData.serviceGbn = '301';
                                  sendData.shopCd = AuthService.SHOPCD;
                                  sendData.status = '10';
                                  sendData.groupCd = selectedGroupCd ?? '';
                                  sendData.menuCd = dataItemList[index].menuCd;
                                  sendData.menuName = dataItemList[index].menuName;
                                  sendData.filter = dataItemList[index].menuCd;
                                  sendData.uCode = AuthService.uCode;
                                  sendData.uName = AuthService.uName;

                                  PickedFile? afterImageFile = PickedFile(dataItemList[index].fileName!);

                                  List<PickedFile>? imageFileList = <PickedFile>[];
                                  imageFileList.add(afterImageFile!);

                                  showDialog(
                                      context: context,
                                      builder: (context) => FutureProgressDialog(RequestController.to.setRequireSingleImageService(sendData, imageFileList))
                                  ).then((value) async{
                                    if (value == null) {
                                      ISAlert(context, content: '정상 처리가 되지 않았습니다. \n\n다시 시도해 주세요.');
                                    }
                                    else {
                                      http.Response.fromStream(value).asStream().listen((event) async {
                                        if (event.statusCode == 200) {
                                          var result = jsonDecode(event.body);

                                          String code = result['code'].toString();
                                          String msg = result['msg'].toString();

                                          if (code == '00'){
                                            await Future.delayed(Duration(milliseconds: 500), () {
                                              ISAlert(dialogContext, title: '메뉴 이미지 삭제 요청', content: '메뉴 이미지 삭제 요청이 완료되었습니다.\n\n심사 결과는 [변경 요청 내역] 메뉴에서 확인해 주세요.', constraints: const BoxConstraints(maxWidth: 360.0));
                                            });
                                          }
                                          else{
                                            ISAlert(dialogContext, content: '정상 처리가 되지 않았습니다.\n→ ${msg} ');
                                          }
                                        }
                                        else{
                                          //Navigator.of(dialogContext).pop(true);
                                        }
                                      });
                                    }
                                  });
                                }
                              });
                            },
                            child: const Text('삭제', style: TextStyle(fontSize: 10, fontFamily: FONT_FAMILY)),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                          child: FilledButton(
                            style: appTheme.imageButtonStyleRight,
                            onPressed: () {
                              liveEventYn== 'Y'
                                  ?
                              ISAlert(context, content: '라이브 이벤트 중에는 수정이 불가능합니다.')
                                  :
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) => RequestImageInfoEdit(jobGbn: '1', beforeImageURL: dataItemList[index].fileName, code: dataItemList[index].menuCd, name: dataItemList[index].menuName, groupCd: selectedGroupCd),
                              ).then((value) async {
                                if (value == true) {
                                  await Future.delayed(Duration(milliseconds: 500), () {
                                    ISAlert(context, title: '메뉴 이미지 정보 변경 요청 완료', content: '메뉴 이미지 정보 변경 요청이 접수되었습니다.\n\n운영사 확인 후, 2~3일 내로 처리될 예정입니다.\n결과는 [변경 요청 내역] 메뉴에서 확인해 주세요.', constraints: const BoxConstraints(maxWidth: 360.0));
                                  });
                                }
                              });
                            },
                            child: const Text('변경', style: TextStyle(fontSize: 10, fontFamily: FONT_FAMILY)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(width: 8,),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          dataItemList[index].useGbn == 'Y'
                              ? Container(
                              width: 36,
                              height: 18,
                              alignment: Alignment.center,
                              decoration: AppTheme.getListBadgeDecoration(const Color.fromRGBO(87, 170, 58, 0.8431372549019608)),
                              child: const Center(
                                  child: Text('사용중', style: TextStyle(fontSize: 10, color: Colors.white, fontFamily: FONT_FAMILY, fontWeight: FONT_NORMAL),
                                  ))
                          ) : Container(
                              width: 36,
                              height: 18,
                              alignment: Alignment.center,
                              decoration: AppTheme.getListBadgeDecoration(Colors.black26),
                              child: const Text('미사용', style: TextStyle(fontSize: 10, color: Colors.white, fontFamily: FONT_FAMILY, fontWeight: FONT_NORMAL),)
                          ),
                          dataItemList[index].mAloneOrder == 'Y'
                              ? Container(
                            width: 26,
                            height: 18,
                            margin: const EdgeInsets.only(left: 2.0),
                            alignment: Alignment.center,
                            decoration: AppTheme.getListBadgeDecoration(Colors.blueAccent.shade100),
                            child: const Center(child: Text('1인', style: TextStyle(fontSize: 10, color: Colors.white, fontFamily: FONT_FAMILY, fontWeight: FONT_NORMAL),)
                            ),
                          ) : const SizedBox.shrink(),
                          dataItemList[index].mMainYn == 'Y'
                              ? Container(
                              width: 26,
                              height: 18,
                              margin: const EdgeInsets.only(left: 2.0),
                              alignment: Alignment.center,
                              decoration: AppTheme.getListBadgeDecoration(const Color.fromRGBO(141, 65, 217, 1.0)),
                              child: const Center(child: Text('대표', style: TextStyle(fontSize: 10, color: Colors.white, fontFamily: FONT_FAMILY, fontWeight: FONT_NORMAL),))
                          ) : const SizedBox.shrink(),
                          dataItemList[index].menuEventYn == 'Y'
                              ? Container(
                              width: 36,
                              height: 18,
                              margin: const EdgeInsets.only(left: 2.0),
                              alignment: Alignment.center,
                              decoration: AppTheme.getListBadgeDecoration(const Color.fromRGBO(219, 203, 58, 1.0)),
                              child: const Center(child: Text('라이브', style: TextStyle(fontSize: 10, color: Colors.white, fontFamily: FONT_FAMILY, fontWeight: FONT_NORMAL),))
                          ) : const SizedBox.shrink(),
                          dataItemList[index].noFlag == 'Y'
                              ? Container(
                              width: 26,
                              height: 18,
                              margin: const EdgeInsets.only(left: 2.0),
                              alignment: Alignment.center,
                              decoration: AppTheme.getListBadgeDecoration(Colors.redAccent.shade100),
                              child: const Center(child: Text('품절', style: TextStyle(fontSize: 10, color: Colors.white, fontFamily: FONT_FAMILY, fontWeight: FONT_NORMAL),))
                          ) : const SizedBox.shrink(),
                          dataItemList[index].adultOnly == 'Y'
                              ? Container(
                            width: 26,
                            height: 18,
                            margin: const EdgeInsets.only(left: 2.0),
                            alignment: Alignment.center,
                            decoration: AppTheme.getListBadgeDecoration(Colors.red),
                            child: const Center(child: Text('성인', style: TextStyle(fontSize: 10, color: Colors.white, fontFamily: FONT_FAMILY, fontWeight: FONT_NORMAL),)),
                          ) : const SizedBox.shrink(),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(dataItemList[index].menuName ?? '--', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: FONT_FAMILY),),
                      Text('${Utils.getCashComma(dataItemList[index].menuCost!)} 원', style: const TextStyle(fontSize: 14, fontFamily: FONT_FAMILY)),
                    ],
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, Responsive.isMobile(context) ? 5 :  30 , 0),
                  child: IconButton(
                    icon: const Icon(Icons.more_horiz, size: 20),
                    color: Colors.black,
                    tooltip: '수정',
                    onPressed: () {
                      liveEventYn== 'Y'
                          ?
                      ISAlert(context, content: '라이브 이벤트 중에는 수정이 불가능합니다.')
                          :
                      showMenuSelectList(index);
                    },

                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

  showMenuSelectList(int index)
  {
    double listHeight = 0.0;
    List<String> values = ['메뉴 수정', '옵션 설정', '메뉴 품절'/*, '메뉴 삭제'*/];

    if (AuthService.ShopServiceGbn == AuthService.SHOPGBN_MEALKIT) {
      listHeight = 290.0;
      values = ['메뉴 수정', '옵션 설정', '메뉴 품절', '설명 이미지'/*, '메뉴 삭제'*/];
    }
    else{
      listHeight = 232.0;
      values = ['메뉴 수정', '옵션 설정', '메뉴 품절', /*, '메뉴 삭제'*/];
    }

    ISOptionDialog(context, BoxConstraints(maxWidth: 360.0, maxHeight: listHeight), dataItemList[index].menuName!, values, (context, selectIdx) async {
      Navigator.of(context).pop();
      if (selectIdx == 0){
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => MenuListEdit(sData: dataItemList.elementAt(index), menuGroupCd: selectedGroupCd),
        ).then((value) async {
          if (value == true){
            await Future.delayed(const Duration(milliseconds: 500), () {
              requestAPI_MenuData(selectedGroupCd!);
            });
          }
        });
      }
      else if (selectIdx == 1){
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => MenuOptionLink(menuCd: dataItemList[index].menuCd),
        ).then((value) async {
          if (value == true){
            await Future.delayed(const Duration(milliseconds: 500), () {
              requestAPI_MenuData(selectedGroupCd!);
            });
          }
        });
      }
      else if (selectIdx == 2){
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => CommonNoFlagEdit(jobGbn: 'D', subGbn: 'M', targetCd: dataItemList[index].menuCd, noFlag: dataItemList[index].noFlag),
        ).then((value) async {
          if (value == true){
            await Future.delayed(const Duration(milliseconds: 500), () {
              requestAPI_MenuData(selectedGroupCd!);
            });
          }
        });
      }
      else if (selectIdx == 3){
        MenuInfoController.to.getMultiImageList(dataItemList[index].menuCd!, 'D').then((value) {
          if (value == null){

          }
          else{
            List<String> imageList = [];
            value.forEach((element) {
              imageList.add(element['fileName'] as String);
            });

            if (imageList.length > 0){
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) => CommonImageVerticalPreviewMain(imageList: imageList),
              );
            }
            else{
              ISAlert(context, content: '설명 이미지가 없습니다.');
            }
          }
        });
      }
      else if (selectIdx == 4){
        ISConfirm(context, '삭제', '[${dataItemList[index].menuName!}] 메뉴를 삭제합니다. \n\n계속 진행하시겠습니까?', (context, isOK) async {
          Navigator.pop(context);

          if (isOK){

          }
        });
      }
    });
  }
}