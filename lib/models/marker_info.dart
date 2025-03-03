import 'package:latlong2/latlong.dart';

class MarkerInfo {
  final LatLng position;
  final String title;
  final String description;
  final String? documentId; // Firestoreのドキュメントと紐付けるためのID
  final String? imageUrl; // 企業のロゴ画像URL
  final String? websiteUrl; // 企業のウェブサイトURL

  MarkerInfo({
    required this.position,
    required this.title,
    required this.description,
    this.documentId,
    this.imageUrl,
    this.websiteUrl,
  });
}
