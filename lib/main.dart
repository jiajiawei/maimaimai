import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maimaimai/capture_page.dart';
import 'package:maimaimai/data_store.dart';
import 'package:maimaimai/home_page.dart';
import 'package:maimaimai/luru.dart';
import 'package:maimaimai/mai.dart';

late DataStore objectBox;
late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  objectBox = await DataStore.create();
  cameras = await availableCameras();

  runApp(const MaiMaiMaiApp());
}

class MaiMaiMaiApp extends StatelessWidget {
  const MaiMaiMaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '卖卖卖',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Microsoft YaHei',
        useMaterial3: true,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const HomePage(title: '卖卖卖'),
        ),
        GetPage(
          name: '/luru',
          page: () => const Luru(),
        ),
        GetPage(
          name: '/mai',
          page: () => const Mai(),
        ),
        GetPage(
          name: '/capture',
          page: () => const CapturePage(),
        ),
      ],
      home: const HomePage(title: '卖卖卖'),
    );
  }
}
