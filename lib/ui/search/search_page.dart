import 'package:flutter/material.dart';
import 'package:kitakyushu_shukatu/ui/Company/company_list_page.dart'; // 企業一覧のデータを使う

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<String> _allCompanies = []; // 企業一覧データ
  List<String> _filteredCompanies = []; // 検索結果

  @override
  void initState() {
    super.initState();
    _loadCompanies();
  }

  // 企業一覧のデータを取得
  void _loadCompanies() {
    setState(() {
      _allCompanies = CompanyListPage.companies.map((company) => company.name).toList(); // 企業データを取得
      _filteredCompanies = List.from(_allCompanies);
    });
  }

  // 検索処理
  void _filterCompanies(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCompanies = List.from(_allCompanies);
      } else {
        _filteredCompanies = _allCompanies
            .where((company) => company.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50], // **背景色を淡いピンクに**
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('検索'),
      ),
      body: Column(
        children: [
          // **検索バー + 追加ボタン**
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: '企業名を検索',
                      prefixIcon: Icon(Icons.search, color: Colors.purple),
                      filled: true,
                      fillColor: Colors.purple[50], // **淡い紫の背景**
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: _filterCompanies,
                  ),
                ),
                const SizedBox(width: 8),
                // **追加ボタン**
                Container(
                  decoration: BoxDecoration(
                    color: Colors.purple[100], // **ボタンの背景**
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      // 追加ボタンの処理（例えば、新しい企業追加画面へ）
                    },
                  ),
                ),
              ],
            ),
          ),

          // **企業リスト表示**
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCompanies.length,
              itemBuilder: (context, index) {
                String companyName = _filteredCompanies[index];
                String firstLetter = companyName.isNotEmpty ? companyName[0] : '?'; // **頭文字を取得**

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.purple[100], // **アイコン背景**
                    child: Text(
                      firstLetter, // **企業名の頭文字を表示**
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(companyName),
                  onTap: () {
                    // 企業詳細ページへ遷移（未実装）
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
