class ServerInfo {
  static const String APP_VERSION = "검수중";//"v2.1.4";//
  
  // 이미지경로
  static const String REST_IMG_BASEURL = "";  // 실서버 배포

  //API경로
  // static const String REST_BASEURL = "https://admin.daeguro.co.kr/api"; //  실서버API
  // static const String REST_RESERVEURL = 'https://admin.daeguro.co.kr/Reserveapi';  // 실서버API

  static const String REST_BASEURL = "http://dgpub.282.co.kr:8426";  // 테스트서버API
  static const String REST_RESERVEURL = 'https://reser.daeguro.co.kr:10018';//"/Reserveapi";  // 테스트서버API

  ///////////// 전체현황
  static const String REST_URL_DASHBOARD = REST_BASEURL + "/Total/getShopCount";
  static const String REST_URL_DASHBOARDWEEKORDER = REST_BASEURL + "/Total/getWeekOrder";
  static const String REST_URL_DASHBOARDWEEKCUSTOMER = REST_BASEURL + "/Total/getWeekCustomer";
  static const String REST_URL_DASHBOARDTODAYCOUNT = REST_BASEURL + "/Total/getTodayCount";
  //static const String REST_URL_DASHBOARDTOTALINFOSUM = REST_BASEURL + "/Total/getDaeguroTotalInfoSum";

  static const String REST_URL_DASHBOARDTOTALINSTALLOS = REST_BASEURL + "/Total/getTotalInstalled";
  static const String REST_URL_DASHBOARDTOTALORDERS = REST_BASEURL + "/Total/getTotalOrders";
  static const String REST_URL_DASHBOARDTOTALYEARMEMBERS = REST_BASEURL + "/Total/getTotalYearMembers";
  static const String REST_URL_DASHBOARDTOTALCANCEL = REST_BASEURL + "/Total/getTotalCancel";

  /////////////
  static const String REST_URL_AGENT = REST_BASEURL + "/Agent";
  static const String REST_URL_AGENT_CODE = REST_BASEURL +"/AgentCode";

  static const String REST_URL_MEMBERSHIP_CODE = REST_BASEURL +"/MembershipCode";

  ///////////// 가맹점
  static const String REST_URL_SHOP = REST_BASEURL +"/Shop";
  static const String REST_URL_SHOPMODIFICATIONREGNO = REST_BASEURL +"/ShopInfo/getRegNoHist";
  static const String REST_URL_SHOP_IMAGESTATUS = REST_BASEURL + "/Shop/updateImageStatus";
  static const String REST_URL_SHOPHISTORY = REST_BASEURL +"/Shop/history";


  static const String REST_URL_SHOPBASIC = REST_BASEURL +"/ShopBasic";
  static const String REST_URL_SHOPFRANCHISELIST = REST_BASEURL +"/ShopBasic/getFranchiseList";
  static const String REST_URL_SHOPINFO = REST_BASEURL +"/ShopInfo";
  static const String REST_URL_SHOPIMAGEHISTORY = REST_BASEURL + "/Image/history";
  static const String REST_URL_SHOPCALC = REST_BASEURL +"/ShopCalc";
  static const String REST_URL_SHOPCALC_CONFIRM = REST_BASEURL +"/ShopCalc/confirm";
  static const String REST_URL_SHOPSECTOR = REST_BASEURL +"/ShopSector";
  static const String REST_URL_SHOPSECTORHIST = REST_BASEURL +"/ShopSector/history";
  static const String REST_URL_SHOPUPDATESORT = REST_BASEURL +"/Menu/updateSort";
  static const String REST_URL_SHOPBANKCONFIRM = REST_BASEURL +"/Shop/setBankConfirm";
  static const String REST_URL_SHOPCHARGEJOIN = REST_BASEURL +"/Shop/ChargeJoin";
  static const String REST_URL_SHOPMEMOHISTORY = REST_BASEURL +"/ShopBasic/getMemoHist";

  static const String REST_URL_SHOPPOSTFILES = REST_BASEURL +"/Shop/PostFiles";
  static const String REST_URL_SHOPDELETEFILES = REST_BASEURL +"/Shop/DeleteFile";

