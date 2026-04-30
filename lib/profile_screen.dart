import 'package:clothing_brand/apptheme.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFD2),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              "Profile",
              style: Apptheme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w500,
                fontFamily: 'Serif',
              ),
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
                      radius: 35,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage('assets/images/user_avatar.png'),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Layla", style: Apptheme.textTheme.titleLarge),
                          Text(
                            "layla@example.com",
                            style: Apptheme.textTheme.bodySmall?.copyWith(color: Apptheme.black),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Apptheme.greyText),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      child: const Text(
                        "Update photo",
                        style: TextStyle(color: Apptheme.black, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildListContainer(context, [
                _buildOption("Profile Details"),
                _buildOption("Order History"),
                _buildOption("Saved wishlists"),
                _buildOption("My Reviews"),
                Divider(
                  color: Apptheme.greyText,
                  thickness: 1.2,
                  indent: 0, 
                  endIndent: 0,
                ),
                
                _buildOption("Payment methods"),
                _buildOption("Help center"),
                const SizedBox(height: 10),
              ]),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildListContainer(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Apptheme.greyText),
      ),
  
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildOption(String title) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: Text(
        title,
        style: Apptheme.textTheme.bodyLarge?.copyWith(color: Apptheme.black),
      ),
      trailing: const Icon(
        Icons.keyboard_arrow_down,
        color: Apptheme.accentDark,
      ),
      onTap: () {
      },
    );
  }
}