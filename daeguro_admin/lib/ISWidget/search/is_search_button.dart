import 'package:flutter/material.dart';

class ISSearchButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData iconData;
  final String tip;
  final EdgeInsets padding;
  final TextStyle textStyle;
  final bool enable;
  final double width;

  ISSearchButton(
      {this.label,
        this.iconData,
        this.onPressed,
        this.tip,
        this.padding,
        this.textStyle,
        this.enable = true,
        this.width});

  @override
  Widget build(BuildContext context) {
    Widget result;

    if (!enable) return Container(height: 40,);

    if (iconData != null) {
      if (label == null) {
        result = Container(
          width: 48,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.blue,//secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(6.0)),
          ),
          child: IconButton(
            icon: Icon(iconData, size: 16, color: Colors.white,),
            onPressed: onPressed,
          ),
        );
      }
      else {
        result = Container(
          width: width ?? null,
          height: 40,
          child: RaisedButton.icon(
            elevation: 0,
            highlightElevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0)
            ),
            icon: Icon(iconData, size: 16, color: Colors.white),
            label: Text(this.label, style: this.textStyle ?? TextStyle(fontSize: 14, color: Colors.white),),
            onPressed: onPressed,
          ),
        );
      }
    }
    else {
      result = Container(
        width: width ?? null,
        height: 40,
        child: RaisedButton(
          elevation: 0,
          highlightElevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0)
          ),
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(this.label ?? '', style: this.textStyle ?? TextStyle(fontSize: 14, color: Colors.white),),
          onPressed: onPressed,
        ),
      );
    }
    if (this.padding != null) {
      result = Container(padding: this.padding, child: result);
    }

    if (tip != null) {
      result = Tooltip(
        child: result,
        message: tip,
      );
    }

    return result;
  }
}