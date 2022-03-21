import 'package:daeguro_admin_app/ISWidget/userinfo/is_info_form_field.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';



class ISInfoSelectDate extends ISInfoFormField {
  ISInfoSelectDate(
      BuildContext context, {
        Key key,
        String value,
        String label,
        ValueChanged onChange,
        FormFieldSetter onSaved,
      }) : super(
    key: key,
    builder: (ISInfoFormFieldState state) {
      return TextFormField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          labelText: label,
        ),
        controller: TextEditingController(text: value),
        onChanged: (v) {
          if (onChange != null) {
            onChange(v);
          }
        },
        onTap: () async {
          DateTime valueDt = isBlank(value) ? DateTime.now() : DateTime.parse(value);
          final DateTime picked = await showDatePicker(
            context: context,
            initialDate: valueDt,
            firstDate: DateTime(1900, 1),
            lastDate: DateTime(2031, 12),
          );
          if (picked != null) {
            value = formatDate(picked, [yyyy, '-', mm, '-', dd]);
          }
          state.didChange();
        },
        onSaved: onSaved,
      );
    },
  );
}
