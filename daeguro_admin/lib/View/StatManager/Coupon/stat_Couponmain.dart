
import 'package:daeguro_admin_app/View/StatManager/Coupon/statCouponManager.dart';
import 'package:daeguro_admin_app/View/Today/header.dart';
import 'package:daeguro_admin_app/constants/constant.dart';

import 'package:flutter/material.dart';

class StatCouponMain extends StatelessWidget {
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
            Header(title: "쿠폰 통계"),
            //SizedBox(height: defaultHeightPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      StatCouponManager()
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