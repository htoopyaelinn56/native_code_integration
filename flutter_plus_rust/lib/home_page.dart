import 'package:flutter/material.dart';

import 'native_lib.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(NativeLib.greetFfi()),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: TextField(
                    controller: firstAddNumberController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: secondAddNumberController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final firstNumber =
                        int.tryParse(firstAddNumberController.text) ?? 0;
                    final secondNumber =
                        int.tryParse(secondAddNumberController.text) ?? 0;
                    final sum = NativeLib.addFfi(firstNumber, secondNumber);
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Sum: $sum')));
                  },
                  child: Text('Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
