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
      backgroundColor: Colors.lightBlue[50], // 背景色を薄い水色に統一
      appBar: AppBar(
        title: const Text(
          "北九就",
          style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold), // タイトルを大きく
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true, // タイトルを中央配置
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
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // 角丸
                ),
                elevation: 5, // 影をつけて立体感を出す
                textStyle: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              child: const Text("北九州マップ", style: TextStyle(color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }
}
