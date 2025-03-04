import 'package:kitakyushu_shukatu/models/marker_info.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapPageViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<MarkerInfo> markers = [];
  bool isLoading = true;
  String? errorMessage;

  // 初期化済みの固定マーカー（オプション）
  final List<MarkerInfo> staticMarkers = [];

  // Firestoreからデータを取得
  Future<void> fetchMarkers() async {
    isLoading = true;
    errorMessage = null;

    try {
      // markersリストをクリア（staticMarkersは残したい場合は別途処理）
      markers = List.from(staticMarkers);

      // companiesコレクションからデータを取得
      final QuerySnapshot snapshot =
          await _firestore.collection('companies').get();

      for (var doc in snapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>;

          // 必要なデータが存在するか確認
          if (data.containsKey('location') && data.containsKey('name')) {
            final GeoPoint location = data['location'] as GeoPoint;
            final String title = data['name'] as String;

            // 説明文の組み立て
            String description = '';

            if (data.containsKey('fw_bold')) {
              description += '${data['fw_bold']}\n\n';
            }

            if (data.containsKey('field')) {
              description += '${data['field']}\n\n';
            }

            if (data.containsKey('d_inlineblock')) {
              description += '業種: ${data['d_inlineblock']}\n';
            }

            if (data.containsKey('d_inlineblock2')) {
              description += '企業規模: ${data['d_inlineblock2']}\n';
            }

            // 画像URLとウェブサイトURLを含むMarkerInfoを作成
            markers.add(
              MarkerInfo(
                position: LatLng(location.latitude, location.longitude),
                title: title,
                description: description.trim(),
                documentId: doc.id, // 後で参照できるようにドキュメントIDも保存
                imageUrl:
                    data.containsKey('imageURL')
                        ? data['imageURL'] as String
                        : null,
                websiteUrl:
                    data.containsKey('nameURL')
                        ? data['nameURL'] as String
                        : null,
              ),
            );
          }
        } catch (e) {
          print('ドキュメント ${doc.id} の処理中にエラーが発生: $e');
        }
      }

      isLoading = false;
    } catch (e) {
      isLoading = false;
      errorMessage = 'データの取得に失敗しました: $e';
      print('Firestoreからのデータ取得エラー: $e');
    }
  }

  // 特定の企業データだけを取得
  Future<MarkerInfo?> fetchCompanyDetail(String companyId) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection('companies').doc(companyId).get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;

        if (data.containsKey('location') && data.containsKey('name')) {
          final GeoPoint location = data['location'] as GeoPoint;
          final String title = data['name'] as String;

          String description = '';

          if (data.containsKey('fw_bold')) {
            description += '${data['fw_bold']}\n\n';
          }

          if (data.containsKey('field')) {
            description += '${data['field']}\n\n';
          }

          if (data.containsKey('d_inlineblock')) {
            description += '業種: ${data['d_inlineblock']}\n';
          }

          if (data.containsKey('d_inlineblock2')) {
            description += '企業規模: ${data['d_inlineblock2']}\n';
          }

          return MarkerInfo(
            position: LatLng(location.latitude, location.longitude),
            title: title,
            description: description.trim(),
            documentId: doc.id,
            imageUrl:
                data.containsKey('imageURL')
                    ? data['imageURL'] as String
                    : null,
            websiteUrl:
                data.containsKey('nameURL') ? data['nameURL'] as String : null,
          );
        }
      }

      return null;
    } catch (e) {
      print('企業詳細データの取得エラー: $e');
      return null;
    }
  }

  // ドキュメントIDを指定して、そのIDに対応するMarkerInfoを返す
  MarkerInfo? getMarkerById(String documentId) {
    try {
      return markers.firstWhere((marker) => marker.documentId == documentId);
    } catch (e) {
      return null;
    }
  }
}
