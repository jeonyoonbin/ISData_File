import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_input.dart';
import 'package:daeguro_admin_app/Model/mappingDModel.dart';
import 'package:daeguro_admin_app/Model/mappingListModel.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/MappingManager/mappingEdit.dart';
import 'package:daeguro_admin_app/View/MappingManager/mappingRegist.dart';
import 'package:daeguro_admin_app/View/MappingManager/mapping_controller.dart';
import 'package:daeguro_admin_app/constants/constant.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

List items = List();

class MappingList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MappingListState();
  }
}

final List<MappingListModel> dataList = <MappingListModel>[];

class MappingListState extends State {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  SearchItems _searchItems = new SearchItems();

  //int rowsPerPage = 10;

  int _totalRowCnt = 0;
  int _selectedpagerows = 15;

  int _currentPage = 1;
  int _totalPages = 0;

  String _useGbn = ' ';
  String _apiType = ' ';

  void _pageMove(int _page) {
    _query();
  }

  _reset() {
    formKey.currentState.reset();
    //loadData();
  }

  _query() {
    formKey.currentState.save();

    MappingController.to.page.value = _currentPage.round().toString();
    MappingController.to.raw.value = _selectedpagerows.toString();;
    loadData();
  }

  _regist() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: MappingRegist(),
      ),
    ).then((v) async {
      if (v != null) {
        dataList.clear();

        await MappingController.to.getData(_useGbn, _apiType, _searchItems.code).then((value) {
          if (value == null) {
            ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
          }
          else {
            value.forEach((e) {
              MappingListModel temp = MappingListModel.fromJson(e);
              dataList.add(temp);
            });

            _totalPages = 1;
            _totalRowCnt = MappingController.to.totalRowCnt;
            _totalPages = (_totalRowCnt / _selectedpagerows).ceil();
          }
        });

        setState(() {});
      }
    });
  }

  _edit({String seq}) async {
    MappingDModel editData = null;

    await MappingController.to.getDetailData(seq.toString()).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        editData = MappingDModel.fromJson(value);
      }
    });

    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: MappingEdit(
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

  loadData() async {
    dataList.clear();

    await MappingController.to.getData(_useGbn, _apiType, _searchItems.code).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        value.forEach((e) {
          MappingListModel temp = MappingListModel.fromJson(e);
          dataList.add(temp);
        });

        _totalRowCnt = MappingController.to.totalRowCnt;
        _totalPages = (_totalRowCnt / _selectedpagerows).ceil();
      }
    });

    //print(_searchItems.code);

    //if (this.mounted) {
      setState(() {

      });
    //}
  }

  @override
  void initState() {
    super.initState();

    Get.put(MappingController());

    WidgetsBinding.instance.addPostFrameCallback((c) {
      _reset();
      _query();
    });
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
        children: [
          Row(
            children: [
              Text('총: ${Utils.getCashComma(MappingController.to.totalRowCnt.toString())}건', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      ISSearchDropdown(
                        label: '사용구분',
                        width: 120,
                        value: _useGbn,
                        onChange: (value) {
                          setState(() {
                            _useGbn = value;
                            _query();
                          });
                        },
                        item: [
                          DropdownMenuItem(value: ' ', child: Text('전체'),),
                          DropdownMenuItem(value: 'Y', child: Text('사용'),),
                          DropdownMenuItem(value: 'N', child: Text('미사용'),),
                        ].cast<DropdownMenuItem<String>>(),
                      ),
                      ISSearchDropdown(
                        label: '업체타입',
                        width: 112,
                        value: _apiType,
                        onChange: (value) {
                          setState(() {
                            _apiType = value;
                            _query();
                          });
                        },
                        item: [
                          DropdownMenuItem(value: ' ', child: Text('전체'),),
                          DropdownMenuItem(value: '1', child: Text('주문'),),
                          DropdownMenuItem(value: '3', child: Text('POS(배달)'),),
                        ].cast<DropdownMenuItem<String>>(),
                      ),
                      SizedBox(width: 8,)
                    ],
                  ),
                  SizedBox(height: 8,),
                  ISSearchInput(
                    label: '가맹점명',
                    width: 240,
                    value: _searchItems.code,
                    onChange: (v) {
                      _searchItems.code = v;
                    },
                    onFieldSubmitted: (value) {
                      _query();
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  if (AuthUtil.isAuthCreateEnabled('40') == true)
                  ISSearchButton(
                      width: 104,
                      label: '매핑추가',
                      iconData: Icons.add,
                      onPressed: () => _regist()),
                  SizedBox(height: 8,),
                  ISSearchButton(
                      width: 104,
                      label: '조회',
                      iconData: Icons.search,
                      onPressed: () => {_currentPage = 1, _query()}),
                ],
              ),
            ],
          ),
        ],
      ),
    );

    return Container(
      //padding: EdgeInsets.only(left: 140, right: 140, bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          form,
          buttonBar,
          Divider(),
          ISDatatable(
            panelHeight: (MediaQuery.of(context).size.height-defaultContentsHeight)-48,
            listWidth: Responsive.getResponsiveWidth(context, 480),  // Responsive.isTablet(context) ? MediaQuery.of(context).size.width : contentListWidth,
            rows: dataList.map((item) {
              return DataRow(cells: [
                DataCell(Center(child: Text(item.shopMapSeq.toString() ?? '--', style: TextStyle(color: Colors.black),))),
                DataCell(Align(child: Text(item.shopName.toString() ?? '--', style: TextStyle(color: Colors.black),),alignment: Alignment.centerLeft)),
                DataCell(Align(child: Text(item.companyName.toString() ?? '--', style: TextStyle(color: Colors.black),),alignment: Alignment.centerLeft)),
                DataCell(
                  Center(
                    child: InkWell(
                        onTap: () {
                          _edit(seq: item.shopMapSeq);
                        },
                        child: Icon(Icons.edit)
                    ),
                  ),
                ),
              ]);
            }).toList(),
            columns: <DataColumn>[
              DataColumn(label: Expanded(child: Text('순번', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('가맹점명', textAlign: TextAlign.left)),),
              DataColumn(label: Expanded(child: Text('업체명', textAlign: TextAlign.left)),),
              DataColumn(label: Expanded(child: Text('관리', textAlign: TextAlign.center)),),
            ],
          ),
          Divider(),
          SizedBox(
            height: 0,
          ),
          showPagerBar(),
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
                Text('페이지당 행 수 : ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),),
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
}
