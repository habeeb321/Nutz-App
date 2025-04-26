import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nutz_app/home_screen/model/home_model.dart';

class HomeService {
  static final Dio dio = Dio();

  static Future<HomeModel?> getIphoneData() async {
    try {
      Response response = await dio.get(
        'https://nutz-server-2.onrender.com/api/iphones',
      );

      if (response.statusCode == 200 && response.data != null) {
        debugPrint('Success: ${response.data}');
        return HomeModel.fromJson(response.data);
      } else {
        debugPrint('HTTP Error: Status code ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('getIphoneData Error : $e');
    }
    return null;
  }
}
