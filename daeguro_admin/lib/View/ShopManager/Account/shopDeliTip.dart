import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/Model/shop/shop_delitip.dart';
import 'package:daeguro_admin_app/Model/shop/shop_delitipHistory.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/Util/multi_masked_formatter.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopDeliTipEdit.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopDeliTipLocalEdit.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopDetailNotifierData.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/Util/utils.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class ShopDeliTip extends StatefulWidget {
  final Stream<ShopDetailNotifierData> stream;
  final double height;

  const ShopDeliTip({Key key, this.stream, this.height}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShopDeliTipState();
  }
}



class ShopDeliTipState extends State<ShopDeliTip> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<ShopDeliTipModel> dataTimeDeliTipList = <ShopDeliTipModel>[];
  List<ShopDeliTipModel> dataCostDeliTipList = <ShopDeliTipModel>[];
  List<ShopDeliTipModel> dataLocalDeliTipList = <ShopDeliTipModel>[];

  List<ShopDeliTipHistoryModel> deliTipHistoryList = <ShopDeliTipHistoryModel>[];

  TabController _nestedTabController;
  ScrollController _scrollController;
  int current_tabIdx = 0;

  ShopDetailNotifierData detailData;

  bool isReceiveDataEnabled = false;



  void refreshWidget(ShopDetailNotifierData element){
    detailData = element;
    if (detailData != null) {
      //print('shopDeliTip refreshWidget() is not NULL -> [${element.selected_shopCode}]');

      dataTimeDeliTipList.clear();
      dataCostDeliTipList.clear();
      dataLocalDeliTipList.clear();
      deliTipHistoryList.clear();

      _query();

      isReceiveDataEnabled = true;

      setState(() {
        _nestedTabController.index = 0;
        _scrollController.jumpTo(0.0);
      });
    }
    else{
      //print('shopDeliTip refreshWidget() is NULL');

      dataTimeDeliTipList.clear();
      dataCostDeliTipList.clear();
      dataLocalDeliTipList.clear();
      deliTipHistoryList.clear();

      isReceiveDataEnabled = false;

      setState(() {
        _nestedTabController.index = 0;
        _scrollController.jumpTo(0.0);
      });
    }
  }

  _query() async {
    //print('call deliTip query()');

    //loadDelitipDaeguroData();

    loadTimeDeliTipData();
    loadCostDeliTipData();
    loadLocalDeliTipData();
    loadDeliTipHistoryData();
  }

  loadDeliTipHistoryData() async {
    deliTipHistoryList.clear();

    await ShopController.to.getDeliTipHistoryData(detailData.selected_shopCode, '1', '10000').then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        value.forEach((element) {
          ShopDeliTipHistoryModel hisData = ShopDeliTipHistoryModel.fromJson(element);
          if (hisData.modTime != null) hisData.modTime = hisData.modTime.replaceAll('T', '  ');
          deliTipHistoryList.add(hisData);
        });
      }
    });

    setState(() {

    });
  }

  loadTimeDeliTipData() async {
    dataTimeDeliTipList.clear();

    String tipGbn = '7';

    await ShopController.to.getDeliTipData(detailData.selected_shopCode, tipGbn);

    setState(() {
      ShopController.to.qDataDeliTipTimeList.forEach((element) {
        ShopDeliTipModel tempData = ShopDeliTipModel.fromJson(element);
        tempData.tipGbn = tipGbn;
        dataTimeDeliTipList.add(tempData);
      });
    });
  }

  loadCostDeliTipData() async {
    //await EasyLoading.show();

    dataCostDeliTipList.clear();

    String tipGbn = '3';

    await ShopController.to.getDeliTipData(detailData.selected_shopCode, tipGbn);

    setState(() {
      ShopController.to.qDataDeliTipCostList.forEach((element) {
        ShopDeliTipModel tempData = ShopDeliTipModel.fromJson(element);
        tempData.tipGbn = tipGbn;
        dataCostDeliTipList.add(tempData);
      });
    });
  }

  loadLocalDeliTipData() async {
    //await EasyLoading.show();

    dataLocalDeliTipList.clear();

    String tipGbn = '9';

    await ShopController.to.getDeliTipData(detailData.selected_shopCode, tipGbn);

    setState(() {
      ShopController.to.qDataDeliTipLocalList.forEach((element) {
        ShopDeliTipModel tempData = ShopDeliTipModel.fromJson(element);
        tempData.tipGbn = tipGbn;
        dataLocalDeliTipList.add(tempData);
      });
    });
  }

  _editDeliTip(ShopDeliTipModel item, {String tipGbn}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: ShopDeliTipEdit(
          shopCode: detailData.selected_shopCode,
          tipGbn: tipGbn,
          sData: item,
        ),
      ),
    ).then((v) async {
      await Future.delayed(Duration(milliseconds: 500), () {
        _query();
      });
    });
  }

  _editDeliLocalTip() {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: ShopDeliTipLocalEdit(
          shopCode: detailData.selected_shopCode,
        ),
      ),
    ).then((v) async {
      await Future.delayed(Duration(milliseconds: 500), () {
        _query();
      });
    });
  }

  _deleteDeliTip(String tipSeq) {
    ISConfirm(context, '배달팁 삭제', '배달팁을 삭제합니다. \n\n계속 진행 하시겠습니까?', (context) async {
      await ShopController.to.deleteDeliTipData(tipSeq, context);

      Navigator.of(context).pop();

      await Future.delayed(Duration(milliseconds: 500), () {
        _query();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _nestedTabController = new TabController(length: 2, vsync: this);
    _scrollController = ScrollController();

    dataTimeDeliTipList.clear();
    dataCostDeliTipList.clear();
    dataLocalDeliTipList.clear();
    deliTipHistoryList.clear();



    // WidgetsBinding.instance.addPostFrameCallback((c) {
    //   _query();
    // });

    //if (widget.streamIsInit == false){
      widget.stream.listen((element) {
        refreshWidget(element);
      });
    //}
  }

  @override
  void dispose() {
   _nestedTabController.dispose();
    _scrollController.dispose();

    dataTimeDeliTipList.clear();
    dataCostDeliTipList.clear();
    dataLocalDeliTipList.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var form = Scrollbar(
      isAlwaysShown: false,
      controller: _scrollController,
      child: ListView(
        controller: _scrollController,
        children: [
          Form(
            key: formKey,
            child: Container(
              child: Wrap(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(),
                          // Container(
                          //     child: Text('배달도 대구로 사용', style: TextStyle(fontSize: 12, color: Colors.black),),
                          //     margin: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 10)//.all(5),
                          // ),
                          // Radio(value: RadioGbn.gbn1, groupValue: _radioGbn,
                          //     onChanged: (v) async {
                          //       setState(() {
                          //         _radioGbn = v;
                          //       });
                          //
                          //       //await ShopController.to.postSectorGeofenceData(detailData.selected_shopCode, 'N', context);
                          //
                          //     }),
                          // Text('미사용', style: TextStyle(fontSize: 12)),
                          // Container(
                          //   margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          //   child: Radio(value: RadioGbn.gbn2, groupValue: _radioGbn,
                          //       onChanged: (v) async {
                          //         setState(() {
                          //           _radioGbn = v;
                          //         });
                          //
                          //
                          //         //await ShopController.to.postSectorGeofenceData(detailData.selected_shopCode, 'Y', context);
                          //       }),
                          // ),
                          // Text('사용', style: TextStyle(fontSize: 12)),
                          // SizedBox(width: 5,),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 16),
                        child: ISButton(
                          iconData: Icons.refresh,
                          iconColor: Colors.white,
                          tip: '갱신',
                          onPressed: (){
                            if (isReceiveDataEnabled == true){
                              _query();

                              setState(() {
                                _nestedTabController.index = 0;
                                _scrollController.jumpTo(0.0);
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  /*_radioGbn == RadioGbn.gbn1 ?*/ Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        Divider(height: 20,),
                        getTitleBarSet('7', '주문 시간대별 배달팁'),
                        TimeDeliTipTable(),
                        Divider(height: 2),
                        getTitleBarSet('3', '주문 금액별 배달팁'),
                        CostDeliTipTable(),
                        Divider(height: 2),
                        getTitleBarSet('9', '지역별 배달팁'),
                        LocalDeliTipTable(),
                        //Divider(height: 2),
                      ],
                    ),
                  )// : getDelTipDaeguro()
                ],
              ),
            ),
          )
        ],
      ),
    );

    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
              child: Container(
                height: 30.0,
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200, width: 2.0), borderRadius: BorderRadius.circular(5), color: Colors.grey.shade200,),
                child: TabBar(
                  controller: _nestedTabController,
                  labelStyle: TextStyle(fontSize: 12, fontFamily: 'NotoSansKR'),
                  unselectedLabelColor: Colors.black45,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BubbleTabIndicator(
                    indicatorRadius: 5.0,
                    indicatorHeight: 25.0,
                    indicatorColor: Colors.blue,
                    tabBarIndicatorSize: TabBarIndicatorSize.tab,
                  ),
                  tabs: [
                    Tab(text: '배달팁정보',),
                    Tab(text: '변경이력',)
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: widget.height,
              child: TabBarView(
                controller: _nestedTabController,
                children: [form, getHistoryDelTip()],
              ),
            )
          ]
        )
    );
  }

  Widget getTitleBarSet(String type, String titleStr) {
    bool addBtnEnabled = true;
    if (AuthUtil.isAuthCreateEnabled('99') == true)           addBtnEnabled = true;
    else                                                      addBtnEnabled = false;


    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
          Container(
            //padding: const EdgeInsets.only(left: 10),
            child: Text(
              titleStr,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),

          addBtnEnabled == true ? Container(
          //padding: const EdgeInsets.only(right: 4),
          child: IconButton(
            icon: Icon(
              Icons.add_box,
              color: Colors.blue,
              size: 30,
            ),
            onPressed: () {
              if (type == '9')
                _editDeliLocalTip();
              else
                _editDeliTip(null, tipGbn: type);
            },

          ),
          // ISButton(
          //     label: '추가', iconData: Icons.add,
          //     //onPressed: () => _edit(null)
          // ),
        ) : Container(height: 40),
      ],
    );
  }

  Widget TimeDeliTipTable() {
    return ListView(
      controller: ScrollController(),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 14),
      children: <Widget>[
        DataTable(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black26, offset: Offset(2.0, 2.0), blurRadius: 4.0),
            ],
          ),
          headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blue[50]),
          headingTextStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', color: Colors.black54, fontSize: 12),
          headingRowHeight: 30,
          dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white),
          dataTextStyle: TextStyle(fontWeight: FontWeight.normal, fontFamily: 'NotoSansKR', fontSize: 12),
          columnSpacing: 0,
          columns: <DataColumn>[
            DataColumn(label: Expanded(child: Text('요일', textAlign: TextAlign.center)),),
            DataColumn(label: Expanded(child: Text('시간구간', textAlign: TextAlign.center)),),
            DataColumn(label: Expanded(child: Text('배달팁', textAlign: TextAlign.center)),),
            if (AuthUtil.isAuthEditEnabled('99') == true || AuthUtil.isAuthDeleteEnabled('99') == true)
            DataColumn(label: Expanded(child: Text('관리', textAlign: TextAlign.center)),),
          ],
          //source: listDS,
          rows: dataTimeDeliTipList.map((item) {
            return DataRow(cells: [
              DataCell(Center(child: Text(Utils.getDay(item.tipDay) ?? '--', style: TextStyle(color: Colors.black),))),
              DataCell(Center(child: Text(Utils.getTimeFormat(item.tipFromStand) + ' ~ ' + Utils.getTimeFormat(item.tipToStand) ?? '--', style: TextStyle(color: Colors.black)))),
              DataCell(Center(child: Text(Utils.getCashComma(item.tipAmt) + '원' ?? '--', style: TextStyle(color: Colors.black)))),
              if (AuthUtil.isAuthEditEnabled('99') == true || AuthUtil.isAuthDeleteEnabled('99') == true)
              DataCell(ButtonBar(
                children: <Widget>[
                  if (AuthUtil.isAuthEditEnabled('99') == true)
                  IconButton(
                    onPressed: () {
                      _editDeliTip(item);
                    },
                    icon: Icon(Icons.edit),
                    tooltip: '수정',
                  ),
                  if (AuthUtil.isAuthDeleteEnabled('99') == true)
                  IconButton(
                    onPressed: () {
                      _deleteDeliTip(item.tipSeq);
                    },
                    icon: Icon(Icons.delete),
                    tooltip: '삭제',
                  ),
                ],
                alignment: MainAxisAlignment.center,
              )),
            ]);
          }).toList(),
        ),
      ],
    );
  }

  Widget CostDeliTipTable() {
    return ListView(
      controller: ScrollController(),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 14),
      children: <Widget>[
        DataTable(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black26, offset: Offset(2.0, 2.0), blurRadius: 4.0),
            ],
          ),
          headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blue[50]),
          headingTextStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', color: Colors.black54, fontSize: 12),
          headingRowHeight: 30,
          dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white),
          dataTextStyle: TextStyle(fontWeight: FontWeight.normal, fontFamily: 'NotoSansKR', fontSize: 12),
          columnSpacing: 0,
          columns: <DataColumn>[
            DataColumn(label: Expanded(child: Text('금액', textAlign: TextAlign.center)),),
            DataColumn(label: Expanded(child: Text('배달팁', textAlign: TextAlign.center)),),
            if (AuthUtil.isAuthEditEnabled('99') == true || AuthUtil.isAuthDeleteEnabled('99') == true)
            DataColumn(label: Expanded(child: Text('관리', textAlign: TextAlign.center)),),
          ],
          //source: listDS,
          rows: dataCostDeliTipList.map((item) {
            return DataRow(cells: [
              DataCell(Center(child: Text(Utils.getCashComma(item.tipFromStand) + '원' ?? '--', style: TextStyle(color: Colors.black)))),
              DataCell(Center(child: Text(item.tipAmt == '0' ? '무료' : Utils.getCashComma(item.tipAmt) + '원', style: TextStyle(color: Colors.black)))),
              if (AuthUtil.isAuthEditEnabled('99') == true || AuthUtil.isAuthDeleteEnabled('99') == true)
              DataCell(ButtonBar(
                children: <Widget>[
                  if (AuthUtil.isAuthEditEnabled('99') == true)
                  IconButton(
                    onPressed: () {
                      _editDeliTip(item);
                    },
                    icon: Icon(Icons.edit),
                    tooltip: '수정',
                  ),
                  if (AuthUtil.isAuthDeleteEnabled('99') == true)
                  IconButton(
                    onPressed: () {
                      _deleteDeliTip(item.tipSeq);
                    },
                    icon: Icon(Icons.delete),
                    tooltip: '삭제',
                  ),
                ],
                alignment: MainAxisAlignment.center,
              )),
            ]);
          }).toList(),
        ),
      ],
    );
  }

  Widget LocalDeliTipTable() {
    return ListView(
      controller: ScrollController(),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 14),
      children: <Widget>[
        DataTable(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black26, offset: Offset(2.0, 2.0), blurRadius: 4.0),
            ],
          ),
          headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blue[50]),
          headingTextStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', color: Colors.black54, fontSize: 12),
          headingRowHeight: 30,
          dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white),
          dataTextStyle: TextStyle(fontWeight: FontWeight.normal, fontFamily: 'NotoSansKR', fontSize: 12),
          columnSpacing: 0,
          columns: <DataColumn>[
            DataColumn(label: Expanded(child: Text('지역', textAlign: TextAlign.center)),),
            DataColumn(label: Expanded(child: Text('배달팁', textAlign: TextAlign.center)),),
            if (AuthUtil.isAuthEditEnabled('99') == true || AuthUtil.isAuthDeleteEnabled('99') == true)
            DataColumn(label: Expanded(child: Text('관리', textAlign: TextAlign.center)),),
          ],
          //source: listDS,
          rows: dataLocalDeliTipList.map((item) {
            return DataRow(cells: [
              DataCell(Center(child: Text(item.tipFromStand ?? '--', style: TextStyle(color: Colors.black)))),
              DataCell(Center(child: Text(Utils.getCashComma(item.tipAmt) + '원' ?? '--', style: TextStyle(color: Colors.black)))),
              if (AuthUtil.isAuthEditEnabled('99') == true || AuthUtil.isAuthDeleteEnabled('99') == true)
              DataCell(ButtonBar(
                children: <Widget>[
                  if (AuthUtil.isAuthEditEnabled('99') == true)
                  IconButton(
                    onPressed: () {
                      _editDeliTip(item);
                    },
                    icon: Icon(Icons.edit),
                    tooltip: '수정',
                  ),
                  if (AuthUtil.isAuthDeleteEnabled('99') == true)
                  IconButton(
                    onPressed: () {
                      _deleteDeliTip(item.tipSeq);
                    },
                    icon: Icon(Icons.delete),
                    tooltip: '삭제',
                  ),
                ],
                alignment: MainAxisAlignment.center,
              )),
            ]);
          }).toList(),
        ),
      ],
    );
  }



  Widget getHistoryDelTip() {
    return ListView.builder(
      controller: ScrollController(),
      padding: EdgeInsets.all(8.0),
      itemCount: deliTipHistoryList.length,
      itemBuilder: (BuildContext context, int index) {
        return deliTipHistoryList != null
            ? GestureDetector(
                // onTap: (){
                //   Navigator.pushNamed(context, '/editor', arguments: UserController.to.userData[index]);
                // },
                child: Card(
                  color: Colors.white,
                  elevation: 2.0,
                  child: ListTile(
                    //leading: Text(dataList[index].siguName),
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Text('No.' + deliTipHistoryList[index].no.toString() ?? '--', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Container(
                            padding: EdgeInsets.only(top: 5),
                            child: SelectableText(
                              deliTipHistoryList[index].modDesc.toString() ?? '--',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              showCursor: true,
                            )),
                      ],
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(alignment: Alignment.centerRight, child: Text(deliTipHistoryList[index].modTime.toString() ?? '--', style: TextStyle(fontSize: 12), textAlign: TextAlign.right))
                      ],
                    ),
                  ),
                ),
              )
            : Text('Data is Empty');
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
