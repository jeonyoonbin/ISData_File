@JS()
library javascript_bundler;

import 'dart:convert';


import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:daeguro_admin_app/Model/imageList.dart';
import 'package:daeguro_admin_app/View/ShopManager/Menu/shopMenu_main.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:js/js.dart';
import 'package:flutter/material.dart';


import 'package:daeguro_admin_app/ISWidget/is_button.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' show AnchorElement;

@JS('downloadImg')
external void showConfirm(var _uri);

class ShopImagePre extends StatefulWidget {
  final String ccCode;
  final String shopCode;

  const ShopImagePre({Key key, this.ccCode, this.shopCode})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShopImagePreState();
  }
}

class ShopImagePreState extends State<ShopImagePre> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final List<ImageList> dataList = <ImageList>[];

  List<Object> menuMultiImageList = List<Object>();

  List<Object> shopRepresentImageList = List<Object>();
  List<Object> menuBoardImageList = List<Object>();

  loadData() async {
    //print('call loadData() ');

    dataList.clear();

    await ShopController.to.getImageData(widget.shopCode).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        value.forEach((e) {
          ImageList temp = ImageList.fromJson(e);
          dataList.add(temp);

          menuMultiImageList.add('Add Image');
        });
      }
    });

    //if (this.mounted) {
      setState(() {

      });
    //}

    await Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _deleteImageFromCache();
      });
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((c) {
      loadData();
    });
  }

  @override
  void dispose() {
    super.dispose();

    PaintingBinding.instance.imageCache.clearLiveImages();
    PaintingBinding.instance.imageCache.clear();
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              MenuMultiImageView(),
            ],
          ),
          Divider(
            height: 40,
          ),
        ],
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
        title: Text('가맹점 이미지 현황'),
        actions: [
          ISButton(
            iconData: Icons.save,
            iconColor: Colors.white,
            label: '완료처리',
            textStyle: TextStyle(color: Colors.white),
            onPressed: () {
              ShopController.to.putImageStatus(widget.shopCode, '3', context);
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            form,
          ],
        ),
      ),
      bottomNavigationBar: buttonBar,
    );
    return SizedBox(
      width: 980,
      height: 580,
      child: result,
    );
  }

  Widget MenuMultiImageView() {
    return GridView.count(
      padding: EdgeInsets.only(left: 10, right: 10),
      shrinkWrap: true,
      crossAxisCount: 5,
      childAspectRatio: 0.9,
      children: List.generate(menuMultiImageList.length, (index) {
        return getMultiMenuListCard(widget.ccCode, widget.shopCode, index);
      }),
    );
  }

  Widget getMultiMenuListCard(String ccCode, String shopCode, int index) {
    String thumbImageUrl = ServerInfo.REST_IMG_BASEURL +
        '/api/Image/thumb?div=O&cccode=$ccCode&shop_cd=$shopCode&file_name=' +
        dataList[index].fileName +
        '&width=180&height=110';

    //String thumbImageUrl = ServerInfo.REST_IMG_BASEURL + '/images/$ccCode/$shopCode/'+dataList[index].fileName;

    // String thumbImageUrl = ServerInfo.REST_IMG_BASEURL +
    //     '/images/' +
    //     ccCode +
    //     '/' +
    //     shopCode +
    //     '/' +
    //     dataList[index].fileName;

    //print(thumbImageUrl);
    var downloadImageUrl = '/origin-images/$ccCode/$shopCode/' + dataList[index].fileName;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              child: Row(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 10),
              InkWell(
                child: Container(
                    color: Colors.blue,
                    child: Icon(Icons.reorder, size: 16, color: Colors.white,)
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => Dialog(
                      child: ShopMenuMain(
                        ccCode: widget.ccCode,
                        shopCode: widget.shopCode,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                child: Container(
                    color: Colors.blue,
                    child: Icon(Icons.file_download, size: 16, color: Colors.white,)
                ),
                onTap: () async {
                  if (AuthUtil.isAuthDownloadEnabled('7') == false){
                    ISAlert(context, '다운로드 권한이 없습니다. \n\n관리자에게 문의 바랍니다');
                    return;
                  }
                    
                  showConfirm(downloadImageUrl);
                  //fileDownload(downloadImageUrl, dataList[index].fileName);
                  // await fileDownload(downloadImageUrl, dataList[index].fileName);
                  // setState(() {
                  //
                  //   //_onAddMenuMultiImageClick(index);
                  // });
                },
              ),
            ],
          )),
          AspectRatio(
            aspectRatio: 18 / 11,
            child: Image.network(
              thumbImageUrl,
              fit: BoxFit.fitWidth,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/empty_menu.png');
              },
            ), //div: o=가공전, p=가공후,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(dataList[index].menuName, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                      Text(dataList[index].insertDate, style: TextStyle(fontSize: 10),),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    // return Container(
    //   child: Column(
    //     children: [
    //       Container(
    //         child: Text(dataList[index].menuName, style: TextStyle(fontSize: 14),),
    //       ),
    //       Card(clipBehavior: Clip.antiAlias,
    //           child: Stack(
    //             children: <Widget>[
    //
    //               Container(
    //                 padding: EdgeInsets.all(16),
    //                 child: Image.network(thumbImageUrl, width: 150, height: 150,),//div: o=가공전, p=가공후
    //               ),
    //               Positioned(right: 5, top: 5,
    //                 child: InkWell(
    //                   child: Icon(Icons.reorder, size: 20, color: Colors.blue,),
    //                   onTap: (){
    //                     showDialog(
    //                       context: context,
    //                       builder: (BuildContext context) => Dialog(
    //                         child: ShopAccountMenuManager(
    //                           ccCode: widget.ccCode, shopCode: widget.shopCode,),
    //                       ),
    //                     );
    //                   },
    //                 ),
    //               ),
    //               Positioned(left:36, bottom: 3,
    //                 child: Text(dataList[index].insertDate, style: TextStyle(fontSize: 10),),
    //               ),
    //               Positioned(right: 5, bottom: 5,
    //                 child: InkWell(
    //                   child: Container(
    //                       color: Colors.blue,
    //                       child: Icon(Icons.file_download, size: 20, color: Colors.white,)),
    //                   onTap: () async{
    //                     showConfirm(downloadImageUrl);
    //                     // await fileDownload(downloadImageUrl, dataList[index].fileName);
    //                     // setState(() {
    //                     //
    //                     //   //_onAddMenuMultiImageClick(index);
    //                     // });
    //                   },
    //                 ),
    //               ),
    //             ],
    //           )
    //       ),
    //     ],
    //   ),
    // );
  }

  void fileDownload(String url, String filename) async {
    //print('fileDownload url: ' + url);

    // print('check1');
    // http.Client Client = new http.Client();
    // print('check2');
    // var request = await Client.get(Uri.parse(url));
    // print('check3');
    // var bytes = await request.bodyBytes;
    //
    // print('check5');
    // String dir = (await getApplicationDocumentsDirectory()).path;
    // File file = new File('$dir/$filename');
    // await file.writeAsBytes(bytes);

    await http.get(url).then((http.Response response) {
      var bytes = response.bodyBytes;

      AnchorElement(href:'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
        ..setAttribute('download', filename)
        ..click();
    });

    //return file;
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
