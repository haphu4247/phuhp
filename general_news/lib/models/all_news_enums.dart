
import 'package:general_news/resources/string.dart';

enum AllNews {
  UNNews, VietNamNews, VNExpress, CNET, ABCNew, IndiaToday
}

extension AllNewsExt on AllNews {
  String get name {
    switch (this) {
      case AllNews.VietNamNews:
        return 'Việt Nam News';
      case AllNews.CNET:
        return 'c|net';
      case AllNews.ABCNew:
        return 'ABC News';
      case AllNews.IndiaToday:
        return 'India Today';
      case AllNews.UNNews:
        return 'UN News';
      case AllNews.VNExpress:
        return 'VN Express';
    }
  }

  String get json {
    switch (this) {
      case AllNews.VietNamNews:
        return vietnamnews_json;
      case AllNews.CNET:
        return cnet_json;
      case AllNews.ABCNew:
        return abc_news_json;
      case AllNews.IndiaToday:
        return india_today_json;
      case AllNews.UNNews:
        return un_news_json;
      case AllNews.VNExpress:
        return vnexpress_json;
    }
  }
}