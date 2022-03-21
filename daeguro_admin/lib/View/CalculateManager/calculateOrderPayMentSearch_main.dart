
import 'package:daeguro_admin_app/View/CalculateManager/calculateOrderPayMentSearch.dart';
import 'package:daeguro_admin_app/View/Today/header.dart';
import 'package:daeguro_admin_app/constants/constant.dart';

import 'package:flutter/material.dart';

class CalculateOrderPayMentSearchManager extends StatelessWidget {
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
            Header(title: "주문별 정산금액 조회"),
            //SizedBox(height: defaultHeightPadding),
            CalculateOrderPayMentSearch(),
          ],
        ),
      ),
    );
  }
}