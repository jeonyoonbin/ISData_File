import 'package:daeguro_admin_app/constants/serverInfo.dart';
import 'package:get/get.dart';

class RestApiProvider extends GetConnect {
  static RestApiProvider get to => Get.find();
  static String default_ContentType = 'text/plain';
  dynamic data = [{}];


  // Map<String, String> headers = {
  //   "Accept": "*/*", // Required for CORS support to work
  //   "Accept-Language": "",
  //   "Content-Language": "",
  //   "DPR": "",
  //   "Downlink":"",
  //   "Save-Data":"",
  //   "Viewport-Width":"",
  //   "Width":"",
  //   "Content-Type":"text/plain",
  //   // "Access-Control-Allow-Origin": "*", // Required for CORS support to work
  //   // "Access-Control-Allow-Headers": "X-API-KEY, Origin, X-Requested-With, Content-Type, Accept, Access-Control-Request-Method,Access-Control-Request-Headers, Authorization",
  //   // "Access-Control-Allow-Credentials": "true",
  //   // "Access-Control-Allow-Methods": "HEAD, GET, POST, PUT, PATCH, DELETE, OPTIONS",
  //   // "Method":"GET",
  //   // "Content-Type":"text/plain",
  // };
  //var PosbodyData = {'"order_no"': '"' +  saveStatusData.orderNo + '"', '"order_status"': '"' + value + '"', '"shop_token"': '"'+ item.apiComCode + '"'};
  ///////////// 전체현황
  //Future<Response> getDashBoard() => get(ServerInfo.REST_URL_DASHBOARD, contentType: default_ContentType);

  //Future<Response> getDashBoardWeekCustomer() => get(ServerInfo.REST_URL_DASHBOARDWEEKCUSTOMER, contentType: default_ContentType);

  //Future<Response> getDashBoardWeekOrder() => get(ServerInfo.REST_URL_DASHBOARDWEEKORDER, contentType: default_ContentType);

  //Future<Response> getDashBoardTodayCount() => get(ServerInfo.REST_URL_DASHBOARDTODAYCOUNT, contentType: default_ContentType);

  //Future<Response> getDaeguroTotalInfoSum() => get(ServerInfo.REST_URL_DASHBOARDTOTALINFOSUM, contentType: default_ContentType);

  ///////////// 콜센터
  //Future<Response> getAgent(String mCode) => get(ServerInfo.REST_URL_AGENT + '?mCode=$mCode', contentType: default_ContentType);

  //Future<Response> getAgentDetail(String ccCode, String ucode) => get(ServerInfo.REST_URL_AGENT + '/$ccCode?ucode=$ucode', contentType: default_ContentType);

  Future<Response> postAgent(Map data) => post(ServerInfo.REST_URL_AGENT, data);

  //Future<Response> getAgentCode(String mCode) => get(ServerInfo.REST_URL_AGENT_CODE + '?mCode=$mCode', contentType: default_ContentType);

  //Future<Response> getMembershipCode() => get(ServerInfo.REST_URL_MEMBERSHIP_CODE, contentType: default_ContentType);

  ///////////// 가맹점
  //Future<Response> getShop(String mCode, String searchinfo, String operator_code, String image_status, String reg_no_yn, String use_yn, String app_order_yn, String memo_yn, String img_yn, String reg_date, String page, String rows) =>      get(ServerInfo.REST_URL_SHOP + '?mCode=$mCode&keyword=$searchinfo&operator_code=$operator_code&image_status=$image_status&reg_no_yn=$reg_no_yn&use_yn=$use_yn&app_order_yn=$app_order_yn&memo_yn=$memo_yn&img_yn=$img_yn&reg_date=$reg_date&page=$page&rows=$rows', contentType: default_ContentType);

  //Future<Response> getModificationRegNo(String startDate, String endDate, String page, String rows) =>      get(ServerInfo.REST_URL_SHOPMODIFICATIONREGNO + '?date_begin=$startDate&date_end=$endDate&page=$page&rows=$rows', contentType: default_ContentType);

  Future<Response> putImageStatus(String shop_cd, status) => put(ServerInfo.REST_URL_SHOP_IMAGESTATUS + '?shop_cd=$shop_cd&status=$status', data);

  Future<Response> postShopDeleteFile(String shopCode, String kind, String file_name) => post(ServerInfo.REST_URL_SHOPDELETEFILES + '?shop_cd=$shopCode&kind=$kind&file_name=$file_name', '');

  //Future<Response> getHistory(String shopCode, String page, String rows) => get(ServerInfo.REST_URL_SHOPHISTORY + '/$shopCode?page=$page&rows=$rows', contentType: default_ContentType);

  //Future<Response> getFranchiseList() => get(ServerInfo.REST_URL_SHOPFRANCHISELIST, contentType: default_ContentType);

  //Future<Response> getOptionHistory(String shopCode, String page, String rows) => get(ServerInfo.REST_URL_OPTIONHISTORY + '/$shopCode?page=$page&rows=$rows', contentType: default_ContentType);

  //Future<Response> getShopBasic(String shopCode, String ucode) => get(ServerInfo.REST_URL_SHOPBASIC + '/$shopCode?ucode=$ucode', contentType: default_ContentType);

  Future<Response> postShopBasic(Map data) => post(ServerInfo.REST_URL_SHOPBASIC, data);

  Future<Response> putShopBasic(Map data) => put(ServerInfo.REST_URL_SHOPBASIC, data);

  //Future<Response> getShopInfo(String shopCode) => get(ServerInfo.REST_URL_SHOPINFO + '/$shopCode', contentType: default_ContentType);

  Future<Response> putShopInfo(Map data) => put(ServerInfo.REST_URL_SHOPINFO, data);

  Future<Response> postShopPosUpdate(Map data) => post('https://pos.daeguro.co.kr:15412/posApi/POSData/DaeguroApp_Process', data);

  //Future<Response> postShopChangePass(Map data) => post('http://172.16.10.74:12500/Sync/MyPass', data);
  Future<Response> postShopChangePass(Map data) => post('https://ceo.daeguro.co.kr/Sync/MyPass', data);

  //post('http://172.16.10.74:12500/Sync/MyPass', data);

  Future<Response> getImageHistory(String shopCode, String page, String rows) => get(ServerInfo.REST_URL_SHOPIMAGEHISTORY + '/$shopCode?page=$page&rows=$rows', contentType: default_ContentType);

  //Future<Response> getShopCalc(String shopCode) => get(ServerInfo.REST_URL_SHOPCALC + '/$shopCode', contentType: default_ContentType);

  Future<Response> putShopCalc(Map data) => put(ServerInfo.REST_URL_SHOPCALC, data);

  Future<Response> postShopCalcConfirm(Map data) => post(ServerInfo.REST_URL_SHOPCALC_CONFIRM, data);

  Future<Response> postSetBankConfirm(String shopCode, String confirmYn) => post(ServerInfo.REST_URL_SHOPBANKCONFIRM + '/$shopCode?confirmYn=$confirmYn', '');

  Future<Response> postChargeJoin(String shopCode, String ucode) => post(ServerInfo.REST_URL_SHOPCHARGEJOIN + '/$shopCode?ucode=$ucode', '');

  //Future<Response> getShopSector(String shopCode) => get(ServerInfo.REST_URL_SHOPSECTOR + '/$shopCode', contentType: default_ContentType);

  Future<Response> postShopSector(String shopCode, String sidoName, String gunguName, String ucode, String uname, dynamic data) => post(ServerInfo.REST_URL_SHOPSECTOR + '?shopCd=$shopCode&sidoName=$sidoName&gunguName=$gunguName&ucode=$ucode&uname=$uname', data);

  Future<Response> deleteShopSector(String shopCode, String sidoName, String gunguName, String ucode, String uname) =>delete(ServerInfo.REST_URL_SHOPSECTOR + '?shopCd=$shopCode&sidoName=$sidoName&gunguName=$gunguName&ucode=$ucode&uname=$uname');

