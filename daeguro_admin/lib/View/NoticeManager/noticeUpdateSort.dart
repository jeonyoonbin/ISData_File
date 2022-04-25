import 'dart:convert';

import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Model/noticeSortListModel.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/NoticeManager/notice_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoticeUpdateSort extends StatefulWidget {
  final String shopCode;
  final String menuCode;

  const NoticeUpdateSort({Key key, this.shopCode, this.menuCode}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NoticeUpdateSortState();
  }
}

class NoticeUpdateSortState extends State<NoticeUpdateSort> with SingleTickerProviderStateMixin {
  //final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //final ScrollController _scrollController = ScrollController();
  final List<noticeSortListModel> sortListEvent = <noticeSortListModel>[];
  final List<noticeSortListModel> sortListMainPopup = <noticeSortListModel>[];
  final List<noticeSortListModel> sortListNotice = <noticeSortListModel>[];
  final List<noticeSortListModel> sortListOwnerNotice = <noticeSortListModel>[];
  final List<noticeSortListModel> sortListOwnerEvent = <noticeSortListModel>[];
  final List<noticeSortListModel> sortListOwnerMainPopup = <noticeSortListModel>[];
  final List<noticeSortListModel> sortListMunicipal = <noticeSortListModel>[];

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
    await NoticeController.to.getNoticeSortList('3').then((value) async{
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        value.forEach((e) {
          noticeSortListModel temp = noticeSortListModel.fromJson(e);

          temp.DISP_FR_DATE = Utils.getYearMonthDayFormat(temp.DISP_FR_DATE);
          temp.DISP_TO_DATE = Utils.getYearMonthDayFormat(temp.DISP_TO_DATE);

          sortListEvent.add(temp);
        });

        if (isSaveEnabled == true) {
          await Future.delayed(Duration(milliseconds: 500), () async {
            List<String> sortDataList = [];
            sortListEvent.forEach((element) {
              sortDataList.add(element.NOTICE_SEQ.toString());
            });

            if (sortDataList.length != 0) {
              String jsonData = jsonEncode(sortDataList);
              await NoticeController.to.updateSort(jsonData, context);
            }

            isSaveEnabled = false;
          });
        }
      }
    });

    //if (this.mounted) {
      setState(() {});
    //}

    // 메인팝업 조회
    await NoticeController.to.getNoticeSortList('5').then((value) async {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        value.forEach((e) {
          noticeSortListModel temp = noticeSortListModel.fromJson(e);

          temp.DISP_FR_DATE = Utils.getYearMonthDayFormat(temp.DISP_FR_DATE);
          temp.DISP_TO_DATE = Utils.getYearMonthDayFormat(temp.DISP_TO_DATE);

          sortListMainPopup.add(temp);
        });

        if (isSaveEnabled == true) {
          await Future.delayed(Duration(milliseconds: 500), () async {
            List<String> sortDataList = [];
            sortListMainPopup.forEach((element) {
              sortDataList.add(element.NOTICE_SEQ.toString());
            });

            if (sortDataList.length != 0) {
              String jsonData = jsonEncode(sortDataList);
              await NoticeController.to.updateSort(jsonData, context);
            }

            isSaveEnabled = false;
          });
        }
      }
    });

    //if (this.mounted) {
      setState(() {});
    //}

    // 공지사항 바인딩
    await NoticeController.to.getNoticeSortList('1').then((value) async {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        value.forEach((e) {
          noticeSortListModel temp = noticeSortListModel.fromJson(e);

          temp.DISP_FR_DATE = Utils.getYearMonthDayFormat(temp.DISP_FR_DATE);
          temp.DISP_TO_DATE = Utils.getYearMonthDayFormat(temp.DISP_TO_DATE);

          sortListNotice.add(temp);
        });

        if (isSaveEnabled == true) {
          await Future.delayed(Duration(milliseconds: 500), () async {
            List<String> sortDataList = [];
            sortListNotice.forEach((element) {
              sortDataList.add(element.NOTICE_SEQ.toString());
            });

            if (sortDataList.length != 0) {
              String jsonData = jsonEncode(sortDataList);
              await NoticeController.to.updateSort(jsonData, context);
            }

            isSaveEnabled = false;
          });
        }
      }
    });

    //if (this.mounted) {
      setState(() {});
    //}

    // 사장님공지 바인딩
    await NoticeController.to.getNoticeSortList('2').then((value) async {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        value.forEach((e) {
          noticeSortListModel temp = noticeSortListModel.fromJson(e);

          temp.DISP_FR_DATE = Utils.getYearMonthDayFormat(temp.DISP_FR_DATE);
          temp.DISP_TO_DATE = Utils.getYearMonthDayFormat(temp.DISP_TO_DATE);

          sortListOwnerNotice.add(temp);
        });

        if (isSaveEnabled == true) {
          await Future.delayed(Duration(milliseconds: 500), () async {
            List<String> sortDataList = [];
            sortListOwnerNotice.forEach((element) {
              sortDataList.add(element.NOTICE_SEQ.toString());
            });

            if (sortDataList.length != 0) {
              String jsonData = jsonEncode(sortDataList);
              await NoticeController.to.updateSort(jsonData, context);
            }

            isSaveEnabled = false;
          });
        }
      }
    });

    //if (this.mounted) {
      setState(() {});
    //}

    // 사장님 이벤트 바인딩
    await NoticeController.to.getNoticeSortList('4').then((value) async {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        value.forEach((e) {
          noticeSortListModel temp = noticeSortListModel.fromJson(e);

          temp.DISP_FR_DATE = Utils.getYearMonthDayFormat(temp.DISP_FR_DATE);
          temp.DISP_TO_DATE = Utils.getYearMonthDayFormat(temp.DISP_TO_DATE);

          sortListOwnerEvent .add(temp);
        });

        if (isSaveEnabled == true) {
          await Future.delayed(Duration(milliseconds: 500), () async {
            List<String> sortDataList = [];
            sortListOwnerEvent .forEach((element) {
              sortDataList.add(element.NOTICE_SEQ.toString());
            });

            if (sortDataList.length != 0) {
              String jsonData = jsonEncode(sortDataList);
              await NoticeController.to.updateSort(jsonData, context);
            }

            isSaveEnabled = false;
          });
        }
      }
    });

    //if (this.mounted) {
      setState(() {});
    //}

    // 사장님 팝업 바인딩
    await NoticeController.to.getNoticeSortList('6').then((value) async {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        value.forEach((e) {
          noticeSortListModel temp = noticeSortListModel.fromJson(e);

          temp.DISP_FR_DATE = Utils.getYearMonthDayFormat(temp.DISP_FR_DATE);
          temp.DISP_TO_DATE = Utils.getYearMonthDayFormat(temp.DISP_TO_DATE);

          sortListOwnerMainPopup .add(temp);
        });

        if (isSaveEnabled == true) {
          await Future.delayed(Duration(milliseconds: 500), () async {
            List<String> sortDataList = [];
            sortListOwnerMainPopup .forEach((element) {
              sortDataList.add(element.NOTICE_SEQ.toString());
            });

            if (sortDataList.length != 0) {
              String jsonData = jsonEncode(sortDataList);
              await NoticeController.to.updateSort(jsonData, context);
            }

            isSaveEnabled = false;
          });
        }
      }
    });

    //if (this.mounted) {
      setState(() {});
    //}

    // 시정홍보 바인딩
    await NoticeController.to.getNoticeSortList('7').then((value) async {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        value.forEach((e) {
          noticeSortListModel temp = noticeSortListModel.fromJson(e);

          temp.DISP_FR_DATE = Utils.getYearMonthDayFormat(temp.DISP_FR_DATE);
          temp.DISP_TO_DATE = Utils.getYearMonthDayFormat(temp.DISP_TO_DATE);

          sortListMunicipal .add(temp);
        });

        if (isSaveEnabled == true) {
          await Future.delayed(Duration(milliseconds: 500), () async {
            List<String> sortDataList = [];
            sortListMunicipal .forEach((element) {
              sortDataList.add(element.NOTICE_SEQ.toString());
            });

            if (sortDataList.length != 0) {
              String jsonData = jsonEncode(sortDataList);
              await NoticeController.to.updateSort(jsonData, context);
            }

            isSaveEnabled = false;
          });
        }
      }
    });

    //if (this.mounted) {
      setState(() {});
    //}
  }

  _editListSort(List<String> sortDataList) async {
    String jsonData = jsonEncode(sortDataList);

    //print(jsonData);

    //print('data set->'+jsonData);
    await NoticeController.to.updateSort(jsonData, context);

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
                                        '[' + sortListEvent[index].NOTICE_SEQ.toString() + '] ' + sortListEvent[index].NOTICE_TITLE ?? '--',
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
                                          sortListEvent[index].DISP_FR_DATE + ' ~ ' + sortListEvent[index].DISP_TO_DATE ?? '--',
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
                                        '[' + sortListMainPopup[index].NOTICE_SEQ.toString() + '] ' + sortListMainPopup[index].NOTICE_TITLE ?? '--',
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
                                          sortListMainPopup[index].DISP_FR_DATE + ' ~ ' + sortListMainPopup[index].DISP_TO_DATE ?? '--',
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
                                    '[' + sortListNotice[index].NOTICE_SEQ.toString() + '] ' + sortListNotice[index].NOTICE_TITLE ?? '--',
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
                                      sortListNotice[index].DISP_FR_DATE + ' ~ ' + sortListNotice[index].DISP_TO_DATE ?? '--',
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
                                    '[' + sortListOwnerNotice[index].NOTICE_SEQ.toString() + '] ' + sortListOwnerNotice[index].NOTICE_TITLE ?? '--',
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
                                      sortListOwnerNotice[index].DISP_FR_DATE + ' ~ ' + sortListOwnerNotice[index].DISP_TO_DATE ?? '--',
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
                                    '[' + sortListOwnerEvent[index].NOTICE_SEQ.toString() + '] ' + sortListOwnerEvent[index].NOTICE_TITLE ?? '--',
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
                                      sortListOwnerEvent[index].DISP_FR_DATE + ' ~ ' + sortListOwnerEvent[index].DISP_TO_DATE ?? '--',
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
                                    '[' + sortListOwnerMainPopup[index].NOTICE_SEQ.toString() + '] ' + sortListOwnerMainPopup[index].NOTICE_TITLE ?? '--',
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
                                      sortListOwnerMainPopup[index].DISP_FR_DATE + ' ~ ' + sortListOwnerMainPopup[index].DISP_TO_DATE ?? '--',
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
                                    '[' + sortListMunicipal[index].NOTICE_SEQ.toString() + '] ' + sortListMunicipal[index].NOTICE_TITLE ?? '--',
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
                                      sortListMunicipal[index].DISP_FR_DATE + ' ~ ' + sortListMunicipal[index].DISP_TO_DATE ?? '--',
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
      final noticeSortListModel item = sortListEvent.removeAt(oldIndex);
      sortListEvent.insert(newIndex, item);

      List<String> sortDataList = [];
      sortListEvent.forEach((element) {
        sortDataList.add(element.NOTICE_SEQ.toString());
      });
      _editListSort(sortDataList);
    });
  }

  void _onReorder_MainPopup(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final noticeSortListModel item = sortListMainPopup.removeAt(oldIndex);
      sortListMainPopup.insert(newIndex, item);

      List<String> sortDataList = [];
      sortListMainPopup.forEach((element) {
        sortDataList.add(element.NOTICE_SEQ.toString());
      });
      _editListSort(sortDataList);
    });
  }

  void _onReorder_Notice(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final noticeSortListModel item = sortListNotice.removeAt(oldIndex);
      sortListNotice.insert(newIndex, item);

      List<String> sortDataList = [];
      sortListNotice.forEach((element) {
        sortDataList.add(element.NOTICE_SEQ.toString());
      });
      _editListSort(sortDataList);
    });
  }

  void _onReorder_OwnerNotice(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final noticeSortListModel item = sortListOwnerNotice.removeAt(oldIndex);
      sortListOwnerNotice.insert(newIndex, item);

      List<String> sortDataList = [];
      sortListOwnerNotice.forEach((element) {
        sortDataList.add(element.NOTICE_SEQ.toString());
      });
      _editListSort(sortDataList);
    });
  }

  void _onReorder_OwnerEvent(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final noticeSortListModel item = sortListOwnerEvent.removeAt(oldIndex);
      sortListOwnerEvent.insert(newIndex, item);

      List<String> sortDataList = [];
      sortListOwnerEvent.forEach((element) {
        sortDataList.add(element.NOTICE_SEQ.toString());
      });
      _editListSort(sortDataList);
    });
  }

  void _onReorder_OwnerMainPopup(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final noticeSortListModel item = sortListOwnerMainPopup.removeAt(oldIndex);
      sortListOwnerMainPopup.insert(newIndex, item);

      List<String> sortDataList = [];
      sortListOwnerMainPopup.forEach((element) {
        sortDataList.add(element.NOTICE_SEQ.toString());
      });
      _editListSort(sortDataList);
    });
  }

  void _onReorder_Municipal(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final noticeSortListModel item = sortListMunicipal.removeAt(oldIndex);
      sortListMunicipal.insert(newIndex, item);

      List<String> sortDataList = [];
      sortListMunicipal.forEach((element) {
        sortDataList.add(element.NOTICE_SEQ.toString());
      });
      _editListSort(sortDataList);
    });
  }
}
