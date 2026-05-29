import 'dart:io';

void main() async {
  final libDir = Directory('lib');
  
  // Mapping of old paths (relative to lib) to new paths (relative to lib)
  final Map<String, String> moves = {
    // core API
    'controllers/ApiController.dart': 'core/api/ApiController.dart',
    'providers/api_provider.dart': 'core/api/api_provider.dart',
    
    // core common
    'models/app_data.dart': 'core/common/app_data.dart',
    'widgets/common_widgets.dart': 'core/common/common_widgets.dart',
    'widgets/animation.dart': 'core/common/animation.dart',
    
    // core startup
    'screens/splash_screen.dart': 'core/startup/splash_screen.dart',
    
    // core theme
    'theme/app_theme.dart': 'core/theme/app_theme.dart',
    
    // auth feature
    'controllers/AuthController.dart': 'features/auth/data/AuthController.dart',
    'providers/auth_provider.dart': 'features/auth/data/auth_provider.dart',
    'states/AuthState.dart': 'features/auth/data/AuthState.dart',
    'services/AuthService.dart': 'features/auth/data/AuthService.dart',
    'screens/login_screen.dart': 'features/auth/presentation/login_screen.dart',
    'screens/register_screen.dart': 'features/auth/presentation/register_screen.dart',
    'screens/otp_screen.dart': 'features/auth/presentation/otp_screen.dart',
    'screens/welcome_screen.dart': 'features/auth/presentation/welcome_screen.dart',
    
    // user_profile feature
    'controllers/UserController.dart': 'features/user_profile/data/UserController.dart',
    'providers/user_provider.dart': 'features/user_profile/data/user_provider.dart',
    'providers/user_summary_state_provider.dart': 'features/user_profile/data/user_summary_state_provider.dart',
    'screens/profile_screen.dart': 'features/user_profile/presentation/profile_screen.dart',
    'screens/profile_setup_screen.dart': 'features/user_profile/presentation/profile_setup_screen.dart',
    'screens/user_config_qs.dart': 'features/user_profile/presentation/user_config_qs.dart',
    'screens/privacy_settings_screen.dart': 'features/user_profile/presentation/privacy_settings_screen.dart',
    'screens/health_goals_screen.dart': 'features/user_profile/presentation/health_goals_screen.dart',
    
    // meals feature
    'controllers/AiResponseController.dart': 'features/meals/data/AiResponseController.dart',
    'providers/AiResponse_provider.dart': 'features/meals/data/AiResponse_provider.dart',
    'providers/meal_plan_provider.dart': 'features/meals/data/meal_plan_provider.dart',
    'screens/meal_screen.dart': 'features/meals/presentation/meal_screen.dart',
    'screens/meal_detail_screen.dart': 'features/meals/presentation/meal_detail_screen.dart',
    'screens/batch_meal_screen.dart': 'features/meals/presentation/batch_meal_screen.dart',
    'screens/surprise_meal_screen.dart': 'features/meals/presentation/surprise_meal_screen.dart',
    'widgets/meal_card.dart': 'features/meals/presentation/meal_card.dart',
    'widgets/change_meal_sheet.dart': 'features/meals/presentation/change_meal_sheet.dart',
    
    // dashboard feature
    'screens/home_screen.dart': 'features/dashboard/presentation/home_screen.dart',
    'screens/main_shell.dart': 'features/dashboard/presentation/main_shell.dart',
    'screens/progress_screen.dart': 'features/dashboard/presentation/progress_screen.dart',
    'widgets/bottom_nav_bar.dart': 'features/dashboard/presentation/bottom_nav_bar.dart',
    
    // grocery feature
    'screens/grocery_screen.dart': 'features/grocery/presentation/grocery_screen.dart',
    
    // alarms feature
    'screens/alarms_screen.dart': 'features/alarms/presentation/alarms_screen.dart',
    
    // location feature
    'screens/locationTest.dart': 'features/location/presentation/locationTest.dart',
    
    // notifications module
    'screens/notifications_screen.dart': 'notifications/views/notifications_screen.dart',
    
    // services/location
    'models/location_state.dart': 'services/location/location_state.dart',
    'providers/location_provider.dart': 'services/location/location_provider.dart',
    'services/location_service.dart': 'services/location/location_service.dart',
    
    // root files
    'routes/app_routes.dart': 'routes.dart',
  };

  final packageName = 'ileum';
  
  List<Map<String, dynamic>> tasks = [];
  for (var entry in moves.entries) {
    var oldPath = entry.key;
    var newPath = entry.value;
    if (oldPath == newPath) continue;

    var oldFile = File('lib/$oldPath');
    if (oldFile.existsSync()) {
      tasks.add({
        'oldRel': oldPath,
        'newRel': newPath,
        'oldFile': oldFile,
        'newFile': File('lib/$newPath')
      });
    }
  }

  List<File> allDartFiles = [];
  void scanDir(Directory dir) {
    if (!dir.existsSync()) return;
    for (var entity in dir.listSync(recursive: false)) {
      if (entity is Directory) {
        scanDir(entity);
      } else if (entity is File && entity.path.endsWith('.dart')) {
        allDartFiles.add(entity);
      }
    }
  }
  scanDir(libDir);

  String normalizePath(String path) {
    var parts = path.split('/');
    var resolved = <String>[];
    for (var part in parts) {
      if (part == '..') {
        if (resolved.isNotEmpty) resolved.removeLast();
      } else if (part != '.' && part.isNotEmpty) {
        resolved.add(part);
      }
    }
    return resolved.join('/');
  }
  
  Map<String, String> packageImportMap = {};
  for (var entry in moves.entries) {
    packageImportMap['package:$packageName/${entry.key}'] = 'package:$packageName/${entry.value}';
  }

  for (var file in allDartFiles) {
    var content = file.readAsStringSync();
    var filePathRelLib = file.path.replaceAll('\\', '/').substring(4);
    var fileDir = filePathRelLib.contains('/') ? filePathRelLib.substring(0, filePathRelLib.lastIndexOf('/')) : '';
    
    var regex = RegExp(r"(import|export)\s+['""]([^'""]+)['""]");
    
    var newContent = content.replaceAllMapped(regex, (match) {
      var keyword = match.group(1);
      var importPath = match.group(2)!;
      
      if (importPath.startsWith('dart:') || importPath.startsWith('package:') && !importPath.startsWith('package:$packageName/')) {
        return match.group(0)!;
      }
      
      String resolvedPackagePath = importPath;
      if (importPath.startsWith('.')) {
        var combinedPath = fileDir.isEmpty ? importPath : '$fileDir/$importPath';
        var normalizedLibRelPath = normalizePath(combinedPath);
        resolvedPackagePath = 'package:$packageName/$normalizedLibRelPath';
      }
      
      if (packageImportMap.containsKey(resolvedPackagePath)) {
        return "$keyword '${packageImportMap[resolvedPackagePath]}'";
      }
      
      if (importPath.startsWith('.') && resolvedPackagePath.startsWith('package:$packageName/')) {
        return "$keyword '$resolvedPackagePath'";
      }
      
      return match.group(0)!;
    });
    
    if (content != newContent) {
      file.writeAsStringSync(newContent);
    }
  }

  for (var task in tasks) {
    File oldFile = task['oldFile'];
    File newFile = task['newFile'];
    
    if (!newFile.parent.existsSync()) {
      newFile.parent.createSync(recursive: true);
    }
    
    oldFile.copySync(newFile.path);
    oldFile.deleteSync();
  }
  
  void cleanEmptyDirs(Directory dir) {
    if (!dir.existsSync()) return;
    for (var entity in dir.listSync(recursive: false)) {
      if (entity is Directory) {
        cleanEmptyDirs(entity);
      }
    }
    if (dir.listSync(recursive: false).isEmpty && dir.path != libDir.path) {
      dir.deleteSync();
    }
  }
  cleanEmptyDirs(libDir);
  
  stdout.writeln("Refactoring complete.");
}
