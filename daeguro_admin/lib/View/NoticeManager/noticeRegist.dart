
import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/ISWidget/is_select_date.dart';
import 'package:daeguro_admin_app/Model/noticeRegistModel.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/View/CouponManager/coupon_controller.dart';

import 'package:daeguro_admin_app/Network/FileUpLoader.dart';
import 'package:daeguro_admin_app/View/NoticeManager/noticeFileUpload.dart';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class NoticeRegist extends StatefulWidget {
  const NoticeRegist({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NoticeRegistState();
  }
}

class NoticeRegistState extends State<NoticeRegist> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  noticeRegistModel formData;

  List<SelectOptionVO> selectBox_noticeGbn = List();

  String _couponCnt;
  String _orderDate;
  String _fromDate;
  String _toDate;

  var _file = null;
  var responseData;

  @override
  void dispose(){
    selectBox_noticeGbn.clear();
    formData = null;

    PaintingBinding.instance.imageCache.clearLiveImages();
    PaintingBinding.instance.imageCache.clear();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Get.put(CouponController());

    selectBox_noticeGbn.clear();

    selectBox_noticeGbn.add(new SelectOptionVO(value: '1', label: '공지'));
    selectBox_noticeGbn.add(new SelectOptionVO(value: '2', label: '공지(사장님)'));
    selectBox_noticeGbn.add(new SelectOptionVO(value: '3', label: '이벤트'));
    selectBox_noticeGbn.add(new SelectOptionVO(value: '4', label: '이벤트(사장님)'));
    selectBox_noticeGbn.add(new SelectOptionVO(value: '5', label: '메인팝업'));
    selectBox_noticeGbn.add(new SelectOptionVO(value: '6', label: '메인팝업(사장님)'));
    selectBox_noticeGbn.add(new SelectOptionVO(value: '7', label: '시정홍보'));

    formData = noticeRegistModel();
    formData.extUrlYn = 'N';
    formData.dispGbn = 'Y';
    formData.noticeGbn = '1';
    formData.orderDate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    formData.dispFromDate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    formData.dispToDate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    _orderDate = formatDate(DateTime.now(), [yyyy, '', mm, '', dd]);
    _fromDate = formatDate(DateTime.now(), [yyyy, '', mm, '', dd]);
    _toDate = formatDate(DateTime.now(), [yyyy, '', mm, '', dd]);
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
                      color: formData.dispGbn == 'Y' ? Colors.blue[200] : Colors.red[200],
                      borderRadius: new BorderRadius.circular(6)),
                  child: SwitchListTile(
                    dense: true,
                    value: formData.dispGbn == 'Y' ? true : false,
                    title: Text('게시 유무', style: TextStyle(fontSize: 12, color: Colors.white),),
                    onChanged: (v) {
                      setState(() {
                        formData.dispGbn = v ? 'Y' : 'N';
                        formKey.currentState.save();
                      });
                    },
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: new BoxDecoration(
                      color: formData.extUrlYn == 'Y' ? Colors.blue[200] : Colors.red[200],
                      borderRadius: new BorderRadius.circular(6)),
                  child: SwitchListTile(
                    dense: true,
                    value: formData.extUrlYn == 'Y' ? true : false,
                    title: Text('외부URL 사용 유무', style: TextStyle(fontSize: 10, color: Colors.white),),
                    onChanged: (v) {
                      setState(() {
                        formData.extUrlYn = v ? 'Y' : 'N';
                        formKey.currentState.save();
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: ISSelect(
                  label: '구분',
                  value: formData.noticeGbn,
                  dataList: selectBox_noticeGbn,
                  onChange: (value) {
                    setState(() {
                      formData.noticeGbn = value;
                      formKey.currentState.save();
                    });
                  },
                ),
          ),
              Flexible(
                flex: 1,
                child: ISSelectDate(
                  context,
                  label: '시작일',
                  value: formData.dispFromDate,
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
                        formData.dispFromDate =
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
                  value: formData.dispToDate,
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
                        formData.dispToDate = formatDate(picked, [yyyy, '-', mm, '-', dd]);
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
            value: formData.noticeTitle,
            autofocus: true,
            context: context,
            label: '제목',
            onSaved: (v) {
              formData.noticeTitle = v;
            },
            // validator: (v) {
            //   return v.isEmpty ? '[필수] 제목' : null;
            // },
          ),
          ISInput(
            value: formData.noticeContents,
            context: context,
            label: '내용',
            height: 140,
            contentPadding: 20,
            keyboardType: TextInputType.multiline,
            maxLines: 8,
            onSaved: (v) {
              formData.noticeContents = v;
            },
            // validator: (v) {
            //   return v.isEmpty ? '[필수] 내용' : null;
            // },
          ),
          ISInput(
            value: formData.noticeUrl_2,
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
                      formData.noticeUrl_2 = v;
                    });
                  }
                });
              },
            ),
            onSaved: (v) {
              formData.noticeUrl_2 = v;
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
                    child: formData.noticeUrl_1 == null ? Image.asset('assets/empty_menu.png', width: 150, height: 150,) : Image.network(formData.noticeUrl_1, gaplessPlayback: true, fit: BoxFit.fill, width: 440, height: 150,),
                    onTap: () {
                      ImagePicker imagePicker = ImagePicker();
                      Future<PickedFile> _imageFile = imagePicker.getImage(source: ImageSource.gallery); //imagePicker.pickImage(source: ImageSource.gallery);
                      _imageFile.then((file) async {
                        formData.noticeUrl_1 = file.path;
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
        ISButton(
          label: '저장',
          iconData: Icons.save,
          onPressed: () async {
            FormState form = formKey.currentState;
            if (!form.validate()) {
              return;
            }

            form.save();

            if (_file == null) {
              ISAlert(context, '이미지를 등록 해 주십시오.');
              return;
            }

            formData.orderDate = _orderDate;
            formData.dispFromDate = _fromDate;
            formData.dispToDate = _toDate;
            formData.insDate = formatDate(DateTime.now(), [yyyy, '', mm, '', dd]);
            formData.insUCode = GetStorage().read('logininfo')['uCode'];
            formData.insName = GetStorage().read('logininfo')['name'];

            formData.noticeUrl_2 = formData.noticeUrl_2.replaceAll(' ', '');

            FileUpLoadProvider provider = FileUpLoadProvider();
            provider.setResource('image', _file);
            provider.makeNoticePostResourceRequest(formData.noticeGbn, formData.dispGbn, formData.dispFromDate, formData.dispToDate, formData.noticeTitle, formData.noticeContents,
                formData.noticeUrl_1, formData.noticeUrl_2, formData.orderDate, formData.insDate, formData.insUCode, formData.insName, formData.extUrlYn);

            await Future.delayed(Duration(milliseconds: 500), () {
              setState(() {
                _deleteImageFromCache();
              });
            });

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
        title: Text('공지사항&이벤트 등록'),
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
      width: 480,
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
