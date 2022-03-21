
import 'package:daeguro_admin_app/ISWidget/bottomsheet/is_bs_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ISBSInput extends ISBSFormField {
  ISBSInput({
    Key key,
    double width,
    double padding,
    double contentPadding,
    int maxLines,
    String label,
    String value,
    String hint,
    TextAlign textAlign,
    TextStyle textStyle,
    ValueChanged onChange,
    FormFieldSetter<String> onSaved,
    FormFieldValidator<String> validator,
    ValueChanged<String> onFieldSubmitted,
    TextInputType keyboardType = TextInputType.text,
    bool enable,
    bool readOnly = false,
    bool required = false,
    bool autofocus = false,
    Widget prefixIcon,
    BuildContext context,
    List<TextInputFormatter> inputFormatters,
    Widget suffix,
  }) : super(
    key: key,
    width: width,
    padding: padding,
    builder: (ISBSFormFieldState state) {
      BuildContext _context;

      return Container(
        //margin: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        //color: Colors.yellow,
        height: 28.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
                child: Container(
                  width: 100,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal), textAlign: TextAlign.right),
                  // height: 28.0,
                  // padding: EdgeInsets.only(left: 10, right: 10, top: 4),
                  // child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
                  // decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.blue.withOpacity(.4))),
                )
            ),
            Flexible(
              child: TextFormField(
                enabled: enable ?? true,
                autofocus: autofocus,
                readOnly: readOnly,
                onEditingComplete: () =>
                context == null ? null : FocusScope.of(context).nextFocus(),
                textAlign: textAlign ?? TextAlign.start,
                textAlignVertical: prefixIcon == null ? TextAlignVertical.top : TextAlignVertical.center,
                maxLines: maxLines,
                keyboardType: keyboardType,
                onFieldSubmitted: onFieldSubmitted,
                style: textStyle ?? TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                decoration: InputDecoration(
                  //labelText: label,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.zero, borderSide: BorderSide(color: Colors.white, width: 1),),
                  hintText: hint,
                  contentPadding: EdgeInsets.all(5),
                  suffixIcon: suffix,
                ),
                controller: TextEditingController(text: value),
                inputFormatters: inputFormatters ?? [],
                onChanged: (v) {
                  if (onChange != null) {
                    onChange(v);
                  }
                },
                onSaved: (v) {
                  if (onSaved != null) {
                    onSaved(v);
                  }
                },
                validator: (v) {
                  if (required && v.isEmpty) {
                    return '필수입력항목';
                  }
                  if (validator != null) {
                    return validator(v);
                  }
                  return null;
                },
              ),
            ),
          ],
        ),

      );
    },
  );
}
