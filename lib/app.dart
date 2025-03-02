import 'package:flutter/material.dart';
import 'package:kitakyushu_shukatu/ui/home/home_page.dart';
import 'ui/MyPage/my_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kitakyushu-Shukatu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    );
  }
}
