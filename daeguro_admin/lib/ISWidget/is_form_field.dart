import 'package:flutter/material.dart';

class ISFormField extends StatefulWidget {
  final double width;
  final double padding;
  final Function builder;

  ISFormField({
    Key key,
    this.builder,
    this.width,
    this.padding,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ISFormFieldState();
}

class ISFormFieldState extends State<ISFormField> {
  didChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(widget.padding ?? 8.0),//16.0),
      width: widget.width ?? double.infinity,
      child: widget.builder(this),
    );
  }
}
