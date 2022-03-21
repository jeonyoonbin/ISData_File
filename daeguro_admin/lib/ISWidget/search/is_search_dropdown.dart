import 'package:flutter/material.dart';

class ISSearchDropdown extends StatelessWidget {
  double width;
  String label;
  String value;
  ValueChanged onChange;
  EdgeInsets padding;
  List item;
  bool ignoring = false;

  ISSearchDropdown({this.width, this.label, this.value, this.onChange, this.padding, this.item, this.ignoring = false});

  @override
  Widget build(BuildContext context) {
    return (value == '' || value == null)
        ? Container(
            width: width,
            child: Container(
              //margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Wrap(
                children: [
                  //Container(padding: EdgeInsets.fromLTRB(15, 5, 0, 0), height: 20, child: Text(label, style: TextStyle(fontSize: 10, color: Colors.black54))),
                  Container(
                      padding: padding ?? EdgeInsets.fromLTRB(8, 0, 0, 0),
                      height: 40,
                      child: IgnorePointer(
                        ignoring: ignoring,
                        child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
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
                            style: TextStyle(fontSize: 12, fontFamily: 'NotoSansKR', color: Colors.black),
                            isExpanded: true,
                            onChanged: (value) {
                              if (onChange != null) {
                                onChange(value);
                              }
                            },
                            items: item,
                          ),
                      )),
                ],
              ),
            ),
          )
        : Container(
            width: width,
            child: Container(
              //margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Wrap(
                children: [
                  //Container(padding: EdgeInsets.fromLTRB(15, 5, 0, 0), height: 20, child: Text(label, style: TextStyle(fontSize: 10, color: Colors.black54))),
                  Container(
                      padding: padding ?? EdgeInsets.fromLTRB(8, 0, 0, 0),
                      height: 40,
                      child: IgnorePointer(
                        ignoring: ignoring,
                        child: DropdownButtonFormField(
                            icon: Icon(Icons.arrow_drop_down, size: 24, color: ignoring == false ? Colors.black : Colors.black38,),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
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
                            style: TextStyle(fontSize: 12, fontFamily: 'NotoSansKR', color: ignoring == false ? Colors.black : Colors.black38),
                            isExpanded: true,
                            value: value,
                            onChanged: (value) {
                              if (onChange != null) {
                                onChange(value);
                              }
                            },
                            items: item,
                        ),
                      )),
                ],
              ),
            ),
          );
  }
}
