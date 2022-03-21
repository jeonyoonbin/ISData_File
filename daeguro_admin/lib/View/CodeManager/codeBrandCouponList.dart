import 'package:daeguro_admin_app/ISWidget/is_datatable.dart';
import 'package:daeguro_admin_app/ISWidget/is_dialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_progressDialog.dart';
import 'package:daeguro_admin_app/ISWidget/is_select.dart';
import 'package:daeguro_admin_app/ISWidget/search/is_search_button.dart';
import 'package:daeguro_admin_app/Model/codeListModel.dart';
import 'package:daeguro_admin_app/Model/search_items.dart';
import 'package:daeguro_admin_app/Util/auth_util.dart';
import 'package:daeguro_admin_app/Util/select_option_vo.dart';
import 'package:daeguro_admin_app/Util/utils.dart';
import 'package:daeguro_admin_app/View/CodeManager/codeBrandCouponEdit.dart';
import 'package:daeguro_admin_app/View/CodeManager/codeBrandCouponRegist.dart';
import 'package:daeguro_admin_app/View/CodeManager/code_controller.dart';
import 'package:daeguro_admin_app/View/CouponManager/coupon_controller.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CodeBrandCouponListManager extends StatefulWidget {
  @override
  CodeBrandCouponListManagerState createState() => CodeBrandCouponListManagerState();
}

