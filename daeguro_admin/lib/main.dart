import 'dart:convert';

import 'package:daeguro_admin_app/Common/routes.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/Layout/layout_controller.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_strategy/url_strategy.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:html' as html;

void main() async{
  await GetStorage.init();
  //await ApplicationContext.instance.init();

  WidgetsFlutterBinding.ensureInitialized();

  setPathUrlStrategy();

  // 로그인 상태 정보 false 인 상태여야 Login 화면으로 감
  Utils.setLoginState(false);

  //추후 Dio변경 완료시, 서버정보 txt파일 활용 처리 예정
  /*String serverInfoStr = await rootBundle.loadString('/serverInfo.txt');
  print('serverInfoStr:${serverInfoStr}');
  Map<String,dynamic> jsonData = jsonDecode(serverInfoStr);
  print('appVersion:${jsonData['appVersion']}');

  bool debugEnabled = false;
  ServerInfo.APP_VERSION = jsonData['appVersion'].toString();
  if (ServerInfo.APP_VERSION.contains('검수중') == true)
    debugEnabled = true;

  if (debugEnabled == true){
    ServerInfo.REST_PUBLISH_URL = jsonData['publishUrl'].toString();
    ServerInfo.REST_IMG_BASEURL = jsonData['imageUrl'].toString();
    ServerInfo.REST_RESERVEURL = jsonData['reserveUrl'].toString();
  }
  else{
    ServerInfo.REST_PUBLISH_URL = 'https://dgpub.282.co.kr:8500';//'https://admin.daeguro.co.kr'
    ServerInfo.REST_IMG_BASEURL = '';
    ServerInfo.REST_RESERVEURL = 'https://reser.daeguro.co.kr:10008';

    //API경로
    //static const String REST_BASEURL = "https://admin.daeguro.co.kr/api"; //  실서버API
    //static const String REST_RESERVEURL = 'https://admin.daeguro.co.kr/Reserveapi';  // 실서버API

    //static const String REST_BASEURL = "http://dgpub.282.co.kr:8426";  // 테스트서버API
    //static const String REST_BASEURL = "/api";
    //static const String REST_RESERVEURL = 'https://reser.daeguro.co.kr:10008';//"/Reserveapi";  // 테스트서버API
  }*/


  // PackageInfo packageInfo = await PackageInfo.fromPlatform();
  // Utils.setAppVersionInfo(packageInfo.version);

  Get.put(LayoutController());


  ErrorWidget.builder = (FlutterErrorDetails details){
    return Container(
      color: Colors.green,
      child: Text(details.toString(), style: TextStyle(fontSize: 10.0, color: Colors.white),),
    );
  };

  html.window.onBeforeUnload.listen((event) async{
    GetStorage().remove('logininfo');
    Utils.setLoginState(false);
  });

  html.window.onUnload.listen((event) async{
    GetStorage().remove('logininfo');
    Utils.setLoginState(false);
  });

  Utils.setEasyLoading();

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(

      debugShowCheckedModeBanner: false,
      title: '대구로 관리 앱',
      theme: Utils.getThemeData(Colors.blue),
      //theme: Utils.getThemeData(Color.fromARGB(255, 056, 190, 239)),
      // defaultTransition: Transition.noTransition,
      // transitionDuration: Duration(seconds: 0),
      builder: EasyLoading.init(),
      // builder: BotToastInit(),
      // navigatorObservers: [BotToastNavigatorObserver()],
      // theme: ThemeData(
      //   primarySwatch: Colors.blueAccent[500]
      //   primaryColor: Color.fromARGB(255, 000, 079, 255),),
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ko', 'KR'),
      ],
      onGenerateRoute: (settings) => Routes.onGenerateRoute(settings),
    );
  }
}