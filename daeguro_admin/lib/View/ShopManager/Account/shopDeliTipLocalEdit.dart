

import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_checkbox.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/Model/shop/shop_delitip.dart';
import 'package:daeguro_admin_app/Model/shop/shopsector_address.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:daeguro_admin_app/Util/multi_masked_formatter.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/Util/utils.dart';

import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ShopDeliTipLocalEdit extends StatefulWidget {
  final String shopCode;
  //final ShopSectorInfo sData;
  const ShopDeliTipLocalEdit({Key key, this.shopCode}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShopDeliTipLocalEditState();
  }
}

class ShopDeliTipLocalEditState extends State<ShopDeliTipLocalEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ShopDeliTipModel formData = ShopDeliTipModel();

  List<String> sData_siguList = [];
  List<String> sData_dongList = [];

  List<String> selectedDongList = [];
  List<String> originalDongList = [];

  List<SelectOptionVO> selectBox_Sido = [];
  List<SelectOptionVO> selectBox_Gungu = [];


  bool isAllSelected = false;


  String current_Sido;
  String current_Gungu;

  loadSidoData() async {

    selectBox_Sido.clear();

    await ShopController.to.getSidoData();

    int idx = 0;

    selectBox_Sido.add(new SelectOptionVO(value: '대구광역시', label: '대구광역시'));

    if (idx == 0) {
      current_Sido = '대구광역시';
    }

    loadGunguData(current_Sido);

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

          if (idx == 0) {
            current_Gungu = tempData.gunGuName;
          }

          idx++;
        });
      }
    });

    loadDongData(sido, current_Gungu);

    setState(() {});
  }

  loadDongData(String sido, String gungu) async {

    originalDongList.clear();

    await ShopController.to.getDongData(sido, gungu).then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
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

    formData.tipAmt = '0';

    WidgetsBinding.instance.addPostFrameCallback((c) {
      loadSidoData();
    });
  }

  @override
  void dispose() {
    formData = null;

    sData_siguList.clear();
    sData_dongList.clear();

    selectedDongList.clear();
    originalDongList.clear();

    selectBox_Sido.clear();
    selectBox_Gungu.clear();

    super.dispose();
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
                child: ISSelect(
                  label: '시/도',
                  value: current_Sido ?? '',
                  dataList: selectBox_Sido,
                  onChange: (v){
                    current_Sido = v;
                    loadGunguData(v);
                  },
                  onSaved: (v) {
                    //formData.cLevel = v;
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: ISSelect(
                  label: '군/구',
                  value: current_Gungu ?? '',
                  dataList: selectBox_Gungu,
                  onChange: (v){
                    selectedDongList.clear();
                    current_Gungu = v;
                    isAllSelected = false;

                    loadDongData(current_Sido, current_Gungu);
                  },
                  onSaved: (v) {
                    //formData.cLevel = v;
                  },
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: ISInput(
                  value: formData.tipAmt == null ? '' : Utils.getCashComma(formData.tipAmt) ?? '',
                  context: context,
                  label: '배달팁',
                  prefixIcon: Icon(Icons.money, color: Colors.grey,),
                  onChange: (v) {
                    setState(() {
                      formData.tipAmt = v.toString().replaceAll(',', '');
                    });
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    MultiMaskedTextInputFormatter(masks: ['x,xxx', 'xx,xxx', 'xxx,xxx'], separator: ',')
                  ],
                  // validator: (v) {
                  //   return v.isEmpty ? '[필수] 배달팁' : null;
                  // },
                ),
              ),
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
            ],
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

            if(int.parse(formData.tipAmt) % 100 != 0)
            {
              ISAlert(context, '100 원 단위의 금액만 입력 가능합니다.');
              return;
            }

            formData.tipGbn = '9';
            formData.tipDay = '1';
            formData.tipToStand = '0';

            formData.shopCd = widget.shopCode;
            formData.modUCode = GetStorage().read('logininfo')['uCode'];
            formData.modName = GetStorage().read('logininfo')['name'];

            selectedDongList.forEach((element) async{
              formData.tipFromStand = element;

              //print('formData--> '+formData.toJson().toString());
              await ShopController.to.postDeliTipData(formData.toJson(), context);
            });

            //String jsonData = jsonEncode(selectedDongList);
            //await ShopController.to.postSectorData(widget.shopCode, formData.sidoName, formData.gunGuName, jsonData, context);

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
        title: Text('지역별 배달팁 등록'),
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
      width: 420,
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

