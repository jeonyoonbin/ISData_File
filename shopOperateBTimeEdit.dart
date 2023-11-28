import 'dart:convert';

import 'package:daeguro_ceo_app/common/constant.dart';
import 'package:daeguro_ceo_app/config/auth_service.dart';
import 'package:daeguro_ceo_app/iswidgets/is_alertdialog.dart';
import 'package:daeguro_ceo_app/iswidgets/is_dialog.dart';
import 'package:daeguro_ceo_app/iswidgets/is_progressDialog.dart';
import 'package:daeguro_ceo_app/iswidgets/isd_button.dart';
import 'package:daeguro_ceo_app/iswidgets/isd_input.dart';
import 'package:daeguro_ceo_app/iswidgets/isd_labelBarSub.dart';
import 'package:daeguro_ceo_app/screen/ShopManager/shopManagerController.dart';
import 'package:daeguro_ceo_app/theme.dart';
import 'package:daeguro_ceo_app/util/utils.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluentUI;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../iswidgets/multi_masked_formatter.dart';
import '../../models/ShopManager/ShopBreakTimeHourListEditModel.dart';

class ShopOperateBTimeEdit extends StatefulWidget {
  final dynamic? b_time;
  const ShopOperateBTimeEdit({Key? key, this.b_time})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShopOperateBTimeEditState();
  }
}



class ShopOperateBTimeEditState extends State<ShopOperateBTimeEdit> {
  final ScrollController _scrollController = ScrollController();
  dynamic? setB_time;
  List<dynamic> tempSetB_time = [];

  String startTemp = '';
  String endTemp = '';

  ShopBreakTimeHourListEditModel sendData = ShopBreakTimeHourListEditModel();

  @override
  void initState() {
    super.initState();

    Get.put(ShopController());

    if(widget.b_time.toString() == '[]') {
      for(int i = 0; i < 7; i++) {
        var addData = {
          'dayGbn': (i+1).toString(),
          'openTime': '0000',
          'closeTime': '0000',
          'useGbn': 'N',
          'nextDayYn': 'N',
        };
        tempSetB_time.add(addData);
      }
      setB_time = tempSetB_time;
    }else if(widget.b_time.length < 7){ // 데이터 7개 다 안들어와있을 경우
      List necessityVal = []; // 이미 들어와있는 값 체크용 배열
      var addData;

      for(int i = 0; i < widget.b_time.length; i++) {
        addData = {
          'dayGbn': widget.b_time[i]['dayGbn'],
          'openTime': widget.b_time[i]['openTime'],
          'closeTime': widget.b_time[i]['closeTime'],
          'useGbn': 'Y',
          'nextDayYn': 'N',
        };

        necessityVal.add(widget.b_time[i]['dayGbn']);

        tempSetB_time.add(addData);
      }

      for(int i = 1; i <= 7 ; i++ ){
        if(necessityVal.contains(i.toString())){
        }else{ // 안 들어와있는값에는 이거 집어넣어준다.
          addData = {
            'dayGbn': i.toString(),
            'openTime': '0000',
            'closeTime': '0000',
            'useGbn': 'N',
            'nextDayYn': 'N',
          };

          tempSetB_time.add(addData);
        }
      }

      setB_time = tempSetB_time;
      setB_time.sort((a,b) => int.parse(a['dayGbn']).compareTo(int.parse(b['dayGbn']))); // dayGbn 순서로 정렬

    }else { // 멀쩡할때
      setB_time = widget.b_time;
    }
  }