  static const String REST_URL_SHOPMENUGROUP = REST_BASEURL +"/MenuGroup";

  static const String REST_URL_SHOPMENULIST = REST_BASEURL +"/Menu/menuList";
  static const String REST_URL_SHOPMENUDETAIL = REST_BASEURL +"/Menu";
  static const String REST_URL_SHOPMENUCOPY = REST_BASEURL +"/Menu/copyMenu";
  static const String REST_URL_SHOPMENUNAMELIST = REST_BASEURL +"/Menu/menuNameList";
  static const String REST_URL_SHOPSHOPNAMELIST = REST_BASEURL +"/Menu/shopNameList";
  static const String REST_URL_SHOPREMOVEMENUOPTION = REST_BASEURL +"/Menu/removeMenuOption";
  static const String REST_URL_SHOPCOPYMENUOPTION = REST_BASEURL +"/Menu/copyMenuOption";
  static const String REST_URL_SHOPMENUCOMPLETE = REST_BASEURL + "/Menu/setMenuComplete";

  static const String REST_URL_SHOPOPTIONGROUP = REST_BASEURL +"/OptionGroup";

  static const String REST_URL_SHOPCOPYOPTIONGROUP = REST_BASEURL +"/OptionGroup/copyOptionGroup";
  static const String REST_URL_OPTIONHISTORY = REST_BASEURL +"/Option/history";

  static const String REST_URL_SHOPMENUOPTIONGROUP = REST_BASEURL +"/MenuOptionGroup";

  static const String REST_URL_SHOPOPTIONLIST = REST_BASEURL +"/Option/optionList";
  static const String REST_URL_SHOPOPTIONDETAIL = REST_BASEURL +"/Option";

  static const String REST_URL_BANK_CODE = REST_BASEURL +"/BankCode";

  static const String REST_URL_DIV_CODE = REST_BASEURL +"/ShopDiv";

  static const String REST_URL_SIDO_CODE = REST_BASEURL +"/Address/sido";
  static const String REST_URL_GUNGU_CODE = REST_BASEURL +"/Address/gungu";
  static const String REST_URL_DONG_CODE = REST_BASEURL +"/Address/dong";
  static const String REST_URL_RI_CODE = REST_BASEURL +"/Address/ri";

  static const String REST_URL_SALETIME = REST_BASEURL +"/DeliTip/getSaleTime";
  static const String REST_URL_SET_SALETIME = REST_BASEURL +"/DeliTip/setSaleTime";
  static const String REST_URL_SET_DAYTIME = REST_BASEURL +"/DeliTip/setDayTime";

  static const String REST_URL_DELITIP = REST_BASEURL +"/DeliTip";
  static const String REST_URL_DELITIPHISTORY = REST_BASEURL +"/DeliTip/history";

  //static const String REST_URL_DELITIPSETRESERVE = REST_BASEURL +"/DeliTip/setReserve";

  static const String REST_URL_EXCELEXPORT = REST_BASEURL +"/Shop/ExcelExport";

  static const String REST_URL_SHOPORDERCANCELLIST = REST_BASEURL +"/Shop/getOrderCancelShopList";

  static const String REST_URL_SHOPEVENTLIST = REST_BASEURL +"/ShopInfo/getShopEventList";
  static const String REST_URL_SHOPEVENTHIST = REST_BASEURL +"/ShopInfo/getShopEventHist";
  static const String REST_URL_SHOPEVENTMENU = REST_BASEURL +"/ShopInfo/getShopEventDiscMenu";
  static const String REST_URL_SHOPEVENTYN = REST_BASEURL + "/ShopInfo/getEventYn";

  //static const String REST_URL_TAXREGCHECK = REST_BASEURL + "/Tax";
  static const String REST_URL_DBREGCHECK = REST_BASEURL + "/Shop/RegNoCheck";

  static const String REST_URL_MOVEREVIEW = REST_BASEURL + "/ShopReview/moveReview";

  static const String REST_URL_CONTRACTEND = REST_BASEURL + "/Shop/setContractEnd";

