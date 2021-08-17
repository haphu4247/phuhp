import 'dart:io';
import 'package:general_news/models/args.dart';
import 'package:general_news/screens/webview/my_webview_controller.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

class MyWebView extends GetView<MyWebViewController>{
  late WebViewController _webViewController;

  bool _useRtlText = false;

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    final args = ModalRoute.of(context)!.settings.arguments as Args;
    return Scaffold(
      body: buildBody(args, context),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_outlined),
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }

  LoaderOverlay buildBody(Args args, BuildContext context) {
    return LoaderOverlay(
      child: WebView(
        initialUrl: args.link,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController c) {
          _webViewController = c;
          _getTitle();
        },
        onPageFinished: (String s) {
          // Navigator.of(context).pop();
          context.loaderOverlay.hide();
        },
        onPageStarted: (String s) {
          // _onLoading();
          context.loaderOverlay.show();
        },
      ),
    );
  }

  _getTitle() async {
    var title = await _webViewController.getTitle();
    controller.title.value = title ?? "";
  }
}
