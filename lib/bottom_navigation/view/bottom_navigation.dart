import 'package:flutter/material.dart';
import 'package:nutz_app/bottom_navigation/controller/bottom_nav_controller.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BottomNavController>(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: controller.screens[controller.selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
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
        elevation: 50,
      ),
    );
  }
}
