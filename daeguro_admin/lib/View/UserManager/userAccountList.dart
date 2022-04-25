import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_input.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Model/user/userListDetailModel.dart';
import 'package:daeguro_admin_app/Model/user/userListModel.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/AgentManager/agentAccount_Controller.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/UserManager/userEdit.dart';
import 'package:daeguro_admin_app/View/UserManager/userHistory.dart';
import 'package:daeguro_admin_app/View/UserManager/userRegist.dart';
import 'package:daeguro_admin_app/View/UserManager/user_controller.dart';
import 'package:daeguro_admin_app/constants/constant.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';

class UserAccountList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserAccountListState();
  }
}

class UserAccountListState extends State {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  SearchItems _searchItems = new SearchItems();

  final List<UserListModel> dataList = <UserListModel>[];

  List items = List();
  List CCenterListitems = List();
  List MCodeListitems = List();

  String _mCode = '2';

  String _level = ' ';
  String _working = ' ';
  String _idname = '';
  String _memo = '';
  int _SerchCount = 0;

  //int rowsPerPage = 10;

  int _totalRowCnt = 0;
  int _selectedpagerows = 15;

  int _currentPage = 1;
  int _totalPages = 0;

  void _pageMove(int _page) {
    _query();
  }

  _reset() {
    _searchItems = null;
    _searchItems = new SearchItems();

    // formKey.currentState.initState();
    // formKey.currentState.reset();
  }

  _query() {
    //formKey.currentState.save();

    UserController.to.level.value = _level;
    UserController.to.working.value = _working;
    UserController.to.id_name.value = _searchItems.code;
    UserController.to.memo.value = _searchItems.memo;
    UserController.to.page.value = _currentPage.round().toString();
    UserController.to.raw.value = _selectedpagerows.toString();
    loadData();
  }

