

import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CalculateSearchShopTax_Detail extends StatefulWidget {
  final Map<String,dynamic> items;

  const CalculateSearchShopTax_Detail({Key key, this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CalculateSearchShopTax_DetailState();
  }
}

class CalculateSearchShopTax_DetailState extends State<CalculateSearchShopTax_Detail> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    //print(widget.items.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
          Row(
            children: [
              Flexible(
                flex: 2,
                child: ISInput(value: widget.items['shopCd'].toString() ?? '', readOnly: true, label: '가맹점 코드', textStyle: TextStyle(fontSize: 12),),
              ),
              Flexible(
                flex: 5,
                child: ISInput(value: widget.items['shopName'].toString() ?? '', readOnly: true, label: '가맹점 명', textStyle: TextStyle(fontSize: 12)),
              ),
              Flexible(
                flex: 3,
                child: ISInput(value: widget.items['taxNo'].toString() ?? '', readOnly: true, label: '일련번호', textStyle: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: ISInput(value: widget.items['fdiaGbn'].toString() =='1' ? '인성' : '', readOnly: true, label: '업무구분', textStyle: TextStyle(fontSize: 12)),
              ),
              Flexible(
                flex: 1,
                child: ISInput(value: widget.items['taxAcc'].toString() == 'null' ? '' : widget.items['taxAcc'].toString(), readOnly: true, label: '매출계정', textStyle: TextStyle(fontSize: 12)),
              ),
              Flexible(
                flex: 1,
                child: ISInput(value: widget.items['saleGbn'].toString() == 'null' ? '' : widget.items['saleGbn'].toString(), readOnly: true, label: '매입/매출 구분', textStyle: TextStyle(fontSize: 12)),
              ),
              Flexible(
                flex: 1,
                child: ISInput(value: Utils.getYearMonthDayFormat(widget.items['issymd'].toString()), readOnly: true, label: '처리일자', textStyle: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          Divider(),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: ISInput(value: widget.items['reqDate'].toString() ?? '', readOnly: true, label: '전자세금계산서 청구시간', textStyle: TextStyle(fontSize: 12)),
              ),
              Flexible(
              flex: 1,
              child: ISInput(value: _getStatus(widget.items['status'].toString()), readOnly: true, label: '전자세금계산서 청구상태', textStyle: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: ISInput(value: widget.items['rtnDate'].toString() ?? '', readOnly: true, label: '전자세금계산서 응답시간', textStyle: TextStyle(fontSize: 12)),
              ),
              Flexible(
                flex: 1,
                child: ISInput(value: widget.items['rtnMsg'].toString() ?? '', readOnly: true, label: '전자세금계산서 응답결과', textStyle: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          Divider(),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: ISInput(value: Utils.getCashComma(widget.items['supamt'].toString()), readOnly: true, label: '공급가 합계', textAlign: TextAlign.right, textStyle: TextStyle(fontSize: 12)),
              ),
              Flexible(
                flex: 1,
                child: ISInput(value: Utils.getCashComma(widget.items['vatamt'].toString()), readOnly: true, label: '부가세 합계', textAlign: TextAlign.right, textStyle: TextStyle(fontSize: 12)),
              ),
              Flexible(
                flex: 1,
                child: ISInput(value: Utils.getCashComma(widget.items['amt'].toString()), readOnly: true, label: '금액 합계', textAlign: TextAlign.right, textStyle: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          Divider(),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: ISInput(value: widget.items['receiptId'].toString() ?? '', readOnly: true, label: '국세청 접수번호', textStyle: TextStyle(fontSize: 12)),
              ),
              Flexible(
                flex: 1,
                child: ISInput(value: widget.items['taxGbn'].toString() == 'null' ? '' : widget.items['taxGbn'].toString(), readOnly: true, label: '세금계산서 구분', textStyle: TextStyle(fontSize: 12)),
              ),
              Flexible(
                flex: 1,
                child: ISInput(value: widget.items['prtGbn'].toString() == 'null' ? '' : widget.items['prtGbn'].toString() , readOnly: true, label: '청구/영수 구분', textStyle: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: ISInput(value: widget.items['etaxYn'].toString() == 'null' ? '' : widget.items['etaxYn'].toString(), readOnly: true, label: '전자세금계산서 사용유무', textStyle: TextStyle(fontSize: 12)),
              ),
              Flexible(
                flex: 1,
                child: ISInput(value: widget.items['etaxSeq'].toString() ?? '', readOnly: true, label: '전자세금계산서 일련번호', textStyle: TextStyle(fontSize: 12)),
              ),
              Flexible(
                flex: 1,
                child: ISInput(value: widget.items['prtDate'].toString() ?? '', readOnly: true, label: '전자세금계산서 발행일자', textStyle: TextStyle(fontSize: 12)),
              ),
            ]
          ),
          Divider(),
          ISInput(value: widget.items['canReason'].toString() ?? '', readOnly: true, label: '반려사유', textStyle: TextStyle(fontSize: 12)),
          ISInput(value: widget.items['memo'].toString() == 'null' ? '' : widget.items['memo'].toString(), readOnly: true, label: '메모', textStyle: TextStyle(fontSize: 12)),
        ],
      ),
    );

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
        title: Text('전자세금계산서 상세'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: form
            ),
          ],
        ),
      ),
      bottomNavigationBar: buttonBar,
    );
    return SizedBox(
      width: 500,
      height: 700,
      child: result,
    );
  }

  String _getStatus(String value) {
    String retValue = '--';

    if (value.toString().compareTo('RDY') == 0)             retValue = '[$value] 세금계산서 발행 요청';
    else if (value.toString().compareTo('RD1') == 0)        retValue = '[$value] 세금계산서 발행 처리 중';
    else if (value.toString().compareTo('SND') == 0)        retValue = '[$value] 세금계산서 발행';
    else if (value.toString().compareTo('RCV') == 0)        retValue = '[$value] 세금계산서 수신';
    else if (value.toString().compareTo('ACK') == 0)        retValue = '[$value] 세금계산서 승인';
    else if (value.toString().compareTo('CAN') == 0)        retValue = '[$value] 세금계산서 반려';
    else if (value.toString().compareTo('NLR') == 0)        retValue = '[$value] 국세청 전송';
    else if (value.toString().compareTo('NLW') == 0)        retValue = '[$value] 국세청 응답대기';
    else if (value.toString().compareTo('NLE') == 0)        retValue = '[$value] 국세청 응답에러';
    else if (value.toString().compareTo('NLF') == 0)        retValue = '[$value] 국세청 제출완료';
    else if (value.toString().compareTo('ERR') == 0)        retValue = '[$value] 세금계산서 에러';
    else if (value.toString().compareTo('CCR') == 0)        retValue = '[$value] 세금계산서 삭제요청';
    else if (value.toString().compareTo('DEL') == 0)        retValue = '[$value] 세금계산서 삭제';
    else
      retValue = value;

    return retValue;
  }
}
