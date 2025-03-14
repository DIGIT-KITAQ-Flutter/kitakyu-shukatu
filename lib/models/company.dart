// 企業データのモデルクラス
class Company {
  final String id;
  final String name;
  final String? industry;
  final String location;
  final String imageUrl;
String progress; 

  Company({
    required this.id,
    required this.name,
    this.industry,
    required this.location,
    required this.imageUrl,
     this.progress = '進行度', 
  });
}
