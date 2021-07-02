import 'package:flutter/material.dart';
import 'package:general_news/models/all_news_enums.dart';
import 'package:general_news/models/news_item.dart';
import 'package:general_news/repository/service/news_feed_service.dart';
import 'dart:convert';
import 'package:general_news/screens/main_news/body.dart';
import 'package:general_news/resources/string.dart';
import 'package:general_news/screens/main_news/bottombar_item.dart';
import 'package:loader_overlay/loader_overlay.dart';

class MainNews extends StatefulWidget {
  static String routeName = "/MainNews";
  @override
  _MainNewsState createState() => _MainNewsState();
}

class _MainNewsState extends State<MainNews> {

  List<NewsItem> news = [];
  String appbarTitle = "General News";

  bool fetchFirstItem = true;

  String currentJsonNews = AllNews.values.first.json;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(appbarTitle)),
      drawer: _drawer(context),
      body: LoaderOverlay(child: Body(news: news),),
      bottomNavigationBar: _bottomBar(context),
    );
  }

  Widget _drawer(BuildContext context){
    List<Widget> view = [];

    var header = DrawerHeader(
        decoration: BoxDecoration(
            color: Colors.blue
        ),
        child: Text("All News", style: TextStyle(color: Colors.white, fontStyle: FontStyle.normal, fontSize: 30))
    );
    view.add(header);

    AllNews.values.forEach((element) {
      var item = ListTile(title:Text(element.name), onTap: (){
        Navigator.pop(context);
        _fetchSelectedPost(element);
      },);
      view.add(item);
    });

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: view,
      ),
    );
  }

  _fetchSelectedPost(AllNews news){
    context.loaderOverlay.show();
    String json = news.json;
    if (currentJsonNews != json){
      setState((){
        fetchFirstItem = true;
        currentJsonNews = json;
      });
    }
    context.loaderOverlay.hide();
  }

  _fetchNews(String title, String url) async{
    try {
      context.loaderOverlay.show();
    } on Exception catch(e){
    } finally {
      print("title:$title url:$url");
      var data = NewsFeedService();
      var result = await data.fetchData(url);
      print("result: ${result.toString()}");
      setState(() {
        appbarTitle = title;
        news = result;
        context.loaderOverlay.hide();
      });
    }
  }
  
  Widget _bottomBar(BuildContext context){
    Map<String, String> items = Map<String, String>.from(jsonDecode(currentJsonNews));
    var keys = items.keys;
    print("keys:$keys");
    List<BottomBarItem> bottomItem = [];

    items.forEach((key,value) {
      var model = BottomBarModel(title: key, url: value);
      var view = BottomBarItem(data: model, onTap: (){
        model.isSelected = true;
        _fetchNews(model.title, model.url);
      });
      if (fetchFirstItem){
        fetchFirstItem = false;
        _fetchNews(model.title, model.url);
      }
      bottomItem.add(view);
    });
    print("keys:$keys");
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.blue
      ),
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: bottomItem,
      ),
    );
  }


}
