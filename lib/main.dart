import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Added Riverpod import
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ileum/services/location/location_provider.dart';
import 'package:ileum/core/theme/app_theme.dart';
import 'package:ileum/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create a ProviderContainer to read providers before runApp
  final container = ProviderContainer();

  // --- START LOCATION CHECK ---
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // This will open the system location settings immediately on startup
    await Geolocator.openLocationSettings();
  }
  // --- END LOCATION CHECK ---

  // This checks storage; if empty, it calls the loadLocation function
  debugPrint("running fetch location ...........................");
  // Do not await this, so runApp can execute immediately and prevent ANR
  container.read(locationProvider.notifier).initLocation();

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
  runApp(const ProviderScope(child: PlanitPrepApp()));
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
