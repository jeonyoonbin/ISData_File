
import 'package:daeguro_admin_app/Network/DioClient.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class TaxController extends GetxController with SingleGetTickerProviderMixin {
  static TaxController get to => Get.find();

  @override
  void onInit() {
    super.onInit();
  }

  Future<String> getTaxData(String buss_reg_no) async {
    String retContent = '';

    final response = await DioClient().get(ServerInfo.REST_URL_TAX + '?buss_reg_no=$buss_reg_no');

    print('response -> ${response.data.toString()}');

    if (response.data['status_code'] == 'OK') {
      dynamic retBody = response.data['data'];
      if (response.data['match_cnt'] == 0){//자료 없음
        retContent = '-> 사업자등록번호: ${retBody[0]['b_no']}\n\n'
            '과세유형메세지: ${retBody[0]['tax_type']}';
      }
      else{
        retContent = '-> 사업자등록번호: ${retBody[0]['b_no']}\n\n'
            '납세자상태: ${retBody[0]['b_stt']}\n'
            '과세유형메세지: ${retBody[0]['tax_type']}\n'
            '폐업일: ${retBody[0]['end_dt']}\n'
            '단위과세전환폐업여부: ${retBody[0]['utcc_yn']}\n'
            '최근과세유형전환일자: ${retBody[0]['tax_type_change_dt']}\n'
            '세금계산서적용일자: ${retBody[0]['invoice_apply_dt']}';
      }

      return (response.data['match_cnt'].toString() + '|' +retContent);//response.data['data'];
    }
    else
      return null;
  }

  String _getTaxUserState(String b_stt) {
    String retValue = '--';

    if (b_stt.toString().compareTo('01') == 0)
      retValue = '계속사업자';
    else if (b_stt.toString().compareTo('02') == 0)
      retValue = '휴업자';
    else if (b_stt.toString().compareTo('03') == 0)
      retValue = '폐업자';
    else
      retValue = b_stt;

    return retValue;
  }

  String _getTaxType(String tax_type) {
    String retValue = '--';

    if (tax_type.toString().compareTo('01') == 0)
      retValue = '부가가치세 일반과세자';
    else if (tax_type.toString().compareTo('02') == 0)
      retValue = '부가가치세 간이과세자';
    else if (tax_type.toString().compareTo('03') == 0)
      retValue = '부가가치세 과세특례자';
    else if (tax_type.toString().compareTo('04') == 0)
      retValue = '부가가치세 면세사업자';
    else if (tax_type.toString().compareTo('05') == 0)
      retValue = '수익사업을 영위하지 않는 비영리법인이거나 고유번호가 부여된 단체,국가기관 등';
    else if (tax_type.toString().compareTo('06') == 0)
      retValue = '고유번호가 부여된 단체';
    else if (tax_type.toString().compareTo('07') == 0)
      retValue = '부가가치세 간이과세자(세금계산서 발급사업자)';
    else
      retValue = tax_type;

    return retValue;
  }
}