import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:planit_prep_pro/screens/batch_meal_screen.dart';
import 'package:planit_prep_pro/screens/grocery_screen.dart';
import 'package:planit_prep_pro/screens/health_goals_screen.dart';
import 'package:planit_prep_pro/screens/login_screen.dart';
import 'package:planit_prep_pro/screens/main_shell.dart';
import 'package:planit_prep_pro/screens/meal_detail_screen.dart';
import 'package:planit_prep_pro/screens/notifications_screen.dart';
import 'package:planit_prep_pro/screens/otp_screen.dart';
import 'package:planit_prep_pro/screens/privacy_settings_screen.dart';
import 'package:planit_prep_pro/screens/profile_setup_screen.dart';
import 'package:planit_prep_pro/screens/progress_screen.dart';
import 'package:planit_prep_pro/screens/register_screen.dart';
import 'package:planit_prep_pro/screens/surprise_meal_screen.dart';
import 'package:planit_prep_pro/screens/user_config_qs.dart';
import 'package:planit_prep_pro/screens/welcome_screen.dart';

// --- Screens ---
import '../screens/home_screen.dart';
import '../screens/alarms_screen.dart';
import '../screens/splash_screen.dart';
// Note: Ensure these files exist in your screens folder or update the paths
// import '../screens/welcome_screen.dart';
// import '../screens/login_screen.dart';
// import '../screens/otp_screen.dart';

class AppPages {
  AppPages._();

  // The first screen the app will open is now Splash
  static const initial = Routes.splash;

  static final routes = [
    // --- Auth Flow ---
    GetPage(name: Routes.splash, page: () => const SplashScreen()),
    GetPage(name: Routes.welcome, page: () => const WelcomeScreen()),
    GetPage(name: Routes.login, page: () => const LoginScreen()),
    GetPage(name: Routes.verifyOtp, page: () => const OtpScreen()),
    GetPage(name: Routes.ProfileSetup, page: () => const ProfileSetupScreen()),
    GetPage(name: Routes.userGoal, page: () => const HealthGoalsScreen()),
    GetPage(name: Routes.mainShell, page: () => const MainShell()),

    // --- Main App ---
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      participatesInRootNavigator: true,
    ),
    GetPage(
      name: Routes.dietPlan,
      page: () => const Scaffold(body: Center(child: Text('Diet Plan Screen'))),
    ),
    GetPage(name: Routes.batchMeal, page: () => const BatchMealScreen()),
    GetPage(name: Routes.surpriseMeal, page: () => const SurpriseMealScreen()),
    GetPage(name: Routes.mealDetails, page: () => const MealDetailScreen()),
    GetPage(name: Routes.groceryList, page: () => const GroceryScreen()),

    GetPage(name: Routes.mealAlarm, page: () => const AlarmsScreen()),

    GetPage(name: Routes.myProgress, page: () => const ProgressScreen()),

    GetPage(name: Routes.privacy, page: () => const PrivacySettingsScreen()),

    GetPage(
      name: Routes.notifications,
      page: () => const NotificationsScreen(),
    ),
    GetPage(name: Routes.qs_and_ans, page: () => const QuestionnaireScreen()),

    GetPage(name: Routes.register, page: () => const RegisterScreen()),
  ];
}

abstract class Routes {
  static const splash = _Paths.splash;
  static const welcome = _Paths.welcome;
  static const login = _Paths.login;
  static const verifyOtp = _Paths.verifyOtp;
  static const home = _Paths.home;
  static const dietPlan = _Paths.dietPlan;
  static const batchMeal = _Paths.batchMeal;
  static const surpriseMeal = _Paths.surpriseMeal;
  static const groceryList = _Paths.groceryList;
  static const mealAlarm = _Paths.mealAlarm;
  static const notifications = _Paths.notifications;
  static const myProgress = _Paths.myProgress;
  static const ProfileSetup = _Paths.ProfileSetup;
  static const userGoal = _Paths.userGoal;
  static const mealDetails = _Paths.mealDetails;
  static const mainShell = _Paths.mainShell;
  static const privacy = _Paths.privacy;
  static const qs_and_ans = _Paths.qs_and_ans;
  static const register = _Paths.register;

  Routes._();
}

abstract class _Paths {
  static const splash = '/splash';
  static const welcome = '/welcome';
  static const login = '/login';
  static const register = '/register';
  static const verifyOtp = '/verify-otp';
  static const home = '/home';
  static const dietPlan = '/diet-plan';
  static const batchMeal = '/batch-meal';
  static const surpriseMeal = '/surprise-meal';
  static const groceryList = '/grocery-list';
  static const mealAlarm = '/meal-alarm';
  static const notifications = '/notifications';
  static const myProgress = '/my-progress';
  static const ProfileSetup = '/profile-setup';
  static const userGoal = '/user-goal';
  static const mealDetails = '/meal-details';
  static const mainShell = '/main-shell';
  static const privacy = '/privacy';
  static const qs_and_ans = '/qs_and_ans';
  //static const scanIngredients = '/scan-ingredients';
}
