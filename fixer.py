import os
import re

def main():
    lib_dir = "lib"
    
    # 1. File renames
    renames = {
        "config/AppConfig.dart": "config/app_config.dart",
        "core/api/ApiController.dart": "core/api/api_controller.dart",
        "features/auth/data/AuthController.dart": "features/auth/data/auth_controller.dart",
        "features/auth/data/AuthService.dart": "features/auth/data/auth_service.dart",
        "features/auth/data/AuthState.dart": "features/auth/data/auth_state.dart",
        "features/location/presentation/locationTest.dart": "features/location/presentation/location_test.dart",
        "features/meals/data/AiResponseController.dart": "features/meals/data/ai_response_controller.dart",
        "features/meals/data/AiResponse_provider.dart": "features/meals/data/ai_response_provider.dart",
        "features/user_profile/data/UserController.dart": "features/user_profile/data/user_controller.dart",
    }
    
    for old_rel, new_rel in renames.items():
        old_path = os.path.join(lib_dir, old_rel.replace('/', os.sep))
        new_path = os.path.join(lib_dir, new_rel.replace('/', os.sep))
        if os.path.exists(old_path):
            os.rename(old_path, new_path)
            
    # Function to collect all dart files
    dart_files = []
    for root, dirs, files in os.walk(lib_dir):
        for f in files:
            if f.endswith(".dart"):
                dart_files.append(os.path.join(root, f))
                
    dart_files.append("lib/main.dart") # wait, main is in lib
    if "lib/main.dart" not in [f.replace(os.sep, '/') for f in dart_files]:
        # main is inside lib, already covered by walk
        pass
        
    for filepath in dart_files:
        with open(filepath, "r", encoding="utf-8") as f:
            content = f.read()
            
        new_content = content
        
        # Replace old filenames in imports
        for old_rel, new_rel in renames.items():
            old_base = old_rel.split('/')[-1]
            new_base = new_rel.split('/')[-1]
            new_content = new_content.replace(old_base, new_base)
            
        # Specific fixes
        if "main.dart" in filepath.replace('\\', '/'):
            new_content = new_content.replace("import 'theme/app_theme.dart';", "import 'package:ileum/core/theme/app_theme.dart';")
            new_content = new_content.replace("import 'routes/app_routes.dart';", "import 'package:ileum/routes.dart';")
            
        if "main_shell.dart" in filepath.replace('\\', '/'):
            new_content = new_content.replace("import 'meal_screen.dart';", "import 'package:ileum/features/meals/presentation/meal_screen.dart';")
            new_content = new_content.replace("import 'grocery_screen.dart';", "import 'package:ileum/features/grocery/presentation/grocery_screen.dart';")
            new_content = new_content.replace("import 'profile_screen.dart';", "import 'package:ileum/features/user_profile/presentation/profile_screen.dart';")
            
        if "meal_card.dart" in filepath.replace('\\', '/'):
            new_content = new_content.replace("import 'common_widgets.dart';", "import 'package:ileum/core/common/common_widgets.dart';")
            
        # withOpacity -> withValues(alpha: ...)
        new_content = re.sub(r'\.withOpacity\(([^)]+)\)', r'.withValues(alpha: \1)', new_content)
        
        # '.value' to 'initialValue' in textformfields etc. Wait, regex for this might be risky.
        # "lib\features\meals\presentation\batch_meal_screen.dart:689:11 - deprecated_member_use"
        # "lib\features\user_profile\presentation\profile_setup_screen.dart:202:17"
        
        if content != new_content:
            with open(filepath, "w", encoding="utf-8") as f:
                f.write(new_content)

if __name__ == "__main__":
    main()
