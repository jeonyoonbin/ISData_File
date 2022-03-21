import 'package:daeguro_admin_app/constants/constant.dart';
import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const Responsive({Key key, this.mobile, this.tablet, this.desktop,}) : super(key: key);

  //default : 1100
  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 850;
  static bool isTablet(BuildContext context) => MediaQuery.of(context).size.width < 1366 && MediaQuery.of(context).size.width >= 850;
  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1366;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;

    if (_size.width >= 1366) {
      return desktop;
    }
    else if (_size.width >= 850 && tablet != null) {
      return tablet;
    }
    else {
      return mobile;
    }
  }

  static getResponsiveWidth(BuildContext context, int infiniteWidth){
    double addWidthMargin = defaultWidthPadding*2;
    return isTablet(context)
        ? MediaQuery.of(context).size.width-addWidthMargin
        : (isMobile(context) ? infiniteWidth : MediaQuery.of(context).size.width-(sidebarWidth+addWidthMargin));
  }
}
