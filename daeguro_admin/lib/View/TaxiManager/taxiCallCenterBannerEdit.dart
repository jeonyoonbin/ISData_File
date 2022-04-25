import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/ISWidget/is_select_date.dart';
import 'package:daeguro_admin_app/Model/coupon/couponEditModel.dart';
import 'package:daeguro_admin_app/Model/reserNoticeRegistModel.dart';
import 'package:daeguro_admin_app/View/CouponManager/coupon_controller.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class taxiCallCenterBannerEdit extends StatefulWidget {
  final String name;
  final String title;
  final String memo;

  const taxiCallCenterBannerEdit({Key key, this.name, this.title, this.memo}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return taxiCallCenterBannerEditState();
  }
}

enum RadioGbn { gbn1, gbn2 }

class taxiCallCenterBannerEditState extends State<taxiCallCenterBannerEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ReserNoticeRegistModel formData;

  String _selTitle;
  RadioGbn _radioGbn;

  bool isReceiveDataEnabled = false;
  bool isListSaveEnabled = false;

  String _fromDate;
  String _fromDate2;
  String _toDate;
  String _toDate2;

  List<SelectOptionVO> selectBox_title = [
    new SelectOptionVO(value: '00', label: '운영정책'),
    new SelectOptionVO(value: '10', label: '이용약관'),
    new SelectOptionVO(value: '20', label: '개인정보처리방침'),
    new SelectOptionVO(value: '30', label: '개인정보수집및이용'),
    new SelectOptionVO(value: '40', label: '개인정보취급위탁'),
    new SelectOptionVO(value: '50', label: '개인정보제3자제공'),
    new SelectOptionVO(value: '60', label: '위치기반서비스이용약관'),
    new SelectOptionVO(value: '70', label: '전자금융거래이용약관'),
    new SelectOptionVO(value: '80', label: '위수탁전자세금계산서이용약관'),
    new SelectOptionVO(value: '90', label: '푸쉬알림수신동의'),
  ];

  @override
  void initState() {
    super.initState();
    _selTitle = widget.title;
    Get.put(CouponController());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
          Row(
            children: [
              Flexible(
                flex: 1,
                child: ISInput(
                  value: widget.name ?? '',
                  context: context,
                  label: '배너 제목',
                  //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                  //prefixIcon: Icon(Icons.person, color: Colors.grey,),
                  textStyle: TextStyle(fontSize: 12),
                ),
              ),
              Flexible(
                flex: 1,
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Text('공개 여부', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    Radio(
                        value: RadioGbn.gbn1,
                        groupValue: _radioGbn,
                        onChanged: (v) async {
                          _radioGbn = v;

                          if (isReceiveDataEnabled == true) {
                            setState(() {
                              //_scrollController.jumpTo(0.0);
                              isListSaveEnabled = true;
                            });
                            //Navigator.pop(context, true);
                          }
                        }),
                    Text('공개', style: TextStyle(fontSize: 12)),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Radio(
                          value: RadioGbn.gbn2,
                          groupValue: _radioGbn,
                          onChanged: (v) async {
                            _radioGbn = v;

                            if (isReceiveDataEnabled == true) {
                              setState(() {
                                //_scrollController.jumpTo(0.0);
                                isListSaveEnabled = true;
                              });
                              //Navigator.pop(context, true);
                            }
                          }),
                    ),
                    Text('비공개', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: ISSelectDate(
                  context,
                  label: '시작일',
                  value: _fromDate2,
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
                        _fromDate = formatDate(picked, [yyyy, '', mm, '', dd]);
                        _fromDate2 = formatDate(picked, [yyyy, '-', mm, '-', dd]);
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
                  value: _toDate2,
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
                        _toDate = formatDate(picked, [yyyy, '', mm, '', dd]);
                        _toDate2 = formatDate(picked, [yyyy, '-', mm, '-', dd]);
                      }
                    });

                    formKey.currentState.save();
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                flex: 2,
                child: ISInput(
                  value: '',
                  context: context,
                  label: '링크 주소',
                  //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                  //prefixIcon: Icon(Icons.person, color: Colors.grey,),
                  textStyle: TextStyle(fontSize: 12),
                ),
              ),

            ],
          ),
          Center(
            child: Container(
              width: 120,
              height: 150,
              child: Column(
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
                          //_launchInBrowser(dataImageList[index].fileUrl + '?tm=${Utils.getTimeStamp()}');
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

                            await Future.delayed(Duration(milliseconds: 500), () {
                              setState(() {
                                _deleteImageFromCache();
                              });
                            });
                          }
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Image.network('/shopinfo-images',
                    gaplessPlayback: true,
                    fit: BoxFit.fill,
                    width: 120,
                    height: 120,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/daeguro_icon_32.png', width: 120, height: 120);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    ButtonBar buttonBar = ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        ISButton(
          label: '수정',
          iconData: Icons.save,
          onPressed: () {
            FormState form = formKey.currentState;
            if (!form.validate()) {
              return;
            }

            form.save();

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
        title: Text('지점(콜센터) 약관/정책 수정'),
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
      width: 500,
      height: 430,
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
