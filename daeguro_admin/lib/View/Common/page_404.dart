import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:flutter/material.dart';

class Page404 extends StatelessWidget {
  const Page404({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('페이지가 존재하지 않습니다.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
            SizedBox(height: 20,),
            ISButton(
              iconData: Icons.arrow_back,
              label: '돌아가기',
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
