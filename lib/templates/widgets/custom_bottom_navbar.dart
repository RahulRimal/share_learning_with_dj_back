import 'package:flutter/material.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/managers/values_manager.dart';
import 'package:share_learning/templates/screens/order_request_screen.dart';
import 'package:share_learning/templates/screens/user_profile_screen.dart';
import 'package:share_learning/templates/screens/wishlisted_books_screen.dart';

import '../screens/cart_screen.dart';
import '../screens/home_screen_new.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  CustomBottomNavigationBar({Key? key, required this.index}) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();

  int index;
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  List<Map<String, dynamic>> navItems = [
    {
      'icon': Icons.home,
      'label': 'Home',
      'route': HomeScreenNew.routeName,
    },
    {
      'icon': Icons.favorite,
      'label': 'Wishlist',
      'route': WishlistedBooksScreen.routeName,
    },
    {
      'icon': Icons.person,
      'label': 'Profile',
      'route': UserProfileScreen.routeName,
    },
    {
      'icon': Icons.send,
      'label': 'Requests',
      'route': OrderRequestScreen.routeName,
    },
    {
      'icon': Icons.shopping_cart,
      'label': 'Cart',
      'route': CartScreen.routeName,
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
          (index) => _buildBottomNavigationBarItem(navItems[index]['icon'],
              navItems[index]['label'], navItems[index]['route'], index),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBarItem(
      IconData iconData, String label, String route, int index) {
    final isSelected = index == widget.index;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
        setState(() {
          widget.index = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p12,
          vertical: AppPadding.p8,
        ),
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
