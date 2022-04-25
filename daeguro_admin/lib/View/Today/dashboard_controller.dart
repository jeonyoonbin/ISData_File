import 'package:daeguro_admin_app/Model/dashboard/dashboardTodayCountModel.dart';
import 'package:daeguro_admin_app/Network/DioClient.dart';

import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class DashBoardController extends GetxController with SingleGetTickerProviderMixin {
  static DashBoardController get to => Get.find();

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

    final response = await DioClient().get(ServerInfo.REST_URL_DASHBOARD);

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

    final response = await DioClient().get(ServerInfo.REST_URL_DASHBOARDWEEKCUSTOMER);

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

    final response = await DioClient().get(ServerInfo.REST_URL_DASHBOARDWEEKORDER);

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

    final response = await DioClient().get(ServerInfo.REST_URL_DASHBOARDTODAYCOUNT);

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
    }
  }

  Future<dynamic> getTotalInstalled() async {
    dynamic qData = null;

    final response = await DioClient().get(ServerInfo.REST_URL_DASHBOARDTOTALINSTALLOS);

    if (response.data['code'] == '00') {
      qData = response.data['data'];
    }
    else
      return null;

    return qData;
  }

  Future<dynamic> getTotalOrders() async {
    dynamic qData = null;

    final response = await DioClient().get(ServerInfo.REST_URL_DASHBOARDTOTALORDERS);

    if (response.data['code'] == '00') {
      qData = response.data['data'];
    }
    else
      return null;

    return qData;
  }

  Future<dynamic> getTotalYearMembers() async {
    dynamic qData = null;

    final response = await DioClient().get(ServerInfo.REST_URL_DASHBOARDTOTALYEARMEMBERS);

    if (response.data['code'] == '00') {
      qData = response.data['data'];
    }
    else
      return null;

    return qData;
  }

  Future<dynamic> getTotalCancel() async {
    dynamic qData = null;

    final response = await DioClient().get(ServerInfo.REST_URL_DASHBOARDTOTALCANCEL);

    if (response.data['code'] == '00') {
      qData = response.data['data'];
    }
    else
      return null;

    return qData;
  }
}
