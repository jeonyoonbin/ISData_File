
import 'package:daeguro_admin_app/ISWidget/bottomsheet/is_bs_form_field.dart';
import 'package:flutter/material.dart';

class ISBSSwitchButton extends ISBSFormField {
  ISBSSwitchButton({
    Key key,
    double width,
    double padding,
    double contentPadding,

    String label,
    bool value,
    ValueChanged onChanged,


    bool autofocus = false,

    BuildContext context,


  }) : super(
    key: key,
    width: width,
    padding: padding,
    builder: (ISBSFormFieldState state) {
      BuildContext _context;

      return Container(
        //margin: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        height: 28.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
                )
            ),
            Flexible(
              child: Switch(
                inactiveTrackColor: Colors.red[200],
                activeTrackColor: Colors.blue[200],
                activeColor: Colors.blue[200],
                value: value,
                autofocus: autofocus,
                onChanged: (v) {
                  if (onChanged != null) {
                    onChanged(v);
                  }
                },
              ),
            ),
          ],
        ),

      );
    },
  );
}
