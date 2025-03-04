import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kitakyushu_shukatu/ui/favorite/favorite_manager.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteCompanies = context.watch<FavoriteManager>().favoriteCompanies;

    return Scaffold(
      appBar: AppBar(title: const Text('お気に入り')),
      body: favoriteCompanies.isEmpty
          ? const Center(child: Text('お気に入りの企業がありません'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: favoriteCompanies.length,
              itemBuilder: (context, index) {
                final company = favoriteCompanies[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.pink[100],
                    child: Text(company.name[0]), // 頭文字
                  ),
                  title: Text(company.name),
                  subtitle: Text(company.industry),
                );
              },
            ),
    );
  }
}