  tempReset() async{
    bool reset = true;
    for(int i = 0; i < 7 ; i++ ){
      if(widget.b_time[i]['useGbn'] == 'Y'){
        reset = false;
      }
    }

    if(reset){
      startTemp = '';
      endTemp = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(fluentUI.debugCheckHasFluentTheme(context));

    final appTheme = context.watch<AppTheme>();

    tempReset();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: ContentDialog(
        constraints: const BoxConstraints(maxWidth: 400.0, maxHeight: 680),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        isFillActions: true,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('휴게시간 설정', style: const TextStyle(fontSize: 22, fontFamily: FONT_FAMILY),),
            SizedBox(width: 10),
            Text('*일괄 적용은 월요일 기준으로 적용됩니다.', style: const TextStyle(fontSize: 14, color: Colors.grey),),
          ],
        ),
        content: Material(
            color: Colors.transparent,
            borderOnForeground: false,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  ISLabelBarSub(
                    title: '휴게시간',
                    trailing: Row(
                      children: [
                        ISButton(
                          child: const Text('초기화'),
                          onPressed: () {
                            setB_time.forEach((element) { // 월요일 기준이라서 index 0 아니고 1
                              element['openTime'] = '0900';
                              element['closeTime'] = '2359';
                              element['useGbn'] = 'N';
                            });

                            setState(() {});
                          },
                        ),
                        const SizedBox(width: 5,),
                        ISButton(
                          child: const Text('일괄 적용'),
                          onPressed: () {
                            setB_time.forEach((element) { // 월요일 기준이라서 index 0 아니고 1
                              element['openTime'] = setB_time[1]['openTime'];
                              element['closeTime'] = setB_time[1]['closeTime'];
                              element['useGbn'] = setB_time[1]['useGbn'];
                            });

                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    body: Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('월요일', style: TextStyle(fontWeight: FONT_BOLD)),
                              SizedBox(width: 20),

                              Visibility(
                                visible: setB_time[1]['useGbn'] == 'Y' ? true : false,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('   휴게시작', style: TextStyle(fontSize: 12, fontWeight: FONT_NORMAL, fontFamily: FONT_FAMILY)),
                                        const SizedBox(height: 4,),
                                        SizedBox(
                                          width: 65,
                                          child: ISInput(
                                            autofocus: true,
                                            value: Utils.getTimeFormat(setB_time[1]['openTime'].toString()),
                                            height: 30,
                                            //padding: 0,
                                            context: context,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[LengthLimitingTextInputFormatter(5),MultiMaskedTextInputFormatter(masks: ['x:xx', 'xx:xx'], separator: ':')],
                                            label: '00:00',
                                            onChange: (v) {
                                              String value = v.toString().replaceAll(':', '');
                                              startTemp = v.toString().replaceAll(':', '');

                                              if(int.parse(value) > 2359){
                                                setState(() {
                                                  setB_time[1]['openTime'] = '2359';
                                                });

                                                ISAlert(context, content: '휴게 시작 시간을 23:59 이상 입력 하실 수 없습니다.');

                                              } else {
                                                setB_time[1]['openTime'] = value;
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('   휴게종료', style: TextStyle(fontSize: 12, fontWeight: FONT_NORMAL, fontFamily: FONT_FAMILY)),
                                        const SizedBox(height: 4,),
                                        SizedBox(
                                          width: 65,
                                          child: ISInput(
                                            autofocus: true,
                                            value: Utils.getTimeFormat(setB_time[1]['closeTime'].toString()),
                                            height: 30,
                                            //padding: 0,
                                            context: context,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[LengthLimitingTextInputFormatter(5), MultiMaskedTextInputFormatter(masks: ['x:xx', 'xx:xx'], separator: ':')],
                                            label: '00:00',
                                            onChange: (v) {
                                              String value = v.toString().replaceAll(':', '');
                                              endTemp = v.toString().replaceAll(':', '');

                                              if(int.parse(value) > 2359){
                                                setState(() {
                                                  setB_time[1]['closeTime'] = '2359';
                                                });

                                                ISAlert(context, content: '휴게 종료 시간을 23:59 이상 입력 하실 수 없습니다.');

                                              } else {
                                                setB_time[1]['closeTime'] = value;
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(setB_time[1]['useGbn'] == 'Y'? '설정함' : '설정안함', style: TextStyle(fontSize: 12, fontWeight: FONT_NORMAL, fontFamily: FONT_FAMILY) ),
                                  Switch(
                                      value: setB_time[1]['useGbn'] == 'Y' ? true : false,
                                      onChanged: (v){
                                        setState(() {
                                          if (v == true) {
                                            setB_time[1]['useGbn'] = 'Y';
                                            setB_time[1]['openTime'] = startTemp != '' ? startTemp : '0000';
                                            setB_time[1]['closeTime'] = endTemp != '' ? endTemp : '0000';
                                          } else {
                                            setB_time[1]['useGbn'] = 'N';
                                          }
                                        });
                                      }
                                  ),
                                ],
                              ),

                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('화요일', style: TextStyle(fontWeight: FONT_BOLD)),
                              SizedBox(width: 20),
                              Visibility(
                                visible: setB_time[2]['useGbn'] == 'Y' ? true : false,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('   휴게시작', style: TextStyle(fontSize: 12, fontWeight: FONT_NORMAL, fontFamily: FONT_FAMILY)),
                                        const SizedBox(height: 4,),
                                        SizedBox(
                                          width: 65,
                                          child: ISInput(
                                            autofocus: true,
                                            value: Utils.getTimeFormat(setB_time[2]['openTime'].toString()),
                                            height: 30,
                                            //padding: 0,
                                            context: context,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[LengthLimitingTextInputFormatter(5), MultiMaskedTextInputFormatter(masks: ['x:xx', 'xx:xx'], separator: ':')],
                                            label: '00:00',
                                            onChange: (v) {
                                              String value = v.toString().replaceAll(':', '');
                                              startTemp = v.toString().replaceAll(':', '');

                                              if(int.parse(value) > 2359){
                                                setState(() {
                                                  setB_time[2]['openTime'] = '2359';
                                                });

                                                ISAlert(context, content: '휴게 시작 시간을 23:59 이상 입력 하실 수 없습니다.');

                                              } else {
                                                setB_time[2]['openTime'] = value;
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('   휴게종료', style: TextStyle(fontSize: 12, fontWeight: FONT_NORMAL, fontFamily: FONT_FAMILY)),
                                        const SizedBox(height: 4,),
                                        SizedBox(
                                          width: 65,
                                          child: ISInput(
                                            autofocus: true,
                                            value: Utils.getTimeFormat(setB_time[2]['closeTime'].toString()),
                                            height: 30,
                                            //padding: 0,
                                            context: context,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[LengthLimitingTextInputFormatter(5), MultiMaskedTextInputFormatter(masks: ['x:xx', 'xx:xx'], separator: ':')],
                                            label: '00:00',
                                            onChange: (v) {
                                              String value = v.toString().replaceAll(':', '');
                                              endTemp = v.toString().replaceAll(':', '');

                                              if(int.parse(value) > 2359){
                                                setState(() {
                                                  setB_time[2]['closeTime'] = '2359';
                                                });

                                                ISAlert(context, content: '휴게 종료 시간을 23:59 이상 입력 하실 수 없습니다.');

                                              } else {
                                                setB_time[2]['closeTime'] = value;
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(setB_time[2]['useGbn'] == 'Y'? '설정함' : '설정안함', style: TextStyle(fontSize: 12, fontWeight: FONT_NORMAL, fontFamily: FONT_FAMILY) ),
                                  Switch(
                                      value: setB_time[2]['useGbn'] == 'Y' ? true : false,
                                      onChanged: (v){
                                        setState(() {
                                          if (v == true) {
                                            setB_time[2]['useGbn'] = 'Y';
                                            setB_time[2]['openTime'] = startTemp != '' ? startTemp : '0000';
                                            setB_time[2]['closeTime'] = endTemp != '' ? endTemp : '0000';
                                          } else {
                                            setB_time[2]['useGbn'] = 'N';
                                          }
                                        });
                                      }
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('수요일', style: TextStyle(fontWeight: FONT_BOLD)),
                              SizedBox(width: 20),
                              Visibility(
                                visible: setB_time[3]['useGbn'] == 'Y' ? true : false,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('   휴게시작', style: TextStyle(fontSize: 12, fontWeight: FONT_NORMAL, fontFamily: FONT_FAMILY)),
                                        const SizedBox(height: 4,),
                                        SizedBox(
                                          width: 65,
                                          child: ISInput(
                                            autofocus: true,
                                            value: Utils.getTimeFormat(setB_time[3]['openTime'].toString()),
                                            height: 30,
                                            //padding: 0,
                                            context: context,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[LengthLimitingTextInputFormatter(5), MultiMaskedTextInputFormatter(masks: ['x:xx', 'xx:xx'], separator: ':')],
                                            label: '00:00',
                                            onChange: (v) {
                                              String value = v.toString().replaceAll(':', '');
                                              startTemp = v.toString().replaceAll(':', '');

                                              if(int.parse(value) > 2359){
                                                setState(() {
                                                  setB_time[3]['openTime'] = '2359';
                                                });

                                                ISAlert(context, content: '휴게 시작 시간을 23:59 이상 입력 하실 수 없습니다.');

                                              } else {
                                                setB_time[3]['openTime'] = value;
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('   휴게종료', style: TextStyle(fontSize: 12, fontWeight: FONT_NORMAL, fontFamily: FONT_FAMILY)),
                                        const SizedBox(height: 4,),
                                        SizedBox(
                                          width: 65,
                                          child: ISInput(
                                            autofocus: true,
                                            value: Utils.getTimeFormat(setB_time[3]['closeTime'].toString()),
                                            height: 30,
                                            //padding: 0,
                                            context: context,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[LengthLimitingTextInputFormatter(5), MultiMaskedTextInputFormatter(masks: ['x:xx', 'xx:xx'], separator: ':')],
                                            label: '00:00',
                                            onChange: (v) {
                                              String value = v.toString().replaceAll(':', '');
                                              endTemp = v.toString().replaceAll(':', '');

                                              if(int.parse(value) > 2359){
                                                setState(() {
                                                  setB_time[3]['closeTime'] = '2359';
                                                });

                                                ISAlert(context, content: '휴게 종료 시간을 23:59 이상 입력 하실 수 없습니다.');

                                              } else {
                                                setB_time[3]['closeTime'] = value;
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(setB_time[3]['useGbn'] == 'Y'? '설정함' : '설정안함', style: TextStyle(fontSize: 12, fontWeight: FONT_NORMAL, fontFamily: FONT_FAMILY) ),
                                  Switch(
                                      value: setB_time[3]['useGbn'] == 'Y' ? true : false,
                                      onChanged: (v){
                                        setState(() {
                                          if (v == true) {
                                            setB_time[3]['useGbn'] = 'Y';
                                            setB_time[3]['openTime'] = startTemp != '' ? startTemp : '0000';
                                            setB_time[3]['closeTime'] = endTemp != '' ? endTemp : '0000';
                                          } else {
                                            setB_time[3]['useGbn'] = 'N';
                                          }
                                        });
                                      }
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('목요일', style: TextStyle(fontWeight: FONT_BOLD)),
                              SizedBox(width: 20),
                              Visibility(
                                visible: setB_time[4]['useGbn'] == 'Y' ? true : false,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('   휴게시작', style: TextStyle(fontSize: 12, fontWeight: FONT_NORMAL, fontFamily: FONT_FAMILY)),
                                        const SizedBox(height: 4,),
                                        SizedBox(
                                          width: 65,
                                          child: ISInput(
                                            autofocus: true,
                                            value: Utils.getTimeFormat(setB_time[4]['openTime'].toString()),
                                            height: 30,
                                            //padding: 0,
                                            context: context,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[LengthLimitingTextInputFormatter(5), MultiMaskedTextInputFormatter(masks: ['x:xx', 'xx:xx'], separator: ':')],
                                            label: '00:00',
                                            onChange: (v) {
                                              String value = v.toString().replaceAll(':', '');
                                              startTemp = v.toString().replaceAll(':', '');

                                              if(int.parse(value) > 2359){
                                                setState(() {
                                                  setB_time[4]['openTime'] = '2359';
                                                });

                                                ISAlert(context, content: '휴게 시작 시간을 23:59 이상 입력 하실 수 없습니다.');

                                              } else {
                                                setB_time[4]['openTime'] = value;
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('   휴게종료', style: TextStyle(fontSize: 12, fontWeight: FONT_NORMAL, fontFamily: FONT_FAMILY)),
                                        const SizedBox(height: 4,),
                                        SizedBox(
                                          width: 65,
                                          child: ISInput(
                                            autofocus: true,
                                            value: Utils.getTimeFormat(setB_time[4]['closeTime'].toString()),
                                            height: 30,
                                            //padding: 0,
                                            context: context,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[LengthLimitingTextInputFormatter(5), MultiMaskedTextInputFormatter(masks: ['x:xx', 'xx:xx'], separator: ':')],
                                            label: '00:00',
                                            onChange: (v) {
                                              String value = v.toString().replaceAll(':', '');
                                              endTemp = v.toString().replaceAll(':', '');

                                              if(int.parse(value) > 2359){
                                                setState(() {
                                                  setB_time[4]['closeTime'] = '2359';
                                                });

                                                ISAlert(context, content: '휴게 종료 시간을 23:59 이상 입력 하실 수 없습니다.');

                                              } else {
                                                setB_time[4]['closeTime'] = value;
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(setB_time[4]['useGbn'] == 'Y'? '설정함' : '설정안함', style: TextStyle(fontSize: 12, fontWeight: FONT_NORMAL, fontFamily: FONT_FAMILY) ),
                                  Switch(
                                      value: setB_time[4]['useGbn'] == 'Y' ? true : false,
                                      onChanged: (v){
                                        setState(() {
                                          if (v == true) {
                                            setB_time[4]['useGbn'] = 'Y';
                                            setB_time[4]['openTime'] = startTemp != '' ? startTemp : '0000';
                                            setB_time[4]['closeTime'] = endTemp != '' ? endTemp : '0000';
                                          } else {
                                            setB_time[4]['useGbn'] = 'N';
                                          }
                                        });
                                      }
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('금요일', style: TextStyle(fontWeight: FONT_BOLD)),
                              SizedBox(width: 20),
                              Visibility(
                                visible: setB_time[5]['useGbn'] == 'Y' ? true : false,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('   휴게시작', style: TextStyle(fontSize: 12, fontWeight: FONT_NORMAL, fontFamily: FONT_FAMILY)),
                                        const SizedBox(height: 4,),
                                        SizedBox(
                                          width: 65,
                                          child: ISInput(
                                            autofocus: true,
                                            value: Utils.getTimeFormat(setB_time[5]['openTime'].toString()),
                                            height: 30,
                                            //padding: 0,
                                            context: context,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[LengthLimitingTextInputFormatter(5), MultiMaskedTextInputFormatter(masks: ['x:xx', 'xx:xx'], separator: ':')],
                                            label: '00:00',
                                            onChange: (v) {
                                              String value = v.toString().replaceAll(':', '');
                                              startTemp = v.toString().replaceAll(':', '');

                                              if(int.parse(value) > 2359){
                                                setState(() {
                                                  setB_time[5]['openTime'] = '2359';
                                                });

                                                ISAlert(context, content: '휴게 시작 시간을 23:59 이상 입력 하실 수 없습니다.');

                                              } else {
                                                setB_time[5]['openTime'] = value;
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('   휴게종료', style: TextStyle(fontSize: 12, fontWeight: FONT_NORMAL, fontFamily: FONT_FAMILY)),
                                        const SizedBox(height: 4,),
                                        SizedBox(
                                          width: 65,
                                          child: ISInput(
                                            autofocus: true,
                                            value: Utils.getTimeFormat(setB_time[5]['closeTime'].toString()),
                                            height: 30,
                                            //padding: 0,
                                            context: context,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[LengthLimitingTextInputFormatter(5), MultiMaskedTextInputFormatter(masks: ['x:xx', 'xx:xx'], separator: ':')],
                                            label: '00:00',
                                            onChange: (v) {
                                              String value = v.toString().replaceAll(':', '');
                                              endTemp = v.toString().replaceAll(':', '');

                                              if(int.parse(value) > 2359){
                                                setState(() {
                                                  setB_time[5]['closeTime'] = '2359';
                                                });

                                                ISAlert(context, content: '휴게 종료 시간을 23:59 이상 입력 하실 수 없습니다.');

                                              } else {
                                                setB_time[5]['closeTime'] = value;
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(setB_time[5]['useGbn'] == 'Y'? '설정함' : '설정안함', style: TextStyle(fontSize: 12, fontWeight: FONT_NORMAL, fontFamily: FONT_FAMILY) ),
                                  Switch(
                                      value: setB_time[5]['useGbn'] == 'Y' ? true : false,
                                      onChanged: (v){
                                        setState(() {
                                          if (v == true) {
                                            setB_time[5]['useGbn'] = 'Y';
                                            setB_time[5]['openTime'] = startTemp != '' ? startTemp : '0000';
                                            setB_time[5]['closeTime'] = endTemp != '' ? endTemp : '0000';
                                          } else {
                                            setB_time[5]['useGbn'] = 'N';
                                          }
                                        });
                                      }
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('토요일', style: TextStyle(fontWeight: FONT_BOLD, color: Colors.blue)),
                              SizedBox(width: 20),
                              Visibility(
                                visible: setB_time[6]['useGbn'] == 'Y' ? true : false,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('   휴게시작', style: TextStyle(fontSize: 12, fontWeight: FONT_NORMAL, fontFamily: FONT_FAMILY)),
                                        const SizedBox(height: 4,),
                                        SizedBox(
                                          width: 65,
                                          child: ISInput(
                                            autofocus: true,
                                            value: Utils.getTimeFormat(setB_time[6]['openTime'].toString()),
                                            height: 30,
                                            //padding: 0,
                                            context: context,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[LengthLimitingTextInputFormatter(5), MultiMaskedTextInputFormatter(masks: ['x:xx', 'xx:xx'], separator: ':')],
                                            label: '00:00',
                                            onChange: (v) {
                                              String value = v.toString().replaceAll(':', '');
                                              startTemp = v.toString().replaceAll(':', '');

                                              if(int.parse(value) > 2359){
                                                setState(() {
                                                  setB_time[6]['openTime'] = '2359';
                                                });

                                                ISAlert(context, content: '휴게 시작 시간을 23:59 이상 입력 하실 수 없습니다.');

                                              } else {
                                                setB_time[6]['openTime'] = value;
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('   휴게종료', style: TextStyle(fontSize: 12, fontWeight: FONT_NORMAL, fontFamily: FONT_FAMILY)),
                                        const SizedBox(height: 4,),
                                        SizedBox(
                                          width: 65,
                                          child: ISInput(
                                            autofocus: true,
                                            value: Utils.getTimeFormat(setB_time[6]['closeTime'].toString()),
                                            height: 30,
                                            //padding: 0,
                                            context: context,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[LengthLimitingTextInputFormatter(5), MultiMaskedTextInputFormatter(masks: ['x:xx', 'xx:xx'], separator: ':')],
                                            label: '00:00',
                                            onChange: (v) {
                                              String value = v.toString().replaceAll(':', '');
                                              endTemp = v.toString().replaceAll(':', '');

                                              if(int.parse(value) > 2359){
                                                setState(() {
                                                  setB_time[6]['closeTime'] = '2359';
                                                });

                                                ISAlert(context, content: '휴게 종료 시간을 23:59 이상 입력 하실 수 없습니다.');

                                              } else {
                                                setB_time[6]['closeTime'] = value;
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(setB_time[6]['useGbn'] == 'Y'? '설정함' : '설정안함', style: TextStyle(fontSize: 12, fontWeight: FONT_NORMAL, fontFamily: FONT_FAMILY) ),
                                  Switch(
                                      value: setB_time[6]['useGbn'] == 'Y' ? true : false,
                                      onChanged: (v){
                                        setState(() {
                                          if (v == true) {
                                            setB_time[6]['useGbn'] = 'Y';
                                            setB_time[6]['openTime'] = startTemp != '' ? startTemp : '0000';
                                            setB_time[6]['closeTime'] = endTemp != '' ? endTemp : '0000';
                                          } else {
                                            setB_time[6]['useGbn'] = 'N';
                                          }
                                        });
                                      }
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Divider(),
                          // 231115 월요일 기준 일괄적용 되는데 일요일이 가장 위에 있어서 아래쪽으로 이동
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('일요일', style: TextStyle(fontWeight: FONT_BOLD, color: Colors.red)),
                              SizedBox(width: 20),
                              Visibility(
                                visible: setB_time[0]['useGbn'] == 'Y' ? true : false,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('   휴게시작', style: TextStyle(fontSize: 12, fontWeight: FONT_NORMAL, fontFamily: FONT_FAMILY)),
                                        const SizedBox(height: 4,),
                                        SizedBox(
                                          width: 65,
                                          child: ISInput(
                                            autofocus: true,
                                            value: Utils.getTimeFormat(setB_time[0]['openTime'].toString()),
                                            height: 30,
                                            //padding: 0,
                                            context: context,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[LengthLimitingTextInputFormatter(5), MultiMaskedTextInputFormatter(masks: ['x:xx', 'xx:xx'], separator: ':')],
                                            label: '00:00',
                                            onChange: (v) {
                                              String value = v.toString().replaceAll(':', '');
                                              startTemp = v.toString().replaceAll(':', '');

                                              if(int.parse(value) > 2359){
                                                setState(() {
                                                  setB_time[0]['openTime'] = '2359';
                                                });

                                                ISAlert(context, content: '휴게 시작 시간을 23:59 이상 입력 하실 수 없습니다.');

                                              } else {
                                                setB_time[0]['openTime'] = value;
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('   휴게종료', style: TextStyle(fontSize: 12, fontWeight: FONT_NORMAL, fontFamily: FONT_FAMILY)),
                                        const SizedBox(height: 4,),
                                        SizedBox(
                                          width: 65,
                                          child: ISInput(
                                            autofocus: true,
                                            value: Utils.getTimeFormat(setB_time[0]['closeTime'].toString()),
                                            height: 30,
                                            //padding: 0,
                                            context: context,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[LengthLimitingTextInputFormatter(5), MultiMaskedTextInputFormatter(masks: ['x:xx', 'xx:xx'], separator: ':')],
                                            label: '00:00',
                                            onChange: (v) {
                                              String value = v.toString().replaceAll(':', '');
                                              endTemp = v.toString().replaceAll(':', '');

                                              if(int.parse(value) > 2359){
                                                setState(() {
                                                  setB_time[0]['closeTime'] = '2359';
                                                });

                                                ISAlert(context, content: '휴게 종료 시간을 23:59 이상 입력 하실 수 없습니다.');

                                              } else {
                                                setB_time[0]['closeTime'] = value;
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(setB_time[0]['useGbn'] == 'Y'? '설정함' : '설정안함', style: TextStyle(fontSize: 12, fontWeight: FONT_NORMAL, fontFamily: FONT_FAMILY) ),
                                  Switch(
                                      value: setB_time[0]['useGbn'] == 'Y' ? true : false,
                                      onChanged: (v){
                                        setState(() {
                                          if (v == true) {
                                            setB_time[0]['useGbn'] = 'Y';
                                            setB_time[0]['openTime'] = startTemp != '' ? startTemp : '0000';
                                            setB_time[0]['closeTime'] = endTemp != '' ? endTemp : '0000';
                                          } else {
                                            setB_time[0]['useGbn'] = 'N';
                                          }
                                        });
                                      }
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
        ),
        actions: [
          SizedBox(
            child: FilledButton(
              style: appTheme.popupButtonStyleLeft,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('취소', style: TextStyle(fontSize: 18, fontFamily: FONT_FAMILY)),
            ),
          ),
          SizedBox(
            child: FilledButton(
              style: appTheme.popupButtonStyleRight,
              onPressed: () {ISConfirm(context, '휴게시간 변경', '휴게시간 정보를 변경하시겠습니까?', constraints: const BoxConstraints(maxWidth: 360.0, maxHeight: 250), (context, isOK) async {
                Navigator.of(context).pop();

                int _daySeq = 0;



                // 시간입력값 4자리 유효성 검사
                setB_time.forEach((v) {
                  if((v['openTime'].length != 4 || v['closeTime'].length != 4) && isOK == true && (v['openTime'] != '' && v['closeTime'].length != '') ) {
                    ISAlert(context, content: '${_dayGbn(_daySeq.toString())} 시간을 정확히 입력 바랍니다.');
                    isOK = false;
                  }
                  _daySeq++;
                });

                _daySeq = 0;
                // // 시작시간, 종료시간 확인(종료시간이 빠를 수 없음)
                // setB_time.forEach((v) {
                //   if((int.parse(v['openTime']) > int.parse(v['closeTime'])) && isOK == true) {
                //     ISAlert(context, content: '${_dayGbn(_daySeq.toString())} 시작 시간이 종료 시간 보다 늦습니다.');
                //     isOK = false;
                //   }
                //   _daySeq++;
                // });

                if (isOK){
                  List<String> dayGbnArr = [];
                  List<String> openTimeArr = [];
                  List<String> closeTimeArr = [];
                  List<String> useGbnArr = [];
                  List<String> nextDayYnArr = [];

                  setB_time.forEach((element){
                    if(element['useGbn'] != 'N'){
                      dayGbnArr.add(element['dayGbn']);
                      openTimeArr.add(element['openTime']);
                      closeTimeArr.add(element['closeTime']);
                      useGbnArr.add(element['useGbn']);
                      nextDayYnArr.add("N");
                    }else{
                      dayGbnArr.add(element['dayGbn']);
                      openTimeArr.add('');
                      closeTimeArr.add('');
                      useGbnArr.add(element['useGbn']);
                      nextDayYnArr.add("N");
                    }
                  });

                  Map<String, dynamic> jsonData = {
                    "shopCd": AuthService.SHOPCD,
                    "sbGbn": 'B',
                    "dayGbn": dayGbnArr,
                    "openTime": openTimeArr,
                    "closeTime": closeTimeArr,
                    "useGbn": useGbnArr,
                    "nextDayYn": nextDayYnArr,
                    "uCode": AuthService.uCode,
                    "uName": AuthService.uName,
                  };

                  String jsonString = jsonEncode(jsonData);

                  var value = await showDialog(
                      context: context,
                      builder: (context) => FutureProgressDialog(ShopController.to.setShopSbTime(jsonString))
                  );

                  if (value == null) {
                    ISAlert(context, content: '정상 처리가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
                  }
                  else {
                    if (value == '00') {
                      Navigator.of(context).pop(true);
                      ISAlert(context, title: '알림', content: '변경이 완료되었습니다.');
                    }
                    else {
                      ISAlert(context, content: '정상 등록되지 않았습니다.\n→ ${value}');
                    }
                  }
                }
              });
              },
              child: const Text('적용', style: TextStyle(fontSize: 18, fontFamily: FONT_FAMILY)),
            ),
          ),
        ],
      ),
    );
  }

  String _dayGbn(String gbn) {
    if(gbn == '0')        {      return '일요일';    }
    else if (gbn == '1')  {      return '월요일';    }
    else if (gbn == '2')  {      return '화요일';    }
    else if (gbn == '3')  {      return '수요일';    }
    else if (gbn == '4')  {      return '목요일';    }
    else if (gbn == '5')  {      return '금요일';    }
    else                  {      return '토요일';    }
  }
}


