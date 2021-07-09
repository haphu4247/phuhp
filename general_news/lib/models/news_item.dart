import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:general_news/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:webfeed/webfeed.dart';

final String tableSavedNewsItem = 'saved_news';
final String tableNewsItem = 'news';
final String columnTitle = 'title';
final String columnDescription = 'description';
final String columnDate = 'date';
final String columnLink = 'link';
final String columnImgUrl = 'imgUrl';
final String columnIsHtml= 'isHtml';
class NewsItem {
  final int maxBits = 128;

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

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnTitle: title,
      columnDescription: description,
      columnImgUrl: imgUrl,
      columnDate: date.millisecondsSinceEpoch,
      columnLink: link,
      columnIsHtml: isHtml ? 1 : 0
    };
    return map;
  }

  NewsItem.fromMap(Map<String, Object?> map) {
    title = map[columnTitle] as String;
    description = map[columnDescription] as String;
    imgUrl = map[columnImgUrl] as String?;
    date = DateTime.fromMillisecondsSinceEpoch((map[columnDate] as int));
    link = map[columnLink] as String;
    isHtml = (map[columnIsHtml] as int) == 0 ? false : true;
  }

  NewsItem.fromRssItem(RssItem rssItem){
    title= (rssItem.title ?? "").trim();
    date= rssItem.pubDate?.toLocal() ?? DateTime.now();
    link= (rssItem.link ?? "").trim();

    description= (rssItem.description ?? "").trim();

    try {
      List<int> codeUnits = title.codeUnits;
      if (codeUnits.length > 0) {
        title = utf8.decode(codeUnits);
      }
      List<int> codeUnitsDescription = description.codeUnits;
      if (codeUnitsDescription.length > 0) {
        description = utf8.decode(codeUnitsDescription);
      }
    } catch (e) {
      print('title: ${e.toString()}');
    }

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