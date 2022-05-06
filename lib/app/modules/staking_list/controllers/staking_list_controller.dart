import 'package:get/get.dart';

class StakingListController extends GetxController {
  final orders = [
    {'days': 180, 'amount': '2000.0', 'startTime': '2022-05-06'},
    {'days': 180, 'amount': '100.0', 'startTime': '2022-05-06'},
    {'days': 180, 'amount': '300.0', 'startTime': '2022-05-06'},
    {'days': 180, 'amount': '600.0', 'startTime': '2022-05-06'},
    {'days': 180, 'amount': '900.0', 'startTime': '2022-05-06'},
    {'days': 180, 'amount': '1234.0', 'startTime': '2022-05-06'},
  ];
  // @override
  // void onInit() {
  //   super.onInit();
  // }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  @override
  void onClose() {}
}
