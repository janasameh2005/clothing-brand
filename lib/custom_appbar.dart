import 'package:clothing_brand/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showArrowBack;
  final bool settings;
  final bool languageNotification;
   CustomAppBar({this.showArrowBack=false,this.settings=false,this.languageNotification=false});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
           Asset.appbarIcon1, // مسار اللوجو بتاعك

          ),
          SizedBox(
            width: 30,
            height: 30,
            child: Image.asset(Asset.appbarIcon2,
             ),
          )
        ],
      ),
      backgroundColor: Color(0xFFF5EFD2),
      leading:showArrowBack?IconButton(onPressed:(){}, icon:Icon(Icons.arrow_back)):IconButton(onPressed:(){}, icon:Icon(Icons.search_outlined)),
      actions: [if (settings)
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => print("Settings clicked"),
            child: const Icon(Icons.settings, color: Color(0xFF1E1E1E)),
          ),
        )
    else if (languageNotification)
        Container(
          padding: EdgeInsets.symmetric(horizontal:8, vertical: 4),
          margin: EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // الأيقونة الأولى
              GestureDetector(
                onTap: () => print("Notification clicked"),
                child: Icon(Icons.notifications_none_outlined, color: Color(0xFF1E1E1E)),
              ),

              // المسافة اللي بينهم - تقدري تخليها 0 لو حابة
              SizedBox(width: 16),

              // الأيقونة الثانية
              GestureDetector(
                onTap: () => print("Language clicked"),
                child: Icon(Icons.language, color: Color(0xFF1E1E1E)),
              ),
            ],
          ),
        )
      ],
        );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}