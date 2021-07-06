import 'package:flutter/material.dart';

extension MyContext on BuildContext {
  showCirclarProgress() {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          Center(
            child: CircularProgressIndicator(backgroundColor: Colors.black12, color: Colors.blue,),
          ),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
        ],),
    );
    return showDialog(
        context: this,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return alert;
        });
  }

  hideCirclarProgress(BuildContext context) {
    Navigator.of(context).pop();
  }
}