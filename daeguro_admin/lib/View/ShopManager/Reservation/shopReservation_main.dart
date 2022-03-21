import 'package:daeguro_admin_app/View/ShopManager/Reservation/shopReservationList.dart';
import 'package:daeguro_admin_app/View/Today/header.dart';
import 'package:daeguro_admin_app/constants/constant.dart';
import 'package:flutter/material.dart';

class ShopReservationMain extends StatelessWidget {
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
            Header(title: "예약 현황"),
            //SizedBox(height: defaultHeightPadding),
            ShopReservationList(),
          ],
        ),
      ),
    );
  }
}