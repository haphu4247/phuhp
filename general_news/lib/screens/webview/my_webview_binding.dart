import 'package:general_news/screens/webview/my_webview_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class MyWebViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(() => MyWebViewController());
  }
}