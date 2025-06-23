import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lumen_christi_tv/routes/app_pages.dart';
import 'package:lumen_christi_tv/routes/app_routes.dart';
// import path_provider if you need it here or in other files
// import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // IMPORTANT to initialize plugins before runApp
  
  // If you want to do any async initialization before app runs,
  // do it here. For example:
  // final dir = await getApplicationDocumentsDirectory();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: const Locale('fr', 'FR'),
      debugShowCheckedModeBanner: false,
      title: "Lumen Christi Tv",
      initialRoute: AppRoutes.SPLASH,
      getPages: AppPages.pages,
    );
  }
}
