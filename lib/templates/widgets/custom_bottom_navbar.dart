import 'package:flutter/material.dart';
import 'package:share_learning/templates/managers/values_manager.dart';

import '../managers/routes_manager.dart';

// ignore: must_be_immutable
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
      'route': RoutesManager.homeScreenNewRoute,
    },
    {
      'icon': Icons.favorite,
      'label': 'Wishlist',
      'route': RoutesManager.wishlistedBooksScreenRoute,
    },
    {
      'icon': Icons.person,
      'label': 'Profile',
      'route': RoutesManager.userProfileScreenRoute,
    },
    {
      'icon': Icons.send,
      'label': 'Requests',
      'route': RoutesManager.orderRequestScreenRoute,
    },
    {
      'icon': Icons.shopping_cart,
      'label': 'Cart',
      'route': RoutesManager.cartScreenRoute,
    }
  ];

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: _theme.bottomNavigationBarTheme.backgroundColor,
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

    ThemeData _theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          widget.index = index;
        });
        Navigator.pushNamed(context, route);
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
              // color: isSelected ? ColorManager.primary : ColorManager.lightGrey,
              color: isSelected ? _theme.bottomNavigationBarTheme.selectedIconTheme!.color :_theme.bottomNavigationBarTheme.unselectedIconTheme!.color,
              size: 30,
            ),
            SizedBox(height: 1),
            Text(
              label,
              // style: TextStyle(
              // color: isSelected ? _theme.bottomNavigationBarTheme.selectedItemColor :_theme.bottomNavigationBarTheme.unselectedItemColor,
              //   fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              // ),
              style: isSelected ? _theme.bottomNavigationBarTheme.selectedLabelStyle: _theme.bottomNavigationBarTheme.unselectedLabelStyle ,
              
            ),
          ],
        ),
      ),
    );
  }
}
