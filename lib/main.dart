import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kitakyushu_shukatu/ui/Home/home_page.dart';
import 'package:kitakyushu_shukatu/ui/Company/company_list_page.dart';
import 'package:kitakyushu_shukatu/ui/MyPage/my_page.dart';
import 'package:kitakyushu_shukatu/ui/favorite/favorites_page.dart';
import 'package:kitakyushu_shukatu/ui/search/search_page.dart';
import 'package:kitakyushu_shukatu/ui/favorite/favorite_manager.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FavoriteManager(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomePage(),
    const SearchPage(),
    const CompanyListPage(),
    FavoritesPage(),
    const MyPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "ホーム"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "検索"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "企業一覧"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "お気に入り"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "マイページ"),
        ],
      ),
    );
  }
}
