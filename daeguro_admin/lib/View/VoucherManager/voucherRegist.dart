import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/ISWidget/is_select_date.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_input.dart';
import 'package:daeguro_admin_app/Model/coupon/couponBrandCodeList.dart';
import 'package:daeguro_admin_app/Model/coupon/couponBrandRegistModel.dart';
import 'package:daeguro_admin_app/Model/coupon/couponTypeList.dart';
import 'package:daeguro_admin_app/Model/voucher/VoucherTypeList.dart';
import 'package:daeguro_admin_app/Model/voucher/voucherRegistModel.dart';
import 'package:daeguro_admin_app/Util/multi_masked_formatter.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/CouponManager/coupon_controller.dart';
import 'package:daeguro_admin_app/View/VoucherManager/voucherReadExcel.dart';
import 'package:daeguro_admin_app/View/VoucherManager/voucher_controller.dart';
import 'package:date_format/date_format.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:collection';
import 'package:excel/excel.dart'as prefix;

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class VoucherRegist extends StatefulWidget {
  const VoucherRegist({Key key}) : super(key: key);

  @override
  _VoucherRegistState createState() => _VoucherRegistState();
}

class _VoucherRegistState extends State<VoucherRegist> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<Map<String, String>> setCust = new List<Map<String, String>>();
  bool isCreateEnabled = false;
  String _input_telNo = '';
  voucherRegistModel formData;
  String _voucherType = '';
  List<SelectOptionVO> _VoucherTypeItems = [];
  List<SelectOptionVO> _VoucherTypeItemsAll = [];
  String _testYn = 'N';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((c) {
      _reset();
    });
    setState(() {
    });
  }

  _reset(){
    formKey.currentState.reset();
    _input_telNo='';
    loadVoucherTypeItemsListData_All();
  }


  loadVoucherTypeItemsListData() async {
    _VoucherTypeItems.clear();
    String _div = _testYn=='Y' ? '1': '' ; //1이면 테스트 상품권, 그 외엔 상용

    await VoucherController.to.getVoucherControllerListItems(_div).then((value) {
      value.forEach((element) {
        VoucherTypeListModel tempData = VoucherTypeListModel.fromJson(element);
        _VoucherTypeItems.add(new SelectOptionVO(value: tempData.CODE, label: '[${tempData.CODE}] '+ tempData.CODE_NM, label2: '[${tempData.CODE}] '+ tempData.CODE_NM));
      });
    });
    setState(() {
    });
  }

  loadVoucherTypeItemsListData_All() async {
    _VoucherTypeItemsAll.clear();
    String _divRevers = _testYn=='Y' ? '': '1' ; //1이면 테스트 상품권, 그 외엔 상용
    //상품권 전체 리스트
    await VoucherController.to.getVoucherControllerListItems(_divRevers).then((value) {
      value.forEach((element) {
        VoucherTypeListModel tempData = VoucherTypeListModel.fromJson(element);
        _VoucherTypeItemsAll.add(new SelectOptionVO(value: tempData.CODE, label: '[${tempData.CODE}] '+ tempData.CODE_NM, label2: '[${tempData.CODE}] '+ tempData.CODE_NM));
      });
    });

    _VoucherTypeItems.clear();
    String _div = _testYn=='Y' ? '1': '' ; //1이면 테스트 상품권, 그 외엔 상용

    await VoucherController.to.getVoucherControllerListItems(_div).then((value) {
      value.forEach((element) {
        VoucherTypeListModel tempData = VoucherTypeListModel.fromJson(element);
        _VoucherTypeItems.add(new SelectOptionVO(value: tempData.CODE, label: '[${tempData.CODE}] '+ tempData.CODE_NM, label2: '[${tempData.CODE}] '+ tempData.CODE_NM));
        _VoucherTypeItemsAll.add(new SelectOptionVO(value: tempData.CODE, label: '[${tempData.CODE}] '+ tempData.CODE_NM, label2: '[${tempData.CODE}] '+ tempData.CODE_NM));
      });
    });
  }

  bool isSame(String telNo, String type){
    bool result = false ;
    if (setCust.length != 0){
      setCust.forEach((element) {
        if(element["tel_no"] == telNo && element["voucher_type"] == type) return result = true;
      });
    }
    return result ;
  }

  _setCustData(){
    if(_voucherType.length < 1) return ISAlert(context, '상품권 타입을 선택하십시오.');
    if(_input_telNo.length < 10) return ISAlert(context, '휴대폰 번호를 입력하십시오.');
    if(isSame(_input_telNo,_voucherType)) return ISAlert(context, '이미 입력된 번호입니다.');
    if(_voucherType!=null&&_input_telNo!=null){
      Map<String, String> data = {"voucher_type": '${_voucherType}', "tel_no": '${_input_telNo}'};
      setState(() {
        setCust.add(data);
        _input_telNo='';
      });
    };
  }

  _readExcelFile() async{
    await openExcelFile().then((value) => {
      if(value==null){
        ISAlert(context, '양식에 맞춰 엑셀 데이터를 등록해주십시오.')
      }else{
        value.forEach((element) {
          if(!isSame(element['tel'],element['type'])){
            Map<String, String> data = {"voucher_type": '${element['type']}', "tel_no": '${element['tel']}'};
            setCust.add(data);
          }
        })
      }
    });
    setState(() {
    });
  }

  _insert() async{
    int error = 0 ;
    /// setCust 의 데이터들을
    /// 등록되어있는 상품권 타입별로 데이터를 나눠서
    /// postDataList 에 옮긴뒤에 post
    await  _VoucherTypeItemsAll.forEach((voucherTypeVal) async {
      List<String> postDataList=[];
      setCust.forEach((setCustVal) {
        if (setCustVal["voucher_type"] == voucherTypeVal.value) {
          postDataList.add(setCustVal["tel_no"]);
        }else{
          error++;
        }
      });

      /// insert에서 성공 > setCust에서 삭제
      /// insert에 실패할 경우 > setCust에 남겨두고 alert 처리
      if(postDataList.length>0) {
        String jsonData = jsonEncode(postDataList);
        var result = await VoucherController.to.postVoucher(voucherTypeVal.value, jsonData);
        if (result != '00') {
          error++;
        } else {
          setState(() {
            postDataList.forEach((element) {
              setCust.removeWhere((cust_element) => cust_element['tel_no'] == element && cust_element['voucher_type'] == voucherTypeVal.value);
            });
          });
        }
      }
    });
    if (error== 0) {
      Navigator.pop(context,true);
    }else{
      ISAlert(context, '발송할 수 없는 상품권 타입들을 제외하고\n정상적으로 저장 되었습니다.\n저장되지 않은 정보들만 리스트에 표시 됩니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
          Column(
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ISSearchDropdown(
                    label: '구분',
                    width: 100,
                    value: _testYn,
                    onChange: (value) {
                      setState(() {
                        _testYn = value;
                        loadVoucherTypeItemsListData();
                      });
                    },
                    item: [
                      DropdownMenuItem(value: 'N', child: Text('상용')),
                      DropdownMenuItem(value: 'Y', child: Text('테스트')),
                    ].cast<DropdownMenuItem<String>>(),
                  ),
                  ISSearchDropdown(
                    label: '상품권 타입',
                    width: 210,
                    value: _voucherType,
                    onChange: (value) {
                      _VoucherTypeItems.forEach((element) {
                        if (value == element.value) {
                          _voucherType = element.value;
                        }
                      });
                    },
                    item: _VoucherTypeItems.map((item) {
                      return new DropdownMenuItem<String>(
                          child: new Text(item.label, style: TextStyle(fontSize: 13, color: Colors.black),),
                          value: item.value);
                    }).toList(),
                  ),
                  ISSearchInput(
                    label: '휴대폰 번호',
                    width: 170,
                    value: Utils.getPhoneNumFormat(_input_telNo, false),
                    // value: CouponController.to.keyword.value,
                    onChange: (v) {
                      setState(() {
                        _input_telNo = v.toString().replaceAll('-', '');
                      });
                    },
                    onFieldSubmitted: (value) {
                      _setCustData();
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      MultiMaskedTextInputFormatter(masks: ['xxx-xxxx-xxxx', 'xxxx-xxxx-xxxx', 'xxx-xxx-xxxx', 'xxxx-xxxx'], separator: '-')
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ISButton(
                    label: '단일 등록',
                    textStyle: TextStyle(color: Colors.white),
                    iconColor: Colors.white,
                    iconData: Icons.save,
                    onPressed: () {
                      _setCustData();
                    },
                  ),
                  SizedBox(width: 10),
                  ISButton(
                    label: '대량 등록',
                    textStyle: TextStyle(color: Colors.white),
                    iconColor: Colors.white,
                    iconData: Icons.save,
                    onPressed: () {
                      _readExcelFile();
                    },
                  ),
                  SizedBox(width: 10)
                ],
              ),
            ],
          ),
          Divider(),
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0), //all(10.0),
            //color: Colors.yellow,
            height: (MediaQuery.of(context).size.height - 430),
            child: ISDatatable(
              listWidth: 480,
              dataRowHeight: 36,
              rows: setCust.map((item) {
                return DataRow(cells: [
                  DataCell(Center(child: SelectableText(item['voucher_type'] ?? '--', style: TextStyle(color: Colors.black), showCursor: true))),
                  DataCell(Align(
                      child: SelectableText(Utils.getPhoneNumFormat(item['tel_no'],false) ?? '--', style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.centerLeft)),
                  DataCell(Center(
                    child: IconButton(
                      onPressed: () {
                        // setCust.removeWhere((element) => element['tel_no'] == item['tel_no'].toString().replaceAll('-', '') );
                        setCust.removeWhere((element) => element['tel_no'] == item['tel_no'].toString() &&  element['voucher_type'] == item['voucher_type'].toString() );

                        setState(() {
                          isCreateEnabled = true;
                        });
                      },
                      icon: Icon(Icons.cancel),
                      tooltip: '삭제',
                    ),
                  )),
                ]);
              }).toList(),
              columns: <DataColumn>[
                DataColumn(
                  label: Expanded(child: Text('상품권타입', textAlign: TextAlign.center)),
                ),
                DataColumn(
                  label: Expanded(child: Text('휴대폰번호', textAlign: TextAlign.left)),
                ),
                DataColumn(
                  label: Expanded(child: Text('삭제', textAlign: TextAlign.center)),
                ),
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
          label: '전송',
          iconData: Icons.save,
          onPressed: () {
            FormState form = formKey.currentState;
            if (!form.validate()) {
              return;
            }
            form.save();
            if(setCust.length<1) return ISAlert(context, '등록하실 데이터를 입력하십시오.');
            _insert();
          },
        ),
        ISButton(
          label: '닫기',
          iconData: Icons.cancel,
          onPressed: () {
            Navigator.pop(context,true);
          },
        )
      ],
    );

    var result = Scaffold(
      appBar: AppBar(
        title: Text('상품권 발송'),
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
      height: 700,
      child: result,
    );
  }
}