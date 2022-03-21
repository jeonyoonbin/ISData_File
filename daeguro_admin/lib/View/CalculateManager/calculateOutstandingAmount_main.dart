
import 'package:daeguro_admin_app/View/CalculateManager/calculateOutstandingAmount.dart';
import 'package:daeguro_admin_app/View/Today/header.dart';
import 'package:daeguro_admin_app/constants/constant.dart';

import 'package:flutter/material.dart';

class CalculateOutstandingAmountManager extends StatelessWidget {
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
            Header(title: "수수료 미수금 관리"),
            //SizedBox(height: defaultHeightPadding),
            CalculateOutstandingAmount(),
          ],
        ),
      ),
    );
  }
}