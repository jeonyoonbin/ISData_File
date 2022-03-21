
class StatMileageInOutMonthModel {
  bool isOpened = false;
  bool isChild = false;
  String MDATE;
  int COUNT;
  int SUM_CUST_MILEAGE;
  int SUM_LOG_CUST_MILEAGE;
  int SUM_IN_CNT;
  int SUM_IN_AMT;
  int SUM_ORDER_IN_CNT;
  int SUM_ORDER_IN_AMT;
  int SUM_SALE_IN_CNT;
  int SUM_SALE_IN_AMT;
  int SUM_ORDER_OUT_AMT;
  int SUM_SALE_OUT_AMT;
  int SUM_OUT_AMT;
  int SUM_TERMINATE_AMT;

  StatMileageInOutMonthModel({
    this.isOpened,
    this.isChild,
    this.MDATE,
    this.COUNT,
    this.SUM_CUST_MILEAGE,
    this.SUM_LOG_CUST_MILEAGE,
    this.SUM_IN_CNT,
    this.SUM_IN_AMT,
    this.SUM_ORDER_IN_CNT,
    this.SUM_ORDER_IN_AMT,
    this.SUM_SALE_IN_CNT,
    this.SUM_SALE_IN_AMT,
    this.SUM_ORDER_OUT_AMT,
    this.SUM_SALE_OUT_AMT,
    this.SUM_OUT_AMT,
    this.SUM_TERMINATE_AMT,
  });
}