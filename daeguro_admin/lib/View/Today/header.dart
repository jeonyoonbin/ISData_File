import 'package:daeguro_admin_app/View/Layout/responsive.dart';
import 'package:daeguro_admin_app/View/Layout/layout_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';


import '../../constants/constant.dart';

class Header extends StatelessWidget {
  final String title;
  const Header({this.title, Key key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.yellow,
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (!Responsive.isDesktop(context))
                IconButton(icon: Icon(Icons.menu), onPressed: LayoutController.to.controlMenu,),

              Text(title, style: Theme.of(context).textTheme.headline6,),
            ],
          ),
          //Text('${GetStorage().read('logininfo')['name']} (접속시각: ${GetStorage().read('logininfoDateTime')})', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
          //ProfileCard(),
        ],
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: defaultAllPadding),
      padding: EdgeInsets.symmetric(horizontal: defaultAllPadding, vertical: defaultAllPadding / 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        // boxShadow: [
        //   BoxShadow(color: Colors.black26, offset: Offset(1.0, 1.0), blurRadius: 0.3),
        // ],
        color: Colors.white24,
      ),
      // decoration: BoxDecoration(
      //   color: Colors.white12,
      //   borderRadius: const BorderRadius.all(Radius.circular(10)),
      //   border: Border.all(color: Colors.black12),
      // ),
      child: Row(
        children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultAllPadding / 2),
              child: Text('${GetStorage().read('logininfo')['name']} (접속시각: ${GetStorage().read('logininfoDateTime')})', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
            )
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: secondaryColor,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {

          },
          child: Container(
            padding: EdgeInsets.all(defaultAllPadding * 0.75),
            margin: EdgeInsets.symmetric(horizontal: defaultAllPadding / 2),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            //child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
        ),
      ),
    );
  }
}
