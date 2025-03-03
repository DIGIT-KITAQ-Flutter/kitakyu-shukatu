import 'package:flutter/material.dart';
import 'package:kitakyushu_shukatu/models/company.dart';
import 'package:kitakyushu_shukatu/ui/Company/company_list_page.dart';

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
    companies = List.from(CompanyListPage.companies); // `List.from` で明示的にコピー
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("北九就"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "注目企業",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 220, // カードの高さを指定
              child: ListView.builder(
                scrollDirection: Axis.horizontal, // 横スクロール
                itemCount: companies.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      width: 250, // カードの幅を指定
                      child: CompanyCard(company: companies[index]),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20), // 余白を追加
          ],
        ),
      ),
    );
  }
}
