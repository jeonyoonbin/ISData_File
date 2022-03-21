

import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/Model/customer/customerMileageModel.dart';
import 'package:daeguro_admin_app/View/CustomerManager/customer_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';


class CustomerMileage extends StatefulWidget {
  final String custCode;
  final String custName;

  const CustomerMileage({Key key, this.custCode, this.custName})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CustomerMileageState();
  }
}

class CustomerMileageState extends State<CustomerMileage> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final List<CustomerMileageModel> dataList = <CustomerMileageModel>[];

  int totalMileage = 0;

  loadData() async {
    await CustomerController.to.getMileageData(widget.custCode).then((value) {
      if (this.mounted) {
        if (value == null) {
          //print('value is NULL');
          ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
        }
        else{
          setState(() {

            totalMileage = CustomerController.to.totalMileage;
            dataList.clear();

            value.forEach((element) {
              CustomerMileageModel tempData = CustomerMileageModel.fromJson(element);
              if (tempData.LOG_DATE != null)
                tempData.LOG_DATE = tempData.LOG_DATE.replaceAll('T', '  ');

              dataList.add(tempData);
            });
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();

    Get.put(CustomerController());

    WidgetsBinding.instance.addPostFrameCallback((c) {
      loadData();
    });
  }

  @override
  void dispose() {
    dataList.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(top: 30),
                child: Text('마일리지 총액 : ', style: TextStyle(fontSize: 14),)
              ),
              SizedBox(width: 10,),
              Text(totalMileage.toString(), style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),),
            ],
          ),
          Divider(
            height: 40,
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 10),
                child: Text('- 마일리지 세부내역', style: TextStyle(fontSize: 14),),
              ),
              Container(
                padding: const EdgeInsets.only(right: 10),
                child: Text('총 ${dataList.length} 건', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
              ),
            ],
          ),
        ],
      ),
    );

    var result = Scaffold(
      appBar: AppBar(
        title: Text('회원 마일리지 내역   [회원명: ${widget.custName}]'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            form,
            SizedBox(height: 400, child: getMileageList()),
          ],
        ),
      ),
    );

    return SizedBox(
      width: 700,
      height: 650,//isDisplayDesktop(context) ? 650 : 820,
      child: result,
    );
  }

  Widget getMileageList(){
    return ListView(
      padding: const EdgeInsets.only(left: 16, right: 16),
      children: <Widget>[
        DataTable(
          headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blue[50]),
          headingTextStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'NotoSansKR', color: Colors.black54, fontSize: 12),
          headingRowHeight: 30,
          dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white),
          dataTextStyle: TextStyle(fontWeight: FontWeight.normal, fontFamily: 'NotoSansKR', fontSize: 12),
          columnSpacing: 0,
          columns: <DataColumn>[
            DataColumn(label: Expanded(child: Text('주문번호', textAlign: TextAlign.left)),),
            DataColumn(label: Expanded(child: Text('주문일자', textAlign: TextAlign.left)),),
            DataColumn(label: Expanded(child: Text('상점명', textAlign: TextAlign.left)),),
            DataColumn(label: Expanded(child: Text('사업자번호', textAlign: TextAlign.left)),),
            DataColumn(label: Expanded(child: Text('마일리지 적립', textAlign: TextAlign.left)),),
            DataColumn(label: Expanded(child: Text('메모', textAlign: TextAlign.center)),),
          ],
          //source: listDS,
          rows: dataList.map((item) {
            return DataRow(
                cells: [
              DataCell(Align(child: SelectableText(item.ORDER_NO.toString() ?? '--', showCursor: true, style: TextStyle(color: Colors.black),), alignment: Alignment.centerLeft,)),
              DataCell(Align(child: SelectableText(item.ORDER_DATE.toString() ?? '--', showCursor: true, style: TextStyle(color: Colors.black)), alignment: Alignment.centerLeft,)),
              DataCell(Align(child: SelectableText(item.SHOP_NAME.toString() ?? '--', showCursor: true, style: TextStyle(color: Colors.black)), alignment: Alignment.centerLeft,)),
              DataCell(Align(child: SelectableText(item.REG_NO.toString() ?? '--', showCursor: true, style: TextStyle(color: Colors.black)), alignment: Alignment.centerLeft,)),
              DataCell(
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SelectableText(item.LOG_GBN+'('+ item.MILEAGE_AMT.toString() +')', style: TextStyle(color: item.LOG_GBN.contains('적립') == true ? Colors.red : Colors.blue, fontWeight: FontWeight.bold),  showCursor: true),
                      SelectableText(item.LOG_DATE ?? '--', style: TextStyle(fontSize: 10, color: Colors.black), showCursor: true),
                    ],
                  ),
              ),
              DataCell(Center(child: SelectableText(item.MEMO,  showCursor: true, style: TextStyle(color: Colors.black)) ?? '--')),

            ]);
          }).toList(),
        ),
      ],
    );
  }
}
