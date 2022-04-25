
import 'dart:async';

import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/Model/shop/shopAccount_menuComplete.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/View/ShopManager/Menu/shopMenuManager.dart';
import 'package:daeguro_admin_app/View/ShopManager/Menu/shopMenuOptionManager.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';

import 'package:daeguro_admin_app/Network/BackendService.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ShopMenuMain extends StatefulWidget {
  final String mCode;
  final String ccCode;
  final String shopCode;
  final String menuComplete;
  const ShopMenuMain({Key key, this.mCode, this.ccCode, this.shopCode, this. menuComplete}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShopMenuMainState();
  }
}

class ShopMenuMainState extends State<ShopMenuMain>  with SingleTickerProviderStateMixin{
  //final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  //final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _typeAheadController = TextEditingController();

  StreamController<bool> mMenu_streamController = StreamController<bool>();
  StreamController<bool> mOption_streamController = StreamController<bool>();

  ShopAccountMenuCompleteModel _menuComplete = new ShopAccountMenuCompleteModel();

  // 메뉴관리 작업완료 버튼 활성 및 비활성화 처리
  String workOut = '';
  Color _color;
  String _eventYn;


  //TextEditingController _searchTextEditingController;
  bool isSearching = false;
  String searchKeyword ='';

  List<String> suggestions = [];

