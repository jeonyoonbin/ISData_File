
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_date.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Model/shop/shop_modificationRegNoModel.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/constants/constant.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModificationRegNoList extends StatefulWidget {
  @override
  _ModificationRegNoListState createState() => _ModificationRegNoListState();
}


class _ModificationRegNoListState extends State<ModificationRegNoList> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<ShopModificationRegNoModel> dataList = <ShopModificationRegNoModel>[];

  SearchItems _searchItems = new SearchItems();

  // 페이징에 필요한 변수
  //int rowsPerPage = 10;

  int _totalRowCnt = 0;
  int _selectedpagerows = 15;

  int _currentPage = 1;
  int _totalPages = 0;

  void _pageMove(int _page) {
    _query();
  }

  _reset() {
    dataList.clear();

    _searchItems = null;
    _searchItems = new SearchItems();

    _searchItems.startdate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', '01']);
    _searchItems.enddate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);

    //formKey.currentState.reset();
    //loadData();
  }

  _query() {
    ShopController.to.fromDate.value = _searchItems.startdate.replaceAll('-', '');
    ShopController.to.toDate.value = _searchItems.enddate.replaceAll('-', '');
    ShopController.to.page.value = _currentPage.round().toString();
    ShopController.to.raw.value = _selectedpagerows.toString();

    loadData();
    // loadMCodeListData();
  }

  loadData() async {
    await ISProgressDialog(context).show(status: 'Loading...');

    dataList.clear();

    await ShopController.to.getModificationRegNoData().then((value) {
      if (this.mounted) {
        if (value == null) {
          ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
        }
        else{
          setState(() {
            dataList.clear();

            value.forEach((e) {
              ShopModificationRegNoModel temp = ShopModificationRegNoModel.fromJson(e);
              // 변경일 날짜와 시간 사이에 생기는 T 공백으로 처리해주기.
              if (temp.hist_date != null)
                temp.hist_date = temp.hist_date.replaceAll('T', '  ');

              dataList.add(temp);
            });

            _totalRowCnt = ShopController.to.totalModiDataCnt;
            _totalPages = (_totalRowCnt / _selectedpagerows).ceil();
          });
        }
      }
    });

    await ISProgressDialog(context).dismiss();
  }

  @override
  void initState() {
    super.initState();

    Get.put(ShopController());

    WidgetsBinding.instance.addPostFrameCallback((c) {
      _reset();
      _query();
    });

    setState(() {
      _searchItems.startdate = formatDate(DateTime.now(), ['1900', '-', mm, '-', '01']);
      _searchItems.enddate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    });
  }

  @override
  void dispose() {
    if(dataList != null) {
      dataList.clear();
      dataList = null;
    }

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
              Text('총: ${Utils.getCashComma(ShopController.to.totalModiDataCnt.toString())}건', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
            ],
          ),
          Row(
            children: [
              ISSearchSelectDate(
                context,
                label: '시작일',
                width: 120,
                value: _searchItems.startdate.toString(),
                onTap: () async {
                  DateTime valueDt = isBlank
                      ? DateTime.now()
                      : DateTime.parse(_searchItems.startdate);
                  final DateTime picked = await showDatePicker(
                    context: context,
                    initialDate: valueDt,
                    firstDate: DateTime(1900, 1),
                    lastDate: DateTime(2031, 12),
                  );

                  setState(() {
                    if (picked != null) {
                      _searchItems.startdate =
                          formatDate(picked, [yyyy, '-', mm, '-', dd]);
                    }
                  });
                },
              ),
              ISSearchSelectDate(
                context,
                label: '종료일',
                width: 120,
                value: _searchItems.enddate.toString(),
                onTap: () async {
                  DateTime valueDt = isBlank
                      ? DateTime.now()
                      : DateTime.parse(_searchItems.enddate);
                  final DateTime picked = await showDatePicker(
                    context: context,
                    initialDate: valueDt,
                    firstDate: DateTime(1900, 1),
                    lastDate: DateTime(2031, 12),
                  );

                  setState(() {
                    if (picked != null) {
                      _searchItems.enddate =
                          formatDate(picked, [yyyy, '-', mm, '-', dd]);
                    }
                  });
                },
              ),
              SizedBox(width: 8),
              ISSearchButton(
                  label: '조회',
                  iconData: Icons.search,
                  onPressed: () => {_currentPage = 1, _query()}),
            ],
          )
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
            panelHeight: (MediaQuery.of(context).size.height-defaultContentsHeight),
            listWidth: Responsive.getResponsiveWidth(context, 640),
            rows: dataList.map((item) {
              return DataRow(cells: [
                DataCell(Align(child: SelectableText(item.seqno.toString(), style: TextStyle(color: Colors.black),showCursor: true), alignment: Alignment.center)),
                // DataCell(Align(child: Text(item.shop_cd.toString(), style: TextStyle(color: Colors.black),), alignment: Alignment.center)),
                // DataCell(Align(child: Text(item.shop_name.toString(), style: TextStyle(color: Colors.black),), alignment: Alignment.center)),
                DataCell(Align(child: SelectableText(item.shop_name.toString() == null ? '--' : '['+ item.shop_cd.toString() +'] '+item.shop_name.toString(), style: TextStyle(color: Colors.black, fontSize: 13),showCursor: true), alignment: Alignment.centerLeft)),
                DataCell(Align(child: SelectableText(Utils.getNameAbsoluteFormat(item.owner.toString(), true), style: TextStyle(color: Colors.black),), alignment: Alignment.center)),
                DataCell(Center(child: SelectableText(Utils.getPhoneNumFormat(item.telno.toString(), true) ?? '--', style: TextStyle(color: Colors.black),showCursor: true,))),
                DataCell(Align(child: SelectableText(item.regno_hist.toString(), style: TextStyle(color: Colors.black),showCursor: true), alignment: Alignment.center)),
                DataCell(Align(child: SelectableText(item.hist_date.toString(), style: TextStyle(color: Colors.black),showCursor: true), alignment: Alignment.center)),
              ]);
            }).toList(),
            columns: <DataColumn>[
              DataColumn(label: Expanded(child: Text('순번', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('가맹점', textAlign: TextAlign.left)),),
              //DataColumn(label: Expanded(child: Text('가맹점명', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('대표자', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('연락처', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('변경내용', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('변경일자', textAlign: TextAlign.center)),
              ),
            ],
          ),
          Divider(),
          SizedBox(height: 0,),
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
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontFamily: 'NotoSansKR'),
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
