
import 'package:daeguro_admin_app/View/CouponManager/BrandcouponShopManager.dart';
import 'package:daeguro_admin_app/View/Today/header.dart';
import 'package:daeguro_admin_app/constants/constant.dart';

import 'package:flutter/material.dart';

class BrandCouponShopMain extends StatelessWidget {
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
            Header(title: "브랜드 쿠폰 가맹점 관리"),
            //SizedBox(height: defaultHeightPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      BrandCouponShopManager(),
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