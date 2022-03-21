

import 'package:daeguro_admin_app/Model/menu.dart';
import 'package:daeguro_admin_app/Model/user/userAuthManagerListModel.dart';
import 'package:daeguro_admin_app/constants/icon_package.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static bool loginState = false;
  static bool isFullScreen = false;

  static String REST_BASEURL = '';

  static getThemeData(Color themeColor) {
    return ThemeData(
      primaryColor: themeColor,
      iconTheme: IconThemeData(color: themeColor),
      fontFamily: 'NotoSansKR',
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: themeColor,
      ),
      buttonTheme: ButtonThemeData(buttonColor: themeColor),
    );
  }

  static setFullScreenState(bool state) {
    isFullScreen = state;
  }

  static bool getFullScreenState() {
    return isFullScreen;
  }

  static message(text, {durationSeconds = 3}) {
    //BotToast.showText(text: text, duration: Duration(seconds: durationSeconds));
  }

  static List getMCodeList(){
    return GetStorage().read('MCodeListinfo');
  }

  static String getDay(String code){
    String retDay = '';
    if (code == '1')        retDay = '일요일';
    else if (code == '2')        retDay = '월요일';
    else if (code == '3')        retDay = '화요일';
    else if (code == '4')        retDay = '수요일';
    else if (code == '5')        retDay = '목요일';
    else if (code == '6')        retDay = '금요일';
    else if (code == '7')        retDay = '토요일';

    return retDay;
  }

  // static isMenuDisplayTypeDrawer(BuildContext context) {
  //   LayoutController layoutController = Get.find();
  //   return layoutController.menuDisplayType == MenuDisplayType.drawer;
  // }

  static setLoginState(bool state) {
    loginState = state;
  }

  static String getUserID() {
    return GetStorage().read('logininfo')['id'];
  }

  // static setAppVersionInfo(String version) {
  //   GetStorage().write('appinfo', version);
  // }
  //
  // static String getAppVersionInfo() {
  //   return ServerInfo.APP_VERSION; //GetStorage().read('appinfo');
  // }

  static bool isLogin() {
    return loginState; //GetStorage().hasData(Constant.KEY_TOKEN);
  }

  static logout() {
    // GetStorage().remove(Constant.KEY_TOKEN);
    // GetStorage().remove(Constant.KEY_MENU_LIST);
    // GetStorage().remove(Constant.KEY_DICT_ITEM_LIST);

    // 기존 로그인 정보 삭제
    GetStorage().remove('logininfo');
  }

  static String validatePassword(String value){
    if(value.isEmpty){
      //focusNode.requestFocus();
      return null;//'비밀번호를 입력하세요.';
    }
    else {
      Pattern pattern = r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{10,30}$';
      RegExp regExp = new RegExp(pattern);
      if(!regExp.hasMatch(value)){
        //focusNode.requestFocus();
        return '대소문자, 특수문자, 숫자 포함 10 이상으로 입력하세요.';
      }
      else{
        return null;
      }
    }
  }

  static List<DropdownMenuItem> getPageRowList(){
    List<DropdownMenuItem> retList = [
      DropdownMenuItem(value: 15, child: Center(child: Text('15'))),
      DropdownMenuItem(value: 30, child: Center(child: Text('30'))),
      DropdownMenuItem(value: 50, child: Center(child: Text('50'))),
    ];

    return retList;
  }

  static bool validateNumber(String value, bool isValidated) {
    RegExp regExp = new RegExp(r'^[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)$');
    if (value.length == 0) {
      return false;
    }
    else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  static bool validateString(String value) {
    RegExp regExp = new RegExp(r'(^[a-zA-Z ]*$)');
    if (value.length == 0) {
      return false;
    }
    else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  static String getTimeFormat(String value) {
    if (value == null || value == '' || value == ' ')      return '';

    String retStr;
    if (value.length == 3) {
      retStr = value.substring(0, 1) + ':' + value.substring(1, 3);
    }    else if (value.length == 4) {
      retStr = value.substring(0, 2) + ':' + value.substring(2, 4);
    }

    return retStr;
  }

  static String getNameAbsoluteFormat(String name, bool isValidated) {
    if (name == null || name == '' || name == ' ' || name == 'null') return '--';

    if (isValidated == false)
      return name;

    if (name.length < 3){
      return name;
    }

    String retStr = '';
    String firstName = ''; // 성
    String middleName = ''; // 이름 중간
    String lastName = ''; //이름 끝
    int lastNameStartPoint; // 이름 시작 포인터

    firstName = name.substring(0, 1);
    lastNameStartPoint = name.indexOf(firstName);
    if(name.trim().length > 2){
      middleName = name.substring(lastNameStartPoint + 1, name.trim().length-1);
      lastName = name.substring(lastNameStartPoint + (name.trim().length - 1), name.trim().length);
    }
    else{
      middleName = name.substring(lastNameStartPoint + 1, name.trim().length);
    }

    String makers = "";
    for(int i = 0; i < middleName.length; i++){
      makers += "*";
    }

    lastName = middleName.replaceAll(middleName, makers) + lastName;
    retStr = firstName + lastName;

    return retStr;
  }

  static String getNameFormat(String name, bool isValidated) {
    if (name == null || name == '' || name == ' ' || name == 'null') return '--';

    if (isValidated == false)
      return name;

    String retStr = '';
    String firstName = ''; // 성
    String middleName = ''; // 이름 중간
    String lastName = ''; //이름 끝
    int lastNameStartPoint; // 이름 시작 포인터

    if (validateString(name) == true){
      String nonMaskingPre = name.substring(0, name.length-3);
      String nonMaskingPost = name.substring(name.length-1, name.length);

      retStr += nonMaskingPre;
      retStr += '**';
      retStr += nonMaskingPost;

      return retStr;
    }

    if(name.length > 1){
      firstName = name.substring(0, 1);
      lastNameStartPoint = name.indexOf(firstName);
      if(name.trim().length > 2){
        middleName = name.substring(lastNameStartPoint + 1, name.trim().length-1);
        lastName = name.substring(lastNameStartPoint + (name.trim().length - 1), name.trim().length);
      }
      else{
        middleName = name.substring(lastNameStartPoint + 1, name.trim().length);
      }

      String makers = "";
      for(int i = 0; i < middleName.length; i++){
        makers += "*";
      }

      lastName = middleName.replaceAll(middleName, makers) + lastName;
      retStr = firstName + lastName;
    }
    else{
      retStr = name;
    }
    return retStr;
  }

  static String getEmailFormat(String value, bool isValidated) {
    if (value == null || value == '' || value == ' ' || value == 'null') return '';

    String retStr;

    if (value.contains('@') == false){
      return value;
    }

    List<String> splitStr = value.split('@');
    if (splitStr == null || splitStr.length == 0)
      return value;

    int len = splitStr[0].length;
    String maskingEmail = '';
    if (len > 3){
      maskingEmail += splitStr[0].substring(0,3);
      for (int i = 3; i<len; i++)
        maskingEmail+='*';
    }
    else{
      maskingEmail += splitStr[0].substring(0,1);
      for (int i = 1; i<len; i++)
        maskingEmail+='*';
    }

    retStr = maskingEmail + '@' + splitStr[1];

    return retStr;
  }


  static String getAddressFormat(String value, bool isValidated) {
    if (value == null || value == '' || value == ' ' || value == 'null') return '';

    String retStr = '';

    int maskingIndex = value.indexOf(RegExp(r'읍 |면 |동 |가 |리 |로 |길 '));

    if (maskingIndex <= 0 )
      return value;

    String nonMaskingStr = value.substring(0, maskingIndex+2);
    String MaskingStr = value.substring(maskingIndex+2, value.length);

    retStr += nonMaskingStr;
    for (int i = 0; i<MaskingStr.length; i++){
      retStr += '*';
    }

    return retStr;
  }

  static String getAddressEtcFormat(String value, bool isValidated) {
    if (value == null || value == '' || value == ' ' || value == 'null') return '';

    String retStr = '';

    int maskingLength = value.length;

    for (int i = 0; i<maskingLength; i++) {
      retStr += '*';
    }

    return retStr;
  }

  static String getBirthFormat(String value, bool isValidated) {
    if (value == null || value == '' || value == ' ' || value == 'null') return '';

    String retStr= '';

    if (value.length < 6)
      return value;

    // String nonMaskingStr = value.substring(0, value.length-2);
    // retStr =  nonMaskingStr+ '**';

    if (isValidated == false)        retStr = value.replaceAllMapped(RegExp(r'(\d{4})(\d{2})(\d+)'), (Match m) => "${m[1]}.${m[2]}.${m[3]}");
    else                            retStr = value.replaceAllMapped(RegExp(r'(\d{4})(\d{2})(\d+)'), (Match m) => "${m[1]}.${m[2]}.${'**'}");

    return retStr;
  }

  static String getAccountNoFormat(String value, bool isValidated) {
    if (value == null || value == '' || value == ' ' || value == 'null') return '';

    String retStr = '';

    if (value.length <= 4)
      return value;

    int maskingLength = value.length-4;

    String nonMaskingStr = value.substring(maskingLength, value.length);

    for (int i = 0; i<maskingLength; i++) {
      retStr += '*';
    }

    retStr += nonMaskingStr;

    return retStr;
  }

  static String getPhoneNumFormat(String value, bool isValidated) {
    if (value == null || value == '' || value == ' '  || value == 'null')      return '';

    String retStr = '';

    if (value.length == 8) {
      if (isValidated == false)        retStr = value.replaceAllMapped(RegExp(r'(\d{4})(\d+)'), (Match m) => "${m[1]}-${m[2]}");
      else                            retStr = value.replaceAllMapped(RegExp(r'(\d{4})(\d+)'), (Match m) => "${'****'}-${m[2]}");
    }
    else if (value.length == 10) {
      if (isValidated == false)        retStr = value.replaceAllMapped(RegExp(r'(\d{3})(\d{3})(\d+)'), (Match m) => "${m[1]}-${m[2]}-${m[3]}");
      else                            retStr = value.replaceAllMapped(RegExp(r'(\d{3})(\d{3})(\d+)'), (Match m) => "${m[1]}-${'***'}-${m[3]}");
    }
    else if (value.length == 11) {
      if (isValidated == false)        retStr = value.replaceAllMapped(RegExp(r'(\d{3})(\d{4})(\d+)'), (Match m) => "${m[1]}-${m[2]}-${m[3]}");
      else                            retStr = value.replaceAllMapped(RegExp(r'(\d{3})(\d{4})(\d+)'), (Match m) => "${m[1]}-${'****'}-${m[3]}");
    }
    else if (value.length == 12) {
      if (isValidated == false)        retStr = value.replaceAllMapped(RegExp(r'(\d{4})(\d{4})(\d+)'), (Match m) => "${m[1]}-${m[2]}-${m[3]}");
      else                            retStr = value.replaceAllMapped(RegExp(r'(\d{3})(\d{4})(\d+)'), (Match m) => "${m[1]}-${'****'}-${m[3]}");
    }
    else {
      if (isValidated == false)        retStr = value.replaceAllMapped(RegExp(r'(\d{3})(\d{3,4})(\d+)'), (Match m) => "${m[1]}-${m[2]}-${m[3]}");
      else                            retStr = value.replaceAllMapped(RegExp(r'(\d{3})(\d{3,4})(\d+)'), (Match m) => "${m[1]}-${'***'}-${m[3]}");
    }

    return retStr;
  }

  static String getYearMonthFormat(String value) {
    if (value == null || value == '' || value == ' ') return '';

    String retStr;

    retStr = value.replaceAllMapped(RegExp(r'(\d{4})(\d{2})'), (Match m) => "${m[1]}-${m[2]}");

    return retStr;
  }

  static String getYearMonthDayFormat(String value) {
    if (value == null || value == '' || value == ' ') return '';

    String retStr;

    retStr = value.replaceAllMapped(RegExp(r'(\d{4})(\d{2})(\d{2})'), (Match m) => "${m[1]}-${m[2]}-${m[3]}");

    return retStr;
  }

  static String getStoreRegNumberFormat(String value, bool isValidated) {
    if (value == null || value == '' || value == ' ')      return '';

    String retStr;
    //retStr = value.replaceAllMapped(RegExp(r'(\d{3})(\d{2})(\d+)'), (Match m) => "${m[1]}-${m[2]}-${m[3]}");
    retStr = value.replaceAllMapped(RegExp(r'(\d{3})(\d{2})(\d+)'), (Match m) => "${m[1]}-${'**'}-${m[3]}");

    if (isValidated == false)
      return value.replaceAllMapped(RegExp(r'(\d{3})(\d{2})(\d+)'), (Match m) => "${m[1]}-${m[2]}-${m[3]}");

    return retStr;
  }

  static String getCashComma(String value) {
    if (value == null || value == '' || value == ' ' || value == 'null' || (isInt(value) == false)) return '0';

    int temp = int.parse(value);
    return new NumberFormat('###,###,###,###').format(temp).replaceAll(' ', '');
  }

  static String getCurrencyCashFormat(String value) {
    final formatCurrency = new NumberFormat.simpleCurrency(locale: 'ko_KR', name: '', decimalDigits: 0);

    return formatCurrency.format(value);
  }

  static bool isInt(String str) {
    if(str == null) {
      return false;
    }
    return int.tryParse(str) != null;
  }



  // static String getTimeSet(String value){
  //   if (value == null || value == '' || value == ' ')
  //     return '--';
  //
  //   if(value == '0000')
  //     return '00:00';
  //
  //   int temp = int.parse(value);
  //   return new NumberFormat('##,##').format(temp).replaceAll(',', ':');
  // }

  static toIconData(String icon) {
    // if (icon == null || icon == '') {
    //   return Icons.menu;
    // }
    // IconData iconData = IconData(int.parse(icon), fontFamily: 'MaterialIcons');
    return iconPackage[icon]; // ?? Icons.menu;
  }

  static setEasyLoading()  {
    EasyLoading.instance
      ..maskType = EasyLoadingMaskType.black
      ..toastPosition = EasyLoadingToastPosition.center
      ..indicatorType = EasyLoadingIndicatorType.ring //ring;
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.yellow
      ..backgroundColor = Colors.green
      ..indicatorColor = Colors.yellow
      ..textColor = Colors.yellow
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false;
  }

  static launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static int getTimeStamp() {
    return (DateTime.now().millisecondsSinceEpoch + DateTime.now().timeZoneOffset.inMilliseconds) ~/ 1000;
  }



  // static List<Menu> getMenuTree() {
  //   List<Menu> notices = [
  //
  //     new Menu(id: 'mSeq_1', name: '사용자관리', menuDepth: '0', icon: 'userGroup', pid: null, url: '/userManager',
  //         visible: GetStorage().read('logininfo')['uCode'] == '35' // 전윤빈 대리
  //             || GetStorage().read('logininfo')['uCode'] == '28' // 이나연 대리
  //             || GetStorage().read('logininfo')['uCode'] == '183' // 이나연 대리
  //             || GetStorage().read('logininfo')['uCode'] == '13' // 이석영 부장
  //             || GetStorage().read('logininfo')['uCode'] == '19' // 이석영 부장
  //             || GetStorage().read('logininfo')['uCode'] == '21' // 최윤오 과장
  //             || GetStorage().read('logininfo')['uCode'] == '15' // 최윤오 과장
  //             || GetStorage().read('logininfo')['uCode'] == '72' // 김상보 과장
  //             || GetStorage().read('logininfo')['uCode'] == '48' // 이성훈 과장
  //             || GetStorage().read('logininfo')['uCode'] == '3' // 이인찬 부장
  //             || GetStorage().read('logininfo')['uCode'] == '321' // 최반야 사원
  //             || GetStorage().read('logininfo')['uCode'] == '233' // 박소연 사원
  //             ? true : false),
  //     new Menu(id: 'mSeq_0', name: '전체현황', menuDepth: '0', icon: 'home', pid: null, url: '/', visible: true),
  //     new Menu(id: 'mSeq_2', name: '콜센터 관리', menuDepth: '0', icon: 'subsystem', pid: null, url: '/agentAccountManager', visible: true),
  //     new Menu(id: 'mSeq_3', name: '가맹점', menuDepth: '0', icon: 'shop', pid: null, url: '', visible: true),
  //
  //     new Menu(id: 'mSeq_7', name: '주문', menuDepth: '0', icon: 'order', pid: null, url: null, visible: true),
  //
  //     new Menu(id: 'mSeq_12', name: '정산', menuDepth: '0', icon: 'calculate', pid: null, url: '', visible:
  //     GetStorage().read('logininfo')['uCode'] == '35' // 전윤빈 대리
  //         || GetStorage().read('logininfo')['uCode'] == '321' // 최반야 사원
  //         || GetStorage().read('logininfo')['uCode'] == '233' // 박소연 사원
  //         || GetStorage().read('logininfo')['uCode'] == '48' // 이성훈 과장
  //         || GetStorage().read('logininfo')['uCode'] == '3' // 이인찬 부장
  //         || GetStorage().read('logininfo')['uCode'] == '7' // 김성근 이사
  //         || GetStorage().read('logininfo')['uCode'] == '178' // 기획팀 박인아
  //         ? true : false),
  //
  //     new Menu(id: 'mSeq_4', name: '통계', menuDepth: '0', icon: 'assessment', pid: null, url: '', visible: true),
  //     new Menu(id: 'mSeq_5', name: '마일리지', menuDepth: '0', icon: 'mileage', pid: null, url: '', visible: true),
  //     new Menu(id: 'mSeq_9', name: '쿠폰', menuDepth: '0', icon: 'money', pid: null, url: '/CouponListManager', visible: true),
  //
  //     new Menu(id: 'mSeq_15', name: '리뷰 관리', menuDepth: '0', icon: 'review', pid: null, url: '/ReviewListManager', visible: true),
  //     new Menu(id: 'mSeq_13', name: '요청 관리', menuDepth: '0', icon: 'request', pid: null, url: '/RequestList', visible: true),
  //     new Menu(id: 'mSeq_8', name: '회원 관리', menuDepth: '0', icon: 'customer', pid: null, url: '/customerListManager',
  //         visible: GetStorage().read('logininfo')['uCode'] == '35' // 전윤빈 대리
  //             || GetStorage().read('logininfo')['uCode'] == '28' // 이나연 대리
  //             || GetStorage().read('logininfo')['uCode'] == '183' // 이나연 대리
  //             || GetStorage().read('logininfo')['uCode'] == '13' // 이석영 부장
  //             || GetStorage().read('logininfo')['uCode'] == '19' // 이석영 부장
  //             || GetStorage().read('logininfo')['uCode'] == '21' // 최윤오 과장
  //             || GetStorage().read('logininfo')['uCode'] == '15' // 최윤오 과장
  //             || GetStorage().read('logininfo')['uCode'] == '72' // 김상보 과장
  //             || GetStorage().read('logininfo')['uCode'] == '48' // 이성훈 과장
  //             || GetStorage().read('logininfo')['uCode'] == '3' // 이인찬 부장
  //             || GetStorage().read('logininfo')['uCode'] == '321' // 최반야 사원
  //             || GetStorage().read('logininfo')['uCode'] == '233' // 박소연 사원
  //             || GetStorage().read('logininfo')['uCode'] == '68' // 운영팀 황은하
  //             || GetStorage().read('logininfo')['uCode'] == '250' // 운영팀 류민정
  //             || GetStorage().read('logininfo')['uCode'] == '247' // 운영팀 정지윤
  //             || GetStorage().read('logininfo')['uCode'] == '334' // 운영팀 김현지
  //             || GetStorage().read('logininfo')['uCode'] == '333' // 운영팀 간희정
  //             || GetStorage().read('logininfo')['uCode'] == '177' // 기획팀 이성민
  //             || GetStorage().read('logininfo')['uCode'] == '176' // 기획팀 원혜정
  //             || GetStorage().read('logininfo')['uCode'] == '178' // 기획팀 박인아
  //             || GetStorage().read('logininfo')['uCode'] == '336' // 운영팀 김동준
  //             || GetStorage().read('logininfo')['uCode'] == '337' // 운영팀 김수빈
  //             || GetStorage().read('logininfo')['uCode'] == '339' // 운영팀 박상우
  //             ? true : false),
  //
  //
  //
  //     new Menu(id: 'mSeq_11', name: '공지사항&이벤트', menuDepth: '0', icon: 'notice', pid: null, url: '/NoticeListManager', visible: true),
  //     new Menu(id: 'mSeq_6', name: '외부연동', menuDepth: '0', icon: 'mapping', pid: null, url: '', visible: true),
  //     //new Menu(id: 'mSeq_12', name: 'FL Chart Test', subsystemId: '0', icon: 'notice', pid: null, url: '/DashboardTest', visible: true),
  //     new Menu(id: 'mSeq_14', name: '코드관리', menuDepth: '0', icon: 'code', pid: null, url: '', visible: GetStorage().read('logininfo')['uCode'] == '35' // 전윤빈 대리
  //         || GetStorage().read('logininfo')['uCode'] == '321' // 최반야 사원
  //         || GetStorage().read('logininfo')['uCode'] == '233' // 박소연 사원
  //         || GetStorage().read('logininfo')['uCode'] == '48' // 이성훈 과장
  //         || GetStorage().read('logininfo')['uCode'] == '3' // 이인찬 부장
  //         || GetStorage().read('logininfo')['uCode'] == '7' // 김성근 이사
  //         || GetStorage().read('logininfo')['uCode'] == '5' // 임창원 과장
  //         || GetStorage().read('logininfo')['uCode'] == '28' // 이나연 대리
  //         || GetStorage().read('logininfo')['uCode'] == '183' // 이나연 대리
  //         ? true : false),
  //     //----------------------------------------------------------------------------------------------------------------------------------
  //     new Menu(id: 'mSeq_18', name: '로그 관리', menuDepth: '0', icon: 'log', pid: null, url: '', visible: true),
  //         // visible: GetStorage().read('logininfo')['uCode'] == '35' // 전윤빈 대리
  //         //     || GetStorage().read('logininfo')['uCode'] == '321' // 최반야 사원
  //         //     || GetStorage().read('logininfo')['uCode'] == '233' // 박소연 사원
  //         //     || GetStorage().read('logininfo')['uCode'] == '48' // 이성훈 과장
  //         //     || GetStorage().read('logininfo')['uCode'] == '3' // 이인찬 부장
  //         //     || GetStorage().read('logininfo')['uCode'] == '63' // 진창훈 과장
  //         //     ? true : false),
  //
  //     new Menu(id: 'mSeq_19', name: '권한 관리', menuDepth: '0', icon: 'manage', pid: null, url: '/userAuthManager', visible: true),
  //
  //     new Menu(id: 'mSeq_20', name: '가맹점 관리', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_3', url: '/shopAccountManager', visible: true),
  //     new Menu(id: 'mSeq_21', name: '사업자변경 조회', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_3', url: '/shopAccountModificationRegNo', visible: true),
  //     new Menu(id: 'mSeq_22', name: '이미지 관리', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_3', url: '/shopImageManager', visible: true),
  //     new Menu(id: 'mSeq_23', name: '라이브 이벤트 조회', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_3', url: '/ShopEventList', visible: true),
  //     new Menu(id: 'mSeq_24', name: '영양성분/알레르기정보', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_3', url: '/ShopFoodSafety', visible: true),
  //     new Menu(id: 'mSeq_25', name: '예약 현황', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_3', url: '/ShopReservationMain', visible: true),
  //
  //     new Menu(id: 'mSeq_40', name: '가맹점별', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_4', url: '/statShopManager', visible: true),
  //     new Menu(id: 'mSeq_41', name: '회원별', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_4', url: '/statCustomerManager', visible: true),
  //     new Menu(id: 'mSeq_42', name: '주문별', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_4', url: '/statOrderManager', visible: true),
  //     new Menu(id: 'mSeq_43', name: '쿠폰별', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_4', url: '/statCouponManager', visible: true),
  //     new Menu(id: 'mSeq_44', name: '마일리지별', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_4', url: '/statMileageManager', visible: true),
  //
  //     new Menu(id: 'mSeq_50', name: '마일리지 사용내역', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_5', url: '/historyMileageList', visible: true),
  //     // new Menu(id: 'mSeq_51', name: '쿠폰 사용내역', tab_name: '[내역] 쿠폰 사용내역', subsystemId: '1', icon: 'menu_child', pid: 'mSeq_5', url: '/historyCouponList', visible: true),
  //     // new Menu(id: 'mSeq_52', name: '제휴 쿠폰 사용내역', tab_name: '[내역] 제휴 쿠폰 사용내역', subsystemId: '1', icon: 'menu_child', pid: 'mSeq_5', url: '/historyB2BCouponList', visible: true),
  //     // new Menu(id: 'mSeq_53', name: '브랜드 쿠폰 사용내역', tab_name: '[내역] 브랜드 쿠폰 사용내역', subsystemId: '1', icon: 'menu_child', pid: 'mSeq_5', url: '/historyBrandCouponList', visible: true),
  //
  //     new Menu(id: 'mSeq_54', name: '마일리지 선입선출 대장', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_5', url: '/MileageInOut', visible: true),
  //     new Menu(id: 'mSeq_55', name: '마일리지(판매) 선입선출 대장', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_5', url: '/MileageSaleInOut', visible: true),
  //
  //     new Menu(id: 'mSeq_60', name: 'API 관리', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_6', url: '/ApiCompanyList', visible: true),
  //     new Menu(id: 'mSeq_61', name: 'POS매핑 관리', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_6', url: '/MappingList', visible: true),
  //
  //     new Menu(id: 'mSeq_70', name: '주문 관리', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_7', url: '/orderManager', visible: true),
  //     new Menu(id: 'mSeq_71', name: '주문취소 가맹점', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_7', url: '/orderShopCancelList', visible: true),
  //     new Menu(id: 'mSeq_72', name: '완료 → 취소 주문 조회', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_7', url: '/orderCompleteToCancel', visible: true),
  //
  //     new Menu(id: 'mSeq_90', name: '대구로 쿠폰', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_9', url: '/CouponListManager', visible: true),
  //     new Menu(id: 'mSeq_91', name: '제휴 쿠폰', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_9', url: '/B2BCouponListManager', visible: true),
  //     new Menu(id: 'mSeq_92', name: '브랜드 쿠폰', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_9', url: '/BrandCouponListManager', visible: true),
  //     new Menu(id: 'mSeq_93', name: '제휴 쿠폰 처리자 관리', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_9', url: '/B2BCouponUserListManager', visible: true),
  //     new Menu(id: 'mSeq_94', name: '브랜드 쿠폰 앱설정 관리', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_9', url: '/BrandCouponAppListManager', visible: true),
  //     new Menu(id: 'mSeq_95', name: '브랜드 쿠폰 가맹점 관리', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_9', url: '/BrandCouponShopListManager', visible: true),
  //
  //     new Menu(id: 'mSeq_120', name: '가맹점 적립금 관리', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_12', url: '/CalculateShopMileage', visible: true),
  //     new Menu(id: 'mSeq_121', name: '콜센터 적립금 관리', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_12', url: '/CalculateCcMileage', visible: true),
  //     new Menu(id: 'mSeq_122', name: '수수료 관리', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_12', url: '/CalculateCommission', visible: true),
  //     new Menu(id: 'mSeq_123', name: '주문별 정산금액 조회', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_12', url: '/CalculateOrderPayMentSearch', visible: true),
  //     new Menu(id: 'mSeq_124', name: '세금계산서 조회', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_12', url: '/CalculateSearchShopTax', visible: true),
  //     new Menu(id: 'mSeq_125', name: '세금계산서 생성', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_12', url: '/CalculateInsertTaxMast', visible: true),
  //
  //     //new Menu(id: 'mSeq_64', name: '수수료 미수금 관리', tab_name: '[정산] 수수료 미수금 관리', subsystemId: '1', icon: 'menu_child', pid: 'mSeq_12', url: '/CalculateOutstandingAmount', visible: true),
  //
  //     new Menu(id: 'mSeq_140', name: '대구로 코드관리', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_14', url: '/codeListManager', visible: true),
  //     new Menu(id: 'mSeq_141', name: '대구로 쿠폰 코드관리', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_14', url: '/codeCouponListManager', visible: true),
  //     new Menu(id: 'mSeq_142', name: '제휴 쿠폰 코드관리', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_14', url: '/codeB2BCouponListManager', visible: true),
  //     new Menu(id: 'mSeq_143', name: '브랜드 쿠폰 코드관리', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_14', url: '/codeBrandCouponListManager', visible: true),
  //
  //     new Menu(id: 'mSeq_180', name: '개인정보 조회 이력', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_18', url: '/LogPrivacyListManager', visible: true),
  //     new Menu(id: 'mSeq_181', name: '세금계산서 작업 이력', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_18', url: '/LogTaxListManager', visible: true),
  //     new Menu(id: 'mSeq_189', name: '장애 이력', menuDepth: '1', icon: 'menu_child', pid: 'mSeq_18', url: '/LogErrorListManager', visible: true),
  //   ];
  //
  //   return notices;
  // }
}