  static const String REST_URL_SHOPREVIEW = REST_BASEURL + "/ShopReview";
  static const String REST_URL_REPORTLIST = REST_BASEURL + "/ShopReview/getReportList";
  static const String REST_URL_SETVISIBLE = REST_BASEURL + "/ShopReview/setVisible";
  static const String REST_URL_SHOPREIVEWHIST = REST_BASEURL + "/ShopReview/history";

  //static const String REST_URL_RESER_LIST = "https://reser.daeguro.co.kr:10008/reser-list";

  ///////////// 주문조회
  static const String REST_URL_ORDER = REST_BASEURL +"/Order";
  static const String REST_URL_ORDERLIST = REST_BASEURL +"/Order/getOrderList";
  static const String REST_URL_ORDER_SETCARDAPPROVALGBN = REST_BASEURL +"/Order/setCardApprovalGbn";
  static const String REST_URL_ORDER_CANCELREASONS = REST_BASEURL +"/Order/getCancelReasons";
  static const String REST_URL_ORDER_COMPLETETOCANCEL = REST_BASEURL +"/Order/getCompleteToCancelOrderList";
  static const String REST_URL_ORDER_GETCARDAPPROVALGBN = REST_BASEURL +"/Order/getCardApprovalGbn";

  ///////////// 쿠폰관리
  static const String REST_URL_COUPON = REST_BASEURL +"/Coupon";
  static const String REST_URL_COUPON_CODE = REST_BASEURL +"/Coupon/couponCode";
  static const String REST_URL_COUPON_HISTORY = REST_BASEURL +"/Coupon/getCouponHistory";
  static const String REST_URL_SETCOUPONAPPCUSTOMER= REST_BASEURL +"/Coupon/setCouponAppCustomer";

  static const String REST_URL_B2BCOUPON = REST_BASEURL +"/B2BCoupon";
  static const String REST_URL_B2BCOUPON_CODE = REST_BASEURL +"/B2BCoupon/couponCode";
  static const String REST_URL_B2BCOUPON_ITEMCODE = REST_BASEURL +"/B2BCoupon/getCouponItemCode";
  static const String REST_URL_B2BCOUPON_CHANGE = REST_BASEURL +"/B2BCoupon/history";
  static const String REST_URL_B2BCOUPON_HISTORY = REST_BASEURL +"/B2BCoupon/getCouponHistory";
  static const String REST_URL_B2BSETCOUPONAPPCUSTOMER= REST_BASEURL +"/B2BCoupon/setCouponAppCustomer";

  static const String REST_URL_B2BUSERCOUPON = REST_BASEURL +"/B2BUser";
  static const String REST_URL_B2BUSERCOUPONSET = REST_BASEURL +"/B2BUser/setB2BUser";
  static const String REST_URL_B2BUSERCOUPONDETAIL = REST_BASEURL +"/B2BUser/getDetail";
  static const String REST_URL_B2BUSERCOUPON_CHANGE = REST_BASEURL +"/B2BUser/history";

  static const String REST_URL_BRANDCOUPON = REST_BASEURL +"/ChainCoupon";
  static const String REST_URL_BRANDCOUPON_CHANGE = REST_BASEURL +"/ChainCoupon/history";
  static const String REST_URL_BRANDSETCOUPONAPPCUSTOMER= REST_BASEURL +"/ChainCoupon/setCouponAppCustomer";
  static const String REST_URL_BRANDCOUPON_HISTORY = REST_BASEURL +"/ChainCoupon/getCouponHistory";
  static const String REST_URL_GETBRANDLIST= REST_BASEURL +"/ChainCoupon/getChainList";
  static const String REST_URL_GETBRANDCOUPONLIST = REST_BASEURL +"/ChainCoupon/getChainCouponList";
  static const String REST_URL_GETBRANDCOUPONSHOP = REST_BASEURL +"/ChainCouponShop";
  static const String REST_URL_GETBRANDCOUPONAPP = REST_BASEURL +"/ChainCouponApp";

