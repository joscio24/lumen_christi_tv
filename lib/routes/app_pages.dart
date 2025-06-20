import 'package:get/get.dart';
import 'package:lumen_christi_tv/modules/MarquePage/bindings/marquepage_binding.dart';
import 'package:lumen_christi_tv/modules/MarquePage/views/marque_page.dart';
import 'package:lumen_christi_tv/modules/Nousrejoindre/views/nous_rejoindre.dart';
import 'package:lumen_christi_tv/modules/Nousrejoindre/views/profile_view.dart';
import 'package:lumen_christi_tv/routes/app_routes.dart';
import 'package:lumen_christi_tv/splash/bindings/splash_binding.dart';
import 'package:lumen_christi_tv/splash/view/splash_view.dart';
import 'package:lumen_christi_tv/views/home_view.dart';


class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
      transition: Transition.cupertino, // Smooth fade-in transition
      transitionDuration: Duration(milliseconds: 800),
    ),
    
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomeView(),
    ),

    GetPage(
      name: AppRoutes.MarquePage,
      page: () => MarquePage(),
      binding: MarquepageBinding(),
      transition: Transition.cupertino, // Smooth fade-in transition
      transitionDuration: Duration(milliseconds: 800),
    ),

    GetPage(
      name: AppRoutes.Profile,
      page: () => ProfilePage(),
      // binding: MarquepageBinding(),
      transition: Transition.cupertino, // Smooth fade-in transition
      transitionDuration: Duration(milliseconds: 800),
    ),

    GetPage(
      name: AppRoutes.Rejoindre,
      page: () => NousRejoindre(),
      // binding: HomeBinding(),
      transition: Transition.cupertino, // Smooth fade-in transition
      transitionDuration: Duration(milliseconds: 800),
    ),
  ];
}
