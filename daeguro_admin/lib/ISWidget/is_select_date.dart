import 'package:daeguro_admin_app/ISWidget/is_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ISSelectDate extends ISFormField {

  ISSelectDate(
      BuildContext context, {
        Key key,
        String value,
        String label,
        double width,
        double padding,
        bool enable = true,
        ValueChanged onChange,
        FormFieldSetter onSaved,
        GestureTapCallback onTap,
      }) : super(
              key: key,
              width: width,
              padding: padding,
              builder: (ISFormFieldState state) {
                return Container(
                  height: 40,
                  child: TextFormField(
                    enabled: enable,
                    style: TextStyle(fontSize: 13, fontFamily: 'NotoSansKR'),
                    decoration: InputDecoration(
                      isDense: false,
                      fillColor: Colors.grey[200],
                      //Color(0xffdefcfc),
                      filled: true,
                      labelText: label,
                      labelStyle: TextStyle(color: Colors.black54, fontSize: 12),
                      //border: const OutlineInputBorder(),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: const BorderRadius.all(Radius.circular(6)),
                      ),
                    ),
                    //style: TextStyle(fontSize: 13, fontFamily: 'NotoSansKR'),
                    controller: TextEditingController(text: value),
                    onChanged: (v) {
                      if (onChange != null) {
                        onChange(v);
                      }
                    },
                    onTap: onTap,
                    onSaved: onSaved,
                    // onSaved: (v) {
                    //   if (onSaved != null) {
                    //     onSaved(v);
                    //   }
                    // },
                  ),
                );
              },
      );
}
