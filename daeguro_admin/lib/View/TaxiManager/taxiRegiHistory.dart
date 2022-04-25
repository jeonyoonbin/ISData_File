
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/ISWidget/is_select_date.dart';
import 'package:daeguro_admin_app/Model/noticeRegistModel.dart';
import 'package:daeguro_admin_app/Model/taxi/notice/taxiNoticeRegistModel.dart';
import 'package:daeguro_admin_app/Model/taxi/regi/taxiRegiHistMdoel.dart';
import 'package:daeguro_admin_app/Model/taxi/regi/taxiRegiModel.dart';
import 'package:daeguro_admin_app/Util/multi_masked_formatter.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/CouponManager/couponList.dart';
import 'package:daeguro_admin_app/View/CouponManager/coupon_controller.dart';

import 'package:daeguro_admin_app/Network/FileUpLoader.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/NoticeManager/noticeFileUpload.dart';
import 'package:daeguro_admin_app/View/PostCode/postCodeRequest.dart';
import 'package:daeguro_admin_app/constants/constant.dart';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:kopo/kopo.dart';

class TaxiRegiHistory extends StatefulWidget {
  final String shopCd;
  const TaxiRegiHistory({Key key, this.shopCd}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TaxiRegiHistoryState();
  }
}
class TempModel{
  TempModel();

  bool selected = false;
  String no = '1';
  String HIST_DATE = '2022-04-07';
  String MEMO = '신규등록';

}
class TaxiRegiHistoryState extends State<TaxiRegiHistory> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<TempModel> dataHistoryList = <TempModel>[];
  // List<TaxiRegiHistModel> dataHistoryList = <TaxiRegiHistModel>[];
  ScrollController _scrollController;

  loadData() async {
    // await UserController.to.getEventHistoryData(widget.shopCode.toString(), '1', '10000').then((value) {
    //   if (value == null) {
    //     ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
    //   } else {
    //     value.forEach((element) {
    //       UserHistoryModel tempData = UserHistoryModel.fromJson(element);
    //       dataHistoryList.add(tempData);
    //     });
    //   }
    // });
    //
    // //if (this.mounted) {
    // setState(() {
    //
    // });
    // //}
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    dataHistoryList.add(TempModel());
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
        title: Text('사업자 변경 이력'),
      ),
      body: getHistoryTabView(),
      bottomNavigationBar: buttonBar,
    );

    return SizedBox(
      width: 500,
      height: 650,
      child: result,
    );
  }
  Widget getHistoryTabView() {
    return ListView.builder(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
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
