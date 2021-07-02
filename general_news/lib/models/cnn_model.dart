import 'package:flutter/material.dart';

class CNNModel {
  CNNModel({
    this.rss,
  });

  Rss? rss;
}

class Rss {
  Rss({
    this.channel,
    this.xmlnsMedia,
    this.xmlnsDc,
    this.xmlnsAtom,
    this.xmlnsContent,
    this.version,
  });

  Channel? channel;
  String? xmlnsMedia;
  String? xmlnsDc;
  String? xmlnsAtom;
  String? xmlnsContent;
  String? version;
}

class Channel {
  Channel({
    this.link,
    this.title,
    this.description,
    this.image,
    this.item,
  });

  List<dynamic>? link;
  String? title;
  String? description;
  Image? image;
  List<Item>? item;
}

class Image {
  Image({
    this.url,
    this.title,
    this.link,
  });

  String? url;
  String? title;
  String? link;
}

class Item {
  Item({
    this.title,
    this.link,
    this.guid,
    this.pubDate,
    this.description,
    this.thumbnail,
    this.content,
    this.creator,
  });

  String? title;
  String? link;
  Guid? guid;
  String? pubDate;
  String? description;
  Thumbnail? thumbnail;
  Content? content;
  Creator? creator;
}

class Content {
  Content({
    this.height,
    this.width,
    this.medium,
    this.url,
    this.prefix,
  });

  String? height;
  String? width;
  Medium? medium;
  String? url;
  ContentPrefix? prefix;
}

enum Medium { IMAGE }

enum ContentPrefix { MEDIA }

class Creator {
  Creator({
    this.prefix,
    this.text,
  });

  CreatorPrefix? prefix;
  String? text;
}

enum CreatorPrefix { DC }

class Guid {
  Guid({
    this.isPermaLink,
    this.text,
  });

  String? isPermaLink;
  String? text;
}

class Thumbnail {
  Thumbnail({
    this.url,
    this.prefix,
  });

  String? url;
  ContentPrefix? prefix;
}

class LinkClass {
  LinkClass({
    this.href,
    this.rel,
    this.type,
    this.prefix,
  });

  String? href;
  String? rel;
  String? type;
  String? prefix;
}
