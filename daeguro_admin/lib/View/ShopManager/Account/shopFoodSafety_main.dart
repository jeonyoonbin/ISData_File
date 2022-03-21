
import 'package:daeguro_admin_app/View/ShopManager/Account/shopFoodSafetyList.dart';
import 'package:daeguro_admin_app/View/Today/header.dart';
import 'package:daeguro_admin_app/constants/constant.dart';

import 'package:flutter/material.dart';

class ShopFoodSafetyMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: defaultWidthPadding, vertical: defaultHeightPadding),
        //child: Container(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Header(title: "영양성분/알레르기정보"),
            //SizedBox(height: defaultHeightPadding),
            ShopFoodSafetyList(),
          ],
        ),
      ),
    );
  }
}