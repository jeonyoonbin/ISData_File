

import 'package:daeguro_admin_app/ISWidget/bottomsheet/is_bs_form_field.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:flutter/material.dart';

class ISBSSelect extends ISBSFormField {
  ISBSSelect({
    Key key,
    double width,
    String label,
    String value,
    TextStyle LabelStyle,
    TextStyle DropdownStyle,
    ValueChanged onChange,
    FormFieldSetter onSaved,
    GestureTapCallback onTap,
    List<SelectOptionVO> dataList = const [],
  }) : super(
    key: key,
    width: width,
    builder: (ISBSFormFieldState state) {

      return Container(
          height: 28.0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Flexible(
                child: Container(
                  width: 100,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal), textAlign: TextAlign.right),
                )
              ),
              Flexible(
                child: (value == ''|| value == null)
                      ? DropdownButtonFormField<String>(
                    //decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), labelText: label, labelStyle: LabelStyle),
                    decoration: InputDecoration(
                      //labelText: label,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.zero, borderSide: BorderSide(color: Colors.white, width: 1),),
                      contentPadding: EdgeInsets.all(5),
                    ),
                    //value: value,
                    items: dataList.map((v) {
                      return DropdownMenuItem<String>(value: v.value, child: Text(v.label, style: DropdownStyle,),);
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
                    //decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), labelText: label, labelStyle: LabelStyle),
                    decoration: InputDecoration(
                      //labelText: label,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.zero, borderSide: BorderSide(color: Colors.white, width: 1),),
                      contentPadding: EdgeInsets.all(5),
                    ),
                    value: value,
                    items: dataList.map((v) {
                      return DropdownMenuItem<String>(
                        value: v.value,
                        child: Text(v.label, style: DropdownStyle,),
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
            ],
          ),
      );
    },
  );
}
