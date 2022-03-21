

import 'package:daeguro_admin_app/View/AgentManager/agentAccount_main.dart';
import 'package:daeguro_admin_app/View/ApiCompanyManager/apiCompany_main.dart';
import 'package:daeguro_admin_app/View/CalculateManager/calculateCcMileage_main.dart';
import 'package:daeguro_admin_app/View/CalculateManager/calculateCommision_main.dart';
import 'package:daeguro_admin_app/View/CalculateManager/calculateInsertTaxMast_main.dart';
import 'package:daeguro_admin_app/View/CalculateManager/calculateOrderPayMentSearch_main.dart';
import 'package:daeguro_admin_app/View/CalculateManager/calculateSearchShopTax_main.dart';
import 'package:daeguro_admin_app/View/CalculateManager/calculateShopMileage_main.dart';
import 'package:daeguro_admin_app/View/CodeManager/codeB2BCouponListMain.dart';
import 'package:daeguro_admin_app/View/CodeManager/codeBrandCouponListMain.dart';
import 'package:daeguro_admin_app/View/CodeManager/codeCouponListMain.dart';
import 'package:daeguro_admin_app/View/CodeManager/codeListMain.dart';
import 'package:daeguro_admin_app/View/CouponManager/B2BUsercoupon_main.dart';
import 'package:daeguro_admin_app/View/CouponManager/B2Bcoupon_main.dart';
import 'package:daeguro_admin_app/View/CouponManager/BrandcouponApp_main.dart';
import 'package:daeguro_admin_app/View/CouponManager/BrandcouponList_main.dart';
import 'package:daeguro_admin_app/View/CouponManager/BrandcouponShop_main.dart';
import 'package:daeguro_admin_app/View/CouponManager/coupon_main.dart';
import 'package:daeguro_admin_app/View/CustomerManager/customer_main.dart';
import 'package:daeguro_admin_app/View/LogManager/logAuthMain.dart';
import 'package:daeguro_admin_app/View/LogManager/logCouponMain.dart';
import 'package:daeguro_admin_app/View/LogManager/logPrivacyMain.dart';
import 'package:daeguro_admin_app/View/LogManager/logTaxMain.dart';
import 'package:daeguro_admin_app/View/HistoryManager/history_B2BCouponmain.dart';
import 'package:daeguro_admin_app/View/HistoryManager/history_BrandCouponmain.dart';
import 'package:daeguro_admin_app/View/HistoryManager/history_Couponmain.dart';
import 'package:daeguro_admin_app/View/HistoryManager/history_Mileagemain.dart';
import 'package:daeguro_admin_app/View/NoticeManager/Reser/reserNotice_main.dart';
import 'package:daeguro_admin_app/View/OrderManager/orderCancelListmain.dart';
import 'package:daeguro_admin_app/View/OrderManager/orderShopCancelListmain.dart';
import 'package:daeguro_admin_app/View/LogManager/logErrorMain.dart';
import 'package:daeguro_admin_app/View/LoginSMS.dart';
import 'package:daeguro_admin_app/View/MappingManager/mapping_main.dart';
import 'package:daeguro_admin_app/View/MileageManager/mileageSale_main.dart';
import 'package:daeguro_admin_app/View/MileageManager/mileage_main.dart';
import 'package:daeguro_admin_app/View/NoticeManager/notice_main.dart';
import 'package:daeguro_admin_app/View/OrderManager/order_main.dart';
import 'package:daeguro_admin_app/View/RequestManager/requestList_main.dart';
import 'package:daeguro_admin_app/View/ReviewManager/review_main.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopFoodSafety_main.dart';
import 'package:daeguro_admin_app/View/ShopManager/Event/shopEvent_main.dart';
import 'package:daeguro_admin_app/View/ShopManager/ImageManager/shopImage_main.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopRegNoList_main.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_main.dart';
import 'package:daeguro_admin_app/View/ShopManager/Reservation/shopReservation_main.dart';
import 'package:daeguro_admin_app/View/StatManager/Coupon/stat_Couponmain.dart';
import 'package:daeguro_admin_app/View/StatManager/Customer/stat_Customermain.dart';
import 'package:daeguro_admin_app/View/StatManager/Mileage/stat_Mileagemain.dart';
import 'package:daeguro_admin_app/View/StatManager/Order/stat_Ordermain.dart';
import 'package:daeguro_admin_app/View/StatManager/Shop/stat_Shopmain.dart';
import 'package:daeguro_admin_app/View/Today/dashboard_screen.dart';
import 'package:daeguro_admin_app/View/AuthManager/AuthManager_main.dart';
import 'package:daeguro_admin_app/View/UserManager/user_main.dart';
import 'package:daeguro_admin_app/View/VoucherManager/voucher_main.dart';
import 'package:daeguro_admin_app/View/common/page_401.dart';
import 'package:daeguro_admin_app/View/common/page_404.dart';
import 'package:daeguro_admin_app/View/common/page_empty.dart';
import 'package:daeguro_admin_app/View/userInfo/user_info_mine.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/Layout/layout.dart';
import 'package:flutter/material.dart';

