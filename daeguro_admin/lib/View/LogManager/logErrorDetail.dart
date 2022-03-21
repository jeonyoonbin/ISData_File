import 'package:daeguro_admin_app/View/LogManager/log_controller.dart';
import 'package:flutter/material.dart';

class LogErrorDetail extends StatefulWidget {
  final String seq;
  // final logDetailModel sData;
  const LogErrorDetail({Key key, this.seq}) : super(key: key);

  @override
  LogErrorDetailState createState() => LogErrorDetailState();
}

class LogErrorDetailState extends State<LogErrorDetail> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String in_date = LogController.to.qDataDetail[0]['INSERT_TIME'];

  @override
  void initState() {
    super.initState();

    // Get.put(LogController());
  }

  @override
  Widget build(BuildContext context) {
    var data = Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Align(child: Text('[번호]', style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold)), alignment: Alignment.centerLeft,),
                      Align(child: SelectableText('  ' + widget.seq, style: TextStyle(fontSize: 13), showCursor: true,), alignment: Alignment.centerLeft,),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Align(child: Text('[구분]', style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold)), alignment: Alignment.centerLeft,),
                      Align(child: SelectableText('  ' + LogController.to.qDataDetail[0]['DIV'], style: TextStyle(fontSize: 13), showCursor: true,), alignment: Alignment.centerLeft,),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Align(child: Text('[포지션]', style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold)), alignment: Alignment.centerLeft,),
                      Align(child: SelectableText('  ' + LogController.to.qDataDetail[0]['POSITION'], style: TextStyle(fontSize: 13), showCursor: true,), alignment: Alignment.centerLeft,),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Align(child: Text('[발생일]', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), alignment: Alignment.centerLeft,),
                      Align(child: Text('  ' + in_date.replaceAll('T', ' '), style: TextStyle(fontSize: 13)), alignment: Alignment.centerLeft,),
                    ],
                  ),
                  SizedBox(height: 10),
                  Align(child: Text('[로그메시지]', style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold)), alignment: Alignment.centerLeft,),
                  Align(child: SelectableText('  ' + LogController.to.qDataDetail[0]['MSG'], style: TextStyle(fontSize: 13), showCursor: true,), alignment: Alignment.centerLeft,),
                  SizedBox(height: 20),
                ],
              )
        );

    var result = Scaffold(
      appBar: AppBar(
        title: Text('로그 상세 조회'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            data
          ],
        ),
      )
    );
    return SizedBox(
      width: 440,
      height: 500,
      child: result,
    );
  }
}
