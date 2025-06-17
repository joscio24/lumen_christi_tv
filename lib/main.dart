import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lumen_christi_tv/routes/app_pages.dart';
import 'package:lumen_christi_tv/routes/app_routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: Locale('fr', 'FR'),
      debugShowCheckedModeBanner: false,
      title: "Lumen Christi Tv",
      initialRoute: AppRoutes.SPLASH,
      getPages: AppPages.pages,
    );
  }
}
