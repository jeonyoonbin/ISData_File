import 'dart:async';

import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/Model/agentListModel.dart';
import 'package:daeguro_admin_app/Model/agentDetailModel.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/View/AgentManager/agentAccountEdit.dart';
import 'package:daeguro_admin_app/View/AgentManager/agentAccount_Controller.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/constants/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AgentAccountList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AgentAccountListState();
  }
}

class AgentAccountListState extends State<AgentAccountList> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final List<AgentListModel> dataList = <AgentListModel>[];
  List MCodeListitems = List();
  String _mCode = '2';

  int _SerchCount = 0;

  _reset() {
    //this.formData = AgentAccount();
    //formKey.currentState.reset();
    //loadData();
  }

  _query() {
    //formKey.currentState.save();

    AgentController.to.MCode.value = _mCode;

    loadData();
  }

  _newAgent(){
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: AgentAccountEdit(
          sData: null,
        ),
      ),
    ).then((v) async{
      if (v != null) {
        await Future.delayed(Duration(milliseconds: 500), (){
          loadData();
        });
      }
    });
  }

  _edit({String ccCode}) async {
    AgentDetailModel editData = null;

    await AgentController.to.getDetailData(ccCode.toString()).then((value) {
      if(value == null){
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else{
        if (value != null){
          editData = AgentDetailModel.fromJson(value);
        }
      }
    });

    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: AgentAccountEdit(
          sData: editData,
        ),
      ),
    ).then((v) async {
      if (v != null) {
        await Future.delayed(Duration(milliseconds: 500), (){
          loadData();
        });
      }
    });
  }

  loadMCodeListData() async {
    //MCodeListitems.clear();

    //await AgentController.to.getDataMCodeItems();
    MCodeListitems = Utils.getMCodeList();

    if(this.mounted) {
      setState(() {
          //MCodeListitems = AgentController.to.qDataMCodeItems;
      });
    }
  }

  loadData() async {
    dataList.clear();
    _SerchCount = 0;

    await AgentController.to.getData(_mCode).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        value.forEach((e) {
          _SerchCount++;
          AgentListModel temp = AgentListModel.fromJson(e);

          temp.telNo = Utils.getPhoneNumFormat(temp.telNo, true);

          dataList.add(temp);
        });

        setState(() {

        });
      }

    });

    // if(this.mounted){
    //   setState(() {
    //
    //   });
    // }
  }

  @override
  void initState() {
    super.initState();

    Get.put(AgentController());

    WidgetsBinding.instance.addPostFrameCallback((c) {
      //_reset();
      loadMCodeListData();
      _query();
    });
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  void deactivate(){
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
          //testSearchBox(),
        ],
      ),
    );

    var buttonBar = Expanded(
      flex: 0,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            ISSearchDropdown(
              label: '회원사명',
              value: _mCode,
              onChange: (value) {
                setState(() {
                  _mCode = value;
                  _query();
                });
              },
              width: 200,
              item: MCodeListitems.map((item) {
                return new DropdownMenuItem<String>(
                    child: new Text(item['mName'], style: TextStyle(fontSize: 13, color: Colors.black),),
                    value: item['mCode']);
              }).toList(),
            ),
            // SizedBox(width: 15,),
            // ISButton(label: '새로고침',
            //     iconData: Icons.refresh,
            //     onPressed: () => _query()),
            SizedBox(width: 8,),
            AuthUtil.isAuthCreateEnabled('3') == true ? ISSearchButton(label: '콜센터 등록',
                iconData: Icons.add,
                onPressed: () => _newAgent()
            ) : Container(),
            ]
      ),
    );

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          form,
          buttonBar,
          Divider(),
          ISDatatable(
            panelHeight: (MediaQuery.of(context).size.height-defaultContentsHeight),
            listWidth: Responsive.getResponsiveWidth(context, 720), //Responsive.isTablet(context) ? MediaQuery.of(context).size.width : contentListWidth,
            rows: dataList.map((item) {
              return DataRow(
                  onSelectChanged: (bool value){
                    //print('onSelect -> '+item.shopName);
                    // showModalBottomSheet(
                    //     context: context,
                    //     builder: (context){
                    //       return showDetailSheet(item.ccCode);
                    //     }
                    // );
                  },
                  cells: [
                    DataCell(Center(child: Text(item.ccCode.toString() ?? '--',style: TextStyle(color: Colors.black)))),
                    DataCell(Align(child: Text(item.ccName.toString() ?? '--',style: TextStyle(color: Colors.black)),alignment: Alignment.centerLeft)),
                    DataCell(Center(child: Text(_getCallCentLevel(item.cLevel.toString()),style: TextStyle(color: Colors.black)))),
                    DataCell(Center(child: item.useGbn.toString() == 'Y' ? Icon(Icons.radio_button_unchecked, color: Colors.blue, size: 16) : Icon(Icons.clear, color: Colors.red))),
                    DataCell(Align(child: Text(Utils.getCashComma(item.remainAmt.toString()) ?? '--',style: TextStyle(color: Colors.black)),alignment: Alignment.centerLeft)),
                    DataCell(Align(child: Text(Utils.getPhoneNumFormat(item.telNo, false) ?? '--', style: TextStyle(color: Colors.black)),alignment: Alignment.centerLeft)),
                    DataCell(Align(child: Text(item.owner.toString() ?? '--',style: TextStyle(color: Colors.black)),alignment: Alignment.centerLeft)),
                    DataCell(
                      Center(
                        child: InkWell(
                            onTap: () {
                              _edit(ccCode: item.ccCode);
                            },
                            child: Icon(Icons.edit)
                        ),
                      ),
                    ),
                  ]);
            }).toList(),
            columns: <DataColumn>[
              DataColumn(label: Expanded(child: Text('콜센터코드', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('콜센터명', textAlign: TextAlign.left)),),
              DataColumn(label: Expanded(child: Text('콜센터레벨', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('사용구분', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('계좌적립잔액', textAlign: TextAlign.left)),),
              DataColumn(label: Expanded(child: Text('전화번호', textAlign: TextAlign.left)),),
              DataColumn(label: Expanded(child: Text('대표자명', textAlign: TextAlign.left)),),
              DataColumn(label: Expanded(child: Text('관리', textAlign: TextAlign.center)),),
            ],
          ),
          Divider(),
          SizedBox(height: 40,),
          //Align(child: Text(_SerchCount.toString() + ' 건 조회', style: TextStyle(fontWeight: FontWeight.bold)), alignment: Alignment.bottomRight)
        ],
      ),
    );
  }

  String _getCallCentLevel(String ccLevel){
    String ret = '';
    if (ccLevel.compareTo('1') == 0)      ret = '본사';
    else if (ccLevel.compareTo('3') == 0)      ret = '지점';

    return ret;
  }
}
