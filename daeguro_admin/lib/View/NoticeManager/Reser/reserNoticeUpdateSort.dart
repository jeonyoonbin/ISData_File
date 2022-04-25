import 'dart:convert';

import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Model/noticeListModel.dart';
import 'package:daeguro_admin_app/Model/noticeSortListModel.dart';
import 'package:daeguro_admin_app/Model/reserNoticeSortListModel.dart';
import 'package:daeguro_admin_app/Model/shop/shopmenuoptionsetting.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/NoticeManager/Reser/reserNotice_controller.dart';
import 'package:daeguro_admin_app/View/NoticeManager/notice_controller.dart';
import 'package:daeguro_admin_app/View/ShopManager/Menu/shopMenuOptionSettingAdd.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReserNoticeUpdateSort extends StatefulWidget {
  final String shopCode;
  final String menuCode;

  const ReserNoticeUpdateSort({Key key, this.shopCode, this.menuCode}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ReserNoticeUpdateSortState();
  }
}

class ReserNoticeUpdateSortState extends State<ReserNoticeUpdateSort> with SingleTickerProviderStateMixin {
  //final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //final ScrollController _scrollController = ScrollController();
  final List<reserNoticeSortListModel> sortListEvent = <reserNoticeSortListModel>[];
  final List<reserNoticeSortListModel> sortListMainPopup = <reserNoticeSortListModel>[];
  final List<reserNoticeSortListModel> sortListNotice = <reserNoticeSortListModel>[];
  final List<reserNoticeSortListModel> sortListOwnerNotice = <reserNoticeSortListModel>[];
  final List<reserNoticeSortListModel> sortListOwnerEvent = <reserNoticeSortListModel>[];
  final List<reserNoticeSortListModel> sortListOwnerMainPopup = <reserNoticeSortListModel>[];
  final List<reserNoticeSortListModel> sortListMunicipal = <reserNoticeSortListModel>[];

  TabController _nestedTabController;
  int current_tabIdx = 0;

  bool isSaveEnabled = false;

  _query() {
    //print('call _query() menuCode->'+widget.menuCode);
    //formKey.currentState.save();

    loadData();
  }

