import 'dart:async';

import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/Model/apiCompanyDModel.dart';
import 'package:daeguro_admin_app/Model/apiCompanyModel.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/View/ApiCompanyManager/apiCompanyEdit.dart';
import 'package:daeguro_admin_app/View/ApiCompanyManager/apiCompanyRegist.dart';
import 'package:daeguro_admin_app/View/ApiCompanyManager/apiCompany_controller.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/constants/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApiCompanyList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ApiCompanyListState();
  }
}

class ApiCompanyListState extends State {
  String _type = '1';
  String _gbn = ' ';

  int _SerchCount = 0;

  List<ApiCompanyModel> dataList = <ApiCompanyModel>[];

  _reset() {
    //this.formData = AgentAccount();
    //formKey.currentState.reset();
    //loadData();
  }

  _query() {
    //formKey.currentState.save();

    loadData();
  }

  _regist() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: ApiCompanyRegist(),
      ),
    ).then((v) async {
      if (v != null) {
        await Future.delayed(Duration(milliseconds: 500), () {
          loadData();
        });
      }
    });
  }

  _edit({String seq}) async {
    ApiCompanyDModel editData = null;

    await ApiCompanyController.to.getDetailData(seq.toString()).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        editData = ApiCompanyDModel.fromJson(value);
      }
    });


    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: ApiCompanyEdit(
          sData: editData, seq: seq,
        ),
      ),
    ).then((v) async {
      if (v != null) {
        await Future.delayed(Duration(milliseconds: 500), () {
          loadData();
        });
      }
    });
  }

  loadMCodeListData() async {
    setState(() {});
  }

  loadData() async {
    dataList.clear();
    _SerchCount = 0;

    await ApiCompanyController.to.getData(_type, _gbn).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        value.forEach((e) {
          _SerchCount++;
          ApiCompanyModel temp = ApiCompanyModel.fromJson(e);
          dataList.add(temp);
        });
      }
    });

    //if (this.mounted) {
      setState(() {
      });
    //}
  }

  @override
  void initState() {
    super.initState();

    Get.put(ApiCompanyController());

    WidgetsBinding.instance.addPostFrameCallback((c) {
      //_reset();
      //loadMCodeListData();
      _query();
    });
  }

  @override
  void dispose() {
    super.dispose();

    dataList.clear();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    var buttonBar = Expanded(
      flex: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ISSearchDropdown(
            label: '업체타입',
            width: 150,
            value: _type,
            onChange: (value) {
              setState(() {
                _type = value;
                _query();
              });
            },
            item: [
              DropdownMenuItem(value: ' ', child: Text('전체'),),
              DropdownMenuItem(value: '1', child: Text('주문'),),
              DropdownMenuItem(value: '3', child: Text('POS(배달)'),),
            ].cast<DropdownMenuItem<String>>(),
          ),
          SizedBox(
            width: 8,
          ),
          if (AuthUtil.isAuthCreateEnabled('39') == true)
          ISSearchButton(
              label: '추가',
              iconData: Icons.add,
              onPressed: () {
                _regist();
              }),
        ],
      ),
    );



    return Container(
      //padding: EdgeInsets.only(left: 140, right: 140, bottom: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          buttonBar,
          Divider(),
          ISDatatable(
            panelHeight: (MediaQuery.of(context).size.height-defaultContentsHeight),
            listWidth: Responsive.getResponsiveWidth(context, 480), // Responsive.isTablet(context) ? MediaQuery.of(context).size.width : contentListWidth,
            rows: dataList.map((item) {
              return DataRow(cells: [
                DataCell(Center(child: Text(item.seq.toString() ?? '--', style: TextStyle(color: Colors.black)))),
                DataCell(Center(child: Text(_getcompanyType(item.companyType.toString()), style: TextStyle(color: Colors.black)))),
                DataCell(Center(child: Text(item.companyGbn.toString() ?? '--', style: TextStyle(color: Colors.black)))),
                DataCell(Align(child: Text(item.companyName.toString() ?? '--', style: TextStyle(color: Colors.black)),alignment: Alignment.centerLeft)),
                DataCell(
                  Center(
                    child: InkWell(
                        onTap: () {
                          _edit(seq: item.seq);
                        },
                        child: Icon(Icons.edit)
                    ),
                  ),
                ),
              ]);
            }).toList(),
            columns: <DataColumn>[
              DataColumn(label: Expanded(child: Text('순번', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('업체타입', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('업체구분', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('업체명', textAlign: TextAlign.left)),),
              DataColumn(label: Expanded(child: Text('관리', textAlign: TextAlign.center)),),
            ],
          ),
          //Align(child: Text(_SerchCount.toString() + ' 건 조회', style: TextStyle(fontWeight: FontWeight.bold)), alignment: Alignment.bottomRight)
        ],
      ),
    );
  }

  String _getcompanyType(String value) {
    String retValue = '--';

    if (value.toString().compareTo('1') == 0)
      retValue = '주문';
    else if (value.toString().compareTo('3') == 0)
      retValue = 'POS(배달)';
    else
      retValue = '--';

    return retValue;
  }
}