  //Future<Response> getShopMenuGroup(String shopCode) => get(ServerInfo.REST_URL_SHOPMENUGROUP + '?shopCd=$shopCode', contentType: default_ContentType);

  //Future<Response> getShopMenuGroupDetail(String menuGroupCd) => get(ServerInfo.REST_URL_SHOPMENUGROUP + '/$menuGroupCd', contentType: default_ContentType);

  Future<Response> postShopMenuGroupDetail(Map data) => post(ServerInfo.REST_URL_SHOPMENUGROUP, data);

  Future<Response> putShopMenuGroupDetail(Map data) => put(ServerInfo.REST_URL_SHOPMENUGROUP, data);

  Future<Response> postMenuSort(String div, dynamic data) => post(ServerInfo.REST_URL_SHOPUPDATESORT + '?div=$div', data);

  Future<Response> putShopMenuCopy(String menuCd, String uName, Map data) => put(ServerInfo.REST_URL_SHOPMENUCOPY + '?menu_cd=$menuCd&insert_name=$uName', '');

  //Future<Response> getShopMenuList(String menuGroupCd) => get(ServerInfo.REST_URL_SHOPMENULIST + '/$menuGroupCd', contentType: default_ContentType);

  //Future<Response> getShopMenuDetail(String menuCd) => get(ServerInfo.REST_URL_SHOPMENUDETAIL + '/$menuCd', contentType: default_ContentType);

  Future<Response> postShopMenuDetail(Map data) => post(ServerInfo.REST_URL_SHOPMENUDETAIL, data);

  Future<Response> putShopMenuDetail(Map data) => put(ServerInfo.REST_URL_SHOPMENUDETAIL, data);

  //Future<Response> getShopOptionGroup(String shopCode, String menuCode) => get(ServerInfo.REST_URL_SHOPOPTIONGROUP + '?shopCd=$shopCode&menuCd=$menuCode', contentType: default_ContentType);

  //Future<Response> getShopOptionGroupDetail(String optionGroupCd) => get(ServerInfo.REST_URL_SHOPOPTIONGROUP + '/$optionGroupCd', contentType: default_ContentType);

  Future<Response> postShopOptionGroupDetail(Map data) => post(ServerInfo.REST_URL_SHOPOPTIONGROUP, data);

  Future<Response> putShopOptionGroupDetail(Map data) => put(ServerInfo.REST_URL_SHOPOPTIONGROUP, data);

  Future<Response> deleteShopOptionGroupDetail(String optionGroupCd) => delete(ServerInfo.REST_URL_SHOPOPTIONGROUP + '/$optionGroupCd');

  Future<Response> postShopCopyOptionGroup(String shopCd, String optionGroupCd, String uName) => post(ServerInfo.REST_URL_SHOPCOPYOPTIONGROUP + '?shop_cd=$shopCd&option_group_cd=$optionGroupCd&insert_name=$uName', '');

  //Future<Response> getShopOptionList(String optionGroupCd) => get(ServerInfo.REST_URL_SHOPOPTIONLIST + '/$optionGroupCd', contentType: default_ContentType);

  //Future<Response> getShopOptionDetail(String optionCd) => get(ServerInfo.REST_URL_SHOPOPTIONDETAIL + '/$optionCd', contentType: default_ContentType);

  Future<Response> postShopOptionDetail(Map data) => post(ServerInfo.REST_URL_SHOPOPTIONDETAIL, data);

  Future<Response> putShopOptionDetail(Map data) => put(ServerInfo.REST_URL_SHOPOPTIONDETAIL, data);

  Future<Response> deleteShopOptionDetail(String optionCd) => delete(ServerInfo.REST_URL_SHOPOPTIONDETAIL + '/$optionCd');

  //Future<Response> getShopMenuOptionGroup(String menuCode) => get(ServerInfo.REST_URL_SHOPMENUOPTIONGROUP + '/$menuCode', contentType: default_ContentType);

  Future<Response> postShopMenuOptionGroup(String menuCode, dynamic data) => post(ServerInfo.REST_URL_SHOPMENUOPTIONGROUP + '?menuCd=$menuCode', data);

  Future<Response> deleteShopMenuOptionGroup(String menuOptionGroupCd) => delete(ServerInfo.REST_URL_SHOPMENUOPTIONGROUP + '/$menuOptionGroupCd');

  //Future<Response> getMenuNameList(String mCode, String keyword) => get(ServerInfo.REST_URL_SHOPMENUNAMELIST + '?shopCd=$mCode&keyword=$keyword', contentType: default_ContentType);

  //Future<Response> getShopNameList(String shopCode, String keyword) => get(ServerInfo.REST_URL_SHOPSHOPNAMELIST + '?mcode=$shopCode&keyword=$keyword', contentType: default_ContentType);

  Future<Response> deleteRemoveMenuOption(String shopCode) => delete(ServerInfo.REST_URL_SHOPREMOVEMENUOPTION + '?shop_cd=$shopCode');

  Future<Response> postCopyMenuOption(String srcCcode, String srcShopCd, String destCcode, String destShopCd, String uName) => post(ServerInfo.REST_URL_SHOPCOPYMENUOPTION + '?source_cccode=$srcCcode&source_shop_cd=$srcShopCd&dest_cccode=$destCcode&dest_shop_cd=$destShopCd&insert_name=$uName', '');

  Future<Response> putMenuComplete(String shopCd, String menuComplete, Map data) => put(ServerInfo.REST_URL_SHOPMENUCOMPLETE + '?shopCd=$shopCd&menuCompleteYn=$menuComplete', '');

  //Future<Response> getBankCode() => get(ServerInfo.REST_URL_BANK_CODE, contentType: default_ContentType);

  //Future<Response> getDivCode() => get(ServerInfo.REST_URL_DIV_CODE, contentType: default_ContentType);

  //Future<Response> getSidoCode() => get(ServerInfo.REST_URL_SIDO_CODE, contentType: default_ContentType);

  //Future<Response> getGunguCode(String sido) => get(ServerInfo.REST_URL_GUNGU_CODE + '/$sido', contentType: default_ContentType);

  //Future<Response> getDongCode(String sido, String gungu) => get(ServerInfo.REST_URL_DONG_CODE + '/$sido/$gungu', contentType: default_ContentType);

  //Future<Response> getRiCode(String sido, String gungu, String dong) => get(ServerInfo.REST_URL_RI_CODE + '/$sido/$gungu/$dong', contentType: default_ContentType);

  //Future<Response> getSaleTime(String shopCode) => get(ServerInfo.REST_URL_SALETIME + '/$shopCode', contentType: default_ContentType);

  //Future<Response> postSaleTime(Map data) => post(ServerInfo.REST_URL_SET_SALETIME, data);

  Future<Response> putDayTime(String shopCode, dynamic data) => put(ServerInfo.REST_URL_SET_DAYTIME + '?shop_cd=$shopCode', data);

  //Future<Response> getSaleDateTime(String shopCode, String tipGbn) => get(ServerInfo.REST_URL_DELITIP + '?shopCd=$shopCode&tipGbn=$tipGbn', contentType: default_ContentType);

  Future<Response> getDeliTip(String shopCode, String tipGbn) => get(ServerInfo.REST_URL_DELITIP + '?shopCd=$shopCode&tipGbn=$tipGbn', contentType: default_ContentType);

  //Future<Response> getDeliTipHistory(String shopCode, String page, String rows) => get(ServerInfo.REST_URL_DELITIPHISTORY + '/$shopCode?page=$page&rows=$rows', contentType: default_ContentType);

  Future<Response> postDeliTip(Map data) => post(ServerInfo.REST_URL_DELITIP, data);

  Future<Response> putDeliTip(Map data) => put(ServerInfo.REST_URL_DELITIP, data);

  Future<Response> deleteDeliTip(String tipSeq, String uCode, String uName) => delete(ServerInfo.REST_URL_DELITIP + '/$tipSeq?modUcode=$uCode&modName=$uName');

