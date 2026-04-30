import 'package:clothing_brand/apptheme.dart';
import 'package:clothing_brand/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'custom_appbar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isNotificationEnabled = true;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showArrowBack: true),
      bottomNavigationBar: CustomBottomNavBar(onTabSelected: (index) {
        setState(() {
          _currentIndex = index;
        });
      }, selectedIndex: 5),
      backgroundColor: const Color(0xFFF5EFD2),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              "Settings",
              style: TextStyle(fontSize: 26, fontFamily: 'Serif', fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),

            Padding(
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
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage('assets/images/user_avatar.png'),
                    ),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("layla", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text("layla@example.com", style: TextStyle(color: Colors.black54, fontSize: 12)),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Apptheme.greyText),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text("Log out", style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Apptheme.greyText),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20, top: 15, bottom: 5),
                      child: Text("Account Settings", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                    _buildSettingItem("Edit profile", showArrow: true),
                    _buildSettingItem("Change password", showArrow: true),
                    _buildSettingItem("Add a payment method", 
                      customTrailing: const Icon(Icons.add_circle, color: Color(0xFF4D0C0C), size: 30)),
                    
                    SwitchListTile(
                      title: const Text("Notifications", style: TextStyle(fontSize: 16)),
                      value: _isNotificationEnabled,
                      activeColor: const Color(0xFF4D0C0C),
                      onChanged: (value) {
                        setState(() {
                          _isNotificationEnabled = value;
                        });
                      },
                    ),
                    _buildSettingItem("Language"),
                     Divider(
                      color: Apptheme.greyText, 
                      thickness: 1.2,
                      indent: 0, 
                      endIndent: 0,
                    ),

                    const Padding(
                      padding: EdgeInsets.only(left: 20, top: 10, bottom: 5),
                      child: Text("More", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                    _buildSettingItem("About us", showArrow: true),
                    _buildSettingItem("Privacy policy", showArrow: true),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, {bool showArrow = false, Widget? customTrailing}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: customTrailing ?? (showArrow ? const Icon(Icons.keyboard_arrow_down, color: Color(0xFF4D0C0C)) : null),
      onTap: () {},
    );
  }
}