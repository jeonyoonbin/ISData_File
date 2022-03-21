import 'package:daeguro_admin_app/Model/dashboard/dashboardTodayCountModel.dart';
import 'package:daeguro_admin_app/Provider/RestApiProvider.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class DashBoardController extends GetxController with SingleGetTickerProviderMixin {
  static DashBoardController get to => Get.find();

  //RxList<DashBoardWeekOrderModel> dataWeekOrderList = <DashBoardWeekOrderModel>[].obs;
  //RxList<DashBoardWeekCustomerModel> dataWeekCustomerList = <DashBoardWeekCustomerModel>[].obs;

  //Rx<DashBoardModel> mData = DashBoardModel().obs;
  //Rx<DashBoardTodayCountModel> mTodayCountData = DashBoardTodayCountModel().obs;

  Rx<DashBoardTodayCountModel> mTodayCountData = DashBoardTodayCountModel().obs;

  int RefreshTime = 60;//5;//60;
  RxInt checkTimeCount = 0.obs;

  RxInt TOTAL_MEMBER = 0.obs;
  RxInt TODAY_APP_INSTALL = 0.obs;
  RxInt TODAY_MEMBER = 0.obs;
  RxInt TODAY_ORDER = 0.obs;
  RxInt TODAY_SHOP_CONFIRM = 0.obs;
  RxInt TODAY_COMPLETE_COUNT = 0.obs;

  @override
  void onInit() {
    Get.put(RestApiProvider());

    super.onInit();
  }

  void initCheckTimeCount()
  {
    checkTimeCount.value = RefreshTime;
  }

  void updateCheckTimeCount()
  {
    checkTimeCount--;
  }

  Future<dynamic> getData() async {
    dynamic qData;

    //var result = await RestApiProvider.to.getDashBoard();

    // dio 패키지
    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_DASHBOARD);

    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qData = response.data['data'];
      //mData.value = DashBoardModel.fromJson(qData);
    }
    else
      return null;

    return qData;
  }

  Future<List<dynamic>> getWeekCustomerData() async {
    List<dynamic> qData = [];

    //var result = await RestApiProvider.to.getDashBoardWeekCustomer();

    // dio 패키지
    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_DASHBOARDWEEKCUSTOMER);

    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qData.assignAll(response.data['data']);

      // dataWeekCustomerList.clear();
      // qData.forEach((element) {
      //   DashBoardWeekCustomerModel temp = DashBoardWeekCustomerModel.fromJson(element);
      //   dataWeekCustomerList.value.add(temp);
      // });
    }
    else
      return null;

    return qData;
  }

  Future<List<dynamic>> getWeekOrderData() async {
    List<dynamic> qData = [];

    //var result = await RestApiProvider.to.getDashBoardWeekOrder();

    // dio 패키지
    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_DASHBOARDWEEKORDER);

    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qData.assignAll(response.data['data']);

      // dataWeekOrderList.clear();
      // qData.forEach((element) {
      //   DashBoardWeekOrderModel temp = DashBoardWeekOrderModel.fromJson(element);
      //   dataWeekOrderList.value.add(temp);
      // });
    }
    else
      return null;

    return qData;
  }

  getTodayCountData() async {
    List<dynamic> qData = [];

    //var result = await RestApiProvider.to.getDashBoardTodayCount();

    // dio 패키지
    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_DASHBOARDTODAYCOUNT);

    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qData.assignAll(response.data['data']);
      //mTodayCountData.value = null;
      DashBoardTodayCountModel mTodayCountData = DashBoardTodayCountModel.fromJson(qData[0]);
      TOTAL_MEMBER.value = mTodayCountData.TOTAL_MEMBER;
      TODAY_APP_INSTALL.value = mTodayCountData.TODAY_APP_INSTALL;
      TODAY_MEMBER.value = mTodayCountData.TODAY_MEMBER;
      TODAY_ORDER.value = mTodayCountData.TODAY_ORDER;
      TODAY_SHOP_CONFIRM.value = mTodayCountData.TODAY_SHOP_CONFIRM;
      TODAY_COMPLETE_COUNT.value = mTodayCountData.TODAY_COMPLETE_COUNT;

      mTodayCountData = null;
      qData.clear();

      dio = null;
    }
  }

  // Future<dynamic> getInfoSumTotal() async {
  //   dynamic qData = null;
  //
  //   //var result = await RestApiProvider.to.getDaeguroTotalInfoSum();
  //
  //   // dio 패키지
  //   var dio = Dio();
  //   final response = await dio.get(ServerInfo.REST_URL_DASHBOARDTOTALINFOSUM);
  //
  //   dio.clear();
  //   dio.close();
  //
  //   if (response.data['code'] == '00') {
  //     //qData.assignAll(result.body['totalOS']);
  //     qData = response.data;
  //     // dataWeekCustomerList.clear();
  //     // qData.forEach((element) {
  //     //   DashBoardWeekCustomerModel temp = DashBoardWeekCustomerModel.fromJson(element);
  //     //   dataWeekCustomerList.value.add(temp);
  //     // });
  //   }
  //   else
  //     return null;
  //
  //   return qData;
  // }

  Future<dynamic> getTotalInstalled() async {
    dynamic qData = null;

    // dio 패키지
    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_DASHBOARDTOTALINSTALLOS);

    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qData = response.data['data'];
    }
    else
      return null;

    return qData;
  }

  Future<dynamic> getTotalOrders() async {
    dynamic qData = null;

    // dio 패키지
    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_DASHBOARDTOTALORDERS);

    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qData = response.data['data'];
    }
    else
      return null;

    return qData;
  }

  Future<dynamic> getTotalYearMembers() async {
    dynamic qData = null;

    // dio 패키지
    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_DASHBOARDTOTALYEARMEMBERS);

    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qData = response.data['data'];
    }
    else
      return null;

    return qData;
  }

  Future<dynamic> getTotalCancel() async {
    dynamic qData = null;

    // dio 패키지
    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_DASHBOARDTOTALCANCEL);

    dio.clear();
    dio.close();

    if (response.data['code'] == '00') {
      qData = response.data['data'];
    }
    else
      return null;

    return qData;
  }

  // Future<List<dynamic>> getInfoSumYearmembers() async {
  //   List<dynamic> qData = [];
  //
  //   var result = await RestApiProvider.to.getDaeguroTotalInfoSum();
  //
  //   if (result.body['code'] == '00') {
  //     qData.assignAll(result.body['totalYearMembers']);
  //
  //     // dataWeekCustomerList.clear();
  //     // qData.forEach((element) {
  //     //   DashBoardWeekCustomerModel temp = DashBoardWeekCustomerModel.fromJson(element);
  //     //   dataWeekCustomerList.value.add(temp);
  //     // });
  //   }
  //   else
  //     return null;
  //
  //   return qData;
  // }
  //
  // Future<List<dynamic>> getInfoSumOrders() async {
  //   List<dynamic> qData = [];
  //
  //   var result = await RestApiProvider.to.getDaeguroTotalInfoSum();
  //
  //   if (result.body['code'] == '00') {
  //     qData.assignAll(result.body['totalOrders']);
  //
  //     // dataWeekCustomerList.clear();
  //     // qData.forEach((element) {
  //     //   DashBoardWeekCustomerModel temp = DashBoardWeekCustomerModel.fromJson(element);
  //     //   dataWeekCustomerList.value.add(temp);
  //     // });
  //   }
  //   else
  //     return null;
  //
  //   return qData;
  // }
  //
  // Future<List<dynamic>> getInfoSumCancel() async {
  //   List<dynamic> qData = [];
  //
  //   var result = await RestApiProvider.to.getDaeguroTotalInfoSum();
  //
  //   if (result.body['code'] == '00') {
  //     qData.assignAll(result.body['totalCancel']);
  //
  //     // dataWeekCustomerList.clear();
  //     // qData.forEach((element) {
  //     //   DashBoardWeekCustomerModel temp = DashBoardWeekCustomerModel.fromJson(element);
  //     //   dataWeekCustomerList.value.add(temp);
  //     // });
  //   }
  //   else
  //     return null;
  //
  //   return qData;
  // }
}
