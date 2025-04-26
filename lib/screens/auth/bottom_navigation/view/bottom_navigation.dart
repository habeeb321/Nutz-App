import 'package:flutter/material.dart';
import 'package:nutz_app/screens/auth/bottom_navigation/controller/bottom_nav_controller.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BottomNavController>(context);
    final theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: controller.screens[controller.selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: theme.bottomNavigationBarTheme.backgroundColor ??
            theme.cardTheme.color,
        selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor ??
            theme.colorScheme.primary,
        unselectedItemColor:
            theme.bottomNavigationBarTheme.unselectedItemColor ??
                theme.colorScheme.onSurface.withOpacity(0.6),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_filled,
              size: size.height * 0.03,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.card_travel,
              size: size.height * 0.03,
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_4_outlined,
              size: size.height * 0.03,
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: controller.selectedIndex,
        onTap: controller.onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: size.height * 0.014),
        unselectedLabelStyle: TextStyle(fontSize: size.height * 0.014),
        elevation: 100,
        selectedIconTheme: IconThemeData(
          color: theme.bottomNavigationBarTheme.selectedItemColor ??
              theme.colorScheme.primary,
        ),
        unselectedIconTheme: IconThemeData(
          color: theme.bottomNavigationBarTheme.unselectedItemColor ??
              theme.colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
    );
  }
}
