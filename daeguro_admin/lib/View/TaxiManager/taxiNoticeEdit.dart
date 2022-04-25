

import 'package:daeguro_admin_app/Editor/editor.dart';
import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/ISWidget/is_select_date.dart';
import 'package:daeguro_admin_app/Model/noticeDetailModel.dart';
import 'package:daeguro_admin_app/Model/taxi/notice/taxiNoticeDetailModel.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/View/NoticeManager/noticeFileUpload.dart';
import 'package:daeguro_admin_app/View/NoticeManager/notice_controller.dart';

import 'package:daeguro_admin_app/Network/FileUpLoader.dart';
import 'package:daeguro_admin_app/constants/serverInfo.dart';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class TaxiNoticeEdit extends StatefulWidget {
  final taxiNoticeDetailModel sData;

  const TaxiNoticeEdit({
    Key key,
    this.sData,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TaxiNoticeEditState();
  }
}

class TaxiNoticeEditState extends State<TaxiNoticeEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  taxiNoticeDetailModel editData;

  List<SelectOptionVO> selectBox_noticeGbn = List();
  List<SelectOptionVO> selectBox_noticeService = List();

  String _couponCnt;
  String _fromDate;
  String _toDate;
  String _htmlText;

  var _file;

  @override
  void dispose(){
    selectBox_noticeGbn.clear();
    editData = null;

    PaintingBinding.instance.imageCache.clearLiveImages();
    PaintingBinding.instance.imageCache.clear();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Get.put(NoticeController());

    selectBox_noticeGbn.clear();

    selectBox_noticeGbn.add(new SelectOptionVO(value: '1', label: '공지'));
    selectBox_noticeGbn.add(new SelectOptionVO(value: '2', label: '공지(사장님)'));
    selectBox_noticeGbn.add(new SelectOptionVO(value: '3', label: '이벤트'));
    selectBox_noticeGbn.add(new SelectOptionVO(value: '4', label: '이벤트(사장님)'));
    selectBox_noticeGbn.add(new SelectOptionVO(value: '5', label: '메인팝업'));
    selectBox_noticeGbn.add(new SelectOptionVO(value: '6', label: '메인팝업(사장님)'));
    selectBox_noticeGbn.add(new SelectOptionVO(value: '7', label: '시정홍보'));

    selectBox_noticeService.clear();

    // selectBox_noticeService.add(new SelectOptionVO(value: '1', label: '서비스'));
    selectBox_noticeService.add(new SelectOptionVO(value: '2', label: '주문'));
    selectBox_noticeService.add(new SelectOptionVO(value: '3', label: '택시'));
    selectBox_noticeService.add(new SelectOptionVO(value: '4', label: '꽃배달'));
    selectBox_noticeService.add(new SelectOptionVO(value: '5', label: '퀵'));
    selectBox_noticeService.add(new SelectOptionVO(value: '6', label: '대리'));

    if (widget.sData != null) {
      editData = new taxiNoticeDetailModel();
      editData = widget.sData;

      _fromDate = editData.dispFromDate.replaceAll('.', '');
      _toDate = editData.dispToDate.replaceAll('.', '');

      if (editData.noticeUrl_1 == '')
        editData.noticeUrl_1 = null;
      else
        editData.noticeUrl_1 =
        //'http://192.168.30.98:8426/admin/Image/thumb?div=E&file_name=' + editData.noticeUrl_1;
        //'http://dgpub.282.co.kr:8426/EventImage/' + editData.noticeUrl_1;
        ServerInfo.REST_IMG_BASEURL + '/api/Image/thumb?div=E&file_name=' + editData.noticeUrl_1;
      //ServerInfo.REST_IMG_BASEURL + '/event-images/' + editData.noticeUrl_1;
    }
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: new BoxDecoration(
                      color: editData.dispGbn == 'Y' ? Colors.blue[200] : Colors.red[200],
                      borderRadius: new BorderRadius.circular(6)),
                  child: SwitchListTile(
                    dense: true,
                    value: editData.dispGbn == 'Y' ? true : false,
                    title: Text('게시 유무', style: TextStyle(fontSize: 12, color: Colors.white),),
                    onChanged: (v) {
                      setState(() {
                        editData.dispGbn = v ? 'Y' : 'N';
                        formKey.currentState.save();
                      });
                    },
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: ISSelect(
                  ignoring: true,
                  label: '구분',
                  value: editData.noticeGbn,
                  dataList: selectBox_noticeGbn,
                  onChange: (value) {
                    setState(() {
                      editData.noticeGbn = value;
                      formKey.currentState.save();
                    });
                  },
                ),
              )
            ],
          ),
          // Flexible(
          //   flex: 1,
          //   child: ISSelect(
          //     label: '서비스',
          //     value: editData.noticeService,
          //     dataList: selectBox_noticeService,
          //     onChange: (value) {
          //       setState(() {
          //         editData.noticeService = value;
          //         formKey.currentState.save();
          //       });
          //     },
          //   ),
          // ),
          Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: ISSelectDate(
                  context,
                  label: '시작일',
                  value: editData.dispFromDate.replaceAll('.', '-'),
                  onTap: () async {
                    DateTime valueDt = DateTime.now();
                    final DateTime picked = await showDatePicker(
                      context: context,
                      initialDate: valueDt,
                      firstDate: DateTime(1900, 1),
                      lastDate: DateTime(2031, 12),
                    );

                    setState(() {
                      if (picked != null) {
                        editData.dispFromDate =
                            formatDate(picked, [yyyy, '-', mm, '-', dd]);

                        _fromDate = formatDate(picked, [yyyy, '', mm, '', dd]);
                      }
                    });

                    formKey.currentState.save();
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: ISSelectDate(
                  context,
                  label: '종료일',
                  value: editData.dispToDate.replaceAll('.', '-'),
                  onTap: () async {
                    DateTime valueDt = DateTime.now();
                    final DateTime picked = await showDatePicker(
                      context: context,
                      initialDate: valueDt,
                      firstDate: DateTime(1900, 1),
                      lastDate: DateTime(2031, 12),
                    );

                    setState(() {
                      if (picked != null) {
                        editData.dispToDate =
                            formatDate(picked, [yyyy, '-', mm, '-', dd]);
                        _toDate = formatDate(picked, [yyyy, '', mm, '', dd]);
                      }
                    });
                    formKey.currentState.save();
                  },
                ),
              ),
            ],
          ),
          ISInput(
            value: editData.noticeTitle,
            autofocus: true,
            context: context,
            label: '제목',
            onSaved: (v) {
              editData.noticeTitle = v;
            },
            validator: (v) {
              return v.isEmpty ? '[필수] 제목' : null;
            },
          ),
          ISInput(
            value: _htmlText,
            context: context,
            readOnly: true,
            label: '내용(HTML 태그)',
            maxLines: 24,
            height: 300,
            keyboardType: TextInputType.multiline,
            suffixIcon: Container(
              width: 30,
              height: 100,
              alignment: Alignment.center,
              child: IconButton(
                splashRadius: 10,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => Dialog(
                      child: IsEditor(htmlText: _htmlText),
                    ),
                  ).then((v) async {
                    if (v != null) {
                      //loadData();

                      print(v);
                      setState(() {
                        _htmlText = v;
                      });
                    }
                  });
                },
                icon: Icon(
                  Icons.note_alt,
                  color: Colors.blue,
                  size: 30,
                ),
                tooltip: '편집기',
              ),
            ),
            onSaved: (v) {
              _htmlText = v;
            },
          ),
          ISInput(
            value: editData.noticeUrl_2,
            context: context,
            label: 'URL주소',
            suffixIcon: MaterialButton(
              color: Colors.blue,
              minWidth: 40,
              child: Text('HTML업로드', style: TextStyle(color: Colors.white, fontSize: 14),),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                    child: NoticeFileUpload(),
                  ),
                ).then((v) async {
                  if (v != null){
                    print('upLoad result:${v.toString()}');
                    //loadData();
                    setState(() {
                      editData.noticeUrl_2 = v;
                    });
                  }
                });
              },
            ),
            onSaved: (v) {
              editData.noticeUrl_2 = v;
            },
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              children: [
                Text('게시 이미지', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54),),
                Container(
                  margin: EdgeInsets.all(8.0),
                  child: InkWell(
                    child: editData.noticeUrl_1 == null
                        ? Image.asset('assets/empty_menu.png', width: 150, height: 150,)
                        : Image.network(editData.noticeUrl_1, gaplessPlayback: true, fit: BoxFit.fill, width: 440, height: 150,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/empty_menu.png', width: 150, height: 150,);
                      },
                    ),
                    onTap: () {
                      ImagePicker imagePicker = ImagePicker();
                      Future<PickedFile> _imageFile = imagePicker.getImage(source: ImageSource.gallery);
                      _imageFile.then((file) async {
                        editData.noticeUrl_1 = file.path;
                        //dataMenuList[index].fileSrc = file;

                        _file = file;

                        await Future.delayed(Duration(milliseconds: 500), () {
                          setState(() {
                            _deleteImageFromCache();
                          });
                        });

                        formKey.currentState.save();
                        setState(() {});
                      });
                    },
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
        if (AuthUtil.isAuthEditEnabled('81') == true)
          ISButton(
            label: '저장',
            iconData: Icons.save,
            onPressed: () async {
              FormState form = formKey.currentState;
              if (!form.validate()) {
                return;
              }

              form.save();

              editData.dispFromDate = _fromDate;
              editData.dispToDate = _toDate;
              editData.modUCode = GetStorage().read('logininfo')['uCode'];
              editData.modName = GetStorage().read('logininfo')['name'];

              editData.noticeUrl_2 = editData.noticeUrl_2.replaceAll(' ', '');

              FileUpLoadProvider provider = FileUpLoadProvider();
              provider.setResource('image', _file);
              provider.makeNoticePutResourceRequest(
                  editData.noticeSeq,
                  editData.noticeGbn,
                  editData.dispGbn,
                  editData.dispFromDate,
                  editData.dispToDate,
                  editData.noticeTitle,
                  editData.noticeContents,
                  editData.noticeUrl_1,
                  editData.noticeUrl_2,
                  editData.orderDate,
                  editData.modUCode,
                  editData.modName,
                  editData.extUrlYn
              );

              await Future.delayed(Duration(milliseconds: 500), () {
                setState(() {
                  _deleteImageFromCache();
                });
              });

              formKey.currentState.save();
              setState(() {});

              Navigator.pop(context, true);
            },
          ),
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
        title: Text('공지사항&이벤트 수정'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: form
            ),
          ],
        ),
      ),
      bottomNavigationBar: buttonBar,
    );
    return SizedBox(
      width: 500,
      height: 870,
      child: result,
    );
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
