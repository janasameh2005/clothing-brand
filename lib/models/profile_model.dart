import 'dart:convert';

ProfileResponse profileResponseFromJson(String str) => ProfileResponse.fromJson(json.decode(str));

String profileResponseToJson(ProfileResponse data) => json.encode(data.toJson());

class ProfileResponse {
  HeaderBar headerBar;
  UserInfo userInfo;
  List<MenuSection> menuSections;
  List<NavigationFooter> navigationFooter;

  ProfileResponse({
    required this.headerBar,
    required this.userInfo,
    required this.menuSections,
    required this.navigationFooter,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) => ProfileResponse(
    headerBar: HeaderBar.fromJson(json["header_bar"]),
    userInfo: UserInfo.fromJson(json["user_info"]),
    menuSections: List<MenuSection>.from(json["menu_sections"].map((x) => MenuSection.fromJson(x))),
    navigationFooter: List<NavigationFooter>.from(json["navigation_footer"].map((x) => NavigationFooter.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "header_bar": headerBar.toJson(),
    "user_info": userInfo.toJson(),
    "menu_sections": List<dynamic>.from(menuSections.map((x) => x.toJson())),
    "navigation_footer": List<dynamic>.from(navigationFooter.map((x) => x.toJson())),
  };
}

class HeaderBar {
  String brandName;
  String title;
  bool showBackButton;
  String settingsIcon;
  String logoUrl;

  HeaderBar({
    required this.brandName,
    required this.title,
    required this.showBackButton,
    required this.settingsIcon,
    required this.logoUrl,
  });

  factory HeaderBar.fromJson(Map<String, dynamic> json) => HeaderBar(
    brandName: json["brand_name"],
    title: json["title"],
    showBackButton: json["show_back_button"],
    settingsIcon: json["settings_icon"],
    logoUrl: json["logo_url"],
  );

  Map<String, dynamic> toJson() => {
    "brand_name": brandName,
    "title": title,
    "show_back_button": showBackButton,
    "settings_icon": settingsIcon,
    "logo_url": logoUrl,
  };
}

class MenuSection {
  List<Item> items;

  MenuSection({
    required this.items,
  });

  factory MenuSection.fromJson(Map<String, dynamic> json) => MenuSection(
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class Item {
  String label;
  String target;
  String icon;

  Item({
    required this.label,
    required this.target,
    required this.icon,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    label: json["label"],
    target: json["target"],
    icon: json["icon"],
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "target": target,
    "icon": icon,
  };
}

class NavigationFooter {
  String id;
  String label;
  String iconInactive;
  String iconActive;
  String target;

  NavigationFooter({
    required this.id,
    required this.label,
    required this.iconInactive,
    required this.iconActive,
    required this.target,
  });

  factory NavigationFooter.fromJson(Map<String, dynamic> json) => NavigationFooter(
    id: json["id"],
    label: json["label"],
    iconInactive: json["icon_inactive"],
    iconActive: json["icon_active"],
    target: json["target"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "label": label,
    "icon_inactive": iconInactive,
    "icon_active": iconActive,
    "target": target,
  };
}

class UserInfo {
  String name;
  String email;
  String profilePicture;
  String updatePhotoText;

  UserInfo({
    required this.name,
    required this.email,
    required this.profilePicture,
    required this.updatePhotoText,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    name: json["name"],
    email: json["email"],
    profilePicture: json["profile_picture"],
    updatePhotoText: json["update_photo_text"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "profile_picture": profilePicture,
    "update_photo_text": updatePhotoText,
  };
}