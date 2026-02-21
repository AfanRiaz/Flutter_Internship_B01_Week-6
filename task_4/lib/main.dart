import 'package:flutter/material.dart';
import 'package:image_upload_app/upload_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const UploadImageScreen(),
    );
  }
}