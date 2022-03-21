import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:flutter/material.dart';


class ISToggleButtons extends StatefulWidget {
  final List<SelectOptionVO> options;
  final Object defaultValue;
  final double fontSize;
  final ValueChanged afterOnPress;
  ISToggleButtons(this.options, {this.defaultValue, this.fontSize, this.afterOnPress});

  @override
  ISToggleButtonsState createState() => ISToggleButtonsState();
}

class ISToggleButtonsState extends State<ISToggleButtons> {
  List<bool> isSelected;
  @override
  void initState() {
    super.initState();
    this.isSelected = widget.options.map((e) => widget.defaultValue == e.value).toList();
  }

  @override
  Widget build(BuildContext context) {
    var list = widget.options.map((e) => Padding(
      child: Text(e.label, style: TextStyle(fontSize: widget.fontSize ?? 12),),
      padding: EdgeInsets.symmetric(horizontal: 10),
    )).toList();

    return ToggleButtons(
      children: list,
      onPressed: (index) {
        setState(() {
          for (int i = 0; i < isSelected.length; i++) {
            setState(() {
              isSelected[i] = i == index;
            });
          }
          widget.afterOnPress(widget.options[index].value);
        });
      },
      isSelected: isSelected,
    );
  }
}
