
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Model/page_model.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/Util/page_util.dart';
import 'package:daeguro_admin_app/View/AuthManager/auth_controller.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/Layout/layout_sidebar.dart';
import 'package:daeguro_admin_app/View/Layout/layout_contents.dart';
import 'package:daeguro_admin_app/constants/constant.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'layout_controller.dart';

class Layout extends StatefulWidget {
  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State {
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  final GlobalKey<LayoutContentsState> layoutContentsKey = GlobalKey<LayoutContentsState>();
  final PageModel menuMainToday = PageModel(id: '1', url: '/', name: '전체현황');

  LayoutController layoutController = Get.find();

  @override
  void initState() {
    super.initState();

    Get.put(AuthController());
  }

  @override
  Widget build(BuildContext context) => GetBuilder<LayoutController>(builder: (_) => getBuild(context));

  Widget getBuild(BuildContext context) {
    //print('layoutController.currentOpenedPageId: ${layoutController.currentOpenedPageId}');

    return Scaffold(
      key: layoutController.scaffoldKey,
      drawer: Responsive.isDesktop(context) == false
          ? Container(
              width: sidebarWidth,
              child: LayoutSideBarMenu(
                  onClick: (PageModel v) {
                    PageUtil.setPage(v);
                  }
              )
            )
          : null,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Container(
                  width: sidebarWidth,
                  child: LayoutSideBarMenu(
                      onClick: (PageModel v) {
                        PageUtil.setPage(v);
                      }
                  )
              ),

            LayoutContents(key: layoutContentsKey, initPage: (layoutController.currentOpenedPageId == '1' || layoutController.currentOpenedPageId == null) ? menuMainToday : null),
          ],
        ),
        // child: Responsive.isMobile(context) == true
        //     ? Center(child: Text('지원하지않는 해상도입니다.'),)
        //     : Row(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //             if (Responsive.isDesktop(context))
        //               Container(width: sidebarWidth, child: LayoutSideBarMenu(onClick: (PageModel v) => PageUtil.setPage(v))),
        //
        //           LayoutContents(key: layoutContentsKey, initPage: (layoutController.currentOpenedPageId == 'mSeq_0' || layoutController.currentOpenedPageId == null) ? menuMainToday : null),
        //         ],
        // ),
      ),
    );
  }
}