  Future<Response> putRemoveShopImage(String cccode, String shop_cd, String salesmanCode, String salesmanName) =>
      put(ServerInfo.REST_URL_IMAGE + '/removeShopImage/$cccode/$shop_cd?&salesmanCode=$salesmanCode&salesmanName=$salesmanName', data);

  Future<Response> putUpdateImageStatus(String shop_cd, String status) => put(ServerInfo.REST_URL_SHOP + '/updateImageStatus?shop_cd=$shop_cd&status=$status', data);

  Future<Response> getShopOrderCancelList(String pos_yn, String gungu, String startdate, String enddate, String page, String rows) =>
      get(ServerInfo.REST_URL_SHOPORDERCANCELLIST + '?pos_yn=$pos_yn&gungu=$gungu&date_begin=$startdate&date_end=$enddate&page=$page&rows=$rows', contentType: default_ContentType);

  //Future<Response> getShopEventList(String mCode, String shopName, String state, String date_begin, String date_end, String page, String rows) => get(ServerInfo.REST_URL_SHOPEVENTLIST + '?mCode=$mCode&shopName=$shopName&state=$state&date_begin=$date_begin&date_end=$date_end&page=$page&rows=$rows', contentType: default_ContentType);

  //Future<Response> getEventHistory(String shopCode, String page, String rows) => get(ServerInfo.REST_URL_SHOPEVENTHIST + '/$shopCode?page=$page&rows=$rows', contentType: default_ContentType);

  //Future<Response> getEventMenu(String shopCode, String state, String page, String rows) =>      get(ServerInfo.REST_URL_SHOPEVENTMENU + '/$shopCode?state=$state&page=$page&rows=$rows', contentType: default_ContentType);

  Future<Response> putMoveReview(String fromShopCode, String toShopCode, String ucode, String uname) => put(ServerInfo.REST_URL_MOVEREVIEW + '?from_shop_cd=$fromShopCode&to_shop_cd=$toShopCode&ucode=$ucode&uname=$uname', '');

  Future<Response> getEventYn(String shopCode) => get(ServerInfo.REST_URL_SHOPEVENTYN + '/$shopCode', contentType: default_ContentType);

  Future<Response> putShopContractEnd(String shopCode, String date_end_contract) => put(ServerInfo.REST_URL_CONTRACTEND+'/$shopCode?date_end_contract=$date_end_contract', '');

  Future<Response> getShopReview(String mcode, String shopCd, String tab, String divKey, String keyword, String date_begin, String date_end, String page, String rows) =>
      get(ServerInfo.REST_URL_SHOPREVIEW + '?mcode=$mcode&shopCd=$shopCd&tab=$tab&divKey=$divKey&keyword=$keyword&date_begin=$date_begin&date_end=$date_end&page=$page&rows=$rows', contentType: default_ContentType);

  Future<Response> getDetail(String seqno, String ucode) => get(ServerInfo.REST_URL_SHOPREVIEW + '/$seqno?ucode=$ucode', contentType: default_ContentType);
  Future<Response> getReportList(String seqno, String page, String rows) => get(ServerInfo.REST_URL_REPORTLIST + '/$seqno?page=$page&rows=$rows', contentType: default_ContentType);
  Future<Response> putAnswer(String seqno, String answerText, String memo, String ucode, String uname) => put(ServerInfo.REST_URL_SHOPREVIEW + '/$seqno?answerText=$answerText&memo=$memo&ucode=$ucode&uname=$uname', data);
  Future<Response> putSetVisible(String seqno, String visible, String ucode, String uname) => put(ServerInfo.REST_URL_SETVISIBLE + '/$seqno?visible=$visible&ucode=$ucode&uname=$uname', data);

  ///////////// 주문조회
  // Future<Response> getOrder(String mCode, String startdate, String enddate, String state, String telNo, String keyword, String custCode, String shopCd, String divKey, String page, String rows) =>
  //     get(ServerInfo.REST_URL_ORDER + '?mCode=$mCode&dateBegin=$startdate&dateEnd=$enddate&state=$state&divKey=$divKey&keyword=$keyword&cust_code=$custCode&shop_cd=$shopCd&page=$page&rows=$rows', contentType: default_ContentType);

  Future<Response> getOrderList(String mCode, String startdate, String enddate, String state, String telNo, String keyword, String custCode, String shopCd, String divKey, String page, String rows) =>
      get(ServerInfo.REST_URL_ORDERLIST + '?mCode=$mCode&dateBegin=$startdate&dateEnd=$enddate&state=$state&divKey=$divKey&keyword=$keyword&cust_code=$custCode&shop_cd=$shopCd&page=$page&rows=$rows',
          contentType: default_ContentType);

  Future<Response> getOrderDetail(String orderSeq, String ucode) => get(ServerInfo.REST_URL_ORDER + '/$orderSeq?ucode=$ucode', contentType: default_ContentType);

  //Future<Response> postOrder(Map data) => post(ServerInfo.REST_URL_ORDER, data);

  Future<Response> putOrder(Map data) => put(ServerInfo.REST_URL_ORDER, data);

  Future<Response> putOrderSetCardApprovalGbn(String order_no) => put(ServerInfo.REST_URL_ORDER_SETCARDAPPROVALGBN + '/' + order_no, data);

  Future<Response> getOrderCancelReasons(String shopCd, String startDate, String endDate) => get(ServerInfo.REST_URL_ORDER_CANCELREASONS + '/' + shopCd + '?date_begin=$startDate&date_end=$endDate');

  Future<Response> getOrderCompleteToCancel(String mCode, String dateBegin, String dateEnd, String page, String rows) =>
      get(ServerInfo.REST_URL_ORDER_COMPLETETOCANCEL + '?mCode=$mCode&dateBegin=$dateBegin&dateEnd=$dateEnd&page=$page&rows=$rows', contentType: default_ContentType);

  Future<Response> getOrderCardApprovalGbn(String order_no) => get(ServerInfo.REST_URL_ORDER_GETCARDAPPROVALGBN + '/$order_no', contentType: default_ContentType);

  ///////////// 쿠폰관리
  //Future<Response> getCoupon(String couponType, String couponStatus, String keyword, int page, int rows) => get(ServerInfo.REST_URL_COUPON + '?couponType=$couponType&couponStatus=$couponStatus&keyword=$keyword&page=$page&rows=$rows', contentType: default_ContentType);
  //Future<Response> getCouponCode() => get(ServerInfo.REST_URL_COUPON_CODE, contentType: default_ContentType);
  Future<Response> postCoupon(String couponType, String couponCount, String isdAmt, String insertUcode, String insertName) =>
      post(ServerInfo.REST_URL_COUPON + '?couponType=$couponType&couponCount=$couponCount&isdAmt=$isdAmt&insertUcode=$insertUcode&insertName=$insertName', data);
  Future<Response> putCoupon(String couponType, String couponCount, String oldStatus, String newStatus, String jobUcode, String jobName) => put(ServerInfo.REST_URL_COUPON + '?couponType=$couponType&couponCount=$couponCount&oldStatus=$oldStatus&newStatus=$newStatus&jobUcode=$jobUcode&jobName=$jobName', ['admin']);

  //Future<Response> getHistoryCoupon(String startDate, String endDate, String page, String rows) => get(ServerInfo.REST_URL_COUPON_HISTORY + '?date_begin=$startDate&date_end=$endDate&page=$page&rows=$rows', contentType: default_ContentType);

  Future<Response> putSetCouponAppCustomer(String jobGbn, String custCode, String couponType, String newStatus, String ucode) => put(ServerInfo.REST_URL_SETCOUPONAPPCUSTOMER + '?jobGbn=$jobGbn&custCode=$custCode&couponType=$couponType&newStatus=$newStatus&ucode=$ucode', ['admin']);
  Future<Response> putSetCouponAppCustomerDisposal(String jobGbn, String custCode, String couponType, String newStatus, String couponNo, String orderNo) =>
      put(ServerInfo.REST_URL_SETCOUPONAPPCUSTOMER + '?jobGbn=$jobGbn&custCode=$custCode&couponType=$couponType&newStatus=$newStatus&couponNo=$couponNo&orderNo=$orderNo', ['admin']);

