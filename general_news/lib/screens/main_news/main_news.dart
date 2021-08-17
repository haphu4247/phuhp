import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:general_news/mainSetting.dart';
import 'package:general_news/models/news_item.dart';
import 'package:general_news/models/news_json.dart';
import 'package:general_news/repository/service/news_feed_service.dart';
import 'package:general_news/resources/colors.dart';
import 'package:general_news/resources/string.dart';
import 'package:general_news/screens/main_news/components/bottombar_item.dart';
import 'package:general_news/screens/main_news/components/item_in_listview.dart';
import 'package:general_news/screens/setting/history/history.dart';
import 'package:general_news/screens/setting/me/me.dart';
import 'package:general_news/screens/setting/saved/saved.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:general_news/extension/context.dart';
import 'package:package_info/package_info.dart';

import 'main_controller.dart';

class MainNews extends GetView<MainNewsController> {
  List<Widget> popupItems = [];

  @override
  Widget build(BuildContext context) {
    _setupPopupItems();

    if (controller.newsData.isEmpty) {
      var json = ModalRoute.of(context)!.settings.arguments as List<NewsJson>;
      print('data: $json');
      controller.newsData.addAll(json);
      controller.currentJsonNews.value = controller.newsData.first.data;
    }
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.appbarTitle.value,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700))),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      drawer: _drawer(context),
      endDrawer: _endDrawer(context),
      body: LoaderOverlay(
        child: _buildBody(),
      ),
      bottomNavigationBar: _bottomBar(),
    );
  }

  void _setupPopupItems() {
    popupItems.add(Row(
      children: [
        Icon(Icons.save_alt_rounded, color: Colors.blue),
        SizedBox(
          width: 5,
        ),
        Text(kSave, style: TextStyle(color: Colors.blue, fontSize: 14)),
      ],
    ));
  }

  Widget _buildBody() {
    return Container(
        decoration: BoxDecoration(color: backgroundGray),
        child: Obx(() => ListView.separated(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),

                itemBuilder: (context, index) {
                  if (controller.news.length == 1) {
                    return emptyDataWidget();
                  } else {
                    return buildItemInListView(context, popupItems,
                        controller.news[index], ActionForItemType.Home, null);
                  }
                },
                itemCount: controller.news.length,
                separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 10,
                    color: backgroundGray,
                  );
                },
              )
        )
    );
  }

  Widget _drawer(BuildContext context) {
    List<Widget> view = [];
    var header = DrawerHeader(
        decoration: BoxDecoration(color: Colors.blue),
        child: Align(
          child: Text(
            "All News",
            style: TextStyle(
                color: Colors.white, fontStyle: FontStyle.normal, fontSize: 30),
            textAlign: TextAlign.center,
          ),
          alignment: Alignment.center,
        ));
    view.add(header);

    controller.newsData.forEach((element) {
      var item = ListTile(
        contentPadding: EdgeInsets.only(left: 15, bottom: 5, right: 5, top: 5),
        title: Text(element.name),
        onTap: () {
          Navigator.pop(context);
          controller.fetchSelectedPost(element);
        },
      );
      view.add(item);
    });

    return Drawer(
      elevation: 12,
      child: ListView(
        children: view,
      ),
    );
  }

  Widget _endDrawer(BuildContext context) {
    List<Widget> view = [];

    Widget home = Container(
      height: 56,
      child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Row(
            children: [
              SizedBox(
                width: 5,
              ),
              Icon(
                Icons.home_filled,
                color: Colors.blue,
              ),
              SizedBox(
                width: 5,
              ),
              Text(kHome, style: TextStyle(color: Colors.blue, fontSize: 14))
            ],
          )),
    );

    Widget aboutApp = Container(
      height: 56,
      child: IconButton(
          onPressed: () async {
            var appInfor = await PackageInfo.fromPlatform();
            var dialog = Dialog(
              child: MeScreen(
                version: appInfor.version,
                buildNumber: appInfor.buildNumber,
              ),
            );
            showDialog(
                context: context,
                builder: (_) => dialog,
                barrierDismissible: true);
          },
          icon: Row(
            children: [
              SizedBox(
                width: 5,
              ),
              Icon(Icons.tag_faces, color: Colors.blue),
              SizedBox(
                width: 5,
              ),
              Text(kMe, style: TextStyle(color: Colors.blue, fontSize: 14))
            ],
          )),
    );

    Widget saved = Container(
      height: 56,
      child: IconButton(
          onPressed: () {
            // Navigator.pushNamed(context, SavedScreen.routeName);
            Get.toNamed(savedScreen);
          },
          icon: Row(
            children: [
              SizedBox(
                width: 5,
              ),
              Icon(Icons.save_alt_rounded, color: Colors.blue),
              SizedBox(
                width: 5,
              ),
              Text(kSave, style: TextStyle(color: Colors.blue, fontSize: 14))
            ],
          )),
    );

    Widget history = Container(
      height: 56,
      child: IconButton(
          onPressed: () {
            // Navigator.pushNamed(context, HistoryScreen.routeName);
            Get.toNamed(historyScreen);
          },
          icon: Row(
            children: [
              SizedBox(
                width: 5,
              ),
              Icon(Icons.history_rounded, color: Colors.blue),
              SizedBox(
                width: 5,
              ),
              Text(kHistory, style: TextStyle(color: Colors.blue, fontSize: 14))
            ],
          )),
    );

    view.add(home);
    view.add(aboutApp);
    view.add(saved);
    view.add(history);
    return Drawer(
      elevation: 12,
      child: ListView(
        children: view,
      ),
    );
  }

  Widget _bottomBar() {
    // List<BottomBarItem> bottomItem = [];
    // controller.currentJsonNews.forEach((key, value) {
    //   var model = BottomBarModel(title: key, url: value);
    //   var view = BottomBarItem(
    //       data: model,
    //       onTap: () {
    //         model.isSelected = true;
    //         controller.fetchNews(model.title, model.url);
    //       });
    //
    //   if (controller.fetchFirstNew) {
    //     controller.fetchFirstNew = false;
    //     controller.fetchNews(model.title, model.url);
    //   }
    //
    //   bottomItem.add(view);
    // });
    return Container(
      height: 56,
      decoration: BoxDecoration(color: Colors.blue),
      child: Obx(
        ()=> ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: 15, right: 15),
          itemCount: controller.currentJsonNews.length,
          itemBuilder: (context, index){
            var key = controller.currentJsonNews.keys.elementAt(index);
            var value = controller.currentJsonNews.value[key] ?? '';
            var model = BottomBarModel(title: key, url: value);
            var view = BottomBarItem(
                data: model,
                onTap: () {
                  model.isSelected = true;
                  controller.fetchNews(model.title, model.url);
                });

            if (controller.fetchFirstNew) {
              controller.fetchFirstNew = false;
              controller.fetchNews(model.title, model.url);
            }
            return view;
          }, separatorBuilder: (context, index) {
            return Divider();
        },
        ),
      ),
    );
  }
}
