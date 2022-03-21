import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_input.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Model/shopAccountModel.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/AgentManager/agentAccount_Controller.dart';
import 'package:daeguro_admin_app/View/MappingManager/mapping_controller.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class SearchShopList extends StatefulWidget {
  final double popWidth;
  final double popHeight;

  const SearchShopList({Key key, this.popWidth, this.popHeight})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SearchShopListState();
  }
}

class SearchShopListState extends State<SearchShopList> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  SearchItems _searchItems = new SearchItems();

  final List<ShopAccountModel> dataList = <ShopAccountModel>[];
  List MCodeListitems = List();

  List<String> _ret = List<String>(3);

  //int rowsPerPage = 10;

  int _totalRowCnt = 0;
  int _selectedpagerows = 15;

  int _currentPage = 1;
  int _totalPages = 0;

  String _mCode = '2';

  void _pageMove(int _page) {
    _query();
  }

  _reset() {
    _searchItems = null;
    _searchItems = new SearchItems();

    //formKey.currentState.reset();
    //loadData();
  }

  _query() {
    //formKey.currentState.save();

    loadData();
  }

  loadMCodeListData() async {
    //MCodeListitems.clear();

    //await AgentController.to.getDataMCodeItems();
    MCodeListitems = Utils.getMCodeList();

    if (this.mounted) {
      setState(() {
        //MCodeListitems = AgentController.to.qDataMCodeItems;
      });
    }
  }

  loadData() async {
    dataList.clear();

    await ShopController.to.getData(_mCode, _searchItems.code, '', '', '','','','','','','', _currentPage.toString(), _selectedpagerows.toString(),).then((value) {
      if (this.mounted) {
        if (value == null) {
          ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
        }
        else{
          setState(() {
            dataList.clear();

            value.forEach((e) {
              ShopAccountModel temp = ShopAccountModel.fromJson(e);
              dataList.add(temp);
            });

            _totalRowCnt = ShopController.to.totalRowCnt;
            _totalPages = (_totalRowCnt / _selectedpagerows).ceil();
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();

    Get.put(AgentController());
    Get.put(ShopController());

    WidgetsBinding.instance.addPostFrameCallback((c) {
      loadMCodeListData();
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
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
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
                  child: new Text(item['mName'], style: TextStyle(fontSize: 13, color: Colors.black),), value: item['mCode']);
            }).toList(),
          ),
          ISSearchInput(
            label: '가맹점명, 대표자명',
            width: 180,
            value: _searchItems.code,
            onChange: (v) {
              _searchItems.code = v;
            },
            onFieldSubmitted: (value) {
              _currentPage = 1;
              _query();
            },
          ),
          ISSearchButton(
              label: '조회',
              iconData: Icons.search,
              onPressed: () => {_currentPage = 1, _query()}),
          // SizedBox(
          //   width: 8,
          // ),
          // ISSearchButton(
          //     label: '닫기',
          //     iconData: Icons.close,
          //     onPressed: () =>
          //     {_currentPage = 1, Navigator.pop(context, true)}),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('POS 업체 연동 조회'),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
        //padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            form,
            buttonBar,
            Divider(),
            ISDatatable(
              panelHeight: widget.popHeight-210,
              listWidth: widget.popWidth-40,
              rows: dataList.map((item) {
                return DataRow(
                  // onSelectChanged: (bool value){
                  //   print('onSelect -> '+item.shopName);
                  //   showModalBottomSheet(
                  //       context: context,
                  //       builder: (context){
                  //         return showDetailSheet(item.ccCode, item.shopCd);
                  //       }
                  //   );
                  // },
                    cells: [
                      DataCell(Align(child: SelectableText('[${item.shopCd.toString() ?? '--'}] '+ item.shopName.toString() ?? '--', style: TextStyle(color: Colors.black), showCursor: true,), alignment: Alignment.centerLeft,)),
                      DataCell(
                        Center(
                            child: ButtonBar(
                              children: <Widget>[
                                IconButton(
                                  onPressed: () async {
                                    await MappingController.to.getCheckApiMap(item.shopCd);

                                    if(MappingController.to.checkCount == '0')
                                    {
                                      _ret[0] = item.shopCd.toString();
                                      _ret[1] = item.shopName.toString();
                                      _ret[2] = item.ccCode.toString();

                                      Navigator.pop(context, _ret);
                                    }
                                    else
                                    {
                                      ISAlert(context, '이미 연결 된 업체 정보가 있습니다.');
                                    }
                                  },
                                  icon: Icon(Icons.check),
                                  tooltip: '선택',
                                )
                              ],
                              alignment: MainAxisAlignment.center,
                            )),
                      ),
                    ]);
              }).toList(),
              columns: <DataColumn>[
                DataColumn(label: Expanded(child: Text('가맹점명', textAlign: TextAlign.center)),),
                DataColumn(label: Expanded(child: Text('선택', textAlign: TextAlign.center)),),
              ],
            ),
            Divider(),
            SizedBox(
              height: 20,
            ),
            showPagerBar(),
          ],
        ),
      ),
    );
  }

  Container showPagerBar() {
    return Container(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Row(
        children: <Widget>[
          Expanded(
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
        ],
      ),
    );
  }
}
