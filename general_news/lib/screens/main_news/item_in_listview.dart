import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:general_news/models/args.dart';
import 'package:general_news/models/news_item.dart';
import 'package:general_news/repository/db/my_db.dart';
import 'package:general_news/screens/webview/my_webview.dart';

enum ActionForItemType {
  Home, Saved, History
}

Widget buildItemInListView(BuildContext context, List<Widget> popupItems, NewsItem item, ActionForItemType type, VoidCallback? onRemoved) {
  return GestureDetector(
    onTap: () {
      switch (type) {
        case ActionForItemType.Home:
          _insertDataToDB(item, false);
          Navigator.pushNamed(context, MyWebView.routeName,
              arguments: Args(link: item.link));
          break;
        case ActionForItemType.Saved:
          Navigator.pushNamed(context, MyWebView.routeName,
              arguments: Args(link: item.link));
          break;
        case ActionForItemType.History:
          Navigator.pushNamed(context, MyWebView.routeName,
              arguments: Args(link: item.link));
          break;
      }

    },
    onDoubleTap: () {
      print('onDoubleTap');
    },
    child: Container(
        padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Column(children: [
              Text(
                item.title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 25),
              ),
              Container(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Align(
                  child: Text(
                    item.getLocalizedDate(),
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.black26,
                        fontSize: 14),
                  ),
                  alignment: AlignmentDirectional.centerEnd,
                ),
              ),
              item.getImage(context),
              Container(
                padding: EdgeInsets.only(top: 5),
                decoration: BoxDecoration(),
                child: item.getDescription(),
              ),
            ]),
            Positioned(
              top: 5,
              right: -8,
              child: PopupMenuButton(
                itemBuilder: (context) {
                  return popupItems.map((e) {
                    return PopupMenuItem(
                        child: IconButton(onPressed: (){
                          switch (type) {
                            case ActionForItemType.Home:
                              _insertDataToDB(item, true);
                              break;
                            case ActionForItemType.Saved:
                              onRemoved!();
                              break;
                            case ActionForItemType.History:
                              break;
                          }
                        }, icon: e));
                  }).toList();
                },
                child: SvgPicture.asset(
                  'lib/assets/more.svg',
                  width: 22,
                  height: 22,
                ),
              ),
            )
          ],
        )),
  );
}

_insertDataToDB(NewsItem item, bool isSaveTable) async {
  var db = MyDB();
  var database = await db.open();
  int valueInserted = await db.insert(database, item, isSaveTable);
  print('valueInserted:$valueInserted');
}