

import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/ISWidget/is_select_date.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/Model/noticeDetailModel.dart';
import 'package:daeguro_admin_app/Model/reserNoticeDetailModel.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
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

class ReserNoticeEdit extends StatefulWidget {
  final ReserNoticeDetailModel sData;

  const ReserNoticeEdit({
    Key key,
    this.sData,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ReserNoticeEditState();
  }
}

class ReserNoticeEditState extends State<ReserNoticeEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ReserNoticeDetailModel editData;

  List<SelectOptionVO> selectBox_noticeGbn = List();

  String _couponCnt;
  String _fromDate;
  String _toDate;
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

    if (widget.sData != null) {
      editData = new ReserNoticeDetailModel();
      editData = widget.sData;

      _fromDate = editData.frDate.replaceAll('.', '');
      _toDate = editData.toDate.replaceAll('.', '');

      if (editData.url2 == '')
        editData.url2 = null;
      else
        editData.url2 =
        '/reservenotice-images/${editData.url1}?tm=${Utils.getTimeStamp()}';
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
          Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: ISSelectDate(
                  context,
                  label: '시작일',
                  value: editData.frDate.replaceAll('.', '-'),
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
                        editData.frDate =
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
                  value: editData.toDate.replaceAll('.', '-'),
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
                        editData.toDate =
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
            value: editData.title,
            autofocus: true,
            context: context,
            label: '제목',
            onSaved: (v) {
              editData.title = v;
            },
            validator: (v) {
              return v.isEmpty ? '[필수] 제목' : null;
            },
          ),
          ISInput(
            value: editData.contents,
            context: context,
            label: '내용',
            height: 140,
            contentPadding: 20,
            keyboardType: TextInputType.multiline,
            maxLines: 8,
            onSaved: (v) {
              editData.contents = v;
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
                    child: editData.url2 == null
                        ? Image.asset('assets/empty_menu.png', width: 150, height: 150,)
                        : Image.network(editData.url2, gaplessPlayback: true, fit: BoxFit.fill, width: 440, height: 150,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/empty_menu.png', width: 150, height: 150,);
                      },
                    ),
                    onTap: () {
                      ImagePicker imagePicker = ImagePicker();
                      Future<PickedFile> _imageFile = imagePicker.getImage(source: ImageSource.gallery);
                      _imageFile.then((file) async {
                        editData.url2 = file.path;
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
        if (AuthUtil.isAuthEditEnabled('82') == true)
        ISButton(
          label: '저장',
          iconData: Icons.save,
          onPressed: () async {
            FormState form = formKey.currentState;
            if (!form.validate()) {
              return;
            }

            form.save();

            editData.frDate = _fromDate;
            editData.toDate = _toDate;

            editData.url2 = editData.url2.replaceAll(' ', '');

            FileUpLoadProvider provider = FileUpLoadProvider();
            provider.setResource('image', _file);
            provider.makeReserNoticePutResourceRequest(
                editData.noticeSeq.toString(),
                editData.noticeGbn,
                editData.dispGbn,
                editData.frDate,
                editData.toDate,
                editData.title,
                editData.contents,
                editData.url2,
                editData.orderDate,
                GetStorage().read('logininfo')['uCode'],
                GetStorage().read('logininfo')['name']);

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
      width: 440,
      height: 700,
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
