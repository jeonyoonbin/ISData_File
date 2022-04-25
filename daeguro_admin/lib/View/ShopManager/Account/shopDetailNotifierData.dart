
class ShopDetailNotifierData{
  ShopDetailNotifierData();

  String selected_shopCode = '';
  String selected_mCode = '';
  String selected_ccCode = '';
  String selected_apiComCode = '';
  String selected_shopStatus = '';

  String selected_calcYn  = 'Y';       //정산정보
  String selected_shopInfoYn = 'Y';    //매장정보
  String selected_deliYn = 'Y';        //배송지관리
  String selected_tipYn = 'Y';         //배달팁정보
  String selected_saleYn = 'Y';        //운영정보
  String selected_reserveYn = 'Y';        //예약정보
  //String selected_franchiseCd = '';    //운영정보

  // String toString()  {
  //   return 'selected_shopCode:${selected_shopCode}, selected_mCode:${selected_mCode}, selected_ccCode:${selected_ccCode}, selected_apiComCode:${selected_apiComCode}, selected_imageStatus:${selected_imageStatus}';
  // }
}