
class DrgCouponModel {
  bool isOpened = false;
  bool isChild = false;
  String MON;
  int COUPON_AMT;
  int INS_CNT;
  int USE_CNT;
  int DIS_USE_CNT;
  int EXP_CNT;
  int INS_AMT;
  int USE_AMT;
  int DIS_USE_AMT;
  int EXP_AMT;

  DrgCouponModel({
    this.isOpened,
    this.isChild,
    this.MON,
    this.COUPON_AMT,
    this.INS_CNT,
    this.USE_CNT,
    this.DIS_USE_CNT,
    this.EXP_CNT,
    this.INS_AMT,
    this.USE_AMT,
    this.DIS_USE_AMT,
    this.EXP_AMT
  });
}