import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:general_news/models/news_json.dart';
import 'package:general_news/repository/db/my_db.dart';
import 'package:general_news/screens/main_news/main_news.dart';
import 'package:general_news/screens/splash/splash_controller.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../mainSetting.dart';

class SplashScreen extends GetView<SplashController>{
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
    if (controller.newsData == null) {
      controller.newsData = await controller.loadJsonData();
    }
    // Navigator.pushReplacementNamed(context, MainNews.routeName,
    //     arguments: newsData);
    print('splash: data: ${controller.newsData}');
    Get.offNamed(mainNews, arguments: controller.newsData);
  }

  Container lottieAnimation() {
    return Container(
        width: double.infinity,
        height: double.infinity,
        child: Lottie.asset('lib/assets/splash.json', controller: _controller));
  }
}
