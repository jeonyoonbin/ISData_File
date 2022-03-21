import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/constants/constant.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_input.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Model/shopAccountModel.dart';
import 'package:daeguro_admin_app/View/AgentManager/agentAccount_Controller.dart';
import 'package:daeguro_admin_app/View/ShopManager/ImageManager/shopImagePre.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopImageList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ShopImageListState();
  }
}

class ShopImageListState extends State {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final List<ShopAccountModel> dataList = <ShopAccountModel>[];
  List MCodeListitems = List();

  String _State = '1';

  SearchItems _searchItems = new SearchItems();

  //int rowsPerPage = 10;

  int _totalRowCnt = 0;
  int _selectedpagerows = 15;

  int _currentPage = 1;
  int _totalPages = 0;

  String _mCode = '2';

  void _pageMove(int _page) {
    _query();
  }

  _query() {
    //formKey.currentState.save();
    loadData();
  }

  loadMCodeListData() async {
    //MCodeListitems.clear();

    //await AgentController.to.getDataMCodeItems();
    //MCodeListitems = AgentController.to.qDataMCodeItems;
    MCodeListitems = Utils.getMCodeList();

    setState(() {});
  }

  loadData() async {
    // print('call loadData() ');

    dataList.clear();

    await ShopController.to.getData(_mCode, _searchItems.code, '', _State, '','','','','','', '', _currentPage.round().toString(), _selectedpagerows.toString()).then((value) {
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

  _editImagePre(String ccCode, String shopCode) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: ShopImagePre(
          ccCode: ccCode,
          shopCode: shopCode,
        ),
      ),
    ).then((v) async {
      await Future.delayed(Duration(milliseconds: 500), () {
        loadData();
      });
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Text('총: ${Utils.getCashComma(ShopController.to.totalRowCnt.toString())}건', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
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
                                child: new Text(
                                  item['mName'],
                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                ),
                                value: item['mCode']);
                          }).toList(),
                        ),
                        ISSearchDropdown(
                          label: '상태',
                          width: 90,
                          value: _State,
                          onChange: (value) {
                            setState(() {
                              _State = value;
                              _currentPage = 1;
                              _query();
                            });
                          },
                          item: [
                            DropdownMenuItem(value: ' ', child: Text('전체')),
                            DropdownMenuItem(value: '0', child: Text('대기')),
                            DropdownMenuItem(value: '1', child: Text('요청')),
                            DropdownMenuItem(value: '2', child: Text('배정')),
                            DropdownMenuItem(value: '3', child: Text('완료')),
                            DropdownMenuItem(value: '4', child: Text('승인')),
                          ].cast<DropdownMenuItem<String>>(),
                        ),
                      ],
                    ),
                    SizedBox(height: 8,),
                    Row(
                      children: [
                        ISSearchInput(
                          label: '가맹점명, 대표자명',
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
                        ISSearchButton(
                            label: '조회',
                            iconData: Icons.search,
                            onPressed: () => {_currentPage = 1, _query()}),
                      ],
                    ),
                  ],
                )
              ],
            ),
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
            panelHeight: (MediaQuery.of(context).size.height-defaultContentsHeight)-48,
            listWidth: Responsive.getResponsiveWidth(context, 480),  // Responsive.isTablet(context) ? MediaQuery.of(context).size.width : contentListWidth,
            rows: dataList.map((item) {
              return DataRow(cells: [
                DataCell(Center(child: Text(item.shopCd.toString() ?? '--', style: TextStyle(color: Colors.black)))),
                DataCell(Align(child: Text(item.shopName.toString() ?? '--', style: TextStyle(color: Colors.black)), alignment: Alignment.centerLeft,)),
                DataCell(
                  Row(
                    children: <Widget>[
                      Text(_getStatus(item.imageStatus.toString()) ?? '--', style: TextStyle(color: Colors.black)),
                      Visibility(
                        child: IconButton(
                          onPressed: () async {
                            ShopController.to.putImageStatus(item.shopCd, '4', context);
                            await Future.delayed(Duration(milliseconds: 300), () {
                              loadData();
                            });
                          },
                          icon: Icon(Icons.post_add),
                          tooltip: '승인',
                        ),
                        visible: item.imageStatus.toString() == '3'
                            ? true
                            : false,
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                  //Text(_getStatus(item.status.toString()) ?? '--'))
                ),
                DataCell(
                  Center(
                    child: InkWell(
                        onTap: () {
                          _editImagePre(item.ccCode, item.shopCd);
                        },
                        child: Icon(Icons.file_download)
                    ),
                  ),
                ),
                // DataCell(Center(child: ButtonBar(alignment: MainAxisAlignment.center, children: <Widget>[
                //   IconButton(icon: Icon(Icons.file_download),
                //     onPressed: () {
                //       _editImageInfo(shopCode: item.shopCd);
                //     },
                //   ),],)),
                // ),
              ]);
            }).toList(),
            columns: <DataColumn>[
              DataColumn(label: Expanded(child: Text('가맹점번호', textAlign: TextAlign.center))),
              DataColumn(label: Expanded(child: Text('가맹점명', textAlign: TextAlign.left))),
              DataColumn(label: Expanded(child: Text('상태명', textAlign: TextAlign.center))),
              DataColumn(label: Expanded(child: Text('첨부이미지', textAlign: TextAlign.center))),
              //DataColumn(label: Expanded(child: Text('첨부이미지', textAlign: TextAlign.center)),),
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

  Future<void> _launchInBrowser(String shopCode) async {
    //ucode, name
    String uCode = GetStorage().read('logininfo')['uCode'];
    String uID = GetStorage().read('logininfo')['id'];

    String url = ServerInfo.OWNERSITE_URL + '/$shopCode/$uCode/$uID/Store';
    // print('launch web : ' + url);

    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false, //true로 설정시, iOS 인앱 브라우저를 통해 오픈
        forceWebView: false, //true로 설정시, Android 인앱 브라우저를 통해 오픈
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Web Request Fail $url';
    }
  }

  String _getStatus(String value) {
    String retValue = '--';

    if (value.toString() == '0')
      retValue = '대기';
    else if (value.toString() == '1')
      retValue = '요청';
    else if (value.toString() == '2')
      retValue = '배정';
    else if (value.toString() == '3')
      retValue = '완료';
    else if (value.toString() == '4')
      retValue = '승인';
    else
      retValue = '--';

    return retValue;
  }
}