class CodeBrandCouponListManagerState extends State<CodeBrandCouponListManager> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final ScrollController _scrollController = ScrollController();

  SearchItems _searchItems = new SearchItems();

  final List<codeListModel> dataList = <codeListModel>[];

  List<SelectOptionVO> selectBox_useGbn = [
    SelectOptionVO(value: ' ', label: '전체'),
    SelectOptionVO(value: 'Y', label: '사용'),
    SelectOptionVO(value: 'N', label: '미사용'),
  ];

  String _useGbn = ' ';

  bool isCheckAll = false;

  List codeItems = List();

  _reset() {
    _searchItems = null;
    _searchItems = new SearchItems();
    _searchItems.memo = '';
  }

  loadChainListData() async {
    codeItems.clear();

    await CouponController.to.getBrandListItems().then((value) {
      codeItems = value;
    });

    setState(() {});
  }

  loadData() async {
    await ISProgressDialog(context).show(status: 'Loading...');

    dataList.clear();

    await CodeController.to.getListData('BRAND_COUPON', _useGbn).then((value) {
      if (value == null) {
        //ISAlert(context, '사용자ID 또는 비밀번호를 확인하십시오.');
      } else {
        value.forEach((e) {
          codeListModel temp = codeListModel.fromJson(e);
          if (temp.INS_DATE != null) {
            List<String> tempInsDate = temp.INS_DATE.split('T');
            temp.INS_DATE = tempInsDate[0];
          }

          if (temp.MOD_DATE != null) {
            List<String> tempModDate = temp.MOD_DATE.split('T');
            temp.MOD_DATE = tempModDate[0];
          }

          if (temp.ETC_CODE_GBN4 == 'null' || temp.ETC_CODE_GBN4 == '') temp.ETC_CODE_GBN4 = null;

          if (temp.ETC_CODE_GBN7 == 'null' || temp.ETC_CODE_GBN7 == '') temp.ETC_CODE_GBN7 = null;

          temp.selected = false;

          //print('ETC_CODE1:${temp.ETC_CODE1}');

          dataList.add(temp);
        });
      }
    });

    _scrollController.jumpTo(0.0);

    //if (this.mounted) {
    setState(() {});
    //}

    await ISProgressDialog(context).dismiss();
  }

  @override
  void initState() {
    super.initState();

    Get.put(CouponController());
    Get.put(CodeController());

    WidgetsBinding.instance.addPostFrameCallback((c) {
      _reset();
      loadChainListData();
      loadData();
    });
  }

  @override
  void dispose() {
    dataList.clear();

    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[],
      ),
    );

    var buttonBar = Expanded(
      flex: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            children: [
              Text('총: ${Utils.getCashComma(dataList.length.toString())}건', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
            ],
          ),
          Row(
            children: [
              ISSelect(
                label: '사용구분',
                width: 100,
                value: _useGbn,
                paddingEnabled: false,
                onChange: (value) {
                  setState(() {
                    _useGbn = value;
                    loadData();
                  });
                },
                dataList: selectBox_useGbn,
              ),
              SizedBox(width: 8,),
              if (AuthUtil.isAuthCreateEnabled('45') == true)
              ISSearchButton(
                  label: '추가',
                  iconData: Icons.add,
                  onPressed: () => {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                        child: CodeBrandCouponRegist(),
                      ),
                    ).then((value) async {
                      if (value != null) {
                        await Future.delayed(Duration(milliseconds: 500), () {
                          loadData();
                        });
                      }
                    }),
                  }
              ),
              SizedBox(width: 8,),
              ISSearchButton(
                  label: '조회',
                  iconData: Icons.search,
                  onPressed: () => {
                    loadData(),
                  }),
            ],
          )
        ],
      ),
    );

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //SizedBox(height: 10),
          form,
          buttonBar,
          Divider(),
          ISDatatable(
            controller: _scrollController,
            panelHeight: (MediaQuery.of(context).size.height-defaultContentsHeight),
            dataRowHeight: 30,
            listWidth: Responsive.getResponsiveWidth(context, 720),
            rows: dataList.map((item) {
              return DataRow(
                  cells: [
                    DataCell(Center(child: SelectableText(item.CODE_GRP.toString() ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true))),
                    DataCell(Center(child: SelectableText(item.CODE ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true))),
                    DataCell(Align(child: SelectableText(item.CODE_NM ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true), alignment: Alignment.centerLeft)),
                    DataCell(Align(child: SelectableText(item.MEMO ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true), alignment: Alignment.centerLeft)),
                    DataCell(Align(
                        child: Container(
                          padding: EdgeInsets.only(left: 10.0),
                          height: 20,
                          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(5.0)),
                          child: DropdownButton(
                            style: TextStyle(fontSize: 12, fontFamily: 'NotoSansKR', color: Colors.black),
                            onChanged: (value) async {
                              if (AuthUtil.isAuthEditEnabled('45') == false){
                                ISAlert(context, '변경 권한이 없습니다. \n\n관리자에게 문의 바랍니다');
                                return;
                              }

                              setState(() {
                                item.USE_GBN = value;
                              });

                              ISConfirm(context, '쿠폰코드 사용구분 변경', '사용구분을 변경 하시겠습니까?', (context) async {
                                Navigator.of(context).pop();

                                await CodeController.to.putListData(
                                    context,
                                    item.CODE_GRP,
                                    item.CODE,
                                    item.CODE_NM,
                                    item.MEMO,
                                    item.ETC_CODE1,
                                    item.USE_GBN,
                                    item.ETC_CODE2,
                                    item.ETC_AMT1.toString(),
                                    item.ETC_AMT2.toString(),
                                    item.ETC_AMT3.toString(),
                                    item.ETC_AMT4.toString(),
                                    item.ETC_CODE_GBN1,
                                    item.ETC_CODE_GBN3,
                                    item.ETC_CODE_GBN4,
                                    item.ETC_CODE_GBN5,
                                    item.ETC_CODE_GBN6,
                                    item.ETC_CODE_GBN7,
                                    item.ETC_CODE_GBN8);

                                await Future.delayed(Duration(milliseconds: 1000), () {
                                  loadData();
                                });
                              });
                            },
                            value: item.USE_GBN,
                            items: [
                              DropdownMenuItem(value: 'Y', child: Text('사용'),),
                              DropdownMenuItem(value: 'N', child: Text('미사용'),),
                            ].cast<DropdownMenuItem<String>>(),
                          ),
                        ),
                        alignment: Alignment.center)
                    ),
                    DataCell(Align(
                        child: SelectableText((item.ETC_CODE1 == null ? '' : getCodeName(item.ETC_CODE1)),
                            style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true),
                        alignment: Alignment.centerRight)),
                    DataCell(Align(
                        child: SelectableText((item.ETC_AMT1 == null ? '' : Utils.getCashComma(item.ETC_AMT1.toString())),
                            style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true),
                        alignment: Alignment.centerRight)),
                    DataCell(Align(
                        child: Container(
                          padding: EdgeInsets.only(left: 10.0),
                          height: 20,
                          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(5.0)),
                          child: DropdownButton(
                            style: TextStyle(fontSize: 12, fontFamily: 'NotoSansKR', color: Colors.black),
                            onChanged: (value) async {
                              if (AuthUtil.isAuthEditEnabled('45') == false){
                                ISAlert(context, '변경 권한이 없습니다. \n\n관리자에게 문의 바랍니다');
                                return;
                              }

                              setState(() {
                                item.ETC_CODE_GBN4 = value;
                              });

                              ISConfirm(context, '쿠폰코드 발급기준 변경', '발급기준을 변경 하시겠습니까?', (context) async {
                                Navigator.of(context).pop();

                                await CodeController.to.putListData(
                                    context,
                                    item.CODE_GRP,
                                    item.CODE,
                                    item.CODE_NM,
                                    item.MEMO,
                                    item.ETC_CODE1,
                                    item.USE_GBN,
                                    item.ETC_CODE2,
                                    item.ETC_AMT1.toString(),
                                    item.ETC_AMT2.toString(),
                                    item.ETC_AMT3.toString(),
                                    item.ETC_AMT4.toString(),
                                    item.ETC_CODE_GBN1,
                                    item.ETC_CODE_GBN3,
                                    item.ETC_CODE_GBN4,
                                    item.ETC_CODE_GBN5,
                                    item.ETC_CODE_GBN6,
                                    item.ETC_CODE_GBN7,
                                    item.ETC_CODE_GBN8);

                                await Future.delayed(Duration(milliseconds: 1000), () {
                                  loadData();
                                });
                              });
                            },
                            value: item.ETC_CODE_GBN4,
                            items: [
                              DropdownMenuItem(value: '1', child: Text('실시간'),),
                              DropdownMenuItem(value: '3', child: Text('일마감'),),
                            ].cast<DropdownMenuItem<String>>(),
                          ),
                        ),
                        alignment: Alignment.center)),
                    DataCell(Align(
                        child: Container(
                          padding: EdgeInsets.only(left: 10.0),
                          height: 20,
                          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(5.0)),
                          child: DropdownButton(
                            style: TextStyle(fontSize: 12, fontFamily: 'NotoSansKR', color: Colors.black),
                            onChanged: (value) async {
                              if (AuthUtil.isAuthEditEnabled('45') == false){
                                ISAlert(context, '변경 권한이 없습니다. \n\n관리자에게 문의 바랍니다');
                                return;
                              }

                              setState(() {
                                item.ETC_CODE_GBN7 = value;
                              });

                              ISConfirm(context, '쿠폰코드 중복사용 여부', '중복사용 여부를 변경 하시겠습니까?', (context) async {
                                Navigator.of(context).pop();

                                await CodeController.to.putListData(
                                    context,
                                    item.CODE_GRP,
                                    item.CODE,
                                    item.CODE_NM,
                                    item.MEMO,
                                    item.ETC_CODE1,
                                    item.USE_GBN,
                                    item.ETC_CODE2,
                                    item.ETC_AMT1.toString(),
                                    item.ETC_AMT2.toString(),
                                    item.ETC_AMT3.toString(),
                                    item.ETC_AMT4.toString(),
                                    item.ETC_CODE_GBN1,
                                    item.ETC_CODE_GBN3,
                                    item.ETC_CODE_GBN4,
                                    item.ETC_CODE_GBN5,
                                    item.ETC_CODE_GBN6,
                                    item.ETC_CODE_GBN7,
                                    item.ETC_CODE_GBN8);

                                await Future.delayed(Duration(milliseconds: 1000), () {
                                  loadData();
                                });
                              });
                            },
                            value: item.ETC_CODE_GBN7,
                            items: [
                              DropdownMenuItem(value: 'Y', child: Text('예'),),
                              DropdownMenuItem(value: 'N', child: Text('아니오'),),
                              DropdownMenuItem(value: 'T', child: Text('당일중복불가'),),
                            ].cast<DropdownMenuItem<String>>(),
                          ),
                        ),
                        alignment: Alignment.center
                    )
                    ),
                    DataCell(Align(child: SelectableText(item.INS_DATE ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true), alignment: Alignment.center)),
                    DataCell(Align(child: SelectableText(item.INS_NAME ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true), alignment: Alignment.center)),
                    DataCell(Align(child: SelectableText(item.MOD_DATE ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true), alignment: Alignment.center)),
                    DataCell(Align(child: SelectableText(item.MOD_NAME ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true), alignment: Alignment.center)),
                    DataCell(Center(
                        child: (item.ETC_CODE_GBN8.toString() == ' ' || item.ETC_CODE_GBN8.toString() == '' || item.ETC_CODE_GBN8 == null)
                            ? IconButton(icon: Icon(Icons.description, color: Colors.grey.shade400, size: 16))
                            : Tooltip(
                          child: IconButton(
                            icon: Icon(Icons.description, color: Colors.blue, size: 16),
                          ),
                          message: item.ETC_CODE_GBN8.replaceAll('</br>', '\n'),
                          textStyle: TextStyle(fontSize: 12, color: Colors.white),
                          padding: EdgeInsets.all(5),
                        ))),
                    DataCell(
                      Center(
                        child: InkWell(
                          child: Icon(Icons.edit, size: 20),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => Dialog(
                                child: CodeBrandCouponEdit(sData: item),
                              ),
                            ).then((v) async {
                              if (v != null) {
                                await Future.delayed(Duration(milliseconds: 500), () {
                                  loadData();
                                });
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ]);
            }).toList(),
            columns: <DataColumn>[
              DataColumn(label: Expanded(child: Text('코드그룹', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('코드', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('코드명', textAlign: TextAlign.left)),),
              DataColumn(label: Expanded(child: Text('코드메모', textAlign: TextAlign.left)),),
              DataColumn(label: Expanded(child: Text('사용구분', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('사용브랜드', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('쿠폰금액', textAlign: TextAlign.right)),),
              DataColumn(label: Expanded(child: Text('발급기준', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('중복사용', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('등록일', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('등록자명', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('수정일', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('수정자명', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('유의사항', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('상세', textAlign: TextAlign.center)),),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }

  String getCodeName(String code){
    String temp = '';

    for (final element in codeItems){
      if (element['CODE'] == code) {
        temp = element['CODE_NM'];
        break;
      }
    }
    return temp;
  }
}