  //Future<Response> getB2BCoupon(String couponType, String couponStatus, String keyword, int page, int rows) => get(ServerInfo.REST_URL_B2BCOUPON + '?couponType=$couponType&couponStatus=$couponStatus&keyword=$keyword&page=$page&rows=$rows', contentType: default_ContentType);
  //Future<Response> getB2BCouponCode() => get(ServerInfo.REST_URL_B2BCOUPON_CODE, contentType: default_ContentType);
  //Future<Response> getB2BCouponItemCode(String couponType) => get(ServerInfo.REST_URL_B2BCOUPON_ITEMCODE + '?couponType=$couponType', contentType: default_ContentType);
  Future<Response> postB2BCoupon(String couponType, String itemType, String couponCount, String insertUcode, String insertName, String title) =>
      post(ServerInfo.REST_URL_B2BCOUPON + '?couponType=$couponType&itemType=$itemType&couponCount=$couponCount&insertUcode=$insertUcode&insertName=$insertName&title=$title', data);
  Future<Response> putB2BCoupon(String couponType, String itemType, String couponCount, String oldStatus, String newStatus, String jobUcode, String jobName) => put(ServerInfo.REST_URL_B2BCOUPON + '?couponType=$couponType&itemType=$itemType&couponCount=$couponCount&oldStatus=$oldStatus&newStatus=$newStatus&jobUcode=$jobUcode&jobName=$jobName', ['admin']);
  //Future<Response> getB2BDetailCoupon(String couponNo) => get(ServerInfo.REST_URL_B2BCOUPON + '/$couponNo', contentType: default_ContentType);
  //Future<Response> getB2BChangeCoupon(String couponNo) => get(ServerInfo.REST_URL_B2BCOUPON_CHANGE + '/$couponNo', contentType: default_ContentType);
  //Future<Response> getB2BHistoryCoupon(String startDate, String endDate, String page, String rows) => get(ServerInfo.REST_URL_B2BCOUPON_HISTORY + '?date_begin=$startDate&date_end=$endDate&page=$page&rows=$rows', contentType: default_ContentType);
  Future<Response> putB2BSetCouponAppCustomer(String modUcode, String custCode, String couponType, String couponNo, String status) =>
      put(ServerInfo.REST_URL_B2BSETCOUPONAPPCUSTOMER + '?modUcode=$modUcode&custCode=$custCode&couponType=$couponType&couponNo=$couponNo&status=$status', ['admin']);

  //Future<Response> getB2BUserCoupon(String divKey, String keyword, int page, int rows) => get(ServerInfo.REST_URL_B2BUSERCOUPON + '?divKey=$divKey&keyword=$keyword&page=$page&rows=$rows', contentType: default_ContentType);
  Future<Response> postB2BUserCoupon(String name, String loginId, String loginPwd, String mobile, String couponType, String ucode) =>
      post(ServerInfo.REST_URL_B2BUSERCOUPON + '?name=$name&loginId=$loginId&loginPwd=$loginPwd&mobile=$mobile&couponType=$couponType&ucode=$ucode', ['admin']);
  Future<Response> putB2BUserCoupon(String userId, String couponType, String name, String loginId, String loginPwd, String mobile, String useYn, String modUcode) =>
      put(ServerInfo.REST_URL_B2BUSERCOUPONSET + '?userId=$userId&couponType=$couponType&name=$name&loginId=$loginId&loginPwd=$loginPwd&mobile=$mobile&useYn=$useYn&modUcode=$modUcode', ['admin']);
  //Future<Response> getB2BUserCouponDetail(String userId, String ucode) => get(ServerInfo.REST_URL_B2BUSERCOUPONDETAIL + '/$userId?ucode=$ucode', contentType: default_ContentType);
  Future<Response> getB2BUserHistoryCoupon(String couponNo) => get(ServerInfo.REST_URL_B2BUSERCOUPON_CHANGE + '/?couponNo=$couponNo', contentType: default_ContentType);

  Future<Response> getBrandCoupon(String chainCode, String couponType, String status, String keyword, int page, int rows) =>
      get(ServerInfo.REST_URL_BRANDCOUPON + '?chainCode=$chainCode&couponType=$couponType&status=$status&keyword=$keyword&page=$page&rows=$rows', contentType: default_ContentType);

  Future<Response> getBrandDetailCoupon(String couponNo) => get(ServerInfo.REST_URL_BRANDCOUPON + '/$couponNo', contentType: default_ContentType);

  Future<Response> postBrandCoupon(String couponType, String couponCount, String chainCode, String startDate, String endDate, String isdAmt, String insertUcode, String insertName) =>
      post(ServerInfo.REST_URL_BRANDCOUPON + '?couponType=$couponType&couponCount=$couponCount&chainCode=$chainCode&startDate=$startDate&endDate=$endDate&isdAmt=$isdAmt&insertUcode=$insertUcode&insertName=$insertName', data);

  Future<Response> putBrandCoupon(String couponType, String couponCount, String oldStatus, String newStatus, String jobUcode, String jobName) =>
      put(ServerInfo.REST_URL_BRANDCOUPON + '?couponType=$couponType&couponCount=$couponCount&oldStatus=$oldStatus&newStatus=$newStatus&jobUcode=$jobUcode&jobName=$jobName', ['admin']);

  Future<Response> putBrandSetCouponAppCustomer(String modUcode, String custCode, String couponType, String couponNo, String status) =>
      put(ServerInfo.REST_URL_BRANDSETCOUPONAPPCUSTOMER + '?modUcode=$modUcode&custCode=$custCode&couponType=$couponType&couponNo=$couponNo&status=$status', ['admin']);

  //Future<Response> getBrandHistoryCoupon(String startDate, String endDate, String page, String rows) =>      get(ServerInfo.REST_URL_BRANDCOUPON_HISTORY + '?date_begin=$startDate&date_end=$endDate&page=$page&rows=$rows', contentType: default_ContentType);

  //Future<Response> getBrandList() => get(ServerInfo.REST_URL_GETBRANDLIST, contentType: default_ContentType);

  //Future<Response> getBrandCouponList(String chainCode) => get(ServerInfo.REST_URL_GETBRANDCOUPONLIST + '?chainCode=$chainCode', contentType: default_ContentType);

  //Future<Response> getBrandChangeCoupon(String couponNo) => get(ServerInfo.REST_URL_BRANDCOUPON_CHANGE + '/$couponNo', contentType: default_ContentType);

  //Future<Response> getBrandCouponShopList(String chainCode, String couponType, String page, String rows) =>      get(ServerInfo.REST_URL_GETBRANDCOUPONSHOP + '?chainCode=$chainCode&couponType=$couponType&page=$page&rows=$rows', contentType: default_ContentType);

  Future<Response> putBrandCouponShop(String couponType, String useYn, String useMaxCount, String modUcode, String modName, var data) =>
      put(ServerInfo.REST_URL_GETBRANDCOUPONSHOP + '?couponType=$couponType&useYn=$useYn&useMaxCount=$useMaxCount&modUcode=$modUcode&modName=$modName', data);

  //Future<Response> getBrandCouponAppList(String chainCode, String couponType, String page, String rows) =>      get(ServerInfo.REST_URL_GETBRANDCOUPONAPP + '?chainCode=$chainCode&couponType=$couponType&page=$page&rows=$rows', contentType: default_ContentType);

  Future<Response> postBrandCouponApp(String couponType, String chainCode, String orderMinAmt, String payMinAmt, String deliveryYn, String packYn, String displayStDate, String displayExpDate, String insertUcode, String insertName, String useYn) =>
      post(ServerInfo.REST_URL_GETBRANDCOUPONAPP + '?couponType=$couponType&chainCode=$chainCode&orderMinAmt=$orderMinAmt&payMinAmt=$payMinAmt&deliveryYn=$deliveryYn&packYn=$packYn&displayStDate=$displayStDate&displayExpDate=$displayExpDate&insertUcode=$insertUcode&insertName=$insertName&useYn=$useYn', '');

