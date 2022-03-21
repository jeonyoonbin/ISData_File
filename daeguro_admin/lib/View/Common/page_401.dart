import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:flutter/material.dart';

class Page401 extends StatelessWidget {
  const Page401({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('이 메뉴에 대한 권한이 없습니다. 관리자로 로그인하여 계정 관리 기능을 구성하세요.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
          SizedBox(height: 20,),
          ISButton(
            iconData: Icons.check,
            label: '재로그인',
            onPressed: () {
              //Utils.logout();
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