  loadData() async {
    if (this.mounted) {
      await ShopController.to.getEventYn(widget.shopCode).then((value) {
        if (value == null){
          ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
        }
        else{
          _eventYn = value.toString();
          setState(() {});
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();

    Get.put(ShopController());

    operateMenuButton();

    loadData();

    //_searchTextEditingController = new TextEditingController();
    // WidgetsBinding.instance.addPostFrameCallback((c) {
    //   _query();
    // });
  }

  @override
  void dispose(){
    super.dispose();

    _typeAheadController.dispose();

    mMenu_streamController.close();
    mOption_streamController.close();

    mMenu_streamController = null;
    mOption_streamController = null;
  }

  @override
  Widget build(BuildContext context) {
    var result = Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: (){
            //print('------ back press [isSearching]:'+isSearching.toString());
            if (isSearching == true) {
              disableSearching();
            }
            else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: isSearching ? _buildSearchField() : _buildTitle(context),//Text('메뉴 정보'),
        actions: _buildActions(),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 10,),
          Container(height: 300, child: ShopMenuManager(ccCode: widget.ccCode, shopCode: widget.shopCode, streamCallback: mMenu_streamController.stream, eventYn: _eventYn),),
          Divider(height: 20,),
          Container(height: 300, child: ShopMenuOptionManager(ccCode: widget.ccCode,shopCode: widget.shopCode, streamCallback: mOption_streamController.stream, eventYn: _eventYn),),
        ],
      ),
    );
    return SizedBox(
      width: 1000,
      height: 700,//isDisplayDesktop(context) ? 700 : 1000,
      child: result,
    );
  }

  Widget _buildTitle(BuildContext context){
    return new InkWell(
      child: new Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('메뉴 정보')
          ],
        ),
      ),

    );
  }

  Widget _buildSearchField(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Text('메뉴 복사'),
        ),
        Container(
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
                  hintText: '가맹점 검색 후, 선택하시면 메뉴가 복사됩니다.',
                  hintStyle: TextStyle(color: Colors.black38),
                  contentPadding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
                  suffixIcon: InkWell(
                    child: Icon(Icons.cancel, size: 16, color: Colors.grey,),
                    onTap: (){
                      if (_typeAheadController == null/* || _typeAheadController.text.isEmpty*/){
                        return;
                      }
                      disableSearching();//clearSearchKeyword();
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
                //subtitle: Text('\$${suggestion['shopCd']}'),
              );
            },
            transitionBuilder: (context, suggstionsBox, controller){
              return suggstionsBox;
            },
            onSuggestionSelected: (Map<String, String> suggestion) async{
              updateSearchKeyword(suggestion['shopName'].toString());

              if (suggestion['shopCd'].toString() == widget.shopCode){
                ISAlert(context, '현재 가맹점과 동일한 가맹점입니다. \n\n가맹점 확인 후, 다시 시도해주세요.');
                return;
              }

              //updateSearchKeyword(text);
              //disableSearching();

              bool isConfirmed = false;
              ISConfirm(context, '메뉴 복사', '[' + suggestion['shopName'].toString() + '] 매장으로 부터 메뉴를 복사합니다. \n\n계속 진행 하시겠습니까?', (context) async {
                //isConfirmed = true;
                await runCopyMenuOption(suggestion['ccCode'].toString(), suggestion['shopCd'].toString(), suggestion['shopName'].toString());
                Navigator.of(context).pop();
              });
            },
          ),
        ),
      ],
    );
  }

  runCopyMenuOption(String srcCcCode, String srcShopCode, String srcShopName) async {
    await Future.delayed(Duration(milliseconds: 700)).then((value) async {
        //ISProgressDialog(context).showLoadingIndicator(title: '기다려주세요', body: '[$srcShopName] 메뉴 가져오는 중');
        ISProgressDialog(context).show(status: '기다려주세요\n\n[$srcShopName] 메뉴 가져오는 중');
        await ShopController.to.postCopyMenuOptionData(srcCcCode, srcShopCode.toString(), widget.ccCode, widget.shopCode, GetStorage().read('logininfo')['name'], context).then((value) {
          setState(() {
            mMenu_streamController.add(true);
            mOption_streamController.add(true);
          });

          //disableSearching();

          ISProgressDialog(context).dismiss();
        });
    });
  }

  List<Widget> _buildActions(){
    if (isSearching){
      return <Widget>[
        Container(
          //padding: EdgeInsets.only(right: 16),
        ),
        // IconButton(
        //   padding: EdgeInsets.only(right: 40),
        //   icon: Icon(Icons.clear),
        //   onPressed: (){
        //     if (_typeAheadController == null || _typeAheadController.text.isEmpty){
        //       return;
        //     }
        //     clearSearchKeyword();
        //   },
        // ),
      ];
    }

    return <Widget>[
      Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Visibility(
                visible: _eventYn == 'Y' ? true : false,
                child: Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Center(
                        child: Text(
                          '[※ 라이브 이벤트 중입니다. 메뉴 정보 수정이 불가능 합니다.]',
                          style: TextStyle(color: Colors.white),
                        )
                    )
                )
            ),
            Visibility(
              visible: _eventYn == 'Y' ? false : true,
              child: Row(
                  children: [
                    AuthUtil.isAuthEditEnabled('109') == true ? MaterialButton(
                      color: Colors.lightBlue,
                      minWidth: 40,
                      child: Text('메뉴복사용 가맹점 검색', style: TextStyle(color: Colors.white, fontSize: 14),),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                      onPressed: ()  {
                        enableSearch();
                      },
                    ) : Container(),
                    SizedBox(width: 10,),

                    AuthUtil.isAuthEditEnabled('109') == true ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                        primary: _color,
                        textStyle: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'NotoSansKR'),
                      ),
                      child: Text(workOut),
                      onPressed: () {
                        if(workOut == '작업진행') {
                          _menuComplete.MENU_COMPLETE = 'Y';
                          ShopController.to.putMenuComplete(widget.shopCode, _menuComplete.MENU_COMPLETE,null, context);
                          // print('${widget.menuComplete}: 작업완료 여부');
                          // print('${_menuComplete.MENU_COMPLETE}: Model 작업완료 여부');
                          setState(() {
                            _color = Colors.grey;
                            workOut = '작업완료';
                          });
                        } else {
                          _menuComplete.MENU_COMPLETE = 'N';
                          ShopController.to.putMenuComplete(widget.shopCode, _menuComplete.MENU_COMPLETE,null, context);
                          // print('${widget.menuComplete}: 작업완료 여부');
                          // print('${_menuComplete.MENU_COMPLETE}: Model 작업완료 여부');
                          setState(() {
                            _color = Colors.lightBlue;
                            workOut = '작업진행';
                          });
                        }
                      },
                    ) : Container(),
                    SizedBox(width: 10,),

                    AuthUtil.isAuthEditEnabled('109') == true ? MaterialButton(
                      color: Colors.lightBlue,
                      minWidth: 40,
                      child: Text('초기화', style: TextStyle(color: Colors.white, fontSize: 14),),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                      onPressed: ()  {
                        deleteShopMenuOption();
                      },
                    ) : Container()
                  ]
              )
            ),
          ],
        ),
      )
    ];
  }

  void deleteShopMenuOption(){
    ISConfirm(context, '메뉴 초기화', '등록된 메뉴, 옵션정보가 모두 삭제됩니다. \n\n계속 진행 하시겠습니까?', (context) async {
      await ShopController.to.deleteRemoveMenuOptionData(widget.shopCode, context);

      setState(() {
        mMenu_streamController.add(true);
        mOption_streamController.add(true);

        disableSearching();
      });

      Navigator.of(context).pop();
    });
  }

  void enableSearch(){
    //ModalRoute.of(context).addLocalHistoryEntry(new LocalHistoryEntry(onRemove: disableSearching));

    setState(() {
      mMenu_streamController.add(false);
      mOption_streamController.add(false);

      isSearching = true;
    });
  }

  void disableSearching(){
    clearSearchKeyword();

    setState(() {
      mMenu_streamController.add(false);
      mOption_streamController.add(false);
      isSearching = false;
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

  void operateMenuButton(){
    if(widget.menuComplete == 'N'){
      _color = Colors.lightBlue;
      workOut = '작업진행';
    } else {
      _color = Colors.grey;
      workOut = '작업완료';
    }
  }
}
