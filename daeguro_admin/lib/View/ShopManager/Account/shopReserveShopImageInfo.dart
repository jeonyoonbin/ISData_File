import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/ISWidget/is_select_date.dart';
import 'package:daeguro_admin_app/Model/noticeDetailModel.dart';
import 'package:daeguro_admin_app/Model/shop/shopReserveImageModel.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/NoticeManager/noticeFileUpload.dart';
import 'package:daeguro_admin_app/View/NoticeManager/notice_controller.dart';

import 'package:daeguro_admin_app/Network/FileUpLoader.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopReserveShopImageInfo extends StatefulWidget {
  final String shopCd;
  final String ccCode;

  const ShopReserveShopImageInfo({Key key, this.shopCd, this.ccCode}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShopReserveShopImageInfoState();
  }
}

class ShopReserveShopImageInfoState extends State<ShopReserveShopImageInfo> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final List<ShopReserveImageModel> dataImageList = <ShopReserveImageModel>[];

  loadData() async {
    dataImageList.clear();

    //await ShopController.to.getShopInfoImage(widget.shopCd);

    await ShopController.to.getShopReserveImage(widget.shopCd, context).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        value.forEach((element) {
          ShopReserveImageModel tempData = ShopReserveImageModel.fromJson(element);
          dataImageList.add(tempData);
        });
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
    dataImageList.clear();

    Get.put(ShopController());

    WidgetsBinding.instance.addPostFrameCallback((c) {
      loadData();
    });
  }

  Widget MenuMultiImageView() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 4,
      childAspectRatio: 0.9,
      children: List.generate(dataImageList.length, (index) {
        return getImageListView(index);
      }),
    );
  }

  Widget getImageListView(int index) {
    return Card(
      color: Colors.white,
      child: ListTile(
        //leading: Text(dataList[index].siguName),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.pageview_outlined,
                          size: 18,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    _launchInBrowser(dataImageList[index].fileUrl + '?tm=${Utils.getTimeStamp()}');
                  },
                ),
                SizedBox(width: 5),
                InkWell(
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.delete_forever,
                          size: 18,
                          color: Colors.redAccent,
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    if (dataImageList[index].fileName != null) {
                      ISConfirm(context, '이미지 삭제', '이미지를 삭제합니다. \n계속 진행 하시겠습니까?', (context) async {
                        await ShopController.to.deleteShopInfoImage(widget.ccCode, widget.shopCd, dataImageList[index].seq.toString(), context);

                        loadData();
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
            SizedBox(height: 5),
            Image.network('/shopinfo-images/${widget.ccCode}/${widget.shopCd}/' + dataImageList[index].fileName,
              gaplessPlayback: true,
              fit: BoxFit.fill,
              width: 120,
              height: 120,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/empty_menu.png', width: 120, height: 120);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ButtonBar buttonBar = ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        ISButton(
          label: '등록',
          iconData: Icons.add,
          onPressed: () {
            ImagePicker imagePicker = ImagePicker();
            imagePicker.getImage(source: ImageSource.gallery).then((file) async {
              await ISProgressDialog(context).show(status: '이미지 업로드중...');

              FileUpLoadProvider provider = FileUpLoadProvider();
              provider.setResource('image', file);
              provider.makeReserShopImagePostResourceRequest(widget.ccCode, widget.shopCd).then((value) async {
                loadData();

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
        title: Text('[예약] 매장 알림 이미지 등록'),
      ),
      body: dataImageList.length != 0 ? MenuMultiImageView() : Container(
        alignment: Alignment.center,
        child: Text('등록된 이미지가 없습니다.', style: TextStyle(color: Colors.black54),)
      ),
      bottomNavigationBar: buttonBar,
    );
    return SizedBox(
      width: 640,
      height: 600,
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