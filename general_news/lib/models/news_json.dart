import 'dart:convert';

import 'package:flutter/material.dart';

class NewsJson {
  late String id;
  late int lastSelected;
  late String name;
  late Map<String, String> data;

  NewsJson({
    required this.id,
    required this.lastSelected,
    required this.name,
    required this.data
  });

  NewsJson.fromJson(Map<String, dynamic> json){
    id = json['id'];
    lastSelected = json['lastSelected'];
    name = json['name'];
    data = Map<String, String>.from(json['data']);
  }
}