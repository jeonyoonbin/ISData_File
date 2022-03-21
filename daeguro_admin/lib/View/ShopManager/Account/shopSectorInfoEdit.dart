
import 'dart:convert';

import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_checkbox.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/Model/shop/shopsector_address.dart';
import 'package:daeguro_admin_app/Model/shop/shopsector_info.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShopSectorInfoEdit extends StatefulWidget {
  final String shopCode;
  final ShopSectorInfoModel sData;
  const ShopSectorInfoEdit({Key key, this.shopCode, this.sData}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShopSectorInfoEditState();
  }
}

class ShopSectorInfoEditState extends State<ShopSectorInfoEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ShopSectorAddressModel formData;

  List<String> sData_siguList = [];
  List<String> sData_dongList = [];


  List<String> selectedDongList = [];
  List<String> originalDongList = [];

  List<SelectOptionVO> selectBox_Sido = [];
  List<SelectOptionVO> selectBox_Gungu = [];

  bool isAllSelected = false;

  loadSidoData() async {

    selectBox_Sido.clear();

    await ShopController.to.getSidoData();

    int idx = 0;

    selectBox_Sido.add(new SelectOptionVO(value: '대구광역시', label: '대구광역시'));

    if (widget.sData == null){
      if (idx == 0) {
        formData.sidoName = '대구광역시';
      }
    }
    else{
      if (sData_siguList[0] == '대구광역시')
        formData.sidoName = '대구광역시';
    }


    // ShopController.to.qDataAddrSidoList.forEach((e) async {
    //   ShopSectorAddress tempData = ShopSectorAddress.fromJson(e);
    //
    //   selectBox_Sido.add(new SelectOptionVO(value: tempData.sidoName, label: tempData.sidoName));
    //
    //   if (widget.sData == null){
    //     if (idx == 0) {
    //       formData.sidoName = tempData.sidoName;
    //     }
    //   }
    //   else{
    //     if (sData_siguList[0] == tempData.sidoName)
    //       formData.sidoName = tempData.sidoName;
    //   }
    //
    //   idx++;
    // });

    loadGunguData(formData.sidoName);

    selectBox_Gungu.clear();

    setState(() {});
  }

  loadGunguData(String sido) async {

    selectBox_Gungu.clear();

    await ShopController.to.getGunguData(sido).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        int idx = 0;
        value.forEach((e) async {
          ShopSectorAddressModel tempData = ShopSectorAddressModel.fromJson(e);

          selectBox_Gungu.add(new SelectOptionVO(value: tempData.gunGuName, label: tempData.gunGuName));

          if (widget.sData == null){
            if (idx == 0) {
              formData.gunGuName = tempData.gunGuName;
            }
          }
          else{
            if (sData_siguList[1] == tempData.gunGuName)
              formData.gunGuName = tempData.gunGuName;
          }

          idx++;
        });
      }
    });

    loadDongData(sido, formData.gunGuName);

    setState(() {});
  }

  loadDongData(String sido, String gungu) async {

    originalDongList.clear();

    await ShopController.to.getDongData(sido, gungu).then((value) {

      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        value.forEach((e) async {
          ShopSectorAddressModel tempData = ShopSectorAddressModel.fromJson(e);
          originalDongList.add(tempData.dongName);
        });
      }
    });


    setState(() {
      sData_dongList.forEach((element) {
        if (_getCompareData(element)){
          selectedDongList.add(element);
        }
      });

      if (selectedDongList.length == originalDongList.length)
        isAllSelected = true;

    });
  }

  @override
  void initState() {
    super.initState();

    formData = ShopSectorAddressModel();

    if (widget.sData != null){
      sData_siguList = widget.sData.siguName.split(' ');
      sData_dongList = widget.sData.dongName.split(' ');
    }

    WidgetsBinding.instance.addPostFrameCallback((c) {
      loadSidoData();
    });
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
                  child: widget.sData != null
                      ? ISInput(label: '시/도', value: formData.sidoName ?? '', readOnly: true,)
                      : ISSelect(label: '시/도', value: formData.sidoName ?? '', dataList: selectBox_Sido,
                    onChange: (v){
                      formData.sidoName = v;
                      loadGunguData(v);
                    },
                    onSaved: (v) {
                      //formData.cLevel = v;
                    },
                  ),
              ),
              Flexible(
                  flex: 1,
                  child: widget.sData != null
                      ? ISInput(label: '군/구', value: formData.gunGuName ?? '', readOnly: true,)
                      : ISSelect(label: '군/구', value: formData.gunGuName ?? '', dataList: selectBox_Gungu,
                    onChange: (v){
                      selectedDongList.clear();
                      formData.gunGuName = v;
                      isAllSelected = false;

                      loadDongData(formData.sidoName, formData.gunGuName);
                    },
                    onSaved: (v) {
                      //formData.cLevel = v;
                    },
                  ),
              ),
            ],
          ),

          Container(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ISCheckbox(label: '전체 선택',
                    value: isAllSelected,
                    padding: EdgeInsets.only(right: 8),
                    onChanged: (v) {
                      if (isAllSelected == true){
                        selectedDongList.clear();

                        isAllSelected = false;
                      }
                      else{
                        selectedDongList.clear();
                        originalDongList.forEach((element) {
                          selectedDongList.add(element);
                        });

                        isAllSelected = true;
                      }

                      setState(() {});
                    }),
              ],
            ),
          ),
          _DongMultiSelectView(),
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

            String jsonData = jsonEncode(selectedDongList);

            //print('data set->'+jsonData);
            await ShopController.to.postSectorData(widget.shopCode, formData.sidoName, formData.gunGuName, jsonData, context);

            //print('formData--> '+formData.toJson().toString());


            //EasyLoading.showSuccess('등록 성공', maskType: EasyLoadingMaskType.clear);

            Navigator.pop(context, true);
          },
        ),
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
        title: Text(widget.sData == null ? '배송지 신규 등록' : '배송지 정보 수정'),
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
      width: 380,
      height: 540,//isDisplayDesktop(context) ? 540 : 1000,
      child: result,
    );
  }

  bool _getCompareData(String item){
    //print('_getCompareData in');
    bool temp = false;

    for (final element in originalDongList){
      //print('_getCompareData element='+element+', item='+item);
      if (element == item) {
        temp = true;
        break;
      }
    }
    return temp;
  }

  _buildChoiceList(){
    List<Widget> choices = List();

    originalDongList.forEach((item) {
      choices.add(
          Container(
            padding: const EdgeInsets.all(4.0),
            child: ChoiceChip(
              label: Text(item),
              selected: selectedDongList.contains(item),
              onSelected: (selected) {
                setState(() {
                  selectedDongList.contains(item) ? selectedDongList.remove(item) : selectedDongList.add(item);

                  if (selectedDongList.length == originalDongList.length)
                    isAllSelected = true;
                  else
                    isAllSelected = false;
                });
              },
            ),
          ));
    });

    return choices;
  }

  Widget _DongMultiSelectView()
  {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 6.0),
            child: Wrap(
              children: _buildChoiceList(),
            ),
          ),
        ],
      ),
    );
  }
}


