import 'package:flutter/material.dart';

class ISButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData iconData;
  final String tip;
  final EdgeInsets padding;
  final TextStyle textStyle;
  final bool enable;
  final Color iconColor;
  final double height;

  ISButton(
      {this.label,
      this.iconData,
      this.onPressed,
      this.tip,
      this.padding,
      this.textStyle,
      this.enable = true,
      this.iconColor,
      this.height});

  @override
  Widget build(BuildContext context) {
    Widget result;

    if (!enable) return Container();

    if (iconData != null) {
      if (label == null) {
        result = Container(
          height: height ?? 30,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: IconButton(
            icon: Icon(iconData, size: 16, color: iconColor,),
            onPressed: onPressed,
          ),
        );
      }
      else {
        result = Container(
          height: height ?? 30,
          child: RaisedButton.icon(
            elevation: 0,
            highlightElevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
            icon: Icon(iconData, size: 16, color: iconColor),
            label: Text(this.label, style: this.textStyle),
            onPressed: onPressed,
          ),
        );
      }
    }
    else {
      result = Container(
        height: height ?? 30,
        child: RaisedButton(
          elevation: 0,
          highlightElevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(this.label ?? '', style: this.textStyle,),
          onPressed: onPressed,
        ),
      );
    }
    if (this.padding != null) {
      result = Container(padding: this.padding, child: result);
    }

    if (tip != null) {
      result = Tooltip(child: result, message: tip,);
    }

    return result;
  }
}
