import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 40),
              Expanded(
                flex: 2,
                child: Container(
                  width: 600,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed('mai');
                    },
                    child: const Text(
                      '卖',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 600,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: OutlinedButton(
                  onPressed: () async {
                    final result = await BarcodeScanner.scan();
                    if (result.rawContent.isEmpty) {
                      return;
                    }
                    Get.toNamed(
                      'luru',
                      parameters: {
                        'barCode': result.rawContent,
                      },
                    );
                  },
                  child: const Text(
                    '录入',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
