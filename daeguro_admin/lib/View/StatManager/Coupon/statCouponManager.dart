import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/View/StatManager/Coupon/statCoupon_DailyDrgCoupon.dart';
import 'package:daeguro_admin_app/View/StatManager/stat_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class StatCouponManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StatCouponManagerState();
  }
}

class StatCouponManagerState extends State with SingleTickerProviderStateMixin{

  TabController _nestedTabController;
  int current_tabIdx = 0;

  List<Widget> _tabs = [];

  _reset() {
  }

  _query() {

  }

  loadData() async {

  }

  addDetailData() async {

  }

  removeDetailData() {

  }

  @override
  void initState() {
    super.initState();

    Get.put(StatController());
    Get.put(ShopController());

    _nestedTabController = new TabController(length: 1, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((c) {

    });
  }

  @override
  void dispose() {
    _nestedTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.only(left: 50, right: 50, bottom: 20, top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            controller: _nestedTabController,
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 4, color: Color(0xFF646464)),
                insets: EdgeInsets.only(left: 0, right: 8, bottom: 4)
            ),
            isScrollable: true,
            labelPadding: EdgeInsets.only(left: 0, right: 0),
            // indicatorColor: Colors.blue,
            labelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.label,
            // unselectedLabelColor: Colors.black54,
            //isScrollable: true,
            // indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: TextStyle(fontSize: 13, fontFamily: 'NotoSansKR'),
            tabs: [
              //Padding(padding: const EdgeInsets.only(right: 8), child: Tab(text: '     대구로 쿠폰 통계      ')),
              Padding(padding: const EdgeInsets.only(right: 8), child: Tab(text: '     대구로 쿠폰 통계(일별)      '))
            ],
            onTap: (v) {
              setState(() {
                current_tabIdx = v;
                //print('----- current_tabIdx: '+current_tabIdx.toString());
              });
            },
          ),
          Container(
            width: double.infinity,
            height: (MediaQuery.of(context).size.height-122),//150),
            child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _nestedTabController,
                children: <Widget>[
                  //StatCoupon_DrgCoupon(),
                  StatCouponDailyDrgCoupon(),
                ]
            ),
          ),
        ],
      ),
    );
  }
}
