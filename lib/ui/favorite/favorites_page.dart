import 'package:flutter/material.dart';
import 'package:kitakyushu_shukatu/ui/company/company_details_page.dart';
import 'package:provider/provider.dart';
import 'package:kitakyushu_shukatu/ui/favorite/favorite_manager.dart';
import 'package:kitakyushu_shukatu/models/company.dart';

class FavoritesPage extends StatefulWidget {
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  Future<void> _fetchFavorites() async {
    final favoriteManager = context.read<FavoriteManager>();
    await favoriteManager.fetchFavoriteCompanies();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteCompanies =
        context.watch<FavoriteManager>().favoriteCompanies;

    return Scaffold(
      appBar: AppBar(title: const Text('お気に入り企業')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : favoriteCompanies.isEmpty
              ? const Center(child: Text('お気に入りの企業がありません'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: favoriteCompanies.length,
                  itemBuilder: (context, index) {
                    final company = favoriteCompanies[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(company.imageUrl),
                        backgroundColor: Colors.pink[100],
                      ),
                      title: Text(company.name),
                      subtitle: Text(company.industry ?? '未設定'),
                      trailing: _buildProgressDropdown(context, company),
                      onTap: () {
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

  /// ✅ 進行度タグのドロップダウンメニュー
  Widget _buildProgressDropdown(BuildContext context, Company company) {
    final favoriteManager = context.read<FavoriteManager>();

    return DropdownButton<String>(
      value: company.progress ?? '進行度',
      icon: const Icon(Icons.timer_outlined),
      items: const [
        DropdownMenuItem(value: '進行度', child: Text('進行度')),
        DropdownMenuItem(value: 'ES提出前', child: Text('ES提出前')),
        DropdownMenuItem(value: 'ES提出中', child: Text('ES提出中')),
        DropdownMenuItem(value: '適性テスト受験済み', child: Text('適性テスト受験済み')),
        DropdownMenuItem(value: '1次試験', child: Text('1次試験')),
        DropdownMenuItem(value: '2次試験', child: Text('2次試験')),
        DropdownMenuItem(value: '内定', child: Text('内定')),
      ],
      onChanged: (newValue) {
        if (newValue != null) {
          favoriteManager.updateProgress(company, newValue);
        }
      },
    );
  }
}