  ///////////// 내역
  static const String REST_URL_MILEAGEHISTORY = REST_BASEURL +"/Mileage/getMileageHistory";
  static const String REST_URL_MILEAGEINOUT = REST_BASEURL +"/Mileage/getMileageInOut";
  static const String REST_URL_MILEAGESALEINOUT = REST_BASEURL +"/Mileage/getSaleMileageInOut";

  ///////////// 공지사항&이벤트
  static const String REST_URL_NOTICE = REST_BASEURL +"/Notice";
  static const String REST_URL_NOTICE_SORT = REST_BASEURL +"/Notice/updateSort";
  static const String REST_URL_NOTICEFILE = REST_BASEURL +"/Notice/setNoticeFile";

  ///////////// 회원관리
  static const String REST_URL_CUSTOMER = REST_BASEURL +"/Customer";
  static const String REST_URL_CUSTOMERINFO = REST_BASEURL +"/Customer/joinInfo";
  static const String REST_URL_CUSTOMERMILEAGE = REST_BASEURL +"/Customer/mileage";
  static const String REST_URL_CUSTOMERCOUPON = REST_BASEURL +"/Customer/coupon";
  static const String REST_URL_CUSTOMERRETIRE = REST_BASEURL +"/Customer/retire";

  ///////////// 사용자관리
  static const String REST_URL_USER = REST_BASEURL  + "/User";
  static const String REST_URL_USER_LOGIN = REST_BASEURL  + "/User/logIn";
  static const String REST_URL_USER_OTPCONFIRM = REST_BASEURL  + "/User/otpConfirm";
  static const String REST_URL_USER_CHECK = REST_BASEURL  + "/User/idCheck";
  static const String REST_URL_USER_CODE_NAME = REST_BASEURL  + "/User/user_code_name";
  static const String REST_URL_USER_ADDLOGINLOG = REST_BASEURL  + "/User/addLoginLog";

  ///////////// 이미지관리
  static const String REST_URL_IMAGE = REST_BASEURL +"/Image";
  static const String REST_URL_IMAGETHUMB = REST_BASEURL +"/Image/thumb";
  static const String REST_URL_MENUIMAGE_REMOVE = REST_BASEURL +"/Image/removeMenuImage";



  ///////////// 사장님사이트 연동
  static const String OWNERSITE_URL = "https://ceo.daeguro.co.kr/login";

  ///////////// 네이버
  static const String REST_URL_NAVER = REST_BASEURL  + "/Naver";

  ///////////// API
  static const String REST_URL_API = REST_BASEURL + "/ApiCompany";

  ///////////// MAPPING
  static const String REST_URL_MAPPING = REST_BASEURL  + "/Mapping";
  static const String REST_URL_MAPPING_CHECK = REST_BASEURL + "/Mapping/checkApiMap";

  ///////////// 로지올 리뷰API(사장님사이트측 API호출(Shop))
  //local Test URL : http://172.16.10.74:12500
  //Test Server URL : http://dgpub.282.co.kr:10002
  //Real Server URL : https://ceo.daeguro.co.kr

  static const String REVIEW_API_TOKEN = "https://ceo.daeguro.co.kr/api/ReviewRest/token";
  static const String REVIEW_API_SHOPCONFIRM = "https://ceo.daeguro.co.kr/api/ReviewRest/Register";
  static const String REVIEW_API_SHOPINFO = "https://ceo.daeguro.co.kr/api/ReviewRest/ShopInfo";

  // 내부망
  //static const String REST_URL_BANKACCOUNT = "http://192.168.30.98:10002/api/AdmAcc/confrim_v2";
  //외부망
  static const String REST_URL_BANKACCOUNT = "https://ceo-adminapi.daeguro.co.kr:45023/api/AdmAcc/confirm_v2";
  //static const String REST_URL_BANKACCOUNT = "https://dgpub.282.co.kr:10002/api/AdmAcc/confirm_v2";

  // 카드결재 취소 api
  static const String PAY_BASIC_CANCEL = "https://pay.daeguro.co.kr/api/basic/cancel/"; // 비회원
  static const String PAY_SMART_CANCEL = "https://pay.daeguro.co.kr/api/smart/cancel/"; // 앱회원
  static const String PAY_API_CANCEL = "https://pay.daeguro.co.kr/api/cancel/"; // 네이버페이

