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
        builder: (context) => Center(
          child: Container(
            padding: EdgeInsets.only(top: 26.0, left: 26.0, right: 26.0),
            //width: 110.0 + addWidth,
            height: 110.0,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: CircularProgressIndicator(color: Colors.white,),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Text(status, style: TextStyle(color: Colors.white, fontSize: 14),),
                ),
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