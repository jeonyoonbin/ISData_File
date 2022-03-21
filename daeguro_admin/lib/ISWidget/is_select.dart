
import 'package:daeguro_admin_app/ISWidget/is_form_field.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:flutter/material.dart';

class ISSelect extends ISFormField {
  ISSelect({
    Key key,
    double width,
    String label,
    String value,
    ValueChanged onChange,
    FormFieldSetter onSaved,
    GestureTapCallback onTap,
    bool required = false,
    FormFieldValidator<String> validator,
    List<SelectOptionVO> dataList = const [],
    bool ignoring = false,
    bool paddingEnabled = true

  }) : super(
    key: key,
    width: width,
    padding: paddingEnabled == true ?  8.0 : 0.0,
    builder: (ISFormFieldState state) {
      return Container(
        //padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
        height: 40,
        child: IgnorePointer(
          ignoring: ignoring ?? false,
          child: (value == ''|| value == null)
              ? DropdownButtonFormField<String>(
            isExpanded: true,
            //decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), labelText: label, labelStyle: LabelStyle),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
              fillColor: ignoring == false ? (paddingEnabled == false ? Colors.grey[200] : Colors.grey[300]) : Colors.grey[200],
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
            validator: (v) {
              // if (required && v.isEmpty) {
              //   return '필수입력항목';
              // }
              if (validator != null) {
                return validator(v);
              }
              return null;
            },
            //value: value,
            items: dataList.map((v) {
              return DropdownMenuItem<String>(value: v.value, child: Text(v.label, style: TextStyle(color: Colors.black, fontSize: 12)),);
            }).toList(),
            onChanged: (v) {
              value = v;
              if (onChange != null) {
                onChange(v);
              }
              state.didChange();
            },
            onSaved: onSaved,
            onTap: onTap,
          )
              : DropdownButtonFormField<String>(
            isExpanded: true,
            //decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), labelText: label, labelStyle: LabelStyle),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
              fillColor: ignoring == false ? (paddingEnabled == false ? Colors.grey[200] : Colors.grey[300]) : Colors.grey[200],
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
            validator: (v) {
              // if (required && v.isEmpty) {
              //   return '필수입력항목';
              // }
              if (validator != null) {
                return validator(v);
              }
              return null;
            },
            value: value,
            items: dataList.map((v) {
              return DropdownMenuItem<String>(
                value: v.value,
                child: Text(v.label, style: TextStyle(color: Colors.black, fontSize: 12),),
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
            onTap: onTap,
          ),
        ),
      );
      },
  );
}