Map<String, Widget> layoutRoutesData = {
  '/': DashboardScreen(),//MainToday(),//DailyStatusInfo(),//

  '/userManager': UserMain(),

  '/agentAccountManager': AgentAccountMain(),

  '/shopAccountManager': ShopAccountMain(),
  '/shopAccountModificationRegNo': ShopRegNoListMain(),
  '/shopImageManager': ShopImageMain(),
  '/ShopEventList': ShopEventMain(),
  '/ShopFoodSafety': ShopFoodSafetyMain(),
  '/ShopReservationMain': ShopReservationMain(),

  '/orderManager': OrderMain(),
  '/orderCompleteToCancel': OrderCancelListMain(),
  '/orderShopCancelList': OrderShopCancelListMain(),

  '/RequestList': RequestManager(),

  '/ApiCompanyList': APICompanyMain(),

  '/CouponListManager': CouponMain(),
  '/B2BCouponListManager': B2BCouponMain(),
  '/BrandCouponAppListManager': BrandCouponAppMain(),
  '/BrandCouponShopListManager': BrandCouponShopMain(),

  '/B2BCouponUserListManager': B2BUserCouponMain(),
  '/BrandCouponListManager': BrandCouponMain(),

  '/savingsManager': PageEmpty(),

  '/NoticeListManager': NoticeMain(),
  '/ReserNoticeListManager': ReserNoticeMain(),
  '/customerListManager': CustomerMain(),

  '/historyCouponList': HistoryCouponMain(),
  '/historyB2BCouponList': HistoryB2BCouponMain(),
  '/historyBrandCouponList': HistoryBrandCouponMain(),
  '/historyMileageList': HistoryMileageMain(),

  '/MileageInOut': MileageMain(),
  '/MileageSaleInOut': MileageSaleMain(),

  '/statShopManager': StatShopMain(),
  '/statCustomerManager': StatCustomerMain(),
  '/statOrderManager': StatOrderMain(),
  '/statCouponManager': StatCouponMain(),
  '/statMileageManager': StatMileageMain(),

  '/MappingList': MappingMain(),//ImageUpload(),

  '/userInfoMine': UserInfoMine(),

  '/userAuthManager' : AuthManagerMain(),

  '/CalculateShopMileage': CalculateShopMileageManager(),
  '/CalculateCcMileage': CalculateCcMileageManager(),
  '/CalculateCommission': CalculateCommissionManager(),
  '/CalculateOrderPayMentSearch': CalculateOrderPayMentSearchManager(),
  '/CalculateInsertTaxMast': CalculateInsertTaxMastMain(),
  '/CalculateSearchShopTax': calculateSearchShopTaxMain(),

  //'/CalculateOutstandingAmount': CalculateOutstandingAmountManager(),

  '/LogPrivacyListManager': LogPrivacyMain(),
  '/LogErrorListManager': LogErrorMain(),
  '/LogTaxListManager': LogTaxMain(),
  '/LogCouponListManager': LogCouponMain(),
  '/LogAuthListManager': LogAuthMain(),

  '/codeListManager': CodeListMain(),
  '/codeCouponListManager': CodeCouponListMain(),
  '/codeB2BCouponListManager': CodeB2BCouponListMain(),
  '/codeBrandCouponListManager': CodeBrandCouponListMain(),

  '/ReviewListManager': ReviewMain(),

  '/VoucherListManager': VoucherMain(),


  '/layout401': Page401(),
  '/layout404': Page404(),
};

Map<String, Widget> routesData = {
  '/login': LoginSMS(),
  // '/register': Register(),
  '/': Layout(),
  '/401': Page401(),
  '/404': Page404(),
};
List<String> whiteRouters = ['/register'];

Map<String, WidgetBuilder> routes = routesData.map((key, value) {
  return MapEntry(key, (context) => value);
});

class Routes {
  static onGenerateRoute(RouteSettings settings) {
    String name = settings.name;
    //print('before name-> '+name);

    if (!routes.containsKey(name)) {
      name = '/404';
    }
    else if (!Utils.isLogin() && !whiteRouters.contains(name)) {
      name = '/login';
    }

    // if (!Utils.isLogin() && !whiteRouters.contains(name)) {
    //   name = '/login';
    // }

    // print('page move-> '+name);

    return MaterialPageRoute(builder: routes[name], settings: settings);
  }
}
