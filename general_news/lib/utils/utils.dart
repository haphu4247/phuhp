import 'package:intl/intl.dart';

final myDateFormat = new DateFormat('yyyy-MM-dd hh:mm');

RegExp htmlReg = RegExp(r"<(“[^”]*”|'[^’]*’|[^'”>])*>");
bool hasHTMLTags(String text){
  return htmlReg.hasMatch(text);
}