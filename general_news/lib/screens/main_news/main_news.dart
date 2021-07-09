import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:general_news/models/all_news_enums.dart';
import 'package:general_news/models/news_item.dart';
import 'package:general_news/models/news_json.dart';
import 'package:general_news/repository/service/news_feed_service.dart';
import 'package:general_news/resources/string.dart';
import 'dart:convert';
import 'package:general_news/screens/main_news/body.dart';
import 'package:general_news/screens/main_news/bottombar_item.dart';
import 'package:general_news/screens/setting/history.dart';
import 'package:general_news/screens/setting/me.dart';
import 'package:general_news/screens/setting/saved.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:general_news/extension/context.dart';
import 'package:package_info/package_info.dart';

class MainNews extends StatefulWidget {
  static String routeName = "/MainNews";

  @override
  _MainNewsState createState() => _MainNewsState();
}

class _MainNewsState extends State<MainNews> {
  List<NewsItem> news = [];
  String appbarTitle = "General News";

  Map<String, String> currentJsonNews = Map<String, String>();

  bool fetchFirstNew = true;

  List<NewsJson>? newsData;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (newsData == null) {
      newsData = ModalRoute.of(context)!.settings.arguments as List<NewsJson>;
      currentJsonNews = newsData!.first.data;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(appbarTitle,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700)),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      drawer: _drawer(context),
      endDrawer: _endDrawer(context),
      body: LoaderOverlay(
        child: Body(news: news),
      ),
      bottomNavigationBar: _bottomBar(context),
    );
  }

  Widget _drawer(BuildContext context) {
    List<Widget> view = [];
    var header = DrawerHeader(
        decoration: BoxDecoration(color: Colors.blue),
        child: Align(
          child: Text(
            "All News",
            style: TextStyle(
                color: Colors.white, fontStyle: FontStyle.normal, fontSize: 30),
            textAlign: TextAlign.center,
          ),
          alignment: Alignment.center,
        ));
    view.add(header);

    newsData?.forEach((element) {
      var item = ListTile(
        contentPadding: EdgeInsets.only(left: 15, bottom: 5, right: 5, top: 5),
        title: Text(element.name),
        onTap: () {
          Navigator.pop(context);
          _fetchSelectedPost(element, context);
        },
      );
      view.add(item);
    });

    return Drawer(
      elevation: 12,
      child: ListView(
        children: view,
      ),
    );
  }

  Widget _endDrawer(BuildContext context) {
    List<Widget> view = [];

    Widget home = Container(
      height: 56,
      child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Row(
            children: [
              SizedBox(
                width: 5,
              ),
              Icon(Icons.home_filled, color: Colors.blue,),
              SizedBox(
                width: 5,
              ),
              Text(kHome, style: TextStyle(color: Colors.blue, fontSize: 14))
            ],
          )),
    );

    Widget aboutApp = Container(
      height: 56,
      child: IconButton(
          onPressed: () async {
            var appInfor = await PackageInfo.fromPlatform();
            var dialog = Dialog(
              child: MeScreen(
                version: appInfor.version,
                buildNumber: appInfor.buildNumber,
              ),
            );
            showDialog(
                context: context,
                builder: (_) => dialog,
                barrierDismissible: true);
          },
          icon: Row(
            children: [
              SizedBox(
                width: 5,
              ),
              Icon(Icons.tag_faces, color: Colors.blue),
              SizedBox(
                width: 5,
              ),
              Text(kMe, style: TextStyle(color: Colors.blue, fontSize: 14))
            ],
          )),
    );

    Widget saved = Container(
      height: 56,
      child: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, SavedScreen.routeName);
          },
          icon: Row(
            children: [
              SizedBox(
                width: 5,
              ),
              Icon(Icons.save_alt_rounded, color: Colors.blue),
              SizedBox(
                width: 5,
              ),
              Text(kSave, style: TextStyle(color: Colors.blue, fontSize: 14))
            ],
          )),
    );

    Widget history = Container(
      height: 56,
      child: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, HistoryScreen.routeName);
          },
          icon: Row(
            children: [
              SizedBox(
                width: 5,
              ),
              Icon(Icons.history_rounded, color: Colors.blue),
              SizedBox(
                width: 5,
              ),
              Text(kHistory,
                  style: TextStyle(color: Colors.blue, fontSize: 14))
            ],
          )),
    );

    view.add(home);
    view.add(aboutApp);
    view.add(saved);
    view.add(history);
    return Drawer(
      elevation: 12,
      child: ListView(
        children: view,
      ),
    );
  }

  _fetchSelectedPost(NewsJson news, BuildContext buildContext) {
    // buildContext.showCirclarProgress();
    buildContext.loaderOverlay.show();
    Map<String, String> json = news.data;

    fetchFirstNew = true;
    setState(() {
      currentJsonNews = json;
    });

    // buildContext.hideCirclarProgress(buildContext);
    buildContext.loaderOverlay.hide();
  }

  _fetchNews(String title, String url, BuildContext myContext) async {
    try {
      context.loaderOverlay.show();
    } on Exception catch (e) {} finally {
      // myContext.showCirclarProgress();
      print("title:$title url:$url");
      var data = NewsFeedService();
      var result = await data.fetchData(url);
      print("result: ${result.toString()}");

      setState(() {
        appbarTitle = title;
        news = result;
        context.loaderOverlay.hide();
        // myContext.hideCirclarProgress(myContext);
      });
    }
  }

  Widget _bottomBar(BuildContext context) {
    List<BottomBarItem> bottomItem = [];
    currentJsonNews.forEach((key, value) {
      var model = BottomBarModel(title: key, url: value);
      var view = BottomBarItem(
          data: model,
          onTap: () {
            model.isSelected = true;
            _fetchNews(model.title, model.url, context);
          });

      if (fetchFirstNew) {
        fetchFirstNew = false;
        _fetchNews(model.title, model.url, context);
      }

      bottomItem.add(view);
    });
    return Container(
      height: 56,
      decoration: BoxDecoration(color: Colors.blue),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(8),
        children: bottomItem,
      ),
    );
  }
}
