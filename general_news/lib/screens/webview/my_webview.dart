import 'dart:io';
import 'package:general_news/models/args.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

class MyWebView extends StatefulWidget {
  static String routeName = "/MyWebView";

  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> with TickerProviderStateMixin {
  late WebViewController _controller;

  String title = "";

  bool _useRtlText = false;

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Args;
    return Scaffold(
      body: buildBody(args, context),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_outlined),
        ),
      ),
    );
  }

  LoaderOverlay buildBody(Args args, BuildContext context) {
    return LoaderOverlay(
      child: WebView(
        initialUrl: args.link,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController c) {
          _controller = c;
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
    var title = await _controller.getTitle();
    setState(() {
      this.title = title ?? "";
    });
  }
}
