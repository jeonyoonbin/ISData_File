import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';

import 'package:daeguro_admin_app/Model/agentDetailModel.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/View/AgentManager/agentAccount_Controller.dart';
import 'package:daeguro_admin_app/View/PostCode/postCodeRequest.dart';

import 'package:daeguro_admin_app/Util/multi_masked_formatter.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/Util/utils.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kopo/kopo.dart';


import 'package:flutter/foundation.dart' show kIsWeb;

class AgentAccountEdit extends StatefulWidget {
  final AgentDetailModel sData;

  const AgentAccountEdit({Key key, this.sData}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AgentAccountEditState();
  }
}

class AgentAccountEditState extends State<AgentAccountEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AgentDetailModel formData;

  List<SelectOptionVO> selectBox_mCode = List();

  List<SelectOptionVO> selectBox_cLevel = [
    new SelectOptionVO(value: '1', label: '본사'),
    new SelectOptionVO(value: '3', label: '지점'),
  ];

  List<SelectOptionVO> selectBox_useGbn = [
    new SelectOptionVO(value: 'Y', label: '사용'),
    new SelectOptionVO(value: 'N', label: '미사용'),
  ];

  _query() async {
    selectBox_mCode.clear();

    // await AgentController.to.getDataMCodeItems();
    // AgentController.to.qDataMCodeItems.forEach((element) {
    //   selectBox_mCode.add(new SelectOptionVO(value: element['mCode'], label: element['mName']));
    // });

    List MCodeListitems = Utils.getMCodeList();
    MCodeListitems.forEach((element) {
      selectBox_mCode.add(new SelectOptionVO(value: element['mCode'], label: element['mName']));
    });

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    //formKey.currentState.reset();

    if (widget.sData != null) {
      formData = widget.sData;
    } else {
      formData = AgentDetailModel();
      formData.ccCode = '0';
      formData.cLevel = '1';
      formData.useGbn = 'Y';
      formData.mCode = 2;
    }

    WidgetsBinding.instance.addPostFrameCallback((c) {
      _query();
    });
  }

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
          });
        }
      });
    } else {
      var v = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => Kopo()));

      if (v != null) {
        setState(() {
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
          Row(
            children: <Widget>[
              Flexible(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                    decoration: new BoxDecoration(
                        color: formData.useGbn == 'Y' ? Colors.blue[200] : Colors.red[200],
                        borderRadius: new BorderRadius.circular(6)
                    ),
                    child: SwitchListTile(
                      dense: true,
                      value: formData.useGbn == 'Y' ? true : false,
                      title: Text('사용 여부', style: TextStyle(fontSize: 12, color: Colors.white),),
                      onChanged: (v) {
                        setState(() {
                          formData.useGbn = v ? 'Y' : 'N';
                          formKey.currentState.save();
                        });
                      },
                    ),
                  ),
              ),
              Flexible(
                  flex: 1,
                  child: widget.sData == null
                      ? ISSelect(
                        label: '*회원사명',
                        value: formData.mCode.toString(),
                        dataList: selectBox_mCode,
                        onChange: (v) {
                          formData.mCode = int.parse(v);
                        })
                      : Container(),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: ISInput(
                  value: formData.ccCode.compareTo('0') == 0 ? '신규' : formData.ccCode,
                  //formData.ccCode ?? '',
                  label: '*콜센터코드',
                  readOnly: true,
                  onSaved: (v) {
                    formData.ccCode.compareTo('0') == 0 ? formData.ccCode = '0' : formData.ccCode = v;
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: ISSelect(
                  label: '*콜센터레벨',
                  value: formData.cLevel,
                  dataList: selectBox_cLevel,
                  onChange: (v) {
                    formData.cLevel = v;
                  },
                ),
              ),
              Flexible(
                flex: 2,
                child: ISInput(
                  autofocus: widget.sData == null ? true : false,
                  value: formData.ccName ?? '',
                  label: '콜센터명',
                  context: context,
                  onChange: (v) {
                    formData.ccName = v;
                  },
                  // validator: (v) {
                  //   return v.isEmpty ? '[필수] 콜센타명' : null;
                  // },
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Flexible(
                flex: 2,
                child: ISInput(
                  value: Utils.getStoreRegNumberFormat(formData.regNo, false) ?? '',
                  context: context,
                  label: '사업자등록번호',
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    MultiMaskedTextInputFormatter(masks: ['xxx-xx-xxxxx'], separator: '-')
                  ],
                  onChange: (v) {
                    formData.regNo = v.toString().replaceAll('-', '');

                    //print(formData.regNo);
                  },
                ),
              ),
              Flexible(
                flex: 3,
                child: ISInput(
                  value: formData.bussType ?? '',
                  context: context,
                  label: '업종',
                  onChange: (v) {
                    formData.bussType = v;
                  },
                ),
              ),
              Flexible(
                flex: 3,
                child: ISInput(
                  value: formData.bussCon ?? '',
                  context: context,
                  label: '업태',
                  onChange: (v) {
                    formData.bussCon = v;
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
                  value: formData.owner ?? '',
                  context: context,
                  label: '대표자명',
                  onChange: (v) {
                    formData.owner = v;
                  },
                ),
              ),

              Flexible(
                flex: 1,
                child: ISInput(
                  value: formData.email ?? '',
                  context: context,
                  label: '이메일',
                  onChange: (v) {
                    formData.email = v;
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
                  value: formData.bankCode ?? '',
                  context: context,
                  label: '은행코드',
                  onChange: (v) {
                    formData.bankCode = v;
                  },
                ),
              ),
              Flexible(
                flex: 3,
                child: ISInput(
                  value: formData.accountNo ?? '',
                  context: context,
                  label: '계좌번호',
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                  onChange: (v) {
                    formData.accountNo = v;
                  },
                ),
              ),
              Flexible(
                flex: 2,
                child: ISInput(
                  value: formData.accOwner ?? '',
                  context: context,
                  label: '예금주명',
                  onChange: (v) {
                    formData.accOwner = v;
                  },
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Flexible(
                flex: 2,
                child: ISInput(
                  value: formData.ddd ?? '',
                  context: context,
                  label: '*지역번호',
                  onChange: (v) {
                    formData.ddd = v;
                  },
                  // validator: (v) {
                  //   return v.isEmpty ? '[필수] 지역번호' : null;
                  // },
                ),
              ),
              Flexible(
                flex: 3,
                child: ISInput(
                  value: Utils.getPhoneNumFormat(formData.telNo, false) ?? '',
                  context: context,
                  label: '전화번호',
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    MultiMaskedTextInputFormatter(masks: ['xxx-xxxx-xxxx', 'xxxx-xxxx-xxxx', 'xxx-xxx-xxxx', 'xxxx-xxxx'], separator: '-')
                  ],
                  onChange: (v) {
                    setState(() {
                      formData.telNo = v.toString().replaceAll('-', '');
                    });
                  },
                ),
              ),
              Flexible(
                flex: 3,
                child: ISInput(
                  value: Utils.getPhoneNumFormat(formData.mobile, false) ?? '',
                  context: context,
                  label: '휴대전화',
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    MultiMaskedTextInputFormatter(masks: ['xxx-xxxx-xxxx', 'xxxx-xxxx-xxxx', 'xxx-xxx-xxxx', 'xxxx-xxxx'], separator: '-')
                  ],
                  onChange: (v) {
                    setState(() {
                      formData.mobile = v.toString().replaceAll('-', '');
                    });
                  },
                ),
              ),
              Flexible(
                flex: 3,
                child: ISInput(
                  value: formData.faxNo ?? '',
                  context: context,
                  label: '팩스번호',
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    MultiMaskedTextInputFormatter(masks: ['xxx-xxxx-xxxx', 'xxxx-xxxx-xxxx', 'xxx-xxx-xxxx', 'xxxx-xxxx'], separator: '-')
                  ],
                  onChange: (v) {
                    setState(() {
                      formData.faxNo = v.toString().replaceAll('-', '');
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            width: 300,
          ),
          Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: ISInput(
                  value: formData.zipCode ?? '',
                  readOnly: true,
                  label: '우편번호',
                  onChange: (v) {
                    formData.zipCode = v;
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(right: 24),
                  child: ISButton(
                    height: 40,
                    textStyle: TextStyle(fontSize: 12, color: Colors.white),
                    label: '주소검색',
                    onPressed: () {
                      _searchPost();
                    },
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: ISInput(
                  value: formData.addr1 ?? '',
                  context: context,
                  label: '구 주소(지번)',
                  onChange: (v) {
                    formData.addr1 = v;
                  },
                ),
              ),
            ],
          ),
          ISInput(
            value: formData.addr2 ?? '',
            context: context,
            label: '신 주소(도로명)',
            maxLines: 1,
            onChange: (v) {
              formData.addr2 = v;
            },
          ),
          ISInput(
            value: formData.memo ?? '',
            context: context,
            label: '메모',
            maxLines: 8,
            height: 100,
            keyboardType: TextInputType.multiline,
            onChange: (v) {
              formData.memo = v;
            },
          ),
          Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: ISInput(
                  value: formData.insert_Date ?? '',
                  label: '사용 등록일자',
                  readOnly: true,
                  onChange: (v) {
                    formData.insert_Date = v;
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: ISInput(
                  value: formData.closed_Date ?? '',
                  label: '미사용 등록일자',
                  readOnly: true,
                  onChange: (v) {
                    formData.closed_Date = v;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );

    ButtonBar buttonBar = ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        if (AuthUtil.isAuthEditEnabled('3') == true)
        ISButton(
          label: '저장',
          iconData: Icons.save,
          onPressed: () {
            FormState form = formKey.currentState;
            if (!form.validate()) {
              return;
            }

            form.save();

            if (formData.ccName == '' || formData.ccName == null) {
              ISAlert(context, '콜센터명을 확인해주세요.');
              return;
            }

            if (formData.ddd == '' || formData.ddd == null) {
              ISAlert(context, '지역번호를 확인해주세요.');
              return;
            }

            //print('formData.toJson():'+formData.toJson().toString());

            AgentController.to.postData(formData.toJson(), context);

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
        title: Text(widget.sData == null ? '콜센터 신규 등록' : '콜센터 정보 수정'),
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
      width: 550,
      height: 700,
      child: result,
    );
  }
}
