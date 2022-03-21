import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Model/shop/shopMemoHistoryModel.dart';
import 'package:daeguro_admin_app/Model/shop/shop_history.dart';
import 'package:daeguro_admin_app/Model/shop/shopmenuoptionHistory.dart';
import 'package:daeguro_admin_app/View/AgentManager/agentAccount_Controller.dart';
import 'package:daeguro_admin_app/View/ShopManager/Account/shopAccount_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ShopMemoHistory extends StatefulWidget {
  final String shopCode;

  //final ShopBasicInfo sData;

  const ShopMemoHistory({Key key, this.shopCode}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShopMemoHistoryState();
  }
}

class ShopMemoHistoryState extends State<ShopMemoHistory> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final List<ShopMemoHistoryModel> dataHistoryList = <ShopMemoHistoryModel>[];

  int current_tabIdx = 0;

  loadData() async {
    await ShopController.to.getMemoHistoryData(widget.shopCode.toString(), '1', '10000').then((value) {
      if (value == null) {
        ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
      }
      else {
        value.forEach((element) {
          ShopMemoHistoryModel tempData = ShopMemoHistoryModel.fromJson(element);
          dataHistoryList.add(tempData);
        });

        setState(() {

        });
      }
    });

    // if (this.mounted) {
    //
    // }
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
        title: Text('메모 변경 이력'),
      ),
      body: getHistoryTabView(),
      bottomNavigationBar: current_tabIdx == 0 ? buttonBar : null,
    );

    return SizedBox(
      width: 600,
      height: 750,
      child: result,
    );
  }

  Widget getHistoryTabView() {
    return ListView.builder(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      itemCount: dataHistoryList.length,
      itemBuilder: (BuildContext context, int index) {
        return dataHistoryList != null
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
                        dataHistoryList[index].MEMO ?? '--',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        showCursor: true,
                      )),
                ],
              ),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      alignment: Alignment.centerRight, child: Text(dataHistoryList[index].HIST_DATE.replaceAll('T', ' ') ?? '--', style: TextStyle(fontSize: 12), textAlign: TextAlign.right))
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
