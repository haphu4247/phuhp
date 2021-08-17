import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:general_news/models/news_json.dart';
import 'package:general_news/repository/db/my_db.dart';
import 'package:general_news/utils/utils.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:path/path.dart';

class SplashController extends GetxController {
  List<NewsJson>? newsData;

  @override
  void onInit() {
    _deleteDatabase();
    _fetchNews();
    super.onInit();
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

  Future<List<NewsJson>> loadJsonData() async {
    var jsonText =
    await getFileData('lib/assets/news.json');
    var result = List<Map<String, dynamic>>.from(jsonDecode(jsonText));
    List<NewsJson> newsjson = result.map((e) => NewsJson.fromJson(e)).toList();
    // newsjson.sort();
    return newsjson;
  }


}