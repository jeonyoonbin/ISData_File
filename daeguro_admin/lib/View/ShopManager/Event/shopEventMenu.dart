import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/Model/shop/shopEventMenuModel.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/AgentManager/agentAccount_Controller.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ShopEventMenu extends StatefulWidget {
  final String shopCode;

  const ShopEventMenu({Key key, this.shopCode}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShopEventMenuState();
  }
}

class ShopEventMenuState extends State<ShopEventMenu> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final List<ShopEventMenuModel> dataMenuList = <ShopEventMenuModel>[];

  int current_tabIdx = 0;
  String _State = ' ';

  loadData() async {
    dataMenuList.clear();

    await ShopController.to.getEventMenuData(widget.shopCode.toString(), _State, '1', '10000').then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      } else {
        value.forEach((element) {
          ShopEventMenuModel tempData = ShopEventMenuModel.fromJson(element);

          if (tempData.FROM_TIME.length > 10) {
            tempData.FROM_TIME = tempData.FROM_TIME.toString().substring(0, 4) +
                '-' + tempData.FROM_TIME.toString().substring(4, 6) +
                '-' + tempData.FROM_TIME.toString().substring(6, 8) +
                ' ' + tempData.FROM_TIME.toString().substring(8, 10) +
                ':' + tempData.FROM_TIME.toString().substring(10, 12);
          } else {
            tempData.FROM_TIME = tempData.FROM_TIME.toString().substring(0, 4) +
                '-' + tempData.FROM_TIME.toString().substring(4, 6) +
                '-' + tempData.FROM_TIME.toString().substring(6, 8);
          }

          if (tempData.TO_TIME.length > 10) {
            tempData.TO_TIME = tempData.TO_TIME.toString().substring(0, 4) +
                '-' + tempData.TO_TIME.toString().substring(4, 6) +
                '-' + tempData.TO_TIME.toString().substring(6, 8) +
                ' ' + tempData.TO_TIME.toString().substring(8, 10) +
                ':' + tempData.TO_TIME.toString().substring(10, 12);
          } else {
            tempData.TO_TIME = tempData.TO_TIME.toString().substring(0, 4) +
                '-' + tempData.TO_TIME.toString().substring(4, 6) +
                '-' + tempData.TO_TIME.toString().substring(6, 8);
          }

          dataMenuList.add(tempData);
        });
      }
    });

    //if (this.mounted) {
      setState(() {

      });
    //}
  }

  @override
  void initState() {
    super.initState();

    Get.put(AgentController());

    WidgetsBinding.instance.addPostFrameCallback((c) {
      // 콜센터 수정 필요시, 추후 삽입예정
      //loadCallCenterListData();
      loadData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ButtonBar buttonBar = ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        ISButton(
          label: '닫기',
          iconData: Icons.cancel,
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );

    var result = Scaffold(
      appBar: AppBar(
        title: Text('라이브 이벤트 메뉴 리스트'),
        actions: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 16.0),
            child: ISSearchDropdown(
              label: '상태',
              width: 100,
              value: _State,
              onChange: (value) {
                setState(() {
                  _State = value;
                });

                loadData();
              },
              item: [
                DropdownMenuItem(value: ' ', child: Text('전체'),),
                DropdownMenuItem(value: '1', child: Text('예정'),),
                DropdownMenuItem(value: '2', child: Text('진행'),),
                DropdownMenuItem(value: '3', child: Text('종료'),),
              ].cast<DropdownMenuItem<String>>(),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container(
          //   padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 10.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     crossAxisAlignment: CrossAxisAlignment.end,
          //     children: [
          //
          //     ],
          //   ),
          // ),
          SizedBox(height: 20,),
          Expanded(child: getHistoryTabView()),
        ],
      ),
      bottomNavigationBar: current_tabIdx == 0 ? buttonBar : null,
    );

    return SizedBox(
      width: 500,
      height: 650,
      child: result,
    );
  }

  Widget getHistoryTabView() {
    return ListView.builder(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      itemCount: dataMenuList.length,
      itemBuilder: (BuildContext context, int index) {
        return dataMenuList != null
            ? GestureDetector(
          // onTap: (){
          //   Navigator.pushNamed(context, '/editor', arguments: UserController.to.userData[index]);
          // },
          child: Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              //leading: Text(dataList[index].siguName),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Text('No.' + dataHistoryList[index].NO.toString() ?? '--', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Container(
                      padding: EdgeInsets.only(top: 5),
                      child: SelectableText(
                        '[' + dataMenuList[index].STATE.toString() + '] ' + dataMenuList[index].FROM_TIME + ' ~ ' + dataMenuList[index].TO_TIME,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        showCursor: true,
                      )),
                  Container(
                      padding: EdgeInsets.only(top: 5),
                      child: SelectableText(
                        '메뉴명 : ' + dataMenuList[index].MENU_NAME,
                        style: TextStyle(fontSize: 12),
                        showCursor: true,
                      )),
                  Divider(thickness: 2),
                  Container(
                      padding: EdgeInsets.only(top: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            dataMenuList[index].EVENT_AMT_GBN == '1'
                                ?  SelectableText('[할인구분 : 할인금액]', style: TextStyle(color: Colors.blue, fontSize: 12), showCursor: true)
                                : SelectableText('[할인구분 : 할인율]', style: TextStyle(color: Colors.green, fontSize: 12), showCursor: true),
                            dataMenuList[index].EVENT_AMT_GBN == '1'
                                ? SelectableText('기존금액 : ' + Utils.getCashComma(dataMenuList[index].MENU_COST.toString()) +
                                                  ' || 할인금액 : ' + Utils.getCashComma(dataMenuList[index].EVENT_AMT.toString()) +
                                                  ' || 최종금액 : ' + Utils.getCashComma(dataMenuList[index].DISC_COST.toString()),
                                        style: TextStyle(fontSize: 12), showCursor: true)
                                : SelectableText('기존금액 : ' + Utils.getCashComma(dataMenuList[index].MENU_COST.toString()) +
                                                  ' || 할인금액 : ' + Utils.getCashComma( (dataMenuList[index].MENU_COST * dataMenuList[index].EVENT_AMT / 100).toString() )  +
                                                  ' (' + Utils.getCashComma(dataMenuList[index].EVENT_AMT.toString()) +
                                                  '%) || 최종금액 : ' + Utils.getCashComma(dataMenuList[index].DISC_COST.toString()),
                                        style: TextStyle(fontSize: 12), showCursor: true)
                        ],
                      ),
                  ),
                  SizedBox(height: 5)
                ],
              ),
            ),
          ),
        )
            : Text('Data is Empty');
      },
    );
  }
}