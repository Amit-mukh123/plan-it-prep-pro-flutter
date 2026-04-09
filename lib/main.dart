import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Added Riverpod import
import 'package:get/get.dart';
import 'theme/app_theme.dart';
import 'routes/app_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Make system UI transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Wrapped PlanitPrepApp with ProviderScope to enable Riverpod
  runApp(
    const ProviderScope(
      child: PlanitPrepApp(),
    ),
  );
}

class PlanitPrepApp extends StatelessWidget {
  const PlanitPrepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PlanitPrep',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      
      // Using the initial route and routes list from AppPages
      initialRoute: AppPages.initial, 
      getPages: AppPages.routes,
      
      // Default transition for all pages
      defaultTransition: Transition.cupertino,
    );
  }
}