  _History(String ucode) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: UserHistory(shopCode: ucode),
      ),
    ).then((v) async {
      if (v != null) {
        await Future.delayed(Duration(milliseconds: 500), () {
          _query();
        });
      }
    });
  }

  _regist() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: UserRegist(),
      ),
    ).then((v) async {
      if (v != null) {
        await Future.delayed(Duration(milliseconds: 500), () {
          loadData();
        });
      }
    });
  }

  _edit({String uCode}) async {
    UserListDetail editData = null;

    await UserController.to.getDetailData(uCode.toString()).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        editData = UserListDetail.fromJson(value);
      }
    });

    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: UserEdit(
          sData: editData,
          mCode: _mCode,
        ),
      ),
    ).then((v) async {
      if (v != null) {
        await Future.delayed(Duration(milliseconds: 500), () {
          _query();
        });
      }
    });
  }

  loadData() async {
    await ISProgressDialog(context).show(status: 'Loading...');

    dataList.clear();
    _SerchCount = 0;
    Get.put(UserController());
    Get.put(AgentController());

    await UserController.to.getData(context, _mCode).then((value) {
      if(value == null){
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        value.forEach((e) {
          _SerchCount++;
          UserListModel temp = UserListModel.fromJson(e);

          // print('name check stt ->${temp.name}');
          temp.name = Utils.getNameAbsoluteFormat(temp.name.toString(), true);
          // print('name check end ->${temp.name}');

          dataList.add(temp);
        });

        _totalRowCnt = UserController.to.totalRowCnt;
        _totalPages = (_totalRowCnt / _selectedpagerows).ceil();
      }

    });

    await AgentController.to.getDataCCenterItems(_mCode).then((value) {
      if(value == null){
        ISAlert(context, '콜센터정보를 가져오지 못했습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        CCenterListitems = value;//AgentController.to.qDataCCenterItems;
      }
    });
    //await AgentController.to.getDataMCodeItems();


    //MCodeListitems = AgentController.to.qDataMCodeItems;

    MCodeListitems = Utils.getMCodeList();

    setState(() {

    });

    await ISProgressDialog(context).dismiss();
  }

  @override
  void initState() {
    super.initState();

    Get.put(UserController());

    WidgetsBinding.instance.addPostFrameCallback((c) {
      _reset();
      _query();
    });
  }

  @override
  Widget build(BuildContext context) {
    var buttonBar = Expanded(
      flex: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            children: [
              Text('총: ${Utils.getCashComma(UserController.to.totalRowCnt.toString())}건', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  ISSearchDropdown(
                    label: '회원사명',
                    value: _mCode,
                    onChange: (value) {
                      setState(() {
                        _mCode = value;
                        _currentPage = 1;
                        _query();
                      });
                    },
                    width: 240,
                    item: MCodeListitems.map((item) {
                      return new DropdownMenuItem<String>(
                          child: new Text(item['mName'], style: TextStyle(fontSize: 13, color: Colors.black),),
                          value: item['mCode']);
                    }).toList(),
                  ),
                  SizedBox(height: 8,),
                  Row(
                    children: [
                      ISSearchDropdown(
                        label: '접속권한',
                        width: 120,
                        value: _level,
                        onChange: (value) {
                          setState(() {
                            _level = value;
                            _currentPage = 1;
                            //formKey.currentState.save();
                            _query();
                          });
                        },
                        item: [
                          DropdownMenuItem(value: ' ', child: Text('전체'),),
                          DropdownMenuItem(value: '0', child: Text('시스템'),),
                          DropdownMenuItem(value: '1', child: Text('관리자'),),
                          DropdownMenuItem(value: '5', child: Text('영업사원'),),
                          DropdownMenuItem(value: '6', child: Text('오퍼레이터'),),
                        ].cast<DropdownMenuItem<String>>(),
                      ),
                      ISSearchDropdown(
                        label: '업무상태',
                        width: 120,
                        value: _working,
                        onChange: (value) {
                          setState(() {
                            _working = value;
                            formKey.currentState.save();
                            _currentPage = 1;
                            _query();
                          });
                        },
                        item: [
                          DropdownMenuItem(value: ' ', child: Text('전체'),),
                          DropdownMenuItem(value: '1', child: Text('재직'),),
                          DropdownMenuItem(value: '3', child: Text('휴직'),),
                          DropdownMenuItem(value: '5', child: Text('퇴직'),),
                        ].cast<DropdownMenuItem<String>>(),
                      ),
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  ISSearchInput(
                    label: '아이디, 이름',
                    width: 200,
                    value: _searchItems.code,
                    onChange: (v) {
                      _searchItems.code = v;
                    },
                    onFieldSubmitted: (value) {
                      _currentPage = 1;
                      _query();
                    },
                  ),
                  SizedBox(height: 8,),
                  ISSearchInput(
                    label: '메모',
                    width: 200,
                    value: _searchItems.memo,
                    onChange: (v) {
                      _searchItems.memo = v;
                    },
                    onFieldSubmitted: (value) {
                      _currentPage = 1;
                      _query();
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  AuthUtil.isAuthCreateEnabled('2') == true ? ISSearchButton(label: '등록', iconData: Icons.add, onPressed: () => _regist()) : Container(),
                  SizedBox(height: 8),
                  ISSearchButton(label: '조회', iconData: Icons.search, onPressed: () => {_currentPage = 1, _query()}),
                ],
              ),
            ],
          )
        ],
      ),
    );

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //form,
          buttonBar,
          Divider(),
          ISDatatable(
            panelHeight: (MediaQuery.of(context).size.height - defaultContentsHeight)-48,
            listWidth: Responsive.getResponsiveWidth(context, 720), //Responsive.isTablet(context) ? MediaQuery.of(context).size.width : contentListWidth,
            rows: dataList.map((item) {
              return DataRow(cells: [
                DataCell(Center(child: Text(item.uCode.toString() ?? '--', style: TextStyle(color: Colors.black),))),
                DataCell(Align(child: Text(item.id.toString() ?? '--', style: TextStyle(color: Colors.black),), alignment: Alignment.centerLeft)),
                DataCell(Align(child: Text(item.name.toString() ?? '--', style: TextStyle(color: Colors.black),), alignment: Alignment.centerLeft)),
                DataCell(
                  Align(
                      child: ButtonBar(
                        children: <Widget>[
                          Text(_getCcName(item.ccCode.toString()) ?? '--', style: TextStyle(color: Colors.black)),
                        ],
                        alignment: MainAxisAlignment.start,
                      ),
                      alignment: Alignment.centerLeft),
                ),
                DataCell(Align(                        child: Text(item.memo.toString() ?? '--',                         style: TextStyle(color: Colors.black)),                       alignment: Alignment.centerLeft)),
                DataCell(Center(
                    child: ButtonBar(
                      children: <Widget>[
                        Text(_getLevel(item.level.toString()) ?? '--', style: TextStyle(color: Colors.black)),
                      ],
                      alignment: MainAxisAlignment.center,
                    )),
                ),
                DataCell(
                  Center(
                      child: ButtonBar(
                        children: <Widget>[
                          Text(_getWorking(item.working.toString()) ?? '--', style: TextStyle(color: Colors.black)),
                        ],
                        alignment: MainAxisAlignment.center,
                      )),
                ),
                DataCell(
                  Center(
                    child: InkWell(
                        onTap: () {
                          _edit(uCode: item.uCode);
                        },
                        child: Icon(Icons.edit)
                    ),
                  ),
                ),
                DataCell(
                  Center(
                      child: Container(
                        //color: Colors.red,
                        child: IconButton(
                          //padding: EdgeInsets.only(top: 20),
                          onPressed: () {
                            _History(item.uCode);
                          },
                          icon: Icon(Icons.history, color: Colors.blue, size: 20,),
                          tooltip: '변경 이력',
                        ),
                      )),
                ),
              ]);
            }).toList(),
            columns: <DataColumn>[
              DataColumn(label: Expanded(child: Text('사용자코드', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('아이디', textAlign: TextAlign.left)),),
              DataColumn(label: Expanded(child: Text('이름', textAlign: TextAlign.left)),),
              DataColumn(label: Expanded(child: Text('콜센터', textAlign: TextAlign.left)),),
              DataColumn(label: Expanded(child: Text('메모', textAlign: TextAlign.left)),),
              DataColumn(label: Expanded(child: Text('접속권한', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('업무상태', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('관리', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('변경이력', textAlign: TextAlign.center)),),
            ],
          ),
          Divider(),
          showPagerBar(),
          //Align(child: Text(_SerchCount.toString() + ' 건 조회', style: TextStyle(fontWeight: FontWeight.bold)), alignment: Alignment.bottomRight)
        ],
      ),
    );
  }

  Container showPagerBar() {
    return Container(
      //padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Row(
              children: <Widget>[
                //Text('row1'),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                    onTap: () {
                      _currentPage = 1;

                      _pageMove(_currentPage);
                    },
                    child: Icon(Icons.first_page)),
                InkWell(
                    onTap: () {
                      if (_currentPage == 1) return;

                      _pageMove(_currentPage--);
                    },
                    child: Icon(Icons.chevron_left)),
                Container(
                  //width: 70,
                  child: Text(_currentPage.toInt().toString() + ' / ' + _totalPages.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ),
                InkWell(
                    onTap: () {
                      if (_currentPage >= _totalPages) return;

                      _pageMove(_currentPage++);
                    },
                    child: Icon(Icons.chevron_right)),
                InkWell(
                    onTap: () {
                      _currentPage = _totalPages;
                      _pageMove(_currentPage);
                    },
                    child: Icon(Icons.last_page))
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Responsive.isMobile(context) ? Container(height: 48) : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                //Text('조회 데이터 : ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),),
                //Text(UserController.to.totalRowCnt.toString() + ' / ' + UserController.to.total_count.toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                //SizedBox(width: 20,),
                Text('페이지당 행 수', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),),
                Container(
                  width: 70,
                  child: DropdownButton(
                      value: _selectedpagerows,
                      isExpanded: true,
                      style: TextStyle(fontSize: 12, color: Colors.black, fontFamily: 'NotoSansKR'),
                      items: Utils.getPageRowList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedpagerows = value;
                          _currentPage = 1;
                          _query();
                        });
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getLevel(String value) {
    String retValue = '--';

    if (value.toString().compareTo('0') == 0)           retValue = '시스템';
    else if (value.toString().compareTo('1') == 0)      retValue = '관리자';
    else if (value.toString().compareTo('3') == 0)      retValue = '접수자';
    else if (value.toString().compareTo('5') == 0)      retValue = '영업사원';
    else if (value.toString().compareTo('6') == 0)      retValue = '오퍼레이터';

    return retValue;
  }

  String _getWorking(String value) {
    String retValue = '--';

    if (value.toString().compareTo('1') == 0)
      retValue = '재직';
    else if (value.toString().compareTo('3') == 0)
      retValue = '휴직';
    else if (value.toString().compareTo('5') == 0) retValue = '퇴직';

    return retValue;
  }

  String _getCcName(String value) {
    String retValue = '--';

    CCenterListitems.forEach((v) {
      if (value == v['ccCode']) {
        retValue = v['ccName'];
      }
    });

    return retValue;
  }
}
