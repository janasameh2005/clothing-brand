import '../models/settings_model.dart';

class SettingsService {
  Future<SettingsResponse> fetchSettings() async {
    // الـ JSON بتاعك
    String jsonString = '''
    {
        "header_bar": {
            "brand_name": "Drapia",
            "title": "Settings",
            "show_back_button": true,
            "logo_url": "https://i.ibb.co/qY080Xsc/icons8-sewing-100-2.png"
        },
        "user_header": {
            "name": "Jana",
            "email": "jana@drapia.com",
            "profile_picture": "https://i.ibb.co/Mxs9svkc/Ellipse-1.png",
            "action_button": {
                "text": "Log out",
                "target_api": "/api/logout/"
            }
        },
        "sections": [
            {
                "title": "Account Settings",
                "items": [
                    {"label": "Edit profile", "type": "navigation", "target": "EditProfileScreen", "icon": "chevron_down"},
                    {"label": "Change password", "type": "navigation", "target": "ChangePasswordScreen", "icon": "chevron_down"},
                    {"label": "Add a payment method", "type": "action", "target": "AddPaymentScreen", "icon": "plus_circle"},
                    {"label": "Notifications", "type": "toggle", "key": "notifications_enabled", "default_value": true},
                    {"label": "Language", "type": "navigation", "target": "LanguageScreen"}
                ]
            },
            {
                "title": "More",
                "items": [
                    {"label": "About us", "type": "navigation", "target": "AboutUsScreen", "icon": "chevron_down"},
                    {"label": "Privacy policy", "type": "navigation", "target": "PrivacyPolicyScreen", "icon": "chevron_down"}
                ]
            }
        ],
        "navigation_footer": []
    }
    ''';

    await Future.delayed(const Duration(seconds: 1)); // محاكاة للتحميل
    return settingsResponseFromJson(jsonString);
  }
}