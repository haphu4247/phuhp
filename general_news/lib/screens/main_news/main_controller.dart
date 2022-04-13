import 'package:general_news/models/news_item.dart';
import 'package:general_news/models/news_json.dart';
import 'package:general_news/repository/service/news_feed_service.dart';
import 'package:get/get.dart';

class MainNewsController extends GetxController {
  RxList<NewsJson> newsData = RxList();

  var appbarTitle = "General News".obs;

  RxMap<String, String> currentJsonNews = RxMap<String, String>();

  bool fetchFirstNew = true;

  RxList<NewsItem> news = RxList();

  var service = Get.find<NewsFeedService>();

  fetchNews(String title, String url) async {
    print("title:$title url:$url");

    var result = await service.fetchData(url);
    print("result: ${result.toString()}");
    appbarTitle.value = title;
    if (result.isEmpty) {
      result.add(NewsItem.empty());
    }
    news.value = result;
  }

  fetchSelectedPost(NewsJson news) {
    Map<String, String> json = news.data;
    print(json);
    fetchFirstNew = true;
    currentJsonNews.value = json;
  }
}