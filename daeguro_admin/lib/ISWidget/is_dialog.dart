import 'package:flutter/material.dart';

void ISAlert(BuildContext context, String content) {
  ISAlertWidget(context, SelectableText(content, showCursor: true,));
}

void ISAlertWidget(BuildContext context, Widget content) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(        
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
        title: Text('알림'),
        titleTextStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', color: Colors.black),
        content: content,        
        contentTextStyle: TextStyle(fontSize: 13, fontFamily: 'NotoSansKR', color: Colors.black),
        actions: <Widget>[
          FlatButton(
            minWidth: 70,
            autofocus: true,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            color: Colors.black12,
            child: Text('확 인', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR')),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void ISConfirm(BuildContext context, String title, String content, onConfirm) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
        content: Text(content, style: TextStyle(fontSize: 14, )),
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
        //contentPadding: EdgeInsets.only(top: 10.0),
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),),
        //insetPadding: EdgeInsets.all(8),
        actions: <Widget>[
          FlatButton(
            child: Text('취소'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('확인'),
            onPressed: () {
              onConfirm(context);
            },
          ),
        ],
      );
    },
  );
}

ISDialog({BuildContext context,  String title,  Widget body,  Future then,  double width,  double height,}) {
  AppBar header = AppBar(
    title: Text(title),
  );
  var result = Container(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          header,
          Expanded(
            child: SingleChildScrollView(
              child: body,
            ),
          ),
        ],
      ));
  return showDialog(
    context: context,
    builder: (BuildContext context) => Dialog(
      child: result,
    ),
  );
}
