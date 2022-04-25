import 'package:daeguro_admin_app/Network/DioClient.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController with SingleGetTickerProviderMixin {
  static AuthController get to => Get.find();

  @override
  void onInit() {
    super.onInit();
  }

  Future<List<dynamic>> getAuthData(String ucode, String pid, String sidebar_yn) async {
    List<dynamic> qData = [];

    final response = await DioClient().get(ServerInfo.REST_URL_AUTH_ADMINROLE + '?ucode=$ucode&pid=$pid&sidebar_yn=$sidebar_yn');

    qData.clear();

    if (response.data['code'] == '00') {
      qData.assignAll(response.data['data']);
    }
    else
      return null;

    return qData;
  }

  Future<List> getMenuData(String id, String menuDepth) async {
    List qDataItems = [];

    final result = await DioClient().get(ServerInfo.REST_URL_AUTH_ADMINMENU+'?id=$id&menudepth=$menuDepth');

    if (result.data['code'] == '00')
      qDataItems.assignAll(result.data['data']);
    else
      return null;

    return qDataItems;
  }

  Future<dynamic> postMenuData(String pid, String menuDepth, String name, String icon, String url, String visible) async {
    final response = await DioClient().post(ServerInfo.REST_URL_AUTH_ADMINMENU + '?pid=$pid&menuDepth=$menuDepth&name=$name&icon=$icon&url=$url&visible=$visible');

    if (response.data['code'] != '00') {
      return response.data['msg'];
    }
    else
      return null;
  }

  Future<dynamic> putMenuData(String id, String pid, String menuDepth, String name, String icon, String url, String visible) async {
    final response = await DioClient().put(ServerInfo.REST_URL_AUTH_ADMINMENU + '?id=$id&pid=$pid&menuDepth=$menuDepth&name=$name&icon=$icon&url=$url&visible=$visible');

    if (response.data['code'] != '00') {
      return response.data['msg'];
    }
    else
      return null;
  }

  Future<List> getChildMenuData(String id) async {
    List qDataItems = [];

    final result = await DioClient().get(ServerInfo.REST_URL_AUTH_ADMINMENU_CHILD+'?id=$id');

    if (result.data['code'] == '00')
      qDataItems.assignAll(result.data['data']);
    else
      return null;

    return qDataItems;
  }

  Future<List<dynamic>> getSideBarData(String ucode) async {
    List<dynamic> qData = [];

    final response = await DioClient().get(ServerInfo.REST_URL_AUTH_ADMINROLE_SIDEBAR+'?ucode=$ucode');

    qData.clear();

    if (response.data['code'] == '00') {
      qData.assignAll(response.data['data']);
    }
    else
      return null;

    return qData;
  }

  Future<dynamic> putAuthData(String id, String ucode, String read_yn, String update_yn, String create_yn, String delete_yn, String download_yn) async {
    String mod_ucode = GetStorage().read('logininfo')['uCode'];

    final response = await DioClient().put(ServerInfo.REST_URL_AUTH_ADMINROLE + '?id=$id&ucode=$ucode&read_yn=$read_yn&update_yn=$update_yn&create_yn=$create_yn&delete_yn=$delete_yn&download_yn=$download_yn&mod_ucode=$mod_ucode');

    if (response.data['code'] != '00') {
      return response.data['msg'];
    }
    else
      return null;
  }

  Future<dynamic> putAllAuthData(String id, String working, String read_yn, String update_yn, String create_yn, String delete_yn, String download_yn) async {
    String mod_ucode = GetStorage().read('logininfo')['uCode'];

    final response = await DioClient().put(ServerInfo.REST_URL_AUTH_ADMINROLE_ALL + '?id=$id&working=$working&read_yn=$read_yn&update_yn=$update_yn&create_yn=$create_yn&delete_yn=$delete_yn&download_yn=$download_yn&mod_ucode=$mod_ucode');

    if (response.data['code'] != '00') {
      return response.data['msg'];
    }
    else
      return null;
  }

  Future<dynamic> deleteAuthData(String id) async {
    final response = await DioClient().delete(ServerInfo.REST_URL_AUTH_ADMINMENU + '?id=$id');

    if (response.data['code'] != '00') {
      return response.data['msg'];
    }
    else
      return null;
  }

  Future<dynamic> updateAdminMenuSort(dynamic data) async {
    final response = await DioClient().put(ServerInfo.REST_URL_AUTH_ADMINMENU_SORT, data: data);

    if (response.data['code'] != '00') {
      return response.data['msg'];
    }
    else
      return null;
  }
}
