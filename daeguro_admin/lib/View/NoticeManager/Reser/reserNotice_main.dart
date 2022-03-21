
import 'package:daeguro_admin_app/View/NoticeManager/Reser/reserNoticeList.dart';
import 'package:daeguro_admin_app/View/NoticeManager/noticeList.dart';
import 'package:daeguro_admin_app/View/Today/header.dart';
import 'package:daeguro_admin_app/constants/constant.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReserNoticeMain extends StatelessWidget {
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
          children: [
            Header(title: "공지사항&이벤트(예약)"),
            //SizedBox(height: defaultHeightPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      ReserNoticeList(),
                      // SizedBox(height: defaultPadding*2, child: Icon(Icons.unfold_more, color: Colors.grey,),),
                      // AgentAccountDetailSheet(),
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