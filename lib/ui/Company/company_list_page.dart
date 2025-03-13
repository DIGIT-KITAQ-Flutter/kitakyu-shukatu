import 'package:flutter/material.dart';
import 'package:kitakyushu_shukatu/ui/company/company_details_page.dart';
import 'package:provider/provider.dart';
import 'package:kitakyushu_shukatu/models/company.dart';
import 'package:kitakyushu_shukatu/ui/favorite/favorite_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyListPage extends StatefulWidget {
  CompanyListPage({Key? key}) : super(key: key);
  static final List<Company> companies = [];

  @override
  State<CompanyListPage> createState() => _CompanyListPageState();
}

class _CompanyListPageState extends State<CompanyListPage> {
  @override
  void initState() {
    super.initState();
    if (CompanyListPage.companies.isEmpty) {
      print('Fetching companies...');
      _fetchCompany();
    }
  }

  Future<void> _fetchCompany() async {
    List<Company> companiesList = [];
    try {
      final companies =
          await FirebaseFirestore.instance.collection('companies').get();

      // データ確認用のログ
      print('Documents count: ${companies.docs.length}');

      companies.docs.forEach((company) {
        // データの型を確認
        Map<String, dynamic> data = company.data();
        // print('Company data: $data');

        // locationフィールドの処理
        String locationStr;
        if (data['location'] is GeoPoint) {
          GeoPoint geoPoint = data['location'];
          locationStr = '${geoPoint.latitude}, ${geoPoint.longitude}';
        } else if (data['location'] is String) {  
          locationStr = data['location'];
        } else {
          locationStr = '未設定';
        }

        companiesList.add(
          Company(
            id: company.id,
            name: data['name'] ?? '名称未設定',
            industry: data['d_inlineblock'] ?? '未設定',
            location: locationStr,
            imageUrl: data['imageUrl'] ?? '',
          ),
        );
      });

      print('Fetched ${companiesList.length} companies');
      setState(() {
        print('Setting companies...');
        CompanyListPage.companies.addAll(companiesList);
      });
    } catch (e) {
      print('Error fetching companies: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('企業一覧')),
      body:
          CompanyListPage.companies.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
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
    final favoriteManager = context.watch<FavoriteManager>();
    final isFavorite = favoriteManager.isFavorite(company);

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
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
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.white,
                  ),
                  onPressed: () {
                    favoriteManager.toggleFavorite(company);
                  },
                ),
              ),
            ],
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
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Icon(Icons.category, color: Colors.grey, size: 16),
    SizedBox(width: 8),
    Expanded( // 追加: 業種名を折り返すために Expanded を使用
      child: Text(
        company.industry ?? '未設定',
        style: TextStyle(fontSize: 14),
        maxLines: 2, // 2行まで表示
        overflow: TextOverflow.ellipsis, // 超えたら「...」を表示
        softWrap: true, // 自然な改行を許可
      ),
    ),
  ],
),

                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // 企業詳細ページへ遷移（会社情報を渡す）
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => CompanyDetailsPage(company: company),
                        ),
                      );
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
