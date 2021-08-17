import 'package:general_news/screens/setting/saved/saved_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class SavedBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SavedController());
  }
}