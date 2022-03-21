import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/Model/codeListModel.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/CodeManager/code_controller.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopFoodSafetyList extends StatefulWidget {
  @override
  ShopFoodSafetyListState createState() => ShopFoodSafetyListState();
}

class ShopFoodSafetyListState extends State<ShopFoodSafetyList> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final ScrollController _scrollController = ScrollController();

  SearchItems _searchItems = new SearchItems();

  final List<codeListModel> dataList = <codeListModel>[];

  String _codeGrp = 'API';
  String _useGbn = ' ';

  _reset() {
    _searchItems = null;
    _searchItems = new SearchItems();

    //_searchItems.startdate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    //_searchItems.enddate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    _searchItems.memo = '';
  }

  loadData() async {
    await ISProgressDialog(context).show(status: 'Loading...');

    dataList.clear();

    await CodeController.to.getListData(_codeGrp, _useGbn).then((value) {
      if (value == null) {
        //ISAlert(context, '사용자ID 또는 비밀번호를 확인하십시오.');
      }
      else {
        value.forEach((e) {
          codeListModel temp = codeListModel.fromJson(e);

          temp.selected = false;

          dataList.add(temp);
        });
      }
    });

    _scrollController.jumpTo(0.0);

    if (this.mounted) {
      setState(() {
      });
    }

    await ISProgressDialog(context).dismiss();
  }

  @override
  void initState() {
    super.initState();

    Get.put(CodeController());

    WidgetsBinding.instance.addPostFrameCallback((c) {
      _reset();
      loadData();
    });
  }

  @override
  void dispose() {
    dataList.clear();

    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
        ],
      ),
    );

    var buttonBar = Expanded(
      flex: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            children: [
              Text('총: ${Utils.getCashComma(dataList.length.toString())}건', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
            ],
          ),
          Row(
            children: [
              ISSearchButton(
                  label: '조회',
                  iconData: Icons.search,
                  onPressed: () => {
                    loadData(),
                  }),
            ],
          )
        ],
      ),
    );

    return Container(
      //padding: EdgeInsets.only(left: 50, right: 50, bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //SizedBox(height: 10),
          form,
          buttonBar,
          Divider(),
          ISDatatable(
            controller: _scrollController,
            panelHeight: (MediaQuery.of(context).size.height-defaultContentsHeight),
            //dataRowHeight: 30,
            listWidth: Responsive.getResponsiveWidth(context, 720),
            rows: dataList.map((item) {
              return DataRow(
                  color: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
                    if (item.USE_GBN == 'N') {
                      return Colors.grey[300];//Colors.grey.shade200;
                      //return Theme.of(context).colorScheme.primary.withOpacity(0.38);
                    }

                    return Theme.of(context).colorScheme.primary.withOpacity(0.00);
                  }),
                  cells: [
                    //DataCell(Center(child: SelectableText(item.CODE_GRP.toString() ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true))),
                    //DataCell(Center(child: SelectableText(item.CODE ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true))),
                    DataCell(Align(child: SelectableText('[${item.CODE}] '+item.CODE_NM, style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true), alignment: Alignment.centerLeft)),
                    DataCell(Align(child: ISInput(
                      value: item.ETC_CODE_GBN9 ?? '',
                      context: context,
                      textStyle: TextStyle(fontSize: 12),
                      onChange: (v) {
                        item.ETC_CODE_GBN9 = v;
                      },
                    ))
                    ),
                    DataCell(Align(child: ISInput(
                      value: item.ETC_CODE_GBN10 ?? '',
                      context: context,
                      textStyle: TextStyle(fontSize: 12),
                      onChange: (v) {
                        item.ETC_CODE_GBN10 = v;
                      },
                    ))
                    ),
                    if (AuthUtil.isAuthEditEnabled('9') == true)
                    DataCell(Center(child: MaterialButton(
                      height: 34.0,
                      color: Colors.blue,
                      minWidth: 60,
                      child: Text('저장', style: TextStyle(color: Colors.white, fontSize: 14),),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                      onPressed: () async {
                        ISConfirm(context, '영양성분/알레르기유발 정보 저장', '입력된 정보를 저장 하시겠습니까?', (context) async {
                          Navigator.of(context).pop();
                          await CodeController.to.putFoodSafetyData(context, item.CODE, item.ETC_CODE_GBN9, item.ETC_CODE_GBN10).then((value) {
                            Future.delayed(Duration(milliseconds: 500), (){
                              loadData();
                            });
                          });
                        });
                      },
                    )))
                  ]);
            }).toList(),
            columns: <DataColumn>[
              //DataColumn(label: Expanded(child: Text('코드그룹', textAlign: TextAlign.center)),),
              //DataColumn(label: Expanded(child: Text('코드', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('브랜드명', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('영양성분정보 URL', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('알레르기 유발정보 URL', textAlign: TextAlign.center)),),
              if (AuthUtil.isAuthEditEnabled('9') == true)
              DataColumn(label: Expanded(child: Text(' ', textAlign: TextAlign.center)),),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
