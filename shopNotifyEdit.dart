import 'dart:convert';
import 'dart:io';

import 'package:daeguro_ceo_app/common/constant.dart';
import 'package:daeguro_ceo_app/common/serverInfo.dart';
import 'package:daeguro_ceo_app/config/auth_service.dart';
import 'package:daeguro_ceo_app/iswidgets/is_alertdialog.dart';
import 'package:daeguro_ceo_app/iswidgets/is_dialog.dart';
import 'package:daeguro_ceo_app/iswidgets/is_progressDialog.dart';
import 'package:daeguro_ceo_app/iswidgets/isd_input.dart';
import 'package:daeguro_ceo_app/models/ShopManager/shopNotifyEditModel.dart';
import 'package:daeguro_ceo_app/models/ShopManager/shopNotifyInfoDetailModel.dart';
import 'package:daeguro_ceo_app/models/ShopManager/shopNotifyInfoModel.dart';
import 'package:daeguro_ceo_app/network/ImageUploadController.dart';
import 'package:daeguro_ceo_app/screen/ShopManager/shopManagerController.dart';
import 'package:daeguro_ceo_app/util/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluentUI;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ShopNotifyEdit extends StatefulWidget {
  final String? introGbn;
  final String? jobGbn;
  final String? introCode;

  const ShopNotifyEdit({Key? key, this.introGbn, this.jobGbn, this.introCode}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShopNotifyEditState();
  }
}

class ShopNotifyEditState extends State<ShopNotifyEdit> {

  ShopNotifyInfoDetailModel formData = ShopNotifyInfoDetailModel();
  TextEditingController textEditingController = TextEditingController();

  // PlatformFile? _imageFile1;
  // PlatformFile? _imageFile2;

  var _file1;
  var _file2;

  // var pickedImage1 = null;
  // var pickedImage2 = null;

  // String? introImageFullPath;
  // String? introImageFullPath2;

  String? addImagePath1 = '';
  String? addImagePath2 = '';
  RxString tempIntroContents = ''.obs;

  requestAPIData({bool? isImageRefresh = false}) async {
    var value = await showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (context) => FutureProgressDialog(ShopController.to.getShopIntroDetailInfo(widget.introCode!))
    );

    if (value == null) {
      ISAlert(context, content: '정상 조회가 되지 않았습니다. \n\n다시 시도해 주세요.');
      //Navigator.of(context).pop;
    }
    else {
      if (isImageRefresh == false){
        formData.introCd = value['introCd'] as String;
        formData.shopCd = value['shopCd'] as String;
        formData.introGbn = value['introGbn'] as String;
        formData.introContents = value['introContents'] as String;
        formData.modDate = value['modDate'] as String;
        formData.useGbn = value['useGbn'] as String;
      }

      formData.introImage = value['introImage'] as String;
      formData.introImage2 = value['introImage2'] as String;

      String pathName = widget.introGbn == 'I' ? 'shopImage' : 'ReviewImage';

      String tempPath1;
      String tempPath2;

      if(ServerInfo.jobMode == 'real') {
        tempPath1 = '/intro/${pathName}/${AuthService.SHOPCD}/thumb/${formData!.introImage!}';
        tempPath2 = '/intro/${pathName}/${AuthService.SHOPCD}/thumb/${formData!.introImage2!}';
      } else {
        tempPath1 = 'https://image.daeguro.co.kr:40443/intro/${pathName}/${AuthService.SHOPCD}/thumb/${formData!.introImage!}';
        tempPath2 = 'https://image.daeguro.co.kr:40443/intro/${pathName}/${AuthService.SHOPCD}/thumb/${formData!.introImage2!}';
      }

      addImagePath1 = formData!.introImage == '' ? '' : tempPath1;
      addImagePath2 = formData!.introImage2 == '' ? '' : tempPath2;
    }

