import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/Model/shop/shopSector_HistoryModel.dart';
import 'package:daeguro_admin_app/Model/shop/shopsector_info.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopDetailNotifierData.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopSectorInfoEdit.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';


class ShopSectorInfo extends StatefulWidget {
  final Stream<ShopDetailNotifierData> stream;
  final Function callback;
  final double height;

  const ShopSectorInfo({Key key, this.stream, this.callback, this.height}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShopSectorInfoState();
  }
}

enum RadioGbn { gbn1, gbn2}

class ShopSectorInfoState extends State<ShopSectorInfo> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TabController _nestedTabController;

  List<ShopSectorHistoryModel> dataHistoryList = <ShopSectorHistoryModel>[];
  List<ShopSectorInfoModel> dataList = <ShopSectorInfoModel>[];
  List<ShopSectorInfoModel> dataShowList = <ShopSectorInfoModel>[];
  //ScrollController _scrollController;

  List<SelectOptionVO> selectBox_sectorTypeItems = [];

  ShopDetailNotifierData detailData;

  bool isListSaveEnabled = false;
  bool isReceiveDataEnabled = false;

  String _geofenceUseEnabled = 'N';

  RadioGbn _radioGbn;

  void refreshWidget(ShopDetailNotifierData element) {
    detailData = element;
    if (detailData != null) {
      //print('shopSector refreshWidget() is not NULL -> [${element.selected_shopCode}]');

      loadData();

      isReceiveDataEnabled = true;

      setState(() {
        //_nestedTabController.index = 0;
        //_scrollController.jumpTo(0.0);
      });
    }
    else{
      //print('shopSector refreshWidget() is NULL');

      dataList.clear();
      dataShowList.clear();

      isReceiveDataEnabled = false;

      setState(() {
        //_nestedTabController.index = 0;
        //_scrollController.jumpTo(0.0);
      });
    }

    setState(() {});
  }

  loadData() async {
    //await EasyLoading.show();
    //_nestedTabController.index = 0;

    dataList.clear();
    dataShowList.clear();
    dataHistoryList.clear();

    await ShopController.to.getSectorGeofenceData(detailData.selected_shopCode).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        _geofenceUseEnabled = value;

        if (_geofenceUseEnabled == 'Y') {
          _radioGbn = RadioGbn.gbn2;
        }
        else {
          _radioGbn = RadioGbn.gbn1;
        }

        // if (_geofenceUseEnabled == 'Y'){
        //   _sectorTypeDong = 'N';
        //   _sectorTypeGeo = 'Y';
        // }
        // else{
        //   _sectorTypeDong = 'Y';
        //   _sectorTypeGeo = 'N';
        // }
      }
    });

    await ShopController.to.getSectorData(detailData.selected_shopCode).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        value.forEach((e) async {
          ShopSectorInfoModel tempData = ShopSectorInfoModel.fromJson(e);
          dataList.add(tempData);
        });

        for (final firstEle in dataList){
          ShopSectorInfoModel newData = ShopSectorInfoModel();
          if (_getCompareData(firstEle.siguName) == false){
            newData.siguName = firstEle.siguName;
            newData.dongName = _getDongData(newData.siguName);
            dataShowList.add(newData);
          }
        }
      }
    });

    await ShopController.to.getSectorhistoryData(detailData.selected_shopCode).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else{
        value.forEach((element) {
          ShopSectorHistoryModel tempData = ShopSectorHistoryModel.fromJson(element);

          tempData.HIST_DATE = tempData.HIST_DATE.replaceAll('T', ' ');

          dataHistoryList.add(tempData);
        });
      }
    });

    //if (this.mounted){
    setState(() {});
    // }
  }

  bool _getCompareData(String siguName){
    bool temp = false;
    for (final element in dataShowList){
      if (element.siguName == siguName) {
        temp = true;
        break;
      }
    }
    return temp;
  }

  String _getDongData(String siguName){
    String temp = '';
    for (final element in dataList){
      if (element.siguName == siguName) {
        temp += element.dongName+' ';
      }
    }
    return temp;
  }

  _editSector(ShopSectorInfoModel editData) async {
    //await loadDongData(formData.sidoName, formData.gunGuName);
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: ShopSectorInfoEdit(
          shopCode: detailData.selected_shopCode, sData: editData,
        ),
      ),
    ).then((v) async {
      if (v != null) {
        await Future.delayed(Duration(milliseconds: 500), (){
          loadData();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _nestedTabController = new TabController(length: 2, vsync: this);
    //_scrollController = ScrollController();

    selectBox_sectorTypeItems.add(new SelectOptionVO(value: 'N', label: '동별 사용', label2: ''));
    selectBox_sectorTypeItems.add(new SelectOptionVO(value: 'Y', label: '지오펜스 사용', label2: ''));

    // WidgetsBinding.instance.addPostFrameCallback((c) {
    //   loadData();
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
    //_scrollController.dispose();
    dataList.clear();
    dataShowList.clear();
    dataHistoryList.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    Tab(text: '배달지 정보',),
                    Tab(text: '변경이력',)
                  ],
                ),
              ),
            ),
            //_nestedTabController.index == 0 ? buttonBar() : Container(height: 32,),
            Container(
              width: double.infinity,
              height: widget.height,
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _nestedTabController,
                children: [
                  Container(padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),//all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                      child: Text('배달지 유형', style: TextStyle(fontSize: 12, color: Colors.black),),
                                      margin: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10)//.all(5),
                                  ),
                                  Radio(value: RadioGbn.gbn1, groupValue: _radioGbn,
                                      onChanged: (v) async {
                                        _radioGbn = v;

                                        await ShopController.to.postSectorGeofenceData(detailData.selected_shopCode, 'N', context);

                                        if (isReceiveDataEnabled == true) {
                                          loadData();

                                          setState(() {
                                            //_scrollController.jumpTo(0.0);
                                            isListSaveEnabled = true;
                                          });
                                          //Navigator.pop(context, true);

                                          widget.callback();
                                        }
                                      }),
                                  Text('동별', style: TextStyle(fontSize: 12)),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Radio(value: RadioGbn.gbn2, groupValue: _radioGbn,
                                        onChanged: (v) async {
                                          _radioGbn = v;

                                          await ShopController.to.postSectorGeofenceData(detailData.selected_shopCode, 'Y', context);

                                          if (isReceiveDataEnabled == true) {
                                            loadData();

                                            setState(() {
                                              //_scrollController.jumpTo(0.0);
                                              isListSaveEnabled = true;
                                            });
                                            //Navigator.pop(context, true);

                                            widget.callback();
                                          }
                                        }),
                                  ),
                                  Text('지오펜스', style: TextStyle(fontSize: 12)),
                                  SizedBox(width: 5,),
                                ],
                              ),
                              //SizedBox(height: 10,),
                              Row(
                                children: [
                                  ISButton(
                                    iconData: Icons.refresh,
                                    iconColor: Colors.white,
                                    tip: '갱신',
                                    onPressed: () {
                                      if (isReceiveDataEnabled == true) {
                                        loadData();

                                        setState(() {
                                          //_scrollController.jumpTo(0.0);
                                          isListSaveEnabled = true;
                                        });
                                        //Navigator.pop(context, true);

                                        widget.callback();
                                      }
                                    },
                                  ),
                                  SizedBox(width: 10,),
                                  if (AuthUtil.isAuthCreateEnabled('98') == true)
                                    Container(
                                      child: ISButton(label: '배송지 추가',
                                          textStyle: TextStyle(color: Colors.white, fontSize: 13),
                                          iconColor: Colors.white,
                                          iconData: Icons.add,
                                          onPressed: () => _editSector(null)
                                      ),
                                    ),
                                  SizedBox(width: 8,),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          _radioGbn == RadioGbn.gbn1 ? getInfoTabView() : Container(
                            height: MediaQuery.of(context).size.height-377,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('지오펜스는 사장님사이트에서 설정 가능합니다.', style: TextStyle(color: Colors.black54),),
                                SizedBox(height: 20,),
                                Container(
                                  child: ISButton(label: '사장님사이트로 이동',
                                      textStyle: TextStyle(color: Colors.white, fontSize: 13),
                                      iconColor: Colors.white,
                                      iconData: Icons.airplay,
                                      onPressed: () async {
                                        await EasyLoading.showInfo('사장님사이트로 이동합니다.', maskType: EasyLoadingMaskType.clear, duration: Duration(seconds: 2), dismissOnTap: true);
                                        await EasyLoading.dismiss();
                                        _launchInBrowser(detailData.selected_shopCode);
                                      }
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                  ),
                  Container(padding: EdgeInsets.all(8.0), child: getHistoryTabView()),
                ],
              ),
            )
      ]),
    );
  }

  Widget getInfoTabView() {
    return Container(
      height: MediaQuery.of(context).size.height-377,
      child: ListView.builder(
        controller: ScrollController(),//_scrollController,
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
        itemCount: dataShowList.length,
        itemBuilder: (BuildContext context, int index) {
          return dataShowList != null
              ? GestureDetector(
            // onTap: (){
            //   Navigator.pushNamed(context, '/editor', arguments: UserController.to.userData[index]);
            // },
            child: Card(
              color: Colors.white,
              elevation: 2.0,
              child: ListTile(
                //leading: Text(dataList[index].siguName),
                title: Text(
                  dataShowList[index].siguName ?? '--',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                subtitle: Text(dataShowList[index].dongName ?? '--', style: TextStyle(fontSize: 12)),
                trailing: PopupMenuButton(
                    onSelected: (select) async {
                      // print('selectItem: '+select.toString());//BlocProvider.of<IdeaBloc>(context)..add
                      // int nSeq= int.parse(idea['seq'].toString());
                      //
                      // selectedMenu(select, nSeq);
                      if (select == 0) {
                        _editSector(dataShowList[index]);
                      }
                      else if (select == 1) {
                        List<String> sidogunguData = dataShowList[index].siguName.split(' ');
                        await ShopController.to.deleteSectorData(detailData.selected_shopCode, sidogunguData[0], sidogunguData[1]).then((value) {
                          // if (value != null){
                          //   ISAlert(context, '정상처리가 되지 않았습니다. \n\n${value}');
                          // }
                        });

                        loadData();
                      }
                    },
                    itemBuilder: (context) => <PopupMenuEntry>[
                      if (AuthUtil.isAuthEditEnabled('98') == true)
                      const PopupMenuItem(value: 0, child: Center(child: Text('수정', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),))),
                      if (AuthUtil.isAuthDeleteEnabled('98') == true)
                      const PopupMenuItem(value: 1, child: Center(child: Text('삭제', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),)))
                    ]),
              ),
            ),
          )
              : Text('Data is Empty');
        },
      ),
    );
  }

  Widget getHistoryTabView() {
    return ListView.builder(
      controller: ScrollController(),
      //padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      itemCount: dataHistoryList.length,
      itemBuilder: (BuildContext context, int index) {
        return dataHistoryList != null ? GestureDetector(
          child: Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: Row(
                children: [
                  //Text('No.' + imageHistoryList[index].no.toString() ?? '--', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Container(
                      width: 340,
                      padding: EdgeInsets.only(top: 5),
                      child: SelectableText(dataHistoryList[index].MEMO ?? '--', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87), showCursor: true,)
                  ),
                ],
              ),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      alignment: Alignment.centerRight,
                      child: Text(dataHistoryList[index].HIST_DATE ?? '--', style: TextStyle(fontSize: 12), textAlign: TextAlign.right)
                  )
                ],
              ),
            ),
          ),
        ) : Text('Data is Empty');
      },
    );
  }

  Future<void> _launchInBrowser(String shopCode) async {
    //ucode, name
    String uCode = GetStorage().read('logininfo')['uCode'];
    String uID = GetStorage().read('logininfo')['id'];
    String uName = GetStorage().read('logininfo')['name'];

    String url = ServerInfo.OWNERSITE_URL + '/$shopCode/$uCode/$uID/Store';

    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false, //true로 설정시, iOS 인앱 브라우저를 통해픈
        forceWebView: false, //true로 설정시, Android 인앱 브라우저를 통해 오픈
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Web Request Fail $url';
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
