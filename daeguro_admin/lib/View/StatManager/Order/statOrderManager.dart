
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/View/StatManager/Order/statOrder_CategoryOrder.dart';
import 'package:daeguro_admin_app/View/StatManager/Order/statOrder_DailyCancelReason.dart';
import 'package:daeguro_admin_app/View/StatManager/Order/statOrder_DailyCompletedCanceled.dart';
import 'package:daeguro_admin_app/View/StatManager/Order/statOrder_DailyOrderPayGbn.dart';
import 'package:daeguro_admin_app/View/StatManager/Order/statOrder_GunguOrder.dart';
import 'package:daeguro_admin_app/View/StatManager/Order/statOrder_PayOrder.dart';
import 'package:daeguro_admin_app/View/StatManager/Order/statOrder_TimeOrder.dart';
import 'package:daeguro_admin_app/View/StatManager/Order/stat_DailyAgeToOrder.dart';
import 'package:daeguro_admin_app/View/StatManager/Shop/statShop_TotalOrderList.dart';
import 'package:daeguro_admin_app/View/StatManager/stat_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class StatOrderManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StatOrderManagerState();
  }
}

class StatOrderManagerState extends State with SingleTickerProviderStateMixin{

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

    _nestedTabController = new TabController(length: 9, vsync: this);

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
            indicator: UnderlineTabIndicator(borderSide: BorderSide(width: 4, color: Color(0xFF646464)), insets: EdgeInsets.only(left: 0, right: 8, bottom: 4)),
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
                Padding(padding: const EdgeInsets.only(right: 8), child: Tab(text: '     전체 주문      ',)),
                Padding(padding: const EdgeInsets.only(right: 8), child: Tab(text: '     카테고리별 주문      ',)),
                Padding(padding: const EdgeInsets.only(right: 8), child: Tab(text: '     시간대별 주문     ',)),
                Padding(padding: const EdgeInsets.only(right: 8), child: Tab(text: '     결제별 주문     ',)),
                Padding(padding: const EdgeInsets.only(right: 8), child: Tab(text: '     군구별 주문     ',)),
                Padding(padding: const EdgeInsets.only(right: 8), child: Tab(text: '     일자별 완료 및 취소     ',)),
                Padding(padding: const EdgeInsets.only(right: 8), child: Tab(text: '     일자별 주문취소 사유     ',)),
                Padding(padding: const EdgeInsets.only(right: 8), child: Tab(text: '     일자별 결제     ',)),
                Padding(padding: const EdgeInsets.only(right: 8), child: Tab(text: '     연령별 주문     ',)),
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
            height: (MediaQuery.of(context).size.height-154),
            child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _nestedTabController,
                children: <Widget>[
                    StatShopTotalOrderList(),
                    StatOrderCategoryList(),
                    StatOrderTimeList(),
                    StatOrderPayList(),
                    StatOrderGunguList(),
                    StatOrderDailyCompletedCanceled(),
                    StatOrderDailyCancelReason(),
                    StatOrderDailyPayGbn(),
                    StatDailyAgeToOrder(),
                ]
            ),
          ),
        ],
      ),
    );
  }
}