  ///////////// 통계
  static const String REST_URL_STAT_SHOPTOTALORDER = REST_BASEURL + "/Total/getTotalOrderInfo";

  static const String REST_URL_STAT_SHOPTYPE = REST_BASEURL + "/Total/getShopItem";
  static const String REST_URL_STAT_SHOPTYPE_GUNGU = REST_BASEURL + "/Total/getShopItemGungu";

  static const String REST_URL_STAT_SHOPSALES = REST_BASEURL + "/Total/getShopSalesman";
  static const String REST_URL_STAT_SHOPSALES_DETAIL = REST_BASEURL + "/Total/getShopSalesmanGungu";
  static const String REST_URL_STAT_SHOPGUNGU = REST_BASEURL + "/Total/getGunguShopV2";
  static const String REST_URL_STAT_SHOPCATEGORY = REST_BASEURL + "/Total/getItemShopV2";

  static const String REST_URL_STAT_CUSTOMERDAILY = REST_BASEURL + "/Total/getDailyMemberCountV2";
  static const String REST_URL_STAT_NONCUSTOMERDAILY = REST_BASEURL + "/Total/getDailyNonMemberCount";
  static const String REST_URL_STAT_CUSTOMERORDER = REST_BASEURL + "/Total/getMemberOrderInfo";
  static const String REST_URL_STAT_CUSTOMERRANKORDER = REST_BASEURL + "/Total/getMemberRank";

  static const String REST_URL_STAT_ORDERCATEGORY = REST_BASEURL + "/Total/getCategoryOrderCount";
  static const String REST_URL_STAT_ORDERTIME = REST_BASEURL + "/Total/getTimeOrderCount";
  static const String REST_URL_STAT_ORDERPAY = REST_BASEURL + "/Total/getPayOrderCountV2";
  static const String REST_URL_STAT_ORDERGUNGU = REST_BASEURL + "/Total/getGunguOrderV2";
  static const String REST_URL_STAT_DAILYORDER_COMPLETEDCANCELED = REST_BASEURL + "/Excel/getDailyOrderCompletedCanceled";
  static const String REST_URL_STAT_DAILYORDER_CANCELREASON = REST_BASEURL + "/Excel/getDailyOrderCancelReason";
  static const String REST_URL_STAT_DAILYORDER_PAYGBN = REST_BASEURL + "/Excel/getDailyOrderPyaGbn";
  static const String REST_URL_STAT_DAILYAGE_TO_ORDER = REST_BASEURL + "/Total/getDailyAgeToOrder";
  static const String REST_URL_STAT_SHOPEVENTCOUNT = REST_BASEURL + "/Total/getDailyEventCount";

  static const String REST_URL_STAT_DRGCOUPON = REST_BASEURL + "/Total/getDGRCoupon";
  static const String REST_URL_STAT_DAILYDRGCOUPON = REST_BASEURL + "/Total/getDailyDGRCoupon";

  static const String REST_URL_STAT_MILEAGEINOUTMONTH = REST_BASEURL + "/Mileage/getMileageInOutMonth";
  static const String REST_URL_STAT_MILEAGEINOUTDAY = REST_BASEURL + "/Mileage/getMileageInOutDay";

  static const String REST_URL_STAT_MILEAGESALEINOUTMONTH = REST_BASEURL + "/Mileage/getSaleMileageInOutMonth";
  static const String REST_URL_STAT_MILEAGESALEINOUTDAY = REST_BASEURL + "/Mileage/getSaleMileageInOutDay";

  ///////////// REST ERROR
  static const String REST_URL_LOG_ERROR = REST_BASEURL +"/RestError";
  static const String REST_URL_LOG_PRIVACY = REST_BASEURL +"/PrivacyLog";
  static const String REST_URL_COUPONHIST = REST_BASEURL +"/Coupon/getCouponHist";
  static const String REST_URL_ROLEHIST = REST_BASEURL +"/AdminRole/getRoleHist"; // 03.14 - kjr 권한변경이력관리 추가

