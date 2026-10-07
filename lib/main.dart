import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:veer_gatha/firebase_options.dart';
import 'package:veer_gatha/routes/app_routes.dart';

class AppColors {
  AppColors._();

  static const Color navy = Color(0xFF102A43);
  static const Color darkNavy = Color(0xFF000E2A);
  static const Color brown = Color(0xFF9A431A);
  static const Color cream = Color(0xFFF8ECD8);
  static const Color sand = Color(0xFFF3DDBB);
  static const Color sandDark = Color(0xFFEBD9B8);
  static const Color gold = Color(0xFFC59B52);
}

final ThemeData appTheme = ThemeData(useMaterial3: true);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      routerConfig: appRoutes,
    );
  }
}
