// 企業データのモデルクラス
class Company {
  final String id;
  final String name;
  final String industry;
  final String location;
  final String imageUrl;

  Company({
    required this.id,
    required this.name,
    required this.industry,
    required this.location,
    required this.imageUrl,
  });
}
