import 'package:flutter/material.dart';

class ISCheckbox extends StatefulWidget {
  final String label;
  final bool value;
  final EdgeInsetsGeometry padding;
  //final TextStyle labelStyle;
  final ValueChanged<bool> onChanged;
  final FocusNode focusNode;

  ISCheckbox({this.label, this.value, this.padding, this.onChanged, this.focusNode});

  @override
  _ISCheckboxState createState() => _ISCheckboxState();
}

class _ISCheckboxState extends State<ISCheckbox> {
  bool _value;

  @override
  void didUpdateWidget(covariant ISCheckbox oldWidget) {
    _value = widget.value;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var result = Container(
      padding: widget.padding ?? EdgeInsets.all(10),
      child: Wrap(
        children: [
          Checkbox(
            value: _value,
            onChanged: (v) {
              this._value = v;
              widget.onChanged(v);
              setState(() {});
            },
            focusNode: widget.focusNode,
          ),
          Container(
              padding: EdgeInsets.only(top: 6),
              child: Text(widget.label, style: TextStyle(fontSize: 12),))
          ,
        ],
      ),
    );
    return result;
  }
}
