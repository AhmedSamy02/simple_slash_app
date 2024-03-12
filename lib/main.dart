import 'package:flutter/material.dart';
import 'package:simple_slash_app/constants.dart';
import 'package:simple_slash_app/views/home_screen.dart';
import 'package:simple_slash_app/views/product_details_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      routes: {
        kHomeScreen: (context) => const HomeScreen(),
        kProductDetailsScreen: (context) => const ProductDetailsScreen(),
      },
      initialRoute: kHomeScreen,
    );
  }
}
