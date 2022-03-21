

import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_dropdown.dart';
import 'package:daeguro_admin_app/Model/customer/customCouponModel.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/View/CouponManager/coupon_controller.dart';
import 'package:daeguro_admin_app/View/CustomerManager/customer_controller.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CustomerCoupon extends StatefulWidget {
  final String custCode;
  final String custName;

  const CustomerCoupon({Key key, this.custCode, this.custName}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CustomerCouponState();
  }
}

enum RadioGbn { gbn1, gbn2, gbn3, gbn4 }

class CustomerCouponState extends State<CustomerCoupon> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RadioGbn _radioGbn;

  final List<CustomerCouponModel> dataList = <CustomerCouponModel>[];
  String _couponGbn = ' ';//'''IS_C225';

  int totalMileage = 0;

  String _couponStatus = '20';

  loadData() async {
    await CustomerController.to.getCouponData(widget.custCode, _couponStatus).then((value) {
      if (this.mounted) {
        if (value == null) {
          //print('value is NULL');
          ISAlert(context, '정상조회가 되지 않았습니다. \n\n관리자에게 문의 바랍니다');
        }        else {
          setState(() {
            dataList.clear();

            value.forEach((element) {
              CustomerCouponModel tempData = CustomerCouponModel.fromJson(element);

              if (tempData.USE_DATE != null)                tempData.USE_DATE = tempData.USE_DATE.replaceAll('T', '\n');
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
    Get.put(CouponController());

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
          Divider(
            height: 40,
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  '- 쿠폰 세부내역',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  '총 ${dataList.length} 건',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    var buttonBar = Expanded(
      flex: 0,
      child: Container(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Visibility(
                visible: AuthUtil.isAuthCreateEnabled('175') == true,
                child: Row(
                  children: [
                    SizedBox(width: 10.0,),
                    ISSearchDropdown(
                      label: '쿠폰종류',
                      width: 200,
                      value: _couponGbn,
                      onChange: (value) {
                        setState(() {
                          _couponGbn = value;
                        });
                      },
                      item: [
                        DropdownMenuItem(value: ' ', child: Text('쿠폰종류를 선택해 주세요.'),),
                        DropdownMenuItem(value: 'IS_FC100', child: Text('대구로 FC 쿠폰(1,000원)'),),
                        DropdownMenuItem(value: 'IS_FC200', child: Text('대구로 FC 쿠폰(2,000원)'),),
                        DropdownMenuItem(value: 'IS_FC300', child: Text('대구로 FC 쿠폰(3,000원)'),),
                        DropdownMenuItem(value: 'IS_C225', child: Text('이벤트 쿠폰(3,000원)'),),
                        DropdownMenuItem(value: 'IS_C220', child: Text('이벤트 쿠폰(5,000원)'),),
                        DropdownMenuItem(value: 'IS_C510', child: Text('감사 쿠폰(2,000원)'),),
                        DropdownMenuItem(value: 'IS_C500', child: Text('감사 쿠폰(5,000원)'),),
                        DropdownMenuItem(value: 'IS_T100', child: Text('테스트용 쿠폰(500원)'),),
                      ].cast<DropdownMenuItem<String>>(),
                    ),
                    SizedBox(width: 8.0,),
                    ISSearchButton(
                      label: '쿠폰 발행',
                      iconData: Icons.add,
                      textStyle: TextStyle(color: Colors.white),
                      onPressed: (){
                        if (_couponGbn ==  ' '){
                          ISAlert(context, '쿠폰 종류를 선택해 주세요.');
                          return;
                        };

                        ISConfirm(context, '쿠폰 발행', '쿠폰을 발행 하시겠습니까?', (context) async {
                          Navigator.of(context).pop();

                          await CouponController.to.putsetCouponAppCustomer('1', widget.custCode, _couponGbn, '20', context).then((value) {
                            loadData();
                          });
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 16.0),
                alignment: Alignment.centerRight,
                child: ISSearchDropdown(
                  label: '상태',
                  width: 180,
                  value: _couponStatus,
                  onChange: (value) {
                    setState(() {
                      // _currentPage = 1;
                      _couponStatus = value;
                      loadData();
                    });
                  },
                  item: [
                    // DropdownMenuItem(value: '00', child: Text('대기'),),
                    // DropdownMenuItem(value: '10', child: Text('승인'),),
                    DropdownMenuItem(
                      value: '20',
                      child: Text('발행(회원)'),
                    ),
                    DropdownMenuItem(
                      value: '30',
                      child: Text('사용(회원)'),
                    ),
                    DropdownMenuItem(
                      value: '99',
                      child: Text('폐기'),
                    ),
                  ].cast<DropdownMenuItem<String>>(),
                ),
              )
            ]
        )
      )
    );

    var result = Scaffold(
      appBar: AppBar(
        title: Text('회원 쿠폰 내역   [회원명: ${widget.custName}]'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            buttonBar,
            form,
            SizedBox(height: 400, child: getMileageList()),
          ],
        ),
      ),
    );

    return SizedBox(
      width: 650,
      height: 650,//isDisplayDesktop(context) ? 650 : 820,
      child: result,
    );
  }

  Widget getMileageList() {
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
          showCheckboxColumn: false,
          columns: <DataColumn>[
            DataColumn(label: Expanded(child: Text('쿠폰명', textAlign: TextAlign.center)),),
            DataColumn(label: Expanded(child: Text('쿠폰번호', textAlign: TextAlign.left)),),
            DataColumn(label: Expanded(child: Text('발행일자', textAlign: TextAlign.center)),),
            DataColumn(label: Expanded(child: Text('지급일자', textAlign: TextAlign.center)),),
            DataColumn(label: Expanded(child: Text('만료일자', textAlign: TextAlign.center)),),
            DataColumn(label: Expanded(child: Text('사용일자', textAlign: TextAlign.center)),),
            DataColumn(label: Expanded(child: Text('쿠폰금액', textAlign: TextAlign.center)),),
          ],
          //source: listDS,
          rows: dataList.map((item) {
            return DataRow(cells: [
              DataCell(Center(child: SelectableText(item.COUPON_NAME ?? '--', showCursor: true, style: TextStyle(color: Colors.black)))),
              DataCell(Align(child: SelectableText(item.COUPON_NO ?? '--',showCursor: true, style: TextStyle(color: Colors.black)),alignment: Alignment.centerLeft,)),
              DataCell(Center(child: SelectableText(item.INS_DATE ?? '--',showCursor: true, style: TextStyle(color: Colors.black)))),
              DataCell(Center(child: SelectableText(item.ST_DATE ?? '--', showCursor: true, style: TextStyle(color: Colors.black)))),
              DataCell(Center(child: SelectableText(item.EXP_DATE ?? '--',showCursor: true, style: TextStyle(color: Colors.black)))),
              DataCell(Center(child: SelectableText(item.USE_DATE ?? '--',showCursor: true, style: TextStyle(color: Colors.black)))),
              DataCell(Center(child: SelectableText(Utils.getCashComma(item.COUPON_AMT.toString()) ?? '--',showCursor: true, style: TextStyle(color: Colors.black)))),
                ]);
          }).toList(),
        ),
      ],
    );
  }
}
