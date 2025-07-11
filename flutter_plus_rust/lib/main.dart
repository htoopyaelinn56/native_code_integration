import 'package:flutter/material.dart';
import 'home_page.dart';
import 'native_lib.dart';

void main() {
  NativeLib.init();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final firstAddNumberController = TextEditingController();
  final secondAddNumberController = TextEditingController();

  @override
  void dispose() {
    firstAddNumberController.dispose();
    secondAddNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}
