import 'package:flutter/material.dart';

class ISInfoFormField extends StatefulWidget {
  final double width;
  final double padding;
  final Function builder;

  ISInfoFormField({
    Key key,
    this.builder,
    this.width,
    this.padding,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ISInfoFormFieldState();
}

class ISInfoFormFieldState extends State<ISInfoFormField> {
  didChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(widget.padding ?? 20.0),
      width: widget.width ?? double.infinity,
      child: widget.builder(this),
    );
  }
}
