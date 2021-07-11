import 'package:general_news/models/news_item.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MyDB {

  Future<Database> open() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, 'my_news.db');
    // open the database
    return openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE $tableNewsItem ($columnLink TEXT PRIMARY KEY, $columnTitle TEXT, $columnDescription TEXT, $columnDate INTEGER, $columnImgUrl TEXT, $columnIsHtml INTEGER)');

          await db.execute(
              'CREATE TABLE $tableSavedNewsItem ($columnLink TEXT PRIMARY KEY, $columnTitle TEXT, $columnDescription TEXT, $columnDate INTEGER, $columnImgUrl TEXT, $columnIsHtml INTEGER)');
        });
  }

  Future<int> insert(Database database, NewsItem item, bool isSaveTable) async {
    int insertedAt = await database.insert(isSaveTable ? tableSavedNewsItem : tableNewsItem, item.toMap());
    return insertedAt;
  }

  delete(Database database, NewsItem item, bool isSaveTable) async {
    String link = item.link;
    print('link:$link');
    return await database.delete(isSaveTable ? tableSavedNewsItem : tableNewsItem, where: '$columnLink=$link');
  }

  deleteOver30Items(Database database, bool isSaveTable) async {
    var queryTable = await database.query(isSaveTable ? tableSavedNewsItem : tableNewsItem);
    if (queryTable.length > 30) {
      for(int i = 0; i < queryTable.length-30; i++){
        await delete(database, NewsItem.fromMap(queryTable[i]), isSaveTable);
      }
    }
  }

  Future<List<NewsItem>> fetchNews(Database database, bool isSaveTable) async {
    var queryTable = await database.query(isSaveTable ? tableSavedNewsItem : tableNewsItem);
    var news = queryTable.reversed.map((e) => NewsItem.fromMap(e)).toList();
    print('news:${news.length}');
    return news;
  }

  Future<List<NewsItem>> fetchNewsLimitation(Database database, int limit) async {
    var queryTable = await database.query(tableNewsItem, limit: limit);
    return queryTable.map((e) => NewsItem.fromMap(e)).toList();
  }
}
