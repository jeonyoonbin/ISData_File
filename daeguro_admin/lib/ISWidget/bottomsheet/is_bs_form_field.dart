
import 'package:flutter/material.dart';

class ISBSFormField extends StatefulWidget {
  final double width;
  final double padding;
  final Function builder;

  ISBSFormField({
    Key key,
    this.builder,
    this.width,
    this.padding,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ISBSFormFieldState();
}

class ISBSFormFieldState extends State<ISBSFormField> {
  didChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 4.0, bottom: 4.0),//EdgeInsets.all(widget.padding ?? 8.0),
      width: widget.width ?? double.infinity,
      child: widget.builder(this),
    );
  }
}
