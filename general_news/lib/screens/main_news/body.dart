import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:general_news/models/args.dart';
import 'package:general_news/models/news_item.dart';
import 'package:general_news/repository/db/my_db.dart';
import 'package:general_news/resources/colors.dart';
import 'package:general_news/resources/string.dart';
import 'package:general_news/screens/main_news/item_in_listview.dart';
import '../webview/my_webview.dart';

class Body extends StatefulWidget {
  final List<NewsItem> news;

  Body({required this.news});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Widget> popupItems = List<Widget>.empty();

  @override
  void initState() {
    _setupPopupItems();
    super.initState();
  }

  void _setupPopupItems() {
    popupItems.add(Row(
      children: [
        SizedBox(
          width: 5,
        ),
        Icon(Icons.save_alt_rounded, color: Colors.blue),
        SizedBox(
          width: 5,
        ),
        Text(kSave, style: TextStyle(color: Colors.blue, fontSize: 14)),
        SizedBox(
          width: 45,
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return buildBody();
  }

  Widget buildBody() {
    return Container(
        decoration: BoxDecoration(color: backgroundGray),
        child: widget.news.length > 0
            ? ListView.separated(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                itemBuilder: (context, index) {
                  return buildItemInListView(context, popupItems, widget.news[index], ActionForItemType.Home, null);
                },
                itemCount: widget.news.length,
                separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 10,
                    color: backgroundGray,
                  );
                },
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.face_retouching_natural,
                      size: 100,
                      color: Colors.blue,
                    ),
                    Text(
                      'Sorry! Service Unavailable.',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ));
  }
}
