import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nutz_app/bottom_navigation/controller/bottom_nav_controller.dart';
import 'package:nutz_app/core/auth_wrapper.dart';
import 'package:nutz_app/firebase_options.dart';
import 'package:nutz_app/home_screen/controller/home_controller.dart';
import 'package:nutz_app/login_screen/controller/login_controller.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginController()),
        ChangeNotifierProvider(create: (_) => BottomNavController()),
        ChangeNotifierProvider(create: (_) => HomeController()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Nutz App',
        home: AuthWrapper(),
      ),
    );
  }
}
