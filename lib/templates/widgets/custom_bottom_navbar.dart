import 'package:flutter/material.dart';
import 'package:share_learning/templates/managers/color_manager.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _currentIndex = 0;

  List<Map<String, dynamic>> navItems = [
    {
      'icon': Icons.home,
      'label': 'Home',
    },
    {
      'icon': Icons.favorite,
      'label': 'Wishlist',
    },
    {
      'icon': Icons.person,
      'label': 'Profile',
    },
    {
      'icon': Icons.shopping_cart,
      'label': 'Cart',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.0,
            spreadRadius: 1.0,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
              navItems.length,
              (index) => _buildBottomNavigationBarItem(
                  navItems[index]['icon'], navItems[index]['label'], index))),
    );
  }

  Widget _buildBottomNavigationBarItem(
      IconData iconData, String label, int index) {
    final isSelected = index == _currentIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              color: isSelected ? ColorManager.primary : Colors.grey,
              size: 30,
            ),
            SizedBox(height: 1),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? ColorManager.primary : ColorManager.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
