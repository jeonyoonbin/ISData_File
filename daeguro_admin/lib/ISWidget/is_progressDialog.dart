import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ISProgressDialog{
  final BuildContext context;
  ISProgressDialog(this.context);

  // void showLoadingIndicator({String title, String body}){
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context){
  //         return WillPopScope(
  //             child: AlertDialog(
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.all(Radius.circular(8.0))
  //               ),
  //               backgroundColor: Colors.white,
  //               content: LoadingIndicator(title: title, body: body,),
  //             ),
  //         );
  //       }
  //   );
  // }

  void show({String status}){
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black38,
        builder: (context) => Center(
          child: Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(75, 135, 185, 1),//Colors.blue.shade700, //Colors.black87,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(color: Colors.black26, offset: Offset(2.0, 2.0), blurRadius: 4.0),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.white,),
                SizedBox(width: 30,),
                Text(status, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
                SizedBox(width: 20,),
              ],
            ),
          ),
        ),
    );
  }

  void dismiss(){
    Navigator.of(context).pop();
  }
}

class LoadingIndicator extends StatelessWidget{
  final String title;
  final String body;
  LoadingIndicator({this.title = '', this.body = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Container(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(strokeWidth: 3,),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Text(title, style: TextStyle(color: Colors.black, fontSize: 16),),
          ),
          Text(body, style: TextStyle(color: Colors.black, fontSize: 14), textAlign: TextAlign.center,)
        ],
      ),
    );
  }
}