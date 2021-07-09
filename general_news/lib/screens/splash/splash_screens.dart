import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:general_news/models/news_json.dart';
import 'package:general_news/repository/db/my_db.dart';
import 'package:general_news/screens/main_news/main_news.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/SplashScreen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  var duration = Duration(milliseconds: 6000);

  var colorizeColors = [
    Colors.blue,
    Colors.yellow,
    Colors.red,
    Colors.white,
    Colors.transparent,
  ];

  var colorizeTextStyle = TextStyle(
      fontFamily: 'Horizon',
      fontSize: 45.0,
      fontWeight: FontWeight.bold,
      backgroundColor: Colors.blue);

  List<NewsJson>? newsData;

  Future<List<NewsJson>> loadJsonData() async {
    var jsonText =
        await DefaultAssetBundle.of(context).loadString('lib/assets/news.json');
    var result = List<Map<String, dynamic>>.from(jsonDecode(jsonText));
    List<NewsJson> newsjson = result.map((e) => NewsJson.fromJson(e)).toList();
    // newsjson.sort();
    return newsjson;
  }

  _fetchNews() async {
    newsData = await this.loadJsonData();
  }

  _deleteDatabase() async {
    var db = MyDB();
    var database = await db.open();
    await db.deleteOver30Items(database, false);
    await database.close();
  }

  @override
  void initState() {
    _deleteDatabase();
    _fetchNews();
    super.initState();
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Center(
      child: _colorizeAndFadeText(width, height, context),
    );
  }

  Widget _colorizeAndFadeText(
      double width, double height, BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(color: Colors.blue),
      child: DefaultTextStyle(
        style: colorizeTextStyle,
        child: Center(
          child: AnimatedTextKit(
            animatedTexts: [
              ColorizeAnimatedText(
                'General News',
                textStyle: colorizeTextStyle,
                colors: colorizeColors,
              ),
              FadeAnimatedText('General News'),
              FadeAnimatedText('General News'),
            ],
            onTap: () {
              print("Tap Event");
            },
            isRepeatingAnimation: false,
            onFinished: onFinished,
          ),
        ),
      ),
    );
  }

  onFinished() async {
    if (newsData == null) {
      newsData = await this.loadJsonData();
    }
    Navigator.pushReplacementNamed(context, MainNews.routeName,
        arguments: newsData);
  }

  Container lottieAnimation() {
    return Container(
        width: double.infinity,
        height: double.infinity,
        child: Lottie.asset('lib/assets/splash.json', controller: _controller));
  }
}
