import 'dart:math';

import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_html/js.dart' as js;
import 'fake_ui.dart' if (dart.library.html) 'real_ui.dart' as ui;

class IsEditor extends StatefulWidget {
  final String htmlText;

  const IsEditor({Key key, this.htmlText}) : super(key: key);

  @override
  _IsEditorState createState() => _IsEditorState();
}

class _IsEditorState extends State<IsEditor> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  js.JsObject connector;

  String createdViewId = Random().nextInt(1000).toString();
  html.IFrameElement element;

  @override
  void initState() {
    js.context["connect_content_to_flutter"] = (js.JsObject content) {
      connector = content;
    };
    element = html.IFrameElement()
      ..src = "/assets/editor.html"
      ..style.border = 'none';

    ui.platformViewRegistry.registerViewFactory(createdViewId, (int viewId) => element);

    WidgetsBinding.instance.addPostFrameCallback((c) async {
      await Future.delayed(Duration(milliseconds: 300), (){
        setState(() {
          sendMessageToEditor(widget.htmlText);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ButtonBar buttonBar = ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        ISButton(
          label: '편집',
          iconData: Icons.edit,
          onPressed: () {
            Navigator.pop(context, getMessageFromEditor());
          },
        ),
        ISButton(
          label: '닫기',
          iconData: Icons.cancel,
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );

    var result = Scaffold(
      appBar: AppBar(
        title: Text('HTML 텍스트 편집기'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(height: 750, width: 1100, child: HtmlElementView(viewType: createdViewId))
            ),
          ],
        ),
      ),
      bottomNavigationBar: buttonBar,
    );

    return SizedBox(
      height: 800,
      width: 1100,
      child: result,
    );
  }

  getMessageFromEditor() {
    final String str = connector.callMethod(
      'getValue',
    ) as String;

    return str;
  }

  void sendMessageToEditor(String data) {
    element.contentWindow.postMessage({
      'id': 'value',
      'msg': data,
    }, "*");
  }
}
