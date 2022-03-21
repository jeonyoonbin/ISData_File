
import 'package:daeguro_admin_app/View/CalculateManager/calculateCcMileage.dart';
import 'package:daeguro_admin_app/View/Today/header.dart';
import 'package:daeguro_admin_app/constants/constant.dart';

import 'package:flutter/material.dart';

class CalculateCcMileageManager extends StatelessWidget {
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
            Header(title: "콜센터 적립금 관리"),
            //SizedBox(height: defaultHeightPadding),
            CalculateCcMileage(),
          ],
        ),
      ),
    );
  }
}