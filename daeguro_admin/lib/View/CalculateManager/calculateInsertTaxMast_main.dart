
import 'package:daeguro_admin_app/View/CalculateManager/calculateInsertTaxMast.dart';
import 'package:daeguro_admin_app/View/Today/header.dart';
import 'package:daeguro_admin_app/constants/constant.dart';

import 'package:flutter/material.dart';

class CalculateInsertTaxMastMain extends StatelessWidget {
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
            Header(title: "전자세금계산서 생성"),
            //SizedBox(height: defaultHeightPadding),
            CalculateInsertTaxMast(),
          ],
        ),
      ),
    );
  }
}