  Future<Response> putBrandCouponApp(String couponType, String orderMinAmt, String payMinAmt, String deliveryYn, String packYn, String displayStDate, String displayExpDate, String modUcode, String modeName, String useYn) =>
      put(ServerInfo.REST_URL_GETBRANDCOUPONAPP + '?couponType=$couponType&orderMinAmt=$orderMinAmt&payMinAmt=$payMinAmt&deliveryYn=$deliveryYn&packYn=$packYn&displayStDate=$displayStDate&displayExpDate=$displayExpDate&modUcode=$modUcode&modeName=$modeName&useYn=$useYn', ['admin']);

  Future<Response> deleteBrandCouponApp(String couponType) => delete(ServerInfo.REST_URL_GETBRANDCOUPONAPP + '?couponType=$couponType');

  //Future<Response> getBrandCouponAppDetail(String couponType) => get(ServerInfo.REST_URL_GETBRANDCOUPONAPP + '/$couponType', contentType: default_ContentType);

  ///////////// 내역
  Future<Response> getHistoryMileage(String startDate, String endDate, String page, String rows) => get(ServerInfo.REST_URL_MILEAGEHISTORY + '?date_begin=$startDate&date_end=$endDate&page=$page&rows=$rows', contentType: default_ContentType);

  Future<Response> getMileageInOut(String date_begin, String date_end, String mcode, String cust_gbn, String keyword, String page, String rows) => get(ServerInfo.REST_URL_MILEAGEINOUT + '?date_begin=$date_begin&date_end=$date_end&mcode=$mcode&cust_gbn=$cust_gbn&keyword=$keyword&page=$page&rows=$rows', contentType: default_ContentType);

  Future<Response> getMileageSaleInOut(String date_begin, String date_end, String mcode, String sale_gbn, String cust_gbn) => get(ServerInfo.REST_URL_MILEAGESALEINOUT + '?date_begin=$date_begin&date_end=$date_end&mcode=$mcode&sale_gbn=$sale_gbn&cust_gbn=$cust_gbn', contentType: default_ContentType);

  ///////////// 회원 관리
  //Future<Response> getCustomer(String divKey, String keyword, String custCode, String page, String rows) => get(ServerInfo.REST_URL_CUSTOMER + '?divKey=$divKey&keyword=$keyword&custCode=$custCode&page=$page&rows=$rows', contentType: default_ContentType);

  //Future<Response> getCustomerInfo(String custCode, String ucode) => get(ServerInfo.REST_URL_CUSTOMERINFO + '/$custCode?ucode=$ucode', contentType: default_ContentType);

  //Future<Response> getCustomerMileage(String custCode) => get(ServerInfo.REST_URL_CUSTOMERMILEAGE + '/$custCode', contentType: default_ContentType);

  //Future<Response> getCustomerCoupon(String custCode, String status) => get(ServerInfo.REST_URL_CUSTOMERCOUPON + '/$custCode?status=$status', contentType: default_ContentType);

  Future<Response> putCustomerJoinInfo(String cust_code, String cust_id, String memo, String mod_ucode, String mod_name) =>
      put(ServerInfo.REST_URL_CUSTOMERINFO + '/$cust_code?cust_id=$cust_id&memo=$memo&mod_ucode=$mod_ucode&mod_name=$mod_name', data);

  Future<Response> deleteCustomerRetire(String cust_code , String retire_memo) => put(ServerInfo.REST_URL_CUSTOMERRETIRE + '/$cust_code?retire_memo=$retire_memo', '');

  ///////////// 공지사항&이벤트 관리
  Future<Response> getNotice(String noticeGbn, String dispGbn, String fromDate, String toDate, int page, int rows) => get(ServerInfo.REST_URL_NOTICE + '?noticeGbn=$noticeGbn&dispGbn=$dispGbn&fromDate=$fromDate&toDate=$toDate&page=$page&rows=$rows', contentType: default_ContentType);

  // Future<Response> postNotice(Map data) => post(ServerInfo.REST_URL_NOTICE, data);
  //
  // Future<Response> putNotice(Map data) => put(ServerInfo.REST_URL_NOTICE, data);

  Future<Response> getNoticeDetail(String noticeSeq) => get(ServerInfo.REST_URL_NOTICE + '/$noticeSeq', contentType: default_ContentType);

  Future<Response> getDashboardNotice() => get(ServerInfo.REST_URL_NOTICE + '/getNoticeMain', contentType: default_ContentType);

  Future<Response> getNoticeSortList(String noticeGbn) => get(ServerInfo.REST_URL_NOTICE + '/getNoticeSortList?noticeGbn=$noticeGbn', contentType: default_ContentType);

  Future<Response> postNoticeSort(dynamic data) => post(ServerInfo.REST_URL_NOTICE_SORT, data);

  ///////////// 사용자관리
  //Future<Response> getUser(String mCode, String level, String working, String id_name, String memo, String page, String rows) => get(ServerInfo.REST_URL_USER + '?mCode=$mCode&level=$level&working=$working&id_name=$id_name&memo=$memo&page=$page&rows=$rows', contentType: default_ContentType);

  Future<Response> postUser(Map data) => post(ServerInfo.REST_URL_USER, data);

  Future<Response> putUser(Map data) => put(ServerInfo.REST_URL_USER, data);

  Future<Response> getUserDetail(String shopCode, String rUcode) => get(ServerInfo.REST_URL_USER + '/$shopCode?rUcode=$rUcode', contentType: default_ContentType);

  Future<Response> getUserLogin(String id, String password) => get(ServerInfo.REST_URL_USER_LOGIN + '/$id' + '/$password', contentType: default_ContentType);

  Future<Response> getUserOtpConfirm(String uCode, String secCode) => get(ServerInfo.REST_URL_USER_OTPCONFIRM + '/$uCode' + '/$secCode', contentType: default_ContentType);

  Future<Response> getIdCheck(String id) => get(ServerInfo.REST_URL_USER_CHECK + '/$id', contentType: default_ContentType);

  Future<Response> getUserCodeName(String mcode, String level) => get(ServerInfo.REST_URL_USER_CODE_NAME + '?mcode=$mcode&level=$level', contentType: default_ContentType);

  Future<Response> getAddLoginLog(String ucode, String log_gbn, String ip) => post(ServerInfo.REST_URL_USER_ADDLOGINLOG + '?ucode=$ucode&log_gbn=$log_gbn&ip=$ip', data);

  ///////////// 이미지관리
  //Future<Response> getImage(String shopCode) => get(ServerInfo.REST_URL_IMAGE + '?shop_cd=$shopCode', contentType: default_ContentType);

  Future<Response> getThumbImage(String cccode, String shopCode, String file_name, String width, String height) => get(ServerInfo.REST_URL_IMAGETHUMB + '?cccode=$cccode&shop_cd=$shopCode&file_name=$file_name&width=$width&height=$height', contentType: default_ContentType);

  //Future<Response> postImage(String div, String cccode, String shopCode, String menuName, Map data) => post(ServerInfo.REST_URL_IMAGE + '?div=$div&cccode=$cccode&shop_cd=$shopCode&menu_name=$menuName', data);
  //Future<Response> putImage(String cccode, String shopCode, String menuCode, Map data) => put(ServerInfo.REST_URL_IMAGE + '?menu_cd=$menuCode&cccode=$cccode&shop_cd=$shopCode', data);
  Future<Response> putMenuImageRemove(String menuCode, String cccode, String shopCode) => put(ServerInfo.REST_URL_MENUIMAGE_REMOVE + '?menu_cd=$menuCode&cccode=$cccode&shop_cd=$shopCode', '');

  ////////////// 네이버
  Future<Response> getNaver(String address) => get(ServerInfo.REST_URL_NAVER + '?address=$address', contentType: default_ContentType);

  ///////////// API
  Future<Response> getApiCompany(String comType, String comGbn) => get(ServerInfo.REST_URL_API + '?comType=$comType&comGbn=$comGbn', contentType: default_ContentType);

