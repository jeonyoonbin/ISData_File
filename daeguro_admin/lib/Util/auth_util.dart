
import 'package:daeguro_admin_app/Model/menu.dart';

class AuthUtil {
  static List<Menu> SideBarMenu = <Menu>[];
  static List MenuAuthItem = [];

  static bool isAuthReadEnabled(String id){
    bool temp = false;

    for (final element in MenuAuthItem){
      if (element['ID'].toString() == id && element['READ_YN'] == 'Y') {
        temp = true;
        break;
      }
    }

    return temp;
  }

  static bool isAuthCreateEnabled(String id){
    bool temp = false;

    for (final element in MenuAuthItem){
      if (element['ID'].toString() == id && element['CREATE_YN'] == 'Y') {
        temp = true;
        break;
      }
    }

    return temp;
  }

  static bool isAuthEditEnabled(String id){
    bool temp = false;

    for (final element in MenuAuthItem){
      if (element['ID'].toString() == id && element['UPDATE_YN'] == 'Y') {
        temp = true;
        break;
      }
    }

    return temp;
  }

  static bool isAuthDeleteEnabled(String id){
    bool temp = false;

    for (final element in MenuAuthItem){
      if (element['ID'].toString() == id && element['DELETE_YN'] == 'Y') {
        temp = true;
        break;
      }
    }

    return temp;
  }

  static bool isAuthDownloadEnabled(String id){
    bool temp = false;

    for (final element in MenuAuthItem){
      if (element['ID'].toString() == id && element['DOWNLOAD_YN'] == 'Y') {
        temp = true;
        break;
      }
    }

    return temp;
  }
}