@JS()
library javascript_bundler;

import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:js/js.dart';
import 'dart:html';

import 'package:daeguro_admin_app/Model/menu.dart';
import 'package:daeguro_admin_app/Util/tree_util.dart';
import 'package:daeguro_admin_app/Util/tree_vo.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/Layout/layout_controller.dart';
import 'package:daeguro_admin_app/View/userInfo/userInfo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

@JS('appRefresh')
external void runAppRefresh();

class LayoutSideBarMenu extends StatefulWidget {
  LayoutSideBarMenu({
    Key key,
    this.onClick,
  }) : super(key: key);
  final Function onClick;

  @override
  _LayoutSideBarMenuState createState() => _LayoutSideBarMenuState();
}

class _LayoutSideBarMenuState extends State<LayoutSideBarMenu> with SingleTickerProviderStateMixin {
  bool expandMenu = true;
  LayoutController layoutController = Get.find();
  String _selectedItem = '4';//''mSeq_3';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    //print('sideBarMenu Len:${Utils.sideBarMenu}');
    //print('sideBarMenu Len:${Utils.getMenuTree()}');

    List<Widget> menuBody = _getMenuListTile(TreeUtil.toTreeVOList(AuthUtil.SideBarMenu));//
    //List<Widget> menuBody = _getMenuListTile(TreeUtil.toTreeVOList(Utils.getMenuTree()));

    return Drawer(
      child: Column(
        children: [
          Container(
            width: 128,
            height: 84,
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: Image.asset('assets/BI_6.png'),
          ),
          Divider(),
          SingleChildScrollView(
            controller: ScrollController(),
            physics: BouncingScrollPhysics(),//NeverScrollableScrollPhysics(),
            // it enables scrolling
            child: Column(
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height-183,
                    child: Container(
                      child: ListView(
                          controller: ScrollController(),
                          key: Key('selected $_selectedItem'),
                        //physics: NeverScrollableScrollPhysics(),
                          children: menuBody
                      ),
                    )
                ),
              ],
            ),
          ),
          Divider(height: 6,),
          Column(
            children: [
              SizedBox(height: 4,),
              Container(
                child: Text('AppVersion: ${ServerInfo.APP_VERSION}', style: TextStyle(fontSize: 12),),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Tooltip(
                    message: '전체화면',
                    child: IconButton(
                      icon: Icon(Icons.fullscreen_outlined, size: 24, color: Color.fromARGB(255, 056, 190, 239),),
                      onPressed: () {
                        if (Utils.getFullScreenState() == true){
                          document.exitFullscreen();
                          Utils.setFullScreenState(false);
                        }
                        else{
                          document.documentElement.requestFullscreen();
                          Utils.setFullScreenState(true);
                        }
                        //runFullScreen();
                      },
                    ),
                  ),
                  Tooltip(
                    message: '업데이트',
                    child: IconButton(
                      icon: Icon(Icons.update, color: Color.fromARGB(255, 056, 190, 239), size: 20,),
                      onPressed: () {
                        runAppRefresh();
                      },
                    ),
                  ),
                  Tooltip(
                    message: '사용자 정보',
                    child: IconButton(
                      icon: Icon(Icons.person, color: Color.fromARGB(255, 056, 190, 239), size: 20,),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => Dialog(
                            child: UserInfoDialog(),
                          ),
                        );
                      },
                    ),
                  ),
                  Tooltip(
                    message: '로그아웃',
                    child: IconButton(
                      icon: Icon(Icons.exit_to_app, color: Color.fromARGB(255, 056, 190, 239), size: 20,),
                      onPressed: () {
                        dispose();
                        Utils.logout();
                        Navigator.popAndPushNamed(context, '/login');
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool isCurrentOpenedMenu(List<TreeVO<Menu>> data) {
    for (var treeVO in data) {
      if (treeVO.children != null && treeVO.children.length > 0) {
        return isCurrentOpenedMenu(treeVO.children);
      }

      return layoutController.currentOpenedPageId == treeVO.data.id;
    }
    return false;
  }

  List<Widget> _getMenuListTile(List<TreeVO<Menu>> data) {
    if (data == null) {
      return [];
    }
    List<Widget> listTileList = data.map<Widget>((TreeVO<Menu> treeVO) {
      IconData iconData = Utils.toIconData(treeVO.data.icon);
      String name = treeVO.data.name ?? '';
      String index = treeVO.data.id;

      if (treeVO.children != null && treeVO.children.length > 0) {
        return ListTileTheme(
          dense: true,
          minVerticalPadding: 0,
          child: ExpansionTile(
            key: Key(index.toString()),
            initiallyExpanded: index == _selectedItem, //isCurrentOpenedMenu(treeVO.children),
            //leading: Icon(iconData, size: 21,),//Icon(expandMenu ? treeVO.icon : null),
            backgroundColor: Theme.of(context).accentColor.withOpacity(0.050),
            children: _getMenuListTile(treeVO.children),
            trailing: expandMenu ? null : Icon(null),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(iconData, size: 21, color: Colors.black54),
                SizedBox(width: 16,),
                Text(expandMenu ? name : '', style: new TextStyle(height:1, fontSize: 14.0, fontFamily: 'NotoSansKR')),
              ],
            ),
            childrenPadding: EdgeInsets.fromLTRB(0,0,0,10),
            onExpansionChanged: (isOpen){
              if (isOpen) {
                setState(() {
                  _selectedItem = index;
                });
              }
            },
          ),
        );
      }
      else {
        return Container(
          height: treeVO.data.pid == null ? 35 : 30,
          child: ListView.builder(physics: NeverScrollableScrollPhysics(), itemBuilder: (BuildContext context, int index) {
            return ListTile(
              dense: true,
              //leading: Icon(iconData),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(iconData, size: 21, color: Colors.black54),
                  SizedBox(width: treeVO.data.pid == null ? 16 : 2),
                  Container(child: Text(expandMenu ? name : '', style: new TextStyle(height: 1, fontSize: treeVO.data.menuDepth == '0' ? 14.0 : 12.0, fontWeight: layoutController.currentOpenedPageId == treeVO.data.id ? FontWeight.bold : FontWeight.normal, fontFamily: 'NotoSansKR')),),
                ],
              ),
              onTap: () {
                if (layoutController.currentOpenedPageId != treeVO.data.id && widget.onClick != null) {

                  if (treeVO.data.pid == null && _selectedItem != ''){
                    layoutController.currentOpenedPageId = treeVO.data.id;
                    _selectedItem = '';
                  }

                  widget.onClick(treeVO.data.toPage());
                  setState(() {});
                  if (Responsive.isDesktop(context) == false)
                    layoutController.scaffoldKey.currentState.openEndDrawer();
                }
              },
            );
          },
          ),
        );
      }
    }).toList();
    return listTileList;
  }
}