  loadData() async {
    sortListEvent.clear();
    sortListMainPopup.clear();
    sortListNotice.clear();

    // 이벤트 바인딩
    await ReserNoticeController.to.getNoticeSortList('3', context);

    if (this.mounted) {
      ReserNoticeController.to.qDataSortList.forEach((e) {
        reserNoticeSortListModel temp = reserNoticeSortListModel.fromJson(e);

        temp.frDate = Utils.getYearMonthDayFormat(temp.frDate);
        temp.toDate = Utils.getYearMonthDayFormat(temp.toDate);

        sortListEvent.add(temp);
      });

      if (isSaveEnabled == true) {
        await Future.delayed(Duration(milliseconds: 500), () async {
          List<String> sortDataList = [];
          sortListEvent.forEach((element) {
            sortDataList.add(element.noticeSeq.toString());
          });

          if (sortDataList.length != 0) {
            String jsonData = jsonEncode(sortDataList);
            await ReserNoticeController.to.updateSort(jsonData, context);
          }

          isSaveEnabled = false;
        });
      }

      setState(() {});
    }

    // 메인팝업 조회
    await ReserNoticeController.to.getNoticeSortList('5', context);

    if (this.mounted) {
      ReserNoticeController.to.qDataSortList.forEach((e) {
        reserNoticeSortListModel temp = reserNoticeSortListModel.fromJson(e);

        temp.frDate = Utils.getYearMonthDayFormat(temp.frDate);
        temp.toDate = Utils.getYearMonthDayFormat(temp.toDate);

        sortListMainPopup.add(temp);
      });

      if (isSaveEnabled == true) {
        await Future.delayed(Duration(milliseconds: 500), () async {
          List<String> sortDataList = [];
          sortListMainPopup.forEach((element) {
            sortDataList.add(element.noticeSeq.toString());
          });

          if (sortDataList.length != 0) {
            String jsonData = jsonEncode(sortDataList);
            await ReserNoticeController.to.updateSort(jsonData, context);
          }

          isSaveEnabled = false;
        });
      }

      setState(() {});
    }

    // 공지사항 바인딩
    await ReserNoticeController.to.getNoticeSortList('1', context);

    if (this.mounted) {
      ReserNoticeController.to.qDataSortList.forEach((e) {
        reserNoticeSortListModel temp = reserNoticeSortListModel.fromJson(e);

        temp.frDate = Utils.getYearMonthDayFormat(temp.frDate);
        temp.toDate = Utils.getYearMonthDayFormat(temp.toDate);

        sortListNotice.add(temp);
      });

      if (isSaveEnabled == true) {
        await Future.delayed(Duration(milliseconds: 500), () async {
          List<String> sortDataList = [];
          sortListNotice.forEach((element) {
            sortDataList.add(element.noticeSeq.toString());
          });

          if (sortDataList.length != 0) {
            String jsonData = jsonEncode(sortDataList);
            await ReserNoticeController.to.updateSort(jsonData, context);
          }

          isSaveEnabled = false;
        });
      }

      setState(() {});
    }

    // 사장님공지 바인딩
    await ReserNoticeController.to.getNoticeSortList('2', context);

    if (this.mounted) {
      ReserNoticeController.to.qDataSortList.forEach((e) {
        reserNoticeSortListModel temp = reserNoticeSortListModel.fromJson(e);

        temp.frDate = Utils.getYearMonthDayFormat(temp.frDate);
        temp.toDate = Utils.getYearMonthDayFormat(temp.toDate);

        sortListOwnerNotice.add(temp);
      });

      if (isSaveEnabled == true) {
        await Future.delayed(Duration(milliseconds: 500), () async {
          List<String> sortDataList = [];
          sortListOwnerNotice.forEach((element) {
            sortDataList.add(element.noticeSeq.toString());
          });

          if (sortDataList.length != 0) {
            String jsonData = jsonEncode(sortDataList);
            await ReserNoticeController.to.updateSort(jsonData, context);
          }

          isSaveEnabled = false;
        });
      }

      setState(() {});
    }

    // 사장님 이벤트 바인딩
    await ReserNoticeController.to.getNoticeSortList('4', context);

    if (this.mounted) {
      ReserNoticeController.to.qDataSortList.forEach((e) {
        reserNoticeSortListModel temp = reserNoticeSortListModel.fromJson(e);

        temp.frDate = Utils.getYearMonthDayFormat(temp.frDate);
        temp.toDate = Utils.getYearMonthDayFormat(temp.toDate);

        sortListOwnerEvent .add(temp);
      });

      if (isSaveEnabled == true) {
        await Future.delayed(Duration(milliseconds: 500), () async {
          List<String> sortDataList = [];
          sortListOwnerEvent .forEach((element) {
            sortDataList.add(element.noticeSeq.toString());
          });

          if (sortDataList.length != 0) {
            String jsonData = jsonEncode(sortDataList);
            await ReserNoticeController.to.updateSort(jsonData, context);
          }

          isSaveEnabled = false;
        });
      }

      setState(() {});
    }

    // 사장님 팝업 바인딩
    await ReserNoticeController.to.getNoticeSortList('6', context);

    if (this.mounted) {
      ReserNoticeController.to.qDataSortList.forEach((e) {
        reserNoticeSortListModel temp = reserNoticeSortListModel.fromJson(e);

        temp.frDate = Utils.getYearMonthDayFormat(temp.frDate);
        temp.toDate = Utils.getYearMonthDayFormat(temp.toDate);

        sortListOwnerMainPopup .add(temp);
      });

      if (isSaveEnabled == true) {
        await Future.delayed(Duration(milliseconds: 500), () async {
          List<String> sortDataList = [];
          sortListOwnerMainPopup .forEach((element) {
            sortDataList.add(element.noticeSeq.toString());
          });

          if (sortDataList.length != 0) {
            String jsonData = jsonEncode(sortDataList);
            await ReserNoticeController.to.updateSort(jsonData, context);
          }

          isSaveEnabled = false;
        });
      }

      setState(() {});
    }

    // 시정홍보 바인딩
    await ReserNoticeController.to.getNoticeSortList('7', context);

    if (this.mounted) {
      ReserNoticeController.to.qDataSortList.forEach((e) {
        reserNoticeSortListModel temp = reserNoticeSortListModel.fromJson(e);

        temp.frDate = Utils.getYearMonthDayFormat(temp.frDate);
        temp.toDate = Utils.getYearMonthDayFormat(temp.toDate);

        sortListOwnerMainPopup .add(temp);
      });

      if (isSaveEnabled == true) {
        await Future.delayed(Duration(milliseconds: 500), () async {
          List<String> sortDataList = [];
          sortListOwnerMainPopup .forEach((element) {
            sortDataList.add(element.noticeSeq.toString());
          });

          if (sortDataList.length != 0) {
            String jsonData = jsonEncode(sortDataList);
            await ReserNoticeController.to.updateSort(jsonData, context);
          }

          isSaveEnabled = false;
        });
      }

      setState(() {});
    }
  }

