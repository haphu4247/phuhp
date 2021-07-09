import 'package:flutter/material.dart';
import 'package:general_news/models/args.dart';
import 'package:general_news/models/news_item.dart';
import 'package:general_news/repository/db/my_db.dart';
import 'package:general_news/resources/colors.dart';
import 'package:general_news/resources/string.dart';
import 'package:general_news/screens/webview/my_webview.dart';

class SavedScreen extends StatefulWidget {
  static String routeName = "/SavedScreen";

  const SavedScreen({Key? key}) : super(key: key);

  @override
  _SavedScreenState createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  return _buildItem(context, news[index]);
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

  Widget _buildItem(BuildContext context, NewsItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, MyWebView.routeName,
            arguments: Args(link: item.link));
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