
import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/Model/taxi/regi/taxiRegiModel.dart';
import 'package:daeguro_admin_app/Util/multi_masked_formatter.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/PostCode/postCodeRequest.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:kopo/kopo.dart';

class TaxiRegiRegist extends StatefulWidget {
  const TaxiRegiRegist({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TaxiRegiRegistState();
  }
}

class TaxiRegiRegistState extends State<TaxiRegiRegist> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TaxiRegiModel formData;

  @override
  void dispose(){
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    formData = TaxiRegiModel();
  }

  List<SelectOptionVO> selectBox_type = [
    new SelectOptionVO(value: '1', label: '개인'),
    new SelectOptionVO(value: '5', label: '법인'),
  ];
  List<SelectOptionVO> selectBox_tax = [
    new SelectOptionVO(value: '1', label: '과세'),
    new SelectOptionVO(value: '3', label: '면세'),
  ];
  _searchPost() async {
    if (kIsWeb) {
      showDialog(
          context: context,
          builder: (BuildContext context) => Dialog(
            child: Container(width: 0, height: 0, child: PostCodeRequest()),
          )).then((v) {
        if (v != null) {
          setState(() {
            formKey.currentState.save();

            formData.zipCode = v[0];
            formData.addr1 = v[1];
            formData.addr2 = v[2];

            formData.sidoName = v[3];
            formData.gunguName = v[4];

            if (v[5] == '') {
              formData.roadDestDong = v[6];
              formData.dongName = v[8];
            } else {
              formData.roadDestDong = v[5] + ' ' + v[6];
              formData.dongName = v[5] + ' ' + v[8];
            }

            formData.roadDestDong = v[6];

            List<String> addr1 = [];
            List<String> addr2 = [];

            addr1 = formData.addr1.split(" ");
            addr2 = formData.addr2.split(" ");

            formData.destJibun = addr1.last;
            formData.roadDestAddr = addr2.last;
          });
        }
      });
    } else {
      var v = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => Kopo()));

