
import 'dart:async';

import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/Network/BackendService.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

class ShopMoveReview extends StatefulWidget {
  final String mCode;
  final String fromShopCode;
  const ShopMoveReview({Key key, this.mCode, this.fromShopCode}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShopMoveReviewState();
  }
}

class ShopMoveReviewState extends State<ShopMoveReview>  with SingleTickerProviderStateMixin{
  //final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _typeAheadController = TextEditingController();

  //TextEditingController _searchTextEditingController;
  bool isMoveReview = false;
  String searchKeyword ='';

  List<String> suggestions = [];

  @override
  void initState() {
    super.initState();

    Get.put(ShopController());
  }

  @override
  void dispose(){
    super.dispose();

    _typeAheadController.dispose();

  }

  @override
  Widget build(BuildContext context) {
    var result = Scaffold(
      appBar: AppBar(
        title: Text('리뷰 이관'),
      ),
      body: Container(
        child: _buildSearchField(),
      ),
    );
    return SizedBox(
      width: 500,//isDisplayDesktop(context) ? 500 : 1000,
      height: 200,//isDisplayDesktop(context) ? 200 : 1000,
      child: result,
    );
  }

  Widget _buildSearchField(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10,),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.grey,),
              Text(' 가맹점 검색 후 선택하시면 리뷰가 이관됩니다.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
            ],
          ),
        ),
        SizedBox(height: 10,),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          width: 400,
          child: TypeAheadFormField(
            textFieldConfiguration: TextFieldConfiguration(
              //focusNode: searchBoxFocusNode,
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black, fontSize: 16.0),
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: const BorderRadius.all(Radius.circular(6)),),
                  hintText: '가맹점명 검색',
                  hintStyle: TextStyle(color: Colors.black38),
                  contentPadding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
                  suffixIcon: InkWell(
                    child: Icon(Icons.cancel, size: 16, color: Colors.grey,),
                    onTap: (){
                      if (_typeAheadController == null/* || _typeAheadController.text.isEmpty*/){
                        return;
                      }
                      clearSearchKeyword();
                    },
                  )
              ),
              controller: this._typeAheadController,
            ),
            suggestionsCallback: (pattern) async {
              return await BackendService.getCopyMenuShopSuggestions(widget.mCode, pattern);
            },
            itemBuilder: (context, Map<String, String> suggestion){
              return ListTile(
                title: Text(suggestion['shopName'], style: TextStyle(fontSize: 14),),
                subtitle: Text('[${suggestion['shopCd']}]'),
              );
            },
            transitionBuilder: (context, suggstionsBox, controller){
              return suggstionsBox;
            },
            onSuggestionSelected: (Map<String, String> suggestion) async{
              if (AuthUtil.isAuthEditEnabled('103') == false){
                ISAlert(context, '처리 권한이 없습니다. \n\n관리자에게 문의 바랍니다');
                return;
              }

              updateSearchKeyword(suggestion['shopName'].toString());

              if (suggestion['shopCd'].toString() == widget.fromShopCode){
                ISAlert(context, '현재 가맹점과 동일한 가맹점입니다. \n\n가맹점 확인 후, 다시 시도해주세요.');
                return;
              }

              ISConfirm(context, '리뷰 이관', '현재 매장에서 ['+suggestion['shopName'].toString()+'] 매장으로 리뷰를 이관합니다. \n\n계속 진행 하시겠습니까?', (context)  {
                moveReview(suggestion['shopName'].toString(), suggestion['shopCd'].toString());
                Navigator.of(context).pop();
              });
            },
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: AnimatedOpacity(
            opacity: isMoveReview ? 1.0 : 0.0,
            duration: Duration(milliseconds: 700),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.red, size: 18),
                Text('이관이 완료되었습니다.', style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold)),
              ],
            ),
            onEnd: () {
              setState(() {
                isMoveReview = false;
              });
            },
          ),
        )
      ],
    );
  }

  moveReview(String shopName, String toShopCode) async {
    await Future.delayed(Duration(microseconds: 700)).then((value) async {
      //ISProgressDialog(context).showLoadingIndicator(title: '기다려주세요', body: '[$shopName] 리뷰 이관 중');
      ISProgressDialog(context).show(status: '기다려주세요\n\n[$shopName] 리뷰 이관 중');

      await ShopController.to.putMoveReview(context, widget.fromShopCode, toShopCode).then((value){
        ISProgressDialog(context).dismiss();
        setState(() {
          isMoveReview = true;
        });
      });
    });
  }


  void clearSearchKeyword(){
    setState(() {
      _typeAheadController.clear();
      updateSearchKeyword('');
    });
  }

  void updateSearchKeyword(String newKeyword){
    setState(() {
      searchKeyword = newKeyword;
      _typeAheadController.text = searchKeyword;
    });
  }
}
