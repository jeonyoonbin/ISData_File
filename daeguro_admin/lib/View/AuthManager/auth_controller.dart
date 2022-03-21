import 'package:daeguro_admin_app/Provider/RestApiProvider.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController with SingleGetTickerProviderMixin {
  static AuthController get to => Get.find();

  @override
  void onInit() {
    Get.put(RestApiProvider());

    super.onInit();
  }

  Future<List<dynamic>> getAuthData(String ucode, String pid, String sidebar_yn) async {
    List<dynamic> qData = [];

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_AUTH_ADMINROLE + '?ucode=$ucode&pid=$pid&sidebar_yn=$sidebar_yn');

    dio.clear();
    dio.close();

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

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_AUTH_ADMINMENU+'?id=$id&menudepth=$menuDepth');

    dio.clear();
    dio.close();

    //print('getMenu -> ${result.data.toString()}');

    if (result.data['code'] == '00')
      qDataItems.assignAll(result.data['data']);
    else
      return null;

    return qDataItems;
  }

  Future<dynamic> postMenuData(String pid, String menuDepth, String name, String icon, String url, String visible) async {
    // dio 패키지
    var dio = Dio();
    final response = await dio.post(ServerInfo.REST_URL_AUTH_ADMINMENU + '?pid=$pid&menuDepth=$menuDepth&name=$name&icon=$icon&url=$url&visible=$visible');

    dio.clear();
    dio.close();

    if (response.data['code'] != '00') {
      return response.data['msg'];
    }
    else
      return null;
  }

  Future<dynamic> putMenuData(String id, String pid, String menuDepth, String name, String icon, String url, String visible) async {
    // dio 패키지
    var dio = Dio();
    final response = await dio.put(ServerInfo.REST_URL_AUTH_ADMINMENU + '?id=$id&pid=$pid&menuDepth=$menuDepth&name=$name&icon=$icon&url=$url&visible=$visible');

    dio.clear();
    dio.close();

    if (response.data['code'] != '00') {
      return response.data['msg'];
    }
    else
      return null;
  }

  Future<List> getChildMenuData(String id) async {
    List qDataItems = [];

    var dio = Dio();
    final result = await dio.get(ServerInfo.REST_URL_AUTH_ADMINMENU_CHILD+'?id=$id');

    dio.clear();
    dio.close();

    //print('getMenu -> ${result.data.toString()}');

    if (result.data['code'] == '00')
      qDataItems.assignAll(result.data['data']);
    else
      return null;

    return qDataItems;
  }

  Future<List<dynamic>> getSideBarData(String ucode) async {
    List<dynamic> qData = [];

    var dio = Dio();
    final response = await dio.get(ServerInfo.REST_URL_AUTH_ADMINROLE_SIDEBAR + '?ucode=$ucode');

    dio.clear();
    dio.close();

    qData.clear();

    //print('getSideBarData response -> ${response.data.toString()}');

    if (response.data['code'] == '00') {
      qData.assignAll(response.data['data']);
    }
    else
      return null;

    return qData;
  }

  // postData(Map data, BuildContext context) async {
  //   var result = await RestApiProvider.to.postUser(data);
  //
  //   if (result.body['code'] != '00') {
  //     ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
  //   }
  // }
  //
  Future<dynamic> putAuthData(String id, String ucode, String read_yn, String update_yn, String create_yn, String delete_yn, String download_yn) async {
    String mod_ucode = GetStorage().read('logininfo')['uCode'];

    // dio 패키지
    var dio = Dio();
    final response = await dio.put(ServerInfo.REST_URL_AUTH_ADMINROLE + '?id=$id&ucode=$ucode&read_yn=$read_yn&update_yn=$update_yn&create_yn=$create_yn&delete_yn=$delete_yn&download_yn=$download_yn&mod_ucode=$mod_ucode');

    dio.clear();
    dio.close();

    //print('putData response -> ${response.data.toString()}');

    if (response.data['code'] != '00') {
      return response.data['msg'];
    }
    else
      return null;
  }

  Future<dynamic> putAllAuthData(String id, String working, String read_yn, String update_yn, String create_yn, String delete_yn, String download_yn) async {
    String mod_ucode = GetStorage().read('logininfo')['uCode'];

    // dio 패키지
    var dio = Dio();
    final response = await dio.put(ServerInfo.REST_URL_AUTH_ADMINROLE_ALL + '?id=$id&working=$working&read_yn=$read_yn&update_yn=$update_yn&create_yn=$create_yn&delete_yn=$delete_yn&download_yn=$download_yn&mod_ucode=$mod_ucode');

    dio.clear();
    dio.close();

    //print('putData response -> ${response.data.toString()}');

    if (response.data['code'] != '00') {
      return response.data['msg'];
    }
    else
      return null;
  }

  Future<dynamic> deleteAuthData(String id) async {
    String mod_ucode = GetStorage().read('logininfo')['uCode'];

    // dio 패키지
    var dio = Dio();
    final response = await dio.delete(ServerInfo.REST_URL_AUTH_ADMINMENU + '?id=$id');

    dio.clear();
    dio.close();

    if (response.data['code'] != '00') {
      return response.data['msg'];
    }
    else
      return null;
  }

  Future<dynamic> updateAdminMenuSort(dynamic data) async {
    // var result = await RestApiProvider.to.postMenuSort(div, data);
    //
    // if (result.body['code'] != '00') {
    //   ISAlert(context, '정상적으로 저장 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    // }

    // dio 패키지
    var dio = Dio();
    final response = await dio.put(ServerInfo.REST_URL_AUTH_ADMINMENU_SORT, data: data);

    dio.clear();
    dio.close();

    if (response.data['code'] != '00') {
      return response.data['msg'];
    }
    else
      return null;

    // print('start updateAdminMenuSort -> ${data.toString()}');
    //
    // var result = await RestApiProvider.to.postAdminMenuSort(data);
    //
    // print('after updateAdminMenuSort -> ${result.bodyString.toString()}');
  }
}
