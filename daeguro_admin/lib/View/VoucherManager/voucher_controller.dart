import 'package:daeguro_admin_app/Network/DioClient.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class VoucherController extends GetxController with SingleGetTickerProviderMixin {
  static VoucherController  get to => Get.find();

  int total_count = 0;
  int totalRowCnt = 0;
  RxInt rows = 0.obs;
  RxInt page = 0.obs;
  RxList<SelectOptionVO> VoucherTypeItems = <SelectOptionVO>[].obs;
  RxList<SelectOptionVO> VoucherTypeItemsRegist = <SelectOptionVO>[].obs;
  RxInt notUse = 0.obs;
  RxInt use = 0.obs;
  RxInt clear = 0.obs;
  RxInt exp = 0.obs;

  Future<List<dynamic>> getData(String testYn, String voucherType, String status, String keyword) async{
    List<dynamic> qData = [];

    final response = await DioClient().get(ServerInfo.REST_URL_VOUCHER + '?testYn=$testYn&voucherType=$voucherType&status=$status&page=${page.value.toString()}&rows=${rows.value.toString()}&keyword=$keyword');

    qData.clear();
    //print('getData:${response.toString()}');
    if (response.data['code'] == '00') {
      total_count = int.parse(response.data['total_count'].toString());
      totalRowCnt = int.parse(response.data['count'].toString());

      notUse.value = int.parse(response.data['notUse'].toString());
      use.value = int.parse(response.data['use'].toString());
      clear.value = int.parse(response.data['clear'].toString());
      exp.value = int.parse(response.data['exp'].toString());

      qData.assignAll(response.data['data']);
    }
    else
      return null;

    return qData;

  }

  Future<List> getVoucherControllerListItems(String div) async {
    List<dynamic> retData = [];

    final result = await DioClient().get(ServerInfo.REST_URL_VOUCHER_GETVOUCHERLIST + '?div=$div');

    if (result.data['code'] == '00')
      retData.assignAll(result.data['data']);
    else
      return null;

    return retData;
  }

  /// 상품권 단일, 단체 등록
  Future<String> postVoucher(String voucherType,dynamic data) async {
    String uCode = GetStorage().read('logininfo')['uCode'];

    final response = await DioClient().post(ServerInfo.REST_URL_VOUCHER_SETVOUCHERAPPCUSTOMER+'?voucher_type=${voucherType}&ucode=${uCode}', data : data);

    return response.data['code'] ;
  }

  Future<List<dynamic>> getHistoryData(String voucherNo, String page, String rows) async {
    List<dynamic> qDataOptionHistoryList = [];

    final response = await DioClient().get(ServerInfo.REST_URL_VOUCHER_HIST + '/$voucherNo?page=1&rows=1000');

    qDataOptionHistoryList.clear();

    if (response.data['code'] == '00') {
      qDataOptionHistoryList.assignAll(response.data['data']);
    } else
      return null;

    return qDataOptionHistoryList;
  }

}