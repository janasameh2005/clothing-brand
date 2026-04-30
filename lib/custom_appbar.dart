import 'package:clothing_brand/settings.dart';
import 'package:flutter/material.dart';
import 'assets.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  final bool showArrowBack;

  final bool settings;

  final bool languageNotification;

  final bool isSearching;

  final VoidCallback? onSearchTap;

  final VoidCallback? onCloseSearch;

  final ValueChanged<String>? onSearchChanged;

  final VoidCallback? onBackTap;



  const CustomAppBar({

    super.key,

    this.showArrowBack = false,

    this.settings = false,

    this.languageNotification = false,

    this.isSearching = false,

    this.onSearchTap,

    this.onCloseSearch,

    this.onSearchChanged,

    this.onBackTap,

  });



  @override

  Widget build(BuildContext context) {

    return AppBar(

      centerTitle: true,

      backgroundColor: const Color(0xFFF5EFD2),

      elevation: 0,

      leading: isSearching

          ? IconButton(

        icon: const Icon(Icons.close, color: Colors.black),

        onPressed: onCloseSearch,

      )

          : (showArrowBack

          ? IconButton(

        icon: const Icon(Icons.arrow_back, color: Colors.black),

        onPressed: onBackTap ?? () => Navigator.pop(context),

      )

          : IconButton(

        icon: const Icon(Icons.search_outlined, color: Colors.black),

        onPressed: onSearchTap,

      )),

      title: isSearching

          ? TextField(

        autofocus: true,

        decoration: const InputDecoration(

          hintText: "Search for products...",

          border: InputBorder.none,

        ),

        onChanged: onSearchChanged,

      )

          : Row(

        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Text("Drapia", style: TextStyle(color: Colors.black, fontFamily: 'serif', fontWeight: FontWeight.bold)),
          SizedBox(width: 5),
          SizedBox(
            width: 30,
            height: 30,
            child: Image.asset(Asset.appbarIcon2,
            ),

          )
        ],

      ),

      actions: [

        if (!isSearching) ...[

          if (settings)

            IconButton(icon: const Icon(Icons.settings, color: Colors.black), onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen()));
            })

          else if (languageNotification)

            Container(

              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),

              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),

              child: const Row(

                children: [

                  Icon(Icons.notifications_none_outlined, color: Colors.black, size: 20),

                  SizedBox(width: 10),

                  Icon(Icons.language, color: Colors.black, size: 20),

                ],

              ),

            ),

        ]

      ],

    );

  }



  @override

  Size get preferredSize => const Size.fromHeight(60);

}