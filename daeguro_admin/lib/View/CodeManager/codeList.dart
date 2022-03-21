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
import 'package:daeguro_admin_app/View/CodeManager/codeEdit.dart';
import 'package:daeguro_admin_app/View/CodeManager/codeRegist.dart';
import 'package:daeguro_admin_app/View/CodeManager/code_controller.dart';
import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CodeListManager extends StatefulWidget {
  @override
  CodeListManagerState createState() => CodeListManagerState();
}

class CodeListManagerState extends State<CodeListManager> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final ScrollController _scrollController = ScrollController();

  SearchItems _searchItems = new SearchItems();

  final List<codeListModel> dataList = <codeListModel>[];

  List<SelectOptionVO> selectBox_codeGroup = [
    SelectOptionVO(value: ' ', label: '전체'),
  ];

  List<SelectOptionVO> selectBox_useGbn = [
    SelectOptionVO(value: ' ', label: '전체'),
    SelectOptionVO(value: 'Y', label: '사용'),
    SelectOptionVO(value: 'N', label: '미사용'),
  ];


  String _codeGrp = ' ';
  String _useGbn = ' ';

  bool isCheckAll = false;

  _reset() {
    _searchItems = null;
    _searchItems = new SearchItems();

    //_searchItems.startdate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    //_searchItems.enddate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    _searchItems.memo = '';
  }

  // _query() {
  //   formKey.currentState.save();
  //
  //   //CodeController.to.startDate.value = _searchItems.startdate.replaceAll('-', '');
  //   //CodeController.to.endDate.value = _searchItems.enddate.replaceAll('-', '');
  //
  //   //CodeController.to.page.value = _currentPage;
  //   //CodeController.to.rows.value = _selectedpagerows;
  //   loadData();
  // }

  // _detail({String seq}) async {
  //   await LogController.to.getDetailData(seq);
  //
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) => Dialog(
  //         child: LogDetail(seq: seq),
  //       )
  //   );
  // }

  loadData() async {
    await ISProgressDialog(context).show(status: 'Loading...');

    dataList.clear();

    await CodeController.to.getListData(_codeGrp, _useGbn).then((value) {
      if (value == null) {
        //ISAlert(context, '사용자ID 또는 비밀번호를 확인하십시오.');
      }
      else {
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

          temp.selected = false;

          dataList.add(temp);
        });
      }
    });

    dataList.forEach((element) {
      if (_getCompareData(element.CODE_GRP) == false){
        selectBox_codeGroup.add(SelectOptionVO(value: element.CODE_GRP, label:element.CODE_GRP.toString()));
      }
    });
    _scrollController.jumpTo(0.0);

    if (this.mounted) {
      setState(() {
      });
    }

    await ISProgressDialog(context).dismiss();
  }

  bool _getCompareData(String codeGrp){
    bool temp = false;

    if (selectBox_codeGroup == null)
      return false;

    for (final element in selectBox_codeGroup){
      if (element.value == codeGrp) {
        temp = true;
        break;
      }
    }
    return temp;
  }

  @override
  void initState() {
    super.initState();

    Get.put(CodeController());

    WidgetsBinding.instance.addPostFrameCallback((c) {
      _reset();
      loadData();
    });

    // setState(() {
    //   _searchItems.startdate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', '01']);
    //   _searchItems.enddate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    // });
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
        children: <Widget>[
        ],
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
                label: '코드그룹',
                width: 180,
                value: _codeGrp,
                paddingEnabled: false,
                onChange: (value) {
                  setState(() {
                    _codeGrp = value;
                    loadData();
                  });
                },
                dataList: selectBox_codeGroup,
              ),
              SizedBox(width: 8,),
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
              if (AuthUtil.isAuthCreateEnabled('42') == true)
              ISSearchButton(
                  label: '추가',
                  iconData: Icons.add,
                  onPressed: () => {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                        child: CodeRegist(),
                      ),
                    ).then((value) async {
                      if (value != null) {
                        await Future.delayed(Duration(milliseconds: 500), () {
                          _codeGrp = ' ';
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
      //padding: EdgeInsets.only(left: 50, right: 50, bottom: 0),
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
                  //selected: item.selected ?? false,
                  color: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
                    if (item.USE_GBN == 'N') {
                      return Colors.grey[300];//Colors.grey.shade200;
                      //return Theme.of(context).colorScheme.primary.withOpacity(0.38);
                    }

                    return Theme.of(context).colorScheme.primary.withOpacity(0.00);
                  }),
                  // onSelectChanged: (bool value){
                  //   // _selectedViewSeq = item.shopCd;
                  //   // nSelectedShopTitle = '[${item.shopCd}] ${item.shopName}';
                  //   // setDetailViewData(item.shopCd, _mCode, item.ccCode, item.apiComCode, item.imageStatus, item.calcYn, item.shopInfoYn, item.deliYn, item.tipYn, item.saleYn);
                  //
                  //   dataList.forEach((element) {
                  //     element.selected = false;
                  //   });
                  //
                  //   item.selected = true;
                  //
                  //   _scrollController.jumpTo(0.0);
                  //
                  //   setState(() {
                  //   });
                  // },
                  cells: [
                // DataCell(
                //     Center(
                //       child: Checkbox(
                //           value: item.selected,
                //           onChanged: (value) {
                //             isCheckAll = false;
                //
                //             item.selected == false ? item.selected = true : item.selected = false;
                //
                //             setState(() {});
                //           }
                //       ),
                //     )
                // ),
                DataCell(Center(child: SelectableText(item.CODE_GRP.toString() ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true))),
                DataCell(Center(child: SelectableText(item.CODE ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true))),
                DataCell(Align(child: SelectableText(item.CODE_NM ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true), alignment: Alignment.centerLeft)),
                DataCell(Align(child: SelectableText(item.MEMO ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true), alignment: Alignment.centerLeft)),
                //DataCell(Align(child: SelectableText(item.USE_GBN ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true), alignment: Alignment.center)),
                DataCell(Align(
                    child: Container(
                      padding: EdgeInsets.only(left: 10.0),
                      height: 20,
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(5.0)),
                      child: DropdownButton(
                        style: TextStyle(fontSize: 12, fontFamily: 'NotoSansKR', color: Colors.black),
                        onChanged: (value) async {
                          if (AuthUtil.isAuthEditEnabled('42') == false){
                            ISAlert(context, '변경 권한이 없습니다. \n\n관리자에게 문의 바랍니다');
                            return;
                          }
                          setState(() {
                            item.USE_GBN = value;
                          });

                          ISConfirm(context, '상태 변경', '상태변경 하시겠습니까?', (context) async {
                            Navigator.of(context).pop();

                            await CodeController.to.putListData(context, item.CODE_GRP, item.CODE, item.CODE_NM, item.MEMO, '', item.USE_GBN, item.ETC_CODE2,
                                item.ETC_AMT1.toString(), item.ETC_AMT2.toString(), item.ETC_AMT3.toString(), item.ETC_AMT4.toString(),
                                item.ETC_CODE_GBN1, item.ETC_CODE_GBN3, item.ETC_CODE_GBN4, item.ETC_CODE_GBN5, item.ETC_CODE_GBN6, item.ETC_CODE_GBN7, item.ETC_CODE_GBN8);

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
                    alignment: Alignment.center
                )
                ),
                DataCell(Align(child: SelectableText((item.ETC_AMT1 == null ? '' : (item.ETC_AMT1.toString().contains('.') == true ? item.ETC_AMT1.toString() : Utils.getCashComma(item.ETC_AMT1.toString()))), style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true), alignment: Alignment.centerRight)),
                DataCell(Align(child: SelectableText((item.ETC_AMT2 == null ? '' : item.ETC_AMT2.toString()), style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true), alignment: Alignment.centerRight)),
                DataCell(Align(child: SelectableText((item.ETC_AMT3 == null ? '' : item.ETC_AMT3.toString()), style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true), alignment: Alignment.centerRight)),
                // DataCell(Align(child: SelectableText(item.ETC_CODE_GBN4 ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true), alignment: Alignment.center)),
                // DataCell(Align(child: SelectableText(item.ETC_CODE_GBN5 ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true), alignment: Alignment.centerLeft)),
                // DataCell(Align(child: SelectableText(item.ETC_CODE_GBN6 ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true), alignment: Alignment.centerLeft)),

                DataCell(Align(child: SelectableText(item.INS_DATE ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true), alignment: Alignment.center)),
                DataCell(Align(child: SelectableText(item.INS_NAME ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true), alignment: Alignment.center)),
                DataCell(Align(child: SelectableText(item.MOD_DATE ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true), alignment: Alignment.center)),
                // //DataCell(Align(child: SelectableText(item.MOD_UCODE ?? '--', style: TextStyle(color: Colors.black), showCursor: true), alignment: Alignment.centerLeft)),
                DataCell(Align(child: SelectableText(item.MOD_NAME ?? '--', style: TextStyle(color: Colors.black, fontSize: 12), showCursor: true), alignment: Alignment.center)),
                DataCell(
                  Center(
                    child: InkWell(
                      child: Icon(Icons.edit, size: 20),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => Dialog(
                            child: CodeEdit(sData: item),
                          ),
                        ).then((v) async {
                          if (v != null) {
                            await Future.delayed(Duration(milliseconds: 500), (){
                              _codeGrp = ' ';
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
              // DataColumn(label: Expanded(
              //       child: Checkbox(
              //         value: isCheckAll,//this.checkAll,
              //         onChanged: (v) {
              //           isCheckAll = v;
              //           //isCheckAll == false ? _testOrderCnt = 0 : _testOrderCnt = dataList.length;
              //
              //           dataList.forEach((element) {
              //             element.selected = v;
              //           });
              //
              //           setState(() {});
              //         }
              //       ),
              //     ),
              // ),
              DataColumn(label: Expanded(child: Text('코드그룹', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('코드', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('코드명', textAlign: TextAlign.left)),),
              DataColumn(label: Expanded(child: Text('코드메모', textAlign: TextAlign.left)),),
              DataColumn(label: Expanded(child: Text('사용구분', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('설정금액1', textAlign: TextAlign.right)),),
              DataColumn(label: Expanded(child: Text('설정금액2', textAlign: TextAlign.right)),),
              DataColumn(label: Expanded(child: Text('설정금액3', textAlign: TextAlign.right)),),
              // DataColumn(label: Expanded(child: Text('설정값1', textAlign: TextAlign.center)),),
              // DataColumn(label: Expanded(child: Text('설정값2', textAlign: TextAlign.center)),),
              // DataColumn(label: Expanded(child: Text('설정값3', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('등록일', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('등록자명', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('수정일', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('수정자명', textAlign: TextAlign.center)),),
              DataColumn(label: Expanded(child: Text('상세', textAlign: TextAlign.center)),),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