  Future<Response> getApiCompanyDetail(String seq) => get(ServerInfo.REST_URL_API + '/' + seq, contentType: default_ContentType);

  Future<Response> postApiCompany(Map data) => post(ServerInfo.REST_URL_API, data);

  Future<Response> putApiCompany(Map data) => put(ServerInfo.REST_URL_API, data);

  ///////////// MAPPING
  Future<Response> getMapping(String useGbn, String apiType, String shopName, String page, String rows) => get(ServerInfo.REST_URL_MAPPING + '?usgGbn=$useGbn&apiType=$apiType&shopName=$shopName&page=$page&rows=$rows', contentType: default_ContentType);

  Future<Response> getMappingDetail(String seq) => get(ServerInfo.REST_URL_MAPPING + '/' + seq, contentType: default_ContentType);

  Future<Response> getCheckApiMap(String shop_cd) => get(ServerInfo.REST_URL_MAPPING_CHECK + '/' + shop_cd, contentType: default_ContentType);

  Future<Response> postMapping(Map data) => post(ServerInfo.REST_URL_MAPPING, data);

  Future<Response> putMapping(Map data) => put(ServerInfo.REST_URL_MAPPING, data);

  //Future<Response> updateAgent(Map data) => put(ServerInfo.REST_URL_AGENT+'?', data);
  //Future<Response> deleteAgent(int id) => delete(ServerInfo.REST_URL_AGENT+'?seq=$id');

  ///////////// 로지올 ReviewAPI
  Future<Response> postReviewToken(Map data) => post(ServerInfo.REVIEW_API_TOKEN, data);

  Future<Response> postReviewShopRegi(Map data) => post(ServerInfo.REVIEW_API_SHOPCONFIRM, data);

  Future<Response> postReviewShopInfo(Map data) => post(ServerInfo.REVIEW_API_SHOPINFO, data);

  ///////////// 카드 결재 취소
  Future<Response> postPayBasicCancel(Map data) => post(ServerInfo.PAY_BASIC_CANCEL, data, headers: {
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Headers": "X-API-KEY, Origin, X-Requested-With, Content-Type, Accept, Access-Control-Request-Method,Access-Control-Request-Headers, Authorization",
        "Access-Control-Allow-Credentials": "true",
        "Access-Control-Allow-Methods": "HEAD, GET, POST, PUT, PATCH, DELETE, OPTIONS",
        "Authorization": "QzI1QTgyNEVFQkVEQ0U5RkM2NTUzODFCNTc3MUJENTc=",
        "Method": "DELETE",
        "Content-Type": "application/json",
      });

  Future<Response> postPaySmartCancel(Map data) => post(ServerInfo.PAY_SMART_CANCEL, data, headers: {
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Headers": "X-API-KEY, Origin, X-Requested-With, Content-Type, Accept, Access-Control-Request-Method,Access-Control-Request-Headers, Authorization",
        "Access-Control-Allow-Credentials": "true",
        "Access-Control-Allow-Methods": "HEAD, GET, POST, PUT, PATCH, DELETE, OPTIONS",
        "Authorization": "QzI1QTgyNEVFQkVEQ0U5RkM2NTUzODFCNTc3MUJENTc=",
        "Method": "DELETE",
        "Content-Type": "application/json",
      });

  Future<Response> postPayApiCancel(Map data) => post(ServerInfo.PAY_API_CANCEL, data, headers: {
    "Access-Control-Allow-Origin": "*", // Required for CORS support to work
    "Access-Control-Allow-Headers": "X-API-KEY, Origin, X-Requested-With, Content-Type, Accept, Access-Control-Request-Method,Access-Control-Request-Headers, Authorization",
    "Access-Control-Allow-Credentials": "true",
    "Access-Control-Allow-Methods": "HEAD, GET, POST, PUT, PATCH, DELETE, OPTIONS",
    "Authorization": "QzI1QTgyNEVFQkVEQ0U5RkM2NTUzODFCNTc3MUJENTc=",
    "Method": "DELETE",
    "Content-Type": "application/json",
  });

  ///////////// 통계

  //Future<Response> getStatShopTotalOrder(String gungu, String startDate, String endDate) => get(ServerInfo.REST_URL_STAT_SHOPTOTALORDER + '?gungu=$gungu&date_begin=$startDate&date_end=$endDate', contentType: default_ContentType);

  //Future<Response> getStatShopType(String startDate, String endDate) => get(ServerInfo.REST_URL_STAT_SHOPTYPE + '?date_begin=$startDate&date_end=$endDate', contentType: default_ContentType);

  //Future<Response> getStatShopTypeDetail(String gungu, String startDate, String endDate) => get(ServerInfo.REST_URL_STAT_SHOPTYPE_GUNGU + '/$gungu?date_begin=$startDate&date_end=$endDate', contentType: default_ContentType);

  //Future<Response> getStatShopSales(String startDate, String endDate) => get(ServerInfo.REST_URL_STAT_SHOPSALES + '?date_begin=$startDate&date_end=$endDate', contentType: default_ContentType);

  //Future<Response> getStatShopSalesDetail(String gungu, String startDate, String endDate) => get(ServerInfo.REST_URL_STAT_SHOPSALES_DETAIL + '/$gungu?date_begin=$startDate&date_end=$endDate', contentType: default_ContentType);

  //Future<Response> getShopGungu(String divKey, String startDate, String endDate) => get(ServerInfo.REST_URL_STAT_SHOPGUNGU + '?divKey=$divKey&date_begin=$startDate&date_end=$endDate', contentType: default_ContentType);

  //Future<Response> getShopCategory(String startDate, String endDate) => get(ServerInfo.REST_URL_STAT_SHOPCATEGORY + '?date_begin=$startDate&date_end=$endDate', contentType: default_ContentType);

  //Future<Response> getStatCustomerDaily(String startDate, String endDate) => get(ServerInfo.REST_URL_STAT_CUSTOMERDAILY + '?date_begin=$startDate&date_end=$endDate', contentType: default_ContentType);

  //Future<Response> getStatNonCustomerDaily(String startDate, String endDate) => get(ServerInfo.REST_URL_STAT_NONCUSTOMERDAILY + '?date_begin=$startDate&date_end=$endDate', contentType: default_ContentType);

  //Future<Response> getStatCustomerOrder(String startDate, String endDate) => get(ServerInfo.REST_URL_STAT_CUSTOMERORDER + '?date_begin=$startDate&date_end=$endDate', contentType: default_ContentType);

  //Future<Response> getStatCustomerRankOrder(String startDate, String endDate) => get(ServerInfo.REST_URL_STAT_CUSTOMERRANKORDER + '?date_begin=$startDate&date_end=$endDate', contentType: default_ContentType);

  //Future<Response> getStatOrderCategory(String startDate, String endDate) => get(ServerInfo.REST_URL_STAT_ORDERCATEGORY + '?date_begin=$startDate&date_end=$endDate', contentType: default_ContentType);

  //Future<Response> getStatOrderTime(String startDate, String endDate) => get(ServerInfo.REST_URL_STAT_ORDERTIME + '?date_begin=$startDate&date_end=$endDate', contentType: default_ContentType);

  //Future<Response> getStatOrderPay(String startDate, String endDate) => get(ServerInfo.REST_URL_STAT_ORDERPAY + '?date_begin=$startDate&date_end=$endDate', contentType: default_ContentType);

  //Future<Response> getStatOrderGungu(String startDate, String endDate) => get(ServerInfo.REST_URL_STAT_ORDERGUNGU + '?date_begin=$startDate&date_end=$endDate', contentType: default_ContentType);

  //Future<Response> getStatOrderDailyCompletedCanceled(String startDate, String endDate) => get(ServerInfo.REST_URL_STAT_DAILYORDER_COMPLETEDCANCELED + '?date_begin=$startDate&date_end=$endDate', contentType: default_ContentType);

  //Future<Response> getStatOrderDailyCancelReason(String startDate, String endDate) => get(ServerInfo.REST_URL_STAT_DAILYORDER_CANCELREASON + '?date_begin=$startDate&date_end=$endDate', contentType: default_ContentType);

