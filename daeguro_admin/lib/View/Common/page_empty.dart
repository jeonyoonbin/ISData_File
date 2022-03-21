import 'package:flutter/material.dart';

class PageEmpty extends StatelessWidget {
  const PageEmpty({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/animat-responsive-color.gif', width: 160, height: 120,),
          Text('열심히 준비중 입니다..T . T', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
}