  _editListSort(List<String> sortDataList) async {
    String jsonData = jsonEncode(sortDataList);

    //print(jsonData);

    //print('data set->'+jsonData);
    await ReserNoticeController.to.updateSort(jsonData, context);

    await Future.delayed(Duration(milliseconds: 500), () {
      loadData();
    });
  }

  @override
  void initState() {
    super.initState();

    _nestedTabController = new TabController(length: 7, vsync: this);

    //Get.put(AgentController());

    //formKey.currentState.reset();

    WidgetsBinding.instance.addPostFrameCallback((c) {
      //loadSidoData();
      isSaveEnabled = true;
      _query();
    });
  }

  @override
  Widget build(BuildContext context) {
    // var form = Form(
    //   key: formKey,
    //   child: Wrap(
    //     children: <Widget>[
    //       Container(
    //         padding: EdgeInsets.only(left: 30, right: 30),
    //         child: Text(
    //           '- 게시 상태만 표시 됩니다.',
    //           style: TextStyle(fontSize: 12.0),
    //         ),
    //       ),
    //     ],
    //   ),
    // );

    var form = Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: Text(
        '- 게시 상태만 표시 됩니다.',
        style: TextStyle(fontSize: 12.0),
      ),
    );

    var result = Scaffold(
      appBar: AppBar(
        title: Text('노출 순서 변경'),
      ),
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              //collapsedHeight: 100.0,
              toolbarHeight: 0.0,
              //backgroundColor: Colors.white,
              //centerTitle: true,
              pinned: true,
              floating: true,
              bottom: TabBar(
                controller: _nestedTabController,
                isScrollable: true,
                //labelPadding: EdgeInsets.only(left: 0, right: 0),
                labelStyle: TextStyle(fontSize: 13, fontFamily: 'NotoSansKR'),
                indicatorSize: TabBarIndicatorSize.label,
                physics: NeverScrollableScrollPhysics(),
                // indicatorColor: Colors.blue,
                // labelColor: Colors.blue,
                // unselectedLabelColor: Colors.black54,
                //isScrollable: true,
                //indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(text: '이벤트',),
                  Tab(text: '메인팝업',),
                  Tab(text: '공지사항',),
                  Tab(text: '공지(사장님)',),
                  Tab(text: '이벤트(사장님)',),
                  Tab(text: '메인팝업(사장님)',),
                  Tab(text: '시정홍보',),
                ],
                onTap: (v) {
                  setState(() {
                    current_tabIdx = v;
                    //print('----- current_tabIdx: '+current_tabIdx.toString());
                  });
                },
              ),
            )
          ];
        },
        body: TabBarView(
          controller: _nestedTabController,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                form,
                SizedBox(height: 10),
                Expanded(
                  child: sortListEvent == null
                      ? Text('Data is Empty')
                      : ReorderableListView(
                      onReorder: _onReorder_Event,
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.only(bottom: 8.0),
                      children: List.generate(sortListEvent.length, (index) {
                        return GestureDetector(
                          // onTap: (){
                          //   Navigator.pushNamed(context, '/editor', arguments: UserController.to.userData[index]);
                          // },
                          key: Key('$index'),
                          child: Card(
                            color: Colors.white,
                            elevation: 2.0,
                            child: ListTile(
                              //leading: Text(dataList[index].siguName),
                              title: Row(
                                children: [
                                  Text(
                                    '[' + sortListEvent[index].noticeSeq.toString() + '] ' + sortListEvent[index].title ?? '--',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                  Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      width: 30,
                                      height: 16,
                                      alignment: Alignment.center,
                                      color: Color.fromRGBO(87, 170, 58, 0.8431372549019608),
                                      child: Text(
                                        '게시',
                                        style: TextStyle(fontSize: 8, color: Colors.white),
                                      ))
                                ],
                              ),
                              subtitle: Container(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  children: [
                                    //Text(dataList[index].noticeContents ?? '--', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),),
                                    Text(
                                      sortListEvent[index].frDate + ' ~ ' + sortListEvent[index].frDate ?? '--',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      })),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                form,
                SizedBox(height: 10),
                Expanded(
                  child: sortListMainPopup == null
                      ? Text('Data is Empty')
                      : ReorderableListView(
                      onReorder: _onReorder_MainPopup,
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.only(bottom: 8.0),
                      children: List.generate(sortListMainPopup.length, (index) {
                        return GestureDetector(
                          // onTap: (){
                          //   Navigator.pushNamed(context, '/editor', arguments: UserController.to.userData[index]);
                          // },
                          key: Key('$index'),
                          child: Card(
                            color: Colors.white,
                            elevation: 2.0,
                            child: ListTile(
                              //leading: Text(dataSortListMainPopup[index].siguName),
                              title: Row(
                                children: [
                                  Text(
                                    '[' + sortListMainPopup[index].noticeSeq.toString() + '] ' + sortListMainPopup[index].title ?? '--',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                  Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      width: 30,
                                      height: 16,
                                      alignment: Alignment.center,
                                      color: Color.fromRGBO(87, 170, 58, 0.8431372549019608),
                                      child: Text(
                                        '게시',
                                        style: TextStyle(fontSize: 8, color: Colors.white),
                                      ))
                                ],
                              ),
                              subtitle: Container(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  children: [
                                    //Text(dataSortListMainPopup[index].noticeContents ?? '--', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),),
                                    Text(
                                      sortListMainPopup[index].frDate + ' ~ ' + sortListMainPopup[index].toDate ?? '--',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      })),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                form,
                SizedBox(height: 10),
                Expanded(
                  child: sortListNotice == null
                      ? Text('Data is Empty')
                      : ReorderableListView(
                      onReorder: _onReorder_Notice,
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.only(bottom: 8.0),
                      children: List.generate(sortListNotice.length, (index) {
                        return GestureDetector(
                          // onTap: (){
                          //   Navigator.pushNamed(context, '/editor', arguments: UserController.to.userData[index]);
                          // },
                          key: Key('$index'),
                          child: Card(
                            color: Colors.white,
                            elevation: 2.0,
                            child: ListTile(
                              //leading: Text(dataList3[index].siguName),
                              title: Row(
                                children: [
                                  Text(
                                    '[' + sortListNotice[index].noticeSeq.toString() + '] ' + sortListNotice[index].title ?? '--',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                  Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      width: 30,
                                      height: 16,
                                      alignment: Alignment.center,
                                      color: Color.fromRGBO(87, 170, 58, 0.8431372549019608),
                                      child: Text(
                                        '게시',
                                        style: TextStyle(fontSize: 8, color: Colors.white),
                                      ))
                                ],
                              ),
                              subtitle: Container(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  children: [
                                    //Text(dataList3[index].noticeContents ?? '--', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),),
                                    Text(
                                      sortListNotice[index].frDate + ' ~ ' + sortListNotice[index].toDate ?? '--',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      })),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                form,
                SizedBox(height: 10),
                Expanded(
                  child: sortListOwnerNotice == null
                      ? Text('Data is Empty')
                      : ReorderableListView(
                      onReorder: _onReorder_OwnerNotice,
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.only(bottom: 8.0),
                      children: List.generate(sortListOwnerNotice.length, (index) {
                        return GestureDetector(
                          // onTap: (){
                          //   Navigator.pushNamed(context, '/editor', arguments: UserController.to.userData[index]);
                          // },
                          key: Key('$index'),
                          child: Card(
                            color: Colors.white,
                            elevation: 2.0,
                            child: ListTile(
                              //leading: Text(dataSortListMainPopup[index].siguName),
                              title: Row(
                                children: [
                                  Text(
                                    '[' + sortListOwnerNotice[index].noticeSeq.toString() + '] ' + sortListOwnerNotice[index].title ?? '--',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                  Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      width: 30,
                                      height: 16,
                                      alignment: Alignment.center,
                                      color: Color.fromRGBO(87, 170, 58, 0.8431372549019608),
                                      child: Text(
                                        '게시',
                                        style: TextStyle(fontSize: 8, color: Colors.white),
                                      ))
                                ],
                              ),
                              subtitle: Container(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  children: [
                                    //Text(dataSortListMainPopup[index].noticeContents ?? '--', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),),
                                    Text(
                                      sortListOwnerNotice[index].frDate + ' ~ ' + sortListOwnerNotice[index].toDate ?? '--',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      })),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                form,
                SizedBox(height: 10),
                Expanded(
                  child: sortListOwnerEvent == null
                      ? Text('Data is Empty')
                      : ReorderableListView(
                      onReorder: _onReorder_OwnerEvent,
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.only(bottom: 8.0),
                      children: List.generate(sortListOwnerEvent.length, (index) {
                        return GestureDetector(
                          // onTap: (){
                          //   Navigator.pushNamed(context, '/editor', arguments: UserController.to.userData[index]);
                          // },
                          key: Key('$index'),
                          child: Card(
                            color: Colors.white,
                            elevation: 2.0,
                            child: ListTile(
                              //leading: Text(dataSortListMainPopup[index].siguName),
                              title: Row(
                                children: [
                                  Text(
                                    '[' + sortListOwnerEvent[index].noticeSeq.toString() + '] ' + sortListOwnerEvent[index].title ?? '--',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                  Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      width: 30,
                                      height: 16,
                                      alignment: Alignment.center,
                                      color: Color.fromRGBO(87, 170, 58, 0.8431372549019608),
                                      child: Text(
                                        '게시',
                                        style: TextStyle(fontSize: 8, color: Colors.white),
                                      ))
                                ],
                              ),
                              subtitle: Container(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  children: [
                                    //Text(dataSortListMainPopup[index].noticeContents ?? '--', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),),
                                    Text(
                                      sortListOwnerEvent[index].frDate + ' ~ ' + sortListOwnerEvent[index].toDate ?? '--',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      })),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                form,
                SizedBox(height: 10),
                Expanded(
                  child: sortListOwnerMainPopup == null
                      ? Text('Data is Empty')
                      : ReorderableListView(
                      onReorder: _onReorder_OwnerMainPopup,
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.only(bottom: 8.0),
                      children: List.generate(sortListOwnerMainPopup.length, (index) {
                        return GestureDetector(
                          // onTap: (){
                          //   Navigator.pushNamed(context, '/editor', arguments: UserController.to.userData[index]);
                          // },
                          key: Key('$index'),
                          child: Card(
                            color: Colors.white,
                            elevation: 2.0,
                            child: ListTile(
                              //leading: Text(dataSortListMainPopup[index].siguName),
                              title: Row(
                                children: [
                                  Text(
                                    '[' + sortListOwnerMainPopup[index].noticeSeq.toString() + '] ' + sortListOwnerMainPopup[index].title ?? '--',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                  Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      width: 30,
                                      height: 16,
                                      alignment: Alignment.center,
                                      color: Color.fromRGBO(87, 170, 58, 0.8431372549019608),
                                      child: Text(
                                        '게시',
                                        style: TextStyle(fontSize: 8, color: Colors.white),
                                      ))
                                ],
                              ),
                              subtitle: Container(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  children: [
                                    //Text(dataSortListMainPopup[index].noticeContents ?? '--', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),),
                                    Text(
                                      sortListOwnerMainPopup[index].frDate + ' ~ ' + sortListOwnerMainPopup[index].toDate ?? '--',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      })),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                form,
                SizedBox(height: 10),
                Expanded(
                  child: sortListMunicipal == null
                      ? Text('Data is Empty')
                      : ReorderableListView(
                      onReorder: _onReorder_Municipal,
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.only(bottom: 8.0),
                      children: List.generate(sortListMunicipal.length, (index) {
                        return GestureDetector(
                          // onTap: (){
                          //   Navigator.pushNamed(context, '/editor', arguments: UserController.to.userData[index]);
                          // },
                          key: Key('$index'),
                          child: Card(
                            color: Colors.white,
                            elevation: 2.0,
                            child: ListTile(
                              //leading: Text(dataSortListMainPopup[index].siguName),
                              title: Row(
                                children: [
                                  Text(
                                    '[' + sortListMunicipal[index].noticeSeq.toString() + '] ' + sortListMunicipal[index].title ?? '--',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                  Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      width: 30,
                                      height: 16,
                                      alignment: Alignment.center,
                                      color: Color.fromRGBO(87, 170, 58, 0.8431372549019608),
                                      child: Text(
                                        '게시',
                                        style: TextStyle(fontSize: 8, color: Colors.white),
                                      ))
                                ],
                              ),
                              subtitle: Container(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  children: [
                                    //Text(dataSortListMainPopup[index].noticeContents ?? '--', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),),
                                    Text(
                                      sortListMunicipal[index].frDate + ' ~ ' + sortListMunicipal[index].toDate ?? '--',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      })),
                ),
              ],
            ),
          ],
        ),
      ),

      //bottomNavigationBar: buttonBar,
    );
    return SizedBox(
      width: 420,
      height: 580, //isDisplayDesktop(context) ? 580 : 1000,
      child: result,
    );
  }

  // final List<noticeSortListModel> sortListEvent = <noticeSortListModel>[];
  // final List<noticeSortListModel> sortListOwnerNotice = <noticeSortListModel>[];
  // final List<noticeSortListModel> sortListMainPopup = <noticeSortListModel>[];
  // final List<noticeSortListModel> sortListNotice = <noticeSortListModel>[];

  void _onReorder_Event(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final reserNoticeSortListModel item = sortListEvent.removeAt(oldIndex);
      sortListEvent.insert(newIndex, item);

      List<String> sortDataList = [];
      sortListEvent.forEach((element) {
        sortDataList.add(element.noticeSeq.toString());
      });
      _editListSort(sortDataList);
    });
  }

  void _onReorder_MainPopup(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final reserNoticeSortListModel item = sortListMainPopup.removeAt(oldIndex);
      sortListMainPopup.insert(newIndex, item);

      List<String> sortDataList = [];
      sortListMainPopup.forEach((element) {
        sortDataList.add(element.noticeSeq.toString());
      });
      _editListSort(sortDataList);
    });
  }

  void _onReorder_Notice(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final reserNoticeSortListModel item = sortListNotice.removeAt(oldIndex);
      sortListNotice.insert(newIndex, item);

      List<String> sortDataList = [];
      sortListNotice.forEach((element) {
        sortDataList.add(element.noticeSeq.toString());
      });
      _editListSort(sortDataList);
    });
  }

  void _onReorder_OwnerNotice(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final reserNoticeSortListModel item = sortListOwnerNotice.removeAt(oldIndex);
      sortListOwnerNotice.insert(newIndex, item);

      List<String> sortDataList = [];
      sortListOwnerNotice.forEach((element) {
        sortDataList.add(element.noticeSeq.toString());
      });
      _editListSort(sortDataList);
    });
  }

  void _onReorder_OwnerEvent(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final reserNoticeSortListModel item = sortListOwnerEvent.removeAt(oldIndex);
      sortListOwnerEvent.insert(newIndex, item);

      List<String> sortDataList = [];
      sortListOwnerEvent.forEach((element) {
        sortDataList.add(element.noticeSeq.toString());
      });
      _editListSort(sortDataList);
    });
  }

  void _onReorder_OwnerMainPopup(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final reserNoticeSortListModel item = sortListOwnerMainPopup.removeAt(oldIndex);
      sortListOwnerMainPopup.insert(newIndex, item);

      List<String> sortDataList = [];
      sortListOwnerMainPopup.forEach((element) {
        sortDataList.add(element.noticeSeq.toString());
      });
      _editListSort(sortDataList);
    });
  }

  void _onReorder_Municipal(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final reserNoticeSortListModel item = sortListMunicipal.removeAt(oldIndex);
      sortListMunicipal.insert(newIndex, item);

      List<String> sortDataList = [];
      sortListMunicipal.forEach((element) {
        sortDataList.add(element.noticeSeq.toString());
      });
      _editListSort(sortDataList);
    });
  }
}