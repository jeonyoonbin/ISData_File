import 'package:flutter/material.dart';

class ISDatatable extends StatelessWidget {
  final double panelHeight;
  final double listWidth;
  final VoidCallback onPressed;
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final double dataRowHeight;
  final bool showCheckboxColumn;
  final ScrollController controller;
  ISDatatable({
    this.panelHeight,
    this.listWidth,
    this.onPressed,
    this.rows,
    this.columns,
    this.dataRowHeight,
    this.showCheckboxColumn,
    this.controller
  });

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      isAlwaysShown: controller == null ? false : true,
      controller: controller,
      child: Container(
        height: panelHeight,
        child: ListView(
          controller: controller,
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),//(20, 0, 20, 20),
          children: <Widget>[
            Container(
              width: listWidth ?? 1650,//MediaQuery.of(context).size.width,
              child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    DataTable(
                      horizontalMargin: 8,
                      checkboxHorizontalMargin: 10,
                      headingRowColor:MaterialStateColor.resolveWith((states) => Colors.blue[50]),
                      headingTextStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', color: Colors.black54),
                      headingRowHeight: 40,
                      dataRowHeight: dataRowHeight ?? 40.0,
                      dataTextStyle: TextStyle(fontWeight: FontWeight.normal, fontFamily: 'NotoSansKR', color: Colors.black, fontSize: 13),
                      columnSpacing: 0,
                      showCheckboxColumn: showCheckboxColumn  ?? false,
                      rows: rows,
                      columns: columns,
                    ),
                  ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}
