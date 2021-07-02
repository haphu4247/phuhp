import 'package:flutter/material.dart';
import 'package:general_news/models/args.dart';
import 'package:general_news/models/news_item.dart';
import 'package:general_news/resources/colors.dart';
import '../webview/my_webview.dart';

class Body extends StatefulWidget {
  final List<NewsItem> news;

  Body({required this.news});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();
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
                  return _buildItem(context, widget.news[index]);
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
                child: Text(
                  'Sorry! Service Unavailable.',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
              ));
  }

  Widget _buildItem(BuildContext context, NewsItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, MyWebView.routeName,
            arguments: Args(link: item.link));
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
            Align(
              child: Text(
                item.getLocalizedDate(),
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.black26,
                    fontSize: 14),
              ),
              alignment: AlignmentDirectional.centerEnd,
            ),
            item.getImage(context),
            item.getDescription(),
          ])),
    );
  }
}
