import 'package:get/get.dart';

class HomeController extends GetxController {
  var index = 0.obs;

  @override
  void onClose() {}

  void setIndex(int i) {
    index.value = i;
  }
}
