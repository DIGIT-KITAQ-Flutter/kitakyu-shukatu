import 'package:flutter/material.dart';
import 'package:kitakyushu_shukatu/ui/company/company_details_page.dart';
import 'package:provider/provider.dart';
import 'package:kitakyushu_shukatu/ui/favorite/favorite_manager.dart';

class FavoritesPage extends StatefulWidget {
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  bool _isLoading = true; // ローディング状態管理

  @override
  void initState() {
    super.initState();
    _fetchFavorites(); // Firestoreからお気に入り企業を取得
  }

  /// Firestoreからお気に入り企業を取得する関数
  Future<void> _fetchFavorites() async {
    final favoriteManager = context.read<FavoriteManager>();
    await favoriteManager.fetchFavoriteCompanies();
    setState(() {
      _isLoading = false; // ローディング終了
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteCompanies =
        context.watch<FavoriteManager>().favoriteCompanies;

    return Scaffold(
      appBar: AppBar(title: const Text('お気に入り企業')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // ローディング中
          : favoriteCompanies.isEmpty
              ? const Center(child: Text('お気に入りの企業がありません'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: favoriteCompanies.length,
                  itemBuilder: (context, index) {
                    final company = favoriteCompanies[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.pink[100],
                        backgroundImage: NetworkImage(company.imageUrl),
                        onBackgroundImageError: (_, __) {
                          // Handle the error, e.g., log it or set a flag
                        },
                      ),
                      title: Text(company.name),
                      subtitle: Text(company.industry ?? '未設定'),
                      onTap: () {
                        // 詳細画面に遷移
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CompanyDetailsPage(company: company),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
