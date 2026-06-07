import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ileum/features/meals/presentation/batch_meal_screen.dart';
import 'package:ileum/features/grocery/presentation/grocery_screen.dart';
import 'package:ileum/features/user_profile/presentation/health_goals_screen.dart';
import 'package:ileum/features/auth/presentation/login_screen.dart';
import 'package:ileum/features/dashboard/presentation/main_shell.dart';
import 'package:ileum/features/meals/presentation/meal_detail_screen.dart';
import 'package:ileum/notifications/views/notifications_screen.dart';
import 'package:ileum/features/auth/presentation/otp_screen.dart';
import 'package:ileum/features/user_profile/presentation/privacy_settings_screen.dart';
import 'package:ileum/features/user_profile/presentation/profile_setup_screen.dart';
import 'package:ileum/features/dashboard/presentation/progress_screen.dart';
import 'package:ileum/features/auth/presentation/register_screen.dart';
import 'package:ileum/features/meals/presentation/surprise_meal_screen.dart';
import 'package:ileum/features/user_profile/presentation/user_config_qs.dart';
import 'package:ileum/features/auth/presentation/welcome_screen.dart';

// --- Screens ---
import 'package:ileum/features/dashboard/presentation/home_screen.dart';
import 'package:ileum/features/alarms/presentation/alarms_screen.dart';
import 'package:ileum/core/startup/splash_screen.dart';
// Note: Ensure these files exist in your screens folder or update the paths
// import 'package:ileum/features/auth/presentation/welcome_screen.dart';
// import 'package:ileum/features/auth/presentation/login_screen.dart';
// import 'package:ileum/features/auth/presentation/otp_screen.dart';

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
    GetPage(name: Routes.profileSetup, page: () => const ProfileSetupScreen()),
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
    GetPage(name: Routes.qsAndAns, page: () => const QuestionnaireScreen()),

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
  static const profileSetup = _Paths.profileSetup;
  static const userGoal = _Paths.userGoal;
  static const mealDetails = _Paths.mealDetails;
  static const mainShell = _Paths.mainShell;
  static const privacy = _Paths.privacy;
  static const qsAndAns = _Paths.qsAndAns;
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
  static const profileSetup = '/profile-setup';
  static const userGoal = '/user-goal';
  static const mealDetails = '/meal-details';
  static const mainShell = '/main-shell';
  static const privacy = '/privacy';
  static const qsAndAns = 's/qs_and_an';
  //static const scanIngredients = '/scan-ingredients';
}