  //Future<Response> getStatOrderDailyPayGbn(String startDate, String endDate) => get(ServerInfo.REST_URL_STAT_DAILYORDER_PAYGBN + '?date_begin=$startDate&date_end=$endDate', contentType: default_ContentType);

  //Future<Response> getDailyAgeToOrder(String startDate, String endDate) => get(ServerInfo.REST_URL_STAT_DAILYAGE_TO_ORDER + '?date_begin=$startDate&date_end=$endDate', contentType: default_ContentType);

  //Future<Response> getDailyEventCount(String startDate, String endDate) =>      get(ServerInfo.REST_URL_STAT_SHOPEVENTCOUNT + '?date_begin=$startDate&date_end=$endDate', contentType: default_ContentType);

  //Future<Response> getStatCouponDrgCoupon(String coupon_name) => get(ServerInfo.REST_URL_STAT_DRGCOUPON + '?coupon_name=$coupon_name', contentType: default_ContentType);

  //Future<Response> getStatCouponDrgCouponDetail(String mon, String coupon_name) => get(ServerInfo.REST_URL_STAT_DRGCOUPON + '/$mon?coupon_name=$coupon_name', contentType: default_ContentType);

  //Future<Response> getStatCouponDailyDrgCoupon(String type, String coupon_name, String startDate, String endDate) => get(ServerInfo.REST_URL_STAT_DAILYDRGCOUPON + '?type=$type&coupon_name=$coupon_name&date_begin=$startDate&date_end=$endDate', contentType: default_ContentType);

  //Future<Response> getMileageInOutMonth(String date_begin, String date_end, String cust_gbn) => get(ServerInfo.REST_URL_STAT_MILEAGEINOUTMONTH + '?date_begin=$date_begin&date_end=$date_end&cust_gbn=$cust_gbn', contentType: default_ContentType);

  //Future<Response> getMileageInOutDay(String date_begin, String date_end, String cust_gbn, String date_ym) => get(ServerInfo.REST_URL_STAT_MILEAGEINOUTDAY + '/$date_ym?date_begin=$date_begin&date_end=$date_end&cust_gbn=$cust_gbn', contentType: default_ContentType);

  //Future<Response> getMileageSaleInOutMonth(String date_begin, String date_end, String cust_gbn, String sale_gbn) => get(ServerInfo.REST_URL_STAT_MILEAGESALEINOUTMONTH + '?date_begin=$date_begin&date_end=$date_end&cust_gbn=$cust_gbn&sale_gbn=$sale_gbn', contentType: default_ContentType);

  //Future<Response> getMileageSaleInOutDay(String date_begin, String date_end, String cust_gbn, String date_ym, String sale_gbn) => get(ServerInfo.REST_URL_STAT_MILEAGESALEINOUTDAY + '/$date_ym?date_begin=$date_begin&date_end=$date_end&cust_gbn=$cust_gbn&sale_gbn=$sale_gbn', contentType: default_ContentType);



  ///////////// REST ERROR
  Future<Response> postRestError(String div, String position, String msg) => post(ServerInfo.REST_URL_LOG_ERROR + '?div=$div&position=$position&msg=$msg', '');


  ///////////// 정산 관리
  // Future<Response> getCalculateOrderCalculateList(String mCode, String status, String payGbn, String date_begin, String date_end, String divKey, String keyword, String page, String rows) => get(
  //     ServerInfo.REST_URL_CALCULATE_GETORDERCALCULATELIST +
  //         '?mcode=$mCode&status=$status&payGbn=$payGbn&date_begin=$date_begin&date_end=$date_end&divKey=$divKey&keyword=$keyword&page=$page&rows=$rows',
  //     contentType: default_ContentType);

  // Future<Response> getCalculateOrderCalculateSum(String mCode, String status, String payGbn, String date_begin, String date_end, String divKey, String keyword) => get(
  //     ServerInfo.REST_URL_CALCULATE_GETORDERCALCULATESUM +
  //         '?mcode=$mCode&status=$status&payGbn=$payGbn&date_begin=$date_begin&date_end=$date_end&divKey=$divKey&keyword=$keyword',
  //     contentType: default_ContentType);

  // Future<Response> getShopCalculateList(String mCode, String startDate, String endDate, String page, String rows, String divKey, String name, String memo) =>
  //     get(ServerInfo.REST_URL_CALCULATE_SHOPMILEAGE + '?mcode=$mCode&date_begin=$startDate&date_end=$endDate&page=$page&rows=$rows&divKey=$divKey&keyword=$name&memo=$memo',
  //         contentType: default_ContentType);

  // Future<Response> getShopCalculateSum(String mCode, String startDate, String endDate, String divKey, String name) =>
  //     get(ServerInfo.REST_URL_CALCULATE_SHOPMILEAGESUM + '?mcode=$mCode&date_begin=$startDate&date_end=$endDate&divKey=$divKey&keyword=$name',
  //         contentType: default_ContentType);

  // Future<Response> getCcCalculateList(String mCode, String ccCode, String startDate, String endDate, String page, String rows, String keyword, String memo) =>
  //     get(ServerInfo.REST_URL_CALCULATE_CCMILEAGE + '?mcode=$mCode&cccode=$ccCode&date_begin=$startDate&date_end=$endDate&keyword=$keyword&memo=$memo&page=$page&rows=$rows',
  //         contentType: default_ContentType);

  // Future<Response> getCcCalculateSum(String mCode, String ccCode, String startDate, String endDate, String keyword, String memo) =>
  //     get(ServerInfo.REST_URL_CALCULATE_CCMILEAGESUM + '?mcode=$mCode&cccode=$ccCode&date_begin=$startDate&date_end=$endDate&keyword=$keyword&memo=$memo',
  //         contentType: default_ContentType);

  // Future<Response> getCommissionList(String mCode, String startDate, String endDate, String divKey, String name, String chargeGbn, String page, String rows) =>
  //     get(ServerInfo.REST_URL_CALCULATE_COMMISSION + '?mcode=$mCode&date_begin=$startDate&date_end=$endDate&divKey=$divKey&keyword=$name&charge_gbn=$chargeGbn&page=$page&rows=$rows',
  //         contentType: default_ContentType);

  Future<Response> postShopCharge(String mCode, String ccCode, String shopCd, String ioGbn, String amt, String memo, String ucode) =>
      post(ServerInfo.REST_URL_CALCULATE_INSERTSHOPCHARGE + '?mcode=$mCode&cccode=$ccCode&shopCd=$shopCd&ioGbn=$ioGbn&amt=$amt&memo=$memo&ucode=$ucode', '');

  //Future<Response> getUngeneratedTax(String fee_ym, String job_gbn) => get(ServerInfo.REST_URL_CALCULATE_UNGENERATEDTAX + '?fee_ym=$fee_ym&job_gbn=$job_gbn', contentType: default_ContentType);

  //Future<Response> getUnpublishedTax(String fee_ym) => get(ServerInfo.REST_URL_CALCULATE_UNPUBLISHEDTAX + '?fee_ym=$fee_ym', contentType: default_ContentType);

  // Future<Response> postInsertTaxMast(String div, String jobGbn, String feeYm, String memo, String modUcode, String modName, var data) =>
  //     post(ServerInfo.REST_URL_CALCULATE_INSERTTAXMAST + '?jobGbn=$jobGbn&div=$div&feeYm=$feeYm&memo=$memo&modUcode=$modUcode&modName=$modName', data);

  // Future<Response> putTaxBill(String jobGbn, String jobGbn2, String div, String feeYm, String sendType, String ucode, String uName, var data) =>
  //     put(ServerInfo.REST_URL_CALCULATE_TAXBILL + '?jobGbn=$jobGbn&jobGbn2=$jobGbn2&div=$div&feeYm=$feeYm&sendType=$sendType&modUcode=$ucode&modName=$uName', data);

