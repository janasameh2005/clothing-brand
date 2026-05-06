import 'package:flutter/material.dart';
import '../models/settings_model.dart';
import 'package:clothing_brand/apptheme.dart';
import 'package:clothing_brand/custom_bottom_navigation_bar.dart';
import 'api_service/settings_service.dart';
import 'custom_appbar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SettingsResponse? _settings;
  bool _isLoading = true;
  bool _isNotificationEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    try {
      final data = await SettingsService().fetchSettings();
      setState(() {
        _settings = data;
        _isLoading = false;
        // استخراج قيمة الـ Toggle من الداتا
        for (var section in data.sections) {
          for (var item in section.items) {
            if (item.key == "notifications_enabled") {
              _isNotificationEnabled = item.defaultValue ?? true;
            }
          }
        }
      });
    } catch (e) {
      print("Error loading data: \$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Color(0xFF4D0C0C))));
    }

    return Scaffold(
      appBar: CustomAppBar(showArrowBack: _settings!.headerBar.showBackButton),
      bottomNavigationBar: CustomBottomNavBar(
        onTabSelected: (index) {},
        selectedIndex: 4,
      ),
      backgroundColor: const Color(0xFFF5EFD2),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              _settings!.headerBar.title,
              style: const TextStyle(fontSize: 26, fontFamily: 'Serif', fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),

            // User Header Card
            _buildUserCard(),

            const SizedBox(height: 25),

            // Sections Container
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Apptheme.greyText),
                ),
                child: Column(
                  children: _settings!.sections.map((section) => _buildSection(section)).toList(),
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard() {
    var user = _settings!.userHeader;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFF5EFD2).withOpacity(0.5),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Apptheme.greyText),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(user.profilePicture),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(user.email, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () => print("Logout from: \${user.actionButton.targetApi}"),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Apptheme.greyText),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Text(user.actionButton.text, style: const TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(Section section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 15, bottom: 5),
          child: Text(section.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        ...section.items.map((item) => _buildItemTile(item)).toList(),
        if (_settings!.sections.last != section)
          Divider(color: Apptheme.greyText, thickness: 1.2),
      ],
    );
  }

  Widget _buildItemTile(Item item) {
    if (item.type == "toggle") {
      return SwitchListTile(
        title: Text(item.label),
        value: _isNotificationEnabled,
        activeColor: const Color(0xFF4D0C0C),
        onChanged: (val) => setState(() => _isNotificationEnabled = val),
      );
    }

    Widget? trailing;
    if (item.icon == "plus_circle") {
      trailing = const Icon(Icons.add_circle, color: Color(0xFF4D0C0C), size: 30);
    } else if (item.icon == "chevron_down") {
      trailing = const Icon(Icons.keyboard_arrow_down, color: Color(0xFF4D0C0C));
    }

    return ListTile(
      title: Text(item.label),
      trailing: trailing,
      onTap: () => print("Navigate to: \${item.target}"),
    );
  }
}