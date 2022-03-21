import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/Model/user/userAuthManagerListModel.dart';
import 'package:daeguro_admin_app/Model/user/userListModel.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/AuthManager/AuthMenuEdit.dart';
import 'package:daeguro_admin_app/View/AuthManager/AuthMenuRegist.dart';
import 'package:daeguro_admin_app/View/AuthManager/AuthSidebarMenuSort.dart';
import 'package:daeguro_admin_app/View/AuthManager/auth_controller.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/constants/constant.dart';

import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_input.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';

import 'package:daeguro_admin_app/View/AgentManager/agentAccount_Controller.dart';
import 'package:daeguro_admin_app/View/UserManager/user_controller.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'dart:async';

class AuthManagerList extends StatefulWidget {
  const AuthManagerList({Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AuthManagerListState();
  }
}

class AuthManagerListState extends State<AuthManagerList>  with SingleTickerProviderStateMixin{
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  SearchItems _searchItems = new SearchItems();

  final ScrollController _scrollController = ScrollController();

  final List<UserListModel> dataList = <UserListModel>[];

  final List<UserAuthManagerListModel> dataAuthList = <UserAuthManagerListModel>[];

  List items = List();
  List CCenterListitems = List();
  List MCodeListitems = List();

  List<SelectOptionVO> selectBox_piditem = [];
  List<SelectOptionVO> selectBox_sideBarEnabled = [];

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

  String _selectedUcode = '';
  String _selectedComment = '';

  bool isCheckAll_read = false;
  bool isCheckAll_add = false;
  bool isCheckAll_save = false;
  bool isCheckAll_del = false;
  bool isCheckAll_masking = false;

  bool menuAdminEnable = false;

  String _sidebarPID = '4';
  String _sidebarEnabled = '*';

  void _pageMove(int _page) {
    _query();
  }

  _reset() {
    dataList.clear();

    _searchItems = null;
    _searchItems = new SearchItems();

    menuAdminEnable = (GetStorage().read('logininfo')['uCode'] == '48' //이성훈
                    || GetStorage().read('logininfo')['uCode'] == '35' //전윤빈
                      ) ? true : false;

    _selectedComment = '사용자를 선택해주세요.';

    selectBox_sideBarEnabled.add(new SelectOptionVO(value: '*', label: '전체'));
    selectBox_sideBarEnabled.add(new SelectOptionVO(value: 'Y', label: 'Y'));
    selectBox_sideBarEnabled.add(new SelectOptionVO(value: 'N', label: 'N'));


    //GetStorage().read('logininfo')['level'] == '0' ? true : false;

    //formKey.currentState.reset();
    //loadData();
  }

  _query() {

    UserController.to.level.value = _level;
    UserController.to.working.value = _working;
    UserController.to.id_name.value = _searchItems.code;
    UserController.to.memo.value = _searchItems.memo;
    UserController.to.page.value = _currentPage.round().toString();
    UserController.to.raw.value = _selectedpagerows.toString();

    loadParentMenu();
    loadUserData();
  }

