@JS()
library javascript_bundler;

import 'package:js/js.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
//import 'dart:html' as html;

@JS('sample4_execDaumPostcode')
external void showConfirm();

@JS('setAddressToDart')
external set _setAddressToDart(void Function() f);

List<String> _result = [];

// import 'package:js/js.dart';
class postCode extends StatefulWidget {
  @override
  _postCodeWebState createState() => _postCodeWebState();
}

class _postCodeWebState extends State<postCode> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _getAddress();
  }

  void _setAddressDartFunction() {
    _result.clear();

    _result.add(html.querySelector('#zonecode').innerText);

    if (html.querySelector('#userSelectedType').innerText == 'R') {
      _result.add(html.querySelector('#roadAddress').innerText);
    } else {
      _result.add(html.querySelector('#jibunAddress').innerText);
    }

    Navigator.of(context, rootNavigator: true).pop(_result);
  }

  void _getAddress() {
    _setAddressToDart = allowInterop(_setAddressDartFunction);
    showConfirm();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('주소검색중입니다...', style: TextStyle(fontSize: 13, color: Colors.black, fontFamily: 'NotoSansKR')));
  }
}
