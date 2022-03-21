
import 'package:daeguro_admin_app/View/LogManager/logCouponList.dart';
import 'package:daeguro_admin_app/View/LogManager/logErrorList.dart';
import 'package:daeguro_admin_app/View/LogManager/logPrivacyList.dart';
import 'package:daeguro_admin_app/View/OrderManager/orderList.dart';
import 'package:daeguro_admin_app/View/Today/header.dart';
import 'package:daeguro_admin_app/constants/constant.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogCouponMain extends StatelessWidget {
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
            Header(title: "쿠폰관리 이력"),
            //SizedBox(height: defaultHeightPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      LogCouponListManager(),
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