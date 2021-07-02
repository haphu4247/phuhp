import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:general_news/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:webfeed/webfeed.dart';

class NewsItem {
  String title = "";
  String? imgUrl;
  DateTime date = DateTime.now();
  String description = "";
  String link = "";
  bool isHtml = false;

  NewsItem(
    this.title,
    this.description,
    this.imgUrl,
    this.date,
    this.link,
  );

  NewsItem.fromRssItem(RssItem rssItem){
    title= (rssItem.title ?? "").trim();

    date= rssItem.pubDate?.toLocal() ?? DateTime.now();
    link= (rssItem.link ?? "").trim();

    description= (rssItem.description ?? "").trim();
    isHtml = hasHTMLTags(description);
    if (!isHtml) {
      try {
        imgUrl= (rssItem.media?.thumbnails?.first.url)?.trim();
      } catch (e){
        print("No Image URL:${e.toString()}");
      }
    }
  }

  String getLocalizedDate(){
    return myDateFormat.format(date);
  }

  Widget getDescription() {
    if (isHtml){
      return Html(data: description);
    }else{
      return Text(description, style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 18,),);
    }
  }

  Widget getImage(BuildContext context) {
    return imgUrl == null ? Container() :Container(
        height: MediaQuery.of(context).size.width*3/4,
        width: MediaQuery.of(context).size.width,
        child: Image.network(imgUrl!, fit: BoxFit.fill,)
    );
  }

  @override
  String toString() {
    return "\ntitle:$title \n description:$description \n imgUrl:$imgUrl \n date:$date \n link:$link";
  }
}