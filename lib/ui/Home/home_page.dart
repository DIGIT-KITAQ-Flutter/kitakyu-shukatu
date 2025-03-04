import 'package:flutter/material.dart';
import 'package:kitakyushu_shukatu/models/company.dart';
import 'package:kitakyushu_shukatu/ui/Company/company_list_page.dart';
import 'package:kitakyushu_shukatu/ui/map/map_page.dart'; // map_page.dart をインポート

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Company> companies;

  @override
  void initState() {
    super.initState();
    companies = List.from(CompanyListPage.companies); // 修正
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("北九就"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // 企業の横スクロールリストを `Expanded` で適切に配置
          Expanded(
            child: SizedBox(
              height: 200, // 高さを確保
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: companies.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      width: 250,
                      child: CompanyCard(company: companies[index]),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20), // 余白を調整
          // 北九州マップボタン
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                textStyle: const TextStyle(fontSize: 18),
                backgroundColor: Colors.grey[300], // 背景色を画像に合わせる
              ),
              child: const Text("北九州マップ", style: TextStyle(color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }
}
