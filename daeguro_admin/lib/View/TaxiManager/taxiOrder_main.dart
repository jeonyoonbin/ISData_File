
import 'package:daeguro_admin_app/View/Common/page_empty.dart';
import 'package:daeguro_admin_app/View/ReviewManager/reviewList.dart';
import 'package:daeguro_admin_app/View/TaxiManager/taxiOrderList.dart';
import 'package:daeguro_admin_app/View/Today/header.dart';
import 'package:daeguro_admin_app/constants/constant.dart';

import 'package:flutter/material.dart';

class TaxiOrderMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: defaultWidthPadding, vertical: defaultHeightPadding),
        //child: Container(),
        child: Column(
          children: [
            Header(title: "오더 관리"),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TaxiOrderList(),//텍시 오더 관리 클래스 생성후, 변경 필요
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}