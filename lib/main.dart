import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:home_service_app/views/homeView.dart';
import 'package:home_service_app/views/loginView.dart';

void main() {
  runApp(DevicePreview(
    builder: (context) => const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: loginView(),
    );
  }
}
