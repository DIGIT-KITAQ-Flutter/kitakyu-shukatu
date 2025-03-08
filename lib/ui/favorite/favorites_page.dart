import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kitakyushu_shukatu/ui/favorite/favorite_manager.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoriteManager = Provider.of<FavoriteManager>(context);

    return Scaffold(
      appBar: AppBar(title: Text('お気に入り')),
      body: FutureBuilder(
        future: favoriteManager.fetchFavoriteCompanies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final favorites = favoriteManager.favoriteCompanies;
          if (favorites.isEmpty) {
            return Center(child: Text('お気に入りの企業はありません'));
          }

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final company = favorites[index];
              return ListTile(
                title: Text(company.name),
                subtitle: Text(company.industry),
              );
            },
          );
        },
      ),
    );
  }
}
