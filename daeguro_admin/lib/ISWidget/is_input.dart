import 'package:daeguro_admin_app/ISWidget/is_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ISInput extends ISFormField {
  ISInput({
    Key key,
    double width,
    double height,
    double padding,
    double contentPadding,
    int maxLines,
    String label,
    String value,
    TextAlign textAlign,
    TextStyle textStyle,
    ValueChanged onChange,
    FormFieldSetter<String> onSaved,
    FormFieldValidator<String> validator,
    ValueChanged<String> onFieldSubmitted,
    TextInputType keyboardType = TextInputType.text,
    int maxLength,
    //bool enable,
    bool readOnly = false,
    bool required = false,
    bool autofocus = false,
    bool obscureText = false,
    Widget prefixIcon,
    Widget suffixIcon,
    BuildContext context,
    List<TextInputFormatter> inputFormatters,
    GestureTapCallback onTap
  }) : super(
          key: key,
          width: width,
          //padding: 0.0,
          builder: (ISFormFieldState state) {
            TextEditingController _textEditingController = TextEditingController(text: value);
            if (value != null){
              _textEditingController.value = _textEditingController.value.copyWith(
                selection: TextSelection.fromPosition(TextPosition(offset: value.length)),
              );
            }

            return Container(
              //padding: EdgeInsets.symmetric(horizontal: 8.0),
              alignment: Alignment.center,
              height: height ?? 40,
              child: TextFormField(
                maxLength: maxLength,
                autofocus: autofocus,
                readOnly: readOnly,
                onEditingComplete: () => context == null ? null : FocusScope.of(context).nextFocus(),
                textAlign: textAlign ?? TextAlign.start,
                textAlignVertical: prefixIcon == null ? TextAlignVertical.top : TextAlignVertical.center,
                maxLines: maxLines ?? 1,
                keyboardType: keyboardType,
                onFieldSubmitted: onFieldSubmitted,
                style: textStyle ?? TextStyle(fontSize: 13),
                obscureText: obscureText ?? false,
                decoration: InputDecoration(
                  isDense: false,
                  fillColor: readOnly == false ? Colors.grey[300] : Colors.grey[200],
                  //Color(0xffdefcfc),
                  filled: true,
                  prefixIcon: prefixIcon,
                  suffixIcon: suffixIcon,
                  enabled: true,//enabled: readOnly == false ? true : false,//enable ?? true,
                  labelText: label,
                  labelStyle: TextStyle(color: Colors.black54, fontSize: 10),
                  //border: const OutlineInputBorder(),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                  ),
                  //hintText: label,
                  contentPadding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
                ),
                controller: _textEditingController,//TextEditingController(text: value),
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
                onTap: onTap,
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
            );
          },
        );
}
