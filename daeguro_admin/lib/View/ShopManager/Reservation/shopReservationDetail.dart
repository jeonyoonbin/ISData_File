import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:flutter/material.dart';

class ShopReservationDetail extends StatefulWidget {
  final Map data;
  final String shopName;

  // final logDetailModel sData;
  const ShopReservationDetail({Key key, this.data, this.shopName}) : super(key: key);

  @override
  ShopReservationDetailState createState() => ShopReservationDetailState();
}

class ShopReservationDetailState extends State<ShopReservationDetail> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var data = Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          children: [
            Align(
              child: Text(widget.shopName, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              alignment: Alignment.centerLeft,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Align(
                  child: Text('[예약번호]', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  alignment: Alignment.centerLeft,
                ),
                SizedBox(width: 5),
                Align(
                    child: SelectableText(
                      widget.data['orderNo'].toString(),
                      style: TextStyle(fontSize: 14),
                      showCursor: true,
                    ),
                    alignment: Alignment.centerLeft),
                SizedBox(width: 20),
                Align(
                  child: Text('[고객 정보]', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  alignment: Alignment.centerLeft,
                ),
                SizedBox(width: 5),
                Align(
                    child: SelectableText(
                      '[' + widget.data['custName'].toString() + '] ' + Utils.getPhoneNumFormat(widget.data['custTelno'], true).toString(),
                      style: TextStyle(fontSize: 14),
                      showCursor: true,
                    ),
                    alignment: Alignment.centerLeft),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Align(
                  child: Text('[예약 시간]', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  alignment: Alignment.centerLeft,
                ),
                SizedBox(width: 5),
                Align(
                    child: SelectableText(
                      Utils.getYearMonthDayFormat(widget.data['reserDate']) + ' ' + widget.data['reserTime'],
                      style: TextStyle(fontSize: 14),
                      showCursor: true,
                    ),
                    alignment: Alignment.centerLeft),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Align(
                  child: Text('[예약인원]', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  alignment: Alignment.centerLeft,
                ),
                SizedBox(width: 5),
                Align(
                    child: SelectableText(
                      widget.data['personCnt'].toString() + ' 인',
                      style: TextStyle(fontSize: 14),
                      showCursor: true,
                    ),
                    alignment: Alignment.centerLeft),
                SizedBox(width: 20),
                Align(
                  child: Text('[결제 구분]', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  alignment: Alignment.centerLeft,
                ),
                SizedBox(width: 5),
                Align(
                    child: SelectableText(
                      _setPayGbn(widget.data['payGbn'].toString()),
                      style: TextStyle(fontSize: 14),
                      showCursor: true,
                    ),
                    alignment: Alignment.centerLeft),
              ],
            ),
            SizedBox(height : 5),
            Align(
              child: Text('[메모]', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              alignment: Alignment.centerLeft,
            ),
            Align(
                child: SelectableText(
                 widget.data['memo'].toString(),
                  style: TextStyle(fontSize: 14),
                  showCursor: true,
                ),
                alignment: Alignment.centerLeft),
            SizedBox(height : 5),
            Align(
              child: Text('[요청사항]', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              alignment: Alignment.centerLeft,
            ),
            Align(
                child: SelectableText(
                  widget.data['location'].toString(),
                  style: TextStyle(fontSize: 14),
                  showCursor: true,
                ),
                alignment: Alignment.centerLeft),
            Divider(thickness: 2),
            Row(
              children: [
                Align(
                  child: Text('[신청 일시]', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  alignment: Alignment.centerLeft,
                ),
                SizedBox(width: 5),
                Align(
                    child: SelectableText(
                      widget.data['isrtDate'].replaceAll('\n', ''),
                      style: TextStyle(fontSize: 14),
                      showCursor: true,
                    ),
                    alignment: Alignment.centerLeft),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Align(
                  child: Text('[예약확정 시간]', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  alignment: Alignment.centerLeft,
                ),
                SizedBox(width: 5),
                Align(
                    child: SelectableText(
                      Utils.getYearMonthDayFormat(widget.data['allocDate'].replaceAll('\n', '')),
                      style: TextStyle(fontSize: 14),
                      showCursor: true,
                    ),
                    alignment: Alignment.centerLeft),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Align(
                  child: Text('[방문완료 시간]', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  alignment: Alignment.centerLeft,
                ),
                SizedBox(width: 5),
                Align(
                    child: SelectableText(
                      Utils.getYearMonthDayFormat(widget.data['compDate'].replaceAll('\n', '')),
                      style: TextStyle(fontSize: 14),
                      showCursor: true,
                    ),
                    alignment: Alignment.centerLeft),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Align(
                  child: Text('[취소 시간]', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  alignment: Alignment.centerLeft,
                ),
                SizedBox(width: 5),
                Align(
                    child: SelectableText(
                      Utils.getYearMonthDayFormat(widget.data['cancelDate'].replaceAll('\n', '')),
                      style: TextStyle(fontSize: 14),
                      showCursor: true,
                    ),
                    alignment: Alignment.centerLeft),
              ],
            ),
            Divider(thickness: 2)
          ],
        ));

    var result = Scaffold(
        appBar: AppBar(
          title: Text('예약 상세 조회 [' + _setStatus(widget.data['status'].toString()) + ']'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [SizedBox(height: 20), data],
          ),
        ));
    return SizedBox(
      width: 440,
      height: 500,
      child: result,
    );
  }

  String _setPayGbn(String value) {
    String retValue = '--';

    if (value.toString().compareTo('1') == 0)
      retValue = '현금';
    else if (value.toString().compareTo('2') == 0)
      retValue = '카드';
    else if (value.toString().compareTo('3') == 0)
      retValue = '외상';
    else if (value.toString().compareTo('4') == 0)
      retValue = '쿠폰(가맹점 자체)';
    else if (value.toString().compareTo('5') == 0)
      retValue = '마일리지';
    else if (value.toString().compareTo('7') == 0)
      retValue = '행복페이';
    else if (value.toString().compareTo('8') == 0)
      retValue = '제로페이';
    else if (value.toString().compareTo('9') == 0)
      retValue = '선결제';
    else if (value.toString().compareTo('P') == 0)
      retValue = '휴대폰';
    else if (value.toString().compareTo('B') == 0)
      retValue = '계좌이체';
    else
      retValue = '--';

    return retValue;
  }

  String _setStatus(String value) {
    String retValue = '--';

    if (value.toString().compareTo('10') == 0)
      retValue = '확정대기';
    else if (value.toString().compareTo('12') == 0)
      retValue = '예약확정';
    else if (value.toString().compareTo('30') == 0)
      retValue = '방문완료';
    else if (value.toString().compareTo('40') == 0)
      retValue = '취소';
    else if (value.toString().compareTo('90') == 0)
      retValue = '미방문';
    else
      retValue = '--';

    return retValue;
  }
}
