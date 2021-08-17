import 'package:general_news/screens/setting/history/history_controller.dart';
import 'package:get/get.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HistoryController());
  }

}