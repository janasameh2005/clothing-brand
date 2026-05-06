import 'dart:convert';

SettingsResponse settingsResponseFromJson(String str) => SettingsResponse.fromJson(json.decode(str));

class SettingsResponse {
  HeaderBar headerBar;
  UserHeader userHeader;
  List<Section> sections;
  List<NavigationFooter> navigationFooter;

  SettingsResponse({
    required this.headerBar,
    required this.userHeader,
    required this.sections,
    required this.navigationFooter,
  });

  factory SettingsResponse.fromJson(Map<String, dynamic> json) => SettingsResponse(
    headerBar: HeaderBar.fromJson(json["header_bar"]),
    userHeader: UserHeader.fromJson(json["user_header"]),
    sections: List<Section>.from(json["sections"].map((x) => Section.fromJson(x))),
    navigationFooter: List<NavigationFooter>.from(json["navigation_footer"].map((x) => NavigationFooter.fromJson(x))),
  );
}

class HeaderBar {
  String brandName;
  String title;
  bool showBackButton;
  String logoUrl;

  HeaderBar({required this.brandName, required this.title, required this.showBackButton, required this.logoUrl});

  factory HeaderBar.fromJson(Map<String, dynamic> json) => HeaderBar(
    brandName: json["brand_name"],
    title: json["title"],
    showBackButton: json["show_back_button"],
    logoUrl: json["logo_url"],
  );
}

class Section {
  String title;
  List<Item> items;

  Section({required this.title, required this.items});

  factory Section.fromJson(Map<String, dynamic> json) => Section(
    title: json["title"],
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
  );
}

class Item {
  String label;
  String type;
  String? target;
  String? icon;
  String? key;
  bool? defaultValue;

  Item({required this.label, required this.type, this.target, this.icon, this.key, this.defaultValue});

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    label: json["label"],
    type: json["type"],
    target: json["target"],
    icon: json["icon"],
    key: json["key"],
    defaultValue: json["default_value"],
  );
}

class UserHeader {
  String name;
  String email;
  String profilePicture;
  ActionButton actionButton;

  UserHeader({required this.name, required this.email, required this.profilePicture, required this.actionButton});

  factory UserHeader.fromJson(Map<String, dynamic> json) => UserHeader(
    name: json["name"],
    email: json["email"],
    profilePicture: json["profile_picture"],
    actionButton: ActionButton.fromJson(json["action_button"]),
  );
}

class ActionButton {
  String text;
  String targetApi;

  ActionButton({required this.text, required this.targetApi});

  factory ActionButton.fromJson(Map<String, dynamic> json) => ActionButton(
    text: json["text"],
    targetApi: json["target_api"],
  );
}

class NavigationFooter {
  String id;
  String label;
  String iconInactive;
  String iconActive;
  String target;

  NavigationFooter({required this.id, required this.label, required this.iconInactive, required this.iconActive, required this.target});

  factory NavigationFooter.fromJson(Map<String, dynamic> json) => NavigationFooter(
    id: json["id"],
    label: json["label"],
    iconInactive: json["icon_inactive"],
    iconActive: json["icon_active"],
    target: json["target"],
  );
}