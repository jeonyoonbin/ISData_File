
import 'package:daeguro_admin_app/View/ShopManager/ImageManager/shopImageList.dart';
import 'package:daeguro_admin_app/View/Today/header.dart';
import 'package:daeguro_admin_app/constants/constant.dart';

import 'package:flutter/material.dart';

class ShopImageMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //print('AgentAccountMain refresh');

    //Get.put(AgentController());

    return SafeArea(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: defaultWidthPadding, vertical: defaultHeightPadding),
        //child: Container(),
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          children: [
            Header(title: "이미지 관리"),
            //SizedBox(height: defaultHeightPadding),
            ShopImageList(),
          ],
        ),
      ),
    );
  }
}