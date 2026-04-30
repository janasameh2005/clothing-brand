import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final Function(int) onTabSelected;
  final int selectedIndex;

  const CustomBottomNavBar({
    super.key,
    required this.onTabSelected,
    required this.selectedIndex,
  });

  IconData _getIcon(int index, bool isSelected) {
    switch (index) {
      case 0: return isSelected ? Icons.home : Icons.home_outlined;
      case 1: return isSelected ? Icons.favorite : Icons.favorite_border_outlined;
      case 2: return isSelected ? Icons.auto_awesome : Icons.auto_awesome_outlined;
      case 3: return isSelected ? Icons.grid_view_rounded : Icons.grid_view_outlined;
      case 4: return isSelected ? Icons.shopping_cart : Icons.shopping_cart_outlined;
      case 5: return isSelected ? Icons.person : Icons.person_outline;
      default: return Icons.home;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      decoration: const BoxDecoration(
        color: Color(0xFFFDFBEC),
        border: Border(top: BorderSide(color: Colors.black12, width: 0.5)),
      ),
      child: Row(
        children: [
          _buildNavItem(0, "Home"),
          _buildNavItem(1, "Wish List"),
          _buildNavItem(2, "New"),
          _buildNavItem(3, "Collections"),
          _buildNavItem(4, "Cart"),
          _buildNavItem(5, "Profile"),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String label) {
    bool isSelected = selectedIndex == index;
    const Color activeColor = Color(0xFF1E1E1E);
    const Color inactiveColor = Colors.black87;

    return Expanded(
      child: InkWell(
        onTap: () => onTabSelected(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getIcon(index, isSelected),
              size: 26,
              color: isSelected ? activeColor : inactiveColor,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}