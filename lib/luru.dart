import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:maimaimai/main.dart';
import 'package:maimaimai/objectbox.g.dart';
import 'package:maimaimai/product.dart';

class Luru extends StatefulWidget {
  const Luru({super.key});

  @override
  State<Luru> createState() => _LuruState();
}

class _LuruState extends State<Luru> {
  bool create = true;
  String barCode = '';
  int productId = 0;
  TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    barCode = Get.parameters['barCode']?.toString() ?? '';
  }

  Future loadProduct() async {
    final box = objectBox.store.box<Product>();
    final product = await box
        .query(Product_.barCode.equals(barCode))
        .build()
        .findFirstAsync();
    if (product != null) {
      productId = product.id;
      priceController.text = product.price.toString();
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('录入商品'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder(
          future: loadProduct(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(
                      width: 100,
                      child: Text(
                        '码:',
                        style: TextStyle(),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(barCode),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(
                      width: 100,
                      child: Text('价格:'),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: priceController,
                      ),
                    ),
                    const Text('元')
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 100,
                      child: Text('图片:'),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 200,
                      height: 200,
                      color: Colors.blue[200],
                    ),
                  ],
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: handleSave,
                  child: const Text('保存'),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: handleReadd,
        tooltip: '再添加',
        child: const Icon(Icons.add),
      ),
    );
  }

  handleSave() async {
    final box = objectBox.store.box<Product>();
    if (create) {
      final newProduct = Product(barCode)
        ..price = double.parse(priceController.text);
      await box.putAsync(newProduct);
    } else {
      final newProduct = Product(barCode)
        ..id = productId
        ..price = double.parse(priceController.text);
      await box.putAsync(newProduct);
    }
  }

  handleReadd() async {
    if (kDebugMode) {
      Get.offAndToNamed(
        'luru',
        parameters: {
          'barCode': '6923450657936',
        },
      );
      return;
    }

    await handleSave();
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
  }
}