  ///////////// 코드관리
  static const String REST_URL_CODE = REST_BASEURL + "/Code";
  static const String REST_URL_CODE_GETFOODSAFETY = REST_BASEURL + "/Code/getFoodSafety";
  static const String REST_URL_CODE_PUTFOODSAFETY = REST_BASEURL + "/Code/putFoodSafety";
  //static const String REST_URL_RESTCOUPONCODE = REST_BASEURL + "/CouponManage";

  ///////////// 정산관리
  static const String REST_URL_CALCULATE_SHOPMILEAGE = REST_BASEURL + "/Calculate/getShopCalculateList";
  static const String REST_URL_CALCULATE_SHOPMILEAGESUM = REST_BASEURL + "/Calculate/getShopCalculateSum";
  static const String REST_URL_CALCULATE_CCMILEAGE = REST_BASEURL + "/Calculate/getCcCalculateList";
  static const String REST_URL_CALCULATE_CCMILEAGESUM = REST_BASEURL + "/Calculate/getCcCalculateSum";
  static const String REST_URL_CALCULATE_COMMISSION = REST_BASEURL + "/Calculate/getPgmCalculateList";
  static const String REST_URL_CALCULATE_GETORDERCALCULATELIST = REST_BASEURL + "/Calculate/getOrderCalculateList";
  static const String REST_URL_CALCULATE_GETORDERCALCULATESUM = REST_BASEURL + "/Calculate/getOrderCalculateSum";
  static const String REST_URL_CALCULATE_INSERTSHOPCHARGE = REST_BASEURL + "/Calculate/insertShopCharge";
  static const String REST_URL_CALCULATE_UNGENERATEDTAX = REST_BASEURL + "/Calculate/ungeneratedTax";
  static const String REST_URL_CALCULATE_UNPUBLISHEDTAX = REST_BASEURL + "/Calculate/unpublishedTax";
  static const String REST_URL_CALCULATE_INSERTTAXMAST = REST_BASEURL + "/Calculate/insertTaxMast";
  static const String REST_URL_CALCULATE_TAXBILL = REST_BASEURL + "/Calculate/TaxBill";
  static const String REST_URL_CALCULATE_SEARCHSHOPTAX = REST_BASEURL + "/Calculate/searchShopTax";
  static const String REST_URL_CALCULATE_GETCOUNT = REST_BASEURL + "/Calculate/getCount";

  static const String REST_URL_CALCULATE_TAXLOG = REST_BASEURL + "/Calculate/getTaxLog";

  ///////////// 요청관리
  static const String REST_URL_REQUESTLIST = REST_BASEURL + "/ServiceRequest";
  static const String REST_URL_SERVICEGBN = REST_BASEURL + "/ServiceRequest/getServiceGbn";
  static const String REST_URL_SERVICESTATUS = REST_BASEURL + "/ServiceRequest/setStatus";
  static const String REST_URL_SERVICEREQUEST = REST_BASEURL + "/ServiceRequest/setDetail";

  ///////////// Tax(국세청)
  static const String REST_URL_TAX = REST_BASEURL +"/Tax";

  ///////////// 권한관리
  static const String REST_URL_AUTH_ADMINMENU = REST_BASEURL +"/AdminMenu";
  static const String REST_URL_AUTH_ADMINMENU_CHILD = REST_BASEURL +"/AdminMenu/getList";
  static const String REST_URL_AUTH_ADMINMENU_SORT = REST_BASEURL +"/AdminMenu/updateSort";
  static const String REST_URL_AUTH_ADMINROLE = REST_BASEURL +"/AdminRole";
  static const String REST_URL_AUTH_ADMINROLE_SIDEBAR = REST_BASEURL +"/AdminRole/getSidebar";
  static const String REST_URL_AUTH_ADMINROLE_ALL = REST_BASEURL +"/AdminRole/setAll";

  ///////////// 상품권관리
  static const String REST_URL_VOUCHER = REST_BASEURL +"/Voucher";
  static const String REST_URL_VOUCHER_GETVOUCHERLIST = REST_BASEURL +"/Voucher/getVoucherList";
}
