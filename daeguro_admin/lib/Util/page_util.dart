import 'package:daeguro_admin_app/Model/page_model.dart';
import 'package:daeguro_admin_app/View/Layout/layout_controller.dart';
import 'package:get/get.dart';


class PageUtil {

  static setPage(PageModel page){
    LayoutController layoutController = Get.find();
    layoutController.updatePageURL(page.url, page.id);
  }
}