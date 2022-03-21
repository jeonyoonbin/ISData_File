@JS()
library javascript_bundler;

import 'dart:async';

import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';

import 'package:daeguro_admin_app/Model/serviceRequestDetail.dart';
import 'package:daeguro_admin_app/Model/shop/shopImageHistory.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/ReviewManager/reviewManager_controller.dart';
import 'package:js/js.dart';

import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

@JS('downloadImg')
external void showConfirm(var _uri);

class ReviewImage extends StatefulWidget {
  final String shop_cd;
  final int seq;

  //final ShopInfo sData;
  const ReviewImage({Key key, this.shop_cd, this.seq}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ReviewImageState();
  }
}

class ReviewImageState extends State<ReviewImage> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ServiceRequestDetail formData = ServiceRequestDetail();

  String RepImagePath;

  String _image1 = ' ';
  String _image2 = ' ';
  String _image3 = ' ';

  List<String> shopImageList = [];
  List<String> shopImageDownList = [];
  List<String> shopImageViewList = [];
  int errorcnt = 0;

  List<SelectOptionVO> selectBox_DivCode = [];

  final List<ShopImageHistoryModel> imageHistoryList = <ShopImageHistoryModel>[];

  int current_tabIdx = 0;

  loadData() async {
    await ReviewController.to.getDetail(widget.seq.toString(), context).then((value) {
      if (this.mounted) {
        if (value == null) {
          ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
        } else {
          setState(() {
            _image1 = value['FILE_IMG_1'];
            _image2 = value['FILE_IMG_2'];
            _image3 = value['FILE_IMG_3'];
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    PaintingBinding.instance.imageCache.clearLiveImages();
    PaintingBinding.instance.imageCache.clear();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((c) {
      setState(() {
        loadData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Center(
        child: Wrap(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Card(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 100,
                              child: Text(
                                '첨부 이미지1',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Visibility(
                              visible: _image1 == null ? false : true,
                              child: InkWell(
                                child: Container(
                                    width: 30,
                                    child: Icon(
                                      Icons.pageview_outlined,
                                      size: 20,
                                      color: Colors.blue,
                                    )),
                                onTap: () async {
                                  _launchInBrowser('https://review.daeguro.co.kr:45008/review-images/' + widget.shop_cd + '/' + _image1 + '?tm=${Utils.getTimeStamp()}');
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        InkWell(
                            child: SizedBox(
                              width: 150,
                              height: 150,
                              child: _image1 == null
                                  ? Image.asset('assets/empty_menu.png')
                                  : Image.network(
                                '/review-thum-images/' + widget.shop_cd + '/thumb_' + _image1 + '?tm=${Utils.getTimeStamp()}',
                                gaplessPlayback: true,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset('assets/empty_menu.png');
                                },
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 100,
                              child: Text(
                                '첨부 이미지2',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Visibility(
                              visible: _image2 == null ? false : true,
                              child: InkWell(
                                child: Container(
                                    width: 30,
                                    child: Icon(
                                      Icons.pageview_outlined,
                                      size: 20,
                                      color: Colors.blue,
                                    )),
                                onTap: () async {
                                  _launchInBrowser('https://review.daeguro.co.kr:45008/review-images/' + widget.shop_cd + '/' + _image2 + '?tm=${Utils.getTimeStamp()}');
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        InkWell(
                            child: SizedBox(
                              width: 150,
                              height: 150,
                              child: _image2 == null
                                  ? Image.asset('assets/empty_menu.png')
                                  : Image.network(
                                '/review-thum-images/' + widget.shop_cd + '/thumb_' + _image2 + '?tm=${Utils.getTimeStamp()}',
                                gaplessPlayback: true,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset('assets/empty_menu.png');
                                },
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 100,
                              child: Text(
                                '첨부 이미지3',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ),
                            InkWell(
                              child: Visibility(
                                visible: _image3 == null ? false : true,
                                child: Container(
                                    width: 30,
                                    child: Icon(
                                      Icons.pageview_outlined,
                                      size: 20,
                                      color: Colors.blue,
                                    )),
                              ),
                              onTap: () async {
                                _launchInBrowser('https://review.daeguro.co.kr:45008/review-images/' + widget.shop_cd + '/' + _image3 + '?tm=${Utils.getTimeStamp()}');
                              },
                            ),
                            // InkWell(
                            //   child: Container(
                            //     child: Icon(
                            //       Icons.file_download,
                            //       size: 20,
                            //       color: Colors.blue,
                            //     ),
                            //   ),
                            //   onTap: () async {
                            //     showConfirm(_image_url);
                            //   },
                            // ),
                          ],
                        ),
                        SizedBox(height: 5),
                        InkWell(
                            child: SizedBox(
                              width: 150,
                              height: 150,
                              child: _image3 == null
                                  ? Image.asset('assets/empty_menu.png')
                                  : Image.network(
                                '/review-thum-images/' + widget.shop_cd + '/thumb_' + _image3 + '?tm=${Utils.getTimeStamp()}',
                                gaplessPlayback: true,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset('assets/empty_menu.png');
                                },
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    ButtonBar buttonBar = ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        ISButton(
          label: '닫기',
          iconData: Icons.cancel,
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );

    var result = Scaffold(
      appBar: AppBar(
        title: Text('첨부 이미지 조회'),
      ),
      body: form,
      bottomNavigationBar: current_tabIdx == 0 ? buttonBar : null,
    );
    return SizedBox(
      width: 560,
      height: 400,
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