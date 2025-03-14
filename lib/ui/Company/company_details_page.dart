import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kitakyushu_shukatu/models/company.dart';
import 'package:kitakyushu_shukatu/ui/favorite/favorite_manager.dart';

class CompanyDetailsPage extends StatefulWidget {
  final Company company;

  const CompanyDetailsPage({Key? key, required this.company}) : super(key: key);

  @override
  State<CompanyDetailsPage> createState() => _CompanyDetailsPageState();
}

class _CompanyDetailsPageState extends State<CompanyDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.company.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 企業画像
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                widget.company.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.business,
                      size: 50,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // 企業名
            Text(
              widget.company.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // 業種
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.category, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '業種: ${widget.company.industry}',
                    style: const TextStyle(fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // 所在地（`,` の後で改行）
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: _splitLocation(widget.company.location),
                    ),
                    style: const TextStyle(fontSize: 16),
                    softWrap: true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // お気に入りボタン
            Consumer<FavoriteManager>(
              builder: (context, favoriteManager, child) {
                final isFavorite = favoriteManager.isFavorite(widget.company);
                return ElevatedButton.icon(
                  onPressed: () {
                    favoriteManager.toggleFavorite(widget.company);
                  },
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                  label: Text(isFavorite ? 'お気に入りから削除' : 'お気に入りに追加'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ `,` の後で改行する関数
  List<TextSpan> _splitLocation(String location) {
    List<TextSpan> spans = [];
    RegExp regex = RegExp(r','); // `,` の後で改行
    Iterable<Match> matches = regex.allMatches(location);

    if (matches.isEmpty) {
      // `,` がなければそのまま表示
      return [TextSpan(text: location)];
    }

    int lastIndex = 0;
    for (var match in matches) {
      spans.add(TextSpan(text: location.substring(lastIndex, match.end))); // `,` まで追加
      spans.add(const TextSpan(text: '\n', style: TextStyle(height: 0.8))); // 改行
      lastIndex = match.end; // `,` の後から次のテキストを取得
    }
    spans.add(TextSpan(text: location.substring(lastIndex))); // 残りのテキストを追加

    return spans;
  }
}
