
import 'package:daeguro_admin_app/View/Common/page_empty.dart';
import 'package:daeguro_admin_app/View/ReviewManager/reviewList.dart';
import 'package:daeguro_admin_app/View/TaxiManager/taxiNotice_list.dart';
import 'package:daeguro_admin_app/View/Today/header.dart';
import 'package:daeguro_admin_app/constants/constant.dart';

import 'package:flutter/material.dart';

class TaxiNoticeMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: defaultWidthPadding, vertical: defaultHeightPadding),
        //child: Container(),
        child: Column(
          children: [
            Header(title: "공지사항&이벤트"),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TaxiNoticeList(),//세부내용 작업중입니다.
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