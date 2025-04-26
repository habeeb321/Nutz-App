import 'package:flutter/material.dart';
import 'package:nutz_app/cart_screen/cart_screen.dart';
import 'package:nutz_app/home_screen/view/home_screen.dart';
import 'package:nutz_app/profile_screen/profile_screen.dart';

class BottomNavController with ChangeNotifier {
  int selectedIndex = 0;

  List screens = [
    const HomeScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  void onItemTapped(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
