import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/ISWidget/is_select_date.dart';
import 'package:daeguro_admin_app/Model/noticeDetailModel.dart';
import 'package:daeguro_admin_app/Model/shop/shopReviewImageModel.dart';
import 'package:daeguro_admin_app/Network/FileUpLoader.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/NoticeManager/noticeFileUpload.dart';
import 'package:daeguro_admin_app/View/NoticeManager/notice_controller.dart';

import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopReviewImage extends StatefulWidget {
  final String shopCd;
  final String ccCode;

  const ShopReviewImage({Key key, this.shopCd, this.ccCode}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShopReviewImageState();
  }
}

class ShopReviewImageState extends State<ShopReviewImage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ShopReviewImageModel reviewImageData = ShopReviewImageModel();

  String Url_1 = '';
  String Url_2 = '';

  String DetailUrl_1 = '';
  String DetailUrl_2 = '';

  loadData() async {
    await ShopController.to.getShopReserveReviewImage(widget.shopCd).then((value) {
      //print('value:${value.toString()}');
      // 이미지 변경내역
      // value.forEach((element) {
      //   ShopReviewImageModel imageData = ShopReviewImageModel.fromJson(element);
      // });
      if (value != null && value.toString() != '[]'){
        ShopReviewImageModel imageData1 = ShopReviewImageModel.fromJson(value[0]);
        Url_1 = '/shopinfo-images/${widget.ccCode}/${widget.shopCd}/${imageData1.fileName}';
        DetailUrl_1 = imageData1.fileUrl;

        ShopReviewImageModel imageData2 = ShopReviewImageModel.fromJson(value[1]);
        Url_2 = '/shopinfo-images/${widget.ccCode}/${widget.shopCd}/${imageData2.fileName}';
        DetailUrl_2 = imageData2.fileUrl;
      }
    });

    setState(() {});
  }

  @override
  void dispose() {
    PaintingBinding.instance.imageCache.clearLiveImages();
    PaintingBinding.instance.imageCache.clear();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Get.put(ShopController());

    loadData();
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  color: Colors.grey.shade200,
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width: 110,
                                child: Text(
                                  '이미지1',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                )),
                            InkWell(
                              child: Container(
                                  child: Visibility(
                                      child: Icon(
                                        Icons.pageview_outlined,
                                        size: 18,
                                        color: Colors.blue,
                                      ),
                                      visible: DetailUrl_1 == '' ? false : true)),
                              onTap: () async {
                                _launchInBrowser(DetailUrl_1 + '?tm=${Utils.getTimeStamp()}');
                              },
                            ),
                            SizedBox(width: 5),
                            InkWell(
                              child: Container(
                                child: Visibility(
                                  child: Icon(
                                    Icons.delete_forever,
                                    size: 18,
                                    color: Colors.redAccent,
                                  ),
                                  visible: DetailUrl_1 == '' ? false : true,
                                ),
                              ),
                              onTap: () async {
                                if (DetailUrl_1 != null) {
                                  ISConfirm(context, '이미지 삭제', '이미지를 삭제합니다. \n계속 진행 하시겠습니까?', (context) async {
                                    await ShopController.to.deleteShopReserveReviewImage(widget.ccCode, widget.shopCd, '1', context);
                                    setState(() {
                                      Url_1 = '';
                                      DetailUrl_1 = '';
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
                        SizedBox(height: 10),
                        SizedBox(
                          height: 150,
                          width: 150,
                          child: InkWell(
                            child: Url_1 == ''
                                ? Image.asset(
                                    'assets/empty_menu.png',
                                    width: 150,
                                    height: 150,
                                  )
                                : Image.network(
                                    Url_1,
                                    gaplessPlayback: true,
                                    fit: BoxFit.fill,
                                    width: 440,
                                    height: 150,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/empty_menu.png',
                                        width: 150,
                                        height: 150,
                                      );
                                    },
                                  ),
                            onTap: () {
                              ImagePicker imagePicker = ImagePicker();
                              imagePicker.getImage(source: ImageSource.gallery).then((file) async {
                                await ISProgressDialog(context).show(status: '이미지 업로드중...');

                                FileUpLoadProvider provider = FileUpLoadProvider();
                                provider.setResource('image', file);
                                provider.makeReserShopReviewPostResourceRequest(widget.ccCode, widget.shopCd, '1').then((value) async {
                                  loadData();
                                  setState(() {
                                    Url_1 = file.path;
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
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Card(
                  color: Colors.grey.shade200,
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width: 110,
                                child: Text(
                                  '이미지2',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                )),
                            InkWell(
                              child: Container(
                                  child: Visibility(
                                      child: Icon(
                                        Icons.pageview_outlined,
                                        size: 18,
                                        color: Colors.blue,
                                      ),
                                      visible: DetailUrl_2 == '' ? false : true)),
                              onTap: () async {
                                _launchInBrowser(DetailUrl_2 + '?tm=${Utils.getTimeStamp()}');
                              },
                            ),
                            SizedBox(width: 5),
                            InkWell(
                              child: Container(
                                child: Visibility(
                                  child: Icon(
                                    Icons.delete_forever,
                                    size: 18,
                                    color: Colors.redAccent,
                                  ),
                                  visible: DetailUrl_2 == '' ? false : true,
                                ),
                              ),
                              onTap: () async {
                                if (DetailUrl_2 != null) {
                                  ISConfirm(context, '이미지 삭제', '이미지를 삭제합니다. \n계속 진행 하시겠습니까?', (context) async {
                                    await ShopController.to.deleteShopReserveReviewImage(widget.ccCode, widget.shopCd, '2', context);
                                    setState(() {
                                      Url_2 = '';
                                      DetailUrl_2 = '';
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
                        SizedBox(height: 10),
                        SizedBox(
                          height: 150,
                          width: 150,
                          child: InkWell(
                            child: Url_2 == ''
                                ? Image.asset(
                                    'assets/empty_menu.png',
                                    width: 150,
                                    height: 150,
                                  )
                                : Image.network(
                                    Url_2,
                                    gaplessPlayback: true,
                                    fit: BoxFit.fill,
                                    width: 440,
                                    height: 150,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/empty_menu.png',
                                        width: 150,
                                        height: 150,
                                      );
                                    },
                                  ),
                            onTap: () {
                              ImagePicker imagePicker = ImagePicker();
                              imagePicker.getImage(source: ImageSource.gallery).then((file) async {
                                await ISProgressDialog(context).show(status: '이미지 업로드중...');

                                FileUpLoadProvider provider = FileUpLoadProvider();
                                provider.setResource('image', file);
                                provider.makeReserShopReviewPostResourceRequest(widget.ccCode, widget.shopCd, '2').then((value) async {
                                  loadData();
                                  setState(() {
                                    Url_2 = file.path;
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
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    ButtonBar buttonBar = ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        ISButton(
          label: '취소',
          iconData: Icons.cancel,
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );

    var result = Scaffold(
      appBar: AppBar(
        title: Text('[예약] 리뷰 알림 이미지 등록'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Container(padding: EdgeInsets.symmetric(horizontal: 8.0), child: form),
          ],
        ),
      ),
      bottomNavigationBar: buttonBar,
    );
    return SizedBox(
      width: 420,
      height: 320,
      child: result,
    );
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
}
