import 'package:flutter/material.dart';
import 'package:general_news/mainSetting.dart';
import 'package:general_news/models/args.dart';
import 'package:general_news/models/news_item.dart';
import 'package:general_news/repository/db/my_db.dart';
import 'package:general_news/resources/colors.dart';
import 'package:general_news/resources/string.dart';
import 'package:general_news/screens/main_news/components/item_in_listview.dart';
import 'package:general_news/screens/setting/saved/saved_controller.dart';
import 'package:general_news/screens/webview/my_webview.dart';
import 'package:get/get.dart';

class SavedScreen extends GetView<SavedController> {
  List<Widget> popupItems = [];

  void _setupPopupItems() {
    popupItems.add(Row(
      children: [
        Icon(Icons.delete, color: Colors.blue),
        SizedBox(
          width: 5,
        ),
        Text(kRemove, style: TextStyle(color: Colors.blue, fontSize: 14)),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    _setupPopupItems();
    return Scaffold(
      body: _buildBody(context),
      appBar: AppBar(
        title: Text(kHistory,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700)),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_outlined),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder(
      future: _fetchData(),
      builder: (BuildContext context, AsyncSnapshot<List<NewsItem>> snapshot) {
        print('snapshot: ${snapshot.toString()}');
        if (snapshot.hasData) {
          return _buildListNews(snapshot.data!);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<List<NewsItem>> _fetchData() async {
    var db = MyDB();
    var openDB = await db.open();
    print('openDb: ${openDB.isOpen}');
    return db.fetchNews(openDB, true);
  }

  Widget _buildListNews(List<NewsItem> news) {
    return Container(
        decoration: BoxDecoration(color: backgroundGray),
        child: news.length > 0
            ? ListView.separated(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                itemBuilder: (context, index) {
                  return buildItemInListView(context, popupItems, news[index], ActionForItemType.Saved, (){ });
                },
                itemCount: news.length,
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
                      'No Saved Post',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ));
  }

  Widget _buildItem(BuildContext context, NewsItem item) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, MyWebView.routeName, arguments: Args(link: item.link));
        Get.toNamed(myWebView, arguments: Args(link: item.link));
      },
      onDoubleTap: () {
        print('onDoubleTap');
      },
      child: Container(
          padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(children: [
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
          ])),
    );
  }
}
