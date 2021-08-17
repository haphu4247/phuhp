import 'package:general_news/repository/service/news_feed_service.dart';
import 'package:general_news/screens/main_news/main_binding.dart';
import 'package:general_news/screens/main_news/main_news.dart';
import 'package:general_news/screens/setting/history/history.dart';
import 'package:general_news/screens/setting/history/history_binding.dart';
import 'package:general_news/screens/setting/saved/saved.dart';
import 'package:general_news/screens/setting/saved/saved_binding.dart';
import 'package:general_news/screens/splash/splash_binding.dart';
import 'package:general_news/screens/splash/splash_screens.dart';
import 'package:general_news/screens/webview/my_webview.dart';
import 'package:general_news/screens/webview/my_webview_binding.dart';
import 'package:get/get.dart';

final String initRoute = '/SplashScreen';
final String mainNews = '/MainNews';
final String myWebView = '/MyWebView';
final String savedScreen = '/SavedScreen';
final String historyScreen = '/HistoryScreen';

List<GetPage<dynamic>> getPages() {
  return [
    GetPage(name: initRoute, page: ()=>SplashScreen(), binding: SplashBinding()),
    GetPage(name: mainNews, page: ()=> MainNews(), binding: MainNewsBinding()),
    GetPage(name: myWebView, page:()=> MyWebView(), binding: MyWebViewBinding()),
    GetPage(name: savedScreen, page: ()=> SavedScreen(), binding: SavedBinding()),
    GetPage(name: historyScreen, page: ()=> HistoryScreen(), binding: HistoryBinding())
  ];
}

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NewsFeedService());
  }

}