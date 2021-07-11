import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:general_news/screens/main_news/main_news.dart';
import 'package:general_news/screens/setting/history.dart';
import 'package:general_news/screens/setting/saved.dart';
import 'package:general_news/screens/splash/splash_screens.dart';
import 'package:general_news/screens/webview/my_webview.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase?.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: SplashScreen.routeName,
      routes: _allRoutes(),
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
    );
  }

  Map<String, WidgetBuilder> _allRoutes(){
    var routes = Map<String, WidgetBuilder>();
    routes[SplashScreen.routeName] = (context) => SplashScreen();
    routes[MainNews.routeName] = (context) => MainNews();
    routes[MyWebView.routeName] = (context) => MyWebView();
    routes[SavedScreen.routeName] = (context) => SavedScreen();
    routes[HistoryScreen.routeName] = (context) => HistoryScreen();
    return routes;
  }
}
