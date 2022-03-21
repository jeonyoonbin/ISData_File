
import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/Model/apiCompanyDModel.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/View/ApiCompanyManager/apiCompany_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ApiCompanyRegist extends StatefulWidget {
  const ApiCompanyRegist({Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ApiCompanyRegistState();
  }
}

class ApiCompanyRegistState extends State<ApiCompanyRegist> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ApiCompanyDModel formData = ApiCompanyDModel();

  List<SelectOptionVO> selectBox_comType = List();

  @override
  void initState() {
    super.initState();

    selectBox_comType.clear();

    selectBox_comType.add(new SelectOptionVO(value: '1', label: '주문'));
    selectBox_comType.add(new SelectOptionVO(value: '3', label: 'POS(배달)'));

    formData.comType = '1';
  }

  @override
  void dispose() {
    selectBox_comType.clear();

    formData = null;

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
                flex: 3,
                child: ISSelect(
                  label: '업체타입',
                  value: formData.comType,
                  dataList: selectBox_comType,
                  onChange: (value) {
                    setState(() {
                      formData.comType = value;
                    });
                  },
                ),
              ),
              Flexible(
                flex: 3,
                child: ISInput(
                  value: formData.comGbn ?? '',
                  context: context,
                  label: '업체구분',
                  textStyle: TextStyle(fontSize: 12),
                  onChange: (v) {
                    formData.comGbn = v;
                  },
                  validator: (v) {
                    return v.isEmpty ? '[필수] 업체구분' : null;
                  },
                ),
              ),
              Flexible(
                flex: 4,
                child: ISInput(
                  value: formData.comName ?? '',
                  context: context,
                  label: '업체명',
                  textStyle: TextStyle(fontSize: 12),
                  onChange: (v) {
                    formData.comName = v;
                  },
                  validator: (v) {
                    return v.isEmpty ? '[필수] 업체명' : null;
                  },
                ),
              ),
            ],
          ),
          ISInput(
            value: formData.comToken ?? '',
            context: context,
            label: '토큰',
            textStyle: TextStyle(fontSize: 12),
            onChange: (v) {
              formData.comToken = v;
            },
          ),
          ISInput(
            value: formData.comAuth ?? '',
            context: context,
            label: '인증키',
            textStyle: TextStyle(fontSize: 12),
            onChange: (v) {
              formData.comAuth = v;
            },
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

            formData.userCode = GetStorage().read('logininfo')['uCode'];
            formData.userName = GetStorage().read('logininfo')['name'];

            ApiCompanyController.to.postData(formData.toJson(), context);

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
        title: Text('API 연동 업체 등록'),
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
      width: 460,
      height: 300,
      child: result,
    );
  }
}
