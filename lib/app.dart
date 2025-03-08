import 'package:flutter/material.dart';
import 'package:kitakyushu_shukatu/ui/main/main_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '北九就',
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}
