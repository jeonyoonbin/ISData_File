import 'dart:async';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_marquee.dart';
import 'package:daeguro_admin_app/Model/dashboard/dashboardModel.dart';
import 'package:daeguro_admin_app/Model/dashboard/dashboardNoticeModel.dart';
import 'package:daeguro_admin_app/Model/dashboard/dashboardTodayCountModel.dart';
import 'package:daeguro_admin_app/Model/dashboard/dashboardTotalCancel.dart';
import 'package:daeguro_admin_app/Model/dashboard/dashboardTotalOrders.dart';
import 'package:daeguro_admin_app/Model/dashboard/dashboardTotalYearMembers.dart';
import 'package:daeguro_admin_app/Model/dashboard/dashboardWeekOrderModel.dart';
import 'package:daeguro_admin_app/Model/dashboard/dashboardTotalOs.dart';
import 'package:daeguro_admin_app/Model/dashboard/dashboardWeekCustomerModel.dart';
import 'package:daeguro_admin_app/Model/noticeDetailModel.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';

import 'package:daeguro_admin_app/View/NoticeManager/notice_controller.dart';
import 'package:daeguro_admin_app/View/Today/dashboardNoticePopup.dart';
import 'package:daeguro_admin_app/View/Today/dashboard_controller.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Dashboard2 extends StatefulWidget {
  const Dashboard2({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return Dashboard2State();
  }
}

class Dashboard2State extends State<Dashboard2> {
  //const DashboardState({Key key}) : super(key: key);
  List<String> _tipMarqueeList = [];
  List<DashBoardNoticeModel> dataNoticeList = <DashBoardNoticeModel>[];

  List<DashBoardWeekOrderModel> dataWeekOrderList = <DashBoardWeekOrderModel>[];
  List<DashBoardWeekCustomerModel> dataWeekCustomerList = <DashBoardWeekCustomerModel>[];

  List<DashBoardTotalOs> dataTotalOs = <DashBoardTotalOs>[];
  List<DashBoardTotalYearMembers> dataTotalYearMembers = <DashBoardTotalYearMembers>[];
  List<DashBoardTotalOrders> dataTotalOrders = <DashBoardTotalOrders>[];
  List<DashBoardTotalCancel> dataTotalCancel = <DashBoardTotalCancel>[];

  DashBoardModel mData = DashBoardModel();

  final int RefreshTime = 60; //5;//

  int cntA;
  int cntI;

  int cntS;
  int cntC;

  Timer _timer;
  String refreshDateTime = '';

  MarqueeController controller = MarqueeController();

