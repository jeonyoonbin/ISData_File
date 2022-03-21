// import 'dart:async';
//
// import 'package:daeguro_admin_app/ISWidget/is_button.dart';
// import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
// import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
// import 'package:daeguro_admin_app/ISWidget/is_input.dart';
// import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
// import 'package:daeguro_admin_app/Model/calculateUnpublishedTaxModel.dart';
// import 'package:daeguro_admin_app/Model/search_items.dart';
// import 'package:daeguro_admin_app/Model/shop/calculateUngeneratedTaxModel.dart';
// import 'package:daeguro_admin_app/Provider/BackendService.dart';
// import 'package:daeguro_admin_app/Util/utils.dart';
// import 'package:daeguro_admin_app/View/Layout/responsive.dart';
// import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
// import 'package:daeguro_admin_app/constants/constant.dart';
//
// import 'package:date_format/date_format.dart';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
//
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:month_picker_dialog/month_picker_dialog.dart';
//
// import 'calculate_controller.dart';
//
// class CalculateInsertTaxMast extends StatefulWidget {
//   final String shopName;
//
//   const CalculateInsertTaxMast({Key key, this.shopName}) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() {
//     return CalculateInsertTaxMastState();
//   }
// }
//
// class CalculateInsertTaxMastState extends State<CalculateInsertTaxMast> {
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   final TextEditingController _typeAheadController = TextEditingController();
//
//   StreamController<bool> mMenu_streamController = StreamController<bool>();
//   StreamController<bool> mOption_streamController = StreamController<bool>();
//
//   String _listGbn = '1';
//
//   bool isSearching = false;
//   String searchKeyword = '';
//
//   bool _shopGbn = false;
//   bool excelEnable = true;
//   String _div = 'except';
//   String _div2 = '1';
//   String _jobGbn = 'P';
//
//   List<CalculateUngeneratedTaxModel> dataListUngeneratedTax = <CalculateUngeneratedTaxModel>[];
//   List<CalculateUnpublishedTaxModel> dataListUnpublishedTax = <CalculateUnpublishedTaxModel>[];
//
//   List<String> shopList = [];
//
//   List<Map<String, String>> selShop = new List<Map<String, String>>();
//
//   List MCodeListItems = [];
//
//   SearchItems _searchItems = new SearchItems();
//
//   String _divKey = '1';
//
//   void _pageMove(int _page) {
//     _query();
//   }
//
//   _query() {
//     CalculateController.to.startDate.value = _searchItems.startdate.replaceAll('-', '');
//     CalculateController.to.name.value = _searchItems.name;
//     CalculateController.to.divKey.value = _divKey;
//     loadData();
//   }
//
//   // 미 생성 가맹점 조회
//   loadData() async {
//     await CalculateController.to.getUngeneratedTaxData(_searchItems.startdate.replaceAll('-', ''), _jobGbn).timeout(const Duration(seconds: 10), onTimeout: () {
//       print('타임아웃 : 시간초과(10초)');
//     }).then((value) {
//       if (this.mounted) {
//         if (value == null) {
//           ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
//         } else {
//           setState(() {
//             dataListUngeneratedTax.clear();
//
//             value.forEach((e) {
//               CalculateUngeneratedTaxModel temp = CalculateUngeneratedTaxModel.fromJson(e);
//
//               dataListUngeneratedTax.add(temp);
//             });
//           });
//         }
//       }
//     });
//   }
//
//   // 미 발행 세금계산서 조회
//   loadData2() async {
//     await CalculateController.to.getUnpublishedTaxData(_searchItems.startdate.replaceAll('-', '')).then((value) {
//       if (this.mounted) {
//         if (value == null) {
//           ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
//         } else {
//           setState(() {
//             dataListUnpublishedTax.clear();
//
//             value.forEach((e) {
//               CalculateUnpublishedTaxModel temp = CalculateUnpublishedTaxModel.fromJson(e);
//
//               if (temp.taxGbn == '1') {
//                 temp.taxGbn = '세금계산서';
//               } else if (temp.taxGbn == '2') {
//                 temp.taxGbn = '계산서';
//               }
//
//               if (temp.saleGbn == 'S') {
//                 temp.saleGbn = '매출';
//               } else if (temp.saleGbn == 'P') {
//                 temp.saleGbn = '매입';
//               }
//
//               if (temp.taxAcc == 'P') {
//                 temp.taxAcc = '중계 수수료';
//               } else if (temp.taxAcc == 'G') {
//                 temp.taxAcc = 'PG 결제금액';
//               } else if (temp.taxAcc == 'K') {
//                 temp.taxAcc = 'PG 결제 수수료';
//               }
//
//               dataListUnpublishedTax.add(temp);
//             });
//           });
//         }
//       }
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     Get.put(CalculateController());
//     Get.put(ShopController());
//
//     setState(() {
//       _searchItems.startdate = formatDate(DateTime.now(), [yyyy, '-', mm]);
//     });
//   }
//
//   @override
//   void dispose() {
//     if (dataListUngeneratedTax != null) {
//       dataListUngeneratedTax.clear();
//       dataListUngeneratedTax = null;
//     }
//
//     if (dataListUnpublishedTax != null) {
//       dataListUnpublishedTax.clear();
//       dataListUnpublishedTax = null;
//     }
//
//     super.dispose();
//   }
//
//   @override
//   void deactivate() {
//     super.deactivate();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var form = Form(
//       key: formKey,
//       child: Wrap(
//         children: <Widget>[
//           //_getSearchBox(),
//         ],
//       ),
//     );
//
//     var buttonBar = Expanded(
//       flex: 0,
//       child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//           ,
//           Container(
//             child: Row(
//               children: <Widget>[
//                 ISSearchDropdown(
//                   label: '발행 구분',
//                   width: 200,
//                   value: _div2,
//                   onChange: (value) {
//                     setState(() {
//                       if (EasyLoading.isShow == true) return;
//                       _div2 = value;
//                     });
//                   },
//                   item: [
//                     DropdownMenuItem(value: '1', child: Text('발행 요청'),),
//                     DropdownMenuItem(value: '2', child: Text('발행 취소'),),
//                     DropdownMenuItem(value: '3', child: Text('국세청 전송'),),
//                     DropdownMenuItem(value: '4', child: Text('세금계산서 삭제'),),
//                   ].cast<DropdownMenuItem<String>>(),
//                 ),
//                 ISInput(
//                   label: '정산월',
//                   width: 140,
//                   readOnly: true,
//                   value: Utils.getYearMonthFormat(_searchItems.startdate),
//                   onChange: (v) {
//                     _searchItems.startdate = v;
//                   },
//                   onFieldSubmitted: (v) {},
//                   suffixIcon: IconButton(
//                     icon: Icon(Icons.calendar_today),
//                     iconSize: 17,
//                     splashRadius: 20,
//                     color: Colors.blue,
//                     onPressed: () {
//                       showMonthPicker(
//                         context: context,
//                         firstDate: DateTime(DateTime.now().year - 10, 5),
//                         lastDate: DateTime(DateTime.now().year + 10, 9),
//                         initialDate: DateTime.now(),
//                       ).then((date) {
//                         if (date != null) {
//                           print(formatDate(date, [yyyy, mm]));
//
//                           setState(() {
//                             _searchItems.startdate = formatDate(date, [yyyy, mm]);
//                           });
//                         }
//                       });
//                     },
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 ISButton(
//                     label: '일괄 발행',
//                     iconData: Icons.publish,
//                     onPressed: () => {
//                       ISConfirm(context, '일괄 발행', '일괄 발행 하시겠습니까?', (context) async {
//                         Navigator.of(context).pop();
//
//                         await EasyLoading.show(status: 'Loading...');
//
//                         await CalculateController.to.putTaxBillData(_div2, _searchItems.startdate.replaceAll('-', ''),
//                             GetStorage().read('logininfo')['uCode'], GetStorage().read('logininfo')['name'], context).timeout(const Duration(seconds: 15), onTimeout: () {
//                           print('타임아웃 : 시간초과(15초)');
//                         }).then((value) {
//                           _listGbn = '2';
//                           loadData2();
//                         });
//
//                         await EasyLoading.dismiss();
//                       })
//                     }),
//               ],
//             ),
//           )
//           ]
//       ),
//     );
//
//     return Container(
//       //padding: EdgeInsets.only(left: 50, right: 50, bottom: 0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           // SizedBox(height: 5),
//           form,
//           buttonBar,
//           Divider(),
//           Container(
//             child: Row(
//               children: [
//                 Expanded(
//                   flex: 3,
//                   child: Column(
//                     children: [
//                       Expanded(
//                         flex: 1,
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: ,
//                             ),
//                             ,
//                           ],
//                         ),
//                       ),
//                       Expanded(
//                         flex: 10,
//                         child: Container(
//                           decoration: new BoxDecoration(border: Border.all(color: Colors.black12, width: 1)),
//                           child: ,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(width: 5),
//                 _listGbn == '1' ? ungeneratedTax() : unpublishedTax(),
//               ],
//             ),
//           ),
//           SizedBox(height: 10)
//         ],
//       ),
//     );
//   }
//
//   Widget ungeneratedTax() {
//     return Expanded(
//       flex: 9,
//       child: Column(
//         children: [
//           Expanded(
//             flex: 1,
//             child: Container(
//               child: Text('- 미 생성 가맹점 조회 리스트', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
//               alignment: Alignment.centerLeft,
//               margin: EdgeInsets.all(5),
//             ),
//           ),
//           Expanded(
//             flex: 10,
//             child: Container(
//               decoration: new BoxDecoration(border: Border.all(color: Colors.black12, width: 1)),
//               child: ISDatatable(
//                 // showCheckboxColumn: true,
//                 panelHeight: (MediaQuery.of(context).size.height-defaultContentsHeight)-16,
//                 listWidth: Responsive.getResponsiveWidth(context, 640),
//                 rows: dataListUngeneratedTax.map((item) {
//                   return DataRow(cells: [
//                     DataCell(Center(child: SelectableText(item.shopCd ?? '--', style: TextStyle(color: Colors.black), showCursor: true))),
//                     DataCell(Align(child: SelectableText(item.shopName ?? '--', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true), alignment: Alignment.centerLeft)),
//                     DataCell(Center(child: SelectableText(Utils.getStoreRegNumberFormat(item.regNo) ?? '--', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true))),
//                     DataCell(Center(child: SelectableText(Utils.getYearMonthFormat(item.chargeYm) ?? '--', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true))),
//                     DataCell(Center(child: SelectableText(Utils.getYearMonthDayFormat(item.issymd) ?? '--', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true))),
//                     DataCell(Align(child: SelectableText(Utils.getCashComma(item.chargeAmt) ?? '--', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true), alignment: Alignment.centerRight)),
//                   ]);
//                 }).toList(),
//                 columns: <DataColumn>[
//                   DataColumn(label: Expanded(child: Text('가맹점번호', textAlign: TextAlign.center)),),
//                   DataColumn(label: Expanded(child: Text('가맹점명', textAlign: TextAlign.center)),),
//                   DataColumn(label: Expanded(child: Text('사업자번호', textAlign: TextAlign.center)),),
//                   DataColumn(label: Expanded(child: Text('정산월', textAlign: TextAlign.center)),),
//                   DataColumn(label: Expanded(child: Text('처리일', textAlign: TextAlign.center)),),
//                   DataColumn(label: Expanded(child: Text('정산금액', textAlign: TextAlign.center)),),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget unpublishedTax() {
//     return Expanded(
//       flex: 9,
//       child: Column(
//         children: [
//           Expanded(
//             flex: 1,
//             child: Container(
//               child: Text('- 미 발행 세금계산서 조회 리스트', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
//               alignment: Alignment.centerLeft,
//               margin: EdgeInsets.all(5),
//             ),
//           ),
//           Expanded(
//             flex: 10,
//             child: Container(
//               decoration: new BoxDecoration(border: Border.all(color: Colors.black12, width: 1)),
//               child: ISDatatable(
//                 // showCheckboxColumn: true,
//                 rows: dataListUnpublishedTax.map((item) {
//                   return DataRow(cells: [
//                     DataCell(Center(child: SelectableText(item.shopCd ?? '--', style: TextStyle(color: Colors.black), showCursor: true))),
//                     DataCell(Align(child: SelectableText(item.shopName ?? '--', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true), alignment: Alignment.centerLeft)),
//                     DataCell(Center(child: SelectableText(Utils.getYearMonthDayFormat(item.issymd) ?? '--', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true))),
//                     DataCell(Center(child: SelectableText(item.taxNo ?? '--', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true))),
//                     DataCell(Center(child: SelectableText(item.taxGbn ?? '--', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true))),
//                     DataCell(Center(child: SelectableText(item.taxAcc ?? '--', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true),)),
//                     DataCell(Center(child: SelectableText(item.saleGbn ?? '--', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true),)),
//                     DataCell(Align(child: SelectableText(Utils.getCashComma(item.supamt) ?? '--', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true), alignment: Alignment.centerRight)),
//                     DataCell(Align(child: SelectableText(Utils.getCashComma(item.vatamt) ?? '--', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true), alignment: Alignment.centerRight)),
//                     DataCell(Align(child: SelectableText(Utils.getCashComma(item.amt) ?? '--', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true), alignment: Alignment.centerRight)),
//                     DataCell(Center(child: SelectableText(item.memo ?? '--', style: TextStyle(color: Colors.black), textAlign: TextAlign.center, showCursor: true),)),
//                   ]);
//                 }).toList(),
//                 columns: <DataColumn>[
//                   DataColumn(label: Expanded(child: Text('가맹점번호', textAlign: TextAlign.center)),),
//                   DataColumn(label: Expanded(child: Text('가맹점명', textAlign: TextAlign.center)),),
//                   DataColumn(label: Expanded(child: Text('처리일', textAlign: TextAlign.center)),),
//                   DataColumn(label: Expanded(child: Text('일련번호', textAlign: TextAlign.center)),),
//                   DataColumn(label: Expanded(child: Text('계산서\n구분', textAlign: TextAlign.center)),),
//                   DataColumn(label: Expanded(child: Text('매입/매출\n구분', textAlign: TextAlign.center)),),
//                   DataColumn(label: Expanded(child: Text('매출계정', textAlign: TextAlign.center)),),
//                   DataColumn(label: Expanded(child: Text('공급가 합계', textAlign: TextAlign.center)),),
//                   DataColumn(label: Expanded(child: Text('부가세 합계', textAlign: TextAlign.center)),),
//                   DataColumn(label: Expanded(child: Text('급액 합계', textAlign: TextAlign.center)),),
//                   DataColumn(label: Expanded(child: Text('메모', textAlign: TextAlign.center)),),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void disableSearching() {
//     clearSearchKeyword();
//
//     setState(() {
//       mMenu_streamController.add(false);
//       mOption_streamController.add(false);
//       isSearching = false;
//     });
//   }
//
//   void clearSearchKeyword() {
//     setState(() {
//       _typeAheadController.clear();
//       updateSearchKeyword('');
//     });
//   }
//
//   void updateSearchKeyword(String newKeyword) {
//     setState(() {
//       searchKeyword = newKeyword;
//       _typeAheadController.text = searchKeyword;
//     });
//   }
// }
