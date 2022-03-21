
import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:daeguro_admin_app/ISWidget/is_input.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/Model/PayCancelModel.dart';
import 'package:daeguro_admin_app/Model/order/order.dart';
import 'package:daeguro_admin_app/Model/order/orderStatusEditModel.dart';
import 'package:daeguro_admin_app/View/OrderManager/orderManager_controller.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OrderStatusEdit extends StatefulWidget {
  final OrderAccount sData;

  const OrderStatusEdit({Key key, this.sData}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OrderStatusEditState();
  }
}

class OrderStatusEditState extends State<OrderStatusEdit> {
  static OrderStatusEditState get to => Get.find();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  OrderAccount formData;
  OrderStatusEditModel saveData;
  PayCancelModel payCancelData;

  List<SelectOptionVO> selectBox_status = [
    new SelectOptionVO(value: '10', label: '접수'),
    new SelectOptionVO(value: '20', label: '대기'),
    new SelectOptionVO(value: '30', label: '가맹점 접수확인'),
    new SelectOptionVO(value: '35', label: '운행'),
    new SelectOptionVO(value: '40', label: '완료'),
    new SelectOptionVO(value: '50', label: '취소'),
    new SelectOptionVO(value: '80', label: '결제대기'),
  ];

  List<SelectOptionVO> selectBox_cancelcode = [
    new SelectOptionVO(value: '00', label: '사유없음'),
    new SelectOptionVO(value: '10', label: '회원본인취소'),
    new SelectOptionVO(value: '11', label: '시간지연'),
    new SelectOptionVO(value: '12', label: '재접수'),
    new SelectOptionVO(value: '20', label: '가맹점취소'),
    new SelectOptionVO(value: '23', label: '가맹점휴무'),
    new SelectOptionVO(value: '21', label: '배달불가'),
    new SelectOptionVO(value: '22', label: '메뉴품절'),
  ];

  // "orderNo": "3",
  // "status": "50",
  // "riderInfo": "string",
  // "modCode": "3",
  // "modName": "이인찬",
  // "cancelCode": "11",
  // "cancelReason": "string"

  @override
  void initState() {
    super.initState();

    Get.put(OrderController());

    if (widget.sData != null) {
      formData = widget.sData;
    } else {
      formData = OrderAccount();
    }

    //print('formData.status: '+formData.status);

    payCancelData = PayCancelModel();
    saveData = OrderStatusEditModel();
    saveData.orderNo = formData.ORDER_NO.toString();
    saveData.status = formData.STATUS;
    saveData.cancelCode = '00';
    saveData.modCode = GetStorage().read('logininfo')['uCode'];//formData.modeUcode;
    saveData.modName = GetStorage().read('logininfo')['name'];//formData.modeName;
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
          ISInput(
            width: 200,
            value: formData.ORDER_NO.toString(),
            label: '주문번호',
            readOnly: true,
            onSaved: (v) {
              formData.ORDER_NO = int.parse(v);
            },
          ),
          SizedBox(width: 200,),
          // ISInput(
          //   width: 200,
          //   value: saveData.modCode,
          //   label: '수정자ID',
          //   onSaved: (v) {
          //     saveData.modCode = v;
          //   },
          // ),
          // ISInput(
          //   width: 200,
          //   value: saveData.modName,
          //   label: '수정자명',
          //   onSaved: (v) {
          //     saveData.modName = v;
          //   },
          // ),
          ISSelect(
            label: '진행상태',
            width: 200,
            value: formData.STATUS,
            dataList: selectBox_status,
            onChange: (v) {
              setState(() {
                saveData.status = v;

                formKey.currentState.save();
              });
            },
          ),
          ISSelect(
            label: '취소코드',
            width: 200,
            value: OrderController.to.qDataDetail['cancelCode'],
            dataList: selectBox_cancelcode,
            onChange: (v) {
              setState(() {
                OrderController.to.qDataDetail['cancelCode'] = v;
                formKey.currentState.save();
              });
            },
          ),
          ISInput(
            value: OrderController.to.qDataDetail['cancelReason'],
            label: '취소사유',
            maxLines: 1,
            onSaved: (v) {
              OrderController.to.qDataDetail['cancelReason'] = v;
              //formData.telNo = v;
            },
          ),
        ],
      ),
    );

    ButtonBar buttonBar = ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        ISButton(
          label: '저장',
          iconData: Icons.save,
          onPressed: () async {
            FormState form = formKey.currentState;
            if (!form.validate()) {
              return;
            }

            form.save();
            saveData.cancelCode = OrderController.to.qDataDetail['cancelCode'];
            saveData.cancelReason = OrderController.to.qDataDetail['cancelReason'];

            payCancelData.order_no = formData.ORDER_NO.toString();
            payCancelData.trade_kcp_no = formData.TUID;
            payCancelData.cancel_reason = saveData.cancelCode;

            var headerData = {
              "Access-Control-Allow-Origin": "*", // Required for CORS support to work
              "Access-Control-Allow-Headers": "X-API-KEY, Origin, X-Requested-With, Content-Type, Accept, Access-Control-Request-Method,Access-Control-Request-Headers, Authorization",
              "Access-Control-Allow-Credentials": "true",
              "Access-Control-Allow-Methods": "HEAD, GET, POST, PUT, PATCH, DELETE, OPTIONS",
              "Authorization":"QzI1QTgyNEVFQkVEQ0U5RkM2NTUzODFCNTc3MUJENTc=",
              "Method":"DELETE",
              "Content-Type":"application/json",
            };

            var bodyData = {
              '"order_no"': '"' + payCancelData.order_no +  '"',
              '"trade_kcp_no"': '"' + payCancelData.trade_kcp_no + '"',
              '"cancel_reason"': '"' + payCancelData.cancel_reason + '"',
            };

            // 카드결재, 취소 인경우 카드결재 취소 같이
            if(formData.PAY_GBN == '2' && saveData.status == '50')
            {
              // await http.post(Uri.parse(ServerInfo.PAY_BASIC_CANCEL), headers: headerData, body: bodyData.toString()).then((http.Response response){
              //   print(response.statusCode);
              // });

              //await OrderController.to.postPayBasicCancel(headerData, payCancelData.toJson(), saveData.toJson(), context);
            }
            else
            {
              OrderController.to.putData(saveData.toJson(), context);
              Navigator.pop(context, true);
            }
          },
        ),
        ISButton(
          label: '취소',
          iconData: Icons.cancel,
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
    var result = Scaffold(
      appBar: AppBar(
        title: Text('주문 상태변경'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            form,
          ],
        ),
      ),
      bottomNavigationBar: buttonBar,
    );
    return SizedBox(
      width: 400,
      height: 400,
      child: result,
    );
  }
}
