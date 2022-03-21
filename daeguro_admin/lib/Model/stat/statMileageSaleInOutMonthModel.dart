
class StatMileageSaleInOutMonthModel {
  bool isOpened = false;
  bool isChild = false;
  int MCODE;
  String MNAME;
  String MDATE;
  int LOG_CUST_MILEAGE;
  int IN_CNT;
  int IN_AMT;
  int ORDER_IN_CNT;
  int ORDER_IN_AMT;
  int SALE_IN_CNT;
  int SALE_IN_AMT;
  int ORDER_OUT_AMT;
  int SALE_OUT_AMT;
  int OUT_AMT;

  StatMileageSaleInOutMonthModel({
    this.isOpened,
    this.isChild,
    this.MCODE,
    this.MNAME,
    this.MDATE,
    this.LOG_CUST_MILEAGE,
    this.IN_CNT,
    this.IN_AMT,
    this.ORDER_IN_CNT,
    this.ORDER_IN_AMT,
    this.SALE_IN_CNT,
    this.SALE_IN_AMT,
    this.ORDER_OUT_AMT,
    this.SALE_OUT_AMT,
    this.OUT_AMT
  });
}