import 'package:flutter/material.dart';
import 'native_lib.dart';

void main() {
  NativeLib.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final greeting = NativeLib.greetFfi();
    final result = NativeLib.addFfi(2, 3);
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(greeting), Text('2 + 3 = $result')],
          ),
        ),
      ),
    );
  }
}
