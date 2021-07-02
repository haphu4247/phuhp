import 'package:flutter/material.dart';

class BottomBarItem extends StatefulWidget {
  BottomBarModel data;
  VoidCallback onTap;

  BottomBarItem({required this.data, required this.onTap});

  @override
  _BottomBarItemState createState() => _BottomBarItemState();
}

class _BottomBarItemState extends State<BottomBarItem> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: TextButton(
          child: Text(widget.data.title, style: TextStyle(color: Colors.white, fontStyle: FontStyle.normal, fontSize: 18),),
          onPressed: widget.onTap,
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(widget.data.isSelected ? Colors.lightBlueAccent : Colors.blue)),
        )
    );
  }
}

class BottomBarModel {
  String title;
  String url;
  bool isSelected = false;

  BottomBarModel({required this.title, required this.url});
}
