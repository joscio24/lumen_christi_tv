import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkFirstTimeUser();
  }

  void _checkFirstTimeUser() async {
    await Future.delayed(Duration(seconds: 4)); // Simulate splash loading
     Get.offAllNamed(AppRoutes.HOME);
    
  }

  
}
