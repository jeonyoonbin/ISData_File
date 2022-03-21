

import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/Model/noticeDetailModel.dart';
import 'package:daeguro_admin_app/View/NoticeManager/notice_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class DashboardNoticePopup extends StatefulWidget {
  final noticeDetailModel sData;

  const DashboardNoticePopup({Key key, this.sData,}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DashboardNoticePopupState();
  }
}

class DashboardNoticePopupState extends State<DashboardNoticePopup> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  noticeDetailModel editData;

  @override
  void dispose(){
    super.dispose();

    PaintingBinding.instance.imageCache.clearLiveImages();
    PaintingBinding.instance.imageCache.clear();
  }

  @override
  void initState() {
    super.initState();

    Get.put(NoticeController());

    if (widget.sData != null) {
      editData = new noticeDetailModel();
      editData = widget.sData;

      if (editData.noticeUrl_1 == '')
        editData.noticeUrl_1 = null;
      else
        editData.noticeUrl_1 = ServerInfo.REST_IMG_BASEURL + '/event-images/' + editData.noticeUrl_1;//'/api/Image/thumb?div=E&file_name=' + editData.noticeUrl_1;

      //print('editData.noticeUrl_1: ${editData.noticeUrl_1}');
    }
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                // Container(
                //   child: editData.noticeUrl_1 == null
                //         ? Image.asset('assets/empty_menu.png')
                //         : Image.network(editData.noticeUrl_1, fit: BoxFit.fitWidth,
                //                   errorBuilder: (context, error, stackTrace) {
                //                     print('image load error -> ${editData.noticeUrl_1}');
                //                     return Image.asset('assets/empty_menu.png');
                //                   },
                //     ),
                // ),
                AspectRatio(
                  aspectRatio: 18 / 11,
                  child: editData.noticeUrl_1 == null
                      ? Image.asset('assets/empty_menu.png')
                      : Image.network(editData.noticeUrl_1, fit: BoxFit.fitWidth,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset('assets/empty_menu.png');
                        },
                      ), //div: o=가공전, p=가공후,
                ),
                SizedBox(height: 10),
                Align(alignment: Alignment.centerLeft, child: Text('  [제목]', style: TextStyle(fontSize: 13, color: Colors.black38)),),
                Align(alignment: Alignment.centerLeft, child: SelectableText('  ' + editData.noticeTitle ?? '--', showCursor: true, style: TextStyle(fontSize: 13)),),
                SizedBox(height: 10),
                Align(alignment: Alignment.centerLeft, child: Text('  [기간]', style: TextStyle(fontSize: 13, color: Colors.black38)),),
                Align(alignment: Alignment.centerLeft, child: SelectableText('  ' + editData.dispFromDate.toString() + ' ~ '+ editData.dispToDate.toString(), showCursor: true, style: TextStyle(fontSize: 13)),),
                SizedBox(height: 10),
                Align(alignment: Alignment.centerLeft, child: Text('  [내용]', style: TextStyle(fontSize: 13, color: Colors.black38)),),
                Align(alignment: Alignment.centerLeft, child: SelectableText('  ' + editData.noticeContents ?? '--', showCursor: true, style: TextStyle(fontSize: 13)),),
                SizedBox(height: 10),
                Align(alignment: Alignment.centerLeft, child: Text('  [URL]', style: TextStyle(fontSize: 13, color: Colors.black38)),),
                Align(alignment: Alignment.centerLeft, child: SelectableText('  ' + editData.noticeUrl_2 ?? '--', showCursor: true, style: TextStyle(fontSize: 13)),),
                SizedBox(height: 30),
              ],
            ),
          )
        ],
      ),
    );

    ButtonBar buttonBar = ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        ISButton(
          label: '닫기',
          iconData: Icons.close,
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );

    var result = Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(_getNoticeGbn(editData.noticeGbn), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            form,
          ],
        ),
      ),
      bottomNavigationBar: buttonBar,
    );
    return SizedBox(
      width: 440,
      height: 600,//isDisplayDesktop(context) ? 600 : 800,
      child: result,
    );
  }

  String _getNoticeGbn(String value) {
    String retValue = '--';

    if (value.toString().compareTo('1') == 0)
      retValue = '공지';
    else if (value.toString().compareTo('3') == 0) retValue = '이벤트';

    return retValue;
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
