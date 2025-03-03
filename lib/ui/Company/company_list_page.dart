import 'package:flutter/material.dart';
import 'package:kitakyushu_shukatu/models/company.dart';

class CompanyListPage extends StatefulWidget {
  const CompanyListPage({Key? key}) : super(key: key);

  // 企業リストを `static` にして外部からアクセス可能にする
  static final List<Company> companies = [
    Company(
      id: '1',
      name: '株式会社テクノロジー',
      industry: 'IT・通信',
      location: '福岡県北九州市',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Company(
      id: '2',
      name: '福岡銀行',
      industry: '金融',
      location: '福岡県福岡市',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Company(
      id: '3',
      name: '九州製造株式会社',
      industry: '製造',
      location: '福岡県北九州市',
      imageUrl: 'https://via.placeholder.com/150',
    ),
  ];

  @override
  State<CompanyListPage> createState() => _CompanyListPageState();
}

class _CompanyListPageState extends State<CompanyListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('企業一覧')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: CompanyListPage.companies.length,
        itemBuilder: (context, index) {
          final company = CompanyListPage.companies[index];
          return CompanyCard(company: company);
        },
      ),
    );
  }
}

class CompanyCard extends StatelessWidget {
  final Company company;

  const CompanyCard({Key? key, required this.company}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12.0),
            ),
            child: Image.network(
              company.imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 150,
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  company.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.category, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(company.industry),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(company.location),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // 企業詳細ページへ遷移
                    },
                    child: const Text('詳細を見る'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
