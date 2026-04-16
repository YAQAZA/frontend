# Constant Rules

--------------------------------------------------
CONSTANTS MANAGEMENT
--------------------------------------------------

All constants must be centralized inside the core layer.

Never hardcode values inside UI, Cubits, services, or repositories.

Examples of constants that must be placed in core:

- Colors
- API base URLs
- API keys
- Asset paths
- Route names
- Spacing values
- Font sizes
- Dummy data
- App-wide strings

--------------------------------------------------
CORE CONSTANTS STRUCTURE
--------------------------------------------------

lib/
  core/
    constants/
      app_colors.dart
      app_strings.dart
      app_assets.dart
      app_values.dart
      api_constants.dart
      dummy_data.dart

--------------------------------------------------
COLOR RULES
--------------------------------------------------

All colors must be defined inside:

core/constants/app_colors.dart

Example:

class AppColors {
  static const primary = Color(0xFF2196F3);
  static const secondary = Color(0xFF64B5F6);
}

Never write colors directly in widgets.

Bad:
Color(0xFF2196F3)

Good:
AppColors.primary

--------------------------------------------------
API CONSTANTS
--------------------------------------------------

All API-related constants must be placed inside:

core/constants/api_constants.dart

Example:

class ApiConstants {
  static const baseUrl = "https://api.example.com";
  static const apiKey = "API_KEY";
}

--------------------------------------------------
ASSET PATHS
--------------------------------------------------

All asset paths must be centralized in:

core/constants/app_assets.dart

Example:

class AppAssets {
  static const logo = "assets/images/logo.png";
  static const profile = "assets/images/profile.png";
}

Widgets must reference assets using these constants.

--------------------------------------------------
DUMMY DATA
--------------------------------------------------

Dummy or mock data used for development must be stored inside:

core/constants/dummy_data.dart

This ensures test data is reusable and easy to remove later.

--------------------------------------------------
GENERAL RULE
--------------------------------------------------

Never hardcode values inside the UI or business logic.

Always reference constants from the core layer.