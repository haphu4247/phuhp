import 'package:flutter/material.dart';
import 'package:general_news/models/all_news_enums.dart';
import 'package:general_news/models/news_item.dart';
import 'package:general_news/models/news_json.dart';
import 'package:general_news/repository/service/news_feed_service.dart';
import 'dart:convert';
import 'package:general_news/screens/main_news/body.dart';
import 'package:general_news/screens/main_news/bottombar_item.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:general_news/extension/context.dart';

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
      appBar: AppBar(title: Text(appbarTitle)),
      drawer: _drawer(context),
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
          child: Text("All News",
            style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.normal,
                fontSize: 30), textAlign: TextAlign.center,),
          alignment: Alignment.center,
        )
    );
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
