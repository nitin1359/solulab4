import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solulab4/controllers/book_controller.dart';
import 'package:solulab4/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final BookController bookController = Get.put(BookController());

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'solulab4',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
