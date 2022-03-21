import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class ISDatatable2 extends StatelessWidget {
  final VoidCallback onPressed;
  final List<DataColumn2> columns;
  final List<DataRow> rows;
  final double dataRowHeight;
  final bool showCheckboxColumn;
  ISDatatable2({
    this.onPressed,
    this.rows,
    this.columns,
    this.dataRowHeight,
    this.showCheckboxColumn
  });

  @override
  Widget build(BuildContext context) {
    return DataTable2(
      headingRowColor:MaterialStateColor.resolveWith((states) => Colors.blue[50]),
      headingTextStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', color: Colors.black54),
      headingRowHeight: 40,
      dataRowHeight: dataRowHeight,
      dataTextStyle: TextStyle(fontWeight: FontWeight.normal, fontFamily: 'NotoSansKR', color: Colors.black, fontSize: 14),
      columnSpacing: 0,
      showCheckboxColumn: showCheckboxColumn  ?? false,
      rows: rows,
      columns: columns,
    );
  }
}
