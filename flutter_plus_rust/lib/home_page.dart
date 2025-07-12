import 'package:flutter/foundation.dart';
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
  late Future<String> myFuture;

  @override
  void dispose() {
    firstAddNumberController.dispose();
    secondAddNumberController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    myFuture = NativeLib.getRandomFfi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            myFuture = NativeLib.getRandomFfi();
          });
        },
        child: Icon(Icons.refresh),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(NativeLib.greetFfi()),
            FutureBuilder(
              future: myFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text('API data from Rust side: ${snapshot.data}');
                }
              },
            ),
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