    textEditingController.text = formData.introContents!;
    tempIntroContents.value = formData.introContents!;
    setState(() {});
  }

  String getTitleStr(){
    if (AuthService.ShopServiceGbn == AuthService.SHOPGBN_MARKET && AuthService.TradShopMainYn == 'Y'){
      return '시장';
    }
    else{
      if (widget.introGbn == 'I') {
        return '매장';
      }
      else if (widget.introGbn == 'R') {
        return '리뷰';
      }
    }

    return '';
  }

  // setImageView(FilePickerResult pickResult, String sort) async{
  //   await showDialog(
  //     context: context,
  //     builder: (context) => FutureProgressDialog(_pickImage(pickResult, sort))
  //   ).then((value) async {
  //     setState(() {
  //       //_deleteImageFromCache();
  //     });
  //   });
  // }

  requestAPI_ImageUploadAdd(String introCd) async {
    List<int>? filebytes1;
    List<int>? filebytes2;

    if (_file1 == null){
      filebytes1 = [];
    }
    else{
      Uint8List data = await _file1.readAsBytes();
      filebytes1 = data.cast();
    }

    if (_file2 == null){
      filebytes2 = [];
    }
    else{
      Uint8List data = await _file2.readAsBytes();
      filebytes2 = data.cast();
    }

    if(filebytes1 != null && filebytes2 != null){
      await showDialog(
          context: context,
          barrierColor: Colors.transparent,
          builder: (context) => FutureProgressDialog(ImageUploadController.to.addShopNotifyImageInfo(introCd, filebytes1!, filebytes2!))
      ).then((value) async {
        await Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.of(context).pop(true);

        ISAlert(context, title: '${getTitleStr()} 알림 등록', content: '등록이 완료되었습니다.');
        });
      });
    }
  }

  requestAPI_ImageUploadUpdate(var value, String sort) async{
    List<int>? filebytes;

    if (value == null){
      filebytes = null;
    }
    else{
      Uint8List data = await value.readAsBytes();
      filebytes = data.cast();
    }

    await showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (context) => FutureProgressDialog(ImageUploadController.to.updateShopNotifyImageInfo(formData!.introCd!, sort, filebytes!))
    ).then((value) {
      requestAPIData(isImageRefresh: true);
    });
  }

  requestAPI_ImageUploadDelete(String sort) async{
    await showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (context) => FutureProgressDialog(ImageUploadController.to.deleteShopNotifyImageInfo(formData!.introCd!, sort))
    ).then((value) {
      requestAPIData(isImageRefresh: true);
    });
  }

  @override
  void dispose() {
    super.dispose();
    formData = ShopNotifyInfoDetailModel();
    textEditingController.dispose();
  }

  @override
  void initState() {
    super.initState();

    Get.put(ShopController());
    Get.put(ImageUploadController());

    if (widget.jobGbn == 'I'){
      formData = ShopNotifyInfoDetailModel();

      addImagePath1 = '';
      addImagePath2 = '';
    }

    //formData = (widget.jobGbn == 'I') ? ShopNotifyInfoModel() : widget.sData;

    WidgetsBinding.instance.addPostFrameCallback((c) {
      if (widget.jobGbn == 'I'){
        setState(() {

        });
      }
      else {
        requestAPIData(isImageRefresh: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    assert(fluentUI.debugCheckHasFluentTheme(context));

    return ContentDialog(
      constraints: BoxConstraints(minWidth: 400, maxWidth: 400.0, minHeight: AuthService.ShopServiceGbn == AuthService.SHOPGBN_MARKET ? 540 : 600, maxHeight: 720),
      // contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      isFillActions: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${getTitleStr()} 알림', style: const TextStyle(fontSize: 22, fontFamily: FONT_FAMILY),),
              Text('※ 등록하신 사진과 정보는 ${getTitleStr()} 정보에 보여집니다.', style: const TextStyle(color: Colors.grey, fontSize: 11, fontFamily: FONT_FAMILY),
              ),
            ],
          ),
          fluentUI.SmallIconButton(
            child: fluentUI.Tooltip(
              message: fluentUI.FluentLocalizations.of(context).closeButtonLabel,
              child: fluentUI.IconButton(
                icon: const Icon(fluentUI.FluentIcons.chrome_close),
                onPressed: Navigator.of(context).pop,
              ),
            ),
          ),
        ],
      ),
      content: Material(
        color: Colors.transparent,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (AuthService.TradShopMainYn != 'Y')...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: const BorderRadius.all(Radius.circular(5))),
                        height: 100,
                        width: 100,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: InkWell(
                              child: Stack(
                                alignment: AlignmentDirectional.topEnd,
                                children: [
                                  addImagePath1 == '' ? const Image(image: AssetImage('images/thumbnail-empty.png'), width: 100, height: 100) : Image.network(addImagePath1!, fit: BoxFit.cover, gaplessPlayback: true, width: 100, height: 100,
                                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                                        ),
                                      );
                                    },

                                    errorBuilder: (context, error, stackTrace) {
                                      return const Image(image: AssetImage('images/thumbnail-empty.png'));
                                    },
                                  ),
                                  if (widget.jobGbn == 'U' && addImagePath1 != '')
                                    Positioned(
                                      top: 2,
                                      right: 2,
                                      child: InkWell(
                                        child: const Image(image: AssetImage('images/image_remove_small.png'), width: 20, height: 20,),
                                        onTap: () {
                                          ISConfirm(context, '이미지 삭제', '해당 이미지를 삭제하시겠습니까?', (context, isOK) async {
                                            Navigator.of(context).pop();

                                            if (isOK){

                                              requestAPI_ImageUploadDelete('1');
                                              // CommonNoFlagModel formData = CommonNoFlagModel();
                                              //
                                              // formData.jobGbn = 'F';
                                              // formData.subGbn = 'M';
                                              // formData.shopCd = AuthService.SHOPCD;
                                              // formData.targetCd = dataList[index].prodCd;
                                              // formData.noFlag = 'N';
                                              // formData.uCode = AuthService.uCode;
                                              // formData.uName = AuthService.uName;
                                              //
                                              // var value = await showDialog(
                                              //     context: context,
                                              //     builder: (context) => FutureProgressDialog(ProductController.to.updateNoFlag(formData.toJson()))
                                              // );
                                              //
                                              // if (value == null) {
                                              //   ISAlert(context, content: '정상처리가 되지 않았습니다. \n\n다시 시도해 주세요');
                                              // }
                                              // else {
                                              //   if (value == '00') {
                                              //     requestAPIData();
                                              //   }
                                              //   else{
                                              //     ISAlert(context, content: '정상처리가 되지 않았습니다.\n→ ${value} ');
                                              //   }
                                              // }
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                ],
                              ),
                              onTap: () async {
                                ImagePicker imagePicker = ImagePicker();
                                Future<PickedFile?> _imageFile = imagePicker.getImage(source: ImageSource.gallery); //imagePicker.pickImage(source: ImageSource.gallery);
                                _imageFile.then((file) async {
                                  addImagePath1 = file!.path;

                                  if (widget.jobGbn == 'I'){
                                    _file1 = file;
                                  }
                                  else {
                                    requestAPI_ImageUploadUpdate(file, '1');
                                  }

                                  setState(() {
                                  });
                                });
                              },
                            )
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: const BorderRadius.all(Radius.circular(5))),
                        height: 100,
                        width: 100,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: InkWell(
                              child: Stack(
                                alignment: AlignmentDirectional.topEnd,
                                children: [
                                  addImagePath2 == '' ? const Image(image: AssetImage('images/thumbnail-empty.png'), width: 100, height: 100) : Image.network(addImagePath2!, fit: BoxFit.cover, gaplessPlayback: true, width: 100, height: 100,
                                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Image(image: AssetImage('images/thumbnail-empty.png'));
                                    },
                                  ),
                                  if (widget.jobGbn == 'U' && addImagePath2 != '')
                                    Positioned(
                                      top: 2,
                                      right: 2,
                                      child: InkWell(
                                        child: const Image(image: AssetImage('images/image_remove_small.png'), width: 20, height: 20,),
                                        onTap: () {
                                          ISConfirm(context, '이미지 삭제', '해당 이미지를 삭제하시겠습니까?', (context, isOK) async {
                                            Navigator.of(context).pop();

                                            if (isOK){
                                              requestAPI_ImageUploadDelete('2');
                                              // CommonNoFlagModel formData = CommonNoFlagModel();
                                              //
                                              // formData.jobGbn = 'F';
                                              // formData.subGbn = 'M';
                                              // formData.shopCd = AuthService.SHOPCD;
                                              // formData.targetCd = dataList[index].prodCd;
                                              // formData.noFlag = 'N';
                                              // formData.uCode = AuthService.uCode;
                                              // formData.uName = AuthService.uName;
                                              //
                                              // var value = await showDialog(
                                              //     context: context,
                                              //     builder: (context) => FutureProgressDialog(ProductController.to.updateNoFlag(formData.toJson()))
                                              // );
                                              //
                                              // if (value == null) {
                                              //   ISAlert(context, content: '정상처리가 되지 않았습니다. \n\n다시 시도해 주세요');
                                              // }
                                              // else {
                                              //   if (value == '00') {
                                              //     requestAPIData();
                                              //   }
                                              //   else{
                                              //     ISAlert(context, content: '정상처리가 되지 않았습니다.\n→ ${value} ');
                                              //   }
                                              // }
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                ],
                              ),

                              onTap: () async {
                                ImagePicker imagePicker = ImagePicker();
                                Future<PickedFile?> _imageFile = imagePicker.getImage(source: ImageSource.gallery); //imagePicker.pickImage(source: ImageSource.gallery);
                                _imageFile.then((file) async {
                                  addImagePath2 = file!.path;

                                  if (widget.jobGbn == 'I'){
                                    _file2 = file;
                                  }
                                  else {
                                    requestAPI_ImageUploadUpdate(file, '2');
                                  }

                                  setState(() {
                                  });
                                });
                              },
                            )
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],

                TextFormField(
                  style: const TextStyle(fontSize: 13, fontWeight: FONT_NORMAL, fontFamily: FONT_FAMILY),
                  keyboardType: TextInputType.multiline,
                  maxLines: 8,
                  controller: textEditingController,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  maxLength: 4000,
                  buildCounter: (context, { required currentLength, required isFocused, maxLength }) {

                    int utf8Length = utf8.encode(TextEditingController(text: formData!.introContents).text).length;
                    String counterText = '$utf8Length/4000 byte';

                    TextStyle counterStyle;

                    if(utf8Length > maxLength!){
                      counterStyle = const TextStyle(color: Colors.red, fontSize: 13, fontFamily: FONT_FAMILY, fontWeight: FONT_NORMAL);
                    }else{
                      counterStyle = const TextStyle(color: Colors.black54, fontSize: 13, fontFamily: FONT_FAMILY, fontWeight: FONT_NORMAL);
                    }

                    return Container(
                      child: Text(
                        counterText,
                        style: counterStyle,
                      ),
                    );
                  },
                  onChanged: (v) {
                      formData!.introContents = v.toString();
                      tempIntroContents.value = formData.introContents!;
                      //print(tempIntroContents.toString());
                  },
                  decoration: const InputDecoration(
                    hintText: '알림 메시지를 작성해 주세요!',
                    fillColor: Colors.white,
                    filled: true,
                    enabled: true,
                    hintStyle: TextStyle(color: Colors.black54, fontSize: 13, fontWeight: FONT_NORMAL, fontFamily: FONT_FAMILY),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black12, width: 1.0)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0)),
                    isDense: true,
                    contentPadding: const EdgeInsets.fromLTRB(10, 10, 4, 10),
                  ),
                  inputFormatters: [
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      if(newValue.text.isEmpty) {
                        return newValue;
                      }
                      try{
                        int inputUtfLength = utf8.encode(newValue.text).length;
                        if(inputUtfLength > 4000){
                          String encodeText = utf8.encode(newValue.text) as String;
                          var decodeText = utf8.decode(encodeText.substring(0,3996) as List<int>);

                          final cursorPosition = newValue.selection.baseOffset;
                          final newCursorPosition = cursorPosition + (decodeText.length - newValue.text.length);

                          return TextEditingValue(
                            text: decodeText,
                            selection: TextSelection.collapsed(offset: newCursorPosition),
                          );
                        }
                        else{
                          return newValue;
                        }
                      }catch (_) {
                        return oldValue;
                      }

                    },)
                  ],
                ),

                // ISInput(
                //   value: formData!.introContents ?? '',
                //   context: context,
                //   height: 220,
                //   //padding: 0,
                //   label: '알림 메시지를 작성해 주세요!',
                //   keyboardType: TextInputType.multiline,
                //   maxLines: 8,
                //   maxLength: AuthService.ShopServiceGbn == AuthService.SHOPGBN_MARKET && AuthService.TradShopMainYn == 'Y' ? 100 : 4000,
                //   counterText: '${utf8.encode(formData.introContents.toString()).length}/4000 byte',
                //   onChange: (v) {
                //     setState(() {
                //       formData!.introContents = v;
                //     });
                //   },
                //   inputFormatters: [Utf8LengthLimitingTextInputFormatter(AuthService.ShopServiceGbn == AuthService.SHOPGBN_MARKET && AuthService.TradShopMainYn == 'Y' ? 100 : 4000)],
                // ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(color: Color.fromARGB(255, 240, 240, 240), borderRadius: BorderRadius.all(Radius.circular(10))),
                  // height: 35,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('대구로 앱에서 보여지는 알림 화면', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                      const Text('※ 해상도에 따라 다르게 보일 수 있습니다.', style: TextStyle(fontSize: 12, color: Colors.grey),),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                height: 40,
                                width: 100,
                                decoration: const BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Colors.black38, width: 2))),
                                child: const Text('메뉴', style: TextStyle(fontSize: 13)),
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: 40,
                                width: 100,
                                decoration: BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: widget.introGbn == 'I' ? const Color(0xff01CAFF) : Colors.black38, width: 2))),
                                child: Text('정보', style: TextStyle(color: widget.introGbn == 'I' ? const Color(0xff01CAFF) : null, fontSize: 13)),
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: 40,
                                width: 100,
                                decoration: BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: widget.introGbn == 'R' ? const Color(0xff01CAFF) : Colors.black38, width: 2))),
                                child: Text('리뷰', style: TextStyle(color: widget.introGbn == 'R' ? const Color(0xff01CAFF) : null, fontSize: 13)),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                child: Text('${getTitleStr()} 알림', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          Container(
                              width: 300,
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.black38, width: 2))),
                              child: Text(tempIntroContents.toString() ?? '', style: const TextStyle(fontSize: 13),)
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        SizedBox(
          //width: double.infinity,
          child: FilledButton(
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(const Size(60, 70)), //Size.fromHeight(60),
              backgroundColor: const MaterialStatePropertyAll(Color(0xff333333)),
              shape: const MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(11.0)) //.circular(4.0)
                  )),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('취소', style: TextStyle(fontSize: 18, fontFamily: FONT_FAMILY)),
          ),
        ),
        SizedBox(
          //width: double.infinity,
          child: FilledButton(
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(const Size(60, 70)), //Size.fromHeight(60),
              backgroundColor: const MaterialStatePropertyAll(Color(0xff01CAFF)),
              shape: const MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(11.0)) //BorderRadius.circular(4.0))
                  )),
            ),
            onPressed: () async {
              ISConfirm(context, '${getTitleStr()} 알림', widget.jobGbn == 'I' ? '신규 알림 정보를 등록하시겠습니까?' : '알림 정보를 변경하시겠습니까?', constraints: const BoxConstraints(maxWidth: 360.0, maxHeight: 260), (context2, isOK) async {
                Navigator.of(context2).pop();
                if (isOK){
                  ShopNotifyEditModel sendData = ShopNotifyEditModel();
                  sendData.jobGbn = widget.jobGbn;
                  sendData.introCd = formData!.introCd;
                  sendData.shopCd = AuthService.SHOPCD;
                  sendData.introGbn = widget.introGbn;
                  sendData.introContents = formData!.introContents;
                  sendData.useGbn = widget.jobGbn == 'I' ? 'N' : formData!.useGbn;
                  sendData.modUcode = AuthService.uCode;
                  sendData.modName = AuthService.uName;

                  var value = await ShopController.to.updateShopIntroInfo(sendData.toJson());
                  if (value == null) {
                    ISAlert(context2, content: '정상 처리가 되지 않았습니다. \n\n다시 시도해 주세요');
                  }
                  else {
                    String code = value.split('|').first;
                    String msg = value.split('|').last;
                    if (code == '00') {
                      if (widget.jobGbn == 'I'){
                        if (AuthService.ShopServiceGbn == AuthService.SHOPGBN_MARKET && AuthService.TradShopMainYn == 'Y'){
                          Navigator.of(context).pop(true);

                          ISAlert(context, title: '${getTitleStr()} 알림 등록', content: '등록이 완료되었습니다.');
                        }
                        else{
                          String introCd = msg.split(' ').last;
                          if (introCd != ''){
                            requestAPI_ImageUploadAdd(introCd);
                          }
                        }
                      }
                      else{
                        Navigator.of(context).pop(true);

                        ISAlert(context, title: '${getTitleStr()} 알림 수정', content: '수정이 완료되었습니다.');
                      }
                    }
                    else{
                      ISAlert(context, content: '정상 처리가 되지 않았습니다.\n→ ${value} ');
                    }
                  }
                }
              });
            },
            child: Text(widget.jobGbn == 'I' ? '등록' : '수정', style: const TextStyle(fontSize: 18, fontFamily: FONT_FAMILY)),
          ),
        ),
      ],
    );
  }

  Future _deleteImageFromCache() async {
    //await CachedNetworkImage.evictFromCache(url);

    PaintingBinding.instance.imageCache.clearLiveImages();
    PaintingBinding.instance.imageCache.clear();

    //await DefaultCacheManager().removeFile(key);
    //await DefaultCacheManager().emptyCache();
    //setState(() {});
  }
}
