import 'package:flutter/material.dart';
import 'package:nutz_app/home_screen/model/home_model.dart';
import 'package:nutz_app/home_screen/service/home_service.dart';

class HomeController with ChangeNotifier {
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';
  HomeModel? homeData;

  Future<void> fetchIphoneData() async {
    try {
      isLoading = true;
      hasError = false;
      errorMessage = '';
      notifyListeners();

      final data = await HomeService.getIphoneData();

      if (data != null) {
        homeData = data;
      } else {
        hasError = true;
        errorMessage = 'Failed to load data';
      }
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
      debugPrint('Error in controller: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
