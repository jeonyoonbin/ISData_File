import 'dart:core';

import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ISTextBox extends StatelessWidget {
  final String label;
  final String value;
  final int width;

  const ISTextBox({Key key, this.label, this.value, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.blue[50],
        // borderRadius: BorderRadius.circular(6.0),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text('※ ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.deepOrange),),
                Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,),),
                SizedBox(width: 10,)
              ],
            ),
            Container(
              color: Colors.white,
              width: width ?? 110,
              child: SelectableText(Utils.getCashComma(value), textAlign: TextAlign.right,),
            ),
          ],
        ),
      ),
    );
  }}