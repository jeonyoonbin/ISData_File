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

@JS('windowClosed')
external set _windowClosed(void Function() f);

List<String> _result = [];

// import 'package:js/js.dart';
class PostCodeRequest extends StatefulWidget {
  const PostCodeRequest({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState(){
    return PostCodeRequestState();
  }
}

class PostCodeRequestState extends State<PostCodeRequest> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((c) {
      _getAddress();
    });
  }

  @override
  void dispose(){
    super.dispose();
  }

  void _setAddressDartFunction() {
    _result.clear();

    _result.add(html.querySelector('#zonecode').innerText);
    _result.add(html.querySelector('#jibunAddress').innerText);
    _result.add(html.querySelector('#roadAddress').innerText);
    _result.add(html.querySelector('#sido').innerText);
    _result.add(html.querySelector('#sigungu').innerText);
    _result.add(html.querySelector('#bname1').innerText);
    _result.add(html.querySelector('#roadname').innerText);
    _result.add(html.querySelector('#hname').innerText);
    _result.add(html.querySelector('#bname2').innerText);

    // print(html.querySelector('#sido').innerText);
    // print(html.querySelector('#sigungu').innerText);
    // print(html.querySelector('#bname').innerText);

    Navigator.of(context, rootNavigator: true).pop(_result);
  }

  void _windowClosedState(){
    Navigator.pop(context);
  }

  void _getAddress(){
    _setAddressToDart = allowInterop(_setAddressDartFunction);
    _windowClosed = allowInterop(_windowClosedState);

    showConfirm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(height: 20),
    );
  }
}
