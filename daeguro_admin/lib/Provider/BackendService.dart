import 'dart:async';

import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';



class BackendService{
  static Future<List<Map<String, String>>> getCopyMenuShopSuggestions(String mCode, String keyword) async {
    List<Map<String, String>> tempList = new List<Map<String, String>>();

    await ShopController.to.getShopNameListData(mCode, keyword).then((value) {
      value.forEach((element) {
          Map<String, String> nData = {'ccCode': element['ccCode'].toString(), 'shopCd': element['shopCd'].toString(), 'shopName': element['shopName'].toString()};
          tempList.add(nData);
      });
    });

    return tempList;
  }

  // static Future<List<Map<String, String>>> getMenuNameSuggestions(String shopCode, String keyword) async {
  //   List<Map<String, String>> tempList = new List<Map<String, String>>();
  //
  //   await ShopController.to.getMenuNameListData(shopCode, keyword).then((value) {
  //     value.forEach((element) {
  //       // Map<String, String> nData = {'ccCode': element['ccCode'].toString(), 'shopCd': element['shopCd'].toString(), 'shopName': element['shopName'].toString()};
  //       // tempList.add(nData);
  //     });
  //   });
  //
  //   return tempList;
  // }
}