  loadUserData() async {
    dataList.clear();
    _SerchCount = 0;

    await UserController.to.getData(context, _mCode).then((value) {
      if(value == null){
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        value.forEach((e) {
          _SerchCount++;
          UserListModel temp = UserListModel.fromJson(e);
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
      else{
        CCenterListitems = value;//AgentController.to.qDataCCenterItems;
      }
    });

    MCodeListitems = Utils.getMCodeList();

    _scrollController.jumpTo(0.0);

    //if (this.mounted) {
      setState(() {

      });
    //}
  }

  loadAuthData(String ucode) async {
    dataAuthList.clear();

    _selectedUcode = ucode;

    _selectedComment = '조회중';

    String paramPid = '';
    String paramSidebarYn = '';
    if (_sidebarPID == '*')
      paramPid = '';
    else if (_sidebarPID == '#') {
      paramPid = '';
      paramSidebarYn = 'Y';
    }
    else
      paramPid = _sidebarPID;

    await AuthController.to.getAuthData(ucode, paramPid, paramSidebarYn).then((value) {
      if(value == null){
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        if (value.length != 0){
          UserAuthManagerListModel temp = UserAuthManagerListModel();
          temp.defaultItem = true;
          dataAuthList.add(temp);

          value.forEach((element) {
            if(_sidebarEnabled == '*' || _sidebarEnabled == element['SIDEBAR_YN']){
              UserAuthManagerListModel temp = UserAuthManagerListModel();//UserAuthManagerListModel.fromJson(element);
              temp.defaultItem = false;

              temp.ID = element['ID'];
              temp.NAME = element['NAME'];
              temp.SIDEBAR_YN = element['SIDEBAR_YN'];
              temp.READ_YN = element['READ_YN'];
              temp.UPDATE_YN = element['UPDATE_YN'];
              temp.CREATE_YN = element['CREATE_YN'];
              temp.DELETE_YN = element['DELETE_YN'];
              temp.DOWNLOAD_YN = element['DOWNLOAD_YN'];

              dataAuthList.add(temp);
            }
          });

          refreshDefaultItem('Y', 0);
          refreshDefaultItem('Y', 1);
          refreshDefaultItem('Y', 2);
          refreshDefaultItem('Y', 3);
          refreshDefaultItem('Y', 4);
        }
        else{
          _selectedComment = '하위메뉴가 없습니다.';
        }
      }
    });

    setState(() {

    });
  }

  loadParentMenu() async {
    await ISProgressDialog(context).show(status: 'Loading...');

    selectBox_piditem.clear();

    //PIDListitems.add(new SelectOptionVO(value: '', label: '전체'));
    
    await AuthController.to.getMenuData('', '0').then((value) {
      if(value == null){
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else{
        selectBox_piditem.add(new SelectOptionVO(value: '*', label: '전체보기'));
        selectBox_piditem.add(new SelectOptionVO(value: '#', label: '사이드바 메뉴'));
        value.forEach((element) {
          selectBox_piditem.add(new SelectOptionVO(value: element['ID'].toString(), label: '[${element['ID'].toString()}] ${element['NAME'].toString()}'));
        });
      }
    });

    setState(() {});

    await ISProgressDialog(context).dismiss();
  }

  _regist() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: AuthMenuRegist(),
      ),
    ).then((v) async {
      if (v != null) {
        await Future.delayed(Duration(milliseconds: 500), () {
          loadParentMenu();
          loadAuthData(_selectedUcode);
        });
      }
    });
  }

  _edit(String id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: AuthMenuEdit(id: id,),
      ),
    ).then((v) async {
      if (v != null) {
        await Future.delayed(Duration(milliseconds: 500), () {
          print('loadAuthData refresh');
          loadParentMenu();
          loadAuthData(_selectedUcode);
        });
      }
    });
  }

