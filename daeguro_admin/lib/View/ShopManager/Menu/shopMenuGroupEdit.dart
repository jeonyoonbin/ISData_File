
import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/Model/shop/shopmenugroup_edit.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get_storage/get_storage.dart';

class ShopMenuGroupEdit extends StatefulWidget {
  final ShopMenuGroupEditModel sData;
  final String sShopCode;
  const ShopMenuGroupEdit({Key key, this.sData, this.sShopCode}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShopMenuGroupEditState();
  }
}

class ShopMenuGroupEditState extends State<ShopMenuGroupEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ShopMenuGroupEditModel formData;

  @override
  void initState() {
    super.initState();

    if (widget.sData != null) {
      // print('EditData');
      formData = widget.sData;

      if (formData.sortSeq == '')               formData.sortSeq = null;
      if (formData.groupFileName == '')         formData.groupFileName = null;
      if (formData.insertName == '')            formData.insertName = null;
    }
    else{
      // print('NewData');
      formData = ShopMenuGroupEditModel();
      formData.menuGroupCd = '';
      formData.menuGroupMemo = '';
      formData.useYn = 'Y';
      formData.optionYn = 'Y';
      formData.mainImageYn = 'N';
      formData.sortSeq = '';
      formData.groupFileName = '';
      formData.insertName = '';
    }

    formData.shopCd = widget.sShopCode;

    // WidgetsBinding.instance.addPostFrameCallback((c) {
    //   _query();
    // });
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
          ISInput(
            autofocus: true,
            value: formData.menuGroupName ?? '',
            context: context,
            height: 64,
            inputFormatters: <TextInputFormatter>[
              BlacklistingTextInputFormatter(RegExp('[;]')),
            ],
            //padding: 0,
            label: '그룹이름',
            maxLength: 25,
            onChange: (v) {
              formData.menuGroupName = v;
            },
          ),
          ISInput(
            value: formData.menuGroupMemo ?? '',
            context: context,
            height: 120,
            //padding: 0,
            label: '그룹메모',
            keyboardType: TextInputType.multiline,
            maxLines: 8,
            maxLength: 250,
            onChange: (v) {
              formData.menuGroupMemo = v;
            },
          ),
          Divider(height: 20,),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            decoration: new BoxDecoration(
                color: formData.useYn == 'Y' ? Colors.blue[200] : Colors.red[200],
                borderRadius: new BorderRadius.circular(6.0)),
            child: SwitchListTile(
              dense: true,
              value: formData.useYn == 'Y' ? true : false,
              title: Text(
                '사용',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
              onChanged: (v) {
                setState(() {
                  formData.useYn = v ? 'Y' : 'N';
                  formKey.currentState.save();
                });
              },
            ),
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
          onPressed: () {
            FormState form = formKey.currentState;
            if (!form.validate()) {
              return;
            }

            form.save();

            String titleStr = '메뉴그룹 변경';
            String commentStr = '변경된 정보를 저장합니다.';

            if (widget.sData == null){
              titleStr = '메뉴그룹 등록';
              commentStr = '새로운 메뉴그룹을 등록합니다.';
            }

            formData.insertName = GetStorage().read('logininfo')['name'];

            // print('formData--> '+formData.toJson().toString());

            if (widget.sData == null)              ShopController.to.postMenuGroupDetailData(widget.sShopCode, formData.toJson(), context);
            else                                   ShopController.to.putMenuGroupDetailData(widget.sShopCode, formData.toJson(), context);

            //EasyLoading.showSuccess('등록 성공', maskType: EasyLoadingMaskType.clear);

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
        title: Text(widget.sData == null ? '메뉴그룹 신규 등록' : '메뉴그룹 정보 수정'),
      ),
      body: Column(
        children: [
          SizedBox(height: 15),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: form
          ),
        ],
      ),
      bottomNavigationBar: buttonBar,
    );
    return SizedBox(
      width: 400,
      height: 420,//600 : 1000,
      child: result,
    );
  }
}
