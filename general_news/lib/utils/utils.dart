import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

final myDateFormat = new DateFormat('yyyy-MM-dd hh:mm');

RegExp htmlReg = RegExp(r"<(“[^”]*”|'[^’]*’|[^'”>])*>");
bool hasHTMLTags(String text){
  return htmlReg.hasMatch(text);
}

Future<String> getFileData(String path) async {
  return await rootBundle.loadString(path);
}