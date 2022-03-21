import 'package:daeguro_admin_app/View/Today/header.dart';
import 'package:daeguro_admin_app/View/Today/dashboard2.dart';
import 'package:daeguro_admin_app/constants/constant.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //print('AgentAccountMain refresh');

    //Get.put(AgentController());

    return SafeArea(
      child: SingleChildScrollView(
        controller: ScrollController(),
        //physics: Responsive.isMobile(context) == true ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(defaultWidthPadding),
        //child: Container(),
        child: Column(
          children: [
            Header(title: "전체 현황"),
            SizedBox(height: defaultHeightPadding),
            Dashboard2()
          ],
        ),
      ),
    );
  }
}
