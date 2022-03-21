import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LayoutController extends GetxController {
  static LayoutController get to => Get.find();

  String currentOpenedPageId;
  String currentPageURL;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  init() {
    currentOpenedPageId = null;
    currentPageURL = null;
  }

  updatePageURL(url, id) {
    currentOpenedPageId = id;
    currentPageURL = url;
    update();
  }

  void controlMenu() {
    if (!_scaffoldKey.currentState.isDrawerOpen) {
      _scaffoldKey.currentState.openDrawer();
    }
  }
}