  loadPreData() async {
    // await NoticeController.to.getDashboardNoticeData().then((value) {
    //   if (value == null) {
    //     ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    //   } else {
    //     dataNoticeList.clear();
    //     value.forEach((element) {
    //       DashBoardNoticeModel temp = DashBoardNoticeModel.fromJson(element);
    //       _tipMarqueeList.add(temp.TITLE);
    //       dataNoticeList.add(temp);
    //     });
    //   }
    // });
    // refreshUI();

    await DashBoardController.to.getData().then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        mData = DashBoardModel.fromJson(value);
      }
    });
    refreshUI();

    await DashBoardController.to.getWeekCustomerData().then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        dataWeekCustomerList.clear();
        value.forEach((element) {
          DashBoardWeekCustomerModel temp = DashBoardWeekCustomerModel.fromJson(element);
          dataWeekCustomerList.add(temp);
        });
      }
    });
    refreshUI();

    await DashBoardController.to.getWeekOrderData().then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        dataWeekOrderList.clear();
        value.forEach((element) {
          DashBoardWeekOrderModel temp = DashBoardWeekOrderModel.fromJson(element);
          dataWeekOrderList.add(temp);
        });
      }
    });
    refreshUI();

    await DashBoardController.to.getTotalInstalled().then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        dataTotalOs.clear();
        value.forEach((element) {
          DashBoardTotalOs temp = DashBoardTotalOs.fromJson(element);
          dataTotalOs.add(temp);
        });

        cntI = dataTotalOs[0].count; // 안드로이드 사용자 수
        cntA = dataTotalOs[1].count; // 아이폰 사용자 수
      }
    });
    refreshUI();

    await DashBoardController.to.getTotalOrders().then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        dataTotalOrders.clear();
        value.forEach((element) {
          DashBoardTotalOrders temp = DashBoardTotalOrders.fromJson(element);
          dataTotalOrders.add(temp);
        });

        cntC = dataTotalOrders[0].count;
        cntS = dataTotalOrders[1].count;
      }
    });
    refreshUI();

    await DashBoardController.to.getTotalYearMembers().then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        dataTotalYearMembers.clear();
        value.forEach((element) {
          DashBoardTotalYearMembers temp = DashBoardTotalYearMembers.fromJson(element);
          dataTotalYearMembers.add(temp);
        });
      }
    });
    refreshUI();

    await DashBoardController.to.getTotalCancel().then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        dataTotalCancel.clear();
        value.forEach((element) {
          DashBoardTotalCancel temp = DashBoardTotalCancel.fromJson(element);
          dataTotalCancel.add(temp);
        });
      }
    });
    refreshUI();
  }

  loadData() async {
    DateTime tempDT = DateTime.now();

    refreshDateTime = null;
    refreshDateTime = DateFormat('yyyy.MM.dd').add_jms().format(tempDT).toString();
    if (refreshDateTime.contains(' AM')) {
      refreshDateTime = refreshDateTime.replaceAll(' AM', '');
      refreshDateTime = refreshDateTime.replaceAll(' ', ' 오전');
    } else if (refreshDateTime.contains(' PM')) {
      refreshDateTime = refreshDateTime.replaceAll(' PM', '');
      refreshDateTime = refreshDateTime.replaceAll(' ', ' 오후');
    }

    await DashBoardController.to.getTodayCountData();
  }

  @override
  void dispose() {
    if (controller != null) controller = null;

    if (_timer != null) _timer.cancel();

    if (_tipMarqueeList != null) _tipMarqueeList.clear();

    if (dataNoticeList != null) dataNoticeList.clear();

    if (dataWeekOrderList != null) dataWeekOrderList.clear();

    if (dataWeekCustomerList != null) dataWeekCustomerList.clear();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Get.put(NoticeController());
    Get.put(DashBoardController());

    DashBoardController.to.checkTimeCount.value = RefreshTime;

    // if (mData == null){
    //   mData = DashBoardModel();
    // }

    if (DashBoardController.to.mTodayCountData.value == null) {
      DashBoardController.to.mTodayCountData.value = DashBoardTodayCountModel();
    }

    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (DashBoardController.to.checkTimeCount.value == 0) {
        //print('----- reload');
        DashBoardController.to.checkTimeCount.value = RefreshTime;

        loadData();
      } else {
        //setState(() {
        DashBoardController.to.checkTimeCount.value--;
        //});
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((c) {
      loadPreData();
      loadData();

      refreshUI();
    });
  }

  refreshUI(){
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context).size;
    //final isDesktop = isDisplayDesktop(context);

    var mobileContent = Column(
      children: <Widget>[
        Container(height: 20,),
        Container(
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 360,
                    child: _buildPanelContainer('회원현황', _media, child: _WeeklyCustomerChart(),),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 360,
                    child: _buildPanelContainer('주문현황', _media, child: _WeeklyOrderChart(),),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 270,
                        child: _buildPanelContainer('금일 현황', _media,
                          child: Obx(() => Column(
                            children: [
                              _RequestView(context, _media),
                              SizedBox(height: 7,),
                              Align(child: Text('최근 갱신(${refreshDateTime}) : ${DashBoardController.to.checkTimeCount}초',
                                style: TextStyle(color: Colors.black38, fontSize: 12),), alignment: Alignment.centerRight)
                            ],
                          ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        height: 150,
                        child: _buildPanelContainer('전체 가맹점 현황', _media,
                            child: Column(
                              children: [
                                _ShopStatusView(context, _media),
                              ],
                            )),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 430,
                        child: _buildVerticalPanelContainer('OS 별 설치 현황', _media, child: _totalOsChart(),),
                      ),
                      SizedBox(width: 10,),
                      Container(
                        height: 430,
                        child: _buildVerticalPanelContainer('주문 현황', _media, child: _totalOrdersChart(),),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 360,
                    child: _buildPanelContainer('연령별 가입 현황', _media, child: _totalYearMembersChart(),),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 360,
                    child: _buildPanelContainer('취소 현황', _media, child: _totalCancelChart(),),
                  ),
                ],
              ),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ],
    );

    var content = Column(
      children: <Widget>[
        Container(height: 20,),
        Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 360,
                    child: _buildPanelContainer('회원현황', _media, child: _WeeklyCustomerChart(),),
                  ),
                  SizedBox(width: 20,),
                  Container(
                    height: 360,
                    child: _buildPanelContainer('주문현황', _media, child: _WeeklyOrderChart(),),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 270,
                        child: _buildPanelContainer('금일 현황', _media,
                          child: Obx(() => Column(
                              children: [
                                _RequestView(context, _media),
                                SizedBox(height: 7,),
                                Align(child: Text('최근 갱신(${refreshDateTime}) : ${DashBoardController.to.checkTimeCount}초',
                                      style: TextStyle(color: Colors.black38, fontSize: 12),), alignment: Alignment.centerRight)
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        height: 150,
                        child: _buildPanelContainer('전체 가맹점 현황', _media,
                            child: Column(
                              children: [
                                _ShopStatusView(context, _media),
                              ],
                            )),
                      ),
                    ],
                  ),
                  SizedBox(width: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 430,
                        child: _buildVerticalPanelContainer('OS 별 설치 현황', _media, child: _totalOsChart(),),
                      ),
                      SizedBox(width: 10,),
                      Container(
                        height: 430,
                        child: _buildVerticalPanelContainer('주문 현황', _media, child: _totalOrdersChart(),),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 360,
                    child: _buildPanelContainer('연령별 가입 현황', _media, child: _totalYearMembersChart(),),
                  ),
                  SizedBox(width: 20,),
                  Container(
                    height: 360,
                    child: _buildPanelContainer('취소 현황', _media, child: _totalCancelChart(),),
                  ),
                ],
              ),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ],
    );

    return Responsive.isMobile(context) ? mobileContent : content;
  }

  int getCompareNoticeData(String title) {
    int temp = -1;
    for (final element in dataNoticeList) {
      if (element.TITLE.contains(title) == true) {
        temp = element.NOTICE_SEQ;
        break;
      }
    }
    return temp;
  }

  _YearMembersView(context, Size _media, isDesktop) {
    var boxList = <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _getFlipBoard('10 대', dataTotalYearMembers[0].count.toString(), _media, bgcolor: Color.fromRGBO(37, 180, 60, 1.0), fontcolor: Colors.white, width: _media.width / 13),
          _getFlipBoard('20 대', dataTotalYearMembers[1].count.toString(), _media, bgcolor: Color.fromRGBO(37, 180, 60, 1.0), fontcolor: Colors.white, width: _media.width / 13),
          _getFlipBoard('30 대', dataTotalYearMembers[2].count.toString(), _media, bgcolor: Color.fromRGBO(37, 180, 60, 1.0), fontcolor: Colors.white, width: _media.width / 13),
          _getFlipBoard('40 대', dataTotalYearMembers[3].count.toString(), _media, bgcolor: Color.fromRGBO(37, 180, 60, 1.0), fontcolor: Colors.white, width: _media.width / 13),
        ],
      ),
      SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _getFlipBoard('50 대', dataTotalYearMembers[4].count.toString(), _media, bgcolor: Color.fromRGBO(187, 182, 62, 1.0), fontcolor: Colors.white, width: _media.width / 13),
          _getFlipBoard('60 대', dataTotalYearMembers[5].count.toString(), _media, bgcolor: Color.fromRGBO(187, 182, 62, 1.0), fontcolor: Colors.white, width: _media.width / 13),
          _getFlipBoard('70 대', dataTotalYearMembers[6].count.toString(), _media, bgcolor: Color.fromRGBO(187, 182, 62, 1.0), fontcolor: Colors.white, width: _media.width / 13),
          _getFlipBoard('80 대', dataTotalYearMembers[7].count.toString(), _media, bgcolor: Color.fromRGBO(187, 182, 62, 1.0), fontcolor: Colors.white, width: _media.width / 13),
        ],
      )
    ];

    //if (isDesktop) {
    return Container(
      //color: Colors.yellow,
      height: 190,
      padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0), //const EdgeInsets.all(5.0),
      child: Column(children: boxList),
    );
    // }
    // else {
    //   return Container(
    //     width: double.infinity,
    //     height: 500,
    //     padding: const EdgeInsets.all(18.0),
    //     child: Column(children: boxList),
    //   );
    // }
  }

  _CancelView(context, Size _media, isDesktop) {
    var boxList = <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _getFlipBoard('고객본인취소', dataTotalCancel[0].count.toString(), _media, bgcolor: Color.fromRGBO(189, 119, 47, 1.0), fontcolor: Colors.white, width: _media.width / 13),
          _getFlipBoard('가맹점취소', dataTotalCancel[1].count.toString(), _media, bgcolor: Color.fromRGBO(189, 119, 47, 1.0), fontcolor: Colors.white, width: _media.width / 13),
          _getFlipBoard('시간지연', dataTotalCancel[2].count.toString(), _media, bgcolor: Color.fromRGBO(189, 119, 47, 1.0), fontcolor: Colors.white, width: _media.width / 13),
          _getFlipBoard('결재대기자동취소', dataTotalCancel[3].count.toString(), _media, bgcolor: Color.fromRGBO(189, 119, 47, 1.0), fontcolor: Colors.white, width: _media.width / 13),
        ],
      ),
      SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _getFlipBoard('주소입력오류', dataTotalCancel[4].count.toString(), _media, bgcolor: Color.fromRGBO(180, 48, 174, 1.0), fontcolor: Colors.white, width: _media.width / 9.5),
          _getFlipBoard('사유없음', dataTotalCancel[5].count.toString(), _media, bgcolor: Color.fromRGBO(180, 48, 174, 1.0), fontcolor: Colors.white, width: _media.width / 9.5),
          _getFlipBoard('정산 접수겁부', dataTotalCancel[6].count.toString(), _media, bgcolor: Color.fromRGBO(180, 48, 174, 1.0), fontcolor: Colors.white, width: _media.width / 9.5),
        ],
      )
    ];

    //if (isDesktop) {
    return Container(
      //color: Colors.yellow,
      height: 190,
      padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0), //const EdgeInsets.all(5.0),
      child: Column(children: boxList),
    );
    // }
    // else {
    //   return Container(
    //     width: double.infinity,
    //     height: 500,
    //     padding: const EdgeInsets.all(18.0),
    //     child: Column(children: boxList),
    //   );
    // }
  }

  _RequestView(context, Size _media) {
    var boxList = <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _getFlipBoard('누적회원', DashBoardController.to.TOTAL_MEMBER.toString(), _media, bgcolor: Color.fromRGBO(192, 108, 132, 1), fontcolor: Colors.white, width: (Responsive.isMobile(context) ? _media.width / 10+64 : _media.width / 10)),
          _getFlipBoard('신규회원', DashBoardController.to.TODAY_MEMBER.toString(), _media, bgcolor: Color.fromRGBO(192, 108, 132, 1), fontcolor: Colors.white, width: (Responsive.isMobile(context) ? _media.width / 10+64 : _media.width / 10)),
          _getFlipBoard('앱설치', DashBoardController.to.TODAY_APP_INSTALL.toString(), _media, bgcolor: Color.fromRGBO(192, 108, 132, 1), fontcolor: Colors.white, width: (Responsive.isMobile(context) ? _media.width / 10+64 : _media.width / 10)),
        ],
      ),
      SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _getFlipBoard('전체주문', DashBoardController.to.TODAY_ORDER.toString(), _media, bgcolor: Color.fromRGBO(0, 168, 181, 1), fontcolor: Colors.white, width: (Responsive.isMobile(context) ? _media.width / 10+64 : _media.width / 10)),
          _getFlipBoard('가맹점확인', DashBoardController.to.TODAY_SHOP_CONFIRM.toString(), _media, bgcolor: Color.fromRGBO(0, 168, 181, 1), fontcolor: Colors.white, width: (Responsive.isMobile(context) ? _media.width / 10+64 : _media.width / 10)),
          _getFlipBoard('완료주문', DashBoardController.to.TODAY_COMPLETE_COUNT.toString(), _media, bgcolor: Color.fromRGBO(0, 168, 181, 1), fontcolor: Colors.white, width: (Responsive.isMobile(context) ? _media.width / 10+64 : _media.width / 10)),
        ],
      )
    ];

    //if (isDesktop) {
    return Container(
      //color: Colors.yellow,
      height: 190,
      padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0), //const EdgeInsets.all(5.0),
      child: Column(children: boxList),
    );
    // }
    // else {
    //   return Container(
    //     width: double.infinity,
    //     height: 500,
    //     padding: const EdgeInsets.all(18.0),
    //     child: Column(children: boxList),
    //   );
    // }
  }

  _ShopStatusView(context, Size _media) {
    var boxList = <Widget>[
      _getFlipBoard('전체', mData.totalShopCount, _media, bgcolor: Color.fromRGBO(75, 135, 185, 1), fontcolor: Colors.white, width: (Responsive.isMobile(context) ? _media.width / 14+52 : _media.width / 14)),
      _getFlipBoard('신규', mData.newShopCount, _media, bgcolor: Color.fromRGBO(75, 135, 185, 1), fontcolor: Colors.white, width: (Responsive.isMobile(context) ? _media.width / 14+52 : _media.width / 14)),
      _getFlipBoard('운영', mData.useShopCount, _media, bgcolor: Color.fromRGBO(75, 135, 185, 1), fontcolor: Colors.white, width: (Responsive.isMobile(context) ? _media.width / 14+52 : _media.width / 14)),
      _getFlipBoard('미운영', mData.stopShopCount, _media, bgcolor: Color.fromRGBO(75, 135, 185, 1), fontcolor: Colors.white, width: (Responsive.isMobile(context) ? _media.width / 14+52 : _media.width / 14)),
    ];

    // Color.fromRGBO(75, 135, 185, 1);
    // Color.fromRGBO(192, 108, 132, 1);
    // Color.fromRGBO(246, 114, 128, 1);
    // Color.fromRGBO(248, 177, 149, 1);
    // Color.fromRGBO(116, 180, 155, 1);
    // Color.fromRGBO(0, 168, 181, 1);
    // Color.fromRGBO(73, 76, 162, 1);
    // Color.fromRGBO(255, 205, 96, 1);
    // Color.fromRGBO(255, 240, 219, 1);
    // Color.fromRGBO(238, 238, 238, 1);

    //if (isDesktop) {
    return Container(
      //color: Colors.yellow,
      height: 90,
      padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 0.0, bottom: 0.0), //const EdgeInsets.all(5.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: boxList),
    );
    // }
    // else {
    //   return Container(
    //     width: double.infinity,
    //     height: 500,
    //     padding: const EdgeInsets.all(18.0),
    //     child: Column(children: boxList),
    //   );
    // }
  }

  _getASizedBox(isDesktop) {
    return SizedBox(
      width: isDesktop ? 20 : 0,
      height: isDesktop ? 0 : 20,
    );
  }

  _getFlipBoard(String title, String subtitle, Size _media, {Color bgcolor, Color fontcolor, Icon icon, double width, double height}) {
    return Container(
      width: width, //_media.width / 22,//double.infinity,
      height: 70, //_media.height / 20,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black26, offset: Offset(2.0, 2.0), blurRadius: 4.0),
        ],
      ),
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                height: 24,
                width: width,
                //_media.width / 22,
                color: bgcolor,
                child: Text(
                  title,
                  style: TextStyle(
                    color: fontcolor,
                    fontSize: 13.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12), //const EdgeInsets.only(left: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    //Text(subtitle, style: TextStyle(color: Colors.black, fontSize: 24),),
                    AnimatedFlipCounter(textStyle: TextStyle(color: Colors.black, fontSize: 20), value: double.parse(subtitle)),
                    Container(padding: EdgeInsets.only(bottom: 3.0), child: Text('건')),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _getSignBox(String title, String subtitle, Size _media, {Color bgcolor, Color fontcolor, Icon icon, double width, double height}) {
    return Container(
      width: width, //_media.width / 22,//double.infinity,
      height: 80, //_media.height / 20,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black26, offset: Offset(2.0, 2.0), blurRadius: 4.0),
        ],
      ),
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                height: 26,
                width: width,
                //_media.width / 22,
                color: bgcolor,
                child: Text(
                  title,
                  style: TextStyle(
                    color: fontcolor,
                    fontSize: 14.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8), //const EdgeInsets.only(left: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.black, fontSize: 24),
                    ),
                    Text('건'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container _buildSingleBannerContainer(String title, String subtitle, Size _media, {double width, double height}) {
    // List  palette = const  [
    //   Color.fromRGBO(75, 135, 185, 1),
    //   Color.fromRGBO(192, 108, 132, 1),
    //   Color.fromRGBO(246, 114, 128, 1),
    //   Color.fromRGBO(248, 177, 149, 1),
    //   Color.fromRGBO(116, 180, 155, 1),
    //   Color.fromRGBO(0, 168, 181, 1),
    //   Color.fromRGBO(73, 76, 162, 1),
    //   Color.fromRGBO(255, 205, 96, 1),
    //   Color.fromRGBO(255, 240, 219, 1),
    //   Color.fromRGBO(238, 238, 238, 1)],

    return Container(
      padding: const EdgeInsets.all(16.0),
      width: (_media.width / 3) * 2 + 60,
      //double.infinity,
      height: height,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black26, offset: Offset(2.0, 2.0), blurRadius: 4.0),
        ],
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
              ),
              Text(
                subtitle,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container _buildBannerContainer(Size _media, {Widget child, double width, double height}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: (_media.width / 3) * 2 + 60,
      //double.infinity,
      height: height,
      // width: width ?? double.infinity,
      // height: height,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black26, offset: Offset(2.0, 2.0), blurRadius: 4.0),
        ],
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          child,
        ],
      ),
    );
  }

  Container _buildPanelContainer(String title, Size _media, {Widget child, double width, double height}) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
      //const EdgeInsets.all(16.0),
      width: _media != null ? _media.width / 3 + (Responsive.isMobile(context) ? 240 : 80) : double.infinity,
      height: _media != null ? _media.height / 4.4 : height,
      // width: width ?? double.infinity,
      // height: height,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black26, offset: Offset(2.0, 2.0), blurRadius: 4.0),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          if (child != null) ...[const SizedBox(height: 10.0), child]
        ],
      ),
    );
  }

  Container _buildVerticalPanelContainer(String title, Size _media, {Widget child, double width, double height}) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
      width: _media != null ? _media.width / 6 + (Responsive.isMobile(context) ? 115 : 35) : double.infinity,
      height: _media != null ? _media.height / 4.4 : height,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black26, offset: Offset(2.0, 2.0), blurRadius: 4.0),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          if (child != null) ...[const SizedBox(height: 10.0), child]
        ],
      ),
    );
  }

  Widget _totalOsChart() {
    return SfCircularChart(
      legend: Legend(isVisible: true, textStyle: TextStyle(fontSize: 13, fontFamily: 'NotoSansKR'), overflowMode: LegendItemOverflowMode.scroll, position: LegendPosition.bottom),
      //title: ChartTitle(text: 'OS 별 설치 현황', textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR')),
      tooltipBehavior: TooltipBehavior(enable: true, textStyle: TextStyle(fontSize: 13, fontFamily: 'NotoSansKR')),
      series: <CircularSeries>[
        PieSeries<DashBoardTotalOs, String>(
            enableTooltip: false,
            //enableSmartLabels: true,
            animationDuration: 500.0,
            dataSource: dataTotalOs,
            xValueMapper: (DashBoardTotalOs data, _) => data.device_gbn == 'A' ? '안드로이드\n' + '(' + (cntA / (cntA + cntI) * 100).toInt().toString() + '%)' : '아이폰\n' + '(' + (cntI / (cntA + cntI) * 100).toInt().toString() + '%)',
            yValueMapper: (DashBoardTotalOs data, _) => data.count,
            //pointColorMapper: (DashBoardTotalOs data, _) => data.device_gbn == 'A' ? Colors.indigo : Colors.deepOrangeAccent,
            dataLabelMapper: (DashBoardTotalOs data, _) => data.device_gbn == 'A' ? '안드로이드\n' + '(' + Utils.getCashComma(data.count.toString()) + ')' : '아이폰\n' + '(' + Utils.getCashComma(data.count.toString()) + ')',
            dataLabelSettings: DataLabelSettings(isVisible: true, labelPosition: ChartDataLabelPosition.inside, textStyle: TextStyle(fontSize: 12, fontFamily: 'NotoSansKR', color: Colors.white)))
      ],
    );
  }

  Widget _totalOrdersChart() {
    return SfCircularChart(
      legend: Legend(isVisible: true, textStyle: TextStyle(fontSize: 13, fontFamily: 'NotoSansKR'), overflowMode: LegendItemOverflowMode.scroll, position: LegendPosition.bottom),
      //title: ChartTitle(text: '주문 현황', textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR')),
      tooltipBehavior: TooltipBehavior(enable: true, textStyle: TextStyle(fontSize: 13, fontFamily: 'NotoSansKR')),
      series: <CircularSeries>[
        PieSeries<DashBoardTotalOrders, String>(
            enableTooltip: false,
            //enableSmartLabels: true,
            animationDuration: 500.0,
            dataSource: dataTotalOrders,
            xValueMapper: (DashBoardTotalOrders data, _) => data.status == '취소' ? '취소\n' + '(' + (cntC / (cntS + cntC) * 100).toInt().toString() + '%)' : '완료\n' + '(' + (cntS / (cntS + cntC) * 100).toInt().toString() + '%)',
            yValueMapper: (DashBoardTotalOrders data, _) => data.count,
            //pointColorMapper: (DashBoardTotalOrders data, _) => data.status == '완료' ? Color.fromRGBO(72, 102, 189, 1.0) : Color.fromRGBO(210, 64, 64, 1.0),
            dataLabelMapper: (DashBoardTotalOrders data, _) => data.status + '\n(' + Utils.getCashComma(data.count.toString()) + ')',
            dataLabelSettings: DataLabelSettings(isVisible: true, labelPosition: ChartDataLabelPosition.inside, textStyle: TextStyle(fontSize: 12, fontFamily: 'NotoSansKR', color: Colors.white)))
      ],
    );
  }

  Widget _totalYearMembersChart() {
    return SfCartesianChart(
      legend: Legend(isVisible: false, textStyle: TextStyle(fontSize: 13, fontFamily: 'NotoSansKR'), overflowMode: LegendItemOverflowMode.scroll, position: LegendPosition.bottom),
      //title: ChartTitle(text: '연령별 가입 현황', textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR')),
      //tooltipBehavior: TooltipBehavior(enable: true, textStyle: TextStyle(fontSize: 13, fontFamily: 'NotoSansKR')),
      series: <ChartSeries>[
        BarSeries<DashBoardTotalYearMembers, String>(
            enableTooltip: true,
            animationDuration: 500.0,
            width: 0.7,
            spacing: 0.3,
            dataSource: dataTotalYearMembers,
            xValueMapper: (DashBoardTotalYearMembers data, _) => data.year,
            yValueMapper: (DashBoardTotalYearMembers data, _) => data.count,
            pointColorMapper: (DashBoardTotalYearMembers data, _) => Colors.green,
            dataLabelSettings: DataLabelSettings(isVisible: true, labelPosition: ChartDataLabelPosition.inside, textStyle: TextStyle(fontSize: 12, fontFamily: 'NotoSansKR')))
      ],
      primaryXAxis: CategoryAxis(labelStyle: TextStyle(fontSize: 13, fontFamily: 'NotoSansKR')),
      primaryYAxis: NumericAxis(labelStyle: TextStyle(fontSize: 13, fontFamily: 'NotoSansKR'), numberFormat: NumberFormat.decimalPattern(),),
    );
  }

  Widget _totalCancelChart() {
    return SfCartesianChart(
      legend: Legend(isVisible: false, textStyle: TextStyle(fontSize: 13, fontFamily: 'NotoSansKR'), overflowMode: LegendItemOverflowMode.scroll, position: LegendPosition.bottom),
      //title: ChartTitle(text: '취소 현황', textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR')),
      //tooltipBehavior: TooltipBehavior(enable: true, textStyle: TextStyle(fontSize: 13, fontFamily: 'NotoSansKR')),
      series: <ChartSeries>[
        BarSeries<DashBoardTotalCancel, String>(
            enableTooltip: true,
            animationDuration: 500.0,
            width: 0.7,
            spacing: 0.3,
            dataSource: dataTotalCancel,
            xValueMapper: (DashBoardTotalCancel data, _) => data.cancel_code,
            yValueMapper: (DashBoardTotalCancel data, _) => data.count,
            pointColorMapper: (DashBoardTotalCancel data, _) => Colors.blue,
            dataLabelSettings: DataLabelSettings(isVisible: true, labelPosition: ChartDataLabelPosition.inside, textStyle: TextStyle(fontSize: 12, fontFamily: 'NotoSansKR')))
      ],
      primaryXAxis: CategoryAxis(labelStyle: TextStyle(fontSize: 13, fontFamily: 'NotoSansKR')),
      primaryYAxis: NumericAxis(labelStyle: TextStyle(fontSize: 13, fontFamily: 'NotoSansKR'), numberFormat: NumberFormat.decimalPattern(),),
    );
  }

  Widget _WeeklyCustomerChart() {
    return SfCartesianChart(
        selectionType: SelectionType.series,
        isTransposed: false,
        selectionGesture: ActivationMode.singleTap,
        primaryXAxis: CategoryAxis(isVisible: true, opposedPosition: false, isInversed: false, labelStyle: TextStyle(fontFamily: 'NotoSansKR'), ),
        primaryYAxis: NumericAxis(decimalPlaces: 0, numberFormat: NumberFormat("#,###", "en_US"),
          title: AxisTitle(text: '건수', textStyle: TextStyle(color: Colors.black87, fontFamily: 'NotoSansKR', fontSize: 12, fontWeight: FontWeight.bold)),
        ),
        axes: <ChartAxis>[
          NumericAxis(
              name: 'xAxis',
              decimalPlaces: 0,
              labelStyle: TextStyle(
                fontFamily: 'NotoSansKR',
              )),
          NumericAxis(
              name: 'yAxis',
              decimalPlaces: 0,
              labelStyle: TextStyle(
                fontFamily: 'NotoSansKR',
              ))
        ],
        legend: Legend(
          isVisible: true,
          toggleSeriesVisibility: true,
          position: LegendPosition.bottom,
          overflowMode: LegendItemOverflowMode.wrap,
          alignment: ChartAlignment.center,
          textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR'),
        ),
        crosshairBehavior: CrosshairBehavior(
          lineType: CrosshairLineType.horizontal,
          enable: true,
          shouldAlwaysShow: false,
          activationMode: ActivationMode.singleTap,
        ),
        // tooltipBehavior: TooltipBehavior(
        //   enable: false,
        //   shared: true,
        //   activationMode: ActivationMode.singleTap,
        //   textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR'),
        // ),
        series: <ChartSeries>[
          ColumnSeries<DashBoardWeekCustomerModel, String>(
            width: 0.3,
            enableTooltip: true,
            name: '앱설치건수',
            dataSource: dataWeekCustomerList,
            xValueMapper: (DashBoardWeekCustomerModel charts, _) => charts.INSERT_DATE,
            yValueMapper: (DashBoardWeekCustomerModel charts, _) => charts.INSTALL_COUNT.floor(),
            dataLabelSettings: DataLabelSettings(
                isVisible: false,
                labelPosition: ChartDataLabelPosition.outside,
                textStyle: TextStyle(fontSize: 11, color: Colors.white, fontFamily: 'NotoSansKR'),
                color: Color.fromRGBO(75, 135, 185, 1),
                labelAlignment: ChartDataLabelAlignment.outer),
            markerSettings: MarkerSettings(isVisible: false),
          ),
          ColumnSeries<DashBoardWeekCustomerModel, String>(
            width: 0.3,
            enableTooltip: true,
            name: '신규회원',
            dataSource: dataWeekCustomerList,
            xValueMapper: (DashBoardWeekCustomerModel charts, _) => charts.INSERT_DATE,
            yValueMapper: (DashBoardWeekCustomerModel charts, _) => charts.NEW_COSTOMER_COUNT.floor(),
            dataLabelSettings: DataLabelSettings(
                isVisible: false,
                labelPosition: ChartDataLabelPosition.outside,
                textStyle: TextStyle(fontSize: 11, color: Colors.white, fontFamily: 'NotoSansKR'),
                color: Color.fromRGBO(192, 108, 132, 1),
                labelAlignment: ChartDataLabelAlignment.outer),
            markerSettings: MarkerSettings(isVisible: false),
          ),
        ]);
  }

  Widget _WeeklyOrderChart() {
    return SfCartesianChart(
        selectionType: SelectionType.series,
        isTransposed: false,
        selectionGesture: ActivationMode.singleTap,
        primaryXAxis: CategoryAxis(isVisible: true, opposedPosition: false, isInversed: false, labelStyle: TextStyle(fontFamily: 'NotoSansKR')),
        primaryYAxis: NumericAxis(decimalPlaces: 0, numberFormat: NumberFormat("#,###", "en_US"),
          title: AxisTitle(text: '건수', textStyle: TextStyle(color: Colors.black87, fontFamily: 'NotoSansKR', fontSize: 12, fontWeight: FontWeight.bold)),
        ),
        axes: <ChartAxis>[
          NumericAxis(
              name: 'xAxis',
              opposedPosition: true,
              interval: 1,
              minimum: 0,
              maximum: 5,
              labelStyle: TextStyle(
                fontFamily: 'NotoSansKR',
              )),
          NumericAxis(
              name: 'yAxis',
              opposedPosition: true,
              labelStyle: TextStyle(
                fontFamily: 'NotoSansKR',
              ))
        ],
        legend: Legend(
          isVisible: true,
          toggleSeriesVisibility: true,
          position: LegendPosition.bottom,
          overflowMode: LegendItemOverflowMode.wrap,
          alignment: ChartAlignment.center,
          textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR'),
        ),
        crosshairBehavior: CrosshairBehavior(
          lineType: CrosshairLineType.horizontal,
          enable: true,
          shouldAlwaysShow: false,
          activationMode: ActivationMode.singleTap,
        ),
        // tooltipBehavior: TooltipBehavior(
        //   enable: true,
        //   shared: true,
        //   activationMode: ActivationMode.singleTap,
        //   textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR'),
        // ),
        series: <ChartSeries>[
          LineSeries<DashBoardWeekOrderModel, String>(
            name: '주문건수',
            dataSource: dataWeekOrderList,
            xValueMapper: (DashBoardWeekOrderModel charts, _) => charts.ORDER_DATE,
            yValueMapper: (DashBoardWeekOrderModel charts, _) => charts.COUNT,
            dataLabelSettings: DataLabelSettings(
                isVisible: false,
                labelPosition: ChartDataLabelPosition.outside,
                textStyle: TextStyle(fontSize: 11, color: Colors.white, fontFamily: 'NotoSansKR'),
                color: Color.fromRGBO(75, 135, 185, 1),
                labelAlignment: ChartDataLabelAlignment.outer),
            //Modify data points (show circles)
            markerSettings: MarkerSettings(isVisible: true),
            //yAxisName: 'yAxis'
          ),
          LineSeries<DashBoardWeekOrderModel, String>(
            name: '완료건수',
            dataSource: dataWeekOrderList,
            xValueMapper: (DashBoardWeekOrderModel charts, _) => charts.ORDER_DATE,
            yValueMapper: (DashBoardWeekOrderModel charts, _) => charts.COMPLETE_COUNT,
            dataLabelSettings: DataLabelSettings(
                isVisible: false,
                labelPosition: ChartDataLabelPosition.outside,
                textStyle: TextStyle(fontSize: 11, color: Colors.white, fontFamily: 'NotoSansKR'),
                color: Color.fromRGBO(192, 108, 132, 1),
                labelAlignment: ChartDataLabelAlignment.bottom),
            //Modify data points (show circles)
            markerSettings: MarkerSettings(isVisible: true),
            //yAxisName: 'yAxis'
          )
        ]);
  }
}
