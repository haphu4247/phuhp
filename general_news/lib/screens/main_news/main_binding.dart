import 'package:general_news/screens/main_news/main_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class MainNewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainNewsController());
  }

}