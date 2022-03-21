@JS()
library javascript_bundler;

import 'dart:async';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/Model/shop/shopImageHistory.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopDetailNotifierData.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Model/shop/shop_divcode.dart';
import 'package:daeguro_admin_app/Model/shop/shop_info.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/Provider/FileUpLoader.dart';
import 'package:daeguro_admin_app/Util/multi_masked_formatter.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/Util/utils.dart';

import 'package:image_picker/image_picker.dart';
import 'package:js/js.dart';

import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

@JS('downloadImg')
external void showConfirm(var _uri);

class ShopInfo extends StatefulWidget {
  final Stream<ShopDetailNotifierData> stream;
  final Function callback;
  final double height;

  //final ShopInfo sData;
  const ShopInfo({Key key, this.stream, this.callback, this.height}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShopInfoState();
  }
}

enum RadioGbn { gbn1, gbn2, gbn3 }

class ShopInfoState extends State<ShopInfo> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ShopInfoModel formData = ShopInfoModel();
  RadioGbn _radioGbn;
  String RepImagePath;

  var _file;

  //List DivListitems = List();
  List<String> shopImageList = [];
  List<String> shopImageDownList = [];
  List<String> shopImageViewList = [];
  List<bool> _shopimgGbn = [];
  int errorcnt = 0;

  List<SelectOptionVO> selectBox_DivCode = [];

  TabController _nestedTabController;

  List<ShopImageHistoryModel> imageHistoryList = <ShopImageHistoryModel>[];

  int current_tabIdx = 0;

  ShopDetailNotifierData detailData = ShopDetailNotifierData();

  bool isListSaveEnabled = false;
  bool isReceiveDataEnabled = false;

  void refreshWidget(ShopDetailNotifierData element){
    detailData = element;
    if (detailData != null) {
      //print('shopInfo refreshWidget() is not NULL -> [${element.selected_shopCode}]');

      RepImagePath = null;

      loadImageURLData();
      loadData();

      isReceiveDataEnabled = true;

      setState(() {
        _nestedTabController.index = 0;
      });
    }
    else{
      //print('shopInfo refreshWidget() is NULL');

      formData = null;
      formData = ShopInfoModel();

      shopImageList.clear();
      shopImageDownList.clear();
      shopImageViewList.clear();
      _shopimgGbn.clear();

      imageHistoryList.clear();

      RepImagePath = null;

      isReceiveDataEnabled = false;

      setState(() {
        _nestedTabController.index = 0;
      });
    }

    setState(() {
    });
  }

  loadDivCodeData() async {
    selectBox_DivCode.clear();
    await ShopController.to.getDataDivItems().then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        value.forEach((element) {
          ShopDivCodeModel tempData = ShopDivCodeModel.fromJson(element);

          selectBox_DivCode.add(new SelectOptionVO(value: tempData.itemCd, label: tempData.itemName));
        });
      }
    });


  }

  loadImageURLData() {
    String imageThumbURL = ServerInfo.REST_IMG_BASEURL + '/api/Image/thumb?div=P&cccode=' + detailData.selected_ccCode + '&shop_cd=' + detailData.selected_shopCode;

    shopImageList.clear();
    shopImageViewList.clear();
    shopImageDownList.clear();

    shopImageList.add(imageThumbURL + '&file_name=buss.jpg&width=300&height=300'); //사업자등록증(buss.jpg)
    shopImageList.add(imageThumbURL + '&file_name=idcard.jpg&width=300&height=300'); //신분증(idcard.jpg)
    shopImageList.add(imageThumbURL + '&file_name=bank.jpg&width=300&height=300'); //통장사본(bank.jpg)

    // 이미지 뷰어 리스트(크기 900x900)
    shopImageViewList.add('https://admin.daeguro.co.kr/images/' + detailData.selected_ccCode + '/' + detailData.selected_shopCode + '/buss.jpg');
    shopImageViewList.add('https://admin.daeguro.co.kr/images/' + detailData.selected_ccCode + '/' + detailData.selected_shopCode + '/idcard.jpg');
    shopImageViewList.add('https://admin.daeguro.co.kr/images/' + detailData.selected_ccCode + '/' + detailData.selected_shopCode + '/bank.jpg');

    // 이미지 다운로드 경로
    shopImageDownList.add(ServerInfo.REST_IMG_BASEURL + '/images/' + detailData.selected_ccCode + '/' + detailData.selected_shopCode + '/buss.jpg');
    shopImageDownList.add(ServerInfo.REST_IMG_BASEURL + '/images/' + detailData.selected_ccCode + '/' + detailData.selected_shopCode + '/idcard.jpg');
    shopImageDownList.add(ServerInfo.REST_IMG_BASEURL + '/images/' + detailData.selected_ccCode + '/' + detailData.selected_shopCode + '/bank.jpg');
  }

  loadData() async {
    imageHistoryList.clear();

    await ShopController.to.getImageHistoryData(detailData.selected_shopCode, '1', '10000');

    await ShopController.to.getInfoData(detailData.selected_shopCode).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        formData = ShopInfoModel.fromJson(value);

        // 이미지 변경내역
        ShopController.to.qImageHistoryList.forEach((element) {
          ShopImageHistoryModel hisData = ShopImageHistoryModel.fromJson(element);
          if (hisData.histDate != null) hisData.histDate = hisData.histDate.replaceAll('T', '  ');
          imageHistoryList.add(hisData);
        });

        formData.current = formData.shopPass;

        //print('---> telNo:${formData.telNo}');

        if (formData.shopType == '7') {
          _radioGbn = RadioGbn.gbn1;
        } else if (formData.shopType == '5') {
          _radioGbn = RadioGbn.gbn2;
        } else if (formData.shopType == '5,7' || formData.shopType == '7,5') {
          _radioGbn = RadioGbn.gbn3;
        }

        if (formData.bussImg == 'Y')        _shopimgGbn[0] = true;
        if (formData.idcardImg == 'Y')      _shopimgGbn[1] = true;
        if (formData.bankImg == 'Y')        _shopimgGbn[2] = true;

        if (formData.appMinAmt == null || formData.appMinAmt == '') {
          setState(() {
            formData.appMinAmt = '0';
          });
        }


        if (formData.shopImg != 'Y') {
          RepImagePath == null;
        }
        else {
          // // URL 방식
          RepImagePath = ServerInfo.REST_IMG_BASEURL + '/images/' + detailData.selected_ccCode + '/' + detailData.selected_shopCode + '/shop.jpg?tm=${Utils.getTimeStamp()}';
        }


        setState(() {
        });
      }
    });


    //if (this.mounted) {

    //}
  }

  @override
  void dispose() {
    _nestedTabController.dispose();

    shopImageList.clear();
    shopImageDownList.clear();
    shopImageViewList.clear();
    selectBox_DivCode.clear();

    PaintingBinding.instance.imageCache.clearLiveImages();
    PaintingBinding.instance.imageCache.clear();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _nestedTabController = new TabController(length: 2, vsync: this);

    loadDivCodeData();

    // WidgetsBinding.instance.addPostFrameCallback((c) {
    //   setState(() {
    //     loadImageURLData();
    //   });
    //
    //   loadData();
    // });

    widget.stream.listen((element) {
      if (_shopimgGbn != null)
        _shopimgGbn.clear();

      _shopimgGbn.add(false); // 사업자등록증
      _shopimgGbn.add(false); // 영업신고증
      _shopimgGbn.add(false); // 통장사본

      refreshWidget(element);
    });
  }

  @override
  Widget build(BuildContext context) {
    var form = ListView(
        controller: ScrollController(),
        children: [
          buttonBar(),
          Form(
            key: formKey,
            child: Wrap(
              children: <Widget>[
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: [
                        Text('   매장&POS 정보', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: <Widget>[
                    Flexible(
                      flex: 2,
                      child: ISInput(
                        value: Utils.getPhoneNumFormat(formData.telNo, false) ?? '',
                        context: context,
                        label: '매장전화번호',
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.grey,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          MultiMaskedTextInputFormatter(masks: ['xxxx-xxxx-xxxx', 'xxx-xxxx-xxxx', 'xxx-xxx-xxxx', 'xxxx-xxxx'], separator: '-')
                        ],
                        onChange: (v) {
                          setState(() {
                            formData.telNo = v.toString().replaceAll('-', '');
                          });
                        },
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Row(
                        children: [
                          Container(
                            child: Text('매장 유형', style: TextStyle(fontSize: 10, color: Colors.black54),),
                            margin: EdgeInsets.all(5),
                          ),
                          Radio(value: RadioGbn.gbn1, groupValue: _radioGbn,
                              onChanged: (v) {
                                setState(() {
                                  _radioGbn = v;
                                });
                              }),
                          Text('포장', style: TextStyle(fontSize: 12)),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Radio(value: RadioGbn.gbn2, groupValue: _radioGbn,
                                onChanged: (v) {
                                  setState(() {
                                    _radioGbn = v;
                                  });
                                }),
                          ),
                          Text('배달', style: TextStyle(fontSize: 12)),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Radio(value: RadioGbn.gbn3, groupValue: _radioGbn,
                                onChanged: (v) {
                                  setState(() {
                                    _radioGbn = v;
                                  });
                                }),
                          ),
                          Text('포장/배달', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: ISSelect(
                        label: '업종1',
                        value: formData.itemCd1,
                        dataList: selectBox_DivCode,
                        onChange: (v) {
                          formData.itemCd1 = v;
                          //loadGunguData(v);
                        },
                        onSaved: (v) {
                          //formData.cLevel = v;
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: ISSelect(
                        label: '업종2',
                        value: formData.itemCd2,
                        dataList: selectBox_DivCode,
                        onChange: (v) {
                          formData.itemCd2 = v;
                          //loadGunguData(v);
                        },
                        onSaved: (v) {
                          //formData.cLevel = v;
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: ISSelect(
                        label: '업종3',
                        value: formData.itemCd3,
                        dataList: selectBox_DivCode,
                        onChange: (v) {
                          formData.itemCd3 = v;
                          //loadGunguData(v);
                        },
                        onSaved: (v) {
                          //formData.cLevel = v;
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      flex: 2,
                      child: ISInput(
                        value: formData.shopId ?? '',
                        readOnly: true,
                        label: '가맹점POS 아이디',
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: ISInput(
                        value: formData.shopPass ?? '',
                        label: '가맹점POS 패스워드',
                        suffixIcon: MaterialButton(
                              color: Colors.blue,
                              minWidth: 40,
                              child: Text('패스워드 초기화', style: TextStyle(color: Colors.white, fontSize: 14),),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
                              onPressed: () async {
                                FormState form = formKey.currentState;
                                if (!form.validate()) {
                                  return;
                                }

                                form.save();

                                ISConfirm(context, '비밀번호 초기화', '비밀번호를 초기화 하시겠습니까?', (context) async {
                                  if (_radioGbn == RadioGbn.gbn1) {
                                    formData.shopType = '7';
                                  } else if (_radioGbn == RadioGbn.gbn2) {
                                    formData.shopType = '5';
                                  } else if (_radioGbn == RadioGbn.gbn3) {
                                    formData.shopType = '5,7';
                                  }

                                  //print('등록 Success!!!');
                                  formData.modUCode = GetStorage().read('logininfo')['uCode'];
                                  formData.modName = GetStorage().read('logininfo')['name'];
                                  //print('formData--> '+formData.toJson().toString());

                                  formData.shopPass = 'eornfh';

                                  ShopController.to.putInfoData(int.parse(detailData.selected_mCode), detailData.selected_ccCode, formData.toJson(), context);
                                  setState(() {});

                                  formData.current = 'eornfh';

                                  Navigator.pop(context, true);
                                });
                              },
                            ),
                        onChange: (v) {
                          formData.shopPass = v;
                        },
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                  width: 850,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('첨부 이미지', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ),
                isReceiveDataEnabled == false ? Container() : Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                        child: Card(
                          color: Colors.grey.shade200,
                          clipBehavior: Clip.antiAlias,
                          child: Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        width: 80,
                                        padding: EdgeInsets.only(left: 10.0,  top: 4.0),
                                        child: Text('대표 이미지', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),)
                                    ),
                                    //SizedBox(width: 32),
                                    InkWell(
                                      child: Container(
                                        padding: EdgeInsets.only(top: 4.0),
                                        child: Visibility(
                                          child: Icon(Icons.delete_forever, size: 16, color: Colors.redAccent,),
                                          visible: RepImagePath == null ? false : true,
                                        ),
                                      ),
                                      onTap: () async {
                                        if (RepImagePath != null) {
                                          ISConfirm(context, '매장 대표 이미지 삭제', '매장 대표 이미지를 삭제합니다. \n\n계속 진행 하시겠습니까?', (context) async {
                                            await ShopController.to.putRemoveShopImage(detailData.selected_ccCode, formData.shopCd, context);
                                            setState(() {
                                              RepImagePath = null;
                                            });

                                            Navigator.pop(context);
                                          });

                                          await Future.delayed(Duration(milliseconds: 500), () {
                                            setState(() {
                                              _deleteImageFromCache();
                                            });
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                //SizedBox(height: 10),
                                InkWell(
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    child: SizedBox(
                                      width: 94,
                                      height: 92,
                                      child: RepImagePath == null
                                          ? Image.asset('assets/empty_menu.png')
                                          : Image.network(RepImagePath, gaplessPlayback: true,
                                              errorBuilder: (context, error, stackTrace) {
                                                //print('RepImagePath is Load Fail,,,\n-> ${RepImagePath}');
                                                return Image.asset('assets/empty_menu.png');
                                              },
                                          ),
                                    ),
                                  ),
                                  onTap: () {
                                    ImagePicker imagePicker = ImagePicker();
                                    imagePicker.getImage(source: ImageSource.gallery).then((file) async {
                                      await ISProgressDialog(context).show(status: '이미지 업로드중...');

                                      FileUpLoadProvider provider = FileUpLoadProvider();
                                      provider.setResource('image', file);
                                      provider.makeRepImagePostResourceRequest('4', detailData.selected_ccCode, detailData.selected_shopCode, context).then((value) async {
                                      setState(() {
                                        RepImagePath = file.path;
                                      });

                                      await Future.delayed(Duration(milliseconds: 500), () {
                                        setState(() {
                                          _deleteImageFromCache();
                                        });
                                      });

                                        await ISProgressDialog(context).dismiss();
                                      });
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                    ),
                    Flexible(
                      flex: 3,
                      child: MenuMultiImageView(detailData.selected_ccCode, formData.shopCd),
                    ),
                  ],
                ),
                Divider(height: 20),
              ],
            ),
          )
        ]
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
                  Tab(text: '매장정보',),
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
              controller: _nestedTabController,
              children: [
                Container(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),//EdgeInsets.all(8.0),
                    child: form
                ),
                Container(
                    padding: EdgeInsets.all(8.0),
                    child: getHistoryImageLog()
                )
              ],
            ),
          )
        ]
      ),
    );

    // var result = Scaffold(
    //   // appBar: AppBar(
    //   //   title: Text('가맹점 매장정보 수정'),
    //   // ),
    //   body: NestedScrollView(
    //     floatHeaderSlivers: true,
    //     headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
    //       return <Widget>[
    //         SliverAppBar(
    //           //collapsedHeight: 100.0,
    //           toolbarHeight: 0.0,
    //           //backgroundColor: Colors.white,
    //           //centerTitle: true,
    //           pinned: true,
    //           floating: true,
    //           bottom: TabBar(
    //             controller: _nestedTabController,
    //             tabs: [
    //               Tab(text: '매장정보',),
    //               Tab(text: '변경이력',)
    //             ],
    //             onTap: (v) {
    //               setState(() {
    //                 current_tabIdx = v;
    //                 //print('----- current_tabIdx: '+current_tabIdx.toString());
    //               });
    //             },
    //           ),
    //         )
    //       ];
    //     },
    //     body: TabBarView(
    //       controller: _nestedTabController,
    //       children: [form, getHistoryImageLog()],
    //     ),
    //   ),
    //   bottomNavigationBar: current_tabIdx == 0 ? buttonBar : null,
    // );
    // return result;
  }

  Widget buttonBar(){
    return Container(
        padding: EdgeInsets.only(right: 8),
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AnimatedOpacity(
              opacity: isListSaveEnabled ? 1.0 : 0.0,
              duration: Duration(seconds: 1),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.red, size: 18,),
                  Text('저장 완료', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                ],
              ),
              onEnd: (){
                setState(() {
                  isListSaveEnabled = false;
                });
              },
            ),
            SizedBox(width: 10,),
            ISButton(
              iconData: Icons.refresh,
              iconColor: Colors.white,
              tip: '갱신',
              onPressed: (){
                if (isReceiveDataEnabled == true){
                  loadImageURLData();
                  loadData();

                  setState(() {
                    _nestedTabController.index = 0;
                  });
                }
              },
            ),
            SizedBox(width: 10,),
            if (AuthUtil.isAuthEditEnabled('97') == true)
            ISButton(
              label: '저장',
              iconColor: Colors.white,
              textStyle: TextStyle(color: Colors.white),
              iconData: Icons.save,
              onPressed: () async {
                FormState form = formKey.currentState;
                if (!form.validate()) {
                  return;
                }

                form.save();

                // ISConfirm(context, '정보 변경', '변경된 정보를  저장합니다. \n\n계속 진행 하시겠습니까?',
                //     (context) async {
                // });

                if (_radioGbn == RadioGbn.gbn1) {
                  formData.shopType = '7';
                } else if (_radioGbn == RadioGbn.gbn2) {
                  formData.shopType = '5';
                } else if (_radioGbn == RadioGbn.gbn3) {
                  formData.shopType = '5,7';
                }

                //print('등록 Success!!!');
                formData.modUCode = GetStorage().read('logininfo')['uCode'];
                formData.modName = GetStorage().read('logininfo')['name'];
                //print('formData--> '+formData.toJson().toString());

                ShopController.to.putInfoData(int.parse(detailData.selected_mCode), detailData.selected_ccCode, formData.toJson(), context);


                //Navigator.pop(context, true);

                await Future.delayed(Duration(milliseconds: 500), (){
                  setState(()  {
                    isListSaveEnabled = true;
                  });

                  widget.callback();
                });

              },
            ),
          ],
        )
    );
  }

  Widget MenuMultiImageView(String ccCode, String shopCode) {
    return GridView.count(
      //padding: EdgeInsets.only(left: 10, right: 10),
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 0.85,
      children: List.generate(shopImageList.length, (index) {
        return getMultiMenuListCard(ccCode, shopCode, index);
      }),
    );
  }

  Widget getMultiMenuListCard(String ccCode, String shopCode, int index) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Colors.grey.shade200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 4.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(getImageTypeStr(shopImageList[index], index), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),),
                    width: 60,
                  ),
                  InkWell(
                    child: Container(
                        child: Visibility(child: Icon(Icons.pageview_outlined, size: 16, color: Colors.blue,), visible: _shopimgGbn[index])
                    ),
                    onTap: () async {
                      _launchInBrowser(shopImageViewList[index] +'?tm=${Utils.getTimeStamp()}');
                    },
                  ),
                  InkWell(
                    child: Container(
                        child: Visibility(
                            child: Icon(Icons.file_download, size: 16, color: Colors.blue,), visible: _shopimgGbn[index])
                    ),
                    onTap: () async {
                      showConfirm(shopImageDownList[index]);
                    },
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            child: Container(
              margin: EdgeInsets.all(10),
              child: AspectRatio(
                aspectRatio: 11 / 11,
                child: (shopImageList[index] == null || _shopimgGbn[index] == false)
                    ? Image.asset('assets/empty_menu.png')
                    : Image.network(shopImageList[index], gaplessPlayback: true,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/empty_menu.png');
                              },
                ),
              ),
            ),
            onTap: () {
              ImagePicker imagePicker = ImagePicker();
              Future<PickedFile> _imageFile = imagePicker.getImage(source: ImageSource.gallery); //imagePicker.pickImage(source: ImageSource.gallery);
              _imageFile.then((file) async {
                await ISProgressDialog(context).show(status: '이미지 업로드중...');

                FileUpLoadProvider provider = FileUpLoadProvider();

                provider.setResource('image', file);
                provider.makeRepImagePostResourceRequest((index + 1).toString(), detailData.selected_ccCode, detailData.selected_shopCode, context).then((value) async {
                  //print('------------success');

                setState(() {
                  _shopimgGbn[index] = true;
                  shopImageList[index] = file.path;
                });

                await Future.delayed(Duration(milliseconds: 500), () {
                  setState(() {
                    _deleteImageFromCache();
                  });
                });

                  await ISProgressDialog(context).dismiss();
                });
              });
              },
          ),
        ],
      ),
    );
  }

  String getImageTypeStr(String url, int index) {
    String tempStr;
    if (index == 0)
      tempStr = '사업자등록증';
    else if (index == 1)
      tempStr = '영업신고증';
    else if (index == 2)
      tempStr = '통장사본';
    else
      tempStr = '알수없음';

    return tempStr;
  }

  Future<void> _launchInBrowser(String url) async {
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

  Future _deleteImageFromCache() async {
    //await CachedNetworkImage.evictFromCache(url);

    PaintingBinding.instance.imageCache.clearLiveImages();
    PaintingBinding.instance.imageCache.clear();

    //await DefaultCacheManager().removeFile(key);
    //await DefaultCacheManager().emptyCache();
    setState(() {});
  }

  Widget getHistoryImageLog() {
    return ListView.builder(
      controller: ScrollController(),
      //padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      itemCount: imageHistoryList.length,
      itemBuilder: (BuildContext context, int index) {
        return imageHistoryList != null ? GestureDetector(
                child: Card(
                  color: Colors.white,
                  elevation: 2.0,
                  child: ListTile(
                    //leading: Text(dataList[index].siguName),
                    title: Row(
                      children: [
                        //Text('No.' + imageHistoryList[index].no.toString() ?? '--', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Container(
                            padding: EdgeInsets.only(top: 5), child: SelectableText(imageHistoryList[index].memo.toString() ?? '--', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13), showCursor: true,)),
                      ],
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(alignment: Alignment.centerRight, child: Text(imageHistoryList[index].histDate.toString() ?? '--', style: TextStyle(fontSize: 12), textAlign: TextAlign.right))
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
