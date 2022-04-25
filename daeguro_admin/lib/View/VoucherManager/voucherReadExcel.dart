import 'dart:typed_data';

import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

Future<List<Map<String,String>>> openExcelFile() async {
  FilePickerResult result;
  List<String> voucherNo = [];
  List<Map<String,String>> returnData = [];
  try{
    result = await FilePicker.platform.pickFiles(type: FileType.custom,
      allowedExtensions: ['xls', 'xlsx'],
    );
    if(result != null) {
      Uint8List uploadfile = result.files.single.bytes;
      var excel = Excel.decodeBytes(uploadfile);
      for (var sheetName in excel.tables.keys) {
        // print(excel.tables[sheetName].maxRows);
        // print(excel.tables[sheetName].maxCols);
        for (var row in excel.tables[sheetName].rows) {
          // print(row);
          if (row != null) {
            row.forEach((data) {
              if(data != null && data.value != null){
                if(data.rowIndex==0) {
                  voucherNo.add("${data.value}");
                }else{
                  Map<String,String> maps = {"type":"${voucherNo[data.colIndex]}","tel":"${data.value}",};
                  returnData.add(maps);
                }
              }
            });
          }
        }} //for
  }
    return returnData;
  }catch(e) {
    print(e);
    return null;
  }

}