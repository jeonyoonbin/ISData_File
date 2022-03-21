

import 'package:daeguro_admin_app/Common/routes.dart';
import 'package:daeguro_admin_app/Model/page_model.dart';
import 'package:daeguro_admin_app/Util/page_util.dart';
import 'package:daeguro_admin_app/View/Layout/layout_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LayoutContents extends StatefulWidget {
  final PageModel initPage;
  LayoutContents({Key key, this.initPage}) : super(key: key);

  @override
  LayoutContentsState createState() => LayoutContentsState();
}

class LayoutContentsState extends State<LayoutContents> with TickerProviderStateMixin {
  List<Widget> pages;
  LayoutController layoutController = Get.find();

  @override
  void initState() {
    if (widget.initPage != null) {
      WidgetsBinding.instance.addPostFrameCallback((c) {
        PageUtil.setPage(widget.initPage);
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print('---------------'+layoutController.currentPageURL);

    // AnimationController aniController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    // aniController.forward();
    //
    // return Expanded(
    //   child: FadeTransition(
    //     opacity: CurvedAnimation(parent: aniController, curve: Curves.easeIn),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: <Widget>[
    //         Container(
    //           child: Expanded(
    //             child:layoutRoutesData[layoutController.currentPageURL] ?? Container(),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );

    //print('layout_contents refresh');

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Expanded(
              child:layoutRoutesData[layoutController.currentPageURL] ?? Container(),
            ),
          ),
        ],
      ),
    );
  }
}
