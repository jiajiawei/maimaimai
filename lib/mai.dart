import 'dart:io';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maimaimai/data_store.dart';
import 'package:maimaimai/main.dart';
import 'package:maimaimai/objectbox.g.dart';
import 'package:maimaimai/product.dart';
import 'package:path/path.dart' as path;

class Mai extends StatefulWidget {
  const Mai({super.key});

  @override
  State<Mai> createState() => _MaiState();
}

class _MaiState extends State<Mai> {
  RxList<SaleProduct> products = RxList<SaleProduct>();

  @override
  void initState() {
    super.initState();
    handleAdd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('卖'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Obx(
                () => ListView(
                    children: products
                        .map(
                          (e) => SizedBox(
                            height: 80,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: e.product.imageFileName.isEmpty
                                      ? const Icon(
                                          Icons.image_not_supported_sharp)
                                      : Image.file(
                                          File(
                                            path.join(
                                              docsDir,
                                              e.product.imageFileName,
                                            ),
                                          ),
                                        ),
                                ),
                                const Spacer(),
                                Text('￥${e.product.price}'),
                                const SizedBox(width: 20),
                                Container(
                                  height: 24,
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () => e.count--,
                                        child: const Text('一'),
                                      ),
                                      const VerticalDivider(),
                                      Obx(() => Text(e.count.toString())),
                                      const VerticalDivider(),
                                      InkWell(
                                        onTap: () => e.count++,
                                        child: const Icon(Icons.add),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList()),
              ),
            ),
            Row(
              children: [
                Obx(
                  () => Text(
                      '合计: ￥${products.fold<double>(0, (p, e) => p + e.count * e.product.price)}'),
                ),
                const Spacer(),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: handleAdd,
        tooltip: '添加',
        child: const Icon(Icons.add),
      ),
    );
  }

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void handleAdd() async {
    final result = await BarcodeScanner.scan();
    if (result.rawContent.isEmpty) {
      return;
    }
    final barCode = result.rawContent;
    final find = products.firstWhereOrNull((e) => e.product.barCode == barCode);
    if (find != null) {
      find.count.value += 1;
      return;
    }

    final box = objectBox.store.box<Product>();
    final product = await box
        .query(Product_.barCode.equals(barCode))
        .build()
        .findFirstAsync();
    if (product == null) {
      showInSnackBar('没有该商品, 请先录入价格!');
      return;
    }
    final sp = SaleProduct(product);
    products.add(sp);
  }
}

class SaleProduct {
  RxInt count = 1.obs;
  Product product;
  SaleProduct(this.product);
}
