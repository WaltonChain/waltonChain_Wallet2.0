import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/core/values/urls.dart';

class ApiProvider extends GetConnect {
  Future<dynamic> getLatestVersion() async {
    final response = await get(latestVersionUrl);
    if (response.status.hasError) {
      return Future.error(response.statusText!);
    } else {
      return response.body;
    }
  }
}