      if (v != null) {
        setState(() async {
          if (v.userSelectedType == 'R') {
            formData.zipCode = v.zoncode;
            formData.addr1 = v.roadAddress;
          } else {
            formData.zipCode = v.zoncode;
            formData.addr1 = v.jibunAddress;
          }

          formData.zipCode = v.zoncode;
          formData.addr1 = v.jibunAddress;
          formData.addr2 = v.roadAddress;

          // await ShopController.to.getNaverData(formData_BasicInfo.addr1, formData_BasicInfo.addr1);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
          Divider(height: 20,),
          ///상호(법인명)
          Row(
            children: [
              Flexible(
                // flex: 3,
                  child: ISInput(
                    //autofocus: true,
                    value: formData.shopName ?? '',
                    context: context,
                    label: '상호(법인명)*',
                    //readOnly: (formData.useGbn == 'N' || formData.useGbn == '') ? true : false,
                    prefixIcon: Icon(Icons.store, color: Colors.grey,),
                    onChange: (v) {
                      formData.shopName = v;
                    },
                  )
              ),
            ],
          ),
          ///대표자명,사업자등록번호,법인등록번호
          Row(
            children: [
              Flexible(
                flex: 1,
                child: ISInput(
                  value: formData.owner ?? '',
                  context: context,
                  label: '대표자명',
                  prefixIcon: Icon(Icons.person, color: Colors.grey,),
                  textStyle: TextStyle(fontSize: 12),
                  onChange: (v) {
                    formData.owner = v;
                  },
                  // validator: (v) {
                  //   return v.isEmpty ? '[필수] 대표자명': null;
                  // },
                ),
              ),
              Flexible(
                flex: 1,
                child: ISInput(
                  autofocus: true,
                  value: Utils.getStoreRegNumberFormat(formData.regNo, false) ?? '',
                  context: context,
                  label: '사업자등록번호',
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    MultiMaskedTextInputFormatter(masks: ['xxx-xx-xxxxx'], separator: '-')
                  ],
                  prefixIcon: Icon(Icons.confirmation_number, color: Colors.grey,),
                  textStyle: TextStyle(fontSize: 12),
                  onChange: (v) {
                    formData.regNo = v.toString().replaceAll('-', '');
                  },
                  // validator: (v) {
                  //   return v.isEmpty ? '[필수] 사업자등록번호': null;
                  // },
                ),
              ),
              Flexible(
                flex: 1,
                child: ISInput(
                  autofocus: true,
                  value: Utils.getStoreRegNumberFormat(formData.regNo, false) ?? '',
                  context: context,
                  label: '법인등록번호',
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    MultiMaskedTextInputFormatter(masks: ['xxxxxx-xxxxxxx'], separator: '-')
                  ],
                  prefixIcon: Icon(Icons.confirmation_number, color: Colors.grey,),
                  textStyle: TextStyle(fontSize: 12),
                  onChange: (v) {
                    formData.regNo = v.toString().replaceAll('-', '');
                  },
                  // validator: (v) {
                  //   return v.isEmpty ? '[필수] 사업자등록번호': null;
                  // },
                ),
              ),
            ],
          ),
          ///과세구분, 사업자유형
          Row(
            children: [
              Flexible(
                flex: 1,
                child: ISSelect(
                  label: '과세구분(*)',
                  value: formData.bussTaxType,
                  dataList: selectBox_tax,
                  onChange: (v) {
                    setState(() {
                      formData.bussTaxType = v;

                      formKey.currentState.save();
                    });
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: ISSelect(
                  label: '사업자 유형(*)',
                  value: formData.bussType,
                  dataList: selectBox_type,
                  onChange: (v) {
                    setState(() {
                      formData.bussType = v;

                      formKey.currentState.save();
                    });
                  },
                ),
              ),
              Flexible(
                flex: 2,
                child: ISInput(
                  value: formData.bussCon ?? '',
                  context: context,
                  label: '업태',
                  prefixIcon: Icon(Icons.assignment, color: Colors.grey,),
                  textStyle: TextStyle(fontSize: 12),
                  onChange: (v) {
                    formData.bussCon = v;
                  },
                ),
              ),
              Flexible(
                flex: 2,
                child: ISInput(
                  // value: formData.bussType ?? '',
                  context: context,
                  label: '업종',
                  prefixIcon: Icon(Icons.sticky_note_2, color: Colors.grey,),
                  textStyle: TextStyle(fontSize: 12),
                  onChange: (v) {
                    // formData.bussType = v;
                  },
                ),
              ),
            ],
          ),
          ///주소
          Row(
            children: [
              Flexible(
                flex: 5,
                child: ISInput(
                  readOnly: true,
                  value: formData.addr1 ?? '',
                  context: context,
                  label: '구 주소(지번)',
                  prefixIcon: Icon(Icons.home, color: Colors.grey,),
                  textStyle: TextStyle(fontSize: 12),
                  onChange: (v) {
                    formData.addr1 = v;
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: ISButton(
                    height: 40,
                    //padding: EdgeInsets.fromLTRB(10, 20, 0, 20),
                    textStyle: TextStyle(fontSize: 12, color: Colors.white),
                    label: '주소검색',
                    onPressed: () {
                      _searchPost();
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: ISInput(
                  readOnly: true,
                  value: formData.addr2 ?? '',
                  context: context,
                  label: '신 주소(도로명)',
                  prefixIcon: Icon(Icons.home, color: Colors.grey,),
                  textStyle: TextStyle(fontSize: 12),
                  onChange: (v) {
                    formData.addr2 = v;
                  },
                  // validator: (v) {
                  //   return v.isEmpty ? '[필수] 상세주소': null;
                  // },
                ),
              )
            ],
          ),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: ISInput(
                  value: formData.loc ?? '',
                  context: context,
                  label: '상세주소',
                  prefixIcon: Icon(Icons.home, color: Colors.grey,),
                  textStyle: TextStyle(fontSize: 12),
                  onChange: (v) {
                    formData.loc = v;
                  },
                  // validator: (v) {
                  //   return v.isEmpty ? '[필수] 상세주소': null;
                  // },
                ),
              )
            ],
          ),
          Divider(height: 20,),
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

            /// 등록 처리 및 값체크
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
        title: Text('사업자 등록'),
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
      width: 650,
      height: 500,
      child: result,
    );
  }

}
