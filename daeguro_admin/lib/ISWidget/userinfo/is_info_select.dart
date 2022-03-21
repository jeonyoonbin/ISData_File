import 'package:daeguro_admin_app/ISWidget/userinfo/is_info_form_field.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';

import 'package:flutter/material.dart';

class ISInfoSelect extends ISInfoFormField {
  ISInfoSelect({
    Key key,
    double width,
    String label,
    String value,
    ValueChanged onChange,
    FormFieldSetter onSaved,
    List<SelectOptionVO> dataList = const [],
  }) : super(
    key: key,
    width: width,
    builder: (ISInfoFormFieldState state) {
      return DropdownButtonFormField<String>(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          labelText: label,
        ),
        value: value,
        items: dataList.map((v) {
          return DropdownMenuItem<String>(
            value: v.value,
            child: Text(v.label),
          );
        }).toList(),
        onChanged: (v) {
          value = v;
          if (onChange != null) {
            onChange(v);
          }
          state.didChange();
        },
        onSaved: onSaved,
      );
    },
  );
}