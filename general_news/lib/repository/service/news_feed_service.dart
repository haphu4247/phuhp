import 'package:general_news/models/news_item.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:webfeed/webfeed.dart';

class NewsFeedService {
  Future<List<NewsItem>> fetchData(String url) async{
    var data = await _fetchNews(url);
    try {
      print(data.body);
      var rss = RssFeed.parse(data.body);
      return rss.items!.map((e) => NewsItem.fromRssItem(e)).toList();
    } catch (e) {
      print('error: ${e.toString()}');
      return [];
    }
  }
}

extension on NewsFeedService {
  Future<Response> _fetchNews(String url) {
    print("url:$url");
    return http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        }
    );
  }
}