  _sort() {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: AuthSidebarMenuSort(),
      ),
    ).then((v) async {
      if (v != null) {
        await Future.delayed(Duration(milliseconds: 500), () {
          loadAuthData(_selectedUcode);
        });
      }
    });
  }


  @override
  void initState() {
    super.initState();

    Get.put(UserController());
    Get.put(AgentController());
    Get.put(AuthController());

    WidgetsBinding.instance.addPostFrameCallback((c) {
      _reset();
      _query();
    });
  }

  @override
  void dispose() {
    dataList.clear();
    //MCodeListitems.clear();

    _scrollController.dispose();

    super.dispose();
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            children: [
              menuAdminEnable == true ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    //width: item.defaultItem == true ?  70 : 46,
                    child: ISButton(
                      height: 24.0,
                      label: '사이드바 메뉴 순서',
                      textStyle: TextStyle(color: Colors.white, fontSize: 11),
                      onPressed: () async {
                        _sort();
                      },
                    ),
                  ),
                  SizedBox(width: 8,),
                  Container(
                    //width: item.defaultItem == true ?  70 : 46,
                    child: ISButton(
                      height: 24.0,
                      label: 'PG 추가',
                      textStyle: TextStyle(color: Colors.white, fontSize: 11),
                      onPressed: () async {
                        _regist();
                      },
                    ),
                  )
                ],
              ) : Container(),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    width: 200,
                    item: MCodeListitems.map((item) {
                      return new DropdownMenuItem<String>(
                          child: new Text(
                            item['mName'],
                            style: TextStyle(fontSize: 13, color: Colors.black),
                          ),
                          value: item['mCode']);
                    }).toList(),
                  ),
                  SizedBox(height: 8,),
                  ISSearchInput(
                    label: '아이디, 이름',
                    width: 208,
                    value: _searchItems.code,
                    onChange: (v) {
                      _searchItems.code = v;
                    },
                    onFieldSubmitted: (value) {
                      _currentPage = 1;
                      _query();
                    },
                  ),

                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ISSearchDropdown(
                        label: '접속권한',
                        width: 120,
                        value: _level,
                        padding: EdgeInsets.all(0),
                        onChange: (value) {
                          setState(() {
                            _level = value;
                            _currentPage = 1;
                            formKey.currentState.save();
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
                      SizedBox(width: 8,),
                      ISSearchDropdown(
                        label: '업무상태',
                        width: 92,
                        value: _working,
                        padding: EdgeInsets.all(0),
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
                  ),
                  SizedBox(height: 8,),
                  ISSearchButton(
                      label: '조회',
                      iconData: Icons.search,
                      width: 220,
                      onPressed: () => {_currentPage = 1, _query()}),
                ],
              ),

            ],
          )
        ],
      ),
    );

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          form,
          buttonBar,
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: getListMainPanelWidth(),
                height: (MediaQuery.of(context).size.height-190),
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: Colors.black26, offset: Offset(2.0, 2.0), blurRadius: 4.0),
                  ],
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    ISDatatable(
                      controller: _scrollController,
                      panelHeight: (MediaQuery.of(context).size.height-255),
                      listWidth: 900,
                      dataRowHeight: 30,
                      //showCheckboxColumn: (widget.shopName == null) ? true : false,
                      rows: dataList.map((item) {
                        return DataRow(
                            selected: item.selected ?? false,
                            color: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
                              if (item.selected == true) {
                                return Colors.grey.shade200;
                                //return Theme.of(context).colorScheme.primary.withOpacity(0.38);
                              }

                              return Theme.of(context).colorScheme.primary.withOpacity(0.00);
                            }),
                            onSelectChanged: (bool value){
                              // _selectedViewSeq = item.shopCd;
                              //
                              // nSelectedShopTitle = '[${item.shopCd}] ${item.shopName}';
                              //

                              dataList.forEach((element) {
                                element.selected = false;
                              });

                              item.selected = true;

                              _scrollController.jumpTo(0.0);

                              loadAuthData(item.uCode);

                              setState(() {
                              });
                            },
                            cells: [
                              //DataCell(Center(child: Text(item.uCode.toString() ?? '--', style: TextStyle(color: Colors.black, fontSize: 12),))),
                              //DataCell(Align(child: Text(item.id.toString() ?? '--', style: TextStyle(color: Colors.black),), alignment: Alignment.centerLeft)),
                              DataCell(Align(child: Text('[${item.uCode.toString()}] ${item.name.toString()}' ?? '--', style: TextStyle(color: Colors.black, fontSize: 12),), alignment: Alignment.centerLeft)),
                              DataCell(Align(child: Text(_getCcName(item.ccCode.toString()) ?? '--', style: TextStyle(color: Colors.black, fontSize: 12)), alignment: Alignment.centerLeft),),
                              DataCell(Center(child: Text(_getLevel(item.level.toString()) ?? '--', style: TextStyle(color: Colors.black, fontSize: 12)),),),
                              DataCell(Center(child: Text(_getWorking(item.working.toString()) ?? '--', style: TextStyle(color: Colors.black, fontSize: 12)),),),
                              DataCell(Align(child: Text(item.memo.toString() ?? '--', style: TextStyle(color: Colors.black, fontSize: 12)), alignment: Alignment.centerLeft)),
                              // DataCell(
                              //   Center(
                              //     child: InkWell(
                              //         onTap: () {
                              //           //_edit(uCode: item.uCode);
                              //         },
                              //         child: Icon(Icons.edit)
                              //     ),
                              //   ),
                              // ),

                            ]);
                      }).toList(),
                      columns: <DataColumn>[
                        //DataColumn(label: Expanded(child: Text('사용자코드', textAlign: TextAlign.center)),),
                        //DataColumn(label: Expanded(child: Text('아이디', textAlign: TextAlign.left)),),
                        DataColumn(label: Expanded(child: Text('사용자', textAlign: TextAlign.center)),),
                        DataColumn(label: Expanded(child: Text('콜센터', textAlign: TextAlign.left)),),
                        DataColumn(label: Expanded(child: Text('접속권한', textAlign: TextAlign.center)),),
                        DataColumn(label: Expanded(child: Text('업무상태', textAlign: TextAlign.center)),),
                        DataColumn(label: Expanded(child: Text('메모', textAlign: TextAlign.left)),),
                        //DataColumn(label: Expanded(child: Text('관리', textAlign: TextAlign.center)),),
                      ],
                    ),
                    showPagerBar(),
                  ],
                ),
              ),
              //Divider(height: 1000,),
              getDetailData(),
            ],
          ),
        ],
      ),
    );
  }

  Widget getDetailData(){
    return Container(
      width: 700,
      height: (MediaQuery.of(context).size.height-190),
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black26, offset: Offset(2.0, 2.0), blurRadius: 4.0),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                  flex: 2,
                  child: ISSelect(
                    label: '사이드바 유무',
                    value: _sidebarEnabled,
                    dataList: selectBox_sideBarEnabled,
                    onChange: (v) {
                      setState(() {
                        _sidebarEnabled = v;
                        loadAuthData(_selectedUcode);
                      });
                    },
                  )
              ),
              Flexible(
                  flex: 3,
                  child: ISSelect(
                    label: '사이드바 메뉴명',
                    value: _sidebarPID,
                    dataList: selectBox_piditem,
                    onChange: (v) {
                      setState(() {
                        _sidebarPID = v;
                        loadAuthData(_selectedUcode);
                      });
                    },
                  )
              )
            ],
          ),
          dataAuthList.isEmpty == true
              ? Container(
                height: MediaQuery.of(context).size.height - 300,
                alignment: Alignment.center,
                child: Text(_selectedComment, style: TextStyle(color: Colors.black45),),
              )
              : ISDatatable(
                  panelHeight: (MediaQuery.of(context).size.height-262),
                  listWidth: 680,//Responsive.getResponsiveWidth(context, 640),

                  dataRowHeight: 30,
                  rows: dataAuthList.map((item) {
                    return DataRow(
                        cells: [
                          DataCell(Align(child: Text(item.defaultItem == true ? '' : '[${item.ID.toString()}] ${item.NAME.toString()}', style: TextStyle(color: Colors.black, fontSize: 12)), alignment: Alignment.centerLeft)),
                          //DataCell(Align(child: Text(item.NAME.toString() ?? '--', style: TextStyle(color: Colors.black, fontSize: 12),), alignment: Alignment.centerLeft)),
                          DataCell(Center(child: Text(item.SIDEBAR_YN.toString() ?? '--', style: TextStyle(color: Colors.black, fontSize: 12),))),
                          DataCell(Center(
                              child: Checkbox(
                                  checkColor: Colors.white,
                                  activeColor: item.defaultItem == true ? Colors.blue : Colors.black54,
                                  value: item.READ_YN == 'Y' ? true : false,
                                  onChanged: (value) {
                                    if (item.defaultItem == true){
                                      dataAuthList.forEach((element) {
                                        element.READ_YN = (value == true ? 'Y' : 'N');
                                      });
                                    }
                                    else {
                                      item.READ_YN == 'N' ? item.READ_YN = 'Y' : item.READ_YN = 'N';

                                      refreshDefaultItem(item.READ_YN, 0);
                                    }

                                    setState(() {});
                                  }
                              )
                          )
                          ),
                          DataCell(Center(
                              child: Checkbox(
                                  checkColor: Colors.white,
                                  activeColor: item.defaultItem == true ? Colors.blue : Colors.black54,
                                  value: item.CREATE_YN == 'Y' ? true : false,
                                  onChanged: (value) {
                                    if (item.defaultItem == true){
                                      dataAuthList.forEach((element) {
                                        element.CREATE_YN = (value == true ? 'Y' : 'N');
                                      });
                                    }
                                    else {
                                      item.CREATE_YN == 'N' ? item.CREATE_YN = 'Y' : item.CREATE_YN = 'N';

                                      refreshDefaultItem(item.CREATE_YN, 1);
                                    }

                                    setState(() {});
                                  }
                              )
                          )
                          ),
                          DataCell(Center(
                              child: Checkbox(
                                  checkColor: Colors.white,
                                  activeColor: item.defaultItem == true ? Colors.blue : Colors.black54,
                                  value: item.UPDATE_YN == 'Y' ? true : false,//item.auth_save,//this.checkAll,
                                  onChanged: (value) {
                                    if (item.defaultItem == true){
                                      dataAuthList.forEach((element) {
                                        element.UPDATE_YN = (value == true ? 'Y' : 'N');
                                      });
                                    }
                                    else {
                                      item.UPDATE_YN == 'N' ? item.UPDATE_YN = 'Y' : item.UPDATE_YN = 'N';

                                      refreshDefaultItem(item.UPDATE_YN, 2);
                                    }

                                    setState(() {});
                                  }
                              )
                          )
                          ),
                          DataCell(Center(
                              child: Checkbox(
                                  checkColor: Colors.white,
                                  activeColor: item.defaultItem == true ? Colors.blue : Colors.black54,
                                  value: item.DELETE_YN == 'Y' ? true : false,
                                  onChanged: (value) {
                                    if (item.defaultItem == true){
                                      dataAuthList.forEach((element) {
                                        element.DELETE_YN = (value == true ? 'Y' : 'N');
                                      });
                                    }
                                    else {
                                      item.DELETE_YN == 'N' ? item.DELETE_YN = 'Y' : item.DELETE_YN = 'N';

                                      refreshDefaultItem(item.DELETE_YN, 3);
                                    }

                                    setState(() {});
                                  }
                              )
                          )
                          ),
                          DataCell(Center(
                              child: Checkbox(
                                  checkColor: Colors.white,
                                  activeColor: item.defaultItem == true ? Colors.blue : Colors.black54,
                                  value: item.DOWNLOAD_YN == 'Y' ? true : false,
                                  onChanged: (value) {
                                    if (item.defaultItem == true){
                                      dataAuthList.forEach((element) {
                                        element.DOWNLOAD_YN = (value == true ? 'Y' : 'N');
                                      });
                                    }
                                    else {
                                      item.DOWNLOAD_YN == 'N' ? item.DOWNLOAD_YN = 'Y' : item.DOWNLOAD_YN = 'N';

                                      refreshDefaultItem(item.DOWNLOAD_YN, 4);
                                    }

                                    setState(() {});
                                  }
                              )
                          )
                          ),
                          DataCell(Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                (item.defaultItem == false && menuAdminEnable == true) ? Container(
                                  width: 72,
                                  padding: EdgeInsets.only(right: 4),
                                  child: ISButton(
                                    height: 24.0,
                                    label: '일괄 반영',
                                    textStyle: TextStyle(color: Colors.white, fontSize: 11),
                                    onPressed: () async {
                                      ISConfirm(context, '일괄반영', '모든 사용자에 대해 일괄 반영 하시겠습니까?', (context) async {
                                        await ISProgressDialog(context).show(status: '업데이트중...');

                                        AuthController.to.putAllAuthData(item.ID.toString(),  '', item.READ_YN, item.UPDATE_YN, item.CREATE_YN, item.DELETE_YN, item.DOWNLOAD_YN).then((value) async {
                                          if (value != null){
                                            ISAlert(context, '정상처리가 되지 않았습니다. \n\n${value}');
                                          }
                                          else{
                                            Navigator.pop(context);

                                            setState(() {

                                            });

                                            await ISProgressDialog(context).dismiss();
                                          }
                                        });
                                      });
                                    },
                                  ),
                                ) : Container(),
                                (item.defaultItem == false && menuAdminEnable == true) ? Container(
                                  width: 52,
                                  padding: EdgeInsets.only(right: 4),
                                  child: ISButton(
                                    height: 24.0,
                                    label: '수정',
                                    textStyle: TextStyle(color: Colors.white, fontSize: 11),
                                    onPressed: () async {
                                      print('edit id:${item.ID.toString()}');
                                      _edit(item.ID.toString());
                                    },
                                  ),
                                ) : Container(),
                                Container(
                                  width: item.defaultItem == true ?  70 : 46,
                                  child: ISButton(
                                    height: 24.0,
                                    label: item.defaultItem == true ?  '일괄 저장' : '저장',
                                    textStyle: TextStyle(color: Colors.white, fontSize: 11),
                                    onPressed: () async {

                                      await ISProgressDialog(context).show(status: '업데이트중...');

                                      if (item.defaultItem == true){
                                        dataAuthList.forEach((element) async {
                                          if (element.ID != null){
                                            AuthController.to.putAuthData(element.ID.toString(), _selectedUcode, element.READ_YN, element.UPDATE_YN, element.CREATE_YN, element.DELETE_YN, element.DOWNLOAD_YN).then((value) async {
                                              if (value != null){
                                                ISAlert(context, '정상처리가 되지 않았습니다. \n\n${value}');
                                              }
                                            });
                                            await Future.delayed(Duration(milliseconds: 500), () {
                                            });
                                          }
                                        });


                                        await Future.delayed(Duration(milliseconds: 500), () async {
                                          await ISProgressDialog(context).dismiss();
                                        });
                                      }
                                      else{
                                        AuthController.to.putAuthData(item.ID.toString(), _selectedUcode, item.READ_YN, item.UPDATE_YN, item.CREATE_YN, item.DELETE_YN, item.DOWNLOAD_YN).then((value) async {
                                          if (value != null){
                                            ISAlert(context, '정상처리가 되지 않았습니다. \n\n${value}');
                                          }
                                          else{
                                            // await Future.delayed(Duration(milliseconds: 500), () {
                                            //   loadAuthData(_selectedUcode);
                                            // });
                                            setState(() {

                                            });

                                            await ISProgressDialog(context).dismiss();
                                          }
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )),

                        ]);
                  }).toList(),
                  columns: <DataColumn>[
                    //DataColumn(label: Expanded(child: Text('PG ID', textAlign: TextAlign.center)),),
                    DataColumn(label: Expanded(child: Text('프로그램정보', textAlign: TextAlign.center)),),
                    DataColumn(label: Expanded(child: Text('사이드바\n메뉴', style: TextStyle(fontSize: 12), textAlign: TextAlign.center)),),
                    DataColumn(label: Expanded(child: Text('조회', textAlign: TextAlign.center)),),
                    DataColumn(label: Expanded(child: Text('추가', textAlign: TextAlign.center)),),
                    DataColumn(label: Expanded(child: Text('수정', textAlign: TextAlign.center)),),
                    DataColumn(label: Expanded(child: Text('삭제', textAlign: TextAlign.center)),),
                    DataColumn(label: Expanded(child: Text('다운로드', textAlign: TextAlign.center)),),
                    DataColumn(label: Expanded(child: Container(                      ))
                    ),
                  ],
                )
        ],
      ),
    );
  }

  Widget showPagerBar() {
    return Expanded(
        flex: 0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(),
                      // Visibility(
                      //   visible: false,
                      //   child: Text(
                      //     '[Excel 다운로드 중입니다. 잠시만 기다려 주십시오]',
                      //     style: TextStyle(color: Colors.blue),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Container(
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
                Container(
                  height: 48,
                  child: Responsive.isMobile(context) ? Container(height: 48) :  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      // Text('조회 데이터 : ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),),
                      // Text(ShopController.to.totalRowCnt.toString() + ' / ' + ShopController.to.total_count.toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                      // SizedBox(width: 20,),
                      Text('페이지당 행 수 : ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
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
              ]
          ),
        )
    );
  }

  //type -> 0:read, 1:update, 2:create, 3:delete, 4:download
  refreshDefaultItem(String value, int type){
    int count = 0;

    for (final element in dataAuthList){
      if (type == 0){
        if (element.READ_YN == value)          count++;
      }
      else if (type == 1){
        if (element.CREATE_YN == value)        count++;
      }
      else if (type == 2){
        if (element.UPDATE_YN == value)        count++;
      }
      else if (type == 3){
        if (element.DELETE_YN == value)        count++;
      }
      else if (type == 4){
        if (element.DOWNLOAD_YN == value)      count++;
      }
    }
    if (type == 0)          count == (dataAuthList.length-1) ? dataAuthList[0].READ_YN = 'Y' : dataAuthList[0].READ_YN = 'N';
    else if (type == 1)     count == (dataAuthList.length-1) ? dataAuthList[0].CREATE_YN = 'Y' : dataAuthList[0].CREATE_YN = 'N';
    else if (type == 2)     count == (dataAuthList.length-1) ? dataAuthList[0].UPDATE_YN = 'Y' : dataAuthList[0].UPDATE_YN = 'N';
    else if (type == 3)     count == (dataAuthList.length-1) ? dataAuthList[0].DELETE_YN = 'Y' : dataAuthList[0].DELETE_YN = 'N';
    else if (type == 4)     count == (dataAuthList.length-1) ? dataAuthList[0].DOWNLOAD_YN = 'Y' : dataAuthList[0].DOWNLOAD_YN = 'N';
  }

  double getListMainPanelWidth(){
    double nWidth = MediaQuery.of(context).size.width-1000;

    if (Responsive.isTablet(context) == true)           nWidth = nWidth + sidebarWidth;
    else if (Responsive.isMobile(context) == true)      nWidth = MediaQuery.of(context).size.width;

    return nWidth;
  }

  String _getLevel(String value) {
    String retValue = '--';

    if (value.toString().compareTo('0') == 0)
      retValue = '시스템';
    else if (value.toString().compareTo('1') == 0)
      retValue = '관리자';
    else if (value.toString().compareTo('3') == 0)
      retValue = '접수자';
    else if (value.toString().compareTo('5') == 0)
      retValue = '영업사원';
    else if (value.toString().compareTo('6') == 0) retValue = '오퍼레이터';

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