  // Future<Response> getSearchShopTax(String fee_ym, String mcode, String chargeGbn, String gbn, String prtYn, String shop_name, String page, String rows) =>
  //     get(ServerInfo.REST_URL_CALCULATE_SEARCHSHOPTAX + '?fee_ym=$fee_ym&mcode=$mcode&chargeGbn=$chargeGbn&gbn=$gbn&prtYn=$prtYn&page=$page&rows=$rows', contentType: default_ContentType);

  Future<Response> getCount(String fee_ym, String jobGbn) =>
      get(ServerInfo.REST_URL_CALCULATE_GETCOUNT + '?feeYm=$fee_ym&jobGbn=$jobGbn', contentType: default_ContentType);

  ///////////// 요청 관리
  Future<Response> getRequestList(String mCode, String service_gbn, String status, String ucode, String cancel_req_yn, String page, String rows, String date_begin, String date_end) => get(
      ServerInfo.REST_URL_REQUESTLIST +
          '?mCode=$mCode&service_gbn=$service_gbn&status=$status&ucode=$ucode&cancel_req_yn=$cancel_req_yn&page=$page&rows=$rows&date_begin=$date_begin&date_end=$date_end',
      contentType: default_ContentType);

  Future<Response> getServiceGbn() => get(ServerInfo.REST_URL_SERVICEGBN, contentType: default_ContentType);

  Future<Response> putServiceStatus(String seq, String status, String mod_ucode, String mod_name) =>
      put(ServerInfo.REST_URL_SERVICESTATUS + '/$seq?status=$status&mod_ucode=$mod_ucode&mod_name=$mod_name', ['admin']);

  Future<Response> putServiceRequest(Map data) => put(ServerInfo.REST_URL_SERVICEREQUEST, data);

  Future<Response> getServiceRequestDetail(String seq) => get(ServerInfo.REST_URL_REQUESTLIST + '/$seq', contentType: default_ContentType);

  ///////////// 로그 관리
  //Future<Response> getErrorLogList(String startDate, String endDate, String page, String rows, String divKey, String keyword) => get(ServerInfo.REST_URL_LOG_ERROR + '?divKey=$divKey&keyword=$keyword&date_begin=$startDate&date_end=$endDate&page=$page&rows=$rows', contentType: default_ContentType);

  Future<Response> getErrorLogDetail(String seq) => get(ServerInfo.REST_URL_LOG_ERROR + '/$seq', contentType: default_ContentType);

  ///////////// 코드 관리
  Future<Response> getCodeList(String codeGrp, String useGbn) =>
      get(ServerInfo.REST_URL_CODE + '?codeGrp=$codeGrp&useGbn=$useGbn', contentType: default_ContentType);

  Future<Response> postCodeListData(String CODE_GRP, String CODE, String CODE_NM, String MEMO, String USE_TIME, String USE_GBN, String ETC_CODE2, String ETC_AMT1, String ETC_AMT2, String ETC_AMT3, String ETC_AMT4,
      String ETC_CODE_GBN1, String ETC_CODE_GBN3, String ETC_CODE_GBN4, String ETC_CODE_GBN5, String ETC_CODE_GBN6, String ETC_CODE_GBN7, String ETC_CODE_GBN8, String uCode, String uName) =>
      post(ServerInfo.REST_URL_CODE +
              '?codeGrp=$CODE_GRP&code=$CODE&codeName=$CODE_NM&memo=$MEMO&amt1=$ETC_AMT1&amt2=$ETC_AMT2&amt3=$ETC_AMT3&amt4=$ETC_AMT4&gbn1=$ETC_CODE_GBN1&gbn3=$ETC_CODE_GBN3&value1=$ETC_CODE_GBN4&value2=$ETC_CODE_GBN5&value3=$ETC_CODE_GBN6&value4=$ETC_CODE_GBN7&value5=$ETC_CODE_GBN8&useTime=$USE_TIME&useGbn=$USE_GBN&etc_code2=$ETC_CODE2&insUCode=$uCode&insName=$uName',
          '');

  Future<Response> putCodeListData(String CODE_GRP, String CODE, String CODE_NM, String MEMO, String USE_TIME, String USE_GBN, String etc_code2, String ETC_AMT1, String ETC_AMT2, String ETC_AMT3, String ETC_AMT4,
      String ETC_CODE_GBN1, String ETC_CODE_GBN3, String ETC_CODE_GBN4, String ETC_CODE_GBN5, String ETC_CODE_GBN6, String ETC_CODE_GBN7, String ETC_CODE_GBN8, String uCode, String uName) =>
      put(ServerInfo.REST_URL_CODE +
              '?codeGrp=$CODE_GRP&code=$CODE&codeName=$CODE_NM&memo=$MEMO&amt1=$ETC_AMT1&amt2=$ETC_AMT2&amt3=$ETC_AMT3&amt4=$ETC_AMT4&gbn1=$ETC_CODE_GBN1&gbn3=$ETC_CODE_GBN3&value1=$ETC_CODE_GBN4&value2=$ETC_CODE_GBN5&value3=$ETC_CODE_GBN6&value4=$ETC_CODE_GBN7&value5=$ETC_CODE_GBN8&useTime=$USE_TIME&useGbn=$USE_GBN&etc_code2=$etc_code2&modUCode=$uCode&modName=$uName',
          '');

  Future<Response> deleteCodeList(String codeGrp, String code) => delete(ServerInfo.REST_URL_CODE + '?codeGrp=$codeGrp&code=$code');

  Future<Response> getFoodSafetyData(String code) => get(ServerInfo.REST_URL_CODE_GETFOODSAFETY + '?code=$code', contentType: default_ContentType);

  Future<Response> putFoodSafetyData(String code, String nutrition, String allergy, String modUcode, String modName) => put(ServerInfo.REST_URL_CODE_PUTFOODSAFETY + '?code=$code&nutrition=$nutrition&allergy=$allergy&modUcode=$modUcode&modName=$modName', '');

// Future<Response> getCouponCodeList(String useGbn) => get(
//     ServerInfo.REST_URL_RESTCOUPONCODE + '?useGbn=$useGbn', contentType: default_ContentType);
//
// Future<Response> postCouponCodeListData(String CODE, String CODE_NM, String MEMO, String USE_GBN, String ETC_AMT1, String ETC_AMT2, String ETC_AMT3,
//     String ETC_CODE_GBN4, String ETC_CODE_GBN5, String ETC_CODE_GBN6, String ETC_CODE_GBN7, String uCode, String uName
//     ) => post(ServerInfo.REST_URL_RESTCOUPONCODE + '?code=$CODE&codeName=$CODE_NM&memo=$MEMO&amt1=$ETC_AMT1&amt2=$ETC_AMT2&amt3=$ETC_AMT3&value1=$ETC_CODE_GBN4&value2=$ETC_CODE_GBN5&value3=$ETC_CODE_GBN6&value4=$ETC_CODE_GBN7&useGbn=$USE_GBN&insUCode=$uCode&insName=$uName', '');
//
// Future<Response> putCouponCodeListData(String CODE, String CODE_NM, String MEMO, String USE_GBN, String ETC_AMT1, String ETC_AMT2, String ETC_AMT3,
//     String ETC_CODE_GBN4, String ETC_CODE_GBN5, String ETC_CODE_GBN6, String ETC_CODE_GBN7, String uCode, String uName
//     ) => put(ServerInfo.REST_URL_RESTCOUPONCODE + '?code=$CODE&codeName=$CODE_NM&memo=$MEMO&amt1=$ETC_AMT1&amt2=$ETC_AMT2&amt3=$ETC_AMT3&value1=$ETC_CODE_GBN4&value2=$ETC_CODE_GBN5&value3=$ETC_CODE_GBN6&value4=$ETC_CODE_GBN7&useGbn=$USE_GBN&modUCode=$uCode&modName=$uName', '');
//
// Future<Response> deleteCouponCodeList(String code) => delete(ServerInfo.REST_URL_RESTCOUPONCODE + '?code=$code');

  Future<Response> postAdminMenuSort(dynamic data) => post(ServerInfo.REST_URL_AUTH_ADMINMENU_SORT